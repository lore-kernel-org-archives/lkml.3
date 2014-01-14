Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaANO6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:58:31 -0500
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:35295 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbaANO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:58:29 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v1 1/5] pinctrl: st: Fix a typo in probe
Date: Tue, 14 Jan 2014 14:52:05 +0000
Message-ID: <1389711125-21007-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Probe function had commas instead of semi-colons on some of the lines.
This patch just fixes those lines. No functional chagnes done in this
patch.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/pinctrl/pinctrl-st.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 9cadc68..320c273 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1370,10 +1370,10 @@ static int st_pctl_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	pctl_desc->owner	= THIS_MODULE,
-	pctl_desc->pctlops	= &st_pctlops,
-	pctl_desc->pmxops	= &st_pmxops,
-	pctl_desc->confops	= &st_confops,
+	pctl_desc->owner	= THIS_MODULE;
+	pctl_desc->pctlops	= &st_pctlops;
+	pctl_desc->pmxops	= &st_pmxops;
+	pctl_desc->confops	= &st_confops;
 	pctl_desc->name		= dev_name(&pdev->dev);
 
 	info->pctl = pinctrl_register(pctl_desc, &pdev->dev, info);
-- 
1.7.6.5

