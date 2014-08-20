Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaHTJ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:29:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62423 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHTJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:29:57 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1a-53f46a93a2bb
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] MAINTAINERS: add entry for the Samsung USB2 PHY driver
Date: Wed, 20 Aug 2014 11:29:46 +0200
Message-id: <1408526986-30561-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t9jAd0pWV+CDX68YbX48foCm8WFpz1s
	Fpd3zWFzYPbo27KK0eP4je1MHp83yQUwR3HZpKTmZJalFunbJXBlrJhzg6Wgj73i5NtHjA2M
	09i6GDk5JARMJP7dO8oMYYtJXLi3HijOxSEksIhR4ubiVSwQTgeTxI5rt4EyHBxsApoSq+55
	gDSICChIbO59xgpiMwuYSXyddY0dxBYWcJeY8+gj2FAWAVWJrvVbwGxeAReJBWcuMoKMkQDq
	nTPJZgIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwX5+JrWDcWWDxSFGAQ5GJR5e
	hezPwUKsiWXFlbmHGCU4mJVEeIsSvgQL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCe
	WJKanZpakFoEk2Xi4JRqYIwpvrBO577E+i6P34ce8nk7/Eph8F3s/GUDZ++BLY4xjNFKOrtz
	931O2xYeXf+nO+NbWmldDdf9R3of08t4H234fHPmtbsy7LbZB+eXpzpn9N3MOqt9vtzTImX2
	H5aQ5gTtrSqXlmpYNIUc1wqZHM/5zqRs9zqrnwZ/Q9xOBnCFHtwr+ePpbSWW4oxEQy3mouJE
	AOWtZ/7vAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

