Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaIOUFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:05:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaIOTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Praveen Diwakar <praveen.diwakar@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 30/71] ASoC: wm_adsp: Add missing MODULE_LICENSE
Date: Mon, 15 Sep 2014 12:26:28 -0700
Message-Id: <20140915192639.713990357@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Diwakar <praveen.diwakar@intel.com>

commit 0a37c6efec4a2fdc2563c5a8faa472b814deee80 upstream.

Since MODULE_LICENSE is missing the module load fails,
so add this for module.

Signed-off-by: Praveen Diwakar <praveen.diwakar@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_adsp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1284,3 +1284,5 @@ int wm_adsp2_init(struct wm_adsp *adsp,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_init);
+
+MODULE_LICENSE("GPL v2");


