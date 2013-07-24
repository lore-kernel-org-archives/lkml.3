Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3GXVDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:03:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:15101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3GXVC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,737,1367996400"; 
   d="scan'208";a="375885748"
Message-Id: <cover.1374699492.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Wed, 24 Jul 2013 13:58:12 -0700
Subject: [PATCH 0/2] machine check decode fixes
To: linux-kernel@vger.kernel.org
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2 of this:
* Broken into two patches - by suggestion of Chen Gong
* Just change MCACOD #define value - by suggestion of Naveen

Tony Luck (2):
  x86/mce: Fix mce regression from recent cleanup
  x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC'
    errors

 arch/x86/include/asm/mce.h                | 13 +++++++++++--
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  4 ++--
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.8.1.4

