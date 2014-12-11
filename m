Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaLKAYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:24:19 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36118 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLKAYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:24:18 -0500
Date: Thu, 11 Dec 2014 00:23:42 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: m.chehab@samsung.com
Cc: jarod@wilsonet.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, gulsah.1004@gmail.com,
        tuomas.tynkkynen@iki.fi, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/3] staging: media: lirc: lirc_zilog.c: missing newline
 in dev_err()
Message-ID: <20141211002342.GA11173@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing newline character at the end of string passed to dev_err()

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 27464da..7def690 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -799,7 +799,7 @@ static int fw_load(struct IR_tx *tx)
 		goto corrupt;
 	if (version != 1) {
 		dev_err(tx->ir->l.dev,
-			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
+			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver\n",
 			version);
 		fw_unload_locked();
 		ret = -EFAULT;
-- 
2.1.3

