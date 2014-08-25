Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaHYQzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:55:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbaHYQzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.28 stable review
Date: Mon, 25 Aug 2014 09:54:46 -0700
Message-Id: <1408985699-31838-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.28 stable kernel.

 ** NOTE: This will be the last Linux 3.8.y.z extended stable version
 ** to be released and supported by me and the Ubuntu Kernel team.

This version contains 13 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.28 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/x86/include/asm/ptrace.h   |  16 +++++++
 arch/x86/kernel/entry_32.S      |  13 +++--
 drivers/target/target_core_rd.c |   2 +-
 fs/namespace.c                  |  59 ++++++++++++++++++++---
 include/linux/mount.h           |   9 +++-
 include/linux/ptrace.h          |   3 ++
 mm/shmem.c                      | 104 +++++++++++++++++++++++++++++++++++-----
 net/l2tp/l2tp_ppp.c             |   4 +-
 net/sctp/associola.c            |   2 +-
 9 files changed, 185 insertions(+), 27 deletions(-)

Andy Lutomirski (1):
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Eric W. Biederman (4):
      mnt: Only change user settable mount flags in remount
      mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount
      mnt: Correct permission checks in do_remount
      mnt: Change the default remount atime from relatime to the existing value

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched

Nicholas Bellinger (1):
      target: Explicitly clear ramdisk_mcp backend pages

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem
