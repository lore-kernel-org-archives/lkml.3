Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3BEBt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:49:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:29594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab3BEBt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:49:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="282784998"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: Basic perf PMU support for Haswell v4
Date: Mon,  4 Feb 2013 17:49:09 -0800
Message-Id: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the
extreme "perf for dummies" edition as requested.  

I removed some more patches, these will come later.
I moved parts of an later patch (counter constraints for qualifiers) 
into an earlier patch, to support the full raw bits at least.

For anything beyond basic usage this is not very useful.

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters

v2: Addressed Stephane's feedback. See individual patches for details.
v3: now even more bite-sized. Qualifier constraints merged earlier.
Add some Reviewed-bys.
v4: Rename some variables, add some comments and other minor changes in the first patch.

-Andi
