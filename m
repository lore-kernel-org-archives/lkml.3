Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3BCBdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:33:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:4223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab3BCBdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:33:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,591,1355126400"; 
   d="scan'208";a="282096899"
Date: Sun, 3 Feb 2013 09:33:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: warning: (LOCKDEP && ..) selects FRAME_POINTER which has unmet
 direct dependencies (DEBUG_KERNEL && ..) || ..)
Message-ID: <20130203013340.GD9024@localhost>
References: <510da78c.qEkPZ/vJ5AxY+Wiu%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510da78c.qEkPZ/vJ5AxY+Wiu%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

FYI, there are new compile warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
head:   ce0da597d603726ed22a4237fcf76ca52bd5a2b5
commit: dcf6a6c6e54007c8cfbe6076f2569f28ac0b2248 Kconfig.debug: add METAG to dependency lists
date:   4 days ago
config: make ARCH=mips allmodconfig

It's an old warning but your commit changes its exact form. ;)

warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
