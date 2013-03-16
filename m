Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3CPR5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:57:42 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39704 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3CPR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:57:41 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, tiwai@suse.de, alsa-devel@alsa-project.org,
        perex@perex.cz, rob@landley.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] documentation: alsa: Fix typo in Documentation/sound
Date: Sun, 17 Mar 2013 02:57:28 +0900
Message-Id: <1363456648-7519-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in Documentation/sound/alsa

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/sound/alsa/ALSA-Configuration.txt | 2 +-
 Documentation/sound/alsa/seq_oss.html           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index ce6581c..4499bd9 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -912,7 +912,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
     models depending on the codec chip.  The list of available models
     is found in HD-Audio-Models.txt
 
-    The model name "genric" is treated as a special case.  When this
+    The model name "generic" is treated as a special case.  When this
     model is given, the driver uses the generic codec parser without
     "codec-patch".  It's sometimes good for testing and debugging.
 
diff --git a/Documentation/sound/alsa/seq_oss.html b/Documentation/sound/alsa/seq_oss.html
index d9776cf..9663b45 100644
--- a/Documentation/sound/alsa/seq_oss.html
+++ b/Documentation/sound/alsa/seq_oss.html
@@ -285,7 +285,7 @@ sample data.
 <H4>
 7.2.4 Close Callback</H4>
 The <TT>close</TT> callback is called when this device is closed by the
-applicaion. If any private data was allocated in open callback, it must
+application. If any private data was allocated in open callback, it must
 be released in the close callback. The deletion of ALSA port should be
 done here, too. This callback must not be NULL.
 <H4>
-- 
1.8.2

