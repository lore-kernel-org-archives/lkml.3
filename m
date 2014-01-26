Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbaAZDEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:04:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaAZDEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:04:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/12] 3.4.78-stable review
Date: Sat, 25 Jan 2014 19:05:03 -0800
Message-Id: <20140126030451.934281002@linuxfoundation.org>
X-Mailer: git-send-email 1.9.rc0.19.gb594c97
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.78 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jan 28 03:04:41 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.78-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.78-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    staging: wlags49_h2: buffer overflow setting station name

Jon Medhurst <tixy@linaro.org>
    serial: amba-pl011: use port lock to guard control register access

NeilBrown <neilb@suse.de>
    md/raid5: Fix possible confusion when multiple write errors occur.

NeilBrown <neilb@suse.de>
    md/raid10: fix two bugs in handling of known-bad-blocks.

NeilBrown <neilb@suse.de>
    md/raid10: fix bug when raid10 recovery fails to recover a block.

Andreas Rohner <andreas.rohner@gmx.net>
    nilfs2: fix segctor bug that causes file system corruption

Steven Rostedt <rostedt@goodmis.org>
    SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()

Jean Delvare <khali@linux-fr.org>
    hwmon: (coretemp) Fix truncated name of alarm attributes

Jianguo Wu <wujianguo@huawei.com>
    mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

Robert Richter <rric@kernel.org>
    perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Andy Honig <ahonig@google.com>
    KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)


-------------

Diffstat:

 Makefile                                   |  4 +--
 arch/x86/kernel/cpu/perf_event_amd_ibs.c   | 53 +++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.c                       | 24 ++++++++------
 arch/x86/kvm/lapic.h                       |  4 +--
 arch/x86/kvm/x86.c                         | 33 +------------------
 drivers/hwmon/coretemp.c                   |  2 +-
 drivers/md/raid10.c                        | 12 +++----
 drivers/md/raid5.c                         |  4 +--
 drivers/staging/comedi/drivers/cb_pcidio.c | 21 +++++-------
 drivers/staging/wlags49_h2/wl_priv.c       |  8 +++--
 drivers/tty/serial/amba-pl011.c            |  6 ++++
 fs/nilfs2/segment.c                        | 10 +++---
 mm/memory-failure.c                        | 16 ++++++---
 security/selinux/hooks.c                   | 20 +++++++++--
 security/selinux/include/objsec.h          |  5 ++-
 15 files changed, 133 insertions(+), 89 deletions(-)


