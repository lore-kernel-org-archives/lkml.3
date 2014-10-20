Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaJTCj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:39:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:42792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaJTCjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:39:24 -0400
Message-ID: <544475D5.6080903@infradead.org>
Date: Sun, 19 Oct 2014 19:39:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>
CC: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] DocBook: fix media build error
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix media DocBook build errors by making the orderedlist balanced.

DOC1/Documentation/DocBook/compat.xml:2576: parser error : Opening and ending tag mismatch: orderedlist line 2560 and section
DOC1/Documentation/DocBook/compat.xml:2726: parser error : Premature end of data in tag section line 884
DOC1/Documentation/DocBook/compat.xml:2726: parser error : chunk is not well balanced

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vincent Palatin <vpalatin@chromium.org>
---
 Documentation/DocBook/media/v4l/compat.xml |    1 +
 1 file changed, 1 insertion(+)

--- lnx-318-rc1.orig/Documentation/DocBook/media/v4l/compat.xml
+++ lnx-318-rc1/Documentation/DocBook/media/v4l/compat.xml
@@ -2566,6 +2566,7 @@ fields changed from _s32 to _u32.
 	  <para>Added compound control types and &VIDIOC-QUERY-EXT-CTRL;.
 	  </para>
         </listitem>
+      </orderedlist>
       <title>V4L2 in Linux 3.18</title>
       <orderedlist>
 	<listitem>
