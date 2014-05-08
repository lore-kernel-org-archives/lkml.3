Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaEHDtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:49:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63946 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaEHDtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:49:05 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-65-536afeb02c91
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 4/4] drivers: clk: use COMMON_CLK_SAMSUNG for Samsung clock
 support
Date: Thu, 08 May 2014 13:07:11 +0900
Message-id: <1399522031-3394-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zI90N/7KCDWY94LToXXCVzWLT42us
	Fpd3zWGzmHF+H5PF0wkX2SwWbf3CbrF+xmsWB3aPO9f2sHlsXlLv0bdlFaPH501yASxRXDYp
	qTmZZalF+nYJXBmbjyxlLljLXrH/+1+2BsZFbF2MHBwSAiYSDVdzuhg5gUwxiQv31gOFuTiE
	BJYxStx8Op8FImEi8bn/EDtEYjqjxIr9d1ggnDYmifltJ5lBqtgEdCWevJ8LZosIZEtcabzP
	DFLELNDAKLHs3wlWkISwQITEkqu/2UBsFgFViY4z/5hAbF4Bd4nVbUfZIU5SkJgzyQbE5BTw
	kJh80hqkQgio4t3xzWwQB01ml/i2ThliioDEt8mHWCA6ZSU2HWCGKJGUOLjiBssERuEFjAyr
	GEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MULCun8H490D1ocYk4HGTWSWEk3OB8ZFXkm8obGZ
	kYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgNEyerTVfZvfu
	DSwWLZdvZt234tx12/qW0Z/zfVvUgtfwbHNl+7Pld/uJy63Tdsclaf2fvO79xntHhFL0X+uV
	XJvKr/9S+KjN3qpddSkhiU9WF7gu51PbeVjb5+33gzo7+OcknNmQNH9v5h1PyU3r1Zyion0T
	ZB8c1KiNnnrBN+fjGmm2ptybXEosxRmJhlrMRcWJADu12NWBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQd0N/7KCDQ48ZbXoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF0wkX2SwWbf3CbrF+xmsWB3aPO9f2sHlsXlLv0bdlFaPH501yASxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzNh9Zylywlr1i//e/bA2Mi9i6GDk5
	JARMJD73H2KHsMUkLtxbDxTn4hASmM4osWL/HRYIp41JYn7bSWaQKjYBXYkn7+eC2SIC2RJX
	Gu8zgxQxCzQwSiz7d4IVJCEsECGx5OpvsBUsAqoSHWf+MYHYvALuEqvbjgKt4wBapyAxZ5IN
	iMkp4CEx+aQ1SIUQUMW745vZJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHDnP
	pHYwrmywOMQowMGoxMOb4ZwVLMSaWFZcmXuIUYKDWUmE138yUIg3JbGyKrUoP76oNCe1+BBj
	MtBNE5mlRJPzgVGdVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2ME69Htz/SElr3LyJyd/ILb/Guzx38s37YMeVLvzvaHsqYybeJ9VnpH6YQ059L5s6YOWvS
	HuFDkQp1fwodYi8wrt7FuGvZrG6BGH7GyMQfNdsOf7vn+DOZU22d7POek4LJexoOvNjguVzZ
	szIscs7RuXdnHrv0sJ1ZxifaifGLR+inq1wrIhzZlViKMxINtZiLihMB/qJz7OACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces PLAT_SAMSUNG with COMMON_CLK_SAMSUNG for Samsung
common clock support. Any Samsung SoC want to use Samsung common clock
infrastructure can simply select COMMON_CLK_SAMSUNG.

CC: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5f8a287..17d7f13 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_PLAT_ORION)		+= mvebu/
 obj-$(CONFIG_ARCH_MXS)			+= mxs/
 obj-$(CONFIG_COMMON_CLK_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
-obj-$(CONFIG_PLAT_SAMSUNG)		+= samsung/
+obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
 obj-$(CONFIG_ARCH_SIRF)			+= sirf/
 obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
-- 
1.7.10.4

