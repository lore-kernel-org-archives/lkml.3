Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaLAA0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:26:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61740 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLAAZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:25:58 -0500
From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
X-Google-Original-From: Peter Crosthwaite <crosthwaite.peter@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: michals@xilinx.com, sorenb@xilinx.com, steven.wang@digilentinc.com
Subject: [PATCH v3 1/3] doc: dt: vendor-prefixes: Add Digilent Inc
Date: Mon,  1 Dec 2014 10:25:48 +1000
Message-Id: <1417393550-6674-1-git-send-email-crosthwaite.peter@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digilent is a board designer, making various Linux capabable FPGA and
processor boards. Add to the vendor list.

Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
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

