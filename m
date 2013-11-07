Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3KGDMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:12:23 -0500
Received: from intranet.asianux.com ([58.214.24.6]:32054 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3KGDMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:12:22 -0500
X-Spam-Score: -100.8
Message-ID: <527B0595.5030108@asianux.com>
Date: Thu, 07 Nov 2013 11:14:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, perex@perex.cz,
        "dhowells@redhat.com" <dhowells@redhat.com>
CC: alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/uapi/sound/firewire.h: use "_UAPI" instead of "UAPI"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When installing, "scripts/headers_install.sh" will strip guard macro'
"_UAPI" to prevent from appearing it to users. And also, all another
files which need uapi prefix always use "_UAPI", not "UAPI".

So use "_UAPI" instead of "UAPI" on the guard macro, and also give a
comment for "#endif".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/uapi/sound/firewire.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/sound/firewire.h b/include/uapi/sound/firewire.h
index e86131c..59f5961 100644
--- a/include/uapi/sound/firewire.h
+++ b/include/uapi/sound/firewire.h
@@ -1,5 +1,5 @@
-#ifndef UAPI_SOUND_FIREWIRE_H_INCLUDED
-#define UAPI_SOUND_FIREWIRE_H_INCLUDED
+#ifndef _UAPI_SOUND_FIREWIRE_H_INCLUDED
+#define _UAPI_SOUND_FIREWIRE_H_INCLUDED
 
 #include <linux/ioctl.h>
 
@@ -48,4 +48,4 @@ struct snd_firewire_get_info {
  * Returns -EBUSY if the driver is already streaming.
  */
 
-#endif
+#endif /* _UAPI_SOUND_FIREWIRE_H_INCLUDED */
-- 
1.7.7.6
