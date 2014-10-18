Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaJRQjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 12:39:11 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33351 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaJRQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 12:39:04 -0400
Date: Sat, 18 Oct 2014 12:33:30 -0400
From: Jon Mason <jdmason@kudzu.us>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: [GIT PULL] NTB bug fixes for v3.18
Message-ID: <20141018163329.GA10668@kudzu.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Below are a few NTB changes for v3.18. Please consider pulling them.

Thanks,
Jon


The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

  Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

  git://github.com/jonmason/ntb tags/ntb-3.18

for you to fetch changes up to ab760a0c5667519b375ea9c5ab3a23501c4817ef:

  ntb: Adding split BAR support for Haswell platforms (2014-10-17 07:08:51 -0400)

----------------------------------------------------------------
Add support for Haswell NTB split BARs, a debugfs entry for basic
debugging info, and some code clean-ups.

----------------------------------------------------------------
Dave Jiang (4):
      ntb: move platform detection to separate function
      ntb: conslidate reading of PPD to move platform detection earlier
      ntb: use errata flag set via DID to implement workaround
      ntb: Adding split BAR support for Haswell platforms

Jon Mason (1):
      NTB: debugfs device entry

 drivers/ntb/ntb_hw.c   | 567 +++++++++++++++++++++++++++++++++++++++----------
 drivers/ntb/ntb_hw.h   |  19 +-
 drivers/ntb/ntb_regs.h |  38 +++-
 3 files changed, 501 insertions(+), 123 deletions(-)
