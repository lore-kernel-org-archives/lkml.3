Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab3E1Vmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:42:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59538 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 10/78] ASoC: wm8994: missing break in wm8994_aif3_hw_params()
Date: Tue, 28 May 2013 14:19:19 -0700
Message-Id: <1369776027-17859-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4495e46fe18f198366961bb2b324a694ef8a9b44 upstream.

The missing break here means that we always return early and the
function is a no-op.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 3b269fa..237a7ba 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2841,6 +2841,7 @@ static int wm8994_aif3_hw_params(struct snd_pcm_substream *substream,
 		default:
 			return 0;
 		}
+		break;
 	default:
 		return 0;
 	}
-- 
1.8.1.2

