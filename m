Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517Ab3IECwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762415Ab3IECv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:51:59 -0400
Date: Wed, 4 Sep 2013 22:51:48 -0400
From: Dave Jones <davej@redhat.com>
To: m.chehab@samsung.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: add missing braces in drxd_hard.c:DRXD_init
Message-ID: <20130905025148.GA12062@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, m.chehab@samsung.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 9a213479..a1a3421 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2692,11 +2692,11 @@ static int DRXD_init(struct drxd_state *state, const u8 *fw, u32 fw_size)
 		status = EnableAndResetMB(state);
 		if (status < 0)
 			break;
-		if (state->type_A)
+		if (state->type_A) {
 			status = ResetCEFR(state);
 			if (status < 0)
 				break;
-
+		}
 		if (fw) {
 			status = DownloadMicrocode(state, fw, fw_size);
 			if (status < 0)
