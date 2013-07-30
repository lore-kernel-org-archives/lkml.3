Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab3G3ILo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:11:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58292 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3G3ILk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:11:40 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-7f-51f7753bee06
From: Jingoo Han <jg1.han@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 19/35] extcon: use dev_get_platdata()
Date: Tue, 30 Jul 2013 17:11:39 +0900
Message-id: <004401ce8cfc$6aeb8430$40c28c90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6M/Dp+DQWJh/TRTdu/cCLaEewaNA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zfV3r0u+BBhPuy1tc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+PF0ndsBWcFKk4encbUwLiI
	r4uRk0NCwERids9hFghbTOLCvfVsILaQwDJGiedH0mFqjuw4ydzFyAUUX8Qo8Wj+U1YI5xej
	xO0V81lBqtgE1CS+fDnMDmKLCOhKvLx6mxnEZhbIkZj94hZYjbCAqcTP+9OANnBwsAioSnzq
	cgIJ8wpYSpz8to8dwhaU+DH5HgtEq5bE+p3HmSBseYnNa94yQxykILHj7GtGiFV6Ep/WroWq
	F5HY9+IdI8htEgKL2CVWTfwO1sAiICDxbfIhFpC9EgKyEpsOQM2RlDi44gbLBEaxWUhWz0Ky
	ehaS1bOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIySiencw3j5gfYgxGWj9RGYp
	0eR8YETmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoHRNDDDOYPv0e6nd5iUZrUePjrlY8CvWhnDakepvV85btrfWcRz3Shzm8jutqfibZd9L7O/
	2T1T2fT7m+CfzpenNT03NtHZEHyRde2cC/d/LlubkLJwcmLHeaF/JVxzd1/1iY5IDDl2Lflv
	/aEdfMVFLI5H6ionppRFufTvaw60uF3Zsr+i1u6AEktxRqKhFnNRcSIA3p96vb4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgK516fdAg1WnpC2uf3nOanF54SUg
	sWsOm8XtxhVsDiwefVtWMXp83iQXwBTVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA7RJSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYx5jxYuk7toKzAhUnj05jamBcxNfFyMkhIWAicWTHSWYIW0ziwr31bF2MXBxCAosYJR7N
	f8oK4fxilLi9Yj4rSBWbgJrEly+H2UFsEQFdiZdXb4N1MwvkSMx+cQusRljAVOLn/WlAkzg4
	WARUJT51OYGEeQUsJU5+28cOYQtK/Jh8jwWiVUti/c7jTBC2vMTmNW+hDlKQ2HH2NSPEKj2J
	T2vXQtWLSOx78Y5xAqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECI7YZ1I7GFc2WBxiFOBgVOLh3VDwLVCINbGsuDL3EKMEB7OSCC/LDaAQb0piZVVqUX58
	UWlOavEhxmSgRycyS4km5wOTSV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1ML
	UotgtjBxcEo1MJZofdFOZDtz/nirTcVZhmmLKnvX/q05EZ/rt2jZ9k3vUvvPC1Qs4K7mYLtc
	xTeho/r9kcCNhdsbWr76ioVOeLR8ls6UTybn7kevq+bu+39gwruyy/0t1rtnajv/fP3bU3bu
	xPf7f07zYF289lEX68uPIll54pLbNRylS3smPj3BWf61syc8aLoSS3FGoqEWc1FxIgCmHEhX
	HAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |    2 +-
 drivers/extcon/extcon-gpio.c     |    2 +-
 drivers/extcon/extcon-palmas.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index d0233cd..91babc8 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -94,7 +94,7 @@ static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
 static int adc_jack_probe(struct platform_device *pdev)
 {
 	struct adc_jack_data *data;
-	struct adc_jack_pdata *pdata = pdev->dev.platform_data;
+	struct adc_jack_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int i, err = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 02bec32..c752a47 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -78,7 +78,7 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
-	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_extcon_data *extcon_data;
 	int ret = 0;
 
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index b752a0a..dd3ea74 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -134,7 +134,7 @@ static void palmas_enable_irq(struct palmas_usb *palmas_usb)
 static int palmas_usb_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
-	struct palmas_usb_platform_data	*pdata = pdev->dev.platform_data;
+	struct palmas_usb_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *node = pdev->dev.of_node;
 	struct palmas_usb *palmas_usb;
 	int status;
-- 
1.7.10.4


