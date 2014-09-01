Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaIAPD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:03:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33756 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaIAPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:03:23 -0400
X-AuditID: cbfee61b-f79f86d00000144c-07-54048ab93c0e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] phy: spear1310-miphy: fix driver dependencies
Date: Mon, 01 Sep 2014 17:03:17 +0200
Message-id: <3192131.G3BCYlDRn6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd2dXSwhBqfecVlceNrDZnG26Q27
	xeVdc9gsNk79xWjRfknZgdWjb8sqRo+nP/Yyexy/sZ3J4/MmuQCWKC6blNSczLLUIn27BK6M
	RUvvsBTcYKtY17WXtYHxOmsXIyeHhICJxO6HV6BsMYkL99azgdhCAosYJRqWq0DYLUwSMx7E
	gdhsAlYSE9tXMYLYIgJaEqd3/mDuYuTiYBaYzijx8t10sEHCAnYST35sYAKxWQRUJd7v38oM
	YvMKaErMmHQbzBYV8JTYsX0lG0RcUOLH5HssIDazgLzEvv1TWSFsLYn1O48zTWDkm4WkbBaS
	sllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7KZ9I7GFc1WBxiFOBgVOLhfTCL
	OUSINbGsuDL3EKMEB7OSCG9qBkuIEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp
	2ampBalFMFkmDk6pBsbim3ParvyVjV/4jN+Q8Xvt1oszz0se3/mkl2erf2Vd8rT/Ut0Plkzn
	uWOq7utj8Sj+X8ir/1qC6eVrFwY7LDtyOLxT8+GUbWJnE/z/RBuXt1nfNrjrVmBWY9Br/llU
	duo0/YSdU83MVp3jm7Sk6yfP8paSzst3Nkw9ztfwv/rt+s07AuPNmBYrsRRnJBpqMRcVJwIA
	pN8rz0YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST SPEAR1310-MIPHY support should be available only on
ST SPEAr1310 machine.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/phy/Kconfig
===================================================================
--- a/drivers/phy/Kconfig	2014-08-22 16:54:00.465124023 +0200
+++ b/drivers/phy/Kconfig	2014-09-01 16:43:16.808730424 +0200
@@ -214,6 +214,7 @@ config PHY_QCOM_IPQ806X_SATA
 config PHY_ST_SPEAR1310_MIPHY
 	tristate "ST SPEAR1310-MIPHY driver"
 	select GENERIC_PHY
+	depends on MACH_SPEAR1310 || COMPILE_TEST
 	help
 	  Support for ST SPEAr1310 MIPHY which can be used for PCIe and SATA.
 

