Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaKFSXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:23:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:34219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFSXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:23:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="603639343"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Noor U Mubeen <noor.u.mubeen@intel.com>,
        Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/3] Intel RAPL updates for Atom CPUs
Date: Thu,  6 Nov 2014 10:22:34 -0800
Message-Id: <1415298157-7615-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running Average Power Limit (RAPL) is supported in Atom processors
with a slightly different implementation. This patchset abstracts the
differences and add support for newer ATOM CPUs.

Intel Software Developers Manual has also been updated with many changes
and clarifications on how RAPL units and power limits are calculated.


Jacob Pan (3):
  powercap/rapl: abstract per cpu type functions
  powercap/rapl: handle atom and core differences
  powercap/rapl: add new model ids

 drivers/powercap/intel_rapl.c | 264 ++++++++++++++++++++++++++++--------------
 1 file changed, 177 insertions(+), 87 deletions(-)

-- 
1.9.1

