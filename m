Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3BBBye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 20:54:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:21163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab3BBByb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 20:54:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,588,1355126400"; 
   d="scan'208";a="280025131"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: Basic perf PMU support for Haswell v3
Date: Fri,  1 Feb 2013 17:54:19 -0800
Message-Id: <1359770064-6344-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the
extreme "perf for dummies" edition as requested.  

I removed some more patches, these will come soon later.
I moved parts of an later patch (counter constraints for qualifiers) 
into an earlier patch, to support the full raw bits at least.

For anything beyond basic usage this is not very useful.
I expect speedy merging of the other parts now.
No git branch, because it doesn't make sense to have that 
many branches.

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters

v2: Addressed Stephane's feedback. See individual patches for details.
v3: now even more bite-sized. Qualifier constraints merged earlier.
Add some Reviewed-bys.

-Andi
