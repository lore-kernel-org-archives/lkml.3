Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaIOWOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:14:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbaIOWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Praveen Diwakar <praveen.diwakar@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 059/187] ASoC: wm_adsp: Add missing MODULE_LICENSE
Date: Mon, 15 Sep 2014 15:07:49 -0700
Message-Id: <1410818997-9432-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Diwakar <praveen.diwakar@intel.com>

commit 0a37c6efec4a2fdc2563c5a8faa472b814deee80 upstream.

Since MODULE_LICENSE is missing the module load fails,
so add this for module.

Signed-off-by: Praveen Diwakar <praveen.diwakar@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm_adsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 4fbcab6..07c99e8 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1702,3 +1702,5 @@ int wm_adsp2_init(struct wm_adsp *adsp, bool dvfs)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_init);
+
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

