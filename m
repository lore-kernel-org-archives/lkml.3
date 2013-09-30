Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3I3EdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 00:33:23 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:45299 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3I3EdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 00:33:20 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linus Torvalds <torvalds@linux-foundation.org>
CC: "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ARC fixes for 3.12
Thread-Topic: [GIT PULL] ARC fixes for 3.12
Thread-Index: Ac69lipXTlMIAEmqQViPwbL1wSOG8Q==
Date: Mon, 30 Sep 2013 04:33:16 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514ED20@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC fixes for 3.12.

Thx,
-Vineet

--------------------->
The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-fixes-for-3.12

for you to fetch changes up to 55c2e26204276b27f2b7a63123b701c950e45d89:

  ARC: Use clockevents_config_and_register over clockevents_register_device
(2013-09-27 16:28:48 +0530)

----------------------------------------------------------------
ARC Fixes for 3.12

* Handling unaligned access in zero delay loops
* spinlock livelock fix for SMP systemC model
* fixing 32bit overflow in access_ok
* better setup of clockevents

----------------------------------------------------------------
Mischa Jonker (1):
      ARC: Handle zero-overhead-loop in unaligned access handler

Uwe Kleine-König (1):
      ARC: Use clockevents_config_and_register over clockevents_register_device

Vineet Gupta (2):
      ARC: Fix 32-bit wrap around in access_ok()
      ARC: Workaround spinlock livelock in SMP SystemC simulation

 arch/arc/include/asm/spinlock.h | 9 ++++++++-
 arch/arc/include/asm/uaccess.h  | 4 ++--
 arch/arc/kernel/time.c          | 7 ++-----
 arch/arc/kernel/unaligned.c     | 6 ++++++
 4 files changed, 18 insertions(+), 8 deletions(-)
