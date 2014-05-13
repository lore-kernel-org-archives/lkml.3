Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbaEMNck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:32:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45902 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaEMNcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:32:39 -0400
Date: Tue, 13 May 2014 16:32:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [patch v3] Documentation/email-clients.txt: add a section about git
Message-ID: <20140513133200.GA21702@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days most people use git to send patches so I have added a section
about that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fix typo in commit message
v3: update git am and log commands.  Mention the man pages.

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 4e30eba..9293477 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
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
+the patch to list.
+
 General Preferences
 ----------------------------------------------------------------------
 Patches for the Linux kernel are submitted via email, preferably as
