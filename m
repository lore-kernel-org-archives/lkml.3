Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3EHCfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:35:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49789 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EHCfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:35:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,631,1363158000"; 
   d="scan'208";a="45225124"
Date: Tue, 7 May 2013 21:34:45 -0500
From: rkuo <rkuo@codeaurora.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [GIT PULL] Hexagon fix/cleanup
Message-ID: <20130508023404.GA776@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull the following changes for Hexagon; it includes a bug fix and a
Kconfig cleanup.


Thanks,
Richard Kuo



The following changes since commit 426d29ccb2a8d44c18d3167327ee82b38287e7bf:

  Hexagon: add v4 CS regs to core copyout macro (2013-04-30 19:40:29 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git for-linus

for you to fetch changes up to de44443a45e36b7467af2518d3bf7ec6ec909549:

  HEXAGON: Remove non existent reference to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD (2013-05-07 11:38:12 -0500)

----------------------------------------------------------------
Alexander Shiyan (1):
      HEXAGON: Remove non existent reference to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD

Richard Kuo (1):
      Hexagon: fix register used to call do_work_pending

 arch/hexagon/Kconfig           |    2 --
 arch/hexagon/kernel/vm_entry.S |   12 ++++++------
 2 files changed, 6 insertions(+), 8 deletions(-)


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
