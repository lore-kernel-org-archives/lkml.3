Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423392Ab3CVWWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:22:08 -0400
Received: from sauhun.de ([89.238.76.85]:35457 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422924Ab3CVWWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:22:06 -0400
Date: Fri, 22 Mar 2013 23:22:01 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.9
Message-ID: <20130322222201.GA10797@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the updates for the 3.9 kernel. There is one bugfix for the
tegra driver. There are two updates regarding email addresses and
MAINTAINERS which I like to have up-to-date so people can be reached
immediately. While we are here, there is on PCI_ID addition.

Thanks,

   Wolfram


The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 888f2804e46377b54f283707f87c09922ef87eb2:

  MAINTAINERS: add maintainer entry for atmel i2c driver (2013-03-22 11:19:59 +0100)

----------------------------------------------------------------
Guenter Roeck (1):
      i2c: Fix my e-mail address in drivers and documentation

Laxman Dewangan (1):
      i2c: tegra: check the clk_prepare_enable() return value

Ludovic Desroches (1):
      MAINTAINERS: add maintainer entry for atmel i2c driver

Seth Heasley (1):
      i2c: iSMT: add Intel Avoton DeviceIDs

 Documentation/i2c/busses/i2c-diolan-u2c |    2 +-
 MAINTAINERS                             |    6 ++++++
 drivers/i2c/busses/i2c-ismt.c           |    2 ++
 drivers/i2c/busses/i2c-tegra.c          |   13 +++++++++++--
 drivers/i2c/muxes/i2c-mux-pca9541.c     |    2 +-
 5 files changed, 21 insertions(+), 4 deletions(-)
