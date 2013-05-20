Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3ETLJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:09:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3ETKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 062/115] ASoC: wm8994: missing break in wm8994_aif3_hw_params()
Date: Mon, 20 May 2013 11:51:02 +0100
Message-Id: <1369047116-9378-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4495e46fe18f198366961bb2b324a694ef8a9b44 upstream.

The missing break here means that we always return early and the
function is a no-op.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 7b9b4ef..44719a3 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2778,6 +2778,7 @@ static int wm8994_aif3_hw_params(struct snd_pcm_substream *substream,
 		default:
 			return 0;
 		}
+		break;
 	default:
 		return 0;
 	}
-- 
1.8.1.2

