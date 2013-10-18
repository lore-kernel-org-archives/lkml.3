Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3JRVOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:14:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:4420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3JRVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,525,1378882800"; 
   d="scan'208";a="395149872"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, x86@kernel.org
Cc: sathyanarayanan.kuppuswamy@linux.intel.com, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 0/3] Add maintainers + Clovertrail support to Intel Mid
Date: Fri, 18 Oct 2013 14:18:47 -0700
Message-Id: <1382131130-10903-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next series of patches to add initial support to more Intel Mid
platforms. This time is Clovertrail. Next it will be Merrifield.

This patch set:
1. adds maintainers to Intel Mid architecture
2. moves Medfield code to its own file
3. adds Clovertrail support to Intel Mid

---
David Cohen (2):
  MAINTAINERS: INTEL MID SOC: add maintainers
  x86: intel-mid: move Medfield code out of intel-mid.c core file

Kuppuswamy Sathyanarayanan (1):
  x86: intel-mid: add Clovertrail platform support

 MAINTAINERS                                        |  9 +++
 arch/x86/include/asm/intel-mid.h                   | 46 ++++++++++++-
 arch/x86/platform/intel-mid/Makefile               |  4 +-
 arch/x86/platform/intel-mid/intel-mid.c            | 60 ++++++++---------
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 18 ++++++
 arch/x86/platform/intel-mid/mfld.c                 | 75 ++++++++++++++++++++++
 6 files changed, 178 insertions(+), 34 deletions(-)
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_weak_decls.h
 create mode 100644 arch/x86/platform/intel-mid/mfld.c

-- 
1.8.4.rc3

