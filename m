Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaEUVjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:39:09 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43628 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaEUVjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:39:05 -0400
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
Subject: [PATCH RESEND net-next 1/9] Documentation: devicetree: add old and deprecated 'fixed-link'
Date: Wed, 21 May 2014 14:38:43 -0700
Message-Id: <1400708331-18088-2-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com>
References: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the fixed-link Device Tree binding documentation to contain
information about the old and deprecated 5-digit 'fixed-link' property.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/fixed-link.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fixed-link.txt b/Documentation/devicetree/bindings/net/fixed-link.txt
index e956de1be935..34a991eb213f 100644
--- a/Documentation/devicetree/bindings/net/fixed-link.txt
+++ b/Documentation/devicetree/bindings/net/fixed-link.txt
@@ -18,6 +18,18 @@ properties:
 * 'asym-pause' (boolean, optional), to indicate that asym_pause should
   be enabled.
 
+Old, deprecated 'fixed-link' binding:
+
+* A 'fixed-link' property in the EThernet MAC node, with 5 cells, of the
+  form <a b c d e> with the following accepted values:
+  - a: emulated phy id, choose any but but unique to the all specified
+    fixed-links, from 0 to 31
+  - b: duplex configuration: 0 for half duplex, 1 for full duplex
+  - c: link speed in Mbits/sec, accepted values are: 10, 100 and 1000
+  - d: pause configuration: 0 for no pause, 1 for pause
+  - e: asymetric pause configuration: 0 for no asymetric pause, 1 for asymetric
+    pause
+
 Example:
 
 ethernet@0 {
-- 
1.9.1

