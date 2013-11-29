Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3K2PRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:17:40 -0500
Received: from sauhun.de ([89.238.76.85]:59989 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3K2PRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:17:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 Nov 2013 16:17:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] i2c for 3.13
Message-ID: <86e2cadbd328a3e40b275cda0349dd50@localhost>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

here are some easy but needed fixes for i2c drivers since rc1.

Please pull.

Thanks,

   Wolfram


The following changes since commit
6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git
i2c/for-current

for you to fetch changes up to 07a27a0047274e0ba568ce86b6416c34497a99a7:

  i2c: bcm2835: Linking platform nodes to adapter nodes (2013-11-28
09:47:53 +0100)

----------------------------------------------------------------
Florian Meier (1):
      i2c: bcm2835: Linking platform nodes to adapter nodes

Martin Vogt (1):
      i2c: i2c-diolan-u2c: different usb endpoints for DLN-2-U2C

Taras Kondratiuk (1):
      i2c: davinci: raw read and write endian fix

Tim Kryger (1):
      i2c: i2c-bcm-kona: Fix module build

Victor Kamensky (1):
      i2c: omap: raw read and write endian fix

Wei Yongjun (1):
      i2c: bcm-kona: remove duplicated include

 drivers/i2c/busses/i2c-bcm-kona.c   |  3 +--
 drivers/i2c/busses/i2c-bcm2835.c    |  1 +
 drivers/i2c/busses/i2c-davinci.c    |  4 ++--
 drivers/i2c/busses/i2c-diolan-u2c.c | 16 +++++++++++-----
 drivers/i2c/busses/i2c-omap.c       |  8 ++++----
 5 files changed, 19 insertions(+), 13 deletions(-)

