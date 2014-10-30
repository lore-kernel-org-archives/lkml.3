Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbaJ3QxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:53:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaJ3Qw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:52:58 -0400
Date: Thu, 30 Oct 2014 09:51:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.59
Message-ID: <20141030165146.GA7041@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.59 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/lzo.txt                   |  164 +++++++++++++++++++++++++++=
+++++
 Makefile                                |    2=20
 arch/arm/mach-at91/clock.c              |    1=20
 arch/arm64/include/asm/compat.h         |    4=20
 arch/m68k/mm/hwtest.c                   |    6 +
 arch/s390/kvm/interrupt.c               |    1=20
 arch/x86/include/asm/kvm_host.h         |    1=20
 arch/x86/kernel/cpu/intel.c             |   15 ++
 arch/x86/kvm/mmu.c                      |    2=20
 arch/x86/kvm/x86.h                      |   20 ++-
 drivers/base/firmware_class.c           |    3=20
 drivers/base/regmap/regmap-debugfs.c    |    8 +
 drivers/base/regmap/regmap.c            |    4=20
 drivers/bluetooth/btusb.c               |    9 +
 drivers/bluetooth/hci_h5.c              |    2=20
 drivers/hv/channel.c                    |   20 +--
 drivers/hv/connection.c                 |   17 ++-
 drivers/message/fusion/mptspi.c         |    5=20
 drivers/net/wireless/iwlwifi/pcie/drv.c |    4=20
 drivers/net/wireless/rt2x00/rt2800.h    |    2=20
 drivers/pci/pci-sysfs.c                 |    2=20
 drivers/pci/quirks.c                    |   20 +++
 drivers/scsi/be2iscsi/be_mgmt.c         |   13 +-
 drivers/scsi/qla2xxx/qla_target.c       |    4=20
 drivers/spi/spi-dw-mid.c                |   10 +
 fs/btrfs/inode.c                        |    3=20
 fs/btrfs/relocation.c                   |    5=20
 fs/btrfs/transaction.c                  |   12 +-
 fs/ecryptfs/inode.c                     |    2=20
 fs/namespace.c                          |    2=20
 fs/nfs/nfs4proc.c                       |    2=20
 fs/nfs/nfs4renewd.c                     |   12 +-
 fs/nfs/nfs4state.c                      |   17 +--
 fs/notify/fanotify/fanotify_user.c      |    2=20
 include/linux/compiler-gcc5.h           |   66 ++++++++++++
 include/linux/sched.h                   |    6 -
 lib/lzo/lzo1x_decompress_safe.c         |  103 +++++++++++---------
 sound/core/pcm_native.c                 |    2=20
 sound/pci/emu10k1/emu10k1_callback.c    |    6 -
 sound/usb/quirks-table.h                |   30 +++++
 virt/kvm/kvm_main.c                     |    4=20
 41 files changed, 500 insertions(+), 113 deletions(-)

Anatol Pomozov (1):
      ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Andy Adamson (1):
      NFSv4.1: Fix an NFSv4.1 state renewal regression

Andy Lutomirski (1):
      fs: Add a missing permission check to do_umount

Andy Shevchenko (3):
      spi: dw-mid: respect 8 bit mode
      spi: dw-mid: check that DMA was inited before exit
      spi: dw-mid: terminate ongoing transfers at exit

Arun Easi (1):
      qla2xxx: Use correct offset to req-q-out for reserve calculation

Bryan O'Donoghue (1):
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr

Chris J Arges (1):
      mptfusion: enable no_write_same for vmware scsi disks

Christian Borntraeger (1):
      KVM: s390: unintended fallthrough for external call

David Matlack (2):
      kvm: x86: fix stale mmio cache bug
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Geert Uytterhoeven (1):
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Greg Kroah-Hartman (1):
      Linux 3.10.59

Josef Bacik (2):
      Btrfs: try not to ENOSPC on log replay
      Btrfs: fix build_backref_tree issue with multiple shared blocks

Junxiao Bi (1):
      mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

K. Y. Srinivasan (4):
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
      Drivers: hv: vmbus: Fix a bug in vmbus_open()

Kees Cook (1):
      firmware_class: make sure fw requests contain a name

Loic Poulain (1):
      Bluetooth: Fix HCI H5 corrupted ack value

Ludovic Desroches (1):
      ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clo=
cks

Mike Christie (1):
      be2iscsi: check ip buffer before copying

Oren Givon (1):
      iwlwifi: Add missing PCI IDs for the 7260 series

Pankaj Dubey (1):
      regmap: fix NULL pointer dereference in _regmap_write/read

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class

Sage Weil (1):
      Btrfs: fix race in WAIT_SYNC ioctl

Sasha Levin (1):
      kernel: add support for gcc 5

Stanislaw Gruszka (1):
      rt2800: correct BBP1_TX_POWER_CTRL mask

Takashi Iwai (1):
      ALSA: emu10k1: Fix deadlock in synth voice lookup

Trond Myklebust (2):
      NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails
      NFSv4: fix open/lock state recovery error handling

Victor Kamensky (1):
      arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Vlad Catoi (1):
      ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

Xiubo Li (1):
      regmap: debugfs: fix possbile NULL pointer dereference

Yann Droneaud (1):
      fanotify: enable close-on-exec on events' fd when requested in fanoti=
fy_init()


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUmyiAAoJEDjbvchgkmk+NKQP/3eswhLmKH68qMY1ihGYhvRu
IuWpTohfx+sKuclJJ7kR1n/HPhBZlHoAMnLubS3ayiPp1AyjivWW5wvxlmGPcsgP
A612W1c6ENeqAYJTbuK8brU/5I4WePnqlYZZN5/5jzXAm6y6D1s9toCO50N7Q1B5
eFfYK51mYP9Cqc8AkiRrZ+kqBHap3Q3WNyySEJyHzahsl/VsdhwKORXZl69ovKrb
du3BS3x4R5KaLX/OIYWPM1M3qqAKHR1k4/z5zxfDxNvthR50ddqqjCCtx3JMYJ4k
0yhdWUu++3SnoxFogKK3RK42ZQ+gIy9f0j/vkhOzlJfsiX7R0IqHRyktTdYtAXRb
IlZXjLlA37XptGbmEt5Gp1o55D9P+sZKXJGTgxU3lwnHLoRGtHKkvzb8FIeemYVo
k4PfthSgE/rGHEhpC4XjELnexV3MXvtf+GIIYM+zHVCepmccwlrYe8Czg6zESFt+
X5NiFoaKvlPr2rqhrhCsU0qA681GbZCQ5p/oNIzJcOdi5wUY70/ndEFTs/Rrjq4j
SAWSYPYd0ixO44+TdUZkJ/wWuK7f+WvLQlokVs4MCSlkqcza9mCi9FLhVTt4uiEr
RiYRjYntd89OumUMB9pEVAhQMg00wizdKmubOKe6vd6GeOOXhPmh4XLBaSDpsk5B
+la3rAwA4Qfxb41+mIET
=k0W5
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
