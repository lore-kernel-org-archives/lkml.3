Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3F0Vhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 17:37:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:33689 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3F0Vhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 17:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,954,1363158000"; 
   d="scan'208";a="336640117"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Another mce cleanup for the 3.11 queue
Date: Thu, 27 Jun 2013 14:37:36 -0700
Message-Id: <51ccb0a019950f07cd@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce

for you to fetch changes up to 33d7885b594e169256daef652e8d3527b2298e75:

  x86/mce: Update MCE severity condition check (2013-06-27 13:45:52 -0700)

----------------------------------------------------------------
Changes to simplify the SDM mean that we can also simplify
the code for SRAR (software recoverable action required) errors.

----------------------------------------------------------------
Chen Gong (1):
      x86/mce: Update MCE severity condition check

 arch/x86/kernel/cpu/mcheck/mce-severity.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)
