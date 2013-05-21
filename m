Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3EUSdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:33:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62949 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3EUSdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:33:42 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 21 May 2013 11:33:21 -0700
Message-ID: <CAK5ve-K0Ka6KUhe84aQnvLW4B5s_phNSo+iCKE_OWMB3MVCb4g@mail.gmail.com>
Subject: [GIT PULL] leds fixes for 3.10-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We found a bug in leds-gpio driver, please consider to pull the
following changes since commit
c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
leds-fixes-3.10

for you to fetch changes up to 803d19d57a042e86e9e9b685bbc3f4a0a751040f:

  leds: leds-gpio: reserve gpio before using it (2013-05-21 11:26:53 -0700)

----------------------------------------------------------------
Timo Teräs (1):
      leds: leds-gpio: reserve gpio before using it

 drivers/leds/leds-gpio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
