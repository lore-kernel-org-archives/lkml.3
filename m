Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaEHIpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:45:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaEHIpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:45:02 -0400
Date: Thu, 8 May 2014 11:44:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Subject: [patch v2] Documentation/email-clients.txt: add a section about git
Message-ID: <20140508084412.GA20398@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A5A1E.6070004@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days most people use git to send patches so I have added a section
about that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Fixed changelog

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
_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

