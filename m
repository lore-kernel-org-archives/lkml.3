Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaAaRcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:32:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.17 stable review
Date: Fri, 31 Jan 2014 09:32:03 -0800
Message-Id: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.17 stable kernel.

This version contains 14 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.17 will be open for the next 24 hours.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
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
 14 files changed, 109 insertions(+), 48 deletions(-)

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
