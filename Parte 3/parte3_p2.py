import cv2
import numpy as np
import matplotlib.pyplot as plt
import time


def hough(B, m, n, p):
    P = np.zeros((m, n, p))
    (x, y) = np.where(B > 0.5)
    for i in range(len(x)):
        for a in range(1, m+1):
            for b in range(1, n+1):
                r = np.sqrt((x[i] - a)**2 + (y[i] - b)**2)
                if r != 0:
                    P[a-1, b-1, round(r)-1] += 1/(2*np.pi*r)
        print(f"{i*100/len(x)}%")
    return P

# Parametros
num_imagen = 3
T = 0.4

A = cv2.imread(f"imagen{num_imagen}.png", cv2.IMREAD_GRAYSCALE)
(m, n) = np.shape(A)

smoothed_image = cv2.GaussianBlur(A, (3,3), 0)
edges = cv2.Canny(image=smoothed_image, threshold1=200, threshold2=250, apertureSize=3)

print("Inicia Hough")
start = time.time()
P = hough(edges, m, n, round(np.sqrt(m**2 + n**2)))

end = time.time()
print("Tiempo:")
print(end - start, "segundos")
print("Termina Hough")

(x, y, r) = np.where(P > T)
result_image = np.zeros((m, n, 3), dtype=np.uint8)

for i in range(len(x)):
    center = (y[i], x[i])
    radio = r[i]
    result_image = cv2.circle(result_image, center, radio, (255,255,255), 1)


fig, (ax1, ax2, ax3, ax4) = plt.subplots(1, 4)
ax1.imshow(A, cmap='gray')
ax2.imshow(smoothed_image, cmap='gray')
ax3.imshow(edges, cmap='gray')
ax4.imshow(result_image, cmap='gray')
plt.show()

cv2.imwrite(f"resultado_imagen_{num_imagen}_T_{T}.png", result_image)
