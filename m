Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaEOJeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:34:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24472 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaEOJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:33:59 -0400
Date: Thu, 15 May 2014 12:33:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [patch v4] Documentation/email-clients.txt: add a section about git
Message-ID: <20140515093328.GA31597@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5373DC51.2080207@infradead.org>
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
v4: s/list/appropriate mailing list(s)/

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
+the patch to the appropriate mailing list(s).
+
 General Preferences
 ----------------------------------------------------------------------
 Patches for the Linux kernel are submitted via email, preferably as
_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

