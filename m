Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912Ab3DOReA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:34:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:59274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab3DORd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="318548573"
Date: Mon, 15 Apr 2013 10:33:33 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [RFC 4/7] Docs: Add info on supported kernels to REPORTING-BUGS.
Message-ID: <2c97a63f6fec91db91241981808d099ec60a4688.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the most common frustrations maintainers have with bug reporters
is the email that starts with "I have a two year old kernel from an
embedded vendor with some random drivers and fixes thrown in, and it's
crashing".

Be specific about what kernel versions the upstream maintainers will fix
bugs in, and direct bug reporters to their Linux distribution or
embedded vendor if the bug is in an unsupported kernel.

Suggest that bug reporters should reproduce their bugs on the latest -rc
kernel.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 REPORTING-BUGS |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index f86e500..c1f6e43 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -1,3 +1,25 @@
+Background
+==========
+
+The upstream Linux kernel maintainers only fix bugs for specific kernel
+versions.  Those versions include the current "release candidate" (or -rc)
+kernel, any "stable" kernel versions, and any "long term" kernels.
+
+Please see https://www.kernel.org/ for a list of supported kernels.  Any
+kernel marked with [EOL] is "end of life" and will not have any fixes
+backported to it.
+
+If you've found a bug on a kernel version isn't listed on kernel.org,
+contact your Linux distribution or embedded vendor for support.
+Alternatively, you can attempt to run one of the supported stable or -rc
+kernels, and see if you can reproduce the bug on that.  It's preferable
+to reproduce the bug on the latest -rc kernel.
+
+
+How to report Linux kernel bugs
+===============================
+
+
 Identify the problematic subsystem
 ----------------------------------
 
-- 
1.7.9

