Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3LMGsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:48:42 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:55418 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3LMGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:48:41 -0500
Message-ID: <52AAADA7.4000508@synopsys.com>
Date: Fri, 13 Dec 2013 12:18:07 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        francois Bedard <Francois.Bedard@synopsys.com>
Subject: [GIT PULL] ARC Fixes for 3.13
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC fixes for 3.13. These are couple of weeks old already, but I just
couldn't get them to you earlier.

Thx,
-Vineet
--------------------->
The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-fixes-for-3.13

for you to fetch changes up to da990a4f2d5a321911026c26c7eeec3bbc6fb7b7:

  ARC: [perf] Fix a few thinkos (2013-11-28 15:49:59 +0530)

----------------------------------------------------------------
ARC Fixes for 3.13

- Couple of fixes for recently added perf code
- Build time extable sort

----------------------------------------------------------------
Vineet Gupta (3):
      ARC: extable: Enable sorting at build time
      ARC: Add guard macro to uapi/asm/unistd.h
      ARC: [perf] Fix a few thinkos

 arch/arc/Kconfig                   | 1 +
 arch/arc/include/uapi/asm/unistd.h | 5 +++++
 arch/arc/kernel/perf_event.c       | 4 ++--
 scripts/sortextable.c              | 5 +++++
 4 files changed, 13 insertions(+), 2 deletions(-)
