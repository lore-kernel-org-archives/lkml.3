Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbbATHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:09:57 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:37845 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbATHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:09:53 -0500
From: Romain Perier <romain.perier@gmail.com>
To: peppe.cavallaro@st.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, heiko@sntech.de,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: [PATCH v2 4/4] dt-bindings: Document phy-supply property in rockchip-dwmac
Date: Tue, 20 Jan 2015 07:09:40 +0000
Message-Id: <1421737780-1533-5-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
References: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As no property for phy regulator was documented in this dt-binding documentation,
this commit adds an entry for the optional property phy-supply.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
index 2362dcd..21fd199 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
@@ -33,6 +33,7 @@ Required properties:
 Optional properties:
  - tx_delay: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
  - rx_delay: Delay value for RXD timing. Range value is 0~0x7F, 0x10 as default.
+ - phy-supply: phandle to a regulator if the PHY needs one
 
 Example:
 
-- 
1.9.1

