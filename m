Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaH2Rpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:45:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaH2Rpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:45:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.28
Date: Fri, 29 Aug 2014 10:45:31 -0700
Message-Id: <1409334332-22902-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.28 kernel.

 ** NOTE: This is the last Linux 3.8.y.z extended stable version
 ** that will be released and supported by the Ubuntu Kernel team.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.27 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                        |   2 +-
 arch/x86/include/asm/ptrace.h   |  16 +++++++
 arch/x86/kernel/entry_32.S      |  13 +++--
 drivers/target/target_core_rd.c |   2 +-
 fs/namespace.c                  |  59 ++++++++++++++++++++---
 include/linux/mount.h           |   9 +++-
 include/linux/ptrace.h          |   3 ++
 mm/shmem.c                      | 104 +++++++++++++++++++++++++++++++++++-----
 net/l2tp/l2tp_ppp.c             |   4 +-
 net/sctp/associola.c            |   2 +-
 10 files changed, 186 insertions(+), 28 deletions(-)

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

Kamal Mostafa (1):
      Linux 3.8.13.28

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

