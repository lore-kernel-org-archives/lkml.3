Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3DSR7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:59:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57190 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3DSR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:59:45 -0400
Date: Fri, 19 Apr 2013 10:59:48 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: arm-soc fixes for 3.9
Message-ID: <20130419175948.GA29547@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 71bd98aff05a644a2cfc3ac6ca848a586fa210b9:

  Merge tag 'mvebu_fixes_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into fixes (2013-04-11 16:55:29 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 73053d973dd6f56472309cffa5a5d15a62dd6f96:

  ARM: highbank: fix cache flush ordering for cpu hotplug (2013-04-18 09:37:46 -0700)

----------------------------------------------------------------
ARM: arm-soc fixes for 3.9

Only one remaining fix for arm-soc platforms at this time, a small
bugfix for cpu hotplug on highbank platforms that has become much
easier to hit as of late. Details in the patch description, but it's
small and well-contained and definitely impacts users of the platform,
so 3.9 seems appropriate.

----------------------------------------------------------------
Rob Herring (1):
      ARM: highbank: fix cache flush ordering for cpu hotplug

 arch/arm/mach-highbank/hotplug.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)
