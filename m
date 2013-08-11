Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3HKJze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 05:55:34 -0400
Received: from sauhun.de ([89.238.76.85]:57207 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab3HKJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 05:55:32 -0400
Date: Sun, 11 Aug 2013 11:55:25 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.11
Message-ID: <20130811095525.GA7926@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

here are some driver bugfixes for the I2C subsystem. Please pull.

Thanks,

   Wolfram


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to f480adaf1b7130ad43760f627b762f771fcfc5f5:

  i2c: mv64xxx: Document the newly introduced allwinner compatible (2013-08-07 16:57:53 +0200)

----------------------------------------------------------------
Fabio Estevam (1):
      i2c: i2c-mxs: Use DMA mode even for small transfers

Maxime Ripard (1):
      i2c: mv64xxx: Document the newly introduced allwinner compatible

Michael Brunner (1):
      i2c: Fix Kontron PLD prescaler calculation

 Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt |    2 +-
 drivers/i2c/busses/i2c-kempld.c                       |    4 ++--
 drivers/i2c/busses/i2c-mxs.c                          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
