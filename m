Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3HER2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:28:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:43154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3HER2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:28:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,819,1367996400"; 
   d="scan'208";a="357842536"
From: "Luck, Tony" <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86/mce fix to queue for 3.12
Date: Mon, 05 Aug 2013 10:28:29 -0700
Message-Id: <51ffe0bd109866a44a@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce-f-bit

for you to fetch changes up to 0ca06c0857aee11911f91621db14498496f2c2cd:

  x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors (2013-08-05 10:09:40 -0700)

----------------------------------------------------------------
Bit 12 may or may not be set in MCi_STATUS.MCACOD when
an uncorrected error is reported. Ignore it when checking
error signatures.

----------------------------------------------------------------
Tony Luck (1):
      x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors

 arch/x86/include/asm/mce.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)
