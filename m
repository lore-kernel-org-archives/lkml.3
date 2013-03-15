Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3COQ0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:26:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12845 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3COQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:26:02 -0400
X-AuditID: cbfee68e-b7f946d000001e37-17-51434b98e70c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de
Subject: [PATCH 1/2] iio: adc: Kconfig: exynos_adc depends on CONFIG_OF
Date: Fri, 15 Mar 2013 21:53:40 +0530
Message-id: <1363364620-23597-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkWneGt3OgQcc+NYuzyw6yWTQvXs9m
	sWTyfFaLeUfesVhc3jWHzWLG+X1MFou2/Wd2YPeY3XCRxWPnrLvsHvvnrmH3WPLmEKvH501y
	AaxRXDYpqTmZZalF+nYJXBk/765lLrjGXvH1ww/WBsb1bF2MnBwSAiYSuy8+g7LFJC7cA4lz
	cQgJLGWU+H9gJ1zR5kmPWSES0xkl7mzfzgjh9DBJ/Ft9hwmkik3ATOLgotXsXYwcHCICshIz
	u/VAapgFljNKLLn2gR2kRljAXeLdkwtg9SwCqhLvup6DbeAVcJW4v/suE0ivhICCxJxJNiC9
	EgLN7BIXvj5lhagXkPg2+RALRI2sxKYDzBDHSUocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrF
	ibnFpXnpesn5uZsYgWF7+t+zvh2MNw9YH2JMBho3kVlKNDkfGPZ5JfGGxmZGFqYmpsZG5pZm
	pAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcWD/Vo6F8bkPBWcF1ma837X/8
	0XVHVLcLm993qaNNnMK6bt4z6gw/Jqzyvv1AaZ55YsJD1mVeG3YyXXjt4rBdTdjMxO9IaKi7
	xMvHJ2ew3T25uWhz1Y8OV/0Gj+KPJz7KMHzYt2FJo8sk4dwry59IZcmcvCC3X0t0fn5n37vK
	Y9qXzs9Plw5QYinOSDTUYi4qTgQABuw7AXECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQd0Z3s6BBlPb5SzOLjvIZtG8eD2b
	xZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/Zgd1jdsNFFo+ds+6ye+yfu4bdY8mbQ6wenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+Hl3LXPBNfaKrx9+sDYw
	rmfrYuTkkBAwkdg86TErhC0mceEeSJyLQ0hgOqPEne3bGSGcHiaJf6vvMIFUsQmYSRxctJq9
	i5GDQ0RAVmJmtx5IDbPAckaJJdc+sIPUCAu4S7x7cgGsnkVAVeJd13OwbbwCrhL3d99lAumV
	EFCQmDPJZgIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwVHxTGoH48oGi0OMAhyM
	Sjy8CjbOgUKsiWXFlbmHGCU4mJVEeN/pA4V4UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqcD4zY
	vJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgLPG4Kphy3zVr
	v4jjoyCRd4JPXvkxht1MjqowvnD6XJPP0jdM3zbbTA07NYFH9aRj2taj2RwzOBP/HspLdZ8Q
	ff2J3PoX2h/82detmrd39QSmg1bLD3q8n5NnHuBY/UkhtopDS+7S+kWVYQaCovGPJPj+KYqa
	nty+kONKQ/JxoacNW2sTY49fUWIpzkg01GIuKk4EABOA7pjOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the exynos_adc driver only supports device tree registration.
Making driver depend on CONFIG_OF solves possible errors during probe.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
Discussion thread for this patch can be found at
http://www.gossamer-threads.com/lists/linux/kernel/1693284?page=last

 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index a40d3c2..9c45c0f 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -105,6 +105,7 @@ config AT91_ADC
 
 config EXYNOS_ADC
 	bool "Exynos ADC driver support"
+	depends on OF
 	help
 	  Core support for the ADC block found in the Samsung EXYNOS series
 	  of SoCs for drivers such as the touchscreen and hwmon to use to share
-- 
1.7.9.5

