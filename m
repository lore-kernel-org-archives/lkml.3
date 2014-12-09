Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaLITkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:40:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:19558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbaLITka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:40:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,547,1413270000"; 
   d="scan'208";a="651135209"
Date: Wed, 10 Dec 2014 03:38:17 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org
Subject: [tj-misc:review-wq-dump 1/15] lib/bitmap.c:574:6: sparse: symbol
 'bitmap_print_list' was not declared. Should it be static?
Message-ID: <201412100354.d6xN5OCa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-wq-dump
head:   c48dd4e1a0d7225c97d7294958dd8ba6be82fde9
commit: 069dcda94642807dc31bf52895bd409512531249 [1/15] bitmap: restructure bitmap_sn[list]printf()
reproduce:
  # apt-get install sparse
  git checkout 069dcda94642807dc31bf52895bd409512531249
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> lib/bitmap.c:574:6: sparse: symbol 'bitmap_print_list' was not declared. Should it be static?
   lib/bitmap.c:1250:30: sparse: incorrect type in assignment (different base types)
   lib/bitmap.c:1250:30:    expected unsigned long [unsigned] [long] <noident>
   lib/bitmap.c:1250:30:    got restricted __le64 [usertype] <noident>
   lib/bitmap.c:1252:30: sparse: incorrect type in assignment (different base types)
   lib/bitmap.c:1252:30:    expected unsigned long [unsigned] [long] <noident>
   lib/bitmap.c:1252:30:    got restricted __le32 [usertype] <noident>

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
