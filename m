Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaHHTQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:16:46 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62878 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaHHTQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:16:45 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: DocBook: Rename drm_stub.c to drm_drv.c cause 'make xmldocs' failed
Date: Sat,  9 Aug 2014 04:16:34 +0900
Message-Id: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.rc0.52.gaa544bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed 'make xmldocs' failed on linus's tree and
linux-next as of 8th/Aug,2014.

When drm merge for 3.17-rc1 happen,  a file was renamed from
drm_stub.c to drm_drv.c.
But Documentation/DocBook/drm.tmpl still have an old file name.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/drm.tmpl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
index 1d3756d..bacefc5 100644
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
@@ -315,7 +315,7 @@ char *date;</synopsis>
         <function>drm_dev_unregister()</function> followed by a call to
         <function>drm_dev_unref()</function>.
       </para>
-!Edrivers/gpu/drm/drm_stub.c
+!Edrivers/gpu/drm/drm_drv.c
     </sect2>
     <sect2>
       <title>Driver Load</title>
-- 
2.1.0.rc0.52.gaa544bf

