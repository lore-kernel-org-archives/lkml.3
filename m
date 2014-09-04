Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaIDGVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:21:55 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40199 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaIDGVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:21:54 -0400
Date: Thu, 4 Sep 2014 08:18:53 +0200
From: Piotr Witoslawski <pwitos@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drivers: staging: dgap: fix the checkpatch.pl issue
 "Warning: line over 80 characters"
Message-ID: <20140904061853.GA2940@pwitoslawski.warsaw.osa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break lines exceeding 80 characters

Signed-off-by: Piotr Witoslawski <pwitos@gmail.com>
---
 drivers/staging/dgap/dgap.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 8929dbf..67da1d5 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -88,7 +88,8 @@ static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
 				struct channel_t *ch);
 static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 				unsigned long arg);
-static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo);
+static int dgap_tty_digigeta(struct channel_t *ch,
+			     struct digi_t __user *retinfo);
 static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
 			     struct un_t *un, struct digi_t __user *new_info);
 static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
@@ -104,8 +105,9 @@ static void dgap_tty_flush_chars(struct tty_struct *tty);
 static void dgap_tty_flush_buffer(struct tty_struct *tty);
 static void dgap_tty_hangup(struct tty_struct *tty);
 static int dgap_wait_for_drain(struct tty_struct *tty);
-static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct un_t *un,
-			       unsigned int command, unsigned int __user *value);
+static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd,
+			       struct un_t *un, unsigned int command,
+			       unsigned int __user *value);
 static int dgap_get_modem_info(struct channel_t *ch,
 				unsigned int __user *value);
 static int dgap_tty_digisetcustombaud(struct channel_t *ch, struct board_t *bd,
@@ -3076,8 +3078,9 @@ static int dgap_get_modem_info(struct channel_t *ch, unsigned int __user *value)
  *
  * Set modem signals, called by ld.
  */
-static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct un_t *un,
-			       unsigned int command, unsigned int __user *value)
+static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd,
+			       struct un_t *un, unsigned int command,
+			       unsigned int __user *value)
 {
 	int ret;
 	unsigned int arg;
@@ -3153,7 +3156,8 @@ static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct
  *
  *
  */
-static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo)
+static int dgap_tty_digigeta(struct channel_t *ch,
+			     struct digi_t __user *retinfo)
 {
 	struct digi_t tmp;
 	ulong lock_flags;
-- 
1.8.5.5

