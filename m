Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaE0HbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:31:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57515 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaE0HbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:31:09 -0400
MIME-Version: 1.0
Date: Tue, 27 May 2014 09:31:08 +0200
Message-ID: <CACRpkda3vYf6ZDCTcPj9hbPp6hgQ70bkocvSr15Nki+5vEHe3Q@mail.gmail.com>
Subject: [GIT PULL] final pin control fix for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Charkov <alchark@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a final single patch for v3.15. Details in the signed tag,
please pull it in.

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.15-4

for you to fetch changes up to 7ea456436ff6563b6cf89d3254ae76a8ceab499b:

  pinctrl: vt8500: Ensure value reg is updated when setting direction
(2014-05-22 23:46:10 +0200)

----------------------------------------------------------------
A single last pinctrl fix for the v3.15 series:
the vt8500 driver was failing to update the output value
when the combined set direction output and set value was
executed.

----------------------------------------------------------------
Alexey Charkov (1):
      pinctrl: vt8500: Ensure value reg is updated when setting direction

 drivers/pinctrl/vt8500/pinctrl-wmt.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)
