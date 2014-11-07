Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaKGR36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:29:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:16068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaKGR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:29:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,333,1413270000"; 
   d="scan'208";a="604238426"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>,
        Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>,
        Noor U Mubeen <noor.u.mubeen@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 0/3] Intel RAPL updates for Atom CPUs
Date: Fri,  7 Nov 2014 09:29:24 -0800
Message-Id: <1415381367-16693-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running Average Power Limit (RAPL) is supported in Atom processors
with a slightly different implementation. This patchset abstracts the
differences and add support for newer ATOM CPUs.

Intel Software Developers Manual has also been updated with many changes
and clarifications on how RAPL units and power limits are calculated.

Changes:
	v2: fix 32 bit divide in time window calculation  

Jacob Pan (3):
  powercap/rapl: abstract per cpu type functions
  powercap/rapl: handle atom and core differences
  powercap/rapl: add new model ids

 drivers/powercap/intel_rapl.c | 264 ++++++++++++++++++++++++++++--------------
 1 file changed, 177 insertions(+), 87 deletions(-)

-- 
1.9.1

