Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaJTR05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:26:57 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42017 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaJTR0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:26:52 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
        linux-media@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] [media] v4l: DocBook: fix media build error
Date: Mon, 20 Oct 2014 10:26:43 -0700
Message-Id: <1413826003-1237-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <54454199.3070702@infradead.org>
References: <54454199.3070702@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix media DocBook build errors by re-adding the orderedlist tag
and putting back the section tags lost during merge.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 Documentation/DocBook/media/v4l/compat.xml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 07ffc76..0a2debf 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2566,6 +2566,10 @@ fields changed from _s32 to _u32.
 	  <para>Added compound control types and &VIDIOC-QUERY-EXT-CTRL;.
 	  </para>
         </listitem>
+      </orderedlist>
+    </section>
+
+    <section>
       <title>V4L2 in Linux 3.18</title>
       <orderedlist>
 	<listitem>
-- 
2.1.0.rc2.206.gedb03e5

