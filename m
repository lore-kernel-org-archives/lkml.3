Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaEIUq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:46:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:19657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150AbaEIUq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1020,1389772800"; 
   d="scan'208";a="537854885"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: "David E. Box" <david.e.box@linux.intel.com>, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        jacob.jun.pan@linux.intel.com, boon.leong.ong@intel.com
Subject: [PATCH v4 0/4] x86/iosf: IOSF additional driver/device support
Date: Fri,  9 May 2014 13:44:04 -0700
Message-Id: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
References: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

v2: Remove Kconfig exposure. Make mailbox driver a module.

v3: Use IS_ENABLED macro and clarify commit message. Submit to x86.

v4: Add comment making clear mbi iosf device isn't hot-pluggable.
    Add patch set for Quark support from Ong Boon Leong.

David E. Box (1):
  x86/iosf: Make IOSF driver modular and usable by more drivers

Ong Boon Leong (3):
  arch: x86: added Quark MBI support
  arch: x86: iosf_mbi: add Quark X1000 pci id
  arch: x86: iosf_mbi: add pci id macros for better readability

 arch/x86/Kconfig                |    7 ++---
 arch/x86/include/asm/iosf_mbi.h |   55 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |   13 ++++++++-
 3 files changed, 69 insertions(+), 6 deletions(-)

-- 
1.7.10.4

