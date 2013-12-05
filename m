Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3LEIIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:08:49 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:51496 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3LEIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:08:48 -0500
MIME-Version: 1.0
Date: Thu, 5 Dec 2013 09:08:47 +0100
Message-ID: <CACRpkdbfiDCkBrigdFc_U5jaYS9QOcAfzwxVQdTDa_6H8k1aew@mail.gmail.com>
Subject: 
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Axel Lin <axel.lin@ingics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are som pin control fixes for the v3.13 series. Nothing special really,
we have a calm cycle this time it seems, all the action is in GPIO. Details
are in the signed tag as usual.

Anyway, please pull it in!

Yours,
Linus Walleij


The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.13-2

for you to fetch changes up to 71493de7e55af589dbe76ce78ae2b762f9cc6f27:

  sh-pfc: sh7372: Fix pin bias setup (2013-12-03 10:38:41 +0100)

----------------------------------------------------------------
Pin control fixes for the v3.13 series:

- Minor bug fixes for the Rockchip, ST-Ericsson abx500,
  Renesas PFC r8a7740 and sh7372.

- Compilation warning fixes.

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: abx500: Fix header file include guard

Dan Carpenter (3):
      pinctrl: rockchip: testing the wrong variable
      pinctrl: abx500: fix some more bitwise AND tests
      pinctrl: rockchip: missing unlock on error in rockchip_set_pull()

Laurent Pinchart (2):
      sh-pfc: r8a7740: Fix pin bias setup
      sh-pfc: sh7372: Fix pin bias setup

 drivers/pinctrl/pinctrl-abx500.c     | 6 +++---
 drivers/pinctrl/pinctrl-abx500.h     | 2 +-
 drivers/pinctrl/pinctrl-rockchip.c   | 5 +++--
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c | 2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7372.c  | 2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)
