Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3KHQGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:06:00 -0500
Received: from mail1.windriver.com ([147.11.146.13]:44967 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3KHQF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:05:59 -0500
Date: Fri, 8 Nov 2013 11:04:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Doug Ledford <dledford@redhat.com>, Hannes Reinecke <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] delete decade+ obsolete aic7xxx_old driver
Message-ID: <20131108160446.GA16190@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

We've got appropriate acks on this, and we've also established
that it doesn't appear to even be enabled in any of the common
distros, and nobody voiced any strong objections in the past
month+ since posting, so please pull this driver deletion.

Thanks,
Paul.
---

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git aic7xxx-delete

for you to fetch changes up to 1ef2840c7207c8f22d0065d9149bad7dc5e3dca1:

  scsi: delete decade+ obsolete aic7xxx_old driver (2013-09-19 16:07:44 -0400)

----------------------------------------------------------------
Paul Gortmaker (1):
      scsi: delete decade+ obsolete aic7xxx_old driver

 Documentation/scsi/00-INDEX             |     2 -
 Documentation/scsi/aic7xxx_old.txt      |   511 --
 MAINTAINERS                             |     1 -
 drivers/scsi/Kconfig                    |    41 -
 drivers/scsi/Makefile                   |     1 -
 drivers/scsi/aic7xxx_old.c              | 11149 ------------------------------
 drivers/scsi/aic7xxx_old/aic7xxx.h      |    28 -
 drivers/scsi/aic7xxx_old/aic7xxx.reg    |  1401 ----
 drivers/scsi/aic7xxx_old/aic7xxx.seq    |  1539 -----
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |   270 -
 drivers/scsi/aic7xxx_old/aic7xxx_reg.h  |   629 --
 drivers/scsi/aic7xxx_old/aic7xxx_seq.c  |   817 ---
 drivers/scsi/aic7xxx_old/scsi_message.h |    49 -
 drivers/scsi/aic7xxx_old/sequencer.h    |   135 -
 14 files changed, 16573 deletions(-)
 delete mode 100644 Documentation/scsi/aic7xxx_old.txt
 delete mode 100644 drivers/scsi/aic7xxx_old.c
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.h
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.reg
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.seq
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_proc.c
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_reg.h
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_seq.c
 delete mode 100644 drivers/scsi/aic7xxx_old/scsi_message.h
 delete mode 100644 drivers/scsi/aic7xxx_old/sequencer.h
