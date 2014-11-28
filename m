Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaK1XwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:52:17 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36175 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaK1XwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:52:16 -0500
From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
X-Google-Original-From: Peter Crosthwaite <crosthwaite.peter@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, sorenb@xilinx.com, steven.wang@digilentinc.com
Subject: [PATCH V2 1/3] doc: dt: vendor-prefixes: Add Digilent Inc
Date: Sat, 29 Nov 2014 09:52:06 +1000
Message-Id: <1417218728-4139-1-git-send-email-crosthwaite.peter@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digilent is a board designer, making various Linux capabable FPGA and
processor boards. Add to the vendor list.

Signed-off-by: Peter Crosthwaite <crosthwaite.peter@gmail.com>
---
http://www.digilentinc.com
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index c177cd7..b1df0ad 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -41,6 +41,7 @@ dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
 davicom	DAVICOM Semiconductor, Inc.
 denx	Denx Software Engineering
 digi	Digi International Inc.
+digilent	Diglent, Inc.
 dlg	Dialog Semiconductor
 dlink	D-Link Corporation
 dmo	Data Modul AG
-- 
1.9.1

