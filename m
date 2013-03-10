Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3CJLdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:33:10 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:44015 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab3CJLdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:33:06 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net D5E243DC322
Subject: [PATCH 5/5] HID: roccat: Fixed comments on chardevice
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Mar 2013 12:33:04 +0100
Message-ID: <1362915184.2769.170.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed parameter documentations

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index d7437ef..b59b3df 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -242,7 +242,6 @@ static int roccat_release(struct inode *inode, struct file *file)
  * roccat_report_event() - output data to readers
  * @minor: minor device number returned by roccat_connect()
  * @data: pointer to data
- * @len: size of data
  *
  * Return value is zero on success, a negative error code on failure.
  *
@@ -290,6 +289,7 @@ EXPORT_SYMBOL_GPL(roccat_report_event);
  * @class: the class thats used to create the device. Meant to hold device
  * specific sysfs attributes.
  * @hid: the hid device the char device should be connected to.
+ * @report_size: size of reports
  *
  * Return value is minor device number in Range [0, ROCCAT_MAX_DEVICES] on
  * success, a negative error code on failure.
-- 
1.7.3.4



