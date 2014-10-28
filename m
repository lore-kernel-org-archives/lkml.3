Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaJ1Dvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:51:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbaJ1Dvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:51:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/43] 3.10.59-stable review
Date: Tue, 28 Oct 2014 11:35:58 +0800
Message-Id: <20141028033523.407092670@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.59 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Oct 30 03:35:12 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.59-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.59-rc1

Chao Yu <chao2.yu@samsung.com>
    ecryptfs: avoid to access NULL pointer when write metadata in xattr

Ludovic Desroches <ludovic.desroches@atmel.com>
    ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks

Vlad Catoi <vladcatoi@gmail.com>
    ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Takashi Iwai <tiwai@suse.de>
    ALSA: emu10k1: Fix deadlock in synth voice lookup

Anatol Pomozov <anatol.pomozov@gmail.com>
    ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Victor Kamensky <victor.kamensky@linaro.org>
    arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mid: terminate ongoing transfers at exit

Sasha Levin <sasha.levin@oracle.com>
    kernel: add support for gcc 5

Yann Droneaud <ydroneaud@opteya.com>
    fanotify: enable close-on-exec on events' fd when requested in fanotify_init()

Junxiao Bi <junxiao.bi@oracle.com>
    mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

Champion Chen <champion_chen@realsil.com.cn>
    Bluetooth: Fix issue with USB suspend in btusb driver

Loic Poulain <loic.poulain@intel.com>
    Bluetooth: Fix HCI H5 corrupted ack value

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: correct BBP1_TX_POWER_CTRL mask

Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
    PCI: Generate uppercase hex for modalias interface class

Douglas Lehr <dllehr@us.ibm.com>
    PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Oren Givon <oren.givon@intel.com>
    iwlwifi: Add missing PCI IDs for the 7260 series

Andy Adamson <andros@netapp.com>
    NFSv4.1: Fix an NFSv4.1 state renewal regression

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: fix open/lock state recovery error handling

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails

Willy Tarreau <w@1wt.eu>
    lzo: check for length overrun in variable length encoding.

Willy Tarreau <w@1wt.eu>
    Revert "lzo: properly check for overruns"

Willy Tarreau <w@1wt.eu>
    Documentation: lzo: document part of the encoding

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in vmbus_open()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_post_msg()

Kees Cook <keescook@chromium.org>
    firmware_class: make sure fw requests contain a name

Arun Easi <arun.easi@qlogic.com>
    qla2xxx: Use correct offset to req-q-out for reserve calculation

Chris J Arges <chris.j.arges@canonical.com>
    mptfusion: enable no_write_same for vmware scsi disks

Mike Christie <michaelc@cs.wisc.edu>
    be2iscsi: check ip buffer before copying

Pankaj Dubey <pankaj.dubey@samsung.com>
    regmap: fix NULL pointer dereference in _regmap_write/read

Xiubo Li <Li.Xiubo@freescale.com>
    regmap: debugfs: fix possbile NULL pointer dereference

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mid: check that DMA was inited before exit

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mid: respect 8 bit mode

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

David Matlack <dmatlack@google.com>
    kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: unintended fallthrough for external call

David Matlack <dmatlack@google.com>
    kvm: x86: fix stale mmio cache bug

Andy Lutomirski <luto@amacapital.net>
    fs: Add a missing permission check to do_umount

Sage Weil <sage@redhat.com>
    Btrfs: fix race in WAIT_SYNC ioctl

Josef Bacik <jbacik@fb.com>
    Btrfs: fix build_backref_tree issue with multiple shared blocks

Josef Bacik <jbacik@fb.com>
    Btrfs: try not to ENOSPC on log replay


-------------

Diffstat:

 Documentation/lzo.txt                   | 164 ++++++++++++++++++++++++++++++++
 Makefile                                |   4 +-
 arch/arm/mach-at91/clock.c              |   1 +
 arch/arm64/include/asm/compat.h         |   4 +-
 arch/m68k/mm/hwtest.c                   |   6 ++
 arch/s390/kvm/interrupt.c               |   1 +
 arch/x86/include/asm/kvm_host.h         |   1 +
 arch/x86/kernel/cpu/intel.c             |  15 +++
 arch/x86/kvm/mmu.c                      |   2 +-
 arch/x86/kvm/x86.h                      |  20 +++-
 drivers/base/firmware_class.c           |   3 +
 drivers/base/regmap/regmap-debugfs.c    |   8 +-
 drivers/base/regmap/regmap.c            |   4 +-
 drivers/bluetooth/btusb.c               |   9 ++
 drivers/bluetooth/hci_h5.c              |   2 +-
 drivers/hv/channel.c                    |  20 ++--
 drivers/hv/connection.c                 |  17 +++-
 drivers/message/fusion/mptspi.c         |   5 +
 drivers/net/wireless/iwlwifi/pcie/drv.c |   4 +
 drivers/net/wireless/rt2x00/rt2800.h    |   2 +-
 drivers/pci/pci-sysfs.c                 |   2 +-
 drivers/pci/quirks.c                    |  20 ++++
 drivers/scsi/be2iscsi/be_mgmt.c         |  13 ++-
 drivers/scsi/qla2xxx/qla_target.c       |   4 +-
 drivers/spi/spi-dw-mid.c                |  10 +-
 fs/btrfs/inode.c                        |   3 +-
 fs/btrfs/relocation.c                   |   5 +-
 fs/btrfs/transaction.c                  |  12 ++-
 fs/ecryptfs/inode.c                     |   2 +-
 fs/namespace.c                          |   2 +
 fs/nfs/nfs4proc.c                       |   2 +-
 fs/nfs/nfs4renewd.c                     |  12 ++-
 fs/nfs/nfs4state.c                      |  17 ++--
 fs/notify/fanotify/fanotify_user.c      |   2 +-
 include/linux/compiler-gcc5.h           |  66 +++++++++++++
 include/linux/sched.h                   |   6 +-
 lib/lzo/lzo1x_decompress_safe.c         | 103 +++++++++++---------
 sound/core/pcm_native.c                 |   2 +-
 sound/pci/emu10k1/emu10k1_callback.c    |   6 +-
 sound/usb/quirks-table.h                |  30 ++++++
 virt/kvm/kvm_main.c                     |   4 +
 41 files changed, 501 insertions(+), 114 deletions(-)


