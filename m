Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaEMQ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:29:42 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45257 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaEMQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:29:29 -0400
Date: Tue, 13 May 2014 12:29:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL RESEND] libata fixes for v3.15-rc5
Message-ID: <20140513162924.GC1866@htj.dyndns.org>
References: <20140512183526.GK1421@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512183526.GK1421@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oops, forgot Linus on the To list, resending)

Hey,

And the libata fixes.  Mostly device-specific fixes.  The only thing
which isn't is the fix for zpodd oops-on-detach bug.

The following changes since commit 8a4aeec8d2d6a3edeffbdfae451cdf05cbf0fefd:

  libata/ahci: accommodate tag ordered controllers (2014-04-18 15:56:03 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.15-fixes

for you to fetch changes up to 2af89a3cde1beb88a2c65e0558d828c1a9e4677f:

  ata: pata_at91 only works on sam9 (2014-05-08 11:00:00 -0400)

Thanks.

----------------------------------------------------------------
Arnd Bergmann (1):
      ata: pata_at91 only works on sam9

Jacob Pan (1):
      ahci: disable DEVSLP for Intel Valleyview

Levente Kurusa (1):
      libata: clean up ZPODD when a port is detached

Shawn Guo (2):
      ahci: imx: add namespace for register enums
      ahci: imx: software workaround for phy reset issue in resume

 drivers/ata/Kconfig       |   2 +-
 drivers/ata/ahci.c        |  15 ++++
 drivers/ata/ahci.h        |   1 +
 drivers/ata/ahci_imx.c    | 177 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/ata/libahci.c     |   7 ++
 drivers/ata/libata-core.c |   9 +++
 6 files changed, 203 insertions(+), 8 deletions(-)

-- 
tejun
