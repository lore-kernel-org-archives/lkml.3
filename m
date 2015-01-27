Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbbA0Dh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:37:27 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:26837 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752345AbbA0DhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:37:00 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v3 2/2] binding: wm8904: add new compatible string
Date: Tue, 27 Jan 2015 11:36:40 +0800
Message-ID: <1422329800-28481-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.3.0.rc0
In-Reply-To: <1422329800-28481-1-git-send-email-voice.shen@atmel.com>
References: <1422329800-28481-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "wlf,wm8912" compatible string is used for wm8912, which
share driver with wm8904, however, the data type is different.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
Changes in v3: None
Changes in v2: None

 Documentation/devicetree/bindings/sound/wm8904.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/wm8904.txt b/Documentation/devicetree/bindings/sound/wm8904.txt
index e99f409..66bf261 100644
--- a/Documentation/devicetree/bindings/sound/wm8904.txt
+++ b/Documentation/devicetree/bindings/sound/wm8904.txt
@@ -3,7 +3,7 @@ WM8904 audio CODEC
 This device supports I2C only.
 
 Required properties:
-  - compatible: "wlf,wm8904"
+  - compatible: "wlf,wm8904" or "wlf,wm8912"
   - reg: the I2C address of the device.
   - clock-names: "mclk"
   - clocks: reference to
-- 
2.3.0.rc0

