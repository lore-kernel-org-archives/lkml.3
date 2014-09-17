Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaIQD3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:29:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:3914 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaIQD3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,538,1406617200"; 
   d="scan'208";a="603948448"
From: "David E. Box" <david.e.box@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: iosf: Additions to iosf patch set
Date: Tue, 16 Sep 2014 20:26:23 -0700
Message-Id: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes apply on top of the patches currently in Peter Anvin's tip tree.

David E. Box (3):
  x86: iosf: Add Braswell PCI ID
  x86: iosf: Move Kconfig to proper submenu
  x86: iosf: Make debugfs addition a separate config option

 arch/x86/Kconfig           | 35 ++++++++++++++++++++---------------
 arch/x86/kernel/iosf_mbi.c | 10 ++++++++--
 2 files changed, 28 insertions(+), 17 deletions(-)

-- 
1.9.1

