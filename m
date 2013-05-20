Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3ETHMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:12:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47767 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3ETHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:12:08 -0400
MIME-Version: 1.0
Date: Mon, 20 May 2013 09:12:08 +0200
Message-ID: <CACRpkdZ3H=_1HkQqaazP2-JSBe9RBTQjb+WPm+FYBKFuFCqFOA@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for the rc series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Tony Prisk <linux@prisktech.co.nz>, Wei Yongjun <weiyj.lk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a set of collected pinctrl fixes for the v3.10 series.
The description is in the signed tag as usual.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-v3.10-2

for you to fetch changes up to 1dda2fa650da12a644c7cc8645707c912bdc5ab8:

  pinctrl/lantiq: Free mapping configs for both pin and groups
(2013-05-15 13:28:46 +0200)

----------------------------------------------------------------
Pinctrl fixes for the v3.10 series:
- Three fixes to make the boot path for device tree work
  properly on the Nomadik pin controller.
- Compile warning fix for the vt8500 driver.
- Fix error path in pinctrl-single.
- Free mappings in error path of the Lantiq controller.
- Documentation fixes.

----------------------------------------------------------------
Laurent Pinchart (2):
      pinctrl: generic: Fix typos and clarify comments
      pinctrl/lantiq: Free mapping configs for both pin and groups

Lee Jones (2):
      pinctrl: abx500: Specify failed sub-driver by ID instead of driver_data
      pinctrl: abx500: Rejiggle platform data and DT initialisation

Tony Prisk (1):
      pinctrl: vt8500: Fix incorrect data in WM8750 pinctrl table

Wei Yongjun (1):
      pinctrl: single: fix error return code in pcs_parse_one_pinctrl_entry()

 drivers/pinctrl/pinctrl-abx500.c        | 30 ++++++++++++++----------------
 drivers/pinctrl/pinctrl-lantiq.c        |  3 ++-
 drivers/pinctrl/pinctrl-single.c        |  3 ++-
 drivers/pinctrl/vt8500/pinctrl-wm8750.c |  2 +-
 include/linux/pinctrl/pinconf-generic.h | 12 ++++++------
 5 files changed, 25 insertions(+), 25 deletions(-)
