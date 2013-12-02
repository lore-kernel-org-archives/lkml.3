Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3LBUDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:03:51 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49199 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3LBUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:03:23 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 2 Dec 2013 12:03:01 -0800
Message-ID: <CAK5ve-Jf=rEBaS0MDfk9DCXEeRa16ddKtF1fseW=c_8q7tm0Vg@mail.gmail.com>
Subject: [GIT PULL] leds fixes for 3.13-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider the following bug fix since commit
dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
leds-fixes-for-3.13

for you to fetch changes up to aa1a6d6d74fff31060e08f6007037e6d807c8130:

  leds: pwm: Fix for deferred probe in DT booted mode (2013-12-02
11:53:17 -0800)

----------------------------------------------------------------
Peter Ujfalusi (1):
      leds: pwm: Fix for deferred probe in DT booted mode

 drivers/leds/leds-pwm.c | 53 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)
