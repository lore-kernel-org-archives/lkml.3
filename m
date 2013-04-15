Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab3DORdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:33:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:36192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab3DORdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="295215905"
Date: Mon, 15 Apr 2013 10:33:32 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [RFC 3/7] Docs: Add "Gather info" section to REPORTING-BUGS.
Message-ID: <7883a250fed9562e6eae8a093e5e2d173ef16662.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sub-heading, and emphasize reproducibility.

Suggest taking a picture of the oops message.  (Did no one have cameras
in 2006?)

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 REPORTING-BUGS |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index 6ed518b..f86e500 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -44,22 +44,24 @@ http://www.tux.org/lkml/).
 
 [Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
 
-What follows is a suggested procedure for reporting Linux bugs. You aren't
-obliged to use the bug reporting format, it is provided as a guide to the
-kind of information that can be useful to developers - no more.
+Gather information
+------------------
 
-If the failure includes an "OOPS:" type message in your log or on screen
-please read "Documentation/oops-tracing.txt" before posting your bug
-report. This explains what you should do with the "Oops" information to
-make it useful to the recipient.
+The most important information in a bug report is how to reproduce the
+bug.  This includes system information, and (most importantly)
+step-by-step instructions for how a user can trigger the bug.
 
-If it occurs repeatably try and describe how to recreate it. That is worth
-even more than the oops itself.
+If the failure includes an "OOPS:", take a picture of the screen, capture
+a netconsole trace, or type the message from your screen into the bug
+report.  Please read "Documentation/oops-tracing.txt" before posting your
+bug report. This explains what you should do with the "Oops" information
+to make it useful to the recipient.
 
-This is a suggested format for a bug report sent to the Linux kernel mailing
-list. Having a standardized bug report form makes it easier for you not to
+This is a suggested format for a bug report sent via email or bugzilla.
+Having a standardized bug report form makes it easier for you not to
 overlook things, and easier for the developers to find the pieces of
-information they're really interested in. Don't feel you have to follow it.
+information they're really interested in.  If some information is not
+relevant to your bug, feel free to exclude it.
 
 First run the ver_linux script included as scripts/ver_linux, which
 reports the version of some important subsystems.  Run this script with
-- 
1.7.9

