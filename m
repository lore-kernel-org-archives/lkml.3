Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3EGFeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:34:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47923 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3EGFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:34:16 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-8a-51889257ff92
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        "'Hartley Sweeten'" <hartleys@visionengravers.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/2] misc: ep93xx_pwm: remove unnecessary platform_set_drvdata()
Date: Tue, 07 May 2013 14:34:15 +0900
Message-id: <003801ce4ae4$830d02f0$892708d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5K5G+eyewmerWGShaB6B8jbdVETA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI93wSR2BBhenyFn8nXSM3aJ58Xo2
	i5dnd7NYXF54idXi8q45bA6sHr9/TWL02D93DbtH35ZVjB6fN8l5PD/zgy2ANYrLJiU1J7Ms
	tUjfLoEr48LVt+wF+9krbj5/z9jAuJmti5GTQ0LARGLzh01QtpjEhXvrgWwuDiGBZYwSm5c9
	YYcp+r2vjwkisYhRouPHdlYI5xejxNX/vWDtbAJqEl++HAbrEBGIkGhpbWYEsZkFqiT+PPgM
	ZgsLBEhs7XsPVs8ioCrxYtZdFhCbV8BS4vi3X6wQtqDEj8n3WCB6tSTW7zzOBGHLS2xe85YZ
	4iIFiR1nXzNC7NKT6J96FGqXiMS+F+8YQY6TENjHLrH0YiPUMgGJb5MPAQ3lAErISmw6ADVH
	UuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJDo
	69vBePOA9SHGZKD1E5mlRJPzgdGbVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbG6rt6T9tnd4m9ebjxF/sav0sck2qlNdYHpv27avz90aT2jf9b
	8uuv7VY/+fhdsEJzdtKRti+LP9qf/hj6V2G1kNnb80JNq8TezfxlqOt48JL5ucv6l2wu/VYP
	+/bZwWNjx1fxEx5ziorYQ+TLp2/t1Ol7dDFp2Tqxa8s0Ew5NljON2bi8vp1bQ4mlOCPRUIu5
	qDgRAOWoUtnUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3wSR2BBpN2S1n8nXSM3aJ58Xo2
	i5dnd7NYXF54idXi8q45bA6sHr9/TWL02D93DbtH35ZVjB6fN8l5PD/zgy2ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePC1bfsBfvZK24+f8/YwLiZrYuRk0NCwETi
	974+JghbTOLCvfVAcS4OIYFFjBIdP7azQji/GCWu/u8F62ATUJP48uUwO4gtIhAh0dLazAhi
	MwtUSfx58BnMFhYIkNja9x6snkVAVeLFrLssIDavgKXE8W+/WCFsQYkfk++xQPRqSazfeZwJ
	wpaX2LzmLTPERQoSO86+ZoTYpSfRP/Uo1C4RiX0v3jFOYBSYhWTULCSjZiEZNQtJywJGllWM
	oqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH9THoH46oGi0OMAhyMSjy8CqfaA4VYE8uKK3MP
	MUpwMCuJ8EprdwQK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w7eSVxBsam5gZWRqZWRiZ
	mJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OGmyk3D3tOPhHWIOz2yrhnohETk5c2
	a1b8Beb7jzj8ZEy3LA9j2cRi9fki16wwLkX+/b9DnjAlX5r3fopglNVHfUtWXd7iOzdM9D/4
	Rr42WJunZrjQ6MQcjifHX1fcff7ilMvkg5P+ukWbd+vvbrd5nqje2809jXONd3Og/e1axtil
	Z+y2P1BiKc5INNRiLipOBACmvMxBMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/ep93xx_pwm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 96787ec..9ba93f0 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -347,7 +347,6 @@ static int __exit ep93xx_pwm_remove(struct platform_device *pdev)
 	ep93xx_pwm_disable(pwm);
 	clk_disable(pwm->clk);
 	clk_put(pwm->clk);
-	platform_set_drvdata(pdev, NULL);
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
 	iounmap(pwm->mmio_base);
 	release_mem_region(res->start, resource_size(res));
-- 
1.7.2.5


