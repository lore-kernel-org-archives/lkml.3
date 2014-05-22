Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaEVQ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:57:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34998 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaEVQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:48:14 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...)
Subject: [PATCH net-next v2 1/9] Documentation: devicetree: add old and deprecated 'fixed-link'
Date: Thu, 22 May 2014 09:47:43 -0700
Message-Id: <1400777271-32199-2-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
References: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the fixed-link Device Tree binding documentation to contain
information about the old and deprecated 5-digit 'fixed-link' property.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
- fixed typos and spelling mistakes as spotted by Sergei

 Documentation/devicetree/bindings/net/fixed-link.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fixed-link.txt b/Documentation/devicetree/bindings/net/fixed-link.txt
index e956de1be935..82bf7e0f47b6 100644
--- a/Documentation/devicetree/bindings/net/fixed-link.txt
+++ b/Documentation/devicetree/bindings/net/fixed-link.txt
@@ -18,6 +18,18 @@ properties:
 * 'asym-pause' (boolean, optional), to indicate that asym_pause should
   be enabled.
 
+Old, deprecated 'fixed-link' binding:
+
+* A 'fixed-link' property in the Ethernet MAC node, with 5 cells, of the
+  form <a b c d e> with the following accepted values:
+  - a: emulated PHY ID, choose any but but unique to the all specified
+    fixed-links, from 0 to 31
+  - b: duplex configuration: 0 for half duplex, 1 for full duplex
+  - c: link speed in Mbits/sec, accepted values are: 10, 100 and 1000
+  - d: pause configuration: 0 for no pause, 1 for pause
+  - e: asymmetric pause configuration: 0 for no asymmetric pause, 1 for
+    asymmetric pause
+
 Example:
 
 ethernet@0 {
-- 
1.9.1

