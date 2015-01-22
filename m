Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbbAVPpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:45:54 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37183 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbbAVPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:50 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Carlo Caione <carlo@caione.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH v9 1/5] dt-bindings: add vendor-prefix for X-Powers
Date: Thu, 22 Jan 2015 23:39:03 +0800
Message-Id: <1421941147-9682-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421941147-9682-1-git-send-email-wens@csie.org>
References: <1421941147-9682-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlo Caione <carlo@caione.org>

Signed-off-by: Carlo Caione <carlo@caione.org>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 38c13dc19983..76e288a17996 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -173,6 +173,7 @@ voipac	Voipac Technologies s.r.o.
 winbond Winbond Electronics corp.
 wlf	Wolfson Microelectronics
 wm	Wondermedia Technologies, Inc.
+x-powers	X-Powers
 xes	Extreme Engineering Solutions (X-ES)
 xillybus	Xillybus Ltd.
 xlnx	Xilinx
-- 
2.1.4

