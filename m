Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401AbaD2Wfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:35:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:4588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbaD2Wff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:35:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,953,1389772800"; 
   d="scan'208";a="532007932"
From: "David E. Box" <david.e.box@linux.intel.com>
To: david.e.box@linux.intel.com, jacob.jun.pan@linux.intel.com,
        linux-pm@vger.kernel.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Cc: alan@linux.intel.com, durgadoss.r@intel.com, kristen.c.accardi@intel.com
Subject: [PATCH v2 0/4] RAPL driver updates
Date: Tue, 29 Apr 2014 15:33:05 -0700
Message-Id: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

v2: iosf: Remove Kconfig exposure. Make mailbox driver a module.

David E. Box (1):
  x86/iosf: Make IOSF driver modular and usable by more drivers

Jacob Pan (3):
  powercap/rapl: further relax energy counter checks
  powercap/rapl: add new cpu ids
  powercap/rapl: change floor frequency for vallewview

 arch/x86/Kconfig                |    7 ++---
 arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |    6 ++++
 drivers/powercap/intel_rapl.c   |   60 ++++++++++++++++++++-------------------
 4 files changed, 72 insertions(+), 34 deletions(-)

-- 
1.7.10.4

