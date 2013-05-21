Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3EUSJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:09:48 -0400
Received: from sauhun.de ([89.238.76.85]:37912 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab3EUSJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:09:46 -0400
Date: Tue, 21 May 2013 20:11:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.10
Message-ID: <20130521181117.GA23945@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the bugfixes for the i2c subsystem. Those should have been
in rc1 but I missed it due to working on devm longer than expected.
There is one ID addition, since we are touching the driver anyhow. And
the feature bit documentation is one outcome of a debug session and will
make it easier for users to work around problems. The rest is typical
driver bugfixes.

Please pull.

Thanks,

   Wolfram


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to e9b526fe704812364bca07edd15eadeba163ebfb:

  i2c: suppress lockdep warning on delete_device (2013-05-17 22:49:45 +0200)

----------------------------------------------------------------
Alexander Sverdlin (1):
      i2c: suppress lockdep warning on delete_device

Jean Delvare (1):
      i2c: i801: Document feature bits in modinfo

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun

Mika Westerberg (2):
      i2c: designware: always clear interrupts before enabling them
      i2c: designware: add Intel BayTrail ACPI ID

Russell King (1):
      i2c: mv64xxx: work around signals causing I2C transactions to be aborted

 drivers/i2c/busses/i2c-designware-core.c    |   14 ++++++++++++--
 drivers/i2c/busses/i2c-designware-core.h    |    2 ++
 drivers/i2c/busses/i2c-designware-platdrv.c |    1 +
 drivers/i2c/busses/i2c-i801.c               |    6 +++++-
 drivers/i2c/busses/i2c-mv64xxx.c            |    8 ++++----
 drivers/i2c/i2c-core.c                      |    3 ++-
 6 files changed, 26 insertions(+), 8 deletions(-)
