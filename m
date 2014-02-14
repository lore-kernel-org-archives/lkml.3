Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaBNV06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:26:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:6596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbaBNVWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="483680324"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Subject: Updated Link-Time-Optimization patchkit
Date: Fri, 14 Feb 2014 22:21:24 +0100
Message-Id: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the updated LTO patchkit for 3.14-rc2.  LTO allows
the compiler to do global optimization over the whole kernel.

All problems/comments reported last week have been addressed, plus
a lot of improvements to the documentation and the Kconfig description.
Plus some random improvements.

See the individual patches for a detailed description

Dependencies: asmlinkage patchkit (posted last week), kallsyms patchkit

Full git tree is in
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc lto-3.14

-Andi

