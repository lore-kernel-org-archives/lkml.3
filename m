Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaIKVPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:15:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:5912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaIKVPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:15:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,507,1406617200"; 
   d="scan'208";a="571973841"
Subject: [PATCH 0/3] [v3] x86: disabled features macros
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        fenghua.yu@intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 11 Sep 2014 14:15:10 -0700
Message-Id: <20140911211510.D032EC3B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were only minor changes here from the last version.  I'd
like to get this in before the MPX patch set so that the MPX
patches can use this instead of 'cpu_has_mpx'.

Could this get queued up for 3.18?

Changes from v2:
 * also axe PAE macro
 * fix typo in comment
 * put K6_MTRR in the right DISABLED_MASK leaf

