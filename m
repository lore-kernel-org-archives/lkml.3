Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbaFRFDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:03:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54807 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551AbaFRFDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:03:40 -0400
X-AuditID: cbfee68f-b7fef6d000003970-59-53a11daa51a6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCH] dt-bindings: extcon: Add support for SM5502 MUIC device
Date: Wed, 18 Jun 2014 14:03:36 +0900
Message-id: <1403067816-32535-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkWHeV7MJgg8tbZCyuf3nOajH/yDlW
	i/43C1ktzr1ayWixsG0Ji8XlXXPYLJZev8hkMWH6WhaLt3ems1i07j3C7sDlsWbeGkaPy329
	TB4rl39h89i8Qstj06pONo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKWLn2OXPBV56Kqav2
	MjUwfuXqYuTgkBAwkbg6hb+LkRPIFJO4cG89WxcjF4eQwFJGib3fzzNCJEwkFm+fxwRiCwks
	YpR4t0QFoqiJSeLb+n/MIAk2AS2J/S9usIHYIgIKEpt7n7GCFDELvGeUuLNqDtgkYQF/iecf
	v7KC2CwCqhJPNk0Ha+YVcJWYvOI8K8Q2OYkPex6xgzRLCKxil/jV+Y4dokFA4tvkQywQZ8tK
	bDrADFEvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIEhvnpf8/6dzDe
	PWB9iDEZaNxEZinR5HxgnOSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBkbTBP0AvbeRMRXH2L5E/Z7N+3TxxN+23Q/bq1e9trttd2ap0oSowOjP
	DxUiGZR9FLU0GWTefxWuV6roC3kR+3+S1dWN138e21sqfUbUuzZvitCzLZ6hB+Iarzx/eiLn
	5LWZ753a3U0nBaWJuHAsei5kMbdWbI9i19MbU7Tv66rIW7u06AnOXabEUpyRaKjFXFScCAB5
	NN1ciQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd1VsguDDU70ilhc//Kc1WL+kXOs
	Fv1vFrJanHu1ktFiYdsSFovLu+awWSy9fpHJYsL0tSwWb+9MZ7Fo3XuE3YHLY828NYwel/t6
	mTxWLv/C5rF5hZbHplWdbB59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxv
	amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdJ+SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+Q
	ILgeIwM0kLCGMWPl2ufMBV95Kqau2svUwPiVq4uRk0NCwERi8fZ5TBC2mMSFe+vZQGwhgUWM
	Eu+WqHQxcgHZTUwS39b/YwZJsAloSex/cQOsSERAQWJz7zNWkCJmgfeMEndWzWEESQgL+Es8
	//iVFcRmEVCVeLJpOlgzr4CrxOQV51khtslJfNjziH0CI/cCRoZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMFx9Ex6B+OqBotDjAIcjEo8vBy5C4KFWBPLiitzDzFKcDArifC+Z1oYLMSb
	klhZlVqUH19UmpNafIgxGWj7RGYp0eR8YIznlcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVANj+2p9r99di1uY92674Xfgc8ex1PSUlwu69zpZiK5c8fKS8of4
	tX9Xh+8WN6pZ7r3bYU3txouvInblOswSDjb1WDZPKdCsZav/37uC67vdLplPS957xGTPjpLc
	JXYxq1dbFX+dfLCYs+/vp+rGM7fyMp74OkiVlPCs/JrVoWTB1fzI+uODLvtWJZbijERDLeai
	4kQAPZpc3OcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add documentation for binding of SM5502 MUIC (Micro-USB Interface
Controller) device which is using EXTCON subsystem. The SM5502 MUIC device
can detect various external accessories when external accessories is attached
or detached.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../devicetree/bindings/extcon/extcon-sm5502.txt   | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-sm5502.txt

diff --git a/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt b/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
new file mode 100644
index 0000000..4ecda22
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
@@ -0,0 +1,23 @@
+
+* SM5502 MUIC (Micro-USB Interface Controller) device
+
+The Silicon Mitus SM5502 is a MUIC (Micro-USB Interface Controller) device
+which can detect the state of external accessory when external accessory is
+attached or detached and button is pressed or released. It is interfaced to
+the host controller using an I2C interface.
+
+Required properties:
+- compatible: Should be "siliconmitus,sm5502-muic"
+- reg: Specifies the I2C slave address of the MUIC block. It should be 0x25
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from sm5502 are delivered to.
+- interrupts: Interrupt specifiers for detection interrupt sources.
+
+Example:
+
+	sm5502@25 {
+		compatible = "siliconmitus,sm5502-muic";
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 0>;
+		reg = <0x25>;
+	};
-- 
1.8.0

