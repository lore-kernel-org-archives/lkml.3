Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934971Ab3DORf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:35:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:59272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab3DORd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="318548598"
Date: Mon, 15 Apr 2013 10:33:35 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [RFC 6/7] Docs: Add a tips section to REPORTING-BUGS.
Message-ID: <cc336c29f6284d636b59eb1c6f9b950fbc08c9b7.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of grumpy maintainers would love to have annoying newbies and
disorganized bug reporters read Eric S. Raymond's "How To Ask Questions
The Smart Way".  Simon Tatham's "How to Report Bugs Effectively" is also
relevant.

It's likely no one will bother to read these, but it does give
maintainers something to point to.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 REPORTING-BUGS |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index 327b33b..d397e918 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -64,6 +64,19 @@ information on the linux-kernel mailing list see
 http://www.tux.org/lkml/).
 
 
+Tips for reporting bugs
+-----------------------
+
+If you haven't reported a bug before, please read:
+
+http://www.chiark.greenend.org.uk/~sgtatham/bugs.html
+http://www.catb.org/esr/faqs/smart-questions.html
+
+It's REALLY important to report bugs that seem unrelated as separate email
+threads or separate bugzilla entries.  If you report several unrelated
+bugs at once, it's difficult for maintainers to tease apart the relevant
+data.
+
 [Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
 
 Gather information
-- 
1.7.9

