Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaIRFQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:16:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:14198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaIRFQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,544,1406617200"; 
   d="scan'208";a="604607008"
From: "David E. Box" <david.e.box@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] x86: iosf: Additions to iosf patch set
Date: Wed, 17 Sep 2014 22:13:48 -0700
Message-Id: <1411017231-20807-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
References: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes apply on top of the patches currently in Peter Anvin's tip tree.

V2:	More descriptive Kconfig prompt for IOSF_MBI and IOSF_MBI_DEBUG
	Cleaned up ifdef use on IOSF_MBI_DEBUG with DUMMY functions

David E. Box (3):
  x86: iosf: Add Braswell PCI ID
  x86: iosf: Add better description of IOSF driver in config
  x86: iosf: Add debugfs config option for iosf

 arch/x86/Kconfig           | 45 ++++++++++++++++++++++++++++++---------------
 arch/x86/kernel/iosf_mbi.c | 25 +++++++++++++++++++++----
 2 files changed, 51 insertions(+), 19 deletions(-)

-- 
1.9.1

