Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbaD1WFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:05:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:43858 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932427AbaD1WFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502535804"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "David E. Box" <david.e.box@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/5] RAPL driver updates
Date: Mon, 28 Apr 2014 07:04:35 -0700
Message-Id: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few updates to the RAPL driver. Including David's IOSF-SB driver change
and a small tweak to allow RAPL driver to use IOSF driver on platforms
with and without IOSF mailbox interface.

David E. Box (1):
  x86, iosf: Add dummy functions for loadable modules

Jacob Pan (4):
  powercap/rapl: further relax energy counter checks
  powercap/rapl: add new cpu ids
  x86/iosf: kconfig and used by other drivers
  powercap/rapl: change floor frequency for vallewview

 arch/x86/Kconfig                |  2 +-
 arch/x86/include/asm/iosf_mbi.h | 34 +++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |  6 +++++
 drivers/powercap/intel_rapl.c   | 60 +++++++++++++++++++++--------------------
 4 files changed, 72 insertions(+), 30 deletions(-)

-- 
1.8.1.2

