Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab3BTJbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:31:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22536 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3BTJa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:30:57 -0500
X-AuditID: cbfee68f-b7f656d000000d78-db-512497d0e653
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 7/9] mfd: ezx-pcap: use devm_*() functions
Date: Wed, 20 Feb 2013 18:30:55 +0900
Message-id: <001501ce0f4c$fbf93ef0$f3ebbcd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAAGy0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY90L01UCDU6v4LG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ8+6dYixYI1JxceJF9gbGXQJdjJwcEgImEmeXPmCBsMUkLtxb
	z9bFyMUhJLCMUWLFy0OsMEVdW58wQiSmM0q8vj6JHcKZzSSxa/spRpAqNgE1iS9fDrOD2CIC
	WhLdx84DjeLgYBZwkTg6TQQkLCRgK/GoaysziM0pYCfRcm0emC0MFG/rmcYMUs4ioCqxcoEp
	SJgXKPz2/hV2CFtQ4sfke2CHMgNNX7/zOBOELS+xec1bsFYJAXWJR391IQ4wkrg25R0zRImI
	xL4X78DOlxBYxC6x/9pxsJksAgIS3yYfYoHolZXYdIAZ4l1JiYMrbrBMYJSYhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQuKqfwfj3QPWhxiTgdZPZJYSTc4H
	xmVeSbyhsbGJmYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDO
	Nqt2P77+hDCfTdJc++i51gcVlD6lzO/wD7/W8cP942zPjxE7c4853357kPWzYPL/pMlnvZkX
	trzOkGvw/nukfUHcNoPXu78ze7yaGcrXpvRcpDTuc6M1e07uzEubJ6737DcU8n3DO4f/Ufnf
	au5LOcnnJ+9ZIcGattOOJTqj9VleoL3+zG1KLMUZiYZazEXFiQC9knqZwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO6F6SqBBs//sFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjHn3TjEWrBGpuDjxInsD
	4y6BLkZODgkBE4murU8YIWwxiQv31rN1MXJxCAlMZ5R4fX0SO4Qzm0li1/ZTYFVsAmoSX74c
	ZgexRQS0JLqPnQfq4OBgFnCRODpNBCQsJGAr8ahrKzOIzSlgJ9FybR6YLQwUb+uZxgxSziKg
	KrFygSlImBco/Pb+FXYIW1Dix+R7LCA2M9D09TuPM0HY8hKb17wFa5UQUJd49FcX4gAjiWtT
	3jFDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjtpnUjsYVzZYHGIU4GBU4uHVmK8cKMSaWFZcmXuIUYKDWUmE92eHSqAQb0piZVVqUX58
	UWlOavEhxmSgPycyS4km5wMTSl5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YW
	pBbBbGHi4JRqYBS5YCx/89eL5RPf/rm2Sfjo7++Mf2NUdsa3yfzT+1Wkl3JwqtimN8amJeGX
	JrD/+T47Le7TAxnPNb8CY6S2zX09PyRfZ3nJj6CmlWH/J2zLqTz/9VqCldxuide5Oya/8AzW
	jvE18fz/2tzttA1HXLq95rRZc0t3PFte479a9bfe0oJ8VaOO3YZKLMUZiYZazEXFiQATg8Xi
	HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Use devm_free_irq()

 drivers/mfd/ezx-pcap.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index b7a61f0..f83cc3d 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -403,7 +403,7 @@ static int ezx_pcap_remove(struct spi_device *spi)
 	/* cleanup ADC */
 	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
 				PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
-	free_irq(adc_irq, pcap);
+	devm_free_irq(&spi->dev, adc_irq, pcap);
 	mutex_lock(&pcap->adc_mutex);
 	for (i = 0; i < PCAP_ADC_MAXQ; i++)
 		kfree(pcap->adc_queue[i]);
@@ -415,8 +415,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
 
 	destroy_workqueue(pcap->workqueue);
 
-	kfree(pcap);
-
 	return 0;
 }
 
@@ -431,7 +429,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	if (!pdata)
 		goto ret;
 
-	pcap = kzalloc(sizeof(*pcap), GFP_KERNEL);
+	pcap = devm_kzalloc(&spi->dev, sizeof(*pcap), GFP_KERNEL);
 	if (!pcap) {
 		ret = -ENOMEM;
 		goto ret;
@@ -448,7 +446,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	spi->mode = SPI_MODE_0 | (pdata->config & PCAP_CS_AH ? SPI_CS_HIGH : 0);
 	ret = spi_setup(spi);
 	if (ret)
-		goto free_pcap;
+		goto ret;
 
 	pcap->spi = spi;
 
@@ -458,7 +456,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	if (!pcap->workqueue) {
 		ret = -ENOMEM;
 		dev_err(&spi->dev, "can't create pcap thread\n");
-		goto free_pcap;
+		goto ret;
 	}
 
 	/* redirect interrupts to AP, except adcdone2 */
@@ -491,7 +489,8 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
 					PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
 
-	ret = request_irq(adc_irq, pcap_adc_irq, 0, "ADC", pcap);
+	ret = devm_request_irq(&spi->dev, adc_irq, pcap_adc_irq, 0, "ADC",
+				pcap);
 	if (ret)
 		goto free_irqchip;
 
@@ -511,14 +510,12 @@ static int ezx_pcap_probe(struct spi_device *spi)
 remove_subdevs:
 	device_for_each_child(&spi->dev, NULL, pcap_remove_subdev);
 /* free_adc: */
-	free_irq(adc_irq, pcap);
+	devm_free_irq(&spi->dev, adc_irq, pcap);
 free_irqchip:
 	for (i = pcap->irq_base; i < (pcap->irq_base + PCAP_NIRQS); i++)
 		irq_set_chip_and_handler(i, NULL, NULL);
 /* destroy_workqueue: */
 	destroy_workqueue(pcap->workqueue);
-free_pcap:
-	kfree(pcap);
 ret:
 	return ret;
 }
-- 
1.7.2.5


