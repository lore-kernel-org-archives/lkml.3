Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3KYD3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:29:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11903 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3KYD3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:29:36 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-b6-5292c41f1e7f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] misc: eeprom_93xx46: remove unnecessary spi_set_drvdata()
Date: Mon, 25 Nov 2013 12:29:35 +0900
Message-id: <002701cee98e$90423910$b0c6ab30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7pjoxg5BwYMENSRGq+2VMv0pzXYw==
Content-language: ko
x-cr-hashedpuzzle: FHGW I+VM KPWK LSmy N0a3 VfU9 XUSj cYDg cqE+ iyMo k4AC k+d5
 laLX mPMh opJu
 qKpW;4;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGcAcgBlAGcAawBoAEAAbABpAG4AdQB4AGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{AA26723B-FC07-4F18-8B2B-8149409B1461};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 25 Nov 2013 03:29:29
 GMT;WwBQAEEAVABDAEgAXQAgAG0AaQBzAGMAOgAgAGUAZQBwAHIAbwBtAF8AOQAzAHgAeAA0ADYAOgAgAHIAZQBtAG8AdgBlACAAdQBuAG4AZQBjAGUAcwBzAGEAcgB5ACAAcwBwAGkAXwBzAGUAdABfAGQAcgB2AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {AA26723B-FC07-4F18-8B2B-8149409B1461}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA135I5OCDBrOGFj8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErozVfRvY
	CzrYKq5fXMvUwNjL2sXIySEhYCJx89gVdghbTOLCvfVsXYxcHEICyxgl7nesY4YpujpzKQtE
	YhGjxMQ3W6CqfjFKzH2/kwWkik1ATeLLl8Ngo0QETCU2vp/CCGIzC6RLPDx1hQ3EFhbwkljX
	uR1sNYuAqsSZRbfANvAK2Eqcb37JBmELSvyYfI8FoldLYv3O40wQtrzE5jVvgeo5gC5Sl3j0
	VxdilZ7Eyo6vUCUiEvtevGMEuU1CYAqrxMIPn5gg6k0l7mwzhYifYpf4takd6gYBiW+TD7FA
	1MhKbDoA9bCkxMEVN1gmMErMQnLRLCQXzUJy0SwkqxcwsqxiFE0tSC4oTkovMtIrTswtLs1L
	10vOz93ECInLvh2MNw9YH2JMBlo/kVlKNDkfGNd5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgU
	JCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHR2MI96lhZzOO4h1mvg4IO5K3vMrn8wfZXQtFB
	I2FXT8bMW7wP3CNbHr0475fxYc7Tb0n6Ak2h7u1WM+YuKnepMpvK4BL/47N8xNzTLslS7Htc
	zB8cCG2NOLSZm6+i3szh9KrODEEBrjeOr7/7bFw2N3jWSptl4rXpd5NSzVm/Gd85yX745nMl
	luKMREMt5qLiRACFU5LO4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV35I5OCDGZM07H4O+kYu0Xz4vVs
	FpcXXmK1uLxrDpsDi8fvX5MYPfbPXcPu0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZq/s2sBd0sFVcv7iWqYGxl7WLkZNDQsBE4urMpSwQtpjEhXvr
	2boYuTiEBBYxSkx8swXK+cUoMff9TrAqNgE1iS9fDrOD2CICphIb309hBLGZBdIlHp66wgZi
	Cwt4Sazr3A62gUVAVeLMolvMIDavgK3E+eaXbBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zFqie
	A+gidYlHf3UhVulJrOz4ClUiIrHvxTtGkNskBKawSiz88IkJot5U4s420wmMQrOQbJiFZMMs
	JBtmIRm1gJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw1D+T2sG4ssHiEKMAB6MSD69F
	5aQgIdbEsuLK3EOMEhzMSiK8e+qAQrwpiZVVqUX58UWlOanFhxiTgQEwkVlKNDkfmJDySuIN
	jU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHR8u0x+5lqKWdEHhUE
	T6sS9Vxcf/qmr4v3NrN/W1ut+eI2XnWMt2RutEv8+v/eJfm29HdbFik5BU6eebvq7c61f+QV
	2DQFmbesTLieP3Vf1OHrt2bZ73jL9ZhdVbRh3Zv69bo5/xVXsBw91qf7UODRiqMVd9/anBbc
	x7b0X6mhvu6e8yZv15Z/VWIpzkg01GIuKk4EAEJCNXI+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/eeprom/eeprom_93xx46.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 3a015ab..78e55b5 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -378,7 +378,6 @@ static int eeprom_93xx46_remove(struct spi_device *spi)
 		device_remove_file(&spi->dev, &dev_attr_erase);
 
 	sysfs_remove_bin_file(&spi->dev.kobj, &edev->bin);
-	spi_set_drvdata(spi, NULL);
 	kfree(edev);
 	return 0;
 }
-- 
1.7.10.4


