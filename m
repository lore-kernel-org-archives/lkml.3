Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbaBARu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:50:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60810 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188AbaBARuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:50:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.17
Date: Sat,  1 Feb 2014 09:50:49 -0800
Message-Id: <1391277050-5977-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.17 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.16 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                        |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c        | 53 +++++++++++++++++++++----
 arch/x86/kernel/entry_32.S                      |  4 +-
 arch/x86/kernel/entry_64.S                      |  2 +-
 drivers/gpu/drm/i915/intel_ddi.c                |  8 +++-
 drivers/hwmon/coretemp.c                        |  2 +-
 drivers/md/raid10.c                             | 12 +++---
 drivers/md/raid5.c                              |  4 +-
 drivers/staging/comedi/drivers/8255_pci.c       | 20 ++++++++--
 drivers/staging/comedi/drivers/addi_apci_1032.c |  4 +-
 fs/dcache.c                                     |  7 +++-
 fs/fs-writeback.c                               | 15 ++++---
 fs/nilfs2/segment.c                             | 10 +++--
 net/compat.c                                    |  9 +----
 net/rds/ib_recv.c                               |  7 ++--
 15 files changed, 110 insertions(+), 49 deletions(-)

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Eric W. Biederman (1):
      vfs: In d_path don't call d_dname on a mount point

Gerald Schaefer (1):
      net: rds: fix per-cpu helper usage

H Hartley Sweeten (1):
      staging: comedi: addi_apci_1032: fix subdevice type/flags bug

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Jan Kara (1):
      writeback: Fix data corruption on NFS

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Kamal Mostafa (1):
      Linux 3.8.13.17

NeilBrown (3):
      md/raid5: Fix possible confusion when multiple write errors occur.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid10: fix bug when raid10 recovery fails to recover a block.

PaX Team (1):
      x86, x32: Correct invalid use of user timespec in the kernel

Paulo Zanoni (1):
      drm/i915: fix DDI PLLs HW state readout code

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Steven Rostedt (1):
      ftrace/x86: Load ftrace_ops in parameter not the variable holding it

