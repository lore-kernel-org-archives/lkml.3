Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3FNIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:25:28 -0400
Received: from mail.abilis.ch ([195.70.19.74]:16779 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3FNIZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:25:25 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] Fix comment on pinctrl_gpio_range.pin_base
Date: Fri, 14 Jun 2013 10:24:48 +0200
Message-Id: <1371198288-23829-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <51BAC3A1.80105@st.com>
References: <51BAC3A1.80105@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment introduced with the recently added pinctrl_gpio_range.pins
element was wrong. This corrects it.
Thanks to Patrice Chotard for pointing this out.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 include/linux/pinctrl/pinctrl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 286c5e5..47ab2fb 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -49,7 +49,7 @@ struct pinctrl_pin_desc {
  * @name: a name for the chip in this range
  * @id: an ID number for the chip in this range
  * @base: base offset of the GPIO range
- * @pin_base: base pin number of the GPIO range if pins != NULL
+ * @pin_base: base pin number of the GPIO range if pins == NULL
  * @pins: enumeration of pins in GPIO range or NULL
  * @npins: number of pins in the GPIO range, including the base number
  * @gc: an optional pointer to a gpio_chip
-- 
1.7.1

