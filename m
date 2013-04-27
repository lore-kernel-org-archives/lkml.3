Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3D0Uxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 16:53:43 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57064 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3D0Uxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 16:53:42 -0400
Date: Sat, 27 Apr 2013 13:53:37 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: arm-soc: one more patch for 3.9
Message-ID: <20130427205337.GA27352@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 73053d973dd6f56472309cffa5a5d15a62dd6f96:

  ARM: highbank: fix cache flush ordering for cpu hotplug (2013-04-18 09:37:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to d21be237ffa357e55005e2bf9ffef10b23c184d0:

  Merge tag 'omap-for-v3.9-rc6/fixes-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2013-04-26 17:35:21 -0700)

----------------------------------------------------------------

ARM: arm-soc fixes for 3.9

A late-arriving fix for musb on OMAP4, resolving an issue where the musb
IP won't be clocked and thus not functional. Small in scope, most of the
lines changed is a longish comment.

----------------------------------------------------------------
Kishon Vijay Abraham I (1):
      ARM: OMAP4: hwmod data: make 'ocp2scp_usb_phy_phy_48m" as the main clock

Olof Johansson (1):
      Merge tag 'omap-for-v3.9-rc6/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes

 arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)
