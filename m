Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3DOReh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:34:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:59274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab3DORd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="318548554"
Date: Mon, 15 Apr 2013 10:33:30 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [RFC 1/7] Trivial: docs: Remove six-space indentation in
 REPORTING-BUGS.
Message-ID: <3b12c21ab34c1057aa7f1cf73139215e12e89b6c.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other paragraph format docs in Documentation don't use paragraph
indentations, so conform REPORTING-BUGS to that.

Re-wrap the paragraphs, keeping the doc to a 74-character line length,
since that's what the original seemed to use.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 REPORTING-BUGS |   43 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index 55a6074..ad709e4 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -1,30 +1,31 @@
 [Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
 
-     What follows is a suggested procedure for reporting Linux bugs. You
-aren't obliged to use the bug reporting format, it is provided as a guide
-to the kind of information that can be useful to developers - no more.
+What follows is a suggested procedure for reporting Linux bugs. You aren't
+obliged to use the bug reporting format, it is provided as a guide to the
+kind of information that can be useful to developers - no more.
 
-     If the failure includes an "OOPS:" type message in your log or on
-screen please read "Documentation/oops-tracing.txt" before posting your
-bug report. This explains what you should do with the "Oops" information
-to make it useful to the recipient.
+If the failure includes an "OOPS:" type message in your log or on screen
+please read "Documentation/oops-tracing.txt" before posting your bug
+report. This explains what you should do with the "Oops" information to
+make it useful to the recipient.
+
+Send the output to the maintainer of the kernel area that seems to be
+involved with the problem, and cc the relevant mailing list. Don't worry
+too much about getting the wrong person. If you are unsure send it to the
+person responsible for the code relevant to what you were doing.  If it
+occurs repeatably try and describe how to recreate it. That is worth even
+more than the oops itself.  The list of maintainers and mailing lists is
+in the MAINTAINERS file in this directory.  If you know the file name that
+causes the problem you can use the following command in this directory to
+find some of the maintainers of that file:
 
-      Send the output to the maintainer of the kernel area that seems to
-be involved with the problem, and cc the relevant mailing list. Don't
-worry too much about getting the wrong person. If you are unsure send it
-to the person responsible for the code relevant to what you were doing.
-If it occurs repeatably try and describe how to recreate it. That is
-worth even more than the oops itself.  The list of maintainers and
-mailing lists is in the MAINTAINERS file in this directory.  If you
-know the file name that causes the problem you can use the following
-command in this directory to find some of the maintainers of that file:
      perl scripts/get_maintainer.pl -f <filename>
 
-      If it is a security bug, please copy the Security Contact listed
-in the MAINTAINERS file.  They can help coordinate bugfix and disclosure.
-See Documentation/SecurityBugs for more information.
+If it is a security bug, please copy the Security Contact listed in the
+MAINTAINERS file.  They can help coordinate bugfix and disclosure.  See
+Documentation/SecurityBugs for more information.
 
-      If you are totally stumped as to whom to send the report, send it to
+If you are totally stumped as to whom to send the report, send it to
 linux-kernel@vger.kernel.org. (For more information on the linux-kernel
 mailing list see http://www.tux.org/lkml/).
 
@@ -33,7 +34,7 @@ list. Having a standardized bug report form makes it easier for you not to
 overlook things, and easier for the developers to find the pieces of
 information they're really interested in. Don't feel you have to follow it.
 
-      First run the ver_linux script included as scripts/ver_linux, which
+First run the ver_linux script included as scripts/ver_linux, which
 reports the version of some important subsystems.  Run this script with
 the command "sh scripts/ver_linux".
 
-- 
1.7.9

