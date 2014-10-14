Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaJNIEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:04:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35071 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbaJNIDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:03:13 -0400
X-AuditID: cbfee68f-f791c6d000004834-d4-543cd8bff47a
From: Thomas Abraham <thomas.ab@samsung.com>
To: lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mfd: sec: add S2MPS15 PMIC support
Date: Tue, 14 Oct 2014 13:44:26 +0530
Message-id: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWyRsSkTnf/DZsQg/P/eCwOzH7IatG74Cqb
	xf2vRxktLu+aw+bA4nHn2h42j/MzFjJ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aLDY2M
	BS/ZKj7OvMnUwLiYtYuRk0NCwETizNzHzBC2mMSFe+vZuhi5OIQEljJKfO78zd7FyAFW9KAl
	A6RGSGA6o8T9XaYQNW1MEpMurQMbxCagI3HjzW9GEFtEwFZi2mUIm1nAXOL/jD4WEFsYyP71
	8Q0TyEwWAVWJX3cUQMK8Ai4SJ+buZoK4QUliQ+9RJpD5EgL32SSWXLkMNp9FQEDi2+RDLBD3
	yEpsOgB1s6TEwRU3WCYwCi5gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERiKp/8969/B
	ePeA9SFGAQ5GJR7egkibECHWxLLiytxDjKZAGyYyS4km5wMDPq8k3tDYzMjC1MTU2Mjc0kxJ
	nHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyR0784rn1puz7R1ILxWenuT9UKaadu
	ul7MVvOa0/+3TTp9ziqnDoGYlkWsT8K3/rBpfCFx0OW09a27JbtbHKernpsyV8JUMfPnxDLF
	jrbwl5M0g+xf8E5eWXYpPkIxtaGc5cvaylexs8+xer8JbJBR2f0uotjS3//Zo7ZWPdMoD438
	KSu3qCuxFGckGmoxFxUnAgAsOZcWQAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQd39N2xCDD5+ZrE4MPshq0Xvgqts
	Fve/HmW0uLxrDpsDi8eda3vYPM7PWMjo0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZLzY0Mha8ZKv4OPMmUwPjYtYuRg4OCQETiQctGV2MnECmmMSF
	e+vZQGwhgemMEvd3mXYxcgHZbUwSky6tYwVJsAnoSNx485sRxBYRsJWYdhnCZhYwl/g/o48F
	xBYGsn99fMMEMp9FQFXi1x0FkDCvgIvEibm7mSB2KUls6D3KNIGRewEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4EB/Jr2DcVWDxSFGAQ5GJR7egkibECHWxLLiytxDjBIczEoivMYL
	gUK8KYmVValF+fFFpTmpxYcYTYGWT2SWEk3OB0ZhXkm8obGJuamxqaWJhYmZpZI478FW60Ah
	gfTEktTs1NSC1CKYPiYOTqkGxtD1sxnyl23vrJ38aVm0xMyOmANLH1h80rDrWHS9Wfc316eP
	/H487cnzrnBsTytdfXfydu/0K9fkN9YoOl95f+15qGC97JJtC7MnqmtwfHpm9KO69sj+9l2L
	89RKeFK+zpkqrmk1bWJL7acucZV5Abxyez7b7IlSmnvGsX1+dU9aZ0Jr/azMU0osxRmJhlrM
	RcWJANTfgGSKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung's S2MPS15 PMIC is targetted to be used with Samsung's Exynos7 SoC.
The S2MPS15 PMIC is similar in functionality to S2MPS11/14 PMIC. It contains
27 LDO and 10 Buck regulators, RTC, three 32.768 KHz clock outputs and allows
programming these blocks via a I2C interface. This patch series adds initial
support for LDO/Buck regulators of S2MPS15 PMIC.

Thomas Abraham (2):
  dt-bindings: mfd: s2mps11: add documentation for s2mps15 PMIC
  mfd: sec: Add support for S2MPS15 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   11 +-
 drivers/mfd/sec-core.c                            |   26 ++++
 include/linux/mfd/samsung/core.h                  |    1 +
 include/linux/mfd/samsung/s2mps15.h               |  161 +++++++++++++++++++++
 4 files changed, 196 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps15.h

