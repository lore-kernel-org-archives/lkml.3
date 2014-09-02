Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaIBRLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:11:53 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63390 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbaIBRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:11:52 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 2 Sep 2014 10:11:30 -0700
Message-ID: <CAK5ve-JKTYO1tpdv3C52o36KJ7Wi=bft9HzHAwmJJe=A2U2JpA@mail.gmail.com>
Subject: [GIT PULL] LED fix for 3.17
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Hugh Dickins <hughd@google.com>,
        Vincent Donnefort <vdonnefort@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Hugh, Jiri and many other people found a kernel oops due to a LED
change merged recently. Now the right fix might just revert it and
unblock the kernel oops. Please check the bug report in the patch
commit message and consider merge the following changes since commit
69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
leds-fixes-for-3.17

for you to fetch changes up to 9067359faf890b3a18ab38c792d458fba77b32b4:

  Revert "leds: convert blink timer to workqueue" (2014-09-02 10:02:13 -0700)

----------------------------------------------------------------
Jiri Kosina (1):
      Revert "leds: convert blink timer to workqueue"

 drivers/leds/led-class.c | 14 +++++++-------
 drivers/leds/led-core.c  | 11 +++++------
 include/linux/leds.h     |  3 ++-
 3 files changed, 14 insertions(+), 14 deletions(-)
