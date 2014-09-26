Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaIZKYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:24:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbaIZJqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Praveen Diwakar <praveen.diwakar@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/142] ASoC: wm_adsp: Add missing MODULE_LICENSE
Date: Fri, 26 Sep 2014 11:44:46 +0200
Message-Id: <465da614d4f6787d8e733f9771556220302431ed.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Praveen Diwakar <praveen.diwakar@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0a37c6efec4a2fdc2563c5a8faa472b814deee80 upstream.

Since MODULE_LICENSE is missing the module load fails,
so add this for module.

Signed-off-by: Praveen Diwakar <praveen.diwakar@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/wm_adsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 0d5de6003849..61e871bf63dd 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1694,3 +1694,5 @@ int wm_adsp2_init(struct wm_adsp *adsp, bool dvfs)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_init);
+
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

