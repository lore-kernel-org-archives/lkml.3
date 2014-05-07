Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaEGLRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:17:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbaEGLRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:17:46 -0400
Date: Wed, 7 May 2014 14:17:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [patch] Documentation/email-clients.txt: add a section about git
Message-ID: <20140507111708.GA1850@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days most people don't use git to send patches so I have added a
section about that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 4e30eba..9004a5fd 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -1,6 +1,17 @@
 Email clients info for Linux
 ======================================================================
 
+Git
+----------------------------------------------------------------------
+These days most developers use `git send-email` instead of regular
+email clients.  On the receiving end, maintainers use `git am` to
+apply the patches.
+
+If you are new to git then send your first patch to yourself.  Save it
+as raw text including all the headers.  Run `cat raw_email.txt | git am`
+and then review the changelog with `git log -p`.  When that works then
+send the patch to list.
+
 General Preferences
 ----------------------------------------------------------------------
 Patches for the Linux kernel are submitted via email, preferably as
