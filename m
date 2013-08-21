Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3HUAVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:21:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:41929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab3HUAUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573828"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 8/8] turbostat: Add a .gitignore to ignore the compiled turbostat binary
Date: Tue, 20 Aug 2013 17:20:19 -0700
Message-Id: <1377044419-15045-9-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 tools/power/x86/turbostat/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/power/x86/turbostat/.gitignore

diff --git a/tools/power/x86/turbostat/.gitignore b/tools/power/x86/turbostat/.gitignore
new file mode 100644
index 0000000..7521370
--- /dev/null
+++ b/tools/power/x86/turbostat/.gitignore
@@ -0,0 +1 @@
+turbostat
-- 
1.8.4.rc3

