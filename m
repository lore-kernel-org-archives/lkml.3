Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaKCRRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:17:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbaKCRRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:17:50 -0500
Date: Mon, 3 Nov 2014 18:17:48 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        David Miller <davem@davemloft.net>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Message-ID: <20141103171748.GI10156@dhcp22.suse.cz>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/cgroups/memory.txt is outdate even more hopelessly than
before. It deserves a complete rewrite but I guess something like the
following should be added in the meantime to prepare potential readers
about the trap.
---
diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 67613ff0270c..46b2b5080317 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -1,5 +1,10 @@
 Memory Resource Controller
 
+NOTE: This document is hopelessly outdated and it asks for a complete
+      rewrite. It still contains a useful information so we are keeping it
+      here but make sure to check the current code if you need a deeper
+      understanding.
+
 NOTE: The Memory Resource Controller has generically been referred to as the
       memory controller in this document. Do not confuse memory controller
       used here with the memory controller that is used in hardware.
-- 
Michal Hocko
SUSE Labs
