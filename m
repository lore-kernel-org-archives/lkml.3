Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaF1B2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:28:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaF1B2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:28:46 -0400
Message-ID: <53AE1A4E.9020107@infradead.org>
Date: Fri, 27 Jun 2014 18:28:46 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: [PATCH 1/2] Documentation: add section about git to email-clients.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

These days most people use git to send patches so I have added a section
about that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: fix typo in commit message
v3: update git am and log commands.  Mention the man pages.
v4: s/list/appropriate mailing list(s)/

---
 Documentation/email-clients.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- lnx-315-rc5.orig/Documentation/email-clients.txt
+++ lnx-315-rc5/Documentation/email-clients.txt
@@ -1,6 +1,17 @@
 Email clients info for Linux
 ======================================================================
 
+Git
+----------------------------------------------------------------------
+These days most developers use `git send-email` instead of regular
+email clients.  The man page for this is quite good.  On the receiving
+end, maintainers use `git am` to apply the patches.
+
+If you are new to git then send your first patch to yourself.  Save it
+as raw text including all the headers.  Run `git am raw_email.txt` and
+then review the changelog with `git log`.  When that works then send
+the patch to the appropriate mailing list(s).
+
 General Preferences
 ----------------------------------------------------------------------
 Patches for the Linux kernel are submitted via email, preferably as
