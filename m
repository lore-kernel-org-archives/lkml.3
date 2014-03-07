Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaCGJoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:44:04 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:44450 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbaCGJnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:43:33 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v2 2/5] pinctrl: st: add pinctrl support for the STiH407 SoC
Date: Fri,  7 Mar 2014 10:41:09 +0100
Message-Id: <1394185272-26054-3-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394185272-26054-1-git-send-email-maxime.coquelin@st.com>
References: <1394185272-26054-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe Cavallaro <peppe.cavallaro@st.com>

This patch adds the initial support for pinctrl based on H407 SoC.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 9fb66aa..9e9b6ea 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1580,6 +1580,10 @@ static struct of_device_id st_pctl_of_match[] = {
 	{ .compatible = "st,stih416-rear-pinctrl", .data = &stih416_data},
 	{ .compatible = "st,stih416-fvdp-fe-pinctrl", .data = &stih416_data},
 	{ .compatible = "st,stih416-fvdp-lite-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-sbc-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-front-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-rear-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-flash-pinctrl", .data = &stih416_data},
 	{ /* sentinel */ }
 };
 
-- 
1.9.0

