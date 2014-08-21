Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaHUJdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:33:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14590 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaHUJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:33:52 -0400
X-AuditID: cbfee61b-f79f86d00000144c-6a-53f5bcfdc6e9
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v2] MAINTAINERS: add entry for the Samsung USB2 PHY driver
Date: Thu, 21 Aug 2014 11:33:37 +0200
Message-id: <1408613617-20409-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t9jAd2/e74GG0xp4bX48foCm8WFpz1s
	Fpd3zWFzYPbo27KK0eP4je1MHp83yQUwR3HZpKTmZJalFunbJXBlPH/2lLXgBHvF4s+fGRsY
	j7B1MXJySAiYSBzp380MYYtJXLi3HijOxSEksIhR4vaa80wQTgeTxKRjjUBVHBxsApoSq+55
	gDSICChIbO59xgpiMwuYSXyddY0dxBYW8JI4ffE82AIWAVWJ/U1/wVp5BVwkuk8Ug5gSQK1z
	JtlMYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyPYy8+kdzCuarA4xCjAwajEwyuh
	9jVYiDWxrLgy9xCjBAezkghv5m6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp
	2ampBalFMFkmDk6pBkZLsdP+4UsiZ/z58Nwyfa6e08Rj6q0XN1TNy+X2O+ajqZZ6vcu6ef6B
	Ci051pJ5p18yzlpVpmWUnXZrxZfph9edrJgRWqZdveWLdl9gwC6pc4/X2bn42f5c/djwguju
	kufxPLPqtkb+NuDftPvzYkvt823pZScEGVQaQ90/1O9ILTB3zP4ZV6bEUpyRaKjFXFScCADm
	bEPh7gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry for the Samsung USB2 PHY driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05dc39d..548602f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7873,6 +7873,19 @@ S:	Supported
 L:	netdev@vger.kernel.org
 F:	drivers/net/ethernet/samsung/sxgbe/
 
+SAMSUNG USB2 PHY DRIVER
+M:	Kamil Debski <k.debski@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/phy/samsung-phy.txt
+F:	Documentation/phy/samsung-usb2.txt
+F:	drivers/phy/phy-exynos4210-usb2.c
+F:	drivers/phy/phy-exynos4x12-usb2.c
+F:	drivers/phy/phy-exynos5250-usb2.c
+F:	drivers/phy/phy-s5pv210-usb2.c
+F:	drivers/phy/phy-samsung-usb2.c
+F:	drivers/phy/phy-samsung-usb2.h
+
 SERIAL DRIVERS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
-- 
1.7.9.5

