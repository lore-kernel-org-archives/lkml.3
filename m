Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968Ab3DORee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:34:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:59274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab3DORd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="318548605"
Date: Mon, 15 Apr 2013 10:33:36 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [RFC 7/7] Docs: Move ref to Frohwalt Egerer to end of REPORTING-BUGS
Message-ID: <8d874c1030e1ae4c174d8f947841ee3ee196f898.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The document is largely not the same as the original that was crafted
from Frohwalt Egerer's document, but leave it in as a historical thank
you footnote.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 REPORTING-BUGS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index d397e918..0cb8cdf 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -77,7 +77,6 @@ threads or separate bugzilla entries.  If you report several unrelated
 bugs at once, it's difficult for maintainers to tease apart the relevant
 data.
 
-[Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
 
 Gather information
 ------------------
@@ -171,3 +170,5 @@ responding to these types of bugs in a timely manner (especially during a
 merge window), escalate the bug to LKML and Linus Torvalds.
 
 Thank you!
+
+[Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
-- 
1.7.9

