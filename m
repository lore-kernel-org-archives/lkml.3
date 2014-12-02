Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaLBJSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:18:22 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:47359 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaLBJST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:18:19 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <29810f1e6bb8863eff951c9283f033a8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Mark Yao <mark.yao@rock-chips.com>
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org,
        olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, xw@rock-chips.com,
        Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH v15 2/3] dt-bindings: video: Add for rockchip display subsytem
Date: Tue,  2 Dec 2014 17:16:55 +0800
Message-Id: <1417511815-7182-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add a display subsystem comprise the all display interface nodes.

Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
Changes in v2:
- add DRM master device node to list all display nodes that comprise
  the graphics subsystem.

Changes in v3: None

Changes in v4: None

Changes in v5: None

Changes in v6: None

Changes in v7: None

Changes in v8: None

Changes in v9: None

Changes in v10: None

Changes in v11: None

Changes in v12: None

Changes in v13: None

Changes in v14: None

Changes in v15: None

 .../devicetree/bindings/video/rockchip-drm.txt     |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-drm.txt b/Documentation/devicetree/bindings/video/rockchip-drm.txt
new file mode 100644
index 0000000..7fff582
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-drm.txt
@@ -0,0 +1,19 @@
+Rockchip DRM master device
+================================
+
+The Rockchip DRM master device is a virtual device needed to list all
+vop devices or other display interface nodes that comprise the
+graphics subsystem.
+
+Required properties:
+- compatible: Should be "rockchip,display-subsystem"
+- ports: Should contain a list of phandles pointing to display interface port
+  of vop devices. vop definitions as defined in
+  Documentation/devicetree/bindings/video/rockchip-vop.txt
+
+example:
+
+display-subsystem {
+	compatible = "rockchip,display-subsystem";
+	ports = <&vopl_out>, <&vopb_out>;
+};
-- 
1.7.9.5


