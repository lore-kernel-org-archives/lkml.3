Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbbAJFlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:41:52 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44358 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbbAJFgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:42 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 09/25] staging: line6: Remove useless comments
Date: Fri,  9 Jan 2015 23:35:55 -0600
Message-Id: <1420868171-2031-10-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 6dc8a0d..acde205 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -61,7 +61,6 @@ MODULE_DEVICE_TABLE(usb, line6_id_table);
 	{.id = dev_id,\
 	 .name = dev_name, .capabilities = LINE6_BIT_##dev_cap}
 
-/* *INDENT-OFF* */
 static const struct line6_properties line6_properties_table[] = {
 	L6PROP("BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
 	L6PROP("BassPODxtLive", "BassPODxt Live",   CTRL_PCM_HW),
@@ -82,7 +81,6 @@ static const struct line6_properties line6_properties_table[] = {
 	L6PROP("TonePortUX2",   "TonePort UX2",     PCM),
 	L6PROP("Variax",        "Variax Workbench", CONTROL),
 };
-/* *INDENT-ON* */
 
 /*
 	This is Line6's MIDI manufacturer ID.
-- 
2.1.0

