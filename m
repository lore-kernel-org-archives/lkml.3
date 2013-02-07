Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab3BGO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:26:45 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:39792 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654Ab3BGO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:26:42 -0500
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <Vineet.Gupta1@synopsys.com>, <arnd@arndb.de>,
        <monstr@monstr.eu>, Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: [PATCH] xilinx: Documentation/devicetree - add description for "port-number" property
Date: Thu, 7 Feb 2013 18:26:15 +0400
Message-ID: <1360247175-18399-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.121.8.160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property is used by xsysace device (drivers/block/xsysace.c).

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
---
 Documentation/devicetree/bindings/xilinx.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/xilinx.txt b/Documentation/devicetree/bindings/xilinx.txt
index 299d0923..ad247b9 100644
--- a/Documentation/devicetree/bindings/xilinx.txt
+++ b/Documentation/devicetree/bindings/xilinx.txt
@@ -253,6 +253,7 @@
 
       Optional properties:
        - 8-bit (empty) : Set this property for SystemACE in 8 bit mode
+       - port-number = <port_number> : Set port number for particular device 
 
       iii) Xilinx EMAC and Xilinx TEMAC
 
-- 
1.7.10.4

