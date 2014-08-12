Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaHLRae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:30:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:40397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaHLRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:30:33 -0400
Message-ID: <53EA4F34.4050402@infradead.org>
Date: Tue, 12 Aug 2014 10:30:28 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jim Davis <jim.epost@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: DocBook: Rename drm_stub.c to drm_drv.c cause
 'make xmldocs' failed
References: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
X-Forwarded-Message-Id: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed 'make xmldocs' failed on linus's tree and
linux-next as of 8th/Aug,2014.

When drm merge for 3.17-rc1 happen,  a file was renamed from
drm_stub.c to drm_drv.c.
But Documentation/DocBook/drm.tmpl still have an old file name.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/DocBook/drm.tmpl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Linus, please merge since it fixes a fatal DocBook error.


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



