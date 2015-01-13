Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbbAMWRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:17:21 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37800 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbbAMWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:17:20 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Jan 2015 14:16:59 -0800
Message-ID: <CAK5ve-Kq_x7O-D6--7LBL+GTx5=N15S+y4Ascb5T3-eq1d3CZQ@mail.gmail.com>
Subject: [GIT PULL] LED fix for 3.19
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider the following changes since commit
eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
leds-fixes-for-3.19

for you to fetch changes up to 0c86ac2c50647451d6a70dc900f8bb0ee3d485d9:

  leds: netxbig: fix oops at probe time (2015-01-13 13:49:01 -0800)

----------------------------------------------------------------
Simon Guinot (1):
      leds: netxbig: fix oops at probe time

 drivers/leds/leds-netxbig.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)
