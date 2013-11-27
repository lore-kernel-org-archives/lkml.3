Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3K0A4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:56:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3K0A4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/39] 3.4.71-stable review
Date: Tue, 26 Nov 2013 16:56:24 -0800
Message-Id: <20131127005619.011763867@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.71 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 29 00:56:06 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.71-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.71-rc1

Mauro Carvalho Chehab <m.chehab@samsung.com>
    cris: media platform drivers: fix build

Junxiao Bi <junxiao.bi@oracle.com>
    configfs: fix race between dentry put and lookup

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800usb: slow down TX status polling

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix a data corruption issue when retransmitting RPC calls

Michael Neuling <mikey@neuling.org>
    powerpc/signals: Mark VSX not saved with small contexts

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Add PE to its own PELTV

Prarit Bhargava <prarit@redhat.com>
    powerpc/vio: use strcpy in modalias_show

Mike Snitzer <snitzer@redhat.com>
    block: properly stack underlying max_segment_size to DM device

Mikulas Patocka <mpatocka@redhat.com>
    block: fix a probe argument to blk_register_region

Jeff Moyer <jmoyer@redhat.com>
    block: fix race between request completion and timeout handling

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix max6696 alarm handling

Thomas Renninger <trenn@suse.de>
    x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Christoph Hellwig <hch@infradead.org>
    nfsd: make sure to balance get/put_write_access

Christoph Hellwig <hch@infradead.org>
    nfsd: split up nfsd_setattr

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()

Takashi Iwai <tiwai@suse.de>
    ALSA: msnd: Avoid duplicated driver name

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix probe of multiple cards

Kees Cook <keescook@chromium.org>
    exec/ptrace: fix get_dumpable() incorrect tests

Mimi Zohar <zohar@linux.vnet.ibm.com>
    Revert "ima: policy for RAMFS"

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: check if device is still available on rt2x00mac_flush()

Steven Rostedt <rostedt@goodmis.org>
    perf/ftrace: Fix paranoid level for enabling function tracer

Fan Du <fan.du@windriver.com>
    include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock

Oleg Nesterov <oleg@redhat.com>
    exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

Al Viro <viro@zeniv.linux.org.uk>
    Nest rename_lock inside vfsmount_lock

Andy Adamson <andros@netapp.com>
    SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Andy Adamson <andros@netapp.com>
    SUNRPC handle EKEYEXPIRED in call_refreshresult

Linus Torvalds <torvalds@linux-foundation.org>
    Fix a few incorrectly checked [io_]remap_pfn_range() calls

David Woodhouse <dwmw2@infradead.org>
    8139cp: re-enable interrupts after tx timeout

Markus Pargmann <mpa@pengutronix.de>
    can: c_can: Fix RX message handling, handle lost message before EOB

Neil Horman <nhorman@tuxdriver.com>
    crypto: ansi_cprng - Fix off by one error in non-block size request

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix tiocmget error handling

Bob Moore <robert.moore@intel.com>
    ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a field.

Bob Moore <robert.moore@intel.com>
    ACPICA: Return error if DerefOf resolves to a null package element.

Bob Moore <robert.moore@intel.com>
    ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.

Bob Moore <robert.moore@intel.com>
    ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.

Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
    aacraid: prevent invalid pointer dereference

Dan Carpenter <dan.carpenter@oracle.com>
    libertas: potential oops in debugfs

Jeff Layton <jlayton@redhat.com>
    nfs: don't allow nfs_find_actor to match inodes of the wrong type

Linus Torvalds <torvalds@linux-foundation.org>
    vfs,proc: guarantee unique inodes in /proc


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/cris/include/asm/io.h                |   1 +
 arch/ia64/include/asm/processor.h         |   2 +-
 arch/powerpc/kernel/signal_32.c           |  10 +-
 arch/powerpc/kernel/vio.c                 |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |  12 ++-
 arch/x86/kernel/microcode_amd.c           |   2 +-
 block/blk-core.c                          |   1 +
 block/blk-settings.c                      |   1 +
 block/blk-timeout.c                       |   3 +-
 crypto/ansi_cprng.c                       |   4 +-
 drivers/acpi/acpica/exoparg1.c            |  48 +++++++--
 drivers/acpi/acpica/exstore.c             | 151 ++++++++++++++++++--------
 drivers/block/brd.c                       |   2 +-
 drivers/block/loop.c                      |   2 +-
 drivers/hwmon/lm90.c                      |  11 +-
 drivers/net/can/c_can/c_can.c             |   6 +-
 drivers/net/ethernet/realtek/8139cp.c     |   1 +
 drivers/net/wireless/libertas/debugfs.c   |   6 +-
 drivers/net/wireless/rt2x00/rt2800usb.c   |  12 ++-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   3 +
 drivers/scsi/aacraid/commctrl.c           |   3 +-
 drivers/uio/uio.c                         |  16 ++-
 drivers/usb/serial/mos7840.c              |   4 +
 drivers/video/au1100fb.c                  |  26 +----
 drivers/video/au1200fb.c                  |  23 +---
 fs/configfs/dir.c                         |  16 ++-
 fs/dcache.c                               |  16 ++-
 fs/exec.c                                 |   9 ++
 fs/nfs/inode.c                            |   2 +
 fs/nfs/nfs3proc.c                         |   6 +-
 fs/nfs/nfs4filelayout.c                   |   1 -
 fs/nfs/nfs4proc.c                         |  19 +---
 fs/nfs/nfs4state.c                        |  21 ----
 fs/nfs/proc.c                             |  43 --------
 fs/nfsd/vfs.c                             | 173 +++++++++++++++++-------------
 fs/proc/inode.c                           |  12 +--
 include/linux/binfmts.h                   |   3 -
 include/linux/fs.h                        |   2 +
 include/linux/sched.h                     |  22 ++--
 kernel/ptrace.c                           |   3 +-
 kernel/trace/trace_event_perf.c           |   2 +-
 net/sunrpc/clnt.c                         |   1 +
 net/sunrpc/xprtsock.c                     |  28 +++--
 security/integrity/ima/ima_policy.c       |   1 -
 sound/isa/msnd/msnd_pinnacle.c            |   4 +-
 sound/usb/6fire/chip.c                    |   2 +-
 47 files changed, 411 insertions(+), 333 deletions(-)


