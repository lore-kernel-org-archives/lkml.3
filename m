Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaGBHIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:08:25 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54060 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaGBHIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:08:24 -0400
Date: Wed, 2 Jul 2014 16:07:16 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: dgap: Adds a blank line after declaration
Message-ID: <20140702070716.GA11317@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up checkpatch.pl warning:
WARNING: Missing a blank line after declarations

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index b5ea9ff..5bccd14 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -5388,6 +5388,7 @@ static int dgap_param(struct tty_struct *tty)
 	 */
 	if (bd->bd_flags & BD_FEP5PLUS) {
 		u16 hflow2 = 0;
+
 		if (ch->ch_digi.digi_flags & DIGI_RTS_TOGGLE)
 			hflow2 |= (D_RTS(ch));
 		if (ch->ch_digi.digi_flags & DIGI_DTR_TOGGLE)
@@ -5797,6 +5798,7 @@ static int dgap_create_driver_sysfiles(struct pci_driver *dgap_driver)
 static void dgap_remove_driver_sysfiles(struct pci_driver *dgap_driver)
 {
 	struct device_driver *driverfs = &dgap_driver->driver;
+
 	driver_remove_file(driverfs, &driver_attr_version);
 	driver_remove_file(driverfs, &driver_attr_boards);
 	driver_remove_file(driverfs, &driver_attr_maxboards);
@@ -6390,6 +6392,7 @@ static ssize_t dgap_tty_name_show(struct device *d,
 
 		if (cptr->type == TNODE && found == TRUE) {
 			char *ptr1;
+
 			if (strstr(cptr->u.ttyname, "tty")) {
 				ptr1 = cptr->u.ttyname;
 				ptr1 += 3;
-- 
1.7.1

