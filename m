Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaCQKEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:04:20 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4299 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbaCQKDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:03:19 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>, nicolas.ferre@atmel.com
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, Bo Shen <voice.shen@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904 driver
Date: Mon, 17 Mar 2014 17:45:40 +0800
Message-Id: <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
index 8bbe50c..aca341c 100644
--- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
+++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
@@ -3,6 +3,8 @@ Atmel ASoC driver with wm8904 audio codec complex
 Required properties:
   - compatible: "atmel,asoc-wm8904"
   - atmel,model: The user-visible name of this sound complex.
+  - clocks: A list of clocks needed by the wm8904 chip.
+  - clock-output-names: Driver related clock names. Shall contain "pck0".
   - atmel,audio-routing: A list of the connections between audio components.
     Each entry is a pair of strings, the first being the connection's sink,
     the second being the connection's source. Valid names for sources and
-- 
1.8.5.2

