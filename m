Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3ILGnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:43:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26287 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3ILGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:43:08 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-7f-5231627be174
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Heiko Schocher'" <hs@denx.de>
References: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
In-reply-to: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
Subject: [PATCH 2/3] mfd: sm501: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:43:07 +0900
Message-id: <001601ceaf83$56ead450$04c07cf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgx4pjQNLnVsKTseFP8zkmoiH8wAAAmGQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zfd3qJMMgg8VPhCx23LnPbHF54SVW
	i/tfjzJaXN41h83iycIzTBanu1kd2DzmzTrB4nHn2h4g62Sgx87vDewefVtWMXp83iQXwBbF
	ZZOSmpNZllqkb5fAlbHn1B62guNsFYtfzWJtYFzF2sXIySEhYCJxbUk/G4QtJnHh3nogm4tD
	SGAZo8SmKy1sMEXN3Z9ZIRLTGSWuzL/CDpIQEvjFKNG/pw7EZhNQk/jy5TBQnINDRMBPomEF
	O0g9s0A3o8SU9w+YIeptJY6vaAazOQXsJB5OWwl2hbCAq8S1W9cYQWwWAVWJh43zWEDm8ALV
	t16wAAnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQcgkBdYlHf3VBwiICRhLrHx6GKhGR
	2PfiHSPIORICb9klHjyYD7VKQOLb5EMsEL2yEpsOMEO8KylxcMUNlgmMErOQbJ6FZPMsJJtn
	IVmxgJFlFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZI3E7YwXjvgPUhxmSg9ROZpUST84Fx
	n1cSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRibh
	11Ojn77jS1jhc/3G4kTOtTLt5efl77j6X1A7cGpPrcLP8tBVB1d+sV5/7MDcI2ySkUlHdtU3
	212uPn1tX/Sdg3ohlgV3t/3Zv+6fm8DNleHKjA8+rHujErhi0bkWiXvrDIMPGuRxTJ3RcuXk
	qrbJgrWeO6dfnB330qrj+E6zu5J16at/JUcqsRRnJBpqMRcVJwIAHJHyz/ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd3qJMMgg9en+Cx23LnPbHF54SVW
	i/tfjzJaXN41h83iycIzTBanu1kd2DzmzTrB4nHn2h4g62Sgx87vDewefVtWMXp83iQXwBbV
	wGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SFkkJZ
	Yk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFjz6k9bAXH2SoWv5rF2sC4irWL
	kZNDQsBEorn7M5QtJnHh3nq2LkYuDiGB6YwSV+ZfYQdJCAn8YpTo31MHYrMJqEl8+XIYKM7B
	ISLgJ9Gwgh2knlmgm1FiyvsHzBD1thLHVzSD2ZwCdhIPp60EWyAs4Cpx7dY1RhCbRUBV4mHj
	PBaQObxA9a0XLEDCvAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9dkLCIgJHE
	+oeHoUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn
	525iBCeFZ1I7GFc2WBxiFOBgVOLh7ZhlECTEmlhWXJl7iFGCg1lJhDfe3DBIiDclsbIqtSg/
	vqg0J7X4EGMy0J8TmaVEk/OBCSuvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2amp
	BalFMFuYODilGhjrHr/JKnnk/OvIjF7elT0LA9fNV9wsV8Gt0SX8Z9mXnPkzOCyavWfu5T0h
	KaecN1XzUEP8zKMPt/E9PFGaVxPC0N3LcjB2y6bix3ZJtfc2tp6oTTnFeV42xcWiMKcxPaJZ
	+1Bo+If+tPDmOLnCw1f88v+b/I27X+4aN/fNiR3Hl3ke1gzL61diKc5INNRiLipOBAC23RSF
	TgMAAA==
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
 drivers/mfd/sm501.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 3799a3d..c2c8c91 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1660,7 +1660,6 @@ static int sm501_pci_probe(struct pci_dev *dev,
  err3:
 	pci_disable_device(dev);
  err2:
-	pci_set_drvdata(dev, NULL);
 	kfree(sm);
  err1:
 	return err;
@@ -1695,7 +1694,6 @@ static void sm501_pci_remove(struct pci_dev *dev)
 	release_resource(sm->regs_claim);
 	kfree(sm->regs_claim);
 
-	pci_set_drvdata(dev, NULL);
 	pci_disable_device(dev);
 }
 
-- 
1.7.10.4


