Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaHAD4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 23:56:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42155 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaHAD4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 23:56:34 -0400
Date: Thu, 31 Jul 2014 20:57:01 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] ARM: Straggler SoC fix for 3.16
Message-ID: <20140801035701.GA20901@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit a1ae5b128365f36a3fa2143cfa9de14fc71c51d8:

  Merge tag 'omap-for-v3.16/n900-regression' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2014-07-29 13:04:27 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to b779b88df8370feafa6f49d08a2cc88db4834992:

  MAINTAINERS: Update Tegra Git URL (2014-07-30 12:50:54 -0700)

----------------------------------------------------------------
ARM: Straggler SoC fix for 3.16

A DT bugfix for Nomadik that had an ambigouos double-inversion of a gpio
line, and one MAINTAINER URL update that might as well go in now.

We could hold off until the merge window, but then we'll just have to mark
the DT fix for stable and it just seems like in total causing more work.

----------------------------------------------------------------
Andreas Färber (1):
      MAINTAINERS: Update Tegra Git URL

Linus Walleij (1):
      ARM: nomadik: fix up double inversion in DT

 MAINTAINERS                                | 2 +-
 arch/arm/boot/dts/ste-nomadik-s8815.dts    | 2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)
