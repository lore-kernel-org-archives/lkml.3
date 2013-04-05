Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765841Ab3DEBAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:00:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8826 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765824Ab3DEBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:00:28 -0400
X-AuditID: cbfee68e-b7f946d000001e37-26-515e222af6a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Stefano Babic'" <sbabic@denx.de>,
        "'Anatolij Gustschin'" <agust@denx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004101ce3198$92513a70$b6f3af50$%han@samsung.com>
In-reply-to: <004101ce3198$92513a70$b6f3af50$%han@samsung.com>
Subject: [PATCH 2/2] backlight: ili922x: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:00:25 +0900
Message-id: <004201ce3198$f531ba70$df952f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xmJH+n27OKOYuSb6yuIIk4ZufNAAAAf4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zQ10tpbhAg6aHyhbr7y5htJizfg2b
	xeWFl1gtLu+aw2axe9dTVov2Uz4ObB7zZp1g8Tgx4zeLx575P1g9+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK2PxjT0sBVvYKm78fMzUwLiGtYuRk0NCwETiy6xz7BC2mMSFe+vZuhi5OIQE
	ljFKbFu+hRmmaP3NF1CJ6YwS+5s+MUE4vxgldnZ9A6tiE1CT+PLlMNAoDg4RAX2JthYNkBpm
	gf2MEnt/H2ADqRESsJV4tWcC2GpOATuJqUcfsYDUCwPZbyZkg4RZBFQldk6YwQhi8wKVLz3/
	lgnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCBjJATUJR791QUJiwgYSRz+2sIIUSIise/F
	O0aQcyQEXrJLfOnoYobYJSDxbfIhFoheWYlNB6D+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxY
	wMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkYvt2MN48YH2IMRlo/URmKdHkfGDE55XE
	GxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkUHhxxzH
	m9+YtI3WcZQUfb40M9Y4ed2VlYv2bDDfuGnKji+8jckRqddC+mcXOBo9v7PqfQt37DSmf5lO
	udGncp1P7b+isNgn74ix7J848ytGuQ6z1eaFsrvHFTc4f9VlfVdz82TmkY7rWdVV11h5V6ma
	3mi+PKl/UmuKI888KdNTm1dLnNSdqMRSnJFoqMVcVJwIABE33XLuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQV0tpbhAg62t8hbr7y5htJizfg2b
	xeWFl1gtLu+aw2axe9dTVov2Uz4ObB7zZp1g8Tgx4zeLx575P1g9+rasYvT4vEkugDWqgdEm
	IzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gCJYWyxJxS
	oFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG4ht7WAq2sFXc+PmYqYFxDWsXIyeH
	hICJxPqbL9ggbDGJC/fWA9lcHEIC0xkl9jd9YoJwfjFK7Oz6xgxSxSagJvHly2H2LkYODhEB
	fYm2Fg2QGmaB/YwSe38fAJskJGAr8WrPBLANnAJ2ElOPPmIBqRcGst9MyAYJswioSuycMIMR
	xOYFKl96/i0ThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBxkgIqEs8+qsLEhYRMJI4/LWF
	EaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnA6eCa1g3Flg8UhRgEORiUe3oy+2EAh1sSy4srcQ4wSHMxKIrw7+eIChXhTEiurUovy44tK
	c1KLDzEmAz06kVlKNDkfmKrySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBa
	BLOFiYNTqoGRTal0r0By/uMfLLGTdhX3HXe1bXk5RTjyr0+Oz6aPF3KU9m6U/CJWblLxLHb1
	XebMPTO3qBn6pF/v5b1xKvDJ5sWzzu/X8t9kJ/tS5kZ8hTjvVhuVx3KeZ2ybZA/Lrk1eNsfA
	lJ3RaG7Htr3PDzW6SCYwX3U0dlgnoy7Mla3dn9vAFM2y8pISS3FGoqEWc1FxIgD1LR86SwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili922x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index 8b8465e..d9f65c2 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -488,7 +488,7 @@ static int ili922x_probe(struct spi_device *spi)
 	}
 
 	ili->spi = spi;
-	dev_set_drvdata(&spi->dev, ili);
+	spi_set_drvdata(spi, ili);
 
 	/* check if the device is connected */
 	ret = ili922x_read(spi, REG_DRIVER_CODE_READ, &reg);
-- 
1.7.2.5


