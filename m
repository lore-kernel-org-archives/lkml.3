Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981Ab3GENwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:52:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18118 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab3GENwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:52:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Jul 2013 06:53:30 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>,
        <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <gg@slimlogic.co.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] extcon: palmas: devicetree: remove non-require property details
Date: Fri, 5 Jul 2013 19:29:52 +0530
Message-ID: <1373032792-29001-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1373032792-29001-1-git-send-email-ldewangan@nvidia.com>
References: <1373032792-29001-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extcon for palma driver does not need vbus supply and hence
removing this from devicetree document/bindings.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../devicetree/bindings/extcon/extcon-palmas.txt   |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
index 58f531a..f110e75 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
+++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
@@ -1,15 +1,13 @@
-EXTCON FOR TWL CHIPS
+EXTCON FOR PALMAS/TWL CHIPS
 
 PALMAS USB COMPARATOR
 Required Properties:
  - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
- - vbus-supply : phandle to the regulator device tree node.
 
 Optional Properties:
  - ti,wakeup : To enable the wakeup comparator in probe
 
 palmas-usb {
        compatible = "ti,twl6035-usb", "ti,palmas-usb";
-       vbus-supply = <&smps10_reg>;
        ti,wakeup;
 };
-- 
1.7.1.1

