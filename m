Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3G0OSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 10:18:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59392 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab3G0OSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 10:18:45 -0400
Message-ID: <1374934704.13555.10.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.49
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sat, 27 Jul 2013 15:18:24 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-41g9vh8yekW25sSNgMyg"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-41g9vh8yekW25sSNgMyg
Content-Type: multipart/mixed; boundary="=-zTa+OcuBroNTlxkppPYm"


--=-zTa+OcuBroNTlxkppPYm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.49 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.48 is attached to this message.

Ben.

------------

 Documentation/i2c/busses/i2c-piix4             |   2 +-
 MAINTAINERS                                    |  30 +--
 Makefile                                       |   2 +-
 arch/arm/kernel/perf_event.c                   |   1 +
 arch/powerpc/kernel/setup_64.c                 |   2 +-
 arch/x86/xen/time.c                            |  17 +-
 block/genhd.c                                  |   2 +-
 crypto/algapi.c                                |   3 +-
 drivers/ata/ahci.c                             |   2 +
 drivers/ata/ata_piix.c                         |   2 +
 drivers/ata/libahci.c                          |   3 +-
 drivers/ata/libata-pmp.c                       |  33 ++--
 drivers/block/nbd.c                            |  10 +-
 drivers/cdrom/cdrom.c                          |   2 +-
 drivers/dma/pl330.c                            |   4 +-
 drivers/hv/ring_buffer.c                       |   2 +-
 drivers/hv/vmbus_drv.c                         |   2 +-
 drivers/i2c/busses/Kconfig                     |   1 +
 drivers/i2c/busses/i2c-piix4.c                 |   3 +-
 drivers/iommu/amd_iommu.c                      |   6 +-
 drivers/media/dvb/dvb-core/dmxdev.c            |   8 +-
 drivers/net/ethernet/realtek/r8169.c           |   8 -
 drivers/net/wan/dlci.c                         |  26 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   2 +
 drivers/net/wireless/ath/ath9k/calib.c         |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c            |   3 +-
 drivers/net/wireless/ath/ath9k/hw.h            |   1 +
 drivers/net/wireless/ath/ath9k/main.c          |   7 -
 drivers/net/wireless/b43/Kconfig               |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c    |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c    |   1 +
 drivers/pci/quirks.c                           |   2 +
 drivers/rtc/rtc-rv3029c2.c                     |   2 +-
 drivers/s390/scsi/zfcp_aux.c                   |   5 +-
 drivers/s390/scsi/zfcp_fsf.c                   |  25 ++-
 drivers/s390/scsi/zfcp_scsi.c                  |  10 +-
 drivers/scsi/megaraid/megaraid_sas_base.c      |  10 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c            |  13 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h            |   3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           | 132 ++++++++++++-
 drivers/scsi/osd/osd_uld.c                     |   2 +-
 drivers/scsi/sd.c                              |  20 ++
 drivers/scsi/sd.h                              |   1 +
 drivers/staging/zram/zram_drv.c                |  36 ++--
 drivers/staging/zram/zram_drv.h                |   5 +-
 drivers/staging/zram/zram_sysfs.c              |   2 +
 drivers/target/iscsi/iscsi_target_configfs.c   |   2 +-
 drivers/tty/serial/8250_pci.c                  |   4 -
 drivers/tty/serial/pch_uart.c                  |  29 ++-
 drivers/usb/gadget/f_mass_storage.c            |   2 +
 drivers/usb/host/xhci-mem.c                    |   4 +
 drivers/usb/serial/option.c                    |   4 -
 drivers/usb/serial/qcserial.c                  |   8 +-
 drivers/video/console/vgacon.c                 |  17 +-
 fs/block_dev.c                                 |   9 +-
 fs/ceph/super.c                                |   7 +-
 fs/ceph/super.h                                |   2 +-
 fs/cifs/cifs_unicode.h                         |   8 +-
 fs/cifs/cifsencrypt.c                          |   6 +-
 fs/exec.c                                      |  16 +-
 fs/ext3/namei.c                                |   7 +-
 fs/ext4/extents.c                              |   4 +-
 fs/ext4/inode.c                                |   4 +-
 fs/ext4/namei.c                                |   7 +-
 fs/hpfs/map.c                                  |   3 +-
 fs/hpfs/super.c                                |   8 +-
 fs/jbd2/transaction.c                          |   2 +-
 fs/nfsd/nfs4xdr.c                              |   2 +-
 fs/ocfs2/xattr.c                               |  10 +
 fs/ubifs/dir.c                                 |  54 ++++--
 include/linux/cgroup.h                         |  52 ++++-
 include/linux/hugetlb.h                        |  16 ++
 include/linux/nbd.h                            |   1 +
 include/linux/perf_event.h                     |   3 +-
 kernel/events/core.c                           | 258 ++++++++++++++++++---=
----
 kernel/events/hw_breakpoint.c                  |   4 +-
 kernel/events/internal.h                       |   4 +
 kernel/futex.c                                 |   3 +-
 kernel/irq/manage.c                            |   6 +-
 kernel/printk.c                                |   2 +-
 kernel/timer.c                                 |   8 +-
 kernel/trace/trace_syscalls.c                  |  21 +-
 mm/hugetlb.c                                   |  17 ++
 net/bluetooth/l2cap_core.c                     |   5 +-
 net/ceph/auth_none.c                           |   6 +
 sound/pci/hda/patch_hdmi.c                     |   2 +-
 sound/soc/codecs/wm8962.c                      |  24 +--
 88 files changed, 796 insertions(+), 324 deletions(-)

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree(=
)

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Ben Hutchings (4):
      r8169: fix offloaded tx checksum for small packets.
      sd: Fix parsing of 'temporary ' cache mode prefix
      genirq: Fix can_request_irq() for IRQs without an action
      Linux 3.2.49

Bj=C3=B8rn Mork (1):
      megaraid_sas: fix memory leak if SGL has zero length entries

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Chen Gang (1):
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spi=
nning_secondaries

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Daniel Hansel (1):
      zfcp: fix adapter (re)open recovery while link to SAN is down

Greg KH (1):
      MAINTAINERS: Greg's suse email address is dead

Greg Kroah-Hartman (2):
      Revert "serial: 8250_pci: add support for another kind of NetMos Tech=
nology PCI 9835 Multi-I/O Controller"
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer informa=
tion

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

James Bottomley (1):
      sd: fix array cache flushing bug causing performance problems

Jan Kara (3):
      writeback: Fix periodic writeback after fs mount
      ext4: fix overflow when counting used blocks on 32-bit architectures
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs

Jason Wang (1):
      drivers: hv: switch to use mb() instead of smp_mb()

Jed Davis (1):
      ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Jiang Liu (5):
      zram: avoid invalid memory access in zram_exit()
      zram: use zram->lock to protect zram_free_page() in swap free notify =
path
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid access beyond the zram device
      zram: protect sysfs handler from invalid memory access

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid =
scenario

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

J=C3=B6rn Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

Kees Cook (2):
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string

Larry Finger (2):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
      rtlwifi: rtl8192cu: Fix duplicate if test

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Liang Li (1):
      pch_uart: fix a deadlock when pch_uart as console

Marcelo Tosatti (1):
      vgacon.c: add cond reschedule points in vgacon_do_font_op

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Mikulas Patocka (1):
      hpfs: better test for errors

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Paul Clements (1):
      nbd: correct disconnect behavior

Peter Zijlstra (3):
      perf: Fix perf_lock_task_context() vs RCU
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Rajkumar Manoharan (1):
      ath9k: fill channel mode in caldata

Reddy, Sreekanth (1):
      mpt2sas: Fix for issue Missing delay not getting set during system bo=
otup

Sage Weil (1):
      ceph: fix statvfs fr_size

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (3):
      ahci: Add AMD CZ SATA device ID
      i2c-piix4: Add AMD CZ SMBus device ID
      ahci: remove pmp link online check in FBS EH

Soeren Moch (1):
      media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Sreekanth Reddy (2):
      mpt2sas: Fix for device scan following host reset could get stuck in =
a infinite loop
      mpt2sas: fix firmware failure with wrong task attribute

Steffen Maier (2):
      zfcp: block queue limits with data router
      zfcp: status read buffers on first adapter open with link down

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Steve French (1):
      Handle big endianness in NTLM (ntlmv2) authentication

Sujith Manoharan (3):
      ath9k_hw: Assign default xlna config for AR9485
      ath9k: Fix noisefloor calibration
      ath9k: Do not assign noise for NULL caldata

Takashi Iwai (1):
      ALSA: hda - Cache the MUX selection for generic HDMI

Tejun Heo (2):
      libata: skip SRST for all SIMG [34]7x port-multipliers
      cgroup: fix RCU accesses to task->cgroups

Theodore Ts'o (1):
      jbd2: fix theoretical race in jbd2__journal_restart

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wa=
keup_needed

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

zhangwei(Jovi) (1):
      tracing: Fix irqs-off tag display in syscall tracing



--=-zTa+OcuBroNTlxkppPYm
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.49.patch"
Content-Disposition: attachment; filename="linux-3.2.49.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vaTJjL2J1c3Nlcy9pMmMtcGlpeDQgYi9Eb2N1bWVu
dGF0aW9uL2kyYy9idXNzZXMvaTJjLXBpaXg0DQppbmRleCA0NzViYjRhLi42NWRhMTU3IDEwMDY0
NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9pMmMvYnVzc2VzL2kyYy1waWl4NA0KKysrIGIvRG9jdW1l
bnRhdGlvbi9pMmMvYnVzc2VzL2kyYy1waWl4NA0KQEAgLTgsNyArOCw3IEBAIFN1cHBvcnRlZCBh
ZGFwdGVyczoNCiAgICAgRGF0YXNoZWV0OiBPbmx5IGF2YWlsYWJsZSB2aWEgTkRBIGZyb20gU2Vy
dmVyV29ya3MNCiAgICogQVRJIElYUDIwMCwgSVhQMzAwLCBJWFA0MDAsIFNCNjAwLCBTQjcwMCBh
bmQgU0I4MDAgc291dGhicmlkZ2VzDQogICAgIERhdGFzaGVldDogTm90IHB1YmxpY2x5IGF2YWls
YWJsZQ0KLSAgKiBBTUQgSHVkc29uLTINCisgICogQU1EIEh1ZHNvbi0yLCBDWg0KICAgICBEYXRh
c2hlZXQ6IE5vdCBwdWJsaWNseSBhdmFpbGFibGUNCiAgICogU3RhbmRhcmQgTWljcm9zeXN0ZW1z
IChTTVNDKSBTTEM5MEU2NiAoVmljdG9yeTY2KSBzb3V0aGJyaWRnZQ0KICAgICBEYXRhc2hlZXQ6
IFB1YmxpY2x5IGF2YWlsYWJsZSBhdCB0aGUgU01TQyB3ZWJzaXRlIGh0dHA6Ly93d3cuc21zYy5j
b20NCmRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQppbmRleCA4M2YxNTZl
Li44NjU5ZWJhIDEwMDY0NA0KLS0tIGEvTUFJTlRBSU5FUlMNCisrKyBiL01BSU5UQUlORVJTDQpA
QCAtMTU5LDcgKzE1OSw3IEBAIFM6CU1haW50YWluZWQNCiBGOglkcml2ZXJzL25ldC9ldGhlcm5l
dC9yZWFsdGVrL3I4MTY5LmMNCiANCiA4MjUwLzE2PzUwIChBTkQgQ0xPTkUgVUFSVFMpIFNFUklB
TCBEUklWRVINCi1NOglHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBzdXNlLmRlPg0KK006CUdy
ZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQogTDoJbGludXgt
c2VyaWFsQHZnZXIua2VybmVsLm9yZw0KIFc6CWh0dHA6Ly9zZXJpYWwuc291cmNlZm9yZ2UubmV0
DQogUzoJTWFpbnRhaW5lZA0KQEAgLTE3ODEsOSArMTc4MSw5IEBAIFg6CW5ldC93aXJlbGVzcy93
ZXh0Kg0KIA0KIENIQVIgYW5kIE1JU0MgRFJJVkVSUw0KIE06CUFybmQgQmVyZ21hbm4gPGFybmRA
YXJuZGIuZGU+DQotTToJR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVnQGtyb2FoLmNvbT4NCitNOglH
cmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KIFQ6CWdpdCBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL2NoYXIt
bWlzYy5naXQNCi1TOglNYWludGFpbmVkDQorUzoJU3VwcG9ydGVkDQogRjoJZHJpdmVycy9jaGFy
LyoNCiBGOglkcml2ZXJzL21pc2MvKg0KIA0KQEAgLTIzMTUsNyArMjMxNSw3IEBAIEY6CWxpYi9s
cnVfY2FjaGUuYw0KIEY6CURvY3VtZW50YXRpb24vYmxvY2tkZXYvZHJiZC8NCiANCiBEUklWRVIg
Q09SRSwgS09CSkVDVFMsIERFQlVHRlMgQU5EIFNZU0ZTDQotTToJR3JlZyBLcm9haC1IYXJ0bWFu
IDxncmVna2hAc3VzZS5kZT4NCitNOglHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KIFQ6CWdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvZ3JlZ2toL2RyaXZlci1jb3JlLTIuNi5naXQNCiBTOglTdXBwb3J0ZWQNCiBG
OglEb2N1bWVudGF0aW9uL2tvYmplY3QudHh0DQpAQCAtNjI1NywxNSArNjI1NywxNiBAQCBTOglN
YWludGFpbmVkDQogRjoJYXJjaC9hbHBoYS9rZXJuZWwvc3JtX2Vudi5jDQogDQogU1RBQkxFIEJS
QU5DSA0KLU06CUdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ0Brcm9haC5jb20+DQorTToJR3JlZyBL
cm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCiBMOglzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQotUzoJTWFpbnRhaW5lZA0KK1M6CVN1cHBvcnRlZA0KK0Y6CURvY3VtZW50
YXRpb24vc3RhYmxlX2tlcm5lbF9ydWxlcy50eHQNCiANCiBTVEFHSU5HIFNVQlNZU1RFTQ0KLU06
CUdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQHN1c2UuZGU+DQorTToJR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCiBUOglnaXQgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC9zdGFnaW5nLmdpdA0KIEw6CWRl
dmVsQGRyaXZlcmRldi5vc3Vvc2wub3JnDQotUzoJTWFpbnRhaW5lZA0KK1M6CVN1cHBvcnRlZA0K
IEY6CWRyaXZlcnMvc3RhZ2luZy8NCiANCiBTVEFHSU5HIC0gQUdFUkUgSEVSTUVTIElJIGFuZCBJ
SS41IFdJUkVMRVNTIERSSVZFUlMNCkBAIC02NjU0LDggKzY2NTUsOCBAQCBTOglNYWludGFpbmVk
DQogSzoJXlN1YmplY3Q6LiooP2kpdHJpdmlhbA0KIA0KIFRUWSBMQVlFUg0KLU06CUdyZWcgS3Jv
YWgtSGFydG1hbiA8Z3JlZ2toQHN1c2UuZGU+DQotUzoJTWFpbnRhaW5lZA0KK006CUdyZWcgS3Jv
YWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQorUzoJU3VwcG9ydGVkDQog
VDoJZ2l0IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVn
a2gvdHR5LTIuNi5naXQNCiBGOglkcml2ZXJzL3R0eS8qDQogRjoJZHJpdmVycy90dHkvc2VyaWFs
L3NlcmlhbF9jb3JlLmMNCkBAIC02OTQzLDcgKzY5NDQsNyBAQCBTOglNYWludGFpbmVkDQogRjoJ
ZHJpdmVycy91c2Ivc2VyaWFsL2RpZ2lfYWNjZWxlcG9ydC5jDQogDQogVVNCIFNFUklBTCBEUklW
RVINCi1NOglHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBzdXNlLmRlPg0KK006CUdyZWcgS3Jv
YWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQogTDoJbGludXgtdXNiQHZn
ZXIua2VybmVsLm9yZw0KIFM6CVN1cHBvcnRlZA0KIEY6CURvY3VtZW50YXRpb24vdXNiL3VzYi1z
ZXJpYWwudHh0DQpAQCAtNjk1OCw5ICs2OTU5LDggQEAgUzoJTWFpbnRhaW5lZA0KIEY6CWRyaXZl
cnMvdXNiL3NlcmlhbC9lbXBlZy5jDQogDQogVVNCIFNFUklBTCBLRVlTUEFOIERSSVZFUg0KLU06
CUdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ0Brcm9haC5jb20+DQorTToJR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCiBMOglsaW51eC11c2JAdmdlci5rZXJu
ZWwub3JnDQotVzoJaHR0cDovL3d3dy5rcm9haC5jb20vbGludXgvDQogUzoJTWFpbnRhaW5lZA0K
IEY6CWRyaXZlcnMvdXNiL3NlcmlhbC8qa2V5c3BhbioNCiANCkBAIC02OTg4LDcgKzY5ODgsNyBA
QCBGOglEb2N1bWVudGF0aW9uL3ZpZGVvNGxpbnV4L3NuOWMxMDIudHh0DQogRjoJZHJpdmVycy9t
ZWRpYS92aWRlby9zbjljMTAyLw0KIA0KIFVTQiBTVUJTWVNURU0NCi1NOglHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBzdXNlLmRlPg0KK006CUdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmc+DQogTDoJbGludXgtdXNiQHZnZXIua2VybmVsLm9yZw0KIFc6CWh0
dHA6Ly93d3cubGludXgtdXNiLm9yZw0KIFQ6CWdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL3VzYi0yLjYuZ2l0DQpAQCAtNzA3NSw3ICs3MDc1
LDcgQEAgRjoJZnMvaHBwZnMvDQogDQogVVNFUlNQQUNFIEkvTyAoVUlPKQ0KIE06CSJIYW5zIEou
IEtvY2giIDxoamtAaGFuc2prb2NoLmRlPg0KLU06CUdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2to
QHN1c2UuZGU+DQorTToJR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZz4NCiBTOglNYWludGFpbmVkDQogRjoJRG9jdW1lbnRhdGlvbi9Eb2NCb29rL3Vpby1ob3d0
by50bXBsDQogRjoJZHJpdmVycy91aW8vDQpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmls
ZQ0KaW5kZXggMjk5ZTJlYi4uMmUzZDc5MSAxMDA2NDQNCi0tLSBhL01ha2VmaWxlDQorKysgYi9N
YWtlZmlsZQ0KQEAgLTEsNiArMSw2IEBADQogVkVSU0lPTiA9IDMNCiBQQVRDSExFVkVMID0gMg0K
LVNVQkxFVkVMID0gNDgNCitTVUJMRVZFTCA9IDQ5DQogRVhUUkFWRVJTSU9OID0NCiBOQU1FID0g
U2FiZXItdG9vdGhlZCBTcXVpcnJlbA0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2tlcm5lbC9w
ZXJmX2V2ZW50LmMgYi9hcmNoL2FybS9rZXJuZWwvcGVyZl9ldmVudC5jDQppbmRleCBhNTU5ZWU3
Li43NzhkMjQ4IDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0va2VybmVsL3BlcmZfZXZlbnQuYw0KKysr
IGIvYXJjaC9hcm0va2VybmVsL3BlcmZfZXZlbnQuYw0KQEAgLTc5NSw2ICs3OTUsNyBAQCBwZXJm
X2NhbGxjaGFpbl91c2VyKHN0cnVjdCBwZXJmX2NhbGxjaGFpbl9lbnRyeSAqZW50cnksIHN0cnVj
dCBwdF9yZWdzICpyZWdzKQ0KIAlzdHJ1Y3QgZnJhbWVfdGFpbCBfX3VzZXIgKnRhaWw7DQogDQog
DQorCXBlcmZfY2FsbGNoYWluX3N0b3JlKGVudHJ5LCByZWdzLT5BUk1fcGMpOw0KIAl0YWlsID0g
KHN0cnVjdCBmcmFtZV90YWlsIF9fdXNlciAqKXJlZ3MtPkFSTV9mcCAtIDE7DQogDQogCXdoaWxl
ICgoZW50cnktPm5yIDwgUEVSRl9NQVhfU1RBQ0tfREVQVEgpICYmDQpkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC9zZXR1cF82NC5jIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9zZXR1cF82
NC5jDQppbmRleCBmYjliYjQ2Li4yYzg4OTBhIDEwMDY0NA0KLS0tIGEvYXJjaC9wb3dlcnBjL2tl
cm5lbC9zZXR1cF82NC5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3NldHVwXzY0LmMNCkBA
IC03NCw3ICs3NCw3IEBADQogI2VuZGlmDQogDQogaW50IGJvb3RfY3B1aWQgPSAwOw0KLWludCBf
X2luaXRkYXRhIHNwaW5uaW5nX3NlY29uZGFyaWVzOw0KK2ludCBzcGlubmluZ19zZWNvbmRhcmll
czsNCiB1NjQgcHBjNjRfcGZ0X3NpemU7DQogDQogLyogUGljayBkZWZhdWx0cyBzaW5jZSB3ZSBt
aWdodCB3YW50IHRvIHBhdGNoIGluc3RydWN0aW9ucw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hl
bi90aW1lLmMgYi9hcmNoL3g4Ni94ZW4vdGltZS5jDQppbmRleCAwNTRjYzAxLi5kNTBhODIxIDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYveGVuL3RpbWUuYw0KKysrIGIvYXJjaC94ODYveGVuL3RpbWUu
Yw0KQEAgLTM2LDkgKzM2LDggQEAgc3RhdGljIERFRklORV9QRVJfQ1BVKHN0cnVjdCB2Y3B1X3J1
bnN0YXRlX2luZm8sIHhlbl9ydW5zdGF0ZSk7DQogLyogc25hcHNob3RzIG9mIHJ1bnN0YXRlIGlu
Zm8gKi8NCiBzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHZjcHVfcnVuc3RhdGVfaW5mbywg
eGVuX3J1bnN0YXRlX3NuYXBzaG90KTsNCiANCi0vKiB1bnVzZWQgbnMgb2Ygc3RvbGVuIGFuZCBi
bG9ja2VkIHRpbWUgKi8NCisvKiB1bnVzZWQgbnMgb2Ygc3RvbGVuIHRpbWUgKi8NCiBzdGF0aWMg
REVGSU5FX1BFUl9DUFUodTY0LCB4ZW5fcmVzaWR1YWxfc3RvbGVuKTsNCi1zdGF0aWMgREVGSU5F
X1BFUl9DUFUodTY0LCB4ZW5fcmVzaWR1YWxfYmxvY2tlZCk7DQogDQogLyogcmV0dXJuIGFuIGNv
bnNpc3RlbnQgc25hcHNob3Qgb2YgNjQtYml0IHRpbWUvY291bnRlciB2YWx1ZSAqLw0KIHN0YXRp
YyB1NjQgZ2V0NjQoY29uc3QgdTY0ICpwKQ0KQEAgLTExNSw3ICsxMTQsNyBAQCBzdGF0aWMgdm9p
ZCBkb19zdG9sZW5fYWNjb3VudGluZyh2b2lkKQ0KIHsNCiAJc3RydWN0IHZjcHVfcnVuc3RhdGVf
aW5mbyBzdGF0ZTsNCiAJc3RydWN0IHZjcHVfcnVuc3RhdGVfaW5mbyAqc25hcDsNCi0JczY0IGJs
b2NrZWQsIHJ1bm5hYmxlLCBvZmZsaW5lLCBzdG9sZW47DQorCXM2NCBydW5uYWJsZSwgb2ZmbGlu
ZSwgc3RvbGVuOw0KIAljcHV0aW1lX3QgdGlja3M7DQogDQogCWdldF9ydW5zdGF0ZV9zbmFwc2hv
dCgmc3RhdGUpOw0KQEAgLTEyNSw3ICsxMjQsNiBAQCBzdGF0aWMgdm9pZCBkb19zdG9sZW5fYWNj
b3VudGluZyh2b2lkKQ0KIAlzbmFwID0gJl9fZ2V0X2NwdV92YXIoeGVuX3J1bnN0YXRlX3NuYXBz
aG90KTsNCiANCiAJLyogd29yayBvdXQgaG93IG11Y2ggdGltZSB0aGUgVkNQVSBoYXMgbm90IGJl
ZW4gcnVubippbmcqICAqLw0KLQlibG9ja2VkID0gc3RhdGUudGltZVtSVU5TVEFURV9ibG9ja2Vk
XSAtIHNuYXAtPnRpbWVbUlVOU1RBVEVfYmxvY2tlZF07DQogCXJ1bm5hYmxlID0gc3RhdGUudGlt
ZVtSVU5TVEFURV9ydW5uYWJsZV0gLSBzbmFwLT50aW1lW1JVTlNUQVRFX3J1bm5hYmxlXTsNCiAJ
b2ZmbGluZSA9IHN0YXRlLnRpbWVbUlVOU1RBVEVfb2ZmbGluZV0gLSBzbmFwLT50aW1lW1JVTlNU
QVRFX29mZmxpbmVdOw0KIA0KQEAgLTE0MSwxNyArMTM5LDYgQEAgc3RhdGljIHZvaWQgZG9fc3Rv
bGVuX2FjY291bnRpbmcodm9pZCkNCiAJdGlja3MgPSBpdGVyX2Rpdl91NjRfcmVtKHN0b2xlbiwg
TlNfUEVSX1RJQ0ssICZzdG9sZW4pOw0KIAlfX3RoaXNfY3B1X3dyaXRlKHhlbl9yZXNpZHVhbF9z
dG9sZW4sIHN0b2xlbik7DQogCWFjY291bnRfc3RlYWxfdGlja3ModGlja3MpOw0KLQ0KLQkvKiBB
ZGQgdGhlIGFwcHJvcHJpYXRlIG51bWJlciBvZiB0aWNrcyBvZiBibG9ja2VkIHRpbWUsDQotCSAg
IGluY2x1ZGluZyBhbnkgbGVmdC1vdmVycyBmcm9tIGxhc3QgdGltZS4gKi8NCi0JYmxvY2tlZCAr
PSBfX3RoaXNfY3B1X3JlYWQoeGVuX3Jlc2lkdWFsX2Jsb2NrZWQpOw0KLQ0KLQlpZiAoYmxvY2tl
ZCA8IDApDQotCQlibG9ja2VkID0gMDsNCi0NCi0JdGlja3MgPSBpdGVyX2Rpdl91NjRfcmVtKGJs
b2NrZWQsIE5TX1BFUl9USUNLLCAmYmxvY2tlZCk7DQotCV9fdGhpc19jcHVfd3JpdGUoeGVuX3Jl
c2lkdWFsX2Jsb2NrZWQsIGJsb2NrZWQpOw0KLQlhY2NvdW50X2lkbGVfdGlja3ModGlja3MpOw0K
IH0NCiANCiAvKiBHZXQgdGhlIFRTQyBzcGVlZCBmcm9tIFhlbiAqLw0KZGlmZiAtLWdpdCBhL2Js
b2NrL2dlbmhkLmMgYi9ibG9jay9nZW5oZC5jDQppbmRleCA2ZWRmMjI4Li44YmQ0ZWYyIDEwMDY0
NA0KLS0tIGEvYmxvY2svZ2VuaGQuYw0KKysrIGIvYmxvY2svZ2VuaGQuYw0KQEAgLTUxOSw3ICs1
MTksNyBAQCB2b2lkIHJlZ2lzdGVyX2Rpc2soc3RydWN0IGdlbmRpc2sgKmRpc2spDQogDQogCWRk
ZXYtPnBhcmVudCA9IGRpc2stPmRyaXZlcmZzX2RldjsNCiANCi0JZGV2X3NldF9uYW1lKGRkZXYs
IGRpc2stPmRpc2tfbmFtZSk7DQorCWRldl9zZXRfbmFtZShkZGV2LCAiJXMiLCBkaXNrLT5kaXNr
X25hbWUpOw0KIA0KIAkvKiBkZWxheSB1ZXZlbnRzLCB1bnRpbCB3ZSBzY2FubmVkIHBhcnRpdGlv
biB0YWJsZSAqLw0KIAlkZXZfc2V0X3VldmVudF9zdXBwcmVzcyhkZGV2LCAxKTsNCmRpZmYgLS1n
aXQgYS9jcnlwdG8vYWxnYXBpLmMgYi9jcnlwdG8vYWxnYXBpLmMNCmluZGV4IDU0ZGQ0ZTMuLmRj
OTk5MWYgMTAwNjQ0DQotLS0gYS9jcnlwdG8vYWxnYXBpLmMNCisrKyBiL2NyeXB0by9hbGdhcGku
Yw0KQEAgLTQ3Nyw3ICs0NzcsOCBAQCBzdGF0aWMgc3RydWN0IGNyeXB0b190ZW1wbGF0ZSAqX19j
cnlwdG9fbG9va3VwX3RlbXBsYXRlKGNvbnN0IGNoYXIgKm5hbWUpDQogDQogc3RydWN0IGNyeXB0
b190ZW1wbGF0ZSAqY3J5cHRvX2xvb2t1cF90ZW1wbGF0ZShjb25zdCBjaGFyICpuYW1lKQ0KIHsN
Ci0JcmV0dXJuIHRyeV90aGVuX3JlcXVlc3RfbW9kdWxlKF9fY3J5cHRvX2xvb2t1cF90ZW1wbGF0
ZShuYW1lKSwgbmFtZSk7DQorCXJldHVybiB0cnlfdGhlbl9yZXF1ZXN0X21vZHVsZShfX2NyeXB0
b19sb29rdXBfdGVtcGxhdGUobmFtZSksICIlcyIsDQorCQkJCSAgICAgICBuYW1lKTsNCiB9DQog
RVhQT1JUX1NZTUJPTF9HUEwoY3J5cHRvX2xvb2t1cF90ZW1wbGF0ZSk7DQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9hdGEvYWhjaS5jIGIvZHJpdmVycy9hdGEvYWhjaS5jDQppbmRleCA4N2FjYzIz
Li4wNDQ1ZjUyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvYWhjaS5jDQorKysgYi9kcml2ZXJz
L2F0YS9haGNpLmMNCkBAIC0zMDIsNiArMzAyLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwY2lf
ZGV2aWNlX2lkIGFoY2lfcGNpX3RibFtdID0gew0KIAl7IFBDSV9WREVWSUNFKElOVEVMLCAweDhk
NjQpLCBib2FyZF9haGNpIH0sIC8qIFdlbGxzYnVyZyBSQUlEICovDQogCXsgUENJX1ZERVZJQ0Uo
SU5URUwsIDB4OGQ2NiksIGJvYXJkX2FoY2kgfSwgLyogV2VsbHNidXJnIFJBSUQgKi8NCiAJeyBQ
Q0lfVkRFVklDRShJTlRFTCwgMHg4ZDZlKSwgYm9hcmRfYWhjaSB9LCAvKiBXZWxsc2J1cmcgUkFJ
RCAqLw0KKwl7IFBDSV9WREVWSUNFKElOVEVMLCAweDIzYTMpLCBib2FyZF9haGNpIH0sIC8qIENv
bGV0byBDcmVlayBBSENJICovDQogDQogCS8qIEpNaWNyb24gMzYwLzEvMy81LzYsIG1hdGNoIGNs
YXNzIHRvIGF2b2lkIElERSBmdW5jdGlvbiAqLw0KIAl7IFBDSV9WRU5ET1JfSURfSk1JQ1JPTiwg
UENJX0FOWV9JRCwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwNCkBAIC0zMTgsNiArMzE5LDcgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkIGFoY2lfcGNpX3RibFtdID0gew0KIA0K
IAkvKiBBTUQgKi8NCiAJeyBQQ0lfVkRFVklDRShBTUQsIDB4NzgwMCksIGJvYXJkX2FoY2kgfSwg
LyogQU1EIEh1ZHNvbi0yICovDQorCXsgUENJX1ZERVZJQ0UoQU1ELCAweDc5MDApLCBib2FyZF9h
aGNpIH0sIC8qIEFNRCBDWiAqLw0KIAkvKiBBTUQgaXMgdXNpbmcgUkFJRCBjbGFzcyBvbmx5IGZv
ciBhaGNpIGNvbnRyb2xsZXJzICovDQogCXsgUENJX1ZFTkRPUl9JRF9BTUQsIFBDSV9BTllfSUQs
IFBDSV9BTllfSUQsIFBDSV9BTllfSUQsDQogCSAgUENJX0NMQVNTX1NUT1JBR0VfUkFJRCA8PCA4
LCAweGZmZmZmZiwgYm9hcmRfYWhjaSB9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2F0YV9w
aWl4LmMgYi9kcml2ZXJzL2F0YS9hdGFfcGlpeC5jDQppbmRleCAwZTkyMzI2Li43YTk0OWFmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvYXRhX3BpaXguYw0KKysrIGIvZHJpdmVycy9hdGEvYXRh
X3BpaXguYw0KQEAgLTM2MCw2ICszNjAsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaV9kZXZp
Y2VfaWQgcGlpeF9wY2lfdGJsW10gPSB7DQogCS8qIFNBVEEgQ29udHJvbGxlciBJREUgKEJheVRy
YWlsKSAqLw0KIAl7IDB4ODA4NiwgMHgwRjIwLCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAw
LCBpY2g4XzJwb3J0X3NhdGFfYnl0IH0sDQogCXsgMHg4MDg2LCAweDBGMjEsIFBDSV9BTllfSUQs
IFBDSV9BTllfSUQsIDAsIDAsIGljaDhfMnBvcnRfc2F0YV9ieXQgfSwNCisJLyogU0FUQSBDb250
cm9sbGVyIElERSAoQ29sZXRvIENyZWVrKSAqLw0KKwl7IDB4ODA4NiwgMHgyM2E2LCBQQ0lfQU5Z
X0lELCBQQ0lfQU5ZX0lELCAwLCAwLCBpY2g4XzJwb3J0X3NhdGEgfSwNCiANCiAJeyB9CS8qIHRl
cm1pbmF0ZSBsaXN0ICovDQogfTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9saWJhaGNpLmMg
Yi9kcml2ZXJzL2F0YS9saWJhaGNpLmMNCmluZGV4IDNjOTJkYmQuLjYwZGVmMDMgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2F0YS9saWJhaGNpLmMNCisrKyBiL2RyaXZlcnMvYXRhL2xpYmFoY2kuYw0K
QEAgLTE1NDEsOCArMTU0MSw3IEBAIHN0YXRpYyB2b2lkIGFoY2lfZXJyb3JfaW50cihzdHJ1Y3Qg
YXRhX3BvcnQgKmFwLCB1MzIgaXJxX3N0YXQpDQogCQl1MzIgZmJzID0gcmVhZGwocG9ydF9tbWlv
ICsgUE9SVF9GQlMpOw0KIAkJaW50IHBtcCA9IGZicyA+PiBQT1JUX0ZCU19EV0VfT0ZGU0VUOw0K
IA0KLQkJaWYgKChmYnMgJiBQT1JUX0ZCU19TREUpICYmIChwbXAgPCBhcC0+bnJfcG1wX2xpbmtz
KSAmJg0KLQkJICAgIGF0YV9saW5rX29ubGluZSgmYXAtPnBtcF9saW5rW3BtcF0pKSB7DQorCQlp
ZiAoKGZicyAmIFBPUlRfRkJTX1NERSkgJiYgKHBtcCA8IGFwLT5ucl9wbXBfbGlua3MpKSB7DQog
CQkJbGluayA9ICZhcC0+cG1wX2xpbmtbcG1wXTsNCiAJCQlmYnNfbmVlZF9kZWMgPSB0cnVlOw0K
IAkJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1wbXAuYyBiL2RyaXZlcnMvYXRh
L2xpYmF0YS1wbXAuYw0KaW5kZXggMjFiODBjNS4uZjYzYTU4OCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvYXRhL2xpYmF0YS1wbXAuYw0KKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLXBtcC5jDQpAQCAt
Mzg5LDkgKzM4OSwxMyBAQCBzdGF0aWMgdm9pZCBzYXRhX3BtcF9xdWlya3Moc3RydWN0IGF0YV9w
b3J0ICphcCkNCiAJCQkvKiBsaW5rIHJlcG9ydHMgb2ZmbGluZSBhZnRlciBMUE0gKi8NCiAJCQls
aW5rLT5mbGFncyB8PSBBVEFfTEZMQUdfTk9fTFBNOw0KIA0KLQkJCS8qIENsYXNzIGNvZGUgcmVw
b3J0IGlzIHVucmVsaWFibGUuICovDQorCQkJLyoNCisJCQkgKiBDbGFzcyBjb2RlIHJlcG9ydCBp
cyB1bnJlbGlhYmxlIGFuZCBTUlNUIHRpbWVzDQorCQkJICogb3V0IHVuZGVyIGNlcnRhaW4gY29u
ZmlndXJhdGlvbnMuDQorCQkJICovDQogCQkJaWYgKGxpbmstPnBtcCA8IDUpDQotCQkJCWxpbmst
PmZsYWdzIHw9IEFUQV9MRkxBR19BU1NVTUVfQVRBOw0KKwkJCQlsaW5rLT5mbGFncyB8PSBBVEFf
TEZMQUdfTk9fU1JTVCB8DQorCQkJCQkgICAgICAgQVRBX0xGTEFHX0FTU1VNRV9BVEE7DQogDQog
CQkJLyogcG9ydCA1IGlzIGZvciBTRU1CIGRldmljZSBhbmQgaXQgZG9lc24ndCBsaWtlIFNSU1Qg
Ki8NCiAJCQlpZiAobGluay0+cG1wID09IDUpDQpAQCAtMzk5LDIwICs0MDMsMTcgQEAgc3RhdGlj
IHZvaWQgc2F0YV9wbXBfcXVpcmtzKHN0cnVjdCBhdGFfcG9ydCAqYXApDQogCQkJCQkgICAgICAg
QVRBX0xGTEFHX0FTU1VNRV9TRU1COw0KIAkJfQ0KIAl9IGVsc2UgaWYgKHZlbmRvciA9PSAweDEw
OTUgJiYgZGV2aWQgPT0gMHg0NzIzKSB7DQotCQkvKiBzaWw0NzIzIHF1aXJrcyAqLw0KLQkJYXRh
X2Zvcl9lYWNoX2xpbmsobGluaywgYXAsIEVER0UpIHsNCi0JCQkvKiBsaW5rIHJlcG9ydHMgb2Zm
bGluZSBhZnRlciBMUE0gKi8NCi0JCQlsaW5rLT5mbGFncyB8PSBBVEFfTEZMQUdfTk9fTFBNOw0K
LQ0KLQkJCS8qIGNsYXNzIGNvZGUgcmVwb3J0IGlzIHVucmVsaWFibGUgKi8NCi0JCQlpZiAobGlu
ay0+cG1wIDwgMikNCi0JCQkJbGluay0+ZmxhZ3MgfD0gQVRBX0xGTEFHX0FTU1VNRV9BVEE7DQot
DQotCQkJLyogdGhlIGNvbmZpZyBkZXZpY2UgYXQgcG9ydCAyIGxvY2tzIHVwIG9uIFNSU1QgKi8N
Ci0JCQlpZiAobGluay0+cG1wID09IDIpDQotCQkJCWxpbmstPmZsYWdzIHw9IEFUQV9MRkxBR19O
T19TUlNUIHwNCi0JCQkJCSAgICAgICBBVEFfTEZMQUdfQVNTVU1FX0FUQTsNCi0JCX0NCisJCS8q
DQorCQkgKiBzaWw0NzIzIHF1aXJrcw0KKwkJICoNCisJCSAqIExpbmsgcmVwb3J0cyBvZmZsaW5l
IGFmdGVyIExQTS4gIENsYXNzIGNvZGUgcmVwb3J0IGlzDQorCQkgKiB1bnJlbGlhYmxlLiAgU0lN
RyBQTVBzIG5ldmVyIGdvdCBTUlNUIHJlbGlhYmxlIGFuZCB0aGUNCisJCSAqIGNvbmZpZyBkZXZp
Y2UgYXQgcG9ydCAyIGxvY2tzIHVwIG9uIFNSU1QuDQorCQkgKi8NCisJCWF0YV9mb3JfZWFjaF9s
aW5rKGxpbmssIGFwLCBFREdFKQ0KKwkJCWxpbmstPmZsYWdzIHw9IEFUQV9MRkxBR19OT19MUE0g
fA0KKwkJCQkgICAgICAgQVRBX0xGTEFHX05PX1NSU1QgfA0KKwkJCQkgICAgICAgQVRBX0xGTEFH
X0FTU1VNRV9BVEE7DQogCX0gZWxzZSBpZiAodmVuZG9yID09IDB4MTA5NSAmJiBkZXZpZCA9PSAw
eDQ3MjYpIHsNCiAJCS8qIHNpbDQ3MjYgcXVpcmtzICovDQogCQlhdGFfZm9yX2VhY2hfbGluayhs
aW5rLCBhcCwgRURHRSkgew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbmJkLmMgYi9kcml2
ZXJzL2Jsb2NrL25iZC5jDQppbmRleCA0MGEwZmNiLi41ZmI2ODg1IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9ibG9jay9uYmQuYw0KKysrIGIvZHJpdmVycy9ibG9jay9uYmQuYw0KQEAgLTU5OCw4ICs1
OTgsMTAgQEAgc3RhdGljIGludCBfX25iZF9pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2
LCBzdHJ1Y3QgbmJkX2RldmljZSAqbG8sDQogCQlpZiAoIWxvLT5zb2NrKQ0KIAkJCXJldHVybiAt
RUlOVkFMOw0KIA0KKwkJbG8tPmRpc2Nvbm5lY3QgPSAxOw0KKw0KIAkJbmJkX3NlbmRfcmVxKGxv
LCAmc3JlcSk7DQotICAgICAgICAgICAgICAgIHJldHVybiAwOw0KKwkJcmV0dXJuIDA7DQogCX0N
CiAgDQogCWNhc2UgTkJEX0NMRUFSX1NPQ0s6IHsNCkBAIC02MjksNiArNjMxLDcgQEAgc3RhdGlj
IGludCBfX25iZF9pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgbmJkX2Rl
dmljZSAqbG8sDQogCQkJCWxvLT5zb2NrID0gU09DS0VUX0koaW5vZGUpOw0KIAkJCQlpZiAobWF4
X3BhcnQgPiAwKQ0KIAkJCQkJYmRldi0+YmRfaW52YWxpZGF0ZWQgPSAxOw0KKwkJCQlsby0+ZGlz
Y29ubmVjdCA9IDA7IC8qIHdlJ3JlIGNvbm5lY3RlZCBub3cgKi8NCiAJCQkJcmV0dXJuIDA7DQog
CQkJfSBlbHNlIHsNCiAJCQkJZnB1dChmaWxlKTsNCkBAIC02NzUsNyArNjc4LDggQEAgc3RhdGlj
IGludCBfX25iZF9pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzdHJ1Y3QgbmJkX2Rl
dmljZSAqbG8sDQogDQogCQltdXRleF91bmxvY2soJmxvLT50eF9sb2NrKTsNCiANCi0JCXRocmVh
ZCA9IGt0aHJlYWRfY3JlYXRlKG5iZF90aHJlYWQsIGxvLCBsby0+ZGlzay0+ZGlza19uYW1lKTsN
CisJCXRocmVhZCA9IGt0aHJlYWRfY3JlYXRlKG5iZF90aHJlYWQsIGxvLCAiJXMiLA0KKwkJCQkJ
bG8tPmRpc2stPmRpc2tfbmFtZSk7DQogCQlpZiAoSVNfRVJSKHRocmVhZCkpIHsNCiAJCQltdXRl
eF9sb2NrKCZsby0+dHhfbG9jayk7DQogCQkJcmV0dXJuIFBUUl9FUlIodGhyZWFkKTsNCkBAIC03
MDAsNiArNzA0LDggQEAgc3RhdGljIGludCBfX25iZF9pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNl
ICpiZGV2LCBzdHJ1Y3QgbmJkX2RldmljZSAqbG8sDQogCQlzZXRfY2FwYWNpdHkobG8tPmRpc2ss
IDApOw0KIAkJaWYgKG1heF9wYXJ0ID4gMCkNCiAJCQlpb2N0bF9ieV9iZGV2KGJkZXYsIEJMS1JS
UEFSVCwgMCk7DQorCQlpZiAobG8tPmRpc2Nvbm5lY3QpIC8qIHVzZXIgcmVxdWVzdGVkLCBpZ25v
cmUgc29ja2V0IGVycm9ycyAqLw0KKwkJCXJldHVybiAwOw0KIAkJcmV0dXJuIGxvLT5oYXJkZXJy
b3I7DQogCX0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Nkcm9tL2Nkcm9tLmMgYi9kcml2ZXJz
L2Nkcm9tL2Nkcm9tLmMNCmluZGV4IDI2NzhiNmYuLjEzMzE3NDAgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2Nkcm9tL2Nkcm9tLmMNCisrKyBiL2RyaXZlcnMvY2Ryb20vY2Ryb20uYw0KQEAgLTI4ODUs
NyArMjg4NSw3IEBAIHN0YXRpYyBub2lubGluZSBpbnQgbW1jX2lvY3RsX2Nkcm9tX3JlYWRfZGF0
YShzdHJ1Y3QgY2Ryb21fZGV2aWNlX2luZm8gKmNkaSwNCiAJaWYgKGxiYSA8IDApDQogCQlyZXR1
cm4gLUVJTlZBTDsNCiANCi0JY2djLT5idWZmZXIgPSBrbWFsbG9jKGJsb2Nrc2l6ZSwgR0ZQX0tF
Uk5FTCk7DQorCWNnYy0+YnVmZmVyID0ga3phbGxvYyhibG9ja3NpemUsIEdGUF9LRVJORUwpOw0K
IAlpZiAoY2djLT5idWZmZXIgPT0gTlVMTCkNCiAJCXJldHVybiAtRU5PTUVNOw0KIA0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZG1hL3BsMzMwLmMgYi9kcml2ZXJzL2RtYS9wbDMzMC5jDQppbmRleCBl
OGVlZGI3Li43MjBjYWNlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9kbWEvcGwzMzAuYw0KKysrIGIv
ZHJpdmVycy9kbWEvcGwzMzAuYw0KQEAgLTM0OSwxMCArMzQ5LDEwIEBAIHN0YXRpYyB2b2lkIHBs
MzMwX2ZyZWVfY2hhbl9yZXNvdXJjZXMoc3RydWN0IGRtYV9jaGFuICpjaGFuKQ0KIAlzdHJ1Y3Qg
ZG1hX3BsMzMwX2NoYW4gKnBjaCA9IHRvX3BjaGFuKGNoYW4pOw0KIAl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KIA0KLQlzcGluX2xvY2tfaXJxc2F2ZSgmcGNoLT5sb2NrLCBmbGFncyk7DQotDQogCXRh
c2tsZXRfa2lsbCgmcGNoLT50YXNrKTsNCiANCisJc3Bpbl9sb2NrX2lycXNhdmUoJnBjaC0+bG9j
aywgZmxhZ3MpOw0KKw0KIAlwbDMzMF9yZWxlYXNlX2NoYW5uZWwocGNoLT5wbDMzMF9jaGlkKTsN
CiAJcGNoLT5wbDMzMF9jaGlkID0gTlVMTDsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2h2L3Jp
bmdfYnVmZmVyLmMgYi9kcml2ZXJzL2h2L3JpbmdfYnVmZmVyLmMNCmluZGV4IDhhZjI1YTAuLjgx
MDY1OGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2h2L3JpbmdfYnVmZmVyLmMNCisrKyBiL2RyaXZl
cnMvaHYvcmluZ19idWZmZXIuYw0KQEAgLTM4Myw3ICszODMsNyBAQCBpbnQgaHZfcmluZ2J1ZmZl
cl93cml0ZShzdHJ1Y3QgaHZfcmluZ19idWZmZXJfaW5mbyAqb3V0cmluZ19pbmZvLA0KIAkJCQkJ
ICAgICBzaXplb2YodTY0KSk7DQogDQogCS8qIE1ha2Ugc3VyZSB3ZSBmbHVzaCBhbGwgd3JpdGVz
IGJlZm9yZSB1cGRhdGluZyB0aGUgd3JpdGVJbmRleCAqLw0KLQlzbXBfd21iKCk7DQorCXdtYigp
Ow0KIA0KIAkvKiBOb3csIHVwZGF0ZSB0aGUgd3JpdGUgbG9jYXRpb24gKi8NCiAJaHZfc2V0X25l
eHRfd3JpdGVfbG9jYXRpb24ob3V0cmluZ19pbmZvLCBuZXh0X3dyaXRlX2xvY2F0aW9uKTsNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2h2L3ZtYnVzX2Rydi5jIGIvZHJpdmVycy9odi92bWJ1c19kcnYu
Yw0KaW5kZXggZDJkMGEyYS4uNDQ0NDJkNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaHYvdm1idXNf
ZHJ2LmMNCisrKyBiL2RyaXZlcnMvaHYvdm1idXNfZHJ2LmMNCkBAIC00NjYsNyArNDY2LDcgQEAg
c3RhdGljIHZvaWQgdm1idXNfb25fbXNnX2RwYyh1bnNpZ25lZCBsb25nIGRhdGEpDQogCQkgKiB3
aWxsIG5vdCBkZWxpdmVyIGFueSBtb3JlIG1lc3NhZ2VzIHNpbmNlIHRoZXJlIGlzDQogCQkgKiBu
byBlbXB0eSBzbG90DQogCQkgKi8NCi0JCXNtcF9tYigpOw0KKwkJbWIoKTsNCiANCiAJCWlmICht
c2ctPmhlYWRlci5tZXNzYWdlX2ZsYWdzLm1zZ19wZW5kaW5nKSB7DQogCQkJLyoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2kyYy9idXNzZXMvS2NvbmZpZyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9LY29u
ZmlnDQppbmRleCA2MGY1OTNjLi5kYmQ0ZmE1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pMmMvYnVz
c2VzL0tjb25maWcNCisrKyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9LY29uZmlnDQpAQCAtMTM3LDYg
KzEzNyw3IEBAIGNvbmZpZyBJMkNfUElJWDQNCiAJICAgIEFUSSBTQjcwMA0KIAkgICAgQVRJIFNC
ODAwDQogCSAgICBBTUQgSHVkc29uLTINCisJICAgIEFNRCBDWg0KIAkgICAgU2VydmVyd29ya3Mg
T1NCNA0KIAkgICAgU2VydmVyd29ya3MgQ1NCNQ0KIAkgICAgU2VydmVyd29ya3MgQ1NCNg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtcGlpeDQuYyBiL2RyaXZlcnMvaTJjL2J1
c3Nlcy9pMmMtcGlpeDQuYw0KaW5kZXggNmQxNGFjMi4uMTRiNTg4YyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvaTJjL2J1c3Nlcy9pMmMtcGlpeDQuYw0KKysrIGIvZHJpdmVycy9pMmMvYnVzc2VzL2ky
Yy1waWl4NC5jDQpAQCAtMjIsNyArMjIsNyBAQA0KIAlJbnRlbCBQSUlYNCwgNDQwTVgNCiAJU2Vy
dmVyd29ya3MgT1NCNCwgQ1NCNSwgQ1NCNiwgSFQtMTAwMCwgSFQtMTEwMA0KIAlBVEkgSVhQMjAw
LCBJWFAzMDAsIElYUDQwMCwgU0I2MDAsIFNCNzAwLCBTQjgwMA0KLQlBTUQgSHVkc29uLTINCisJ
QU1EIEh1ZHNvbi0yLCBDWg0KIAlTTVNDIFZpY3Rvcnk2Ng0KIA0KICAgIE5vdGU6IHdlIGFzc3Vt
ZSB0aGVyZSBjYW4gb25seSBiZSBvbmUgZGV2aWNlLCB3aXRoIG9uZSBTTUJ1cyBpbnRlcmZhY2Uu
DQpAQCAtNDgxLDYgKzQ4MSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBw
aWl4NF9pZHNbXSA9IHsNCiAJeyBQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVRJLCBQQ0lfREVW
SUNFX0lEX0FUSV9JWFA0MDBfU01CVVMpIH0sDQogCXsgUENJX0RFVklDRShQQ0lfVkVORE9SX0lE
X0FUSSwgUENJX0RFVklDRV9JRF9BVElfU0JYMDBfU01CVVMpIH0sDQogCXsgUENJX0RFVklDRShQ
Q0lfVkVORE9SX0lEX0FNRCwgUENJX0RFVklDRV9JRF9BTURfSFVEU09OMl9TTUJVUykgfSwNCisJ
eyBQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQU1ELCAweDc5MGIpIH0sDQogCXsgUENJX0RFVklD
RShQQ0lfVkVORE9SX0lEX1NFUlZFUldPUktTLA0KIAkJICAgICBQQ0lfREVWSUNFX0lEX1NFUlZF
UldPUktTX09TQjQpIH0sDQogCXsgUENJX0RFVklDRShQQ0lfVkVORE9SX0lEX1NFUlZFUldPUktT
LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvYW1kX2lvbW11LmMgYi9kcml2ZXJzL2lvbW11
L2FtZF9pb21tdS5jDQppbmRleCAwN2NiMWE2Li42Y2M4ZTY3IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9pb21tdS9hbWRfaW9tbXUuYw0KKysrIGIvZHJpdmVycy9pb21tdS9hbWRfaW9tbXUuYw0KQEAg
LTEwNzYsNiArMTA3NiwxMCBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBpb21tdV91bm1hcF9wYWdl
KHN0cnVjdCBwcm90ZWN0aW9uX2RvbWFpbiAqZG9tLA0KIA0KIAkJCS8qIExhcmdlIFBURSBmb3Vu
ZCB3aGljaCBtYXBzIHRoaXMgYWRkcmVzcyAqLw0KIAkJCXVubWFwX3NpemUgPSBQVEVfUEFHRV9T
SVpFKCpwdGUpOw0KKw0KKwkJCS8qIE9ubHkgdW5tYXAgZnJvbSB0aGUgZmlyc3QgcHRlIGluIHRo
ZSBwYWdlICovDQorCQkJaWYgKCh1bm1hcF9zaXplIC0gMSkgJiBidXNfYWRkcikNCisJCQkJYnJl
YWs7DQogCQkJY291bnQgICAgICA9IFBBR0VfU0laRV9QVEVfQ09VTlQodW5tYXBfc2l6ZSk7DQog
CQkJZm9yIChpID0gMDsgaSA8IGNvdW50OyBpKyspDQogCQkJCXB0ZVtpXSA9IDBVTEw7DQpAQCAt
MTA4NSw3ICsxMDg5LDcgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgaW9tbXVfdW5tYXBfcGFnZShz
dHJ1Y3QgcHJvdGVjdGlvbl9kb21haW4gKmRvbSwNCiAJCXVubWFwcGVkICs9IHVubWFwX3NpemU7
DQogCX0NCiANCi0JQlVHX09OKCFpc19wb3dlcl9vZl8yKHVubWFwcGVkKSk7DQorCUJVR19PTih1
bm1hcHBlZCAmJiAhaXNfcG93ZXJfb2ZfMih1bm1hcHBlZCkpOw0KIA0KIAlyZXR1cm4gdW5tYXBw
ZWQ7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2RteGRldi5j
IGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZG14ZGV2LmMNCmluZGV4IGU0YjVjMDMuLjRm
OGMzZjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi9kdmItY29yZS9kbXhkZXYuYw0K
KysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZG14ZGV2LmMNCkBAIC0zODAsMTAgKzM4
MCw4IEBAIHN0YXRpYyBpbnQgZHZiX2RteGRldl9zZWN0aW9uX2NhbGxiYWNrKGNvbnN0IHU4ICpi
dWZmZXIxLCBzaXplX3QgYnVmZmVyMV9sZW4sDQogCQlyZXQgPSBkdmJfZG14ZGV2X2J1ZmZlcl93
cml0ZSgmZG14ZGV2ZmlsdGVyLT5idWZmZXIsIGJ1ZmZlcjIsDQogCQkJCQkgICAgICBidWZmZXIy
X2xlbik7DQogCX0NCi0JaWYgKHJldCA8IDApIHsNCi0JCWR2Yl9yaW5nYnVmZmVyX2ZsdXNoKCZk
bXhkZXZmaWx0ZXItPmJ1ZmZlcik7DQorCWlmIChyZXQgPCAwKQ0KIAkJZG14ZGV2ZmlsdGVyLT5i
dWZmZXIuZXJyb3IgPSByZXQ7DQotCX0NCiAJaWYgKGRteGRldmZpbHRlci0+cGFyYW1zLnNlYy5m
bGFncyAmIERNWF9PTkVTSE9UKQ0KIAkJZG14ZGV2ZmlsdGVyLT5zdGF0ZSA9IERNWERFVl9TVEFU
RV9ET05FOw0KIAlzcGluX3VubG9jaygmZG14ZGV2ZmlsdGVyLT5kZXYtPmxvY2spOw0KQEAgLTQx
OSwxMCArNDE3LDggQEAgc3RhdGljIGludCBkdmJfZG14ZGV2X3RzX2NhbGxiYWNrKGNvbnN0IHU4
ICpidWZmZXIxLCBzaXplX3QgYnVmZmVyMV9sZW4sDQogCXJldCA9IGR2Yl9kbXhkZXZfYnVmZmVy
X3dyaXRlKGJ1ZmZlciwgYnVmZmVyMSwgYnVmZmVyMV9sZW4pOw0KIAlpZiAocmV0ID09IGJ1ZmZl
cjFfbGVuKQ0KIAkJcmV0ID0gZHZiX2RteGRldl9idWZmZXJfd3JpdGUoYnVmZmVyLCBidWZmZXIy
LCBidWZmZXIyX2xlbik7DQotCWlmIChyZXQgPCAwKSB7DQotCQlkdmJfcmluZ2J1ZmZlcl9mbHVz
aChidWZmZXIpOw0KKwlpZiAocmV0IDwgMCkNCiAJCWJ1ZmZlci0+ZXJyb3IgPSByZXQ7DQotCX0N
CiAJc3Bpbl91bmxvY2soJmRteGRldmZpbHRlci0+ZGV2LT5sb2NrKTsNCiAJd2FrZV91cCgmYnVm
ZmVyLT5xdWV1ZSk7DQogCXJldHVybiAwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlYWx0ZWsvcjgxNjkuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjku
Yw0KaW5kZXggZWQ3YTVhNi4uYTNiZDBiYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlYWx0ZWsvcjgxNjkuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9y
ODE2OS5jDQpAQCAtNTU4NCwxNCArNTU4NCw2IEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBydGw4MTY5
X3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCWdvdG8gZXJyX3N0b3BfMDsNCiAJ
fQ0KIA0KLQkvKiA4MTY4ZXZsIGRvZXMgbm90IGF1dG9tYXRpY2FsbHkgcGFkIHRvIG1pbmltdW0g
bGVuZ3RoLiAqLw0KLQlpZiAodW5saWtlbHkodHAtPm1hY192ZXJzaW9uID09IFJUTF9HSUdBX01B
Q19WRVJfMzQgJiYNCi0JCSAgICAgc2tiLT5sZW4gPCBFVEhfWkxFTikpIHsNCi0JCWlmIChza2Jf
cGFkdG8oc2tiLCBFVEhfWkxFTikpDQotCQkJZ290byBlcnJfdXBkYXRlX3N0YXRzOw0KLQkJc2ti
X3B1dChza2IsIEVUSF9aTEVOIC0gc2tiLT5sZW4pOw0KLQl9DQotDQogCWlmICh1bmxpa2VseShs
ZTMyX3RvX2NwdSh0eGQtPm9wdHMxKSAmIERlc2NPd24pKQ0KIAkJZ290byBlcnJfc3RvcF8wOw0K
IA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dhbi9kbGNpLmMgYi9kcml2ZXJzL25ldC93YW4v
ZGxjaS5jDQppbmRleCA0OGFiMzhhLi4wMmM5MzllIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
d2FuL2RsY2kuYw0KKysrIGIvZHJpdmVycy9uZXQvd2FuL2RsY2kuYw0KQEAgLTM4NSwyMSArMzg1
LDM3IEBAIHN0YXRpYyBpbnQgZGxjaV9kZWwoc3RydWN0IGRsY2lfYWRkICpkbGNpKQ0KIAlzdHJ1
Y3QgZnJhZF9sb2NhbAkqZmxwOw0KIAlzdHJ1Y3QgbmV0X2RldmljZQkqbWFzdGVyLCAqc2xhdmU7
DQogCWludAkJCWVycjsNCisJYm9vbAkJCWZvdW5kID0gZmFsc2U7DQorDQorCXJ0bmxfbG9jaygp
Ow0KIA0KIAkvKiB2YWxpZGF0ZSBzbGF2ZSBkZXZpY2UgKi8NCiAJbWFzdGVyID0gX19kZXZfZ2V0
X2J5X25hbWUoJmluaXRfbmV0LCBkbGNpLT5kZXZuYW1lKTsNCi0JaWYgKCFtYXN0ZXIpDQotCQly
ZXR1cm4gLUVOT0RFVjsNCisJaWYgKCFtYXN0ZXIpIHsNCisJCWVyciA9IC1FTk9ERVY7DQorCQln
b3RvIG91dDsNCisJfQ0KKw0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KGRscCwgJmRsY2lfZGV2cywg
bGlzdCkgew0KKwkJaWYgKGRscC0+bWFzdGVyID09IG1hc3Rlcikgew0KKwkJCWZvdW5kID0gdHJ1
ZTsNCisJCQlicmVhazsNCisJCX0NCisJfQ0KKwlpZiAoIWZvdW5kKSB7DQorCQllcnIgPSAtRU5P
REVWOw0KKwkJZ290byBvdXQ7DQorCX0NCiANCiAJaWYgKG5ldGlmX3J1bm5pbmcobWFzdGVyKSkg
ew0KLQkJcmV0dXJuIC1FQlVTWTsNCisJCWVyciA9IC1FQlVTWTsNCisJCWdvdG8gb3V0Ow0KIAl9
DQogDQogCWRscCA9IG5ldGRldl9wcml2KG1hc3Rlcik7DQogCXNsYXZlID0gZGxwLT5zbGF2ZTsN
CiAJZmxwID0gbmV0ZGV2X3ByaXYoc2xhdmUpOw0KIA0KLQlydG5sX2xvY2soKTsNCiAJZXJyID0g
KCpmbHAtPmRlYXNzb2MpKHNsYXZlLCBtYXN0ZXIpOw0KIAlpZiAoIWVycikgew0KIAkJbGlzdF9k
ZWwoJmRscC0+bGlzdCk7DQpAQCAtNDA4LDggKzQyNCw4IEBAIHN0YXRpYyBpbnQgZGxjaV9kZWwo
c3RydWN0IGRsY2lfYWRkICpkbGNpKQ0KIA0KIAkJZGV2X3B1dChzbGF2ZSk7DQogCX0NCitvdXQ6
DQogCXJ0bmxfdW5sb2NrKCk7DQotDQogCXJldHVybiBlcnI7DQogfQ0KIA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfZWVwcm9tLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXI5MDAzX2VlcHJvbS5jDQppbmRleCAzYjI2MmJhLi5j
NDFlYjlkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAw
M19lZXByb20uYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAwM19l
ZXByb20uYw0KQEAgLTM2MjUsNyArMzYyNSw3IEBAIHN0YXRpYyB1MTYgYXI5MDAzX2h3X2FudF9j
dHJsX2NoYWluX2dldChzdHJ1Y3QgYXRoX2h3ICphaCwNCiBzdGF0aWMgdm9pZCBhcjkwMDNfaHdf
YW50X2N0cmxfYXBwbHkoc3RydWN0IGF0aF9odyAqYWgsIGJvb2wgaXMyZ2h6KQ0KIHsNCiAJaW50
IGNoYWluOw0KLQl1MzIgcmVndmFsOw0KKwl1MzIgcmVndmFsLCB2YWx1ZTsNCiAJdTMyIGFudF9k
aXZfY3RsMTsNCiAJc3RhdGljIGNvbnN0IHUzMiBzd2l0Y2hfY2hhaW5fcmVnW0FSOTMwMF9NQVhf
Q0hBSU5TXSA9IHsNCiAJCQlBUl9QSFlfU1dJVENIX0NIQUlOXzAsDQpAQCAtMzYzMyw3ICszNjMz
LDExIEBAIHN0YXRpYyB2b2lkIGFyOTAwM19od19hbnRfY3RybF9hcHBseShzdHJ1Y3QgYXRoX2h3
ICphaCwgYm9vbCBpczJnaHopDQogCQkJQVJfUEhZX1NXSVRDSF9DSEFJTl8yLA0KIAl9Ow0KIA0K
LQl1MzIgdmFsdWUgPSBhcjkwMDNfaHdfYW50X2N0cmxfY29tbW9uX2dldChhaCwgaXMyZ2h6KTsN
CisJaWYgKEFSX1NSRVZfOTQ4NShhaCkgJiYgKGFyOTAwM19od19nZXRfcnhfZ2Fpbl9pZHgoYWgp
ID09IDApKQ0KKwkJYXRoOWtfaHdfY2ZnX291dHB1dChhaCwgQVI5MzAwX0VYVF9MTkFfQ1RMX0dQ
SU9fQVI5NDg1LA0KKwkJCQkgICAgQVJfR1BJT19PVVRQVVRfTVVYX0FTX1BDSUVfQVRURU5USU9O
X0xFRCk7DQorDQorCXZhbHVlID0gYXI5MDAzX2h3X2FudF9jdHJsX2NvbW1vbl9nZXQoYWgsIGlz
Mmdoeik7DQogDQogCWlmIChBUl9TUkVWXzk0NjIoYWgpKSB7DQogCQlpZiAoQVJfU1JFVl85NDYy
XzEwKGFoKSkgew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9h
cjkwMDNfcGh5LmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXI5MDAzX3BoeS5o
DQppbmRleCA0MTE0ZmU3Li40ZTliNzFiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL2FyOTAwM19waHkuaA0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL2FyOTAwM19waHkuaA0KQEAgLTMzNCw2ICszMzQsOCBAQA0KIA0KICNkZWZpbmUgQVJf
UEhZX0NDQV9OT01fVkFMXzkzMzBfMkdIWiAgICAgICAgICAtMTE4DQogDQorI2RlZmluZSBBUjkz
MDBfRVhUX0xOQV9DVExfR1BJT19BUjk0ODUgOQ0KKw0KIC8qDQogICogQUdDIEZpZWxkIERlZmlu
aXRpb25zDQogICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2NhbGliLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvY2FsaWIuYw0KaW5kZXgg
YmNhYmZiZi4uNWU1MjJlNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGg5ay9jYWxpYi5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvY2FsaWIu
Yw0KQEAgLTM5MSw3ICszOTEsNiBAQCBib29sIGF0aDlrX2h3X2dldG5mKHN0cnVjdCBhdGhfaHcg
KmFoLCBzdHJ1Y3QgYXRoOWtfY2hhbm5lbCAqY2hhbikNCiANCiAJaWYgKCFjYWxkYXRhKSB7DQog
CQljaGFuLT5ub2lzZWZsb29yID0gbmY7DQotCQlhaC0+bm9pc2UgPSBhdGg5a19od19nZXRjaGFu
X25vaXNlKGFoLCBjaGFuKTsNCiAJCXJldHVybiBmYWxzZTsNCiAJfQ0KIA0KQEAgLTQxMyw2ICs0
MTIsNyBAQCB2b2lkIGF0aDlrX2luaXRfbmZjYWxfaGlzdF9idWZmZXIoc3RydWN0IGF0aF9odyAq
YWgsDQogDQogCWFoLT5jYWxkYXRhLT5jaGFubmVsID0gY2hhbi0+Y2hhbm5lbDsNCiAJYWgtPmNh
bGRhdGEtPmNoYW5uZWxGbGFncyA9IGNoYW4tPmNoYW5uZWxGbGFncyAmIH5DSEFOTkVMX0NXX0lO
VDsNCisJYWgtPmNhbGRhdGEtPmNoYW5tb2RlID0gY2hhbi0+Y2hhbm1vZGU7DQogCWggPSBhaC0+
Y2FsZGF0YS0+bmZDYWxIaXN0Ow0KIAlkZWZhdWx0X25mID0gYXRoOWtfaHdfZ2V0X2RlZmF1bHRf
bmYoYWgsIGNoYW4pOw0KIAlmb3IgKGkgPSAwOyBpIDwgTlVNX05GX1JFQURJTkdTOyBpKyspIHsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHcuYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9ody5jDQppbmRleCAyYjhlOTU3Li5jNjIzNTI3IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h3LmMNCisrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9ody5jDQpAQCAtMTU0MCw3ICsxNTQwLDggQEAg
aW50IGF0aDlrX2h3X3Jlc2V0KHN0cnVjdCBhdGhfaHcgKmFoLCBzdHJ1Y3QgYXRoOWtfY2hhbm5l
bCAqY2hhbiwNCiAJaWYgKGNhbGRhdGEgJiYNCiAJICAgIChjaGFuLT5jaGFubmVsICE9IGNhbGRh
dGEtPmNoYW5uZWwgfHwNCiAJICAgICAoY2hhbi0+Y2hhbm5lbEZsYWdzICYgfkNIQU5ORUxfQ1df
SU5UKSAhPQ0KLQkgICAgIChjYWxkYXRhLT5jaGFubmVsRmxhZ3MgJiB+Q0hBTk5FTF9DV19JTlQp
KSkgew0KKwkgICAgIChjYWxkYXRhLT5jaGFubmVsRmxhZ3MgJiB+Q0hBTk5FTF9DV19JTlQpIHx8
DQorCSAgICAgY2hhbi0+Y2hhbm1vZGUgIT0gY2FsZGF0YS0+Y2hhbm1vZGUpKSB7DQogCQkvKiBP
cGVyYXRpbmcgY2hhbm5lbCBjaGFuZ2VkLCByZXNldCBjaGFubmVsIGNhbGlicmF0aW9uIGRhdGEg
Ki8NCiAJCW1lbXNldChjYWxkYXRhLCAwLCBzaXplb2YoKmNhbGRhdGEpKTsNCiAJCWF0aDlrX2lu
aXRfbmZjYWxfaGlzdF9idWZmZXIoYWgsIGNoYW4pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg5ay9ody5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2h3LmgNCmluZGV4IDBjNjVhMDkuLmRjNzc0Y2QgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoOWsvaHcuaA0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0
aDlrL2h3LmgNCkBAIC0zNTIsNiArMzUyLDcgQEAgc3RydWN0IGF0aDlrX3J0dF9oaXN0IHsNCiBz
dHJ1Y3QgYXRoOWtfaHdfY2FsX2RhdGEgew0KIAl1MTYgY2hhbm5lbDsNCiAJdTMyIGNoYW5uZWxG
bGFnczsNCisJdTMyIGNoYW5tb2RlOw0KIAlpbnQzMl90IENhbFZhbGlkOw0KIAlpbnQ4X3QgaUNv
ZmY7DQogCWludDhfdCBxQ29mZjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvbWFpbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21haW4uYw0K
aW5kZXggZGYzZTI3Yy4uYTU5MjY3YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9t
YWluLmMNCkBAIC0xNjg4LDEzICsxNjg4LDYgQEAgc3RhdGljIGludCBhdGg5a19jb25maWcoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFuZ2VkKQ0KIAkJYXRoX3VwZGF0ZV9zdXJ2ZXlf
c3RhdHMoc2MpOw0KIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY29tbW9uLT5jY19sb2NrLCBm
bGFncyk7DQogDQotCQkvKg0KLQkJICogUHJlc2VydmUgdGhlIGN1cnJlbnQgY2hhbm5lbCB2YWx1
ZXMsIGJlZm9yZSB1cGRhdGluZw0KLQkJICogdGhlIHNhbWUgY2hhbm5lbA0KLQkJICovDQotCQlp
ZiAoYWgtPmN1cmNoYW4gJiYgKG9sZF9wb3MgPT0gcG9zKSkNCi0JCQlhdGg5a19od19nZXRuZihh
aCwgYWgtPmN1cmNoYW4pOw0KLQ0KIAkJYXRoOWtfY21uX3VwZGF0ZV9pY2hhbm5lbCgmc2MtPnNj
X2FoLT5jaGFubmVsc1twb3NdLA0KIAkJCQkJICBjdXJjaGFuLCBjb25mLT5jaGFubmVsX3R5cGUp
Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9LY29uZmlnIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYjQzL0tjb25maWcNCmluZGV4IGI5N2E0MGUuLjM2YTdjZTMgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvS2NvbmZpZw0KKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYjQzL0tjb25maWcNCkBAIC0yOCwxMiArMjgsMTIgQEAgY29uZmlnIEI0
Mw0KIA0KIGNvbmZpZyBCNDNfQkNNQQ0KIAlib29sICJTdXBwb3J0IGZvciBCQ01BIGJ1cyINCi0J
ZGVwZW5kcyBvbiBCNDMgJiYgQkNNQQ0KKwlkZXBlbmRzIG9uIEI0MyAmJiAoQkNNQSA9IHkgfHwg
QkNNQSA9IEI0MykNCiAJZGVmYXVsdCB5DQogDQogY29uZmlnIEI0M19TU0INCiAJYm9vbA0KLQlk
ZXBlbmRzIG9uIEI0MyAmJiBTU0INCisJZGVwZW5kcyBvbiBCNDMgJiYgKFNTQiA9IHkgfHwgU1NC
ID0gQjQzKQ0KIAlkZWZhdWx0IHkNCiANCiAjIEF1dG8tc2VsZWN0IFNTQiBQQ0ktSE9TVCBzdXBw
b3J0LCBpZiBwb3NzaWJsZQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdp
ZmkvcnRsODE5MmN1L3JmLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJj
dS9yZi5jDQppbmRleCAxZTg1MWFhLi4xN2E4ZTk2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3UvcmYuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnRsd2lmaS9ydGw4MTkyY3UvcmYuYw0KQEAgLTEwNCw3ICsxMDQsNyBAQCB2b2lkIHJ0bDky
Y3VfcGh5X3JmNjA1Ml9zZXRfY2NrX3R4cG93ZXIoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQog
CQkJdHhfYWdjW1JGOTBfUEFUSF9BXSA9IDB4MTAxMDEwMTA7DQogCQkJdHhfYWdjW1JGOTBfUEFU
SF9CXSA9IDB4MTAxMDEwMTA7DQogCQl9IGVsc2UgaWYgKHJ0bHByaXYtPmRtLmR5bmFtaWNfdHho
aWdocG93ZXJfbHZsID09DQotCQkJICAgVFhISUdIUFdSTEVWRUxfTEVWRUwxKSB7DQorCQkJICAg
VFhISUdIUFdSTEVWRUxfTEVWRUwyKSB7DQogCQkJdHhfYWdjW1JGOTBfUEFUSF9BXSA9IDB4MDAw
MDAwMDA7DQogCQkJdHhfYWdjW1JGOTBfUEFUSF9CXSA9IDB4MDAwMDAwMDA7DQogCQl9IGVsc2V7
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3Uvc3cu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L3N3LmMNCmluZGV4IDA5
ODRkY2YuLjAxNmVmODYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZp
L3J0bDgxOTJjdS9zdy5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgx
OTJjdS9zdy5jDQpAQCAtMzY3LDYgKzM2Nyw3IEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9p
ZCBydGw4MTkyY191c2JfaWRzW10gPSB7DQogCXtSVExfVVNCX0RFVklDRSgweDIwMDEsIDB4MzMw
YSwgcnRsOTJjdV9oYWxfY2ZnKX0sIC8qRC1MaW5rLUFscGhhKi8NCiAJe1JUTF9VU0JfREVWSUNF
KDB4MjAxOSwgMHhhYjJiLCBydGw5MmN1X2hhbF9jZmcpfSwgLypQbGFuZXggLUFib2NvbSovDQog
CXtSVExfVVNCX0RFVklDRSgweDIwZjQsIDB4NjI0ZCwgcnRsOTJjdV9oYWxfY2ZnKX0sIC8qVFJF
TkROZXQqLw0KKwl7UlRMX1VTQl9ERVZJQ0UoMHgyMzU3LCAweDAxMDAsIHJ0bDkyY3VfaGFsX2Nm
Zyl9LCAvKlRQLUxpbmsgV044MjAwTkQqLw0KIAl7UlRMX1VTQl9ERVZJQ0UoMHg3MzkyLCAweDc4
MjIsIHJ0bDkyY3VfaGFsX2NmZyl9LCAvKkVkaW1heCAtRWRpbWF4Ki8NCiAJe30NCiB9Ow0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3F1aXJrcy5jIGIvZHJpdmVycy9wY2kvcXVpcmtzLmMNCmlu
ZGV4IGNhYjI0ZjcuLmYwYzhjNWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3BjaS9xdWlya3MuYw0K
KysrIGIvZHJpdmVycy9wY2kvcXVpcmtzLmMNCkBAIC0xMTIzLDYgKzExMjMsOCBAQCBERUNMQVJF
X1BDSV9GSVhVUF9IRUFERVIoUENJX1ZFTkRPUl9JRF9BVEksIFBDSV9ERVZJQ0VfSURfQVRJX0lY
UDcwMF9TQVRBLCBxdWlyaw0KIERFQ0xBUkVfUENJX0ZJWFVQX1JFU1VNRV9FQVJMWShQQ0lfVkVO
RE9SX0lEX0FUSSwgUENJX0RFVklDRV9JRF9BVElfSVhQNzAwX1NBVEEsIHF1aXJrX2FtZF9pZGVf
bW9kZSk7DQogREVDTEFSRV9QQ0lfRklYVVBfSEVBREVSKFBDSV9WRU5ET1JfSURfQU1ELCBQQ0lf
REVWSUNFX0lEX0FNRF9IVURTT04yX1NBVEFfSURFLCBxdWlya19hbWRfaWRlX21vZGUpOw0KIERF
Q0xBUkVfUENJX0ZJWFVQX1JFU1VNRV9FQVJMWShQQ0lfVkVORE9SX0lEX0FNRCwgUENJX0RFVklD
RV9JRF9BTURfSFVEU09OMl9TQVRBX0lERSwgcXVpcmtfYW1kX2lkZV9tb2RlKTsNCitERUNMQVJF
X1BDSV9GSVhVUF9IRUFERVIoUENJX1ZFTkRPUl9JRF9BTUQsIDB4NzkwMCwgcXVpcmtfYW1kX2lk
ZV9tb2RlKTsNCitERUNMQVJFX1BDSV9GSVhVUF9SRVNVTUVfRUFSTFkoUENJX1ZFTkRPUl9JRF9B
TUQsIDB4NzkwMCwgcXVpcmtfYW1kX2lkZV9tb2RlKTsNCiANCiAvKg0KICAqCVNlcnZlcndvcmtz
IENTQjUgSURFIGRvZXMgbm90IGZ1bGx5IHN1cHBvcnQgbmF0aXZlIG1vZGUNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3J0Yy9ydGMtcnYzMDI5YzIuYyBiL2RyaXZlcnMvcnRjL3J0Yy1ydjMwMjljMi5j
DQppbmRleCBlYTA5ZmYyLi41MzE3ZDk0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ydGMvcnRjLXJ2
MzAyOWMyLmMNCisrKyBiL2RyaXZlcnMvcnRjL3J0Yy1ydjMwMjljMi5jDQpAQCAtMzEwLDcgKzMx
MCw3IEBAIHN0YXRpYyBpbnQgcnYzMDI5YzJfcnRjX2kyY19zZXRfYWxhcm0oc3RydWN0IGkyY19j
bGllbnQgKmNsaWVudCwNCiAJCWRldl9kYmcoJmNsaWVudC0+ZGV2LCAiYWxhcm0gSVJRIGFybWVk
XG4iKTsNCiAJfSBlbHNlIHsNCiAJCS8qIGRpc2FibGUgQUlFIGlycSAqLw0KLQkJcmV0ID0gcnYz
MDI5YzJfcnRjX2kyY19hbGFybV9zZXRfaXJxKGNsaWVudCwgMSk7DQorCQlyZXQgPSBydjMwMjlj
Ml9ydGNfaTJjX2FsYXJtX3NldF9pcnEoY2xpZW50LCAwKTsNCiAJCWlmIChyZXQpDQogCQkJcmV0
dXJuIHJldDsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3MzOTAvc2NzaS96ZmNwX2F1eC5jIGIv
ZHJpdmVycy9zMzkwL3Njc2kvemZjcF9hdXguYw0KaW5kZXggNGYxYjEwYi4uMzc0M2FjOSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvczM5MC9zY3NpL3pmY3BfYXV4LmMNCisrKyBiL2RyaXZlcnMvczM5
MC9zY3NpL3pmY3BfYXV4LmMNCkBAIC0zLDcgKzMsNyBAQA0KICAqDQogICogTW9kdWxlIGludGVy
ZmFjZSBhbmQgaGFuZGxpbmcgb2YgemZjcCBkYXRhIHN0cnVjdHVyZXMuDQogICoNCi0gKiBDb3B5
cmlnaHQgSUJNIENvcnBvcmF0aW9uIDIwMDIsIDIwMTANCisgKiBDb3B5cmlnaHQgSUJNIENvcnAu
IDIwMDIsIDIwMTMNCiAgKi8NCiANCiAvKg0KQEAgLTIzLDYgKzIzLDcgQEANCiAgKiAgICAgICAg
ICAgIENocmlzdG9mIFNjaG1pdHQNCiAgKiAgICAgICAgICAgIE1hcnRpbiBQZXRlcm1hbm4NCiAg
KiAgICAgICAgICAgIFN2ZW4gU2NodWV0eg0KKyAqICAgICAgICAgICAgU3RlZmZlbiBNYWllcg0K
ICAqLw0KIA0KICNkZWZpbmUgS01TR19DT01QT05FTlQgInpmY3AiDQpAQCAtNDE1LDYgKzQxNiw4
IEBAIHN0cnVjdCB6ZmNwX2FkYXB0ZXIgKnpmY3BfYWRhcHRlcl9lbnF1ZXVlKHN0cnVjdCBjY3df
ZGV2aWNlICpjY3dfZGV2aWNlKQ0KIAlhZGFwdGVyLT5kbWFfcGFybXMubWF4X3NlZ21lbnRfc2l6
ZSA9IFpGQ1BfUURJT19TQkFMRV9MRU47DQogCWFkYXB0ZXItPmNjd19kZXZpY2UtPmRldi5kbWFf
cGFybXMgPSAmYWRhcHRlci0+ZG1hX3Bhcm1zOw0KIA0KKwlhZGFwdGVyLT5zdGF0X3JlYWRfYnVm
X251bSA9IEZTRl9TVEFUVVNfUkVBRFNfUkVDT007DQorDQogCWlmICghemZjcF9zY3NpX2FkYXB0
ZXJfcmVnaXN0ZXIoYWRhcHRlcikpDQogCQlyZXR1cm4gYWRhcHRlcjsNCiANCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3MzOTAvc2NzaS96ZmNwX2ZzZi5jIGIvZHJpdmVycy9zMzkwL3Njc2kvemZjcF9m
c2YuYw0KaW5kZXggOGM4NDlmMC4uOGJmZDU3OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvczM5MC9z
Y3NpL3pmY3BfZnNmLmMNCisrKyBiL2RyaXZlcnMvczM5MC9zY3NpL3pmY3BfZnNmLmMNCkBAIC0z
LDcgKzMsNyBAQA0KICAqDQogICogSW1wbGVtZW50YXRpb24gb2YgRlNGIGNvbW1hbmRzLg0KICAq
DQotICogQ29weXJpZ2h0IElCTSBDb3Jwb3JhdGlvbiAyMDAyLCAyMDEwDQorICogQ29weXJpZ2h0
IElCTSBDb3JwLiAyMDAyLCAyMDEzDQogICovDQogDQogI2RlZmluZSBLTVNHX0NPTVBPTkVOVCAi
emZjcCINCkBAIC00NTUsMTEgKzQ1NSw4IEBAIHN0YXRpYyBpbnQgemZjcF9mc2ZfZXhjaGFuZ2Vf
Y29uZmlnX2V2YWx1YXRlKHN0cnVjdCB6ZmNwX2ZzZl9yZXEgKnJlcSkNCiANCiAJZmNfaG9zdF9w
b3J0X25hbWUoc2hvc3QpID0gbnNwLT5mbF93d3BuOw0KIAlmY19ob3N0X25vZGVfbmFtZShzaG9z
dCkgPSBuc3AtPmZsX3d3bm47DQotCWZjX2hvc3RfcG9ydF9pZChzaG9zdCkgPSBudG9oMjQoYm90
dG9tLT5zX2lkKTsNCi0JZmNfaG9zdF9zcGVlZChzaG9zdCkgPSBib3R0b20tPmZjX2xpbmtfc3Bl
ZWQ7DQogCWZjX2hvc3Rfc3VwcG9ydGVkX2NsYXNzZXMoc2hvc3QpID0gRkNfQ09TX0NMQVNTMiB8
IEZDX0NPU19DTEFTUzM7DQogDQotCWFkYXB0ZXItPmh5ZHJhX3ZlcnNpb24gPSBib3R0b20tPmFk
YXB0ZXJfdHlwZTsNCiAJYWRhcHRlci0+dGltZXJfdGlja3MgPSBib3R0b20tPnRpbWVyX2ludGVy
dmFsICYgWkZDUF9GU0ZfVElNRVJfSU5UX01BU0s7DQogCWFkYXB0ZXItPnN0YXRfcmVhZF9idWZf
bnVtID0gbWF4KGJvdHRvbS0+c3RhdHVzX3JlYWRfYnVmX251bSwNCiAJCQkJCSAodTE2KUZTRl9T
VEFUVVNfUkVBRFNfUkVDT00pOw0KQEAgLTQ2Nyw2ICs0NjQsMTggQEAgc3RhdGljIGludCB6ZmNw
X2ZzZl9leGNoYW5nZV9jb25maWdfZXZhbHVhdGUoc3RydWN0IHpmY3BfZnNmX3JlcSAqcmVxKQ0K
IAlpZiAoZmNfaG9zdF9wZXJtYW5lbnRfcG9ydF9uYW1lKHNob3N0KSA9PSAtMSkNCiAJCWZjX2hv
c3RfcGVybWFuZW50X3BvcnRfbmFtZShzaG9zdCkgPSBmY19ob3N0X3BvcnRfbmFtZShzaG9zdCk7
DQogDQorCXpmY3Bfc2NzaV9zZXRfcHJvdChhZGFwdGVyKTsNCisNCisJLyogbm8gZXJyb3IgcmV0
dXJuIGFib3ZlIGhlcmUsIG90aGVyd2lzZSBtdXN0IGZpeCBjYWxsIGNoYWlucyAqLw0KKwkvKiBk
byBub3QgZXZhbHVhdGUgaW52YWxpZCBmaWVsZHMgKi8NCisJaWYgKHJlcS0+cXRjYi0+aGVhZGVy
LmZzZl9zdGF0dXMgPT0gRlNGX0VYQ0hBTkdFX0NPTkZJR19EQVRBX0lOQ09NUExFVEUpDQorCQly
ZXR1cm4gMDsNCisNCisJZmNfaG9zdF9wb3J0X2lkKHNob3N0KSA9IG50b2gyNChib3R0b20tPnNf
aWQpOw0KKwlmY19ob3N0X3NwZWVkKHNob3N0KSA9IGJvdHRvbS0+ZmNfbGlua19zcGVlZDsNCisN
CisJYWRhcHRlci0+aHlkcmFfdmVyc2lvbiA9IGJvdHRvbS0+YWRhcHRlcl90eXBlOw0KKw0KIAlz
d2l0Y2ggKGJvdHRvbS0+ZmNfdG9wb2xvZ3kpIHsNCiAJY2FzZSBGU0ZfVE9QT19QMlA6DQogCQlh
ZGFwdGVyLT5wZWVyX2RfaWQgPSBudG9oMjQoYm90dG9tLT5wZWVyX2RfaWQpOw0KQEAgLTQ4OCw4
ICs0OTcsNiBAQCBzdGF0aWMgaW50IHpmY3BfZnNmX2V4Y2hhbmdlX2NvbmZpZ19ldmFsdWF0ZShz
dHJ1Y3QgemZjcF9mc2ZfcmVxICpyZXEpDQogCQlyZXR1cm4gLUVJTzsNCiAJfQ0KIA0KLQl6ZmNw
X3Njc2lfc2V0X3Byb3QoYWRhcHRlcik7DQotDQogCXJldHVybiAwOw0KIH0NCiANCkBAIC01MzQs
OCArNTQxLDE0IEBAIHN0YXRpYyB2b2lkIHpmY3BfZnNmX2V4Y2hhbmdlX2NvbmZpZ19kYXRhX2hh
bmRsZXIoc3RydWN0IHpmY3BfZnNmX3JlcSAqcmVxKQ0KIAkJZmNfaG9zdF9wb3J0X3R5cGUoc2hv
c3QpID0gRkNfUE9SVFRZUEVfVU5LTk9XTjsNCiAJCWFkYXB0ZXItPmh5ZHJhX3ZlcnNpb24gPSAw
Ow0KIA0KKwkJLyogYXZvaWRzIGFkYXB0ZXIgc2h1dGRvd24gdG8gYmUgYWJsZSB0byByZWNvZ25p
emUNCisJCSAqIGV2ZW50cyBzdWNoIGFzIExJTksgVVAgKi8NCisJCWF0b21pY19zZXRfbWFzayha
RkNQX1NUQVRVU19BREFQVEVSX1hDT05GSUdfT0ssDQorCQkJCSZhZGFwdGVyLT5zdGF0dXMpOw0K
IAkJemZjcF9mc2ZfbGlua19kb3duX2luZm9fZXZhbChyZXEsDQogCQkJJnF0Y2ItPmhlYWRlci5m
c2Zfc3RhdHVzX3F1YWwubGlua19kb3duX2luZm8pOw0KKwkJaWYgKHpmY3BfZnNmX2V4Y2hhbmdl
X2NvbmZpZ19ldmFsdWF0ZShyZXEpKQ0KKwkJCXJldHVybjsNCiAJCWJyZWFrOw0KIAlkZWZhdWx0
Og0KIAkJemZjcF9lcnBfYWRhcHRlcl9zaHV0ZG93bihhZGFwdGVyLCAwLCAiZnNlY2RoMyIpOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvczM5MC9zY3NpL3pmY3Bfc2NzaS5jIGIvZHJpdmVycy9zMzkw
L3Njc2kvemZjcF9zY3NpLmMNCmluZGV4IGI3OTU3NmIuLjdiMzUzNjQgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3MzOTAvc2NzaS96ZmNwX3Njc2kuYw0KKysrIGIvZHJpdmVycy9zMzkwL3Njc2kvemZj
cF9zY3NpLmMNCkBAIC0zLDcgKzMsNyBAQA0KICAqDQogICogSW50ZXJmYWNlIHRvIExpbnV4IFND
U0kgbWlkbGF5ZXIuDQogICoNCi0gKiBDb3B5cmlnaHQgSUJNIENvcnBvcmF0aW9uIDIwMDIsIDIw
MTANCisgKiBDb3B5cmlnaHQgSUJNIENvcnAuIDIwMDIsIDIwMTMNCiAgKi8NCiANCiAjZGVmaW5l
IEtNU0dfQ09NUE9ORU5UICJ6ZmNwIg0KQEAgLTMxMSw4ICszMTEsMTIgQEAgc3RhdGljIHN0cnVj
dCBzY3NpX2hvc3RfdGVtcGxhdGUgemZjcF9zY3NpX2hvc3RfdGVtcGxhdGUgPSB7DQogCS5wcm9j
X25hbWUJCSA9ICJ6ZmNwIiwNCiAJLmNhbl9xdWV1ZQkJID0gNDA5NiwNCiAJLnRoaXNfaWQJCSA9
IC0xLA0KLQkuc2dfdGFibGVzaXplCQkgPSAxLCAvKiBhZGp1c3RlZCBsYXRlciAqLw0KLQkubWF4
X3NlY3RvcnMJCSA9IDgsIC8qIGFkanVzdGVkIGxhdGVyICovDQorCS5zZ190YWJsZXNpemUJCSA9
ICgoKFFESU9fTUFYX0VMRU1FTlRTX1BFUl9CVUZGRVIgLSAxKQ0KKwkJCQkgICAgICogWkZDUF9R
RElPX01BWF9TQkFMU19QRVJfUkVRKSAtIDIpLA0KKwkJCQkgICAvKiBHQ0QsIGFkanVzdGVkIGxh
dGVyICovDQorCS5tYXhfc2VjdG9ycwkJID0gKCgoUURJT19NQVhfRUxFTUVOVFNfUEVSX0JVRkZF
UiAtIDEpDQorCQkJCSAgICAgKiBaRkNQX1FESU9fTUFYX1NCQUxTX1BFUl9SRVEpIC0gMikgKiA4
LA0KKwkJCQkgICAvKiBHQ0QsIGFkanVzdGVkIGxhdGVyICovDQogCS5kbWFfYm91bmRhcnkJCSA9
IFpGQ1BfUURJT19TQkFMRV9MRU4gLSAxLA0KIAkuY21kX3Blcl9sdW4JCSA9IDEsDQogCS51c2Vf
Y2x1c3RlcmluZwkJID0gMSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYyBiL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jDQppbmRleCA3YzQ3MWViLi5mYzVhMmVmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMNCisrKyBiL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jDQpAQCAtNDg4NiwxMCArNDg4NiwxMiBAQCBtZWdhc2FzX21nbXRf
ZndfaW9jdGwoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLA0KIAkJCQkgICAgc2Vu
c2UsIHNlbnNlX2hhbmRsZSk7DQogCX0NCiANCi0JZm9yIChpID0gMDsgaSA8IGlvYy0+c2dlX2Nv
dW50ICYmIGtidWZmX2FycltpXTsgaSsrKSB7DQotCQlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFu
Y2UtPnBkZXYtPmRldiwNCi0JCQkJICAgIGtlcm5fc2dlMzJbaV0ubGVuZ3RoLA0KLQkJCQkgICAg
a2J1ZmZfYXJyW2ldLCBrZXJuX3NnZTMyW2ldLnBoeXNfYWRkcik7DQorCWZvciAoaSA9IDA7IGkg
PCBpb2MtPnNnZV9jb3VudDsgaSsrKSB7DQorCQlpZiAoa2J1ZmZfYXJyW2ldKQ0KKwkJCWRtYV9m
cmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+ZGV2LA0KKwkJCQkJICBrZXJuX3NnZTMyW2ld
Lmxlbmd0aCwNCisJCQkJCSAga2J1ZmZfYXJyW2ldLA0KKwkJCQkJICBrZXJuX3NnZTMyW2ldLnBo
eXNfYWRkcik7DQogCX0NCiANCiAJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfYmFzZS5jIGIvZHJpdmVy
cy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMNCmluZGV4IDE3ZGUzNDguLmExMWE5MDkgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2FzX2Jhc2UuYw0KKysrIGIvZHJp
dmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMNCkBAIC03OSwxMCArNzksNiBAQCBzdGF0
aWMgaW50IG1zaXhfZGlzYWJsZSA9IC0xOw0KIG1vZHVsZV9wYXJhbShtc2l4X2Rpc2FibGUsIGlu
dCwgMCk7DQogTU9EVUxFX1BBUk1fREVTQyhtc2l4X2Rpc2FibGUsICIgZGlzYWJsZSBtc2l4IHJv
dXRlZCBpbnRlcnJ1cHRzIChkZWZhdWx0PTApIik7DQogDQotc3RhdGljIGludCBtaXNzaW5nX2Rl
bGF5WzJdID0gey0xLCAtMX07DQotbW9kdWxlX3BhcmFtX2FycmF5KG1pc3NpbmdfZGVsYXksIGlu
dCwgTlVMTCwgMCk7DQotTU9EVUxFX1BBUk1fREVTQyhtaXNzaW5nX2RlbGF5LCAiIGRldmljZSBt
aXNzaW5nIGRlbGF5ICwgaW8gbWlzc2luZyBkZWxheSIpOw0KLQ0KIHN0YXRpYyBpbnQgbXB0MnNh
c19md2ZhdWx0X2RlYnVnOw0KIE1PRFVMRV9QQVJNX0RFU0MobXB0MnNhc19md2ZhdWx0X2RlYnVn
LCAiIGVuYWJsZSBkZXRlY3Rpb24gb2YgZmlybXdhcmUgZmF1bHQgIg0KIAkiYW5kIGhhbHQgZmly
bXdhcmUgLSAoZGVmYXVsdD0wKSIpOw0KQEAgLTIxMDQsNyArMjEwMCw3IEBAIF9iYXNlX2Rpc3Bs
YXlfaW9jX2NhcGFiaWxpdGllcyhzdHJ1Y3QgTVBUMlNBU19BREFQVEVSICppb2MpDQogfQ0KIA0K
IC8qKg0KLSAqIF9iYXNlX3VwZGF0ZV9taXNzaW5nX2RlbGF5IC0gY2hhbmdlIHRoZSBtaXNzaW5n
IGRlbGF5IHRpbWVycw0KKyAqIG1wdDJzYXNfYmFzZV91cGRhdGVfbWlzc2luZ19kZWxheSAtIGNo
YW5nZSB0aGUgbWlzc2luZyBkZWxheSB0aW1lcnMNCiAgKiBAaW9jOiBwZXIgYWRhcHRlciBvYmpl
Y3QNCiAgKiBAZGV2aWNlX21pc3NpbmdfZGVsYXk6IGFtb3VudCBvZiB0aW1lIHRpbGwgZGV2aWNl
IGlzIHJlcG9ydGVkIG1pc3NpbmcNCiAgKiBAaW9fbWlzc2luZ19kZWxheTogaW50ZXJ2YWwgSU8g
aXMgcmV0dXJuZWQgd2hlbiB0aGVyZSBpcyBhIG1pc3NpbmcgZGV2aWNlDQpAQCAtMjExNSw4ICsy
MTExLDggQEAgX2Jhc2VfZGlzcGxheV9pb2NfY2FwYWJpbGl0aWVzKHN0cnVjdCBNUFQyU0FTX0FE
QVBURVIgKmlvYykNCiAgKiBkZWxheSwgYXMgd2VsbCBhcyB0aGUgaW8gbWlzc2luZyBkZWxheS4g
VGhpcyBzaG91bGQgYmUgY2FsbGVkIGF0IGRyaXZlcg0KICAqIGxvYWQgdGltZS4NCiAgKi8NCi1z
dGF0aWMgdm9pZA0KLV9iYXNlX3VwZGF0ZV9taXNzaW5nX2RlbGF5KHN0cnVjdCBNUFQyU0FTX0FE
QVBURVIgKmlvYywNCit2b2lkDQorbXB0MnNhc19iYXNlX3VwZGF0ZV9taXNzaW5nX2RlbGF5KHN0
cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYywNCiAJdTE2IGRldmljZV9taXNzaW5nX2RlbGF5LCB1
OCBpb19taXNzaW5nX2RlbGF5KQ0KIHsNCiAJdTE2IGRtZCwgZG1kX25ldywgZG1kX29yaWduYWw7
DQpAQCAtNDMwMiw5ICs0Mjk4LDYgQEAgbXB0MnNhc19iYXNlX2F0dGFjaChzdHJ1Y3QgTVBUMlNB
U19BREFQVEVSICppb2MpDQogCWlmIChyKQ0KIAkJZ290byBvdXRfZnJlZV9yZXNvdXJjZXM7DQog
DQotCWlmIChtaXNzaW5nX2RlbGF5WzBdICE9IC0xICYmIG1pc3NpbmdfZGVsYXlbMV0gIT0gLTEp
DQotCQlfYmFzZV91cGRhdGVfbWlzc2luZ19kZWxheShpb2MsIG1pc3NpbmdfZGVsYXlbMF0sDQot
CQkgICAgbWlzc2luZ19kZWxheVsxXSk7DQogDQogCXJldHVybiAwOw0KIA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfYmFzZS5oIGIvZHJpdmVycy9zY3NpL21wdDJz
YXMvbXB0MnNhc19iYXNlLmgNCmluZGV4IDNjM2JhYmMuLmFhNGRhZjYgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2FzX2Jhc2UuaA0KKysrIGIvZHJpdmVycy9zY3NpL21w
dDJzYXMvbXB0MnNhc19iYXNlLmgNCkBAIC0xMDI5LDYgKzEwMjksOSBAQCB2b2lkIG1wdDJzYXNf
YmFzZV92YWxpZGF0ZV9ldmVudF90eXBlKHN0cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYywgdTMy
ICpldmVudF90eQ0KIA0KIHZvaWQgbXB0MnNhc19oYWx0X2Zpcm13YXJlKHN0cnVjdCBNUFQyU0FT
X0FEQVBURVIgKmlvYyk7DQogDQordm9pZCBtcHQyc2FzX2Jhc2VfdXBkYXRlX21pc3NpbmdfZGVs
YXkoc3RydWN0IE1QVDJTQVNfQURBUFRFUiAqaW9jLA0KKwl1MTYgZGV2aWNlX21pc3NpbmdfZGVs
YXksIHU4IGlvX21pc3NpbmdfZGVsYXkpOw0KKw0KIGludCBtcHQyc2FzX3BvcnRfZW5hYmxlKHN0
cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYyk7DQogDQogLyogc2NzaWggc2hhcmVkIEFQSSAqLw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYyBiL2RyaXZl
cnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYw0KaW5kZXggMjgyNGE5MC4uOTg3YzZkNiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYw0KKysrIGIv
ZHJpdmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19zY3NpaC5jDQpAQCAtMTAxLDYgKzEwMSwxMCBA
QCBzdGF0aWMgdXNob3J0IG1heF9zZWN0b3JzID0gMHhGRkZGOw0KIG1vZHVsZV9wYXJhbShtYXhf
c2VjdG9ycywgdXNob3J0LCAwKTsNCiBNT0RVTEVfUEFSTV9ERVNDKG1heF9zZWN0b3JzLCAibWF4
IHNlY3RvcnMsIHJhbmdlIDY0IHRvIDgxOTIgIGRlZmF1bHQ9ODE5MiIpOw0KIA0KK3N0YXRpYyBp
bnQgbWlzc2luZ19kZWxheVsyXSA9IHstMSwgLTF9Ow0KK21vZHVsZV9wYXJhbV9hcnJheShtaXNz
aW5nX2RlbGF5LCBpbnQsIE5VTEwsIDApOw0KK01PRFVMRV9QQVJNX0RFU0MobWlzc2luZ19kZWxh
eSwgIiBkZXZpY2UgbWlzc2luZyBkZWxheSAsIGlvIG1pc3NpbmcgZGVsYXkiKTsNCisNCiAvKiBz
Y3NpLW1pZCBsYXllciBnbG9iYWwgcGFybWV0ZXIgaXMgbWF4X3JlcG9ydF9sdW5zLCB3aGljaCBp
cyA1MTEgKi8NCiAjZGVmaW5lIE1QVDJTQVNfTUFYX0xVTiAoMTY4OTUpDQogc3RhdGljIGludCBt
YXhfbHVuID0gTVBUMlNBU19NQVhfTFVOOw0KQEAgLTM5MzAsMTEgKzM5MzQsNyBAQCBfc2NzaWhf
cWNtZF9sY2soc3RydWN0IHNjc2lfY21uZCAqc2NtZCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3Np
X2NtbmQgKikpDQogCQkJZWxzZQ0KIAkJCQltcGlfY29udHJvbCB8PSBNUEkyX1NDU0lJT19DT05U
Uk9MX1NJTVBMRVE7DQogCQl9IGVsc2UNCi0vKiBNUEkgUmV2aXNpb24gSSAoVU5JVCA9IDB4QSkg
LSByZW1vdmVkIE1QSTJfU0NTSUlPX0NPTlRST0xfVU5UQUdHRUQgKi8NCi0vKgkJCW1waV9jb250
cm9sIHw9IE1QSTJfU0NTSUlPX0NPTlRST0xfVU5UQUdHRUQ7DQotICovDQotCQkJbXBpX2NvbnRy
b2wgfD0gKDB4NTAwKTsNCi0NCisJCQltcGlfY29udHJvbCB8PSBNUEkyX1NDU0lJT19DT05UUk9M
X1NJTVBMRVE7DQogCX0gZWxzZQ0KIAkJbXBpX2NvbnRyb2wgfD0gTVBJMl9TQ1NJSU9fQ09OVFJP
TF9TSU1QTEVROw0KIAkvKiBNYWtlIHN1cmUgRGV2aWNlIGlzIG5vdCByYWlkIHZvbHVtZS4NCkBA
IC03MDA2LDExICs3MDA2LDE0IEBAIF9zY3NpaF9zY2FuX2Zvcl9kZXZpY2VzX2FmdGVyX3Jlc2V0
KHN0cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYykNCiAJc3RydWN0IF9zYXNfZGV2aWNlICpzYXNf
ZGV2aWNlOw0KIAlzdHJ1Y3QgX3Nhc19ub2RlICpleHBhbmRlcl9kZXZpY2U7DQogCXN0YXRpYyBz
dHJ1Y3QgX3JhaWRfZGV2aWNlICpyYWlkX2RldmljZTsNCisJdTggcmV0cnlfY291bnQ7DQogDQog
CXByaW50ayhNUFQyU0FTX0lORk9fRk1UICJzY2FuIGRldmljZXM6IHN0YXJ0XG4iLCBpb2MtPm5h
bWUpOw0KIA0KIAlfc2NzaWhfc2FzX2hvc3RfcmVmcmVzaChpb2MpOw0KIA0KKwlwcmludGsoTVBU
MlNBU19JTkZPX0ZNVCAiXHRzY2FuIGRldmljZXM6IGV4cGFuZGVycyBzdGFydFxuIiwNCisJCWlv
Yy0+bmFtZSk7DQogCS8qIGV4cGFuZGVycyAqLw0KIAloYW5kbGUgPSAweEZGRkY7DQogCXdoaWxl
ICghKG1wdDJzYXNfY29uZmlnX2dldF9leHBhbmRlcl9wZzAoaW9jLCAmbXBpX3JlcGx5LCAmZXhw
YW5kZXJfcGcwLA0KQEAgLTcwMTksMTkgKzcwMjIsMzkgQEAgX3Njc2loX3NjYW5fZm9yX2Rldmlj
ZXNfYWZ0ZXJfcmVzZXQoc3RydWN0IE1QVDJTQVNfQURBUFRFUiAqaW9jKQ0KIAkJICAgIE1QSTJf
SU9DU1RBVFVTX01BU0s7DQogCQlpZiAoaW9jX3N0YXR1cyA9PSBNUEkyX0lPQ1NUQVRVU19DT05G
SUdfSU5WQUxJRF9QQUdFKQ0KIAkJCWJyZWFrOw0KKwkJaWYgKGlvY19zdGF0dXMgIT0gTVBJMl9J
T0NTVEFUVVNfU1VDQ0VTUykgew0KKwkJCXByaW50ayhNUFQyU0FTX0lORk9fRk1UICJcdGJyZWFr
IGZyb20gZXhwYW5kZXIgc2NhbjogIg0KKwkJCQkiaW9jX3N0YXR1cygweCUwNHgpLCBsb2dpbmZv
KDB4JTA4eClcbiIsDQorCQkJCWlvYy0+bmFtZSwgaW9jX3N0YXR1cywNCisJCQkJbGUzMl90b19j
cHUobXBpX3JlcGx5LklPQ0xvZ0luZm8pKTsNCisJCQlicmVhazsNCisJCX0NCiAJCWhhbmRsZSA9
IGxlMTZfdG9fY3B1KGV4cGFuZGVyX3BnMC5EZXZIYW5kbGUpOw0KIAkJZXhwYW5kZXJfZGV2aWNl
ID0gbXB0MnNhc19zY3NpaF9leHBhbmRlcl9maW5kX2J5X3Nhc19hZGRyZXNzKA0KIAkJICAgIGlv
YywgbGU2NF90b19jcHUoZXhwYW5kZXJfcGcwLlNBU0FkZHJlc3MpKTsNCiAJCWlmIChleHBhbmRl
cl9kZXZpY2UpDQogCQkJX3Njc2loX3JlZnJlc2hfZXhwYW5kZXJfbGlua3MoaW9jLCBleHBhbmRl
cl9kZXZpY2UsDQogCQkJICAgIGhhbmRsZSk7DQotCQllbHNlDQorCQllbHNlIHsNCisJCQlwcmlu
dGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRCRUZPUkUgYWRkaW5nIGV4cGFuZGVyOiAiDQorCQkJCSJo
YW5kbGUgKDB4JTA0eCksIHNhc19hZGRyKDB4JTAxNmxseClcbiIsDQorCQkJCWlvYy0+bmFtZSwg
aGFuZGxlLCAodW5zaWduZWQgbG9uZyBsb25nKQ0KKwkJCQlsZTY0X3RvX2NwdShleHBhbmRlcl9w
ZzAuU0FTQWRkcmVzcykpOw0KIAkJCV9zY3NpaF9leHBhbmRlcl9hZGQoaW9jLCBoYW5kbGUpOw0K
KwkJCXByaW50ayhNUFQyU0FTX0lORk9fRk1UICJcdEFGVEVSIGFkZGluZyBleHBhbmRlcjogIg0K
KwkJCQkiaGFuZGxlICgweCUwNHgpLCBzYXNfYWRkcigweCUwMTZsbHgpXG4iLA0KKwkJCQlpb2Mt
Pm5hbWUsIGhhbmRsZSwgKHVuc2lnbmVkIGxvbmcgbG9uZykNCisJCQkJbGU2NF90b19jcHUoZXhw
YW5kZXJfcGcwLlNBU0FkZHJlc3MpKTsNCisJCX0NCiAJfQ0KIA0KKwlwcmludGsoTVBUMlNBU19J
TkZPX0ZNVCAiXHRzY2FuIGRldmljZXM6IGV4cGFuZGVycyBjb21wbGV0ZVxuIiwNCisJCWlvYy0+
bmFtZSk7DQorDQogCWlmICghaW9jLT5pcl9maXJtd2FyZSkNCiAJCWdvdG8gc2tpcF90b19zYXM7
DQogDQorCXByaW50ayhNUFQyU0FTX0lORk9fRk1UICJcdHNjYW4gZGV2aWNlcyBwaHlzIGRpc2sg
c3RhcnRcbiIsIGlvYy0+bmFtZSk7DQogCS8qIHBoeXMgZGlzayAqLw0KIAlwaHlzX2Rpc2tfbnVt
ID0gMHhGRjsNCiAJd2hpbGUgKCEobXB0MnNhc19jb25maWdfZ2V0X3BoeXNfZGlza19wZzAoaW9j
LCAmbXBpX3JlcGx5LA0KQEAgLTcwNDEsNiArNzA2NCwxMyBAQCBfc2NzaWhfc2Nhbl9mb3JfZGV2
aWNlc19hZnRlcl9yZXNldChzdHJ1Y3QgTVBUMlNBU19BREFQVEVSICppb2MpDQogCQkgICAgTVBJ
Ml9JT0NTVEFUVVNfTUFTSzsNCiAJCWlmIChpb2Nfc3RhdHVzID09IE1QSTJfSU9DU1RBVFVTX0NP
TkZJR19JTlZBTElEX1BBR0UpDQogCQkJYnJlYWs7DQorCQlpZiAoaW9jX3N0YXR1cyAhPSBNUEky
X0lPQ1NUQVRVU19TVUNDRVNTKSB7DQorCQkJcHJpbnRrKE1QVDJTQVNfSU5GT19GTVQgIlx0YnJl
YWsgZnJvbSBwaHlzIGRpc2sgc2NhbjoiDQorCQkJCSJpb2Nfc3RhdHVzKDB4JTA0eCksIGxvZ2lu
Zm8oMHglMDh4KVxuIiwNCisJCQkJaW9jLT5uYW1lLCBpb2Nfc3RhdHVzLA0KKwkJCQlsZTMyX3Rv
X2NwdShtcGlfcmVwbHkuSU9DTG9nSW5mbykpOw0KKwkJCWJyZWFrOw0KKwkJfQ0KIAkJcGh5c19k
aXNrX251bSA9IHBkX3BnMC5QaHlzRGlza051bTsNCiAJCWhhbmRsZSA9IGxlMTZfdG9fY3B1KHBk
X3BnMC5EZXZIYW5kbGUpOw0KIAkJc2FzX2RldmljZSA9IF9zY3NpaF9zYXNfZGV2aWNlX2ZpbmRf
YnlfaGFuZGxlKGlvYywgaGFuZGxlKTsNCkBAIC03MDUwLDE3ICs3MDgwLDQ2IEBAIF9zY3NpaF9z
Y2FuX2Zvcl9kZXZpY2VzX2FmdGVyX3Jlc2V0KHN0cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYykN
CiAJCSAgICAmc2FzX2RldmljZV9wZzAsIE1QSTJfU0FTX0RFVklDRV9QR0FEX0ZPUk1fSEFORExF
LA0KIAkJICAgIGhhbmRsZSkgIT0gMCkNCiAJCQljb250aW51ZTsNCisJCWlvY19zdGF0dXMgPSBs
ZTE2X3RvX2NwdShtcGlfcmVwbHkuSU9DU3RhdHVzKSAmDQorCQkJTVBJMl9JT0NTVEFUVVNfTUFT
SzsNCisJCWlmIChpb2Nfc3RhdHVzICE9IE1QSTJfSU9DU1RBVFVTX1NVQ0NFU1MpIHsNCisJCQlw
cmludGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRicmVhayBmcm9tIHBoeXMgZGlzayBzY2FuICINCisJ
CQkJImlvY19zdGF0dXMoMHglMDR4KSwgbG9naW5mbygweCUwOHgpXG4iLA0KKwkJCQlpb2MtPm5h
bWUsIGlvY19zdGF0dXMsDQorCQkJCWxlMzJfdG9fY3B1KG1waV9yZXBseS5JT0NMb2dJbmZvKSk7
DQorCQkJYnJlYWs7DQorCQl9DQogCQlwYXJlbnRfaGFuZGxlID0gbGUxNl90b19jcHUoc2FzX2Rl
dmljZV9wZzAuUGFyZW50RGV2SGFuZGxlKTsNCiAJCWlmICghX3Njc2loX2dldF9zYXNfYWRkcmVz
cyhpb2MsIHBhcmVudF9oYW5kbGUsDQogCQkgICAgJnNhc19hZGRyZXNzKSkgew0KKwkJCXByaW50
ayhNUFQyU0FTX0lORk9fRk1UICJcdEJFRk9SRSBhZGRpbmcgcGh5cyBkaXNrOiAiDQorCQkJCSIg
aGFuZGxlICgweCUwNHgpLCBzYXNfYWRkcigweCUwMTZsbHgpXG4iLA0KKwkJCQlpb2MtPm5hbWUs
IGhhbmRsZSwgKHVuc2lnbmVkIGxvbmcgbG9uZykNCisJCQkJbGU2NF90b19jcHUoc2FzX2Rldmlj
ZV9wZzAuU0FTQWRkcmVzcykpOw0KIAkJCW1wdDJzYXNfdHJhbnNwb3J0X3VwZGF0ZV9saW5rcyhp
b2MsIHNhc19hZGRyZXNzLA0KIAkJCSAgICBoYW5kbGUsIHNhc19kZXZpY2VfcGcwLlBoeU51bSwN
CiAJCQkgICAgTVBJMl9TQVNfTkVHX0xJTktfUkFURV8xXzUpOw0KIAkJCXNldF9iaXQoaGFuZGxl
LCBpb2MtPnBkX2hhbmRsZXMpOw0KLQkJCV9zY3NpaF9hZGRfZGV2aWNlKGlvYywgaGFuZGxlLCAw
LCAxKTsNCisJCQlyZXRyeV9jb3VudCA9IDA7DQorCQkJLyogVGhpcyB3aWxsIHJldHJ5IGFkZGlu
ZyB0aGUgZW5kIGRldmljZS4NCisJCQkqIF9zY3NpaF9hZGRfZGV2aWNlKCkgd2lsbCBkZWNpZGUg
b24gcmV0cmllcyBhbmQNCisJCQkqIHJldHVybiAiMSIgd2hlbiBpdCBzaG91bGQgYmUgcmV0cmll
ZA0KKwkJCSovDQorCQkJd2hpbGUgKF9zY3NpaF9hZGRfZGV2aWNlKGlvYywgaGFuZGxlLCByZXRy
eV9jb3VudCsrLA0KKwkJCQkxKSkgew0KKwkJCQkJc3NsZWVwKDEpOw0KKwkJCX0NCisJCQlwcmlu
dGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRBRlRFUiBhZGRpbmcgcGh5cyBkaXNrOiAiDQorCQkJCSIg
aGFuZGxlICgweCUwNHgpLCBzYXNfYWRkcigweCUwMTZsbHgpXG4iLA0KKwkJCQlpb2MtPm5hbWUs
IGhhbmRsZSwgKHVuc2lnbmVkIGxvbmcgbG9uZykNCisJCQkJbGU2NF90b19jcHUoc2FzX2Rldmlj
ZV9wZzAuU0FTQWRkcmVzcykpOw0KIAkJfQ0KIAl9DQogDQorCXByaW50ayhNUFQyU0FTX0lORk9f
Rk1UICJcdHNjYW4gZGV2aWNlczogcGh5cyBkaXNrIGNvbXBsZXRlXG4iLA0KKwkJaW9jLT5uYW1l
KTsNCisNCisJcHJpbnRrKE1QVDJTQVNfSU5GT19GTVQgIlx0c2NhbiBkZXZpY2VzOiB2b2x1bWVz
IHN0YXJ0XG4iLCBpb2MtPm5hbWUpOw0KIAkvKiB2b2x1bWVzICovDQogCWhhbmRsZSA9IDB4RkZG
RjsNCiAJd2hpbGUgKCEobXB0MnNhc19jb25maWdfZ2V0X3JhaWRfdm9sdW1lX3BnMShpb2MsICZt
cGlfcmVwbHksDQpAQCAtNzA2OSw2ICs3MTI4LDEzIEBAIF9zY3NpaF9zY2FuX2Zvcl9kZXZpY2Vz
X2FmdGVyX3Jlc2V0KHN0cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYykNCiAJCSAgICBNUEkyX0lP
Q1NUQVRVU19NQVNLOw0KIAkJaWYgKGlvY19zdGF0dXMgPT0gTVBJMl9JT0NTVEFUVVNfQ09ORklH
X0lOVkFMSURfUEFHRSkNCiAJCQlicmVhazsNCisJCWlmIChpb2Nfc3RhdHVzICE9IE1QSTJfSU9D
U1RBVFVTX1NVQ0NFU1MpIHsNCisJCQlwcmludGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRicmVhayBm
cm9tIHZvbHVtZSBzY2FuOiAiDQorCQkJCSJpb2Nfc3RhdHVzKDB4JTA0eCksIGxvZ2luZm8oMHgl
MDh4KVxuIiwNCisJCQkJaW9jLT5uYW1lLCBpb2Nfc3RhdHVzLA0KKwkJCQlsZTMyX3RvX2NwdSht
cGlfcmVwbHkuSU9DTG9nSW5mbykpOw0KKwkJCWJyZWFrOw0KKwkJfQ0KIAkJaGFuZGxlID0gbGUx
Nl90b19jcHUodm9sdW1lX3BnMS5EZXZIYW5kbGUpOw0KIAkJcmFpZF9kZXZpY2UgPSBfc2NzaWhf
cmFpZF9kZXZpY2VfZmluZF9ieV93d2lkKGlvYywNCiAJCSAgICBsZTY0X3RvX2NwdSh2b2x1bWVf
cGcxLldXSUQpKTsNCkBAIC03MDc4LDE4ICs3MTQ0LDM4IEBAIF9zY3NpaF9zY2FuX2Zvcl9kZXZp
Y2VzX2FmdGVyX3Jlc2V0KHN0cnVjdCBNUFQyU0FTX0FEQVBURVIgKmlvYykNCiAJCSAgICAmdm9s
dW1lX3BnMCwgTVBJMl9SQUlEX1ZPTFVNRV9QR0FEX0ZPUk1fSEFORExFLCBoYW5kbGUsDQogCQkg
ICAgIHNpemVvZihNcGkyUmFpZFZvbFBhZ2UwX3QpKSkNCiAJCQljb250aW51ZTsNCisJCWlvY19z
dGF0dXMgPSBsZTE2X3RvX2NwdShtcGlfcmVwbHkuSU9DU3RhdHVzKSAmDQorCQkJTVBJMl9JT0NT
VEFUVVNfTUFTSzsNCisJCWlmIChpb2Nfc3RhdHVzICE9IE1QSTJfSU9DU1RBVFVTX1NVQ0NFU1Mp
IHsNCisJCQlwcmludGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRicmVhayBmcm9tIHZvbHVtZSBzY2Fu
OiAiDQorCQkJCSJpb2Nfc3RhdHVzKDB4JTA0eCksIGxvZ2luZm8oMHglMDh4KVxuIiwNCisJCQkJ
aW9jLT5uYW1lLCBpb2Nfc3RhdHVzLA0KKwkJCQlsZTMyX3RvX2NwdShtcGlfcmVwbHkuSU9DTG9n
SW5mbykpOw0KKwkJCWJyZWFrOw0KKwkJfQ0KIAkJaWYgKHZvbHVtZV9wZzAuVm9sdW1lU3RhdGUg
PT0gTVBJMl9SQUlEX1ZPTF9TVEFURV9PUFRJTUFMIHx8DQogCQkgICAgdm9sdW1lX3BnMC5Wb2x1
bWVTdGF0ZSA9PSBNUEkyX1JBSURfVk9MX1NUQVRFX09OTElORSB8fA0KIAkJICAgIHZvbHVtZV9w
ZzAuVm9sdW1lU3RhdGUgPT0gTVBJMl9SQUlEX1ZPTF9TVEFURV9ERUdSQURFRCkgew0KIAkJCW1l
bXNldCgmZWxlbWVudCwgMCwgc2l6ZW9mKE1waTJFdmVudElyQ29uZmlnRWxlbWVudF90KSk7DQog
CQkJZWxlbWVudC5SZWFzb25Db2RlID0gTVBJMl9FVkVOVF9JUl9DSEFOR0VfUkNfQURERUQ7DQog
CQkJZWxlbWVudC5Wb2xEZXZIYW5kbGUgPSB2b2x1bWVfcGcxLkRldkhhbmRsZTsNCisJCQlwcmlu
dGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRCRUZPUkUgYWRkaW5nIHZvbHVtZTogIg0KKwkJCQkiIGhh
bmRsZSAoMHglMDR4KVxuIiwgaW9jLT5uYW1lLA0KKwkJCQl2b2x1bWVfcGcxLkRldkhhbmRsZSk7
DQogCQkJX3Njc2loX3Nhc192b2x1bWVfYWRkKGlvYywgJmVsZW1lbnQpOw0KKwkJCXByaW50ayhN
UFQyU0FTX0lORk9fRk1UICJcdEFGVEVSIGFkZGluZyB2b2x1bWU6ICINCisJCQkJIiBoYW5kbGUg
KDB4JTA0eClcbiIsIGlvYy0+bmFtZSwNCisJCQkJdm9sdW1lX3BnMS5EZXZIYW5kbGUpOw0KIAkJ
fQ0KIAl9DQogDQorCXByaW50ayhNUFQyU0FTX0lORk9fRk1UICJcdHNjYW4gZGV2aWNlczogdm9s
dW1lcyBjb21wbGV0ZVxuIiwNCisJCWlvYy0+bmFtZSk7DQorDQogIHNraXBfdG9fc2FzOg0KIA0K
KwlwcmludGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRzY2FuIGRldmljZXM6IGVuZCBkZXZpY2VzIHN0
YXJ0XG4iLA0KKwkJaW9jLT5uYW1lKTsNCiAJLyogc2FzIGRldmljZXMgKi8NCiAJaGFuZGxlID0g
MHhGRkZGOw0KIAl3aGlsZSAoIShtcHQyc2FzX2NvbmZpZ19nZXRfc2FzX2RldmljZV9wZzAoaW9j
LCAmbXBpX3JlcGx5LA0KQEAgLTcwOTksNiArNzE4NSwxMyBAQCBfc2NzaWhfc2Nhbl9mb3JfZGV2
aWNlc19hZnRlcl9yZXNldChzdHJ1Y3QgTVBUMlNBU19BREFQVEVSICppb2MpDQogCQkgICAgTVBJ
Ml9JT0NTVEFUVVNfTUFTSzsNCiAJCWlmIChpb2Nfc3RhdHVzID09IE1QSTJfSU9DU1RBVFVTX0NP
TkZJR19JTlZBTElEX1BBR0UpDQogCQkJYnJlYWs7DQorCQlpZiAoaW9jX3N0YXR1cyAhPSBNUEky
X0lPQ1NUQVRVU19TVUNDRVNTKSB7DQorCQkJcHJpbnRrKE1QVDJTQVNfSU5GT19GTVQgIlx0YnJl
YWsgZnJvbSBlbmQgZGV2aWNlIHNjYW46Ig0KKwkJCQkiIGlvY19zdGF0dXMoMHglMDR4KSwgbG9n
aW5mbygweCUwOHgpXG4iLA0KKwkJCQlpb2MtPm5hbWUsIGlvY19zdGF0dXMsDQorCQkJCWxlMzJf
dG9fY3B1KG1waV9yZXBseS5JT0NMb2dJbmZvKSk7DQorCQkJCWJyZWFrOw0KKwkJfQ0KIAkJaGFu
ZGxlID0gbGUxNl90b19jcHUoc2FzX2RldmljZV9wZzAuRGV2SGFuZGxlKTsNCiAJCWlmICghKF9z
Y3NpaF9pc19lbmRfZGV2aWNlKA0KIAkJICAgIGxlMzJfdG9fY3B1KHNhc19kZXZpY2VfcGcwLkRl
dmljZUluZm8pKSkpDQpAQCAtNzEwOSwxMiArNzIwMiwzMSBAQCBfc2NzaWhfc2Nhbl9mb3JfZGV2
aWNlc19hZnRlcl9yZXNldChzdHJ1Y3QgTVBUMlNBU19BREFQVEVSICppb2MpDQogCQkJY29udGlu
dWU7DQogCQlwYXJlbnRfaGFuZGxlID0gbGUxNl90b19jcHUoc2FzX2RldmljZV9wZzAuUGFyZW50
RGV2SGFuZGxlKTsNCiAJCWlmICghX3Njc2loX2dldF9zYXNfYWRkcmVzcyhpb2MsIHBhcmVudF9o
YW5kbGUsICZzYXNfYWRkcmVzcykpIHsNCisJCQlwcmludGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRC
RUZPUkUgYWRkaW5nIGVuZCBkZXZpY2U6ICINCisJCQkJImhhbmRsZSAoMHglMDR4KSwgc2FzX2Fk
ZHIoMHglMDE2bGx4KVxuIiwNCisJCQkJaW9jLT5uYW1lLCBoYW5kbGUsICh1bnNpZ25lZCBsb25n
IGxvbmcpDQorCQkJCWxlNjRfdG9fY3B1KHNhc19kZXZpY2VfcGcwLlNBU0FkZHJlc3MpKTsNCiAJ
CQltcHQyc2FzX3RyYW5zcG9ydF91cGRhdGVfbGlua3MoaW9jLCBzYXNfYWRkcmVzcywgaGFuZGxl
LA0KIAkJCSAgICBzYXNfZGV2aWNlX3BnMC5QaHlOdW0sIE1QSTJfU0FTX05FR19MSU5LX1JBVEVf
MV81KTsNCi0JCQlfc2NzaWhfYWRkX2RldmljZShpb2MsIGhhbmRsZSwgMCwgMCk7DQorCQkJcmV0
cnlfY291bnQgPSAwOw0KKwkJCS8qIFRoaXMgd2lsbCByZXRyeSBhZGRpbmcgdGhlIGVuZCBkZXZp
Y2UuDQorCQkJICogX3Njc2loX2FkZF9kZXZpY2UoKSB3aWxsIGRlY2lkZSBvbiByZXRyaWVzIGFu
ZA0KKwkJCSAqIHJldHVybiAiMSIgd2hlbiBpdCBzaG91bGQgYmUgcmV0cmllZA0KKwkJCSAqLw0K
KwkJCXdoaWxlIChfc2NzaWhfYWRkX2RldmljZShpb2MsIGhhbmRsZSwgcmV0cnlfY291bnQrKywN
CisJCQkJMCkpIHsNCisJCQkJCXNzbGVlcCgxKTsNCisJCQl9DQorCQkJcHJpbnRrKE1QVDJTQVNf
SU5GT19GTVQgIlx0QUZURVIgYWRkaW5nIGVuZCBkZXZpY2U6ICINCisJCQkJImhhbmRsZSAoMHgl
MDR4KSwgc2FzX2FkZHIoMHglMDE2bGx4KVxuIiwNCisJCQkJaW9jLT5uYW1lLCBoYW5kbGUsICh1
bnNpZ25lZCBsb25nIGxvbmcpDQorCQkJCWxlNjRfdG9fY3B1KHNhc19kZXZpY2VfcGcwLlNBU0Fk
ZHJlc3MpKTsNCiAJCX0NCiAJfQ0KIA0KKwlwcmludGsoTVBUMlNBU19JTkZPX0ZNVCAiXHRzY2Fu
IGRldmljZXM6IGVuZCBkZXZpY2VzIGNvbXBsZXRlXG4iLA0KKwkJaW9jLT5uYW1lKTsNCisNCiAJ
cHJpbnRrKE1QVDJTQVNfSU5GT19GTVQgInNjYW4gZGV2aWNlczogY29tcGxldGVcbiIsIGlvYy0+
bmFtZSk7DQogfQ0KIA0KQEAgLTcyMDYsNyArNzMxOCw5IEBAIF9maXJtd2FyZV9ldmVudF93b3Jr
KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJY2FzZSBNUFQyU0FTX1BPUlRfRU5BQkxFX0NP
TVBMRVRFOg0KIAkJaW9jLT5zdGFydF9zY2FuID0gMDsNCiANCi0NCisJCWlmIChtaXNzaW5nX2Rl
bGF5WzBdICE9IC0xICYmIG1pc3NpbmdfZGVsYXlbMV0gIT0gLTEpDQorCQkJbXB0MnNhc19iYXNl
X3VwZGF0ZV9taXNzaW5nX2RlbGF5KGlvYywgbWlzc2luZ19kZWxheVswXSwNCisJCQkJbWlzc2lu
Z19kZWxheVsxXSk7DQogDQogCQlkZXd0cHJpbnRrKGlvYywgcHJpbnRrKE1QVDJTQVNfSU5GT19G
TVQgInBvcnQgZW5hYmxlOiBjb21wbGV0ZSAiDQogCQkgICAgImZyb20gd29ya2VyIHRocmVhZFxu
IiwgaW9jLT5uYW1lKSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL29zZC9vc2RfdWxkLmMg
Yi9kcml2ZXJzL3Njc2kvb3NkL29zZF91bGQuYw0KaW5kZXggZDRlZDllYi4uY2FhYzFiMiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9vc2Qvb3NkX3VsZC5jDQorKysgYi9kcml2ZXJzL3Njc2kv
b3NkL29zZF91bGQuYw0KQEAgLTQ2NSw3ICs0NjUsNyBAQCBzdGF0aWMgaW50IG9zZF9wcm9iZShz
dHJ1Y3QgZGV2aWNlICpkZXYpDQogCW91ZC0+Y2xhc3NfZGV2LmNsYXNzID0gJm9zZF91bGRfY2xh
c3M7DQogCW91ZC0+Y2xhc3NfZGV2LnBhcmVudCA9IGRldjsNCiAJb3VkLT5jbGFzc19kZXYucmVs
ZWFzZSA9IF9fcmVtb3ZlOw0KLQllcnJvciA9IGRldl9zZXRfbmFtZSgmb3VkLT5jbGFzc19kZXYs
IGRpc2stPmRpc2tfbmFtZSk7DQorCWVycm9yID0gZGV2X3NldF9uYW1lKCZvdWQtPmNsYXNzX2Rl
diwgIiVzIiwgZGlzay0+ZGlza19uYW1lKTsNCiAJaWYgKGVycm9yKSB7DQogCQlPU0RfRVJSKCJk
ZXZfc2V0X25hbWUgZmFpbGVkID0+ICVkXG4iLCBlcnJvcik7DQogCQlnb3RvIGVycl9wdXRfY2Rl
djsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQpp
bmRleCBmNDRkNjMzLi42ZGFjZTFhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3NkLmMNCisr
KyBiL2RyaXZlcnMvc2NzaS9zZC5jDQpAQCAtMTM4LDYgKzEzOCw3IEBAIHNkX3N0b3JlX2NhY2hl
X3R5cGUoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwN
CiAJY2hhciAqYnVmZmVyX2RhdGE7DQogCXN0cnVjdCBzY3NpX21vZGVfZGF0YSBkYXRhOw0KIAlz
dHJ1Y3Qgc2NzaV9zZW5zZV9oZHIgc3NoZHI7DQorCXN0YXRpYyBjb25zdCBjaGFyIHRlbXBbXSA9
ICJ0ZW1wb3JhcnkgIjsNCiAJaW50IGxlbjsNCiANCiAJaWYgKHNkcC0+dHlwZSAhPSBUWVBFX0RJ
U0spDQpAQCAtMTQ2LDYgKzE0NywxMyBAQCBzZF9zdG9yZV9jYWNoZV90eXBlKHN0cnVjdCBkZXZp
Y2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsDQogCQkgKiBpdCdzIG5vdCB3
b3J0aCB0aGUgcmlzayAqLw0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQorCWlmIChzdHJuY21wKGJ1
ZiwgdGVtcCwgc2l6ZW9mKHRlbXApIC0gMSkgPT0gMCkgew0KKwkJYnVmICs9IHNpemVvZih0ZW1w
KSAtIDE7DQorCQlzZGtwLT5jYWNoZV9vdmVycmlkZSA9IDE7DQorCX0gZWxzZSB7DQorCQlzZGtw
LT5jYWNoZV9vdmVycmlkZSA9IDA7DQorCX0NCisNCiAJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJ
WkUoc2RfY2FjaGVfdHlwZXMpOyBpKyspIHsNCiAJCWxlbiA9IHN0cmxlbihzZF9jYWNoZV90eXBl
c1tpXSk7DQogCQlpZiAoc3RybmNtcChzZF9jYWNoZV90eXBlc1tpXSwgYnVmLCBsZW4pID09IDAg
JiYNCkBAIC0xNTgsNiArMTY2LDEzIEBAIHNkX3N0b3JlX2NhY2hlX3R5cGUoc3RydWN0IGRldmlj
ZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwNCiAJCXJldHVybiAtRUlOVkFM
Ow0KIAlyY2QgPSBjdCAmIDB4MDEgPyAxIDogMDsNCiAJd2NlID0gY3QgJiAweDAyID8gMSA6IDA7
DQorDQorCWlmIChzZGtwLT5jYWNoZV9vdmVycmlkZSkgew0KKwkJc2RrcC0+V0NFID0gd2NlOw0K
KwkJc2RrcC0+UkNEID0gcmNkOw0KKwkJcmV0dXJuIGNvdW50Ow0KKwl9DQorDQogCWlmIChzY3Np
X21vZGVfc2Vuc2Uoc2RwLCAweDA4LCA4LCBidWZmZXIsIHNpemVvZihidWZmZXIpLCBTRF9USU1F
T1VULA0KIAkJCSAgICBTRF9NQVhfUkVUUklFUywgJmRhdGEsIE5VTEwpKQ0KIAkJcmV0dXJuIC1F
SU5WQUw7DQpAQCAtMjAzNyw2ICsyMDUyLDEwIEBAIHNkX3JlYWRfY2FjaGVfdHlwZShzdHJ1Y3Qg
c2NzaV9kaXNrICpzZGtwLCB1bnNpZ25lZCBjaGFyICpidWZmZXIpDQogCWludCBvbGRfcmNkID0g
c2RrcC0+UkNEOw0KIAlpbnQgb2xkX2Rwb2Z1YSA9IHNka3AtPkRQT0ZVQTsNCiANCisNCisJaWYg
KHNka3AtPmNhY2hlX292ZXJyaWRlKQ0KKwkJcmV0dXJuOw0KKw0KIAlmaXJzdF9sZW4gPSA0Ow0K
IAlpZiAoc2RwLT5za2lwX21zX3BhZ2VfOCkgew0KIAkJaWYgKHNkcC0+dHlwZSA9PSBUWVBFX1JC
QykNCkBAIC0yNTE4LDYgKzI1MzcsNyBAQCBzdGF0aWMgdm9pZCBzZF9wcm9iZV9hc3luYyh2b2lk
ICpkYXRhLCBhc3luY19jb29raWVfdCBjb29raWUpDQogCXNka3AtPmNhcGFjaXR5ID0gMDsNCiAJ
c2RrcC0+bWVkaWFfcHJlc2VudCA9IDE7DQogCXNka3AtPndyaXRlX3Byb3QgPSAwOw0KKwlzZGtw
LT5jYWNoZV9vdmVycmlkZSA9IDA7DQogCXNka3AtPldDRSA9IDA7DQogCXNka3AtPlJDRCA9IDA7
DQogCXNka3AtPkFUTyA9IDA7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NkLmggYi9kcml2
ZXJzL3Njc2kvc2QuaA0KaW5kZXggNDE2M2YyOS4uZTNlM2NkMiAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc2NzaS9zZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvc2QuaA0KQEAgLTY0LDYgKzY0LDcgQEAg
c3RydWN0IHNjc2lfZGlzayB7DQogCXU4CQlwcm90ZWN0aW9uX3R5cGU7LyogRGF0YSBJbnRlZ3Jp
dHkgRmllbGQgKi8NCiAJdTgJCXByb3Zpc2lvbmluZ19tb2RlOw0KIAl1bnNpZ25lZAlBVE8gOiAx
OwkvKiBzdGF0ZSBvZiBkaXNrIEFUTyBiaXQgKi8NCisJdW5zaWduZWQJY2FjaGVfb3ZlcnJpZGUg
OiAxOyAvKiB0ZW1wIG92ZXJyaWRlIG9mIFdDRSxSQ0QgKi8NCiAJdW5zaWduZWQJV0NFIDogMTsJ
Lyogc3RhdGUgb2YgZGlzayBXQ0UgYml0ICovDQogCXVuc2lnbmVkCVJDRCA6IDE7CS8qIHN0YXRl
IG9mIGRpc2sgUkNEIGJpdCwgdW51c2VkICovDQogCXVuc2lnbmVkCURQT0ZVQSA6IDE7CS8qIHN0
YXRlIG9mIGRpc2sgRFBPRlVBIGJpdCAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy96
cmFtL3pyYW1fZHJ2LmMgYi9kcml2ZXJzL3N0YWdpbmcvenJhbS96cmFtX2Rydi5jDQppbmRleCAy
NTk0YTMxLi45MjZkNDgzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3pyYW0venJhbV9k
cnYuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3pyYW0venJhbV9kcnYuYw0KQEAgLTU0MSwxMyAr
NTQxLDIwIEBAIG91dDoNCiAgKi8NCiBzdGF0aWMgaW5saW5lIGludCB2YWxpZF9pb19yZXF1ZXN0
KHN0cnVjdCB6cmFtICp6cmFtLCBzdHJ1Y3QgYmlvICpiaW8pDQogew0KLQlpZiAodW5saWtlbHko
DQotCQkoYmlvLT5iaV9zZWN0b3IgPj0gKHpyYW0tPmRpc2tzaXplID4+IFNFQ1RPUl9TSElGVCkp
IHx8DQotCQkoYmlvLT5iaV9zZWN0b3IgJiAoWlJBTV9TRUNUT1JfUEVSX0xPR0lDQUxfQkxPQ0sg
LSAxKSkgfHwNCi0JCShiaW8tPmJpX3NpemUgJiAoWlJBTV9MT0dJQ0FMX0JMT0NLX1NJWkUgLSAx
KSkpKSB7DQorCXU2NCBzdGFydCwgZW5kLCBib3VuZDsNCisJDQorCS8qIHVuYWxpZ25lZCByZXF1
ZXN0ICovDQorCWlmICh1bmxpa2VseShiaW8tPmJpX3NlY3RvciAmIChaUkFNX1NFQ1RPUl9QRVJf
TE9HSUNBTF9CTE9DSyAtIDEpKSkNCisJCXJldHVybiAwOw0KKwlpZiAodW5saWtlbHkoYmlvLT5i
aV9zaXplICYgKFpSQU1fTE9HSUNBTF9CTE9DS19TSVpFIC0gMSkpKQ0KKwkJcmV0dXJuIDA7DQog
DQorCXN0YXJ0ID0gYmlvLT5iaV9zZWN0b3I7DQorCWVuZCA9IHN0YXJ0ICsgKGJpby0+Ymlfc2l6
ZSA+PiBTRUNUT1JfU0hJRlQpOw0KKwlib3VuZCA9IHpyYW0tPmRpc2tzaXplID4+IFNFQ1RPUl9T
SElGVDsNCisJLyogb3V0IG9mIHJhbmdlIHJhbmdlICovDQorCWlmICh1bmxpa2VseShzdGFydCA+
PSBib3VuZCB8fCBlbmQgPj0gYm91bmQgfHwgc3RhcnQgPiBlbmQpKQ0KIAkJcmV0dXJuIDA7DQot
CX0NCiANCiAJLyogSS9PIHJlcXVlc3QgaXMgdmFsaWQgKi8NCiAJcmV0dXJuIDE7DQpAQCAtNzAy
LDcgKzcwOSw5IEBAIHN0YXRpYyB2b2lkIHpyYW1fc2xvdF9mcmVlX25vdGlmeShzdHJ1Y3QgYmxv
Y2tfZGV2aWNlICpiZGV2LA0KIAlzdHJ1Y3QgenJhbSAqenJhbTsNCiANCiAJenJhbSA9IGJkZXYt
PmJkX2Rpc2stPnByaXZhdGVfZGF0YTsNCisJZG93bl93cml0ZSgmenJhbS0+bG9jayk7DQogCXpy
YW1fZnJlZV9wYWdlKHpyYW0sIGluZGV4KTsNCisJdXBfd3JpdGUoJnpyYW0tPmxvY2spOw0KIAl6
cmFtX3N0YXQ2NF9pbmMoenJhbSwgJnpyYW0tPnN0YXRzLm5vdGlmeV9mcmVlKTsNCiB9DQogDQpA
QCAtNzEzLDcgKzcyMiw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYmxvY2tfZGV2aWNlX29wZXJh
dGlvbnMgenJhbV9kZXZvcHMgPSB7DQogDQogc3RhdGljIGludCBjcmVhdGVfZGV2aWNlKHN0cnVj
dCB6cmFtICp6cmFtLCBpbnQgZGV2aWNlX2lkKQ0KIHsNCi0JaW50IHJldCA9IDA7DQorCWludCBy
ZXQgPSAtRU5PTUVNOw0KIA0KIAlpbml0X3J3c2VtKCZ6cmFtLT5sb2NrKTsNCiAJaW5pdF9yd3Nl
bSgmenJhbS0+aW5pdF9sb2NrKTsNCkBAIC03MjMsNyArNzMyLDYgQEAgc3RhdGljIGludCBjcmVh
dGVfZGV2aWNlKHN0cnVjdCB6cmFtICp6cmFtLCBpbnQgZGV2aWNlX2lkKQ0KIAlpZiAoIXpyYW0t
PnF1ZXVlKSB7DQogCQlwcl9lcnIoIkVycm9yIGFsbG9jYXRpbmcgZGlzayBxdWV1ZSBmb3IgZGV2
aWNlICVkXG4iLA0KIAkJCWRldmljZV9pZCk7DQotCQlyZXQgPSAtRU5PTUVNOw0KIAkJZ290byBv
dXQ7DQogCX0NCiANCkBAIC03MzMsMTEgKzc0MSw5IEBAIHN0YXRpYyBpbnQgY3JlYXRlX2Rldmlj
ZShzdHJ1Y3QgenJhbSAqenJhbSwgaW50IGRldmljZV9pZCkNCiAJIC8qIGdlbmRpc2sgc3RydWN0
dXJlICovDQogCXpyYW0tPmRpc2sgPSBhbGxvY19kaXNrKDEpOw0KIAlpZiAoIXpyYW0tPmRpc2sp
IHsNCi0JCWJsa19jbGVhbnVwX3F1ZXVlKHpyYW0tPnF1ZXVlKTsNCiAJCXByX3dhcm5pbmcoIkVy
cm9yIGFsbG9jYXRpbmcgZGlzayBzdHJ1Y3R1cmUgZm9yIGRldmljZSAlZFxuIiwNCiAJCQlkZXZp
Y2VfaWQpOw0KLQkJcmV0ID0gLUVOT01FTTsNCi0JCWdvdG8gb3V0Ow0KKwkJZ290byBvdXRfZnJl
ZV9xdWV1ZTsNCiAJfQ0KIA0KIAl6cmFtLT5kaXNrLT5tYWpvciA9IHpyYW1fbWFqb3I7DQpAQCAt
NzY2LDExICs3NzIsMTcgQEAgc3RhdGljIGludCBjcmVhdGVfZGV2aWNlKHN0cnVjdCB6cmFtICp6
cmFtLCBpbnQgZGV2aWNlX2lkKQ0KIAkJCQkmenJhbV9kaXNrX2F0dHJfZ3JvdXApOw0KIAlpZiAo
cmV0IDwgMCkgew0KIAkJcHJfd2FybmluZygiRXJyb3IgY3JlYXRpbmcgc3lzZnMgZ3JvdXAiKTsN
Ci0JCWdvdG8gb3V0Ow0KKwkJZ290byBvdXRfZnJlZV9kaXNrOw0KIAl9DQogDQogCXpyYW0tPmlu
aXRfZG9uZSA9IDA7DQorCXJldHVybiAwOw0KIA0KK291dF9mcmVlX2Rpc2s6DQorCWRlbF9nZW5k
aXNrKHpyYW0tPmRpc2spOw0KKwlwdXRfZGlzayh6cmFtLT5kaXNrKTsNCitvdXRfZnJlZV9xdWV1
ZToNCisJYmxrX2NsZWFudXBfcXVldWUoenJhbS0+cXVldWUpOw0KIG91dDoNCiAJcmV0dXJuIHJl
dDsNCiB9DQpAQCAtODQ2LDkgKzg1OCwxMSBAQCBzdGF0aWMgdm9pZCBfX2V4aXQgenJhbV9leGl0
KHZvaWQpDQogCWZvciAoaSA9IDA7IGkgPCB6cmFtX251bV9kZXZpY2VzOyBpKyspIHsNCiAJCXpy
YW0gPSAmenJhbV9kZXZpY2VzW2ldOw0KIA0KKwkJZ2V0X2Rpc2soenJhbS0+ZGlzayk7DQogCQlk
ZXN0cm95X2RldmljZSh6cmFtKTsNCiAJCWlmICh6cmFtLT5pbml0X2RvbmUpDQogCQkJenJhbV9y
ZXNldF9kZXZpY2UoenJhbSk7DQorCQlwdXRfZGlzayh6cmFtLT5kaXNrKTsNCiAJfQ0KIA0KIAl1
bnJlZ2lzdGVyX2Jsa2Rldih6cmFtX21ham9yLCAienJhbSIpOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy96cmFtL3pyYW1fZHJ2LmggYi9kcml2ZXJzL3N0YWdpbmcvenJhbS96cmFtX2Ry
di5oDQppbmRleCBlNWNkMjQ2Li44N2YyZmVjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3pyYW0venJhbV9kcnYuaA0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3pyYW0venJhbV9kcnYuaA0K
QEAgLTEwNyw4ICsxMDcsOSBAQCBzdHJ1Y3QgenJhbSB7DQogCXZvaWQgKmNvbXByZXNzX2J1ZmZl
cjsNCiAJc3RydWN0IHRhYmxlICp0YWJsZTsNCiAJc3BpbmxvY2tfdCBzdGF0NjRfbG9jazsJLyog
cHJvdGVjdCA2NC1iaXQgc3RhdHMgKi8NCi0Jc3RydWN0IHJ3X3NlbWFwaG9yZSBsb2NrOyAvKiBw
cm90ZWN0IGNvbXByZXNzaW9uIGJ1ZmZlcnMgYW5kIHRhYmxlDQotCQkJCSAgICogYWdhaW5zdCBj
b25jdXJyZW50IHJlYWQgYW5kIHdyaXRlcyAqLw0KKwlzdHJ1Y3Qgcndfc2VtYXBob3JlIGxvY2s7
IC8qIHByb3RlY3QgY29tcHJlc3Npb24gYnVmZmVycywgdGFibGUsDQorCQkJCSAgICogMzJiaXQg
c3RhdCBjb3VudGVycyBhZ2FpbnN0IGNvbmN1cnJlbnQNCisJCQkJICAgKiBub3RpZmljYXRpb25z
LCByZWFkcyBhbmQgd3JpdGVzICovDQogCXN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxdWV1ZTsNCiAJ
c3RydWN0IGdlbmRpc2sgKmRpc2s7DQogCWludCBpbml0X2RvbmU7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3pyYW0venJhbV9zeXNmcy5jIGIvZHJpdmVycy9zdGFnaW5nL3pyYW0venJh
bV9zeXNmcy5jDQppbmRleCAwZWE4ZWQyLi4xZmFlMWU5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3pyYW0venJhbV9zeXNmcy5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvenJhbS96cmFt
X3N5c2ZzLmMNCkBAIC0xODYsMTAgKzE4NiwxMiBAQCBzdGF0aWMgc3NpemVfdCBtZW1fdXNlZF90
b3RhbF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwNCiAJdTY0IHZhbCA9IDA7DQogCXN0cnVjdCB6
cmFtICp6cmFtID0gZGV2X3RvX3pyYW0oZGV2KTsNCiANCisJZG93bl9yZWFkKCZ6cmFtLT5pbml0
X2xvY2spOw0KIAlpZiAoenJhbS0+aW5pdF9kb25lKSB7DQogCQl2YWwgPSB4dl9nZXRfdG90YWxf
c2l6ZV9ieXRlcyh6cmFtLT5tZW1fcG9vbCkgKw0KIAkJCSgodTY0KSh6cmFtLT5zdGF0cy5wYWdl
c19leHBhbmQpIDw8IFBBR0VfU0hJRlQpOw0KIAl9DQorCXVwX3JlYWQoJnpyYW0tPmluaXRfbG9j
ayk7DQogDQogCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVsbHVcbiIsIHZhbCk7DQogfQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9jb25maWdmcy5jIGIvZHJp
dmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2NvbmZpZ2ZzLmMNCmluZGV4IDgzZGNmNDku
LjNiODAyODUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXRf
Y29uZmlnZnMuYw0KKysrIGIvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2NvbmZp
Z2ZzLmMNCkBAIC00MTksNyArNDE5LDcgQEAgc3RhdGljIHNzaXplX3QgX19pc2NzaV8jI3ByZWZp
eCMjX3N0b3JlXyMjbmFtZSgJCQkJXA0KIAlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCQkJ
CQlcDQogCQlyZXR1cm4gLUVQRVJNOwkJCQkJCVwNCiAJCQkJCQkJCQlcDQotCXNucHJpbnRmKGF1
dGgtPm5hbWUsIFBBR0VfU0laRSwgIiVzIiwgcGFnZSk7CQkJXA0KKwlzbnByaW50ZihhdXRoLT5u
YW1lLCBzaXplb2YoYXV0aC0+bmFtZSksICIlcyIsIHBhZ2UpOwkJXA0KIAlpZiAoIXN0cm5jbXAo
Ik5VTEwiLCBhdXRoLT5uYW1lLCA0KSkJCQkJXA0KIAkJYXV0aC0+bmFmX2ZsYWdzICY9IH5mbGFn
czsJCQkJXA0KIAllbHNlCQkJCQkJCQlcDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvc2VyaWFs
LzgyNTBfcGNpLmMgYi9kcml2ZXJzL3R0eS9zZXJpYWwvODI1MF9wY2kuYw0KaW5kZXggNjk4NjI1
Ni4uNmM5YmNkZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwX3BjaS5jDQor
KysgYi9kcml2ZXJzL3R0eS9zZXJpYWwvODI1MF9wY2kuYw0KQEAgLTQwODMsMTAgKzQwODMsNiBA
QCBzdGF0aWMgc3RydWN0IHBjaV9kZXZpY2VfaWQgc2VyaWFsX3BjaV90YmxbXSA9IHsNCiAJCVBD
SV9WRU5ET1JfSURfSUJNLCAweDAyOTksDQogCQkwLCAwLCBwYm5fYjBfYnRfMl8xMTUyMDAgfSwN
CiANCi0JewlQQ0lfVkVORE9SX0lEX05FVE1PUywgUENJX0RFVklDRV9JRF9ORVRNT1NfOTgzNSwN
Ci0JCTB4MTAwMCwgMHgwMDEyLA0KLQkJMCwgMCwgcGJuX2IwX2J0XzJfMTE1MjAwIH0sDQotDQog
CXsJUENJX1ZFTkRPUl9JRF9ORVRNT1MsIFBDSV9ERVZJQ0VfSURfTkVUTU9TXzk5MDEsDQogCQkw
eEEwMDAsIDB4MTAwMCwNCiAJCTAsIDAsIHBibl9iMF8xXzExNTIwMCB9LA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdHR5L3NlcmlhbC9wY2hfdWFydC5jIGIvZHJpdmVycy90dHkvc2VyaWFsL3BjaF91
YXJ0LmMNCmluZGV4IDhkNzBmYmMuLmMwYjQ4NzIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3R0eS9z
ZXJpYWwvcGNoX3VhcnQuYw0KKysrIGIvZHJpdmVycy90dHkvc2VyaWFsL3BjaF91YXJ0LmMNCkBA
IC05NDAsMjIgKzk0MCwzNyBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGRtYV9oYW5kbGVfdHgoc3Ry
dWN0IGVnMjB0X3BvcnQgKnByaXYpDQogc3RhdGljIHZvaWQgcGNoX3VhcnRfZXJyX2lyKHN0cnVj
dCBlZzIwdF9wb3J0ICpwcml2LCB1bnNpZ25lZCBpbnQgbHNyKQ0KIHsNCiAJdTggZmNyID0gaW9y
ZWFkOChwcml2LT5tZW1iYXNlICsgVUFSVF9GQ1IpOw0KKwlzdHJ1Y3QgdWFydF9wb3J0ICpwb3J0
ID0gJnByaXYtPnBvcnQ7DQorCXN0cnVjdCB0dHlfc3RydWN0ICp0dHkgPSB0dHlfcG9ydF90dHlf
Z2V0KCZwb3J0LT5zdGF0ZS0+cG9ydCk7DQorCWNoYXIgICAqZXJyb3JfbXNnWzVdID0ge307DQor
CWludCAgICBpID0gMDsNCiANCiAJLyogUmVzZXQgRklGTyAqLw0KIAlmY3IgfD0gVUFSVF9GQ1Jf
Q0xFQVJfUkNWUjsNCiAJaW93cml0ZTgoZmNyLCBwcml2LT5tZW1iYXNlICsgVUFSVF9GQ1IpOw0K
IA0KIAlpZiAobHNyICYgUENIX1VBUlRfTFNSX0VSUikNCi0JCWRldl9lcnIoJnByaXYtPnBkZXYt
PmRldiwgIkVycm9yIGRhdGEgaW4gRklGT1xuIik7DQorCQllcnJvcl9tc2dbaSsrXSA9ICJFcnJv
ciBkYXRhIGluIEZJRk9cbiI7DQogDQotCWlmIChsc3IgJiBVQVJUX0xTUl9GRSkNCi0JCWRldl9l
cnIoJnByaXYtPnBkZXYtPmRldiwgIkZyYW1pbmcgRXJyb3JcbiIpOw0KKwlpZiAobHNyICYgVUFS
VF9MU1JfRkUpIHsNCisJCXBvcnQtPmljb3VudC5mcmFtZSsrOw0KKwkJZXJyb3JfbXNnW2krK10g
PSAiICBGcmFtaW5nIEVycm9yXG4iOw0KKwl9DQogDQotCWlmIChsc3IgJiBVQVJUX0xTUl9QRSkN
Ci0JCWRldl9lcnIoJnByaXYtPnBkZXYtPmRldiwgIlBhcml0eSBFcnJvclxuIik7DQorCWlmIChs
c3IgJiBVQVJUX0xTUl9QRSkgew0KKwkJcG9ydC0+aWNvdW50LnBhcml0eSsrOw0KKwkJZXJyb3Jf
bXNnW2krK10gPSAiICBQYXJpdHkgRXJyb3JcbiI7DQorCX0NCiANCi0JaWYgKGxzciAmIFVBUlRf
TFNSX09FKQ0KLQkJZGV2X2VycigmcHJpdi0+cGRldi0+ZGV2LCAiT3ZlcnJ1biBFcnJvclxuIik7
DQorCWlmIChsc3IgJiBVQVJUX0xTUl9PRSkgew0KKwkJcG9ydC0+aWNvdW50Lm92ZXJydW4rKzsN
CisJCWVycm9yX21zZ1tpKytdID0gIiAgT3ZlcnJ1biBFcnJvclxuIjsNCisJfQ0KKw0KKwlpZiAo
dHR5ID09IE5VTEwpIHsNCisJCWZvciAoaSA9IDA7IGVycm9yX21zZ1tpXSAhPSBOVUxMOyBpKysp
DQorCQkJZGV2X2VycigmcHJpdi0+cGRldi0+ZGV2LCBlcnJvcl9tc2dbaV0pOw0KKwl9DQogfQ0K
IA0KIHN0YXRpYyBpcnFyZXR1cm5fdCBwY2hfdWFydF9pbnRlcnJ1cHQoaW50IGlycSwgdm9pZCAq
ZGV2X2lkKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9mX21hc3Nfc3RvcmFnZS5j
IGIvZHJpdmVycy91c2IvZ2FkZ2V0L2ZfbWFzc19zdG9yYWdlLmMNCmluZGV4IGE1NTcwYjYuLjhk
N2ZiNmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQvZl9tYXNzX3N0b3JhZ2UuYw0K
KysrIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2ZfbWFzc19zdG9yYWdlLmMNCkBAIC01MTIsNiArNTEy
LDcgQEAgc3RhdGljIGludCBmc2dfc2V0X2hhbHQoc3RydWN0IGZzZ19kZXYgKmZzZywgc3RydWN0
IHVzYl9lcCAqZXApDQogLyogQ2FsbGVyIG11c3QgaG9sZCBmc2ctPmxvY2sgKi8NCiBzdGF0aWMg
dm9pZCB3YWtldXBfdGhyZWFkKHN0cnVjdCBmc2dfY29tbW9uICpjb21tb24pDQogew0KKwlzbXBf
d21iKCk7CS8qIGVuc3VyZSB0aGUgd3JpdGUgb2YgYmgtPnN0YXRlIGlzIGNvbXBsZXRlICovDQog
CS8qIFRlbGwgdGhlIG1haW4gdGhyZWFkIHRoYXQgc29tZXRoaW5nIGhhcyBoYXBwZW5lZCAqLw0K
IAljb21tb24tPnRocmVhZF93YWtldXBfbmVlZGVkID0gMTsNCiAJaWYgKGNvbW1vbi0+dGhyZWFk
X3Rhc2spDQpAQCAtNzMxLDYgKzczMiw3IEBAIHN0YXRpYyBpbnQgc2xlZXBfdGhyZWFkKHN0cnVj
dCBmc2dfY29tbW9uICpjb21tb24pDQogCX0NCiAJX19zZXRfY3VycmVudF9zdGF0ZShUQVNLX1JV
Tk5JTkcpOw0KIAljb21tb24tPnRocmVhZF93YWtldXBfbmVlZGVkID0gMDsNCisJc21wX3JtYigp
OwkvKiBlbnN1cmUgdGhlIGxhdGVzdCBiaC0+c3RhdGUgaXMgdmlzaWJsZSAqLw0KIAlyZXR1cm4g
cmM7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYyBiL2Ry
aXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYw0KaW5kZXggNTAxOGUzMy4uZWM3MzU0MSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYw0KKysrIGIvZHJpdmVycy91c2IvaG9z
dC94aGNpLW1lbS5jDQpAQCAtMjcxLDYgKzI3MSwxMCBAQCBzdGF0aWMgc3RydWN0IHhoY2lfY29u
dGFpbmVyX2N0eCAqeGhjaV9hbGxvY19jb250YWluZXJfY3R4KHN0cnVjdCB4aGNpX2hjZCAqeGhj
aQ0KIAkJY3R4LT5zaXplICs9IENUWF9TSVpFKHhoY2ktPmhjY19wYXJhbXMpOw0KIA0KIAljdHgt
PmJ5dGVzID0gZG1hX3Bvb2xfYWxsb2MoeGhjaS0+ZGV2aWNlX3Bvb2wsIGZsYWdzLCAmY3R4LT5k
bWEpOw0KKwlpZiAoIWN0eC0+Ynl0ZXMpIHsNCisJCWtmcmVlKGN0eCk7DQorCQlyZXR1cm4gTlVM
TDsNCisJfQ0KIAltZW1zZXQoY3R4LT5ieXRlcywgMCwgY3R4LT5zaXplKTsNCiAJcmV0dXJuIGN0
eDsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jIGIvZHJpdmVy
cy91c2Ivc2VyaWFsL29wdGlvbi5jDQppbmRleCA4ZWEzN2JjLi5iODM2NWE3IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwv
b3B0aW9uLmMNCkBAIC0xNTksOCArMTU5LDYgQEAgc3RhdGljIHZvaWQgb3B0aW9uX2luc3RhdF9j
YWxsYmFjayhzdHJ1Y3QgdXJiICp1cmIpOw0KICNkZWZpbmUgTk9WQVRFTFdJUkVMRVNTX1BST0RV
Q1RfSFNQQV9FTUJFRERFRF9GVUxMU1BFRUQJMHg5MDAwDQogI2RlZmluZSBOT1ZBVEVMV0lSRUxF
U1NfUFJPRFVDVF9IU1BBX0VNQkVEREVEX0hJR0hTUEVFRAkweDkwMDENCiAjZGVmaW5lIE5PVkFU
RUxXSVJFTEVTU19QUk9EVUNUX0UzNjIJCTB4OTAxMA0KLSNkZWZpbmUgTk9WQVRFTFdJUkVMRVNT
X1BST0RVQ1RfRzEJCTB4QTAwMQ0KLSNkZWZpbmUgTk9WQVRFTFdJUkVMRVNTX1BST0RVQ1RfRzFf
TQkJMHhBMDAyDQogI2RlZmluZSBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9HMgkJMHhBMDEwDQog
I2RlZmluZSBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9NQzU1MQkJMHhCMDAxDQogDQpAQCAtNzQ0
LDggKzc0Miw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRz
W10gPSB7DQogCXsgVVNCX0RFVklDRShOT1ZBVEVMV0lSRUxFU1NfVkVORE9SX0lELCBOT1ZBVEVM
V0lSRUxFU1NfUFJPRFVDVF9NQzU0NykgfSwNCiAJeyBVU0JfREVWSUNFKE5PVkFURUxXSVJFTEVT
U19WRU5ET1JfSUQsIE5PVkFURUxXSVJFTEVTU19QUk9EVUNUX0VWRE9fRU1CRURERURfSElHSFNQ
RUVEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoTk9WQVRFTFdJUkVMRVNTX1ZFTkRPUl9JRCwgTk9WQVRF
TFdJUkVMRVNTX1BST0RVQ1RfSFNQQV9FTUJFRERFRF9ISUdIU1BFRUQpIH0sDQotCXsgVVNCX0RF
VklDRShOT1ZBVEVMV0lSRUxFU1NfVkVORE9SX0lELCBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9H
MSkgfSwNCi0JeyBVU0JfREVWSUNFKE5PVkFURUxXSVJFTEVTU19WRU5ET1JfSUQsIE5PVkFURUxX
SVJFTEVTU19QUk9EVUNUX0cxX00pIH0sDQogCXsgVVNCX0RFVklDRShOT1ZBVEVMV0lSRUxFU1Nf
VkVORE9SX0lELCBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9HMikgfSwNCiAJLyogTm92YXRlbCBP
dmF0aW9uIE1DNTUxIGEuay5hLiBWZXJpem9uIFVTQjU1MUwgKi8NCiAJeyBVU0JfREVWSUNFX0FO
RF9JTlRFUkZBQ0VfSU5GTyhOT1ZBVEVMV0lSRUxFU1NfVkVORE9SX0lELCBOT1ZBVEVMV0lSRUxF
U1NfUFJPRFVDVF9NQzU1MSwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9zZXJpYWwvcWNzZXJpYWwuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9xY3NlcmlhbC5j
DQppbmRleCA1NTM1YzNhLi5lOGM0ZjBjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFs
L3Fjc2VyaWFsLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9xY3NlcmlhbC5jDQpAQCAtMzcs
NyArMzcsMTMgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlW10g
PSB7DQogCXtERVZJQ0VfRzFLKDB4MDRkYSwgMHgyNTBjKX0sCS8qIFBhbmFzb25pYyBHb2JpIFFE
TCBkZXZpY2UgKi8NCiAJe0RFVklDRV9HMUsoMHg0MTNjLCAweDgxNzIpfSwJLyogRGVsbCBHb2Jp
IE1vZGVtIGRldmljZSAqLw0KIAl7REVWSUNFX0cxSygweDQxM2MsIDB4ODE3MSl9LAkvKiBEZWxs
IEdvYmkgUURMIGRldmljZSAqLw0KLQl7REVWSUNFX0cxSygweDE0MTAsIDB4YTAwMSl9LAkvKiBO
b3ZhdGVsIEdvYmkgTW9kZW0gZGV2aWNlICovDQorCXtERVZJQ0VfRzFLKDB4MTQxMCwgMHhhMDAx
KX0sCS8qIE5vdmF0ZWwvVmVyaXpvbiBVU0ItMTAwMCAqLw0KKwl7REVWSUNFX0cxSygweDE0MTAs
IDB4YTAwMil9LAkvKiBOb3ZhdGVsIEdvYmkgTW9kZW0gZGV2aWNlICovDQorCXtERVZJQ0VfRzFL
KDB4MTQxMCwgMHhhMDAzKX0sCS8qIE5vdmF0ZWwgR29iaSBNb2RlbSBkZXZpY2UgKi8NCisJe0RF
VklDRV9HMUsoMHgxNDEwLCAweGEwMDQpfSwJLyogTm92YXRlbCBHb2JpIE1vZGVtIGRldmljZSAq
Lw0KKwl7REVWSUNFX0cxSygweDE0MTAsIDB4YTAwNSl9LAkvKiBOb3ZhdGVsIEdvYmkgTW9kZW0g
ZGV2aWNlICovDQorCXtERVZJQ0VfRzFLKDB4MTQxMCwgMHhhMDA2KX0sCS8qIE5vdmF0ZWwgR29i
aSBNb2RlbSBkZXZpY2UgKi8NCisJe0RFVklDRV9HMUsoMHgxNDEwLCAweGEwMDcpfSwJLyogTm92
YXRlbCBHb2JpIE1vZGVtIGRldmljZSAqLw0KIAl7REVWSUNFX0cxSygweDE0MTAsIDB4YTAwOCl9
LAkvKiBOb3ZhdGVsIEdvYmkgUURMIGRldmljZSAqLw0KIAl7REVWSUNFX0cxSygweDBiMDUsIDB4
MTc3Nil9LAkvKiBBc3VzIEdvYmkgTW9kZW0gZGV2aWNlICovDQogCXtERVZJQ0VfRzFLKDB4MGIw
NSwgMHgxNzc0KX0sCS8qIEFzdXMgR29iaSBRREwgZGV2aWNlICovDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy92aWRlby9jb25zb2xlL3ZnYWNvbi5jIGIvZHJpdmVycy92aWRlby9jb25zb2xlL3ZnYWNv
bi5jDQppbmRleCA1ODU1ZDE3Li45ZDhmZWFjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy92aWRlby9j
b25zb2xlL3ZnYWNvbi5jDQorKysgYi9kcml2ZXJzL3ZpZGVvL2NvbnNvbGUvdmdhY29uLmMNCkBA
IC00Miw2ICs0Miw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2tkLmg+DQogI2luY2x1ZGUgPGxpbnV4
L3NsYWIuaD4NCiAjaW5jbHVkZSA8bGludXgvdnRfa2Vybi5oPg0KKyNpbmNsdWRlIDxsaW51eC9z
Y2hlZC5oPg0KICNpbmNsdWRlIDxsaW51eC9zZWxlY3Rpb24uaD4NCiAjaW5jbHVkZSA8bGludXgv
c3BpbmxvY2suaD4NCiAjaW5jbHVkZSA8bGludXgvaW9wb3J0Lmg+DQpAQCAtMTEyNCwxMSArMTEy
NSwxNSBAQCBzdGF0aWMgaW50IHZnYWNvbl9kb19mb250X29wKHN0cnVjdCB2Z2FzdGF0ZSAqc3Rh
dGUsY2hhciAqYXJnLGludCBzZXQsaW50IGNoNTEyKQ0KIA0KIAlpZiAoYXJnKSB7DQogCQlpZiAo
c2V0KQ0KLQkJCWZvciAoaSA9IDA7IGkgPCBjbWFwc3o7IGkrKykNCisJCQlmb3IgKGkgPSAwOyBp
IDwgY21hcHN6OyBpKyspIHsNCiAJCQkJdmdhX3dyaXRlYihhcmdbaV0sIGNoYXJtYXAgKyBpKTsN
CisJCQkJY29uZF9yZXNjaGVkKCk7DQorCQkJfQ0KIAkJZWxzZQ0KLQkJCWZvciAoaSA9IDA7IGkg
PCBjbWFwc3o7IGkrKykNCisJCQlmb3IgKGkgPSAwOyBpIDwgY21hcHN6OyBpKyspIHsNCiAJCQkJ
YXJnW2ldID0gdmdhX3JlYWRiKGNoYXJtYXAgKyBpKTsNCisJCQkJY29uZF9yZXNjaGVkKCk7DQor
CQkJfQ0KIA0KIAkJLyoNCiAJCSAqIEluIDUxMi1jaGFyYWN0ZXIgbW9kZSwgdGhlIGNoYXJhY3Rl
ciBtYXAgaXMgbm90IGNvbnRpZ3VvdXMgaWYNCkBAIC0xMTM5LDExICsxMTQ0LDE1IEBAIHN0YXRp
YyBpbnQgdmdhY29uX2RvX2ZvbnRfb3Aoc3RydWN0IHZnYXN0YXRlICpzdGF0ZSxjaGFyICphcmcs
aW50IHNldCxpbnQgY2g1MTIpDQogCQkJY2hhcm1hcCArPSAyICogY21hcHN6Ow0KIAkJCWFyZyAr
PSBjbWFwc3o7DQogCQkJaWYgKHNldCkNCi0JCQkJZm9yIChpID0gMDsgaSA8IGNtYXBzejsgaSsr
KQ0KKwkJCQlmb3IgKGkgPSAwOyBpIDwgY21hcHN6OyBpKyspIHsNCiAJCQkJCXZnYV93cml0ZWIo
YXJnW2ldLCBjaGFybWFwICsgaSk7DQorCQkJCQljb25kX3Jlc2NoZWQoKTsNCisJCQkJfQ0KIAkJ
CWVsc2UNCi0JCQkJZm9yIChpID0gMDsgaSA8IGNtYXBzejsgaSsrKQ0KKwkJCQlmb3IgKGkgPSAw
OyBpIDwgY21hcHN6OyBpKyspIHsNCiAJCQkJCWFyZ1tpXSA9IHZnYV9yZWFkYihjaGFybWFwICsg
aSk7DQorCQkJCQljb25kX3Jlc2NoZWQoKTsNCisJCQkJfQ0KIAkJfQ0KIAl9DQogDQpkaWZmIC0t
Z2l0IGEvZnMvYmxvY2tfZGV2LmMgYi9mcy9ibG9ja19kZXYuYw0KaW5kZXggNTNhYjI3My4uYzEw
MzI2NyAxMDA2NDQNCi0tLSBhL2ZzL2Jsb2NrX2Rldi5jDQorKysgYi9mcy9ibG9ja19kZXYuYw0K
QEAgLTU1LDE3ICs1NSwyNCBAQCBzdGF0aWMgdm9pZCBiZGV2X2lub2RlX3N3aXRjaF9iZGkoc3Ry
dWN0IGlub2RlICppbm9kZSwNCiAJCQlzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqZHN0KQ0KIHsN
CiAJc3RydWN0IGJhY2tpbmdfZGV2X2luZm8gKm9sZCA9IGlub2RlLT5pX2RhdGEuYmFja2luZ19k
ZXZfaW5mbzsNCisJYm9vbCB3YWtldXBfYmRpID0gZmFsc2U7DQogDQogCWlmICh1bmxpa2VseShk
c3QgPT0gb2xkKSkJCS8qIGRlYWRsb2NrIGF2b2lkYW5jZSAqLw0KIAkJcmV0dXJuOw0KIAliZGlf
bG9ja190d28oJm9sZC0+d2IsICZkc3QtPndiKTsNCiAJc3Bpbl9sb2NrKCZpbm9kZS0+aV9sb2Nr
KTsNCiAJaW5vZGUtPmlfZGF0YS5iYWNraW5nX2Rldl9pbmZvID0gZHN0Ow0KLQlpZiAoaW5vZGUt
Pmlfc3RhdGUgJiBJX0RJUlRZKQ0KKwlpZiAoaW5vZGUtPmlfc3RhdGUgJiBJX0RJUlRZKSB7DQor
CQlpZiAoYmRpX2NhcF93cml0ZWJhY2tfZGlydHkoZHN0KSAmJiAhd2JfaGFzX2RpcnR5X2lvKCZk
c3QtPndiKSkNCisJCQl3YWtldXBfYmRpID0gdHJ1ZTsNCiAJCWxpc3RfbW92ZSgmaW5vZGUtPmlf
d2JfbGlzdCwgJmRzdC0+d2IuYl9kaXJ0eSk7DQorCX0NCiAJc3Bpbl91bmxvY2soJmlub2RlLT5p
X2xvY2spOw0KIAlzcGluX3VubG9jaygmb2xkLT53Yi5saXN0X2xvY2spOw0KIAlzcGluX3VubG9j
aygmZHN0LT53Yi5saXN0X2xvY2spOw0KKw0KKwlpZiAod2FrZXVwX2JkaSkNCisJCWJkaV93YWtl
dXBfdGhyZWFkX2RlbGF5ZWQoZHN0KTsNCiB9DQogDQogc2VjdG9yX3QgYmxrZGV2X21heF9ibG9j
ayhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2KQ0KZGlmZiAtLWdpdCBhL2ZzL2NlcGgvc3VwZXIu
YyBiL2ZzL2NlcGgvc3VwZXIuYw0KaW5kZXggYjQ4ZjE1Zi4uZGUyNjhhOCAxMDA2NDQNCi0tLSBh
L2ZzL2NlcGgvc3VwZXIuYw0KKysrIGIvZnMvY2VwaC9zdXBlci5jDQpAQCAtNzAsOCArNzAsMTQg
QEAgc3RhdGljIGludCBjZXBoX3N0YXRmcyhzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBr
c3RhdGZzICpidWYpDQogCS8qDQogCSAqIGV4cHJlc3MgdXRpbGl6YXRpb24gaW4gdGVybXMgb2Yg
bGFyZ2UgYmxvY2tzIHRvIGF2b2lkDQogCSAqIG92ZXJmbG93IG9uIDMyLWJpdCBtYWNoaW5lcy4N
CisJICoNCisJICogTk9URTogZm9yIHRoZSB0aW1lIGJlaW5nLCB3ZSBtYWtlIGJzaXplID09IGZy
c2l6ZSB0byBodW1vcg0KKwkgKiBub3QteWV0LWFuY2llbnQgdmVyc2lvbnMgb2YgZ2xpYmMgdGhh
dCBhcmUgYnJva2VuLg0KKwkgKiBTb21lZGF5LCB3ZSB3aWxsIHByb2JhYmx5IHdhbnQgdG8gcmVw
b3J0IGEgcmVhbCBibG9jaw0KKwkgKiBzaXplLi4uICB3aGF0ZXZlciB0aGF0IG1heSBtZWFuIGZv
ciBhIG5ldHdvcmsgZmlsZSBzeXN0ZW0hDQogCSAqLw0KIAlidWYtPmZfYnNpemUgPSAxIDw8IENF
UEhfQkxPQ0tfU0hJRlQ7DQorCWJ1Zi0+Zl9mcnNpemUgPSAxIDw8IENFUEhfQkxPQ0tfU0hJRlQ7
DQogCWJ1Zi0+Zl9ibG9ja3MgPSBsZTY0X3RvX2NwdShzdC5rYikgPj4gKENFUEhfQkxPQ0tfU0hJ
RlQtMTApOw0KIAlidWYtPmZfYmZyZWUgPSBsZTY0X3RvX2NwdShzdC5rYl9hdmFpbCkgPj4gKENF
UEhfQkxPQ0tfU0hJRlQtMTApOw0KIAlidWYtPmZfYmF2YWlsID0gbGU2NF90b19jcHUoc3Qua2Jf
YXZhaWwpID4+IChDRVBIX0JMT0NLX1NISUZULTEwKTsNCkBAIC03OSw3ICs4NSw2IEBAIHN0YXRp
YyBpbnQgY2VwaF9zdGF0ZnMoc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1Y3Qga3N0YXRmcyAq
YnVmKQ0KIAlidWYtPmZfZmlsZXMgPSBsZTY0X3RvX2NwdShzdC5udW1fb2JqZWN0cyk7DQogCWJ1
Zi0+Zl9mZnJlZSA9IC0xOw0KIAlidWYtPmZfbmFtZWxlbiA9IE5BTUVfTUFYOw0KLQlidWYtPmZf
ZnJzaXplID0gUEFHRV9DQUNIRV9TSVpFOw0KIA0KIAkvKiBsZWF2ZSBmc2lkIGxpdHRsZS1lbmRp
YW4sIHJlZ2FyZGxlc3Mgb2YgaG9zdCBlbmRpYW5uZXNzICovDQogCWZzaWQgPSAqKHU2NCAqKSgm
bW9ubWFwLT5mc2lkKSBeICooKHU2NCAqKSZtb25tYXAtPmZzaWQgKyAxKTsNCmRpZmYgLS1naXQg
YS9mcy9jZXBoL3N1cGVyLmggYi9mcy9jZXBoL3N1cGVyLmgNCmluZGV4IGVkY2JmMzcuLmEwOTc4
MTcgMTAwNjQ0DQotLS0gYS9mcy9jZXBoL3N1cGVyLmgNCisrKyBiL2ZzL2NlcGgvc3VwZXIuaA0K
QEAgLTIxLDcgKzIxLDcgQEANCiANCiAvKiBsYXJnZSBncmFudWxhcml0eSBmb3Igc3RhdGZzIHV0
aWxpemF0aW9uIHN0YXRzIHRvIGZhY2lsaXRhdGUNCiAgKiBsYXJnZSB2b2x1bWUgc2l6ZXMgb24g
MzItYml0IG1hY2hpbmVzLiAqLw0KLSNkZWZpbmUgQ0VQSF9CTE9DS19TSElGVCAgIDIwICAvKiAx
IE1CICovDQorI2RlZmluZSBDRVBIX0JMT0NLX1NISUZUICAgMjIgIC8qIDQgTUIgKi8NCiAjZGVm
aW5lIENFUEhfQkxPQ0sgICAgICAgICAoMSA8PCBDRVBIX0JMT0NLX1NISUZUKQ0KIA0KICNkZWZp
bmUgQ0VQSF9NT1VOVF9PUFRfRElSU1RBVCAgICAgICAgICgxPDw0KSAvKiBgY2F0IGRpcm5hbWVg
IGZvciBzdGF0cyAqLw0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc191bmljb2RlLmggYi9mcy9j
aWZzL2NpZnNfdW5pY29kZS5oDQppbmRleCA2ZDAyZmQ1Li5hYWIxOGZlIDEwMDY0NA0KLS0tIGEv
ZnMvY2lmcy9jaWZzX3VuaWNvZGUuaA0KKysrIGIvZnMvY2lmcy9jaWZzX3VuaWNvZGUuaA0KQEAg
LTMyMywxNCArMzIzLDE0IEBAIFVuaVRvdXBwZXIocmVnaXN0ZXIgd2NoYXJfdCB1YykNCiAvKg0K
ICAqIFVuaVN0cnVwcjogIFVwcGVyIGNhc2UgYSB1bmljb2RlIHN0cmluZw0KICAqLw0KLXN0YXRp
YyBpbmxpbmUgd2NoYXJfdCAqDQotVW5pU3RydXByKHJlZ2lzdGVyIHdjaGFyX3QgKnVwaW4pDQor
c3RhdGljIGlubGluZSBfX2xlMTYgKg0KK1VuaVN0cnVwcihyZWdpc3RlciBfX2xlMTYgKnVwaW4p
DQogew0KLQlyZWdpc3RlciB3Y2hhcl90ICp1cDsNCisJcmVnaXN0ZXIgX19sZTE2ICp1cDsNCiAN
CiAJdXAgPSB1cGluOw0KIAl3aGlsZSAoKnVwKSB7CQkvKiBGb3IgYWxsIGNoYXJhY3RlcnMgKi8N
Ci0JCSp1cCA9IFVuaVRvdXBwZXIoKnVwKTsNCisJCSp1cCA9IGNwdV90b19sZTE2KFVuaVRvdXBw
ZXIobGUxNl90b19jcHUoKnVwKSkpOw0KIAkJdXArKzsNCiAJfQ0KIAlyZXR1cm4gdXBpbjsJCS8q
IFJldHVybiBpbnB1dCBwb2ludGVyICovDQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZW5jcnlw
dC5jIGIvZnMvY2lmcy9jaWZzZW5jcnlwdC5jDQppbmRleCA1ZDliOWFjLi5jZGNkNjY1IDEwMDY0
NA0KLS0tIGEvZnMvY2lmcy9jaWZzZW5jcnlwdC5jDQorKysgYi9mcy9jaWZzL2NpZnNlbmNyeXB0
LmMNCkBAIC0zOTQsNyArMzk0LDcgQEAgc3RhdGljIGludCBjYWxjX250bG12Ml9oYXNoKHN0cnVj
dCBjaWZzX3NlcyAqc2VzLCBjaGFyICpudGxtdjJfaGFzaCwNCiAJaW50IHJjID0gMDsNCiAJaW50
IGxlbjsNCiAJY2hhciBudF9oYXNoW0NJRlNfTlRIQVNIX1NJWkVdOw0KLQl3Y2hhcl90ICp1c2Vy
Ow0KKwlfX2xlMTYgKnVzZXI7DQogCXdjaGFyX3QgKmRvbWFpbjsNCiAJd2NoYXJfdCAqc2VydmVy
Ow0KIA0KQEAgLTQxOSw3ICs0MTksNyBAQCBzdGF0aWMgaW50IGNhbGNfbnRsbXYyX2hhc2goc3Ry
dWN0IGNpZnNfc2VzICpzZXMsIGNoYXIgKm50bG12Ml9oYXNoLA0KIAkJcmV0dXJuIHJjOw0KIAl9
DQogDQotCS8qIGNvbnZlcnQgc2VzLT51c2VyX25hbWUgdG8gdW5pY29kZSBhbmQgdXBwZXJjYXNl
ICovDQorCS8qIGNvbnZlcnQgc2VzLT51c2VyX25hbWUgdG8gdW5pY29kZSAqLw0KIAlsZW4gPSBz
dHJsZW4oc2VzLT51c2VyX25hbWUpOw0KIAl1c2VyID0ga21hbGxvYygyICsgKGxlbiAqIDIpLCBH
RlBfS0VSTkVMKTsNCiAJaWYgKHVzZXIgPT0gTlVMTCkgew0KQEAgLTQyNyw3ICs0MjcsNyBAQCBz
dGF0aWMgaW50IGNhbGNfbnRsbXYyX2hhc2goc3RydWN0IGNpZnNfc2VzICpzZXMsIGNoYXIgKm50
bG12Ml9oYXNoLA0KIAkJcmMgPSAtRU5PTUVNOw0KIAkJcmV0dXJuIHJjOw0KIAl9DQotCWxlbiA9
IGNpZnNfc3RydG9VQ1MoKF9fbGUxNiAqKXVzZXIsIHNlcy0+dXNlcl9uYW1lLCBsZW4sIG5sc19j
cCk7DQorCWxlbiA9IGNpZnNfc3RydG9VQ1ModXNlciwgc2VzLT51c2VyX25hbWUsIGxlbiwgbmxz
X2NwKTsNCiAJVW5pU3RydXByKHVzZXIpOw0KIA0KIAlyYyA9IGNyeXB0b19zaGFzaF91cGRhdGUo
JnNlcy0+c2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY21kNS0+c2hhc2gsDQpkaWZmIC0tZ2l0IGEv
ZnMvZXhlYy5jIGIvZnMvZXhlYy5jDQppbmRleCAzMTJlMjk3Li5hMmQwZTUxIDEwMDY0NA0KLS0t
IGEvZnMvZXhlYy5jDQorKysgYi9mcy9leGVjLmMNCkBAIC0xMTU5LDEzICsxMTU5LDYgQEAgdm9p
ZCBzZXR1cF9uZXdfZXhlYyhzdHJ1Y3QgbGludXhfYmlucHJtICogYnBybSkNCiAJCQlzZXRfZHVt
cGFibGUoY3VycmVudC0+bW0sIHN1aWRfZHVtcGFibGUpOw0KIAl9DQogDQotCS8qDQotCSAqIEZs
dXNoIHBlcmZvcm1hbmNlIGNvdW50ZXJzIHdoZW4gY3Jvc3NpbmcgYQ0KLQkgKiBzZWN1cml0eSBk
b21haW46DQotCSAqLw0KLQlpZiAoIWdldF9kdW1wYWJsZShjdXJyZW50LT5tbSkpDQotCQlwZXJm
X2V2ZW50X2V4aXRfdGFzayhjdXJyZW50KTsNCi0NCiAJLyogQW4gZXhlYyBjaGFuZ2VzIG91ciBk
b21haW4uIFdlIGFyZSBubyBsb25nZXIgcGFydCBvZiB0aGUgdGhyZWFkDQogCSAgIGdyb3VwICov
DQogDQpAQCAtMTIyOSw2ICsxMjIyLDE1IEBAIHZvaWQgaW5zdGFsbF9leGVjX2NyZWRzKHN0cnVj
dCBsaW51eF9iaW5wcm0gKmJwcm0pDQogDQogCWNvbW1pdF9jcmVkcyhicHJtLT5jcmVkKTsNCiAJ
YnBybS0+Y3JlZCA9IE5VTEw7DQorDQorCS8qDQorCSAqIERpc2FibGUgbW9uaXRvcmluZyBmb3Ig
cmVndWxhciB1c2Vycw0KKwkgKiB3aGVuIGV4ZWN1dGluZyBzZXR1aWQgYmluYXJpZXMuIE11c3QN
CisJICogd2FpdCB1bnRpbCBuZXcgY3JlZGVudGlhbHMgYXJlIGNvbW1pdHRlZA0KKwkgKiBieSBj
b21taXRfY3JlZHMoKSBhYm92ZQ0KKwkgKi8NCisJaWYgKGdldF9kdW1wYWJsZShjdXJyZW50LT5t
bSkgIT0gU1VJRF9EVU1QX1VTRVIpDQorCQlwZXJmX2V2ZW50X2V4aXRfdGFzayhjdXJyZW50KTsN
CiAJLyoNCiAJICogY3JlZF9ndWFyZF9tdXRleCBtdXN0IGJlIGhlbGQgYXQgbGVhc3QgdG8gdGhp
cyBwb2ludCB0byBwcmV2ZW50DQogCSAqIHB0cmFjZV9hdHRhY2goKSBmcm9tIGFsdGVyaW5nIG91
ciBkZXRlcm1pbmF0aW9uIG9mIHRoZSB0YXNrJ3MNCmRpZmYgLS1naXQgYS9mcy9leHQzL25hbWVp
LmMgYi9mcy9leHQzL25hbWVpLmMNCmluZGV4IDY0MmRjNmQuLjEyNzJkZmIgMTAwNjQ0DQotLS0g
YS9mcy9leHQzL25hbWVpLmMNCisrKyBiL2ZzL2V4dDMvbmFtZWkuYw0KQEAgLTU4NSwxMSArNTg1
LDggQEAgc3RhdGljIGludCBodHJlZV9kaXJibG9ja190b190cmVlKHN0cnVjdCBmaWxlICpkaXJf
ZmlsZSwNCiAJCWlmICghZXh0M19jaGVja19kaXJfZW50cnkoImh0cmVlX2RpcmJsb2NrX3RvX3Ry
ZWUiLCBkaXIsIGRlLCBiaCwNCiAJCQkJCShibG9jazw8RVhUM19CTE9DS19TSVpFX0JJVFMoZGly
LT5pX3NiKSkNCiAJCQkJCQkrKChjaGFyICopZGUgLSBiaC0+Yl9kYXRhKSkpIHsNCi0JCQkvKiBP
biBlcnJvciwgc2tpcCB0aGUgZl9wb3MgdG8gdGhlIG5leHQgYmxvY2suICovDQotCQkJZGlyX2Zp
bGUtPmZfcG9zID0gKGRpcl9maWxlLT5mX3BvcyB8DQotCQkJCQkoZGlyLT5pX3NiLT5zX2Jsb2Nr
c2l6ZSAtIDEpKSArIDE7DQotCQkJYnJlbHNlIChiaCk7DQotCQkJcmV0dXJuIGNvdW50Ow0KKwkJ
CS8qIHNpbGVudGx5IGlnbm9yZSB0aGUgcmVzdCBvZiB0aGUgYmxvY2sgKi8NCisJCQlicmVhazsN
CiAJCX0NCiAJCWV4dDNmc19kaXJoYXNoKGRlLT5uYW1lLCBkZS0+bmFtZV9sZW4sIGhpbmZvKTsN
CiAJCWlmICgoaGluZm8tPmhhc2ggPCBzdGFydF9oYXNoKSB8fA0KZGlmZiAtLWdpdCBhL2ZzL2V4
dDQvZXh0ZW50cy5jIGIvZnMvZXh0NC9leHRlbnRzLmMNCmluZGV4IGNlMGJjMjUuLjNlOGZjODAg
MTAwNjQ0DQotLS0gYS9mcy9leHQ0L2V4dGVudHMuYw0KKysrIGIvZnMvZXh0NC9leHRlbnRzLmMN
CkBAIC00ODAxLDcgKzQ4MDEsNyBAQCBzdGF0aWMgaW50IGV4dDRfeGF0dHJfZmllbWFwKHN0cnVj
dCBpbm9kZSAqaW5vZGUsDQogCQllcnJvciA9IGV4dDRfZ2V0X2lub2RlX2xvYyhpbm9kZSwgJmls
b2MpOw0KIAkJaWYgKGVycm9yKQ0KIAkJCXJldHVybiBlcnJvcjsNCi0JCXBoeXNpY2FsID0gaWxv
Yy5iaC0+Yl9ibG9ja25yIDw8IGJsb2NrYml0czsNCisJCXBoeXNpY2FsID0gKF9fdTY0KWlsb2Mu
YmgtPmJfYmxvY2tuciA8PCBibG9ja2JpdHM7DQogCQlvZmZzZXQgPSBFWFQ0X0dPT0RfT0xEX0lO
T0RFX1NJWkUgKw0KIAkJCQlFWFQ0X0koaW5vZGUpLT5pX2V4dHJhX2lzaXplOw0KIAkJcGh5c2lj
YWwgKz0gb2Zmc2V0Ow0KQEAgLTQ4MDksNyArNDgwOSw3IEBAIHN0YXRpYyBpbnQgZXh0NF94YXR0
cl9maWVtYXAoc3RydWN0IGlub2RlICppbm9kZSwNCiAJCWZsYWdzIHw9IEZJRU1BUF9FWFRFTlRf
REFUQV9JTkxJTkU7DQogCQlicmVsc2UoaWxvYy5iaCk7DQogCX0gZWxzZSB7IC8qIGV4dGVybmFs
IGJsb2NrICovDQotCQlwaHlzaWNhbCA9IEVYVDRfSShpbm9kZSktPmlfZmlsZV9hY2wgPDwgYmxv
Y2tiaXRzOw0KKwkJcGh5c2ljYWwgPSAoX191NjQpRVhUNF9JKGlub2RlKS0+aV9maWxlX2FjbCA8
PCBibG9ja2JpdHM7DQogCQlsZW5ndGggPSBpbm9kZS0+aV9zYi0+c19ibG9ja3NpemU7DQogCX0N
CiANCmRpZmYgLS1naXQgYS9mcy9leHQ0L2lub2RlLmMgYi9mcy9leHQ0L2lub2RlLmMNCmluZGV4
IDAyNWI0YjYuLjQ1Nzc4YTYgMTAwNjQ0DQotLS0gYS9mcy9leHQ0L2lub2RlLmMNCisrKyBiL2Zz
L2V4dDQvaW5vZGUuYw0KQEAgLTQzMzUsNyArNDMzNSw3IEBAIGludCBleHQ0X2dldGF0dHIoc3Ry
dWN0IHZmc21vdW50ICptbnQsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSwNCiAJCSBzdHJ1Y3Qga3N0
YXQgKnN0YXQpDQogew0KIAlzdHJ1Y3QgaW5vZGUgKmlub2RlOw0KLQl1bnNpZ25lZCBsb25nIGRl
bGFsbG9jX2Jsb2NrczsNCisJdW5zaWduZWQgbG9uZyBsb25nIGRlbGFsbG9jX2Jsb2NrczsNCiAN
CiAJaW5vZGUgPSBkZW50cnktPmRfaW5vZGU7DQogCWdlbmVyaWNfZmlsbGF0dHIoaW5vZGUsIHN0
YXQpOw0KQEAgLTQzNTIsNyArNDM1Miw3IEBAIGludCBleHQ0X2dldGF0dHIoc3RydWN0IHZmc21v
dW50ICptbnQsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSwNCiAJICovDQogCWRlbGFsbG9jX2Jsb2Nr
cyA9IEVYVDRfSShpbm9kZSktPmlfcmVzZXJ2ZWRfZGF0YV9ibG9ja3M7DQogDQotCXN0YXQtPmJs
b2NrcyArPSAoZGVsYWxsb2NfYmxvY2tzIDw8IGlub2RlLT5pX3NiLT5zX2Jsb2Nrc2l6ZV9iaXRz
KT4+OTsNCisJc3RhdC0+YmxvY2tzICs9IGRlbGFsbG9jX2Jsb2NrcyA8PCAoaW5vZGUtPmlfc2It
PnNfYmxvY2tzaXplX2JpdHMtOSk7DQogCXJldHVybiAwOw0KIH0NCiANCmRpZmYgLS1naXQgYS9m
cy9leHQ0L25hbWVpLmMgYi9mcy9leHQ0L25hbWVpLmMNCmluZGV4IDg4Zjk3ZTUuLjNjYTNiN2Yg
MTAwNjQ0DQotLS0gYS9mcy9leHQ0L25hbWVpLmMNCisrKyBiL2ZzL2V4dDQvbmFtZWkuYw0KQEAg
LTU4NSwxMSArNTg1LDggQEAgc3RhdGljIGludCBodHJlZV9kaXJibG9ja190b190cmVlKHN0cnVj
dCBmaWxlICpkaXJfZmlsZSwNCiAJCWlmIChleHQ0X2NoZWNrX2Rpcl9lbnRyeShkaXIsIE5VTEws
IGRlLCBiaCwNCiAJCQkJKGJsb2NrPDxFWFQ0X0JMT0NLX1NJWkVfQklUUyhkaXItPmlfc2IpKQ0K
IAkJCQkJICsgKChjaGFyICopZGUgLSBiaC0+Yl9kYXRhKSkpIHsNCi0JCQkvKiBPbiBlcnJvciwg
c2tpcCB0aGUgZl9wb3MgdG8gdGhlIG5leHQgYmxvY2suICovDQotCQkJZGlyX2ZpbGUtPmZfcG9z
ID0gKGRpcl9maWxlLT5mX3BvcyB8DQotCQkJCQkoZGlyLT5pX3NiLT5zX2Jsb2Nrc2l6ZSAtIDEp
KSArIDE7DQotCQkJYnJlbHNlKGJoKTsNCi0JCQlyZXR1cm4gY291bnQ7DQorCQkJLyogc2lsZW50
bHkgaWdub3JlIHRoZSByZXN0IG9mIHRoZSBibG9jayAqLw0KKwkJCWJyZWFrOw0KIAkJfQ0KIAkJ
ZXh0NGZzX2Rpcmhhc2goZGUtPm5hbWUsIGRlLT5uYW1lX2xlbiwgaGluZm8pOw0KIAkJaWYgKCho
aW5mby0+aGFzaCA8IHN0YXJ0X2hhc2gpIHx8DQpkaWZmIC0tZ2l0IGEvZnMvaHBmcy9tYXAuYyBi
L2ZzL2hwZnMvbWFwLmMNCmluZGV4IGE3OTA4MjEuLmVhM2QxY2EgMTAwNjQ0DQotLS0gYS9mcy9o
cGZzL21hcC5jDQorKysgYi9mcy9ocGZzL21hcC5jDQpAQCAtMTcsNyArMTcsOCBAQCB1bnNpZ25l
ZCBpbnQgKmhwZnNfbWFwX2JpdG1hcChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnMsIHVuc2lnbmVkIGJt
cF9ibG9jaywNCiAJCQkgc3RydWN0IHF1YWRfYnVmZmVyX2hlYWQgKnFiaCwgY2hhciAqaWQpDQog
ew0KIAlzZWNubyBzZWM7DQotCWlmIChocGZzX3NiKHMpLT5zYl9jaGspIGlmIChibXBfYmxvY2sg
KiAxNjM4NCA+IGhwZnNfc2IocyktPnNiX2ZzX3NpemUpIHsNCisJdW5zaWduZWQgbl9iYW5kcyA9
IChocGZzX3NiKHMpLT5zYl9mc19zaXplICsgMHgzZmZmKSA+PiAxNDsNCisJaWYgKGhwZnNfc2Io
cyktPnNiX2NoaykgaWYgKGJtcF9ibG9jayA+PSBuX2JhbmRzKSB7DQogCQlocGZzX2Vycm9yKHMs
ICJocGZzX21hcF9iaXRtYXAgY2FsbGVkIHdpdGggYmFkIHBhcmFtZXRlcjogJTA4eCBhdCAlcyIs
IGJtcF9ibG9jaywgaWQpOw0KIAkJcmV0dXJuIE5VTEw7DQogCX0NCmRpZmYgLS1naXQgYS9mcy9o
cGZzL3N1cGVyLmMgYi9mcy9ocGZzL3N1cGVyLmMNCmluZGV4IDk4NTgwYTMuLmY3NjBjMTUgMTAw
NjQ0DQotLS0gYS9mcy9ocGZzL3N1cGVyLmMNCisrKyBiL2ZzL2hwZnMvc3VwZXIuYw0KQEAgLTU1
Myw3ICs1NTMsMTMgQEAgc3RhdGljIGludCBocGZzX2ZpbGxfc3VwZXIoc3RydWN0IHN1cGVyX2Js
b2NrICpzLCB2b2lkICpvcHRpb25zLCBpbnQgc2lsZW50KQ0KIAlzYmktPnNiX2NwX3RhYmxlID0g
TlVMTDsNCiAJc2JpLT5zYl9jX2JpdG1hcCA9IC0xOw0KIAlzYmktPnNiX21heF9md2RfYWxsb2Mg
PSAweGZmZmZmZjsNCi0JDQorDQorCWlmIChzYmktPnNiX2ZzX3NpemUgPj0gMHg4MDAwMDAwMCkg
ew0KKwkJaHBmc19lcnJvcihzLCAiaW52YWxpZCBzaXplIGluIHN1cGVyYmxvY2s6ICUwOHgiLA0K
KwkJCSh1bnNpZ25lZClzYmktPnNiX2ZzX3NpemUpOw0KKwkJZ290byBiYWlsNDsNCisJfQ0KKw0K
IAkvKiBMb2FkIGJpdG1hcCBkaXJlY3RvcnkgKi8NCiAJaWYgKCEoc2JpLT5zYl9ibXBfZGlyID0g
aHBmc19sb2FkX2JpdG1hcF9kaXJlY3RvcnkocywgbGUzMl90b19jcHUoc3VwZXJibG9jay0+Yml0
bWFwcykpKSkNCiAJCWdvdG8gYmFpbDQ7DQpkaWZmIC0tZ2l0IGEvZnMvamJkMi90cmFuc2FjdGlv
bi5jIGIvZnMvamJkMi90cmFuc2FjdGlvbi5jDQppbmRleCA2YWM1YmIxLi4xOGVhNGQ5IDEwMDY0
NA0KLS0tIGEvZnMvamJkMi90cmFuc2FjdGlvbi5jDQorKysgYi9mcy9qYmQyL3RyYW5zYWN0aW9u
LmMNCkBAIC00NzAsMTAgKzQ3MCwxMCBAQCBpbnQgamJkMl9fam91cm5hbF9yZXN0YXJ0KGhhbmRs
ZV90ICpoYW5kbGUsIGludCBuYmxvY2tzLCBnZnBfdCBnZnBfbWFzaykNCiAJCSAgICZ0cmFuc2Fj
dGlvbi0+dF9vdXRzdGFuZGluZ19jcmVkaXRzKTsNCiAJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3Qo
JnRyYW5zYWN0aW9uLT50X3VwZGF0ZXMpKQ0KIAkJd2FrZV91cCgmam91cm5hbC0+al93YWl0X3Vw
ZGF0ZXMpOw0KKwl0aWQgPSB0cmFuc2FjdGlvbi0+dF90aWQ7DQogCXNwaW5fdW5sb2NrKCZ0cmFu
c2FjdGlvbi0+dF9oYW5kbGVfbG9jayk7DQogDQogCWpiZF9kZWJ1ZygyLCAicmVzdGFydGluZyBo
YW5kbGUgJXBcbiIsIGhhbmRsZSk7DQotCXRpZCA9IHRyYW5zYWN0aW9uLT50X3RpZDsNCiAJbmVl
ZF90b19zdGFydCA9ICF0aWRfZ2VxKGpvdXJuYWwtPmpfY29tbWl0X3JlcXVlc3QsIHRpZCk7DQog
CXJlYWRfdW5sb2NrKCZqb3VybmFsLT5qX3N0YXRlX2xvY2spOw0KIAlpZiAobmVlZF90b19zdGFy
dCkNCmRpZmYgLS1naXQgYS9mcy9uZnNkL25mczR4ZHIuYyBiL2ZzL25mc2QvbmZzNHhkci5jDQpp
bmRleCBhZGU1MzE2Li45OTYyNWI4IDEwMDY0NA0KLS0tIGEvZnMvbmZzZC9uZnM0eGRyLmMNCisr
KyBiL2ZzL25mc2QvbmZzNHhkci5jDQpAQCAtMTc3LDggKzE3Nyw4IEBAIHN0YXRpYyBfX2JlMzIg
KnJlYWRfYnVmKHN0cnVjdCBuZnNkNF9jb21wb3VuZGFyZ3MgKmFyZ3AsIHUzMiBuYnl0ZXMpDQog
CSAqLw0KIAltZW1jcHkocCwgYXJncC0+cCwgYXZhaWwpOw0KIAkvKiBzdGVwIHRvIG5leHQgcGFn
ZSAqLw0KLQlhcmdwLT5wID0gcGFnZV9hZGRyZXNzKGFyZ3AtPnBhZ2VsaXN0WzBdKTsNCiAJYXJn
cC0+cGFnZWxpc3QrKzsNCisJYXJncC0+cCA9IHBhZ2VfYWRkcmVzcyhhcmdwLT5wYWdlbGlzdFsw
XSk7DQogCWlmIChhcmdwLT5wYWdlbGVuIDwgUEFHRV9TSVpFKSB7DQogCQlhcmdwLT5lbmQgPSBh
cmdwLT5wICsgKGFyZ3AtPnBhZ2VsZW4+PjIpOw0KIAkJYXJncC0+cGFnZWxlbiA9IDA7DQpkaWZm
IC0tZ2l0IGEvZnMvb2NmczIveGF0dHIuYyBiL2ZzL29jZnMyL3hhdHRyLmMNCmluZGV4IDBkNWVh
OWMuLmJlZjE4N2IgMTAwNjQ0DQotLS0gYS9mcy9vY2ZzMi94YXR0ci5jDQorKysgYi9mcy9vY2Zz
Mi94YXR0ci5jDQpAQCAtNjQ5OSw2ICs2NDk5LDE2IEBAIHN0YXRpYyBpbnQgb2NmczJfcmVmbGlu
a194YXR0cl9pbmxpbmUoc3RydWN0IG9jZnMyX3hhdHRyX3JlZmxpbmsgKmFyZ3MpDQogCX0NCiAN
CiAJbmV3X29pID0gT0NGUzJfSShhcmdzLT5uZXdfaW5vZGUpOw0KKwkvKg0KKwkgKiBBZGp1c3Qg
ZXh0ZW50IHJlY29yZCBjb3VudCB0byByZXNlcnZlIHNwYWNlIGZvciBleHRlbmRlZCBhdHRyaWJ1
dGUuDQorCSAqIElubGluZSBkYXRhIGNvdW50IGhhZCBiZWVuIGFkanVzdGVkIGluIG9jZnMyX2R1
cGxpY2F0ZV9pbmxpbmVfZGF0YSgpLg0KKwkgKi8NCisJaWYgKCEobmV3X29pLT5pcF9keW5fZmVh
dHVyZXMgJiBPQ0ZTMl9JTkxJTkVfREFUQV9GTCkgJiYNCisJICAgICEob2NmczJfaW5vZGVfaXNf
ZmFzdF9zeW1saW5rKGFyZ3MtPm5ld19pbm9kZSkpKSB7DQorCQlzdHJ1Y3Qgb2NmczJfZXh0ZW50
X2xpc3QgKmVsID0gJm5ld19kaS0+aWQyLmlfbGlzdDsNCisJCWxlMTZfYWRkX2NwdSgmZWwtPmxf
Y291bnQsIC0oaW5saW5lX3NpemUgLw0KKwkJCQkJc2l6ZW9mKHN0cnVjdCBvY2ZzMl9leHRlbnRf
cmVjKSkpOw0KKwl9DQogCXNwaW5fbG9jaygmbmV3X29pLT5pcF9sb2NrKTsNCiAJbmV3X29pLT5p
cF9keW5fZmVhdHVyZXMgfD0gT0NGUzJfSEFTX1hBVFRSX0ZMIHwgT0NGUzJfSU5MSU5FX1hBVFRS
X0ZMOw0KIAluZXdfZGktPmlfZHluX2ZlYXR1cmVzID0gY3B1X3RvX2xlMTYobmV3X29pLT5pcF9k
eW5fZmVhdHVyZXMpOw0KZGlmZiAtLWdpdCBhL2ZzL3ViaWZzL2Rpci5jIGIvZnMvdWJpZnMvZGly
LmMNCmluZGV4IDY4MzQ5MjAuLmFhZWJmMGYgMTAwNjQ0DQotLS0gYS9mcy91Ymlmcy9kaXIuYw0K
KysrIGIvZnMvdWJpZnMvZGlyLmMNCkBAIC0zNTcsMzEgKzM1Nyw1MCBAQCBzdGF0aWMgdW5zaWdu
ZWQgaW50IHZmc19kZW50X3R5cGUodWludDhfdCB0eXBlKQ0KIHN0YXRpYyBpbnQgdWJpZnNfcmVh
ZGRpcihzdHJ1Y3QgZmlsZSAqZmlsZSwgdm9pZCAqZGlyZW50LCBmaWxsZGlyX3QgZmlsbGRpcikN
CiB7DQogCWludCBlcnIsIG92ZXIgPSAwOw0KKwlsb2ZmX3QgcG9zID0gZmlsZS0+Zl9wb3M7DQog
CXN0cnVjdCBxc3RyIG5tOw0KIAl1bmlvbiB1Ymlmc19rZXkga2V5Ow0KIAlzdHJ1Y3QgdWJpZnNf
ZGVudF9ub2RlICpkZW50Ow0KIAlzdHJ1Y3QgaW5vZGUgKmRpciA9IGZpbGUtPmZfcGF0aC5kZW50
cnktPmRfaW5vZGU7DQogCXN0cnVjdCB1Ymlmc19pbmZvICpjID0gZGlyLT5pX3NiLT5zX2ZzX2lu
Zm87DQogDQotCWRiZ19nZW4oImRpciBpbm8gJWx1LCBmX3BvcyAlI2xseCIsIGRpci0+aV9pbm8s
IGZpbGUtPmZfcG9zKTsNCisJZGJnX2dlbigiZGlyIGlubyAlbHUsIGZfcG9zICUjbGx4IiwgZGly
LT5pX2lubywgcG9zKTsNCiANCi0JaWYgKGZpbGUtPmZfcG9zID4gVUJJRlNfU19LRVlfSEFTSF9N
QVNLIHx8IGZpbGUtPmZfcG9zID09IDIpDQorCWlmIChwb3MgPiBVQklGU19TX0tFWV9IQVNIX01B
U0sgfHwgcG9zID09IDIpDQogCQkvKg0KIAkJICogVGhlIGRpcmVjdG9yeSB3YXMgc2VlaydlZCB0
byBhIHNlbnNlbGVzcyBwb3NpdGlvbiBvciB0aGVyZQ0KIAkJICogYXJlIG5vIG1vcmUgZW50cmll
cy4NCiAJCSAqLw0KIAkJcmV0dXJuIDA7DQogDQorCWlmIChmaWxlLT5mX3ZlcnNpb24gPT0gMCkg
ew0KKwkJLyoNCisJCSAqIFRoZSBmaWxlIHdhcyBzZWVrJ2VkLCB3aGljaCBtZWFucyB0aGF0IEBm
aWxlLT5wcml2YXRlX2RhdGENCisJCSAqIGlzIG5vdyBpbnZhbGlkLiBUaGlzIG1heSBhbHNvIGJl
IGp1c3QgdGhlIGZpcnN0DQorCQkgKiAndWJpZnNfcmVhZGRpcigpJyBpbnZvY2F0aW9uLCBpbiB3
aGljaCBjYXNlDQorCQkgKiBAZmlsZS0+cHJpdmF0ZV9kYXRhIGlzIE5VTEwsIGFuZCB0aGUgYmVs
b3cgY29kZSBpcw0KKwkJICogYmFzaWNhbGx5IGEgbm8tb3AuDQorCQkgKi8NCisJCWtmcmVlKGZp
bGUtPnByaXZhdGVfZGF0YSk7DQorCQlmaWxlLT5wcml2YXRlX2RhdGEgPSBOVUxMOw0KKwl9DQor
DQorCS8qDQorCSAqICdnZW5lcmljX2ZpbGVfbGxzZWVrKCknIHVuY29uZGl0aW9uYWxseSBzZXRz
IEBmaWxlLT5mX3ZlcnNpb24gdG8NCisJICogemVybywgYW5kIHdlIHVzZSB0aGlzIGZvciBkZXRl
Y3Rpbmcgd2hldGhlciB0aGUgZmlsZSB3YXMgc2VlaydlZC4NCisJICovDQorCWZpbGUtPmZfdmVy
c2lvbiA9IDE7DQorDQogCS8qIEZpbGUgcG9zaXRpb25zIDAgYW5kIDEgY29ycmVzcG9uZCB0byAi
LiIgYW5kICIuLiIgKi8NCi0JaWYgKGZpbGUtPmZfcG9zID09IDApIHsNCisJaWYgKHBvcyA9PSAw
KSB7DQogCQl1Ymlmc19hc3NlcnQoIWZpbGUtPnByaXZhdGVfZGF0YSk7DQogCQlvdmVyID0gZmls
bGRpcihkaXJlbnQsICIuIiwgMSwgMCwgZGlyLT5pX2lubywgRFRfRElSKTsNCiAJCWlmIChvdmVy
KQ0KIAkJCXJldHVybiAwOw0KLQkJZmlsZS0+Zl9wb3MgPSAxOw0KKwkJZmlsZS0+Zl9wb3MgPSBw
b3MgPSAxOw0KIAl9DQogDQotCWlmIChmaWxlLT5mX3BvcyA9PSAxKSB7DQorCWlmIChwb3MgPT0g
MSkgew0KIAkJdWJpZnNfYXNzZXJ0KCFmaWxlLT5wcml2YXRlX2RhdGEpOw0KIAkJb3ZlciA9IGZp
bGxkaXIoZGlyZW50LCAiLi4iLCAyLCAxLA0KIAkJCSAgICAgICBwYXJlbnRfaW5vKGZpbGUtPmZf
cGF0aC5kZW50cnkpLCBEVF9ESVIpOw0KQEAgLTM5Nyw3ICs0MTYsNyBAQCBzdGF0aWMgaW50IHVi
aWZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgKmRpcmVudCwgZmlsbGRpcl90IGZp
bGxkaXIpDQogCQkJZ290byBvdXQ7DQogCQl9DQogDQotCQlmaWxlLT5mX3BvcyA9IGtleV9oYXNo
X2ZsYXNoKGMsICZkZW50LT5rZXkpOw0KKwkJZmlsZS0+Zl9wb3MgPSBwb3MgPSBrZXlfaGFzaF9m
bGFzaChjLCAmZGVudC0+a2V5KTsNCiAJCWZpbGUtPnByaXZhdGVfZGF0YSA9IGRlbnQ7DQogCX0N
CiANCkBAIC00MDUsMTcgKzQyNCwxNiBAQCBzdGF0aWMgaW50IHViaWZzX3JlYWRkaXIoc3RydWN0
IGZpbGUgKmZpbGUsIHZvaWQgKmRpcmVudCwgZmlsbGRpcl90IGZpbGxkaXIpDQogCWlmICghZGVu
dCkgew0KIAkJLyoNCiAJCSAqIFRoZSBkaXJlY3Rvcnkgd2FzIHNlZWsnZWQgdG8gYW5kIGlzIG5v
dyByZWFkZGlyJ2VkLg0KLQkJICogRmluZCB0aGUgZW50cnkgY29ycmVzcG9uZGluZyB0byBAZmls
ZS0+Zl9wb3Mgb3IgdGhlDQotCQkgKiBjbG9zZXN0IG9uZS4NCisJCSAqIEZpbmQgdGhlIGVudHJ5
IGNvcnJlc3BvbmRpbmcgdG8gQHBvcyBvciB0aGUgY2xvc2VzdCBvbmUuDQogCQkgKi8NCi0JCWRl
bnRfa2V5X2luaXRfaGFzaChjLCAma2V5LCBkaXItPmlfaW5vLCBmaWxlLT5mX3Bvcyk7DQorCQlk
ZW50X2tleV9pbml0X2hhc2goYywgJmtleSwgZGlyLT5pX2lubywgcG9zKTsNCiAJCW5tLm5hbWUg
PSBOVUxMOw0KIAkJZGVudCA9IHViaWZzX3RuY19uZXh0X2VudChjLCAma2V5LCAmbm0pOw0KIAkJ
aWYgKElTX0VSUihkZW50KSkgew0KIAkJCWVyciA9IFBUUl9FUlIoZGVudCk7DQogCQkJZ290byBv
dXQ7DQogCQl9DQotCQlmaWxlLT5mX3BvcyA9IGtleV9oYXNoX2ZsYXNoKGMsICZkZW50LT5rZXkp
Ow0KKwkJZmlsZS0+Zl9wb3MgPSBwb3MgPSBrZXlfaGFzaF9mbGFzaChjLCAmZGVudC0+a2V5KTsN
CiAJCWZpbGUtPnByaXZhdGVfZGF0YSA9IGRlbnQ7DQogCX0NCiANCkBAIC00MjcsNyArNDQ1LDcg
QEAgc3RhdGljIGludCB1Ymlmc19yZWFkZGlyKHN0cnVjdCBmaWxlICpmaWxlLCB2b2lkICpkaXJl
bnQsIGZpbGxkaXJfdCBmaWxsZGlyKQ0KIAkJCSAgICAgdWJpZnNfaW5vZGUoZGlyKS0+Y3JlYXRf
c3FudW0pOw0KIA0KIAkJbm0ubGVuID0gbGUxNl90b19jcHUoZGVudC0+bmxlbik7DQotCQlvdmVy
ID0gZmlsbGRpcihkaXJlbnQsIGRlbnQtPm5hbWUsIG5tLmxlbiwgZmlsZS0+Zl9wb3MsDQorCQlv
dmVyID0gZmlsbGRpcihkaXJlbnQsIGRlbnQtPm5hbWUsIG5tLmxlbiwgcG9zLA0KIAkJCSAgICAg
ICBsZTY0X3RvX2NwdShkZW50LT5pbnVtKSwNCiAJCQkgICAgICAgdmZzX2RlbnRfdHlwZShkZW50
LT50eXBlKSk7DQogCQlpZiAob3ZlcikNCkBAIC00NDMsOSArNDYxLDE3IEBAIHN0YXRpYyBpbnQg
dWJpZnNfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqZmlsZSwgdm9pZCAqZGlyZW50LCBmaWxsZGlyX3Qg
ZmlsbGRpcikNCiAJCX0NCiANCiAJCWtmcmVlKGZpbGUtPnByaXZhdGVfZGF0YSk7DQotCQlmaWxl
LT5mX3BvcyA9IGtleV9oYXNoX2ZsYXNoKGMsICZkZW50LT5rZXkpOw0KKwkJZmlsZS0+Zl9wb3Mg
PSBwb3MgPSBrZXlfaGFzaF9mbGFzaChjLCAmZGVudC0+a2V5KTsNCiAJCWZpbGUtPnByaXZhdGVf
ZGF0YSA9IGRlbnQ7DQogCQljb25kX3Jlc2NoZWQoKTsNCisNCisJCWlmIChmaWxlLT5mX3ZlcnNp
b24gPT0gMCkNCisJCQkvKg0KKwkJCSAqIFRoZSBmaWxlIHdhcyBzZWVrJ2VkIG1lYW53aGlsZSwg
bGV0cyByZXR1cm4gYW5kIHN0YXJ0DQorCQkJICogcmVhZGluZyBkaXJlbnRyaWVzIGZyb20gdGhl
IG5ldyBwb3NpdGlvbiBvbiB0aGUgbmV4dA0KKwkJCSAqIGludm9jYXRpb24uDQorCQkJICovDQor
CQkJcmV0dXJuIDA7DQogCX0NCiANCiBvdXQ6DQpAQCAtNDU2LDE1ICs0ODIsMTMgQEAgb3V0Og0K
IA0KIAlrZnJlZShmaWxlLT5wcml2YXRlX2RhdGEpOw0KIAlmaWxlLT5wcml2YXRlX2RhdGEgPSBO
VUxMOw0KKwkvKiAyIGlzIGEgc3BlY2lhbCB2YWx1ZSBpbmRpY2F0aW5nIHRoYXQgdGhlcmUgYXJl
IG5vIG1vcmUgZGlyZW50cmllcyAqLw0KIAlmaWxlLT5mX3BvcyA9IDI7DQogCXJldHVybiAwOw0K
IH0NCiANCi0vKiBJZiBhIGRpcmVjdG9yeSBpcyBzZWVrZWQsIHdlIGhhdmUgdG8gZnJlZSBzYXZl
ZCByZWFkZGlyKCkgc3RhdGUgKi8NCiBzdGF0aWMgbG9mZl90IHViaWZzX2Rpcl9sbHNlZWsoc3Ry
dWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBvZmZzZXQsIGludCBvcmlnaW4pDQogew0KLQlrZnJlZShm
aWxlLT5wcml2YXRlX2RhdGEpOw0KLQlmaWxlLT5wcml2YXRlX2RhdGEgPSBOVUxMOw0KIAlyZXR1
cm4gZ2VuZXJpY19maWxlX2xsc2VlayhmaWxlLCBvZmZzZXQsIG9yaWdpbik7DQogfQ0KIA0KZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvY2dyb3VwLmggYi9pbmNsdWRlL2xpbnV4L2Nncm91cC5o
DQppbmRleCA5YmFiNzVmLi5hY2UwOTg0IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9jZ3Jv
dXAuaA0KKysrIGIvaW5jbHVkZS9saW51eC9jZ3JvdXAuaA0KQEAgLTUzMSwxNiArNTMxLDU0IEBA
IHN0YXRpYyBpbmxpbmUgc3RydWN0IGNncm91cF9zdWJzeXNfc3RhdGUgKmNncm91cF9zdWJzeXNf
c3RhdGUoDQogCXJldHVybiBjZ3JwLT5zdWJzeXNbc3Vic3lzX2lkXTsNCiB9DQogDQotLyoNCi0g
KiBmdW5jdGlvbiB0byBnZXQgdGhlIGNncm91cF9zdWJzeXNfc3RhdGUgd2hpY2ggYWxsb3dzIGZv
ciBleHRyYQ0KLSAqIHJjdV9kZXJlZmVyZW5jZV9jaGVjaygpIGNvbmRpdGlvbnMsIHN1Y2ggYXMg
bG9ja3MgdXNlZCBkdXJpbmcgdGhlDQotICogY2dyb3VwX3N1YnN5czo6YXR0YWNoKCkgbWV0aG9k
cy4NCisvKioNCisgKiB0YXNrX2Nzc19zZXRfY2hlY2sgLSBvYnRhaW4gYSB0YXNrJ3MgY3NzX3Nl
dCB3aXRoIGV4dHJhIGFjY2VzcyBjb25kaXRpb25zDQorICogQHRhc2s6IHRoZSB0YXNrIHRvIG9i
dGFpbiBjc3Nfc2V0IGZvcg0KKyAqIEBfX2M6IGV4dHJhIGNvbmRpdGlvbiBleHByZXNzaW9uIHRv
IGJlIHBhc3NlZCB0byByY3VfZGVyZWZlcmVuY2VfY2hlY2soKQ0KKyAqDQorICogQSB0YXNrJ3Mg
Y3NzX3NldCBpcyBSQ1UgcHJvdGVjdGVkLCBpbml0aWFsaXplZCBhbmQgZXhpdGVkIHdoaWxlIGhv
bGRpbmcNCisgKiB0YXNrX2xvY2soKSwgYW5kIGNhbiBvbmx5IGJlIG1vZGlmaWVkIHdoaWxlIGhv
bGRpbmcgYm90aCBjZ3JvdXBfbXV0ZXgNCisgKiBhbmQgdGFza19sb2NrKCkgd2hpbGUgdGhlIHRh
c2sgaXMgYWxpdmUuICBUaGlzIG1hY3JvIHZlcmlmaWVzIHRoYXQgdGhlDQorICogY2FsbGVyIGlz
IGluc2lkZSBwcm9wZXIgY3JpdGljYWwgc2VjdGlvbiBhbmQgcmV0dXJucyBAdGFzaydzIGNzc19z
ZXQuDQorICoNCisgKiBUaGUgY2FsbGVyIGNhbiBhbHNvIHNwZWNpZnkgYWRkaXRpb25hbCBhbGxv
d2VkIGNvbmRpdGlvbnMgdmlhIEBfX2MsIHN1Y2gNCisgKiBhcyBsb2NrcyB1c2VkIGR1cmluZyB0
aGUgY2dyb3VwX3N1YnN5czo6YXR0YWNoKCkgbWV0aG9kcy4NCisgKi8NCisjZGVmaW5lIHRhc2tf
Y3NzX3NldF9jaGVjayh0YXNrLCBfX2MpCQkJCQlcDQorCXJjdV9kZXJlZmVyZW5jZV9jaGVjaygo
dGFzayktPmNncm91cHMsCQkJCVwNCisJCWxvY2tkZXBfaXNfaGVsZCgmKHRhc2spLT5hbGxvY19s
b2NrKSB8fAkJCVwNCisJCWNncm91cF9sb2NrX2lzX2hlbGQoKSB8fCAoX19jKSkNCisNCisvKioN
CisgKiB0YXNrX3N1YnN5c19zdGF0ZV9jaGVjayAtIG9idGFpbiBjc3MgZm9yICh0YXNrLCBzdWJz
eXMpIHcvIGV4dHJhIGFjY2VzcyBjb25kcw0KKyAqIEB0YXNrOiB0aGUgdGFyZ2V0IHRhc2sNCisg
KiBAc3Vic3lzX2lkOiB0aGUgdGFyZ2V0IHN1YnN5c3RlbSBJRA0KKyAqIEBfX2M6IGV4dHJhIGNv
bmRpdGlvbiBleHByZXNzaW9uIHRvIGJlIHBhc3NlZCB0byByY3VfZGVyZWZlcmVuY2VfY2hlY2so
KQ0KKyAqDQorICogUmV0dXJuIHRoZSBjZ3JvdXBfc3Vic3lzX3N0YXRlIGZvciB0aGUgKEB0YXNr
LCBAc3Vic3lzX2lkKSBwYWlyLiAgVGhlDQorICogc3luY2hyb25pemF0aW9uIHJ1bGVzIGFyZSB0
aGUgc2FtZSBhcyB0YXNrX2Nzc19zZXRfY2hlY2soKS4NCiAgKi8NCiAjZGVmaW5lIHRhc2tfc3Vi
c3lzX3N0YXRlX2NoZWNrKHRhc2ssIHN1YnN5c19pZCwgX19jKQkJCVwNCi0JcmN1X2RlcmVmZXJl
bmNlX2NoZWNrKHRhc2stPmNncm91cHMtPnN1YnN5c1tzdWJzeXNfaWRdLAkJXA0KLQkJCSAgICAg
IGxvY2tkZXBfaXNfaGVsZCgmdGFzay0+YWxsb2NfbG9jaykgfHwJXA0KLQkJCSAgICAgIGNncm91
cF9sb2NrX2lzX2hlbGQoKSB8fCAoX19jKSkNCisJdGFza19jc3Nfc2V0X2NoZWNrKCh0YXNrKSwg
KF9fYykpLT5zdWJzeXNbKHN1YnN5c19pZCldDQorDQorLyoqDQorICogdGFza19jc3Nfc2V0IC0g
b2J0YWluIGEgdGFzaydzIGNzc19zZXQNCisgKiBAdGFzazogdGhlIHRhc2sgdG8gb2J0YWluIGNz
c19zZXQgZm9yDQorICoNCisgKiBTZWUgdGFza19jc3Nfc2V0X2NoZWNrKCkuDQorICovDQorc3Rh
dGljIGlubGluZSBzdHJ1Y3QgY3NzX3NldCAqdGFza19jc3Nfc2V0KHN0cnVjdCB0YXNrX3N0cnVj
dCAqdGFzaykNCit7DQorCXJldHVybiB0YXNrX2Nzc19zZXRfY2hlY2sodGFzaywgZmFsc2UpOw0K
K30NCiANCisvKioNCisgKiB0YXNrX3N1YnN5c19zdGF0ZSAtIG9idGFpbiBjc3MgZm9yICh0YXNr
LCBzdWJzeXMpDQorICogQHRhc2s6IHRoZSB0YXJnZXQgdGFzaw0KKyAqIEBzdWJzeXNfaWQ6IHRo
ZSB0YXJnZXQgc3Vic3lzdGVtIElEDQorICoNCisgKiBTZWUgdGFza19zdWJzeXNfc3RhdGVfY2hl
Y2soKS4NCisgKi8NCiBzdGF0aWMgaW5saW5lIHN0cnVjdCBjZ3JvdXBfc3Vic3lzX3N0YXRlICoN
CiB0YXNrX3N1YnN5c19zdGF0ZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ssIGludCBzdWJzeXNf
aWQpDQogew0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaHVnZXRsYi5oIGIvaW5jbHVkZS9s
aW51eC9odWdldGxiLmgNCmluZGV4IGEyMjI3ZjcuLjMyNjk3YzEgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL2xpbnV4L2h1Z2V0bGIuaA0KKysrIGIvaW5jbHVkZS9saW51eC9odWdldGxiLmgNCkBAIC0z
MjcsNiArMzI3LDE3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaHN0YXRlX2luZGV4X3RvX3No
aWZ0KHVuc2lnbmVkIGluZGV4KQ0KIAlyZXR1cm4gaHN0YXRlc1tpbmRleF0ub3JkZXIgKyBQQUdF
X1NISUZUOw0KIH0NCiANCitwZ29mZl90IF9fYmFzZXBhZ2VfaW5kZXgoc3RydWN0IHBhZ2UgKnBh
Z2UpOw0KKw0KKy8qIFJldHVybiBwYWdlLT5pbmRleCBpbiBQQUdFX1NJWkUgdW5pdHMgKi8NCitz
dGF0aWMgaW5saW5lIHBnb2ZmX3QgYmFzZXBhZ2VfaW5kZXgoc3RydWN0IHBhZ2UgKnBhZ2UpDQor
ew0KKwlpZiAoIVBhZ2VDb21wb3VuZChwYWdlKSkNCisJCXJldHVybiBwYWdlLT5pbmRleDsNCisN
CisJcmV0dXJuIF9fYmFzZXBhZ2VfaW5kZXgocGFnZSk7DQorfQ0KKw0KICNlbHNlDQogc3RydWN0
IGhzdGF0ZSB7fTsNCiAjZGVmaW5lIGFsbG9jX2h1Z2VfcGFnZV9ub2RlKGgsIG5pZCkgTlVMTA0K
QEAgLTM0NSw2ICszNTYsMTEgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgcGFnZXNfcGVy
X2h1Z2VfcGFnZShzdHJ1Y3QgaHN0YXRlICpoKQ0KIAlyZXR1cm4gMTsNCiB9DQogI2RlZmluZSBo
c3RhdGVfaW5kZXhfdG9fc2hpZnQoaW5kZXgpIDANCisNCitzdGF0aWMgaW5saW5lIHBnb2ZmX3Qg
YmFzZXBhZ2VfaW5kZXgoc3RydWN0IHBhZ2UgKnBhZ2UpDQorew0KKwlyZXR1cm4gcGFnZS0+aW5k
ZXg7DQorfQ0KICNlbmRpZg0KIA0KICNlbmRpZiAvKiBfTElOVVhfSFVHRVRMQl9IICovDQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uYmQuaCBiL2luY2x1ZGUvbGludXgvbmJkLmgNCmluZGV4
IGQxNDZjYTEuLmU2ZmUxNzQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L25iZC5oDQorKysg
Yi9pbmNsdWRlL2xpbnV4L25iZC5oDQpAQCAtNjgsNiArNjgsNyBAQCBzdHJ1Y3QgbmJkX2Rldmlj
ZSB7DQogCXU2NCBieXRlc2l6ZTsNCiAJcGlkX3QgcGlkOyAvKiBwaWQgb2YgbmJkLWNsaWVudCwg
aWYgYXR0YWNoZWQgKi8NCiAJaW50IHhtaXRfdGltZW91dDsNCisJaW50IGRpc2Nvbm5lY3Q7IC8q
IGEgZGlzY29ubmVjdCBoYXMgYmVlbiByZXF1ZXN0ZWQgYnkgdXNlciAqLw0KIH07DQogDQogI2Vu
ZGlmDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmggYi9pbmNsdWRlL2xp
bnV4L3BlcmZfZXZlbnQuaA0KaW5kZXggOWI5YjJhYS4uM2NmY2ZlYSAxMDA2NDQNCi0tLSBhL2lu
Y2x1ZGUvbGludXgvcGVyZl9ldmVudC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3BlcmZfZXZlbnQu
aA0KQEAgLTgxOSw4ICs4MTksNyBAQCBzdHJ1Y3QgcGVyZl9ldmVudCB7DQogCS8qIG1tYXAgYml0
cyAqLw0KIAlzdHJ1Y3QgbXV0ZXgJCQltbWFwX211dGV4Ow0KIAlhdG9taWNfdAkJCW1tYXBfY291
bnQ7DQotCWludAkJCQltbWFwX2xvY2tlZDsNCi0Jc3RydWN0IHVzZXJfc3RydWN0CQkqbW1hcF91
c2VyOw0KKw0KIAlzdHJ1Y3QgcmluZ19idWZmZXIJCSpyYjsNCiAJc3RydWN0IGxpc3RfaGVhZAkJ
cmJfZW50cnk7DQogDQpkaWZmIC0tZ2l0IGEva2VybmVsL2V2ZW50cy9jb3JlLmMgYi9rZXJuZWwv
ZXZlbnRzL2NvcmUuYw0KaW5kZXggOWYyMTkxNS4uOGJlOWI3NDYgMTAwNjQ0DQotLS0gYS9rZXJu
ZWwvZXZlbnRzL2NvcmUuYw0KKysrIGIva2VybmVsL2V2ZW50cy9jb3JlLmMNCkBAIC0xODUsOSAr
MTg1LDYgQEAgc3RhdGljIHZvaWQgY3B1X2N0eF9zY2hlZF9pbihzdHJ1Y3QgcGVyZl9jcHVfY29u
dGV4dCAqY3B1Y3R4LA0KIHN0YXRpYyB2b2lkIHVwZGF0ZV9jb250ZXh0X3RpbWUoc3RydWN0IHBl
cmZfZXZlbnRfY29udGV4dCAqY3R4KTsNCiBzdGF0aWMgdTY0IHBlcmZfZXZlbnRfdGltZShzdHJ1
Y3QgcGVyZl9ldmVudCAqZXZlbnQpOw0KIA0KLXN0YXRpYyB2b2lkIHJpbmdfYnVmZmVyX2F0dGFj
aChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQsDQotCQkJICAgICAgIHN0cnVjdCByaW5nX2J1ZmZl
ciAqcmIpOw0KLQ0KIHZvaWQgX193ZWFrIHBlcmZfZXZlbnRfcHJpbnRfZGVidWcodm9pZCkJeyB9
DQogDQogZXh0ZXJuIF9fd2VhayBjb25zdCBjaGFyICpwZXJmX3BtdV9uYW1lKHZvaWQpDQpAQCAt
NzE0LDggKzcxMSwxOCBAQCBwZXJmX2xvY2tfdGFza19jb250ZXh0KHN0cnVjdCB0YXNrX3N0cnVj
dCAqdGFzaywgaW50IGN0eG4sIHVuc2lnbmVkIGxvbmcgKmZsYWdzKQ0KIHsNCiAJc3RydWN0IHBl
cmZfZXZlbnRfY29udGV4dCAqY3R4Ow0KIA0KLQlyY3VfcmVhZF9sb2NrKCk7DQogcmV0cnk6DQor
CS8qDQorCSAqIE9uZSBvZiB0aGUgZmV3IHJ1bGVzIG9mIHByZWVtcHRpYmxlIFJDVSBpcyB0aGF0
IG9uZSBjYW5ub3QgZG8NCisJICogcmN1X3JlYWRfdW5sb2NrKCkgd2hpbGUgaG9sZGluZyBhIHNj
aGVkdWxlciAob3IgbmVzdGVkKSBsb2NrIHdoZW4NCisJICogcGFydCBvZiB0aGUgcmVhZCBzaWRl
IGNyaXRpY2FsIHNlY3Rpb24gd2FzIHByZWVtcHRpYmxlIC0tIHNlZQ0KKwkgKiByY3VfcmVhZF91
bmxvY2tfc3BlY2lhbCgpLg0KKwkgKg0KKwkgKiBTaW5jZSBjdHgtPmxvY2sgbmVzdHMgdW5kZXIg
cnEtPmxvY2sgd2UgbXVzdCBlbnN1cmUgdGhlIGVudGlyZSByZWFkDQorCSAqIHNpZGUgY3JpdGlj
YWwgc2VjdGlvbiBpcyBub24tcHJlZW1wdGlibGUuDQorCSAqLw0KKwlwcmVlbXB0X2Rpc2FibGUo
KTsNCisJcmN1X3JlYWRfbG9jaygpOw0KIAljdHggPSByY3VfZGVyZWZlcmVuY2UodGFzay0+cGVy
Zl9ldmVudF9jdHhwW2N0eG5dKTsNCiAJaWYgKGN0eCkgew0KIAkJLyoNCkBAIC03MzEsNiArNzM4
LDggQEAgcmV0cnk6DQogCQlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoJmN0eC0+bG9jaywgKmZsYWdz
KTsNCiAJCWlmIChjdHggIT0gcmN1X2RlcmVmZXJlbmNlKHRhc2stPnBlcmZfZXZlbnRfY3R4cFtj
dHhuXSkpIHsNCiAJCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY3R4LT5sb2NrLCAqZmxh
Z3MpOw0KKwkJCXJjdV9yZWFkX3VubG9jaygpOw0KKwkJCXByZWVtcHRfZW5hYmxlKCk7DQogCQkJ
Z290byByZXRyeTsNCiAJCX0NCiANCkBAIC03NDAsNiArNzQ5LDcgQEAgcmV0cnk6DQogCQl9DQog
CX0NCiAJcmN1X3JlYWRfdW5sb2NrKCk7DQorCXByZWVtcHRfZW5hYmxlKCk7DQogCXJldHVybiBj
dHg7DQogfQ0KIA0KQEAgLTE2ODcsNyArMTY5NywxNiBAQCBzdGF0aWMgaW50IF9fcGVyZl9ldmVu
dF9lbmFibGUodm9pZCAqaW5mbykNCiAJc3RydWN0IHBlcmZfY3B1X2NvbnRleHQgKmNwdWN0eCA9
IF9fZ2V0X2NwdV9jb250ZXh0KGN0eCk7DQogCWludCBlcnI7DQogDQotCWlmIChXQVJOX09OX09O
Q0UoIWN0eC0+aXNfYWN0aXZlKSkNCisJLyoNCisJICogVGhlcmUncyBhIHRpbWUgd2luZG93IGJl
dHdlZW4gJ2N0eC0+aXNfYWN0aXZlJyBjaGVjaw0KKwkgKiBpbiBwZXJmX2V2ZW50X2VuYWJsZSBm
dW5jdGlvbiBhbmQgdGhpcyBwbGFjZSBoYXZpbmc6DQorCSAqICAgLSBJUlFzIG9uDQorCSAqICAg
LSBjdHgtPmxvY2sgdW5sb2NrZWQNCisJICoNCisJICogd2hlcmUgdGhlIHRhc2sgY291bGQgYmUg
a2lsbGVkIGFuZCAnY3R4JyBkZWFjdGl2YXRlZA0KKwkgKiBieSBwZXJmX2V2ZW50X2V4aXRfdGFz
ay4NCisJICovDQorCWlmICghY3R4LT5pc19hY3RpdmUpDQogCQlyZXR1cm4gLUVJTlZBTDsNCiAN
CiAJcmF3X3NwaW5fbG9jaygmY3R4LT5sb2NrKTsNCkBAIC0yOTM5LDYgKzI5NTgsNyBAQCBzdGF0
aWMgdm9pZCBmcmVlX2V2ZW50X3JjdShzdHJ1Y3QgcmN1X2hlYWQgKmhlYWQpDQogfQ0KIA0KIHN0
YXRpYyB2b2lkIHJpbmdfYnVmZmVyX3B1dChzdHJ1Y3QgcmluZ19idWZmZXIgKnJiKTsNCitzdGF0
aWMgdm9pZCByaW5nX2J1ZmZlcl9kZXRhY2goc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50LCBzdHJ1
Y3QgcmluZ19idWZmZXIgKnJiKTsNCiANCiBzdGF0aWMgdm9pZCBmcmVlX2V2ZW50KHN0cnVjdCBw
ZXJmX2V2ZW50ICpldmVudCkNCiB7DQpAQCAtMjk2Miw4ICsyOTgyLDIyIEBAIHN0YXRpYyB2b2lk
IGZyZWVfZXZlbnQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KQ0KIAl9DQogDQogCWlmIChldmVu
dC0+cmIpIHsNCi0JCXJpbmdfYnVmZmVyX3B1dChldmVudC0+cmIpOw0KLQkJZXZlbnQtPnJiID0g
TlVMTDsNCisJCXN0cnVjdCByaW5nX2J1ZmZlciAqcmI7DQorDQorCQkvKg0KKwkJICogQ2FuIGhh
cHBlbiB3aGVuIHdlIGNsb3NlIGFuIGV2ZW50IHdpdGggcmUtZGlyZWN0ZWQgb3V0cHV0Lg0KKwkJ
ICoNCisJCSAqIFNpbmNlIHdlIGhhdmUgYSAwIHJlZmNvdW50LCBwZXJmX21tYXBfY2xvc2UoKSB3
aWxsIHNraXANCisJCSAqIG92ZXIgdXM7IHBvc3NpYmx5IG1ha2luZyBvdXIgcmluZ19idWZmZXJf
cHV0KCkgdGhlIGxhc3QuDQorCQkgKi8NCisJCW11dGV4X2xvY2soJmV2ZW50LT5tbWFwX211dGV4
KTsNCisJCXJiID0gZXZlbnQtPnJiOw0KKwkJaWYgKHJiKSB7DQorCQkJcmN1X2Fzc2lnbl9wb2lu
dGVyKGV2ZW50LT5yYiwgTlVMTCk7DQorCQkJcmluZ19idWZmZXJfZGV0YWNoKGV2ZW50LCByYik7
DQorCQkJcmluZ19idWZmZXJfcHV0KHJiKTsgLyogY291bGQgYmUgbGFzdCAqLw0KKwkJfQ0KKwkJ
bXV0ZXhfdW5sb2NrKCZldmVudC0+bW1hcF9tdXRleCk7DQogCX0NCiANCiAJaWYgKGlzX2Nncm91
cF9ldmVudChldmVudCkpDQpAQCAtMzIwMSwzMCArMzIzNSwxMyBAQCBzdGF0aWMgdW5zaWduZWQg
aW50IHBlcmZfcG9sbChzdHJ1Y3QgZmlsZSAqZmlsZSwgcG9sbF90YWJsZSAqd2FpdCkNCiAJdW5z
aWduZWQgaW50IGV2ZW50cyA9IFBPTExfSFVQOw0KIA0KIAkvKg0KLQkgKiBSYWNlIGJldHdlZW4g
cGVyZl9ldmVudF9zZXRfb3V0cHV0KCkgYW5kIHBlcmZfcG9sbCgpOiBwZXJmX3BvbGwoKQ0KLQkg
KiBncmFicyB0aGUgcmIgcmVmZXJlbmNlIGJ1dCBwZXJmX2V2ZW50X3NldF9vdXRwdXQoKSBvdmVy
cmlkZXMgaXQuDQotCSAqIEhlcmUgaXMgdGhlIHRpbWVsaW5lIGZvciB0d28gdGhyZWFkcyBUMSwg
VDI6DQotCSAqIHQwOiBUMSwgcmIgPSByY3VfZGVyZWZlcmVuY2UoZXZlbnQtPnJiKQ0KLQkgKiB0
MTogVDIsIG9sZF9yYiA9IGV2ZW50LT5yYg0KLQkgKiB0MjogVDIsIGV2ZW50LT5yYiA9IG5ldyBy
Yg0KLQkgKiB0MzogVDIsIHJpbmdfYnVmZmVyX2RldGFjaChvbGRfcmIpDQotCSAqIHQ0OiBUMSwg
cmluZ19idWZmZXJfYXR0YWNoKHJiMSkNCi0JICogdDU6IFQxLCBwb2xsX3dhaXQoZXZlbnQtPndh
aXRxKQ0KLQkgKg0KLQkgKiBUbyBhdm9pZCB0aGlzIHByb2JsZW0sIHdlIGdyYWIgbW1hcF9tdXRl
eCBpbiBwZXJmX3BvbGwoKQ0KLQkgKiB0aGVyZWJ5IGVuc3VyaW5nIHRoYXQgdGhlIGFzc2lnbm1l
bnQgb2YgdGhlIG5ldyByaW5nIGJ1ZmZlcg0KLQkgKiBhbmQgdGhlIGRldGFjaG1lbnQgb2YgdGhl
IG9sZCBidWZmZXIgYXBwZWFyIGF0b21pYyB0byBwZXJmX3BvbGwoKQ0KKwkgKiBQaW4gdGhlIGV2
ZW50LT5yYiBieSB0YWtpbmcgZXZlbnQtPm1tYXBfbXV0ZXg7IG90aGVyd2lzZQ0KKwkgKiBwZXJm
X2V2ZW50X3NldF9vdXRwdXQoKSBjYW4gc3dpenpsZSBvdXIgcmIgYW5kIG1ha2UgdXMgbWlzcyB3
YWtldXBzLg0KIAkgKi8NCiAJbXV0ZXhfbG9jaygmZXZlbnQtPm1tYXBfbXV0ZXgpOw0KLQ0KLQly
Y3VfcmVhZF9sb2NrKCk7DQotCXJiID0gcmN1X2RlcmVmZXJlbmNlKGV2ZW50LT5yYik7DQotCWlm
IChyYikgew0KLQkJcmluZ19idWZmZXJfYXR0YWNoKGV2ZW50LCByYik7DQorCXJiID0gZXZlbnQt
PnJiOw0KKwlpZiAocmIpDQogCQlldmVudHMgPSBhdG9taWNfeGNoZygmcmItPnBvbGwsIDApOw0K
LQl9DQotCXJjdV9yZWFkX3VubG9jaygpOw0KLQ0KIAltdXRleF91bmxvY2soJmV2ZW50LT5tbWFw
X211dGV4KTsNCiANCiAJcG9sbF93YWl0KGZpbGUsICZldmVudC0+d2FpdHEsIHdhaXQpOw0KQEAg
LTM1MzgsMTYgKzM1NTUsMTIgQEAgc3RhdGljIHZvaWQgcmluZ19idWZmZXJfYXR0YWNoKHN0cnVj
dCBwZXJmX2V2ZW50ICpldmVudCwNCiAJCXJldHVybjsNCiANCiAJc3Bpbl9sb2NrX2lycXNhdmUo
JnJiLT5ldmVudF9sb2NrLCBmbGFncyk7DQotCWlmICghbGlzdF9lbXB0eSgmZXZlbnQtPnJiX2Vu
dHJ5KSkNCi0JCWdvdG8gdW5sb2NrOw0KLQ0KLQlsaXN0X2FkZCgmZXZlbnQtPnJiX2VudHJ5LCAm
cmItPmV2ZW50X2xpc3QpOw0KLXVubG9jazoNCisJaWYgKGxpc3RfZW1wdHkoJmV2ZW50LT5yYl9l
bnRyeSkpDQorCQlsaXN0X2FkZCgmZXZlbnQtPnJiX2VudHJ5LCAmcmItPmV2ZW50X2xpc3QpOw0K
IAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZyYi0+ZXZlbnRfbG9jaywgZmxhZ3MpOw0KIH0NCiAN
Ci1zdGF0aWMgdm9pZCByaW5nX2J1ZmZlcl9kZXRhY2goc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50
LA0KLQkJCSAgICAgICBzdHJ1Y3QgcmluZ19idWZmZXIgKnJiKQ0KK3N0YXRpYyB2b2lkIHJpbmdf
YnVmZmVyX2RldGFjaChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQsIHN0cnVjdCByaW5nX2J1ZmZl
ciAqcmIpDQogew0KIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIA0KQEAgLTM1NjYsMTMgKzM1Nzks
MTAgQEAgc3RhdGljIHZvaWQgcmluZ19idWZmZXJfd2FrZXVwKHN0cnVjdCBwZXJmX2V2ZW50ICpl
dmVudCkNCiANCiAJcmN1X3JlYWRfbG9jaygpOw0KIAlyYiA9IHJjdV9kZXJlZmVyZW5jZShldmVu
dC0+cmIpOw0KLQlpZiAoIXJiKQ0KLQkJZ290byB1bmxvY2s7DQotDQotCWxpc3RfZm9yX2VhY2hf
ZW50cnlfcmN1KGV2ZW50LCAmcmItPmV2ZW50X2xpc3QsIHJiX2VudHJ5KQ0KLQkJd2FrZV91cF9h
bGwoJmV2ZW50LT53YWl0cSk7DQotDQotdW5sb2NrOg0KKwlpZiAocmIpIHsNCisJCWxpc3RfZm9y
X2VhY2hfZW50cnlfcmN1KGV2ZW50LCAmcmItPmV2ZW50X2xpc3QsIHJiX2VudHJ5KQ0KKwkJCXdh
a2VfdXBfYWxsKCZldmVudC0+d2FpdHEpOw0KKwl9DQogCXJjdV9yZWFkX3VubG9jaygpOw0KIH0N
CiANCkBAIC0zNjAxLDE4ICszNjExLDEwIEBAIHN0YXRpYyBzdHJ1Y3QgcmluZ19idWZmZXIgKnJp
bmdfYnVmZmVyX2dldChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQpDQogDQogc3RhdGljIHZvaWQg
cmluZ19idWZmZXJfcHV0KHN0cnVjdCByaW5nX2J1ZmZlciAqcmIpDQogew0KLQlzdHJ1Y3QgcGVy
Zl9ldmVudCAqZXZlbnQsICpuOw0KLQl1bnNpZ25lZCBsb25nIGZsYWdzOw0KLQ0KIAlpZiAoIWF0
b21pY19kZWNfYW5kX3Rlc3QoJnJiLT5yZWZjb3VudCkpDQogCQlyZXR1cm47DQogDQotCXNwaW5f
bG9ja19pcnFzYXZlKCZyYi0+ZXZlbnRfbG9jaywgZmxhZ3MpOw0KLQlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5X3NhZmUoZXZlbnQsIG4sICZyYi0+ZXZlbnRfbGlzdCwgcmJfZW50cnkpIHsNCi0JCWxpc3Rf
ZGVsX2luaXQoJmV2ZW50LT5yYl9lbnRyeSk7DQotCQl3YWtlX3VwX2FsbCgmZXZlbnQtPndhaXRx
KTsNCi0JfQ0KLQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZyYi0+ZXZlbnRfbG9jaywgZmxhZ3Mp
Ow0KKwlXQVJOX09OX09OQ0UoIWxpc3RfZW1wdHkoJnJiLT5ldmVudF9saXN0KSk7DQogDQogCWNh
bGxfcmN1KCZyYi0+cmN1X2hlYWQsIHJiX2ZyZWVfcmN1KTsNCiB9DQpAQCAtMzYyMiwyNiArMzYy
NCwxMDAgQEAgc3RhdGljIHZvaWQgcGVyZl9tbWFwX29wZW4oc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEpDQogCXN0cnVjdCBwZXJmX2V2ZW50ICpldmVudCA9IHZtYS0+dm1fZmlsZS0+cHJpdmF0
ZV9kYXRhOw0KIA0KIAlhdG9taWNfaW5jKCZldmVudC0+bW1hcF9jb3VudCk7DQorCWF0b21pY19p
bmMoJmV2ZW50LT5yYi0+bW1hcF9jb3VudCk7DQogfQ0KIA0KKy8qDQorICogQSBidWZmZXIgY2Fu
IGJlIG1tYXAoKWVkIG11bHRpcGxlIHRpbWVzOyBlaXRoZXIgZGlyZWN0bHkgdGhyb3VnaCB0aGUg
c2FtZQ0KKyAqIGV2ZW50LCBvciB0aHJvdWdoIG90aGVyIGV2ZW50cyBieSB1c2Ugb2YgcGVyZl9l
dmVudF9zZXRfb3V0cHV0KCkuDQorICoNCisgKiBJbiBvcmRlciB0byB1bmRvIHRoZSBWTSBhY2Nv
dW50aW5nIGRvbmUgYnkgcGVyZl9tbWFwKCkgd2UgbmVlZCB0byBkZXN0cm95DQorICogdGhlIGJ1
ZmZlciBoZXJlLCB3aGVyZSB3ZSBzdGlsbCBoYXZlIGEgVk0gY29udGV4dC4gVGhpcyBtZWFucyB3
ZSBuZWVkDQorICogdG8gZGV0YWNoIGFsbCBldmVudHMgcmVkaXJlY3RpbmcgdG8gdXMuDQorICov
DQogc3RhdGljIHZvaWQgcGVyZl9tbWFwX2Nsb3NlKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1h
KQ0KIHsNCiAJc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50ID0gdm1hLT52bV9maWxlLT5wcml2YXRl
X2RhdGE7DQogDQotCWlmIChhdG9taWNfZGVjX2FuZF9tdXRleF9sb2NrKCZldmVudC0+bW1hcF9j
b3VudCwgJmV2ZW50LT5tbWFwX211dGV4KSkgew0KLQkJdW5zaWduZWQgbG9uZyBzaXplID0gcGVy
Zl9kYXRhX3NpemUoZXZlbnQtPnJiKTsNCi0JCXN0cnVjdCB1c2VyX3N0cnVjdCAqdXNlciA9IGV2
ZW50LT5tbWFwX3VzZXI7DQotCQlzdHJ1Y3QgcmluZ19idWZmZXIgKnJiID0gZXZlbnQtPnJiOw0K
KwlzdHJ1Y3QgcmluZ19idWZmZXIgKnJiID0gZXZlbnQtPnJiOw0KKwlzdHJ1Y3QgdXNlcl9zdHJ1
Y3QgKm1tYXBfdXNlciA9IHJiLT5tbWFwX3VzZXI7DQorCWludCBtbWFwX2xvY2tlZCA9IHJiLT5t
bWFwX2xvY2tlZDsNCisJdW5zaWduZWQgbG9uZyBzaXplID0gcGVyZl9kYXRhX3NpemUocmIpOw0K
Kw0KKwlhdG9taWNfZGVjKCZyYi0+bW1hcF9jb3VudCk7DQorDQorCWlmICghYXRvbWljX2RlY19h
bmRfbXV0ZXhfbG9jaygmZXZlbnQtPm1tYXBfY291bnQsICZldmVudC0+bW1hcF9tdXRleCkpDQor
CQlyZXR1cm47DQorDQorCS8qIERldGFjaCBjdXJyZW50IGV2ZW50IGZyb20gdGhlIGJ1ZmZlci4g
Ki8NCisJcmN1X2Fzc2lnbl9wb2ludGVyKGV2ZW50LT5yYiwgTlVMTCk7DQorCXJpbmdfYnVmZmVy
X2RldGFjaChldmVudCwgcmIpOw0KKwltdXRleF91bmxvY2soJmV2ZW50LT5tbWFwX211dGV4KTsN
CisNCisJLyogSWYgdGhlcmUncyBzdGlsbCBvdGhlciBtbWFwKClzIG9mIHRoaXMgYnVmZmVyLCB3
ZSdyZSBkb25lLiAqLw0KKwlpZiAoYXRvbWljX3JlYWQoJnJiLT5tbWFwX2NvdW50KSkgew0KKwkJ
cmluZ19idWZmZXJfcHV0KHJiKTsgLyogY2FuJ3QgYmUgbGFzdCAqLw0KKwkJcmV0dXJuOw0KKwl9
DQorDQorCS8qDQorCSAqIE5vIG90aGVyIG1tYXAoKXMsIGRldGFjaCBmcm9tIGFsbCBvdGhlciBl
dmVudHMgdGhhdCBtaWdodCByZWRpcmVjdA0KKwkgKiBpbnRvIHRoZSBub3cgdW5yZWFjaGFibGUg
YnVmZmVyLiBTb21ld2hhdCBjb21wbGljYXRlZCBieSB0aGUNCisJICogZmFjdCB0aGF0IHJiOjpl
dmVudF9sb2NrIG90aGVyd2lzZSBuZXN0cyBpbnNpZGUgbW1hcF9tdXRleC4NCisJICovDQorYWdh
aW46DQorCXJjdV9yZWFkX2xvY2soKTsNCisJbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoZXZlbnQs
ICZyYi0+ZXZlbnRfbGlzdCwgcmJfZW50cnkpIHsNCisJCWlmICghYXRvbWljX2xvbmdfaW5jX25v
dF96ZXJvKCZldmVudC0+cmVmY291bnQpKSB7DQorCQkJLyoNCisJCQkgKiBUaGlzIGV2ZW50IGlz
IGVuLXJvdXRlIHRvIGZyZWVfZXZlbnQoKSB3aGljaCB3aWxsDQorCQkJICogZGV0YWNoIGl0IGFu
ZCByZW1vdmUgaXQgZnJvbSB0aGUgbGlzdC4NCisJCQkgKi8NCisJCQljb250aW51ZTsNCisJCX0N
CisJCXJjdV9yZWFkX3VubG9jaygpOw0KIA0KLQkJYXRvbWljX2xvbmdfc3ViKChzaXplID4+IFBB
R0VfU0hJRlQpICsgMSwgJnVzZXItPmxvY2tlZF92bSk7DQotCQl2bWEtPnZtX21tLT5waW5uZWRf
dm0gLT0gZXZlbnQtPm1tYXBfbG9ja2VkOw0KLQkJcmN1X2Fzc2lnbl9wb2ludGVyKGV2ZW50LT5y
YiwgTlVMTCk7DQotCQlyaW5nX2J1ZmZlcl9kZXRhY2goZXZlbnQsIHJiKTsNCisJCW11dGV4X2xv
Y2soJmV2ZW50LT5tbWFwX211dGV4KTsNCisJCS8qDQorCQkgKiBDaGVjayB3ZSBkaWRuJ3QgcmFj
ZSB3aXRoIHBlcmZfZXZlbnRfc2V0X291dHB1dCgpIHdoaWNoIGNhbg0KKwkJICogc3dpenpsZSB0
aGUgcmIgZnJvbSB1bmRlciB1cyB3aGlsZSB3ZSB3ZXJlIHdhaXRpbmcgdG8NCisJCSAqIGFjcXVp
cmUgbW1hcF9tdXRleC4NCisJCSAqDQorCQkgKiBJZiB3ZSBmaW5kIGEgZGlmZmVyZW50IHJiOyBp
Z25vcmUgdGhpcyBldmVudCwgYSBuZXh0DQorCQkgKiBpdGVyYXRpb24gd2lsbCBubyBsb25nZXIg
ZmluZCBpdCBvbiB0aGUgbGlzdC4gV2UgaGF2ZSB0bw0KKwkJICogc3RpbGwgcmVzdGFydCB0aGUg
aXRlcmF0aW9uIHRvIG1ha2Ugc3VyZSB3ZSdyZSBub3Qgbm93DQorCQkgKiBpdGVyYXRpbmcgdGhl
IHdyb25nIGxpc3QuDQorCQkgKi8NCisJCWlmIChldmVudC0+cmIgPT0gcmIpIHsNCisJCQlyY3Vf
YXNzaWduX3BvaW50ZXIoZXZlbnQtPnJiLCBOVUxMKTsNCisJCQlyaW5nX2J1ZmZlcl9kZXRhY2go
ZXZlbnQsIHJiKTsNCisJCQlyaW5nX2J1ZmZlcl9wdXQocmIpOyAvKiBjYW4ndCBiZSBsYXN0LCB3
ZSBzdGlsbCBoYXZlIG9uZSAqLw0KKwkJfQ0KIAkJbXV0ZXhfdW5sb2NrKCZldmVudC0+bW1hcF9t
dXRleCk7DQorCQlwdXRfZXZlbnQoZXZlbnQpOw0KIA0KLQkJcmluZ19idWZmZXJfcHV0KHJiKTsN
Ci0JCWZyZWVfdWlkKHVzZXIpOw0KKwkJLyoNCisJCSAqIFJlc3RhcnQgdGhlIGl0ZXJhdGlvbjsg
ZWl0aGVyIHdlJ3JlIG9uIHRoZSB3cm9uZyBsaXN0IG9yDQorCQkgKiBkZXN0cm95ZWQgaXRzIGlu
dGVncml0eSBieSBkb2luZyBhIGRlbGV0aW9uLg0KKwkJICovDQorCQlnb3RvIGFnYWluOw0KIAl9
DQorCXJjdV9yZWFkX3VubG9jaygpOw0KKw0KKwkvKg0KKwkgKiBJdCBjb3VsZCBiZSB0aGVyZSdz
IHN0aWxsIGEgZmV3IDAtcmVmIGV2ZW50cyBvbiB0aGUgbGlzdDsgdGhleSdsbA0KKwkgKiBnZXQg
Y2xlYW5lZCB1cCBieSBmcmVlX2V2ZW50KCkgLS0gdGhleSdsbCBhbHNvIHN0aWxsIGhhdmUgdGhl
aXINCisJICogcmVmIG9uIHRoZSByYiBhbmQgd2lsbCBmcmVlIGl0IHdoZW5ldmVyIHRoZXkgYXJl
IGRvbmUgd2l0aCBpdC4NCisJICoNCisJICogQXNpZGUgZnJvbSB0aGF0LCB0aGlzIGJ1ZmZlciBp
cyAnZnVsbHknIGRldGFjaGVkIGFuZCB1bm1hcHBlZCwNCisJICogdW5kbyB0aGUgVk0gYWNjb3Vu
dGluZy4NCisJICovDQorDQorCWF0b21pY19sb25nX3N1Yigoc2l6ZSA+PiBQQUdFX1NISUZUKSAr
IDEsICZtbWFwX3VzZXItPmxvY2tlZF92bSk7DQorCXZtYS0+dm1fbW0tPnBpbm5lZF92bSAtPSBt
bWFwX2xvY2tlZDsNCisJZnJlZV91aWQobW1hcF91c2VyKTsNCisNCisJcmluZ19idWZmZXJfcHV0
KHJiKTsgLyogY291bGQgYmUgbGFzdCAqLw0KIH0NCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHZt
X29wZXJhdGlvbnNfc3RydWN0IHBlcmZfbW1hcF92bW9wcyA9IHsNCkBAIC0zNjkxLDEyICszNzY3
LDI0IEBAIHN0YXRpYyBpbnQgcGVyZl9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKnZtYSkNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KIAlXQVJOX09OX09OQ0Uo
ZXZlbnQtPmN0eC0+cGFyZW50X2N0eCk7DQorYWdhaW46DQogCW11dGV4X2xvY2soJmV2ZW50LT5t
bWFwX211dGV4KTsNCiAJaWYgKGV2ZW50LT5yYikgew0KLQkJaWYgKGV2ZW50LT5yYi0+bnJfcGFn
ZXMgPT0gbnJfcGFnZXMpDQotCQkJYXRvbWljX2luYygmZXZlbnQtPnJiLT5yZWZjb3VudCk7DQot
CQllbHNlDQorCQlpZiAoZXZlbnQtPnJiLT5ucl9wYWdlcyAhPSBucl9wYWdlcykgew0KIAkJCXJl
dCA9IC1FSU5WQUw7DQorCQkJZ290byB1bmxvY2s7DQorCQl9DQorDQorCQlpZiAoIWF0b21pY19p
bmNfbm90X3plcm8oJmV2ZW50LT5yYi0+bW1hcF9jb3VudCkpIHsNCisJCQkvKg0KKwkJCSAqIFJh
Y2VkIGFnYWluc3QgcGVyZl9tbWFwX2Nsb3NlKCkgdGhyb3VnaA0KKwkJCSAqIHBlcmZfZXZlbnRf
c2V0X291dHB1dCgpLiBUcnkgYWdhaW4sIGhvcGUgZm9yIGJldHRlcg0KKwkJCSAqIGx1Y2suDQor
CQkJICovDQorCQkJbXV0ZXhfdW5sb2NrKCZldmVudC0+bW1hcF9tdXRleCk7DQorCQkJZ290byBh
Z2FpbjsNCisJCX0NCisNCiAJCWdvdG8gdW5sb2NrOw0KIAl9DQogDQpAQCAtMzczNywxOSArMzgy
NSwyNyBAQCBzdGF0aWMgaW50IHBlcmZfbW1hcChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHZt
X2FyZWFfc3RydWN0ICp2bWEpDQogCQlyZXQgPSAtRU5PTUVNOw0KIAkJZ290byB1bmxvY2s7DQog
CX0NCi0JcmN1X2Fzc2lnbl9wb2ludGVyKGV2ZW50LT5yYiwgcmIpOw0KKw0KKwlhdG9taWNfc2V0
KCZyYi0+bW1hcF9jb3VudCwgMSk7DQorCXJiLT5tbWFwX2xvY2tlZCA9IGV4dHJhOw0KKwlyYi0+
bW1hcF91c2VyID0gZ2V0X2N1cnJlbnRfdXNlcigpOw0KIA0KIAlhdG9taWNfbG9uZ19hZGQodXNl
cl9leHRyYSwgJnVzZXItPmxvY2tlZF92bSk7DQotCWV2ZW50LT5tbWFwX2xvY2tlZCA9IGV4dHJh
Ow0KLQlldmVudC0+bW1hcF91c2VyID0gZ2V0X2N1cnJlbnRfdXNlcigpOw0KLQl2bWEtPnZtX21t
LT5waW5uZWRfdm0gKz0gZXZlbnQtPm1tYXBfbG9ja2VkOw0KKwl2bWEtPnZtX21tLT5waW5uZWRf
dm0gKz0gZXh0cmE7DQorDQorCXJpbmdfYnVmZmVyX2F0dGFjaChldmVudCwgcmIpOw0KKwlyY3Vf
YXNzaWduX3BvaW50ZXIoZXZlbnQtPnJiLCByYik7DQogDQogdW5sb2NrOg0KIAlpZiAoIXJldCkN
CiAJCWF0b21pY19pbmMoJmV2ZW50LT5tbWFwX2NvdW50KTsNCiAJbXV0ZXhfdW5sb2NrKCZldmVu
dC0+bW1hcF9tdXRleCk7DQogDQotCXZtYS0+dm1fZmxhZ3MgfD0gVk1fUkVTRVJWRUQ7DQorCS8q
DQorCSAqIFNpbmNlIHBpbm5lZCBhY2NvdW50aW5nIGlzIHBlciB2bSB3ZSBjYW5ub3QgYWxsb3cg
Zm9yaygpIHRvIGNvcHkgb3VyDQorCSAqIHZtYS4NCisJICovDQorCXZtYS0+dm1fZmxhZ3MgfD0g
Vk1fRE9OVENPUFkgfCBWTV9SRVNFUlZFRDsNCiAJdm1hLT52bV9vcHMgPSAmcGVyZl9tbWFwX3Zt
b3BzOw0KIA0KIAlyZXR1cm4gcmV0Ow0KQEAgLTYxMTQsNiArNjIxMCw4IEBAIHNldDoNCiAJaWYg
KGF0b21pY19yZWFkKCZldmVudC0+bW1hcF9jb3VudCkpDQogCQlnb3RvIHVubG9jazsNCiANCisJ
b2xkX3JiID0gZXZlbnQtPnJiOw0KKw0KIAlpZiAob3V0cHV0X2V2ZW50KSB7DQogCQkvKiBnZXQg
dGhlIHJiIHdlIHdhbnQgdG8gcmVkaXJlY3QgdG8gKi8NCiAJCXJiID0gcmluZ19idWZmZXJfZ2V0
KG91dHB1dF9ldmVudCk7DQpAQCAtNjEyMSwxNiArNjIxOSwyOCBAQCBzZXQ6DQogCQkJZ290byB1
bmxvY2s7DQogCX0NCiANCi0Jb2xkX3JiID0gZXZlbnQtPnJiOw0KLQlyY3VfYXNzaWduX3BvaW50
ZXIoZXZlbnQtPnJiLCByYik7DQogCWlmIChvbGRfcmIpDQogCQlyaW5nX2J1ZmZlcl9kZXRhY2go
ZXZlbnQsIG9sZF9yYik7DQorDQorCWlmIChyYikNCisJCXJpbmdfYnVmZmVyX2F0dGFjaChldmVu
dCwgcmIpOw0KKw0KKwlyY3VfYXNzaWduX3BvaW50ZXIoZXZlbnQtPnJiLCByYik7DQorDQorCWlm
IChvbGRfcmIpIHsNCisJCXJpbmdfYnVmZmVyX3B1dChvbGRfcmIpOw0KKwkJLyoNCisJCSAqIFNp
bmNlIHdlIGRldGFjaGVkIGJlZm9yZSBzZXR0aW5nIHRoZSBuZXcgcmIsIHNvIHRoYXQgd2UNCisJ
CSAqIGNvdWxkIGF0dGFjaCB0aGUgbmV3IHJiLCB3ZSBjb3VsZCBoYXZlIG1pc3NlZCBhIHdha2V1
cC4NCisJCSAqIFByb3ZpZGUgaXQgbm93Lg0KKwkJICovDQorCQl3YWtlX3VwX2FsbCgmZXZlbnQt
PndhaXRxKTsNCisJfQ0KKw0KIAlyZXQgPSAwOw0KIHVubG9jazoNCiAJbXV0ZXhfdW5sb2NrKCZl
dmVudC0+bW1hcF9tdXRleCk7DQogDQotCWlmIChvbGRfcmIpDQotCQlyaW5nX2J1ZmZlcl9wdXQo
b2xkX3JiKTsNCiBvdXQ6DQogCXJldHVybiByZXQ7DQogfQ0KQEAgLTY3OTcsNyArNjkwNyw3IEBA
IGluaGVyaXRfdGFza19ncm91cChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQsIHN0cnVjdCB0YXNr
X3N0cnVjdCAqcGFyZW50LA0KIAkJICogY2hpbGQuDQogCQkgKi8NCiANCi0JCWNoaWxkX2N0eCA9
IGFsbG9jX3BlcmZfY29udGV4dChldmVudC0+cG11LCBjaGlsZCk7DQorCQljaGlsZF9jdHggPSBh
bGxvY19wZXJmX2NvbnRleHQocGFyZW50X2N0eC0+cG11LCBjaGlsZCk7DQogCQlpZiAoIWNoaWxk
X2N0eCkNCiAJCQlyZXR1cm4gLUVOT01FTTsNCiANCmRpZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRz
L2h3X2JyZWFrcG9pbnQuYyBiL2tlcm5lbC9ldmVudHMvaHdfYnJlYWtwb2ludC5jDQppbmRleCBi
Nzk3MWQ2Li45OGFjMjRlIDEwMDY0NA0KLS0tIGEva2VybmVsL2V2ZW50cy9od19icmVha3BvaW50
LmMNCisrKyBiL2tlcm5lbC9ldmVudHMvaHdfYnJlYWtwb2ludC5jDQpAQCAtMTQ3LDcgKzE0Nyw3
IEBAIGZldGNoX2JwX2J1c3lfc2xvdHMoc3RydWN0IGJwX2J1c3lfc2xvdHMgKnNsb3RzLCBzdHJ1
Y3QgcGVyZl9ldmVudCAqYnAsDQogCQlyZXR1cm47DQogCX0NCiANCi0JZm9yX2VhY2hfb25saW5l
X2NwdShjcHUpIHsNCisJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgew0KIAkJdW5zaWduZWQg
aW50IG5yOw0KIA0KIAkJbnIgPSBwZXJfY3B1KG5yX2NwdV9icF9waW5uZWRbdHlwZV0sIGNwdSk7
DQpAQCAtMjMzLDcgKzIzMyw3IEBAIHRvZ2dsZV9icF9zbG90KHN0cnVjdCBwZXJmX2V2ZW50ICpi
cCwgYm9vbCBlbmFibGUsIGVudW0gYnBfdHlwZV9pZHggdHlwZSwNCiAJaWYgKGNwdSA+PSAwKSB7
DQogCQl0b2dnbGVfYnBfdGFza19zbG90KGJwLCBjcHUsIGVuYWJsZSwgdHlwZSwgd2VpZ2h0KTsN
CiAJfSBlbHNlIHsNCi0JCWZvcl9lYWNoX29ubGluZV9jcHUoY3B1KQ0KKwkJZm9yX2VhY2hfcG9z
c2libGVfY3B1KGNwdSkNCiAJCQl0b2dnbGVfYnBfdGFza19zbG90KGJwLCBjcHUsIGVuYWJsZSwg
dHlwZSwgd2VpZ2h0KTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVudHMvaW50ZXJu
YWwuaCBiL2tlcm5lbC9ldmVudHMvaW50ZXJuYWwuaA0KaW5kZXggNjQ1NjhhNi4uYTIxMDFiYiAx
MDA2NDQNCi0tLSBhL2tlcm5lbC9ldmVudHMvaW50ZXJuYWwuaA0KKysrIGIva2VybmVsL2V2ZW50
cy9pbnRlcm5hbC5oDQpAQCAtMjYsNiArMjYsMTAgQEAgc3RydWN0IHJpbmdfYnVmZmVyIHsNCiAJ
c3BpbmxvY2tfdAkJCWV2ZW50X2xvY2s7DQogCXN0cnVjdCBsaXN0X2hlYWQJCWV2ZW50X2xpc3Q7
DQogDQorCWF0b21pY190CQkJbW1hcF9jb3VudDsNCisJdW5zaWduZWQgbG9uZwkJCW1tYXBfbG9j
a2VkOw0KKwlzdHJ1Y3QgdXNlcl9zdHJ1Y3QJCSptbWFwX3VzZXI7DQorDQogCXN0cnVjdCBwZXJm
X2V2ZW50X21tYXBfcGFnZQkqdXNlcl9wYWdlOw0KIAl2b2lkCQkJCSpkYXRhX3BhZ2VzWzBdOw0K
IH07DQpkaWZmIC0tZ2l0IGEva2VybmVsL2Z1dGV4LmMgYi9rZXJuZWwvZnV0ZXguYw0KaW5kZXgg
NzdiY2NmYy4uMWQwNTM4ZSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9mdXRleC5jDQorKysgYi9rZXJu
ZWwvZnV0ZXguYw0KQEAgLTYwLDYgKzYwLDcgQEANCiAjaW5jbHVkZSA8bGludXgvcGlkLmg+DQog
I2luY2x1ZGUgPGxpbnV4L25zcHJveHkuaD4NCiAjaW5jbHVkZSA8bGludXgvcHRyYWNlLmg+DQor
I2luY2x1ZGUgPGxpbnV4L2h1Z2V0bGIuaD4NCiANCiAjaW5jbHVkZSA8YXNtL2Z1dGV4Lmg+DQog
DQpAQCAtMzYzLDcgKzM2NCw3IEBAIGFnYWluOg0KIAl9IGVsc2Ugew0KIAkJa2V5LT5ib3RoLm9m
ZnNldCB8PSBGVVRfT0ZGX0lOT0RFOyAvKiBpbm9kZS1iYXNlZCBrZXkgKi8NCiAJCWtleS0+c2hh
cmVkLmlub2RlID0gcGFnZV9oZWFkLT5tYXBwaW5nLT5ob3N0Ow0KLQkJa2V5LT5zaGFyZWQucGdv
ZmYgPSBwYWdlX2hlYWQtPmluZGV4Ow0KKwkJa2V5LT5zaGFyZWQucGdvZmYgPSBiYXNlcGFnZV9p
bmRleChwYWdlKTsNCiAJfQ0KIA0KIAlnZXRfZnV0ZXhfa2V5X3JlZnMoa2V5KTsNCmRpZmYgLS1n
aXQgYS9rZXJuZWwvaXJxL21hbmFnZS5jIGIva2VybmVsL2lycS9tYW5hZ2UuYw0KaW5kZXggMzgy
YTZiZC4uNTJiZGQ1OCAxMDA2NDQNCi0tLSBhL2tlcm5lbC9pcnEvbWFuYWdlLmMNCisrKyBiL2tl
cm5lbC9pcnEvbWFuYWdlLmMNCkBAIC01MzksOSArNTM5LDkgQEAgaW50IGNhbl9yZXF1ZXN0X2ly
cSh1bnNpZ25lZCBpbnQgaXJxLCB1bnNpZ25lZCBsb25nIGlycWZsYWdzKQ0KIAkJcmV0dXJuIDA7
DQogDQogCWlmIChpcnFfc2V0dGluZ3NfY2FuX3JlcXVlc3QoZGVzYykpIHsNCi0JCWlmIChkZXNj
LT5hY3Rpb24pDQotCQkJaWYgKGlycWZsYWdzICYgZGVzYy0+YWN0aW9uLT5mbGFncyAmIElSUUZf
U0hBUkVEKQ0KLQkJCQljYW5yZXF1ZXN0ID0xOw0KKwkJaWYgKCFkZXNjLT5hY3Rpb24gfHwNCisJ
CSAgICBpcnFmbGFncyAmIGRlc2MtPmFjdGlvbi0+ZmxhZ3MgJiBJUlFGX1NIQVJFRCkNCisJCQlj
YW5yZXF1ZXN0ID0gMTsNCiAJfQ0KIAlpcnFfcHV0X2Rlc2NfdW5sb2NrKGRlc2MsIGZsYWdzKTsN
CiAJcmV0dXJuIGNhbnJlcXVlc3Q7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3ByaW50ay5jIGIva2Vy
bmVsL3ByaW50ay5jDQppbmRleCBjMGQxMmVhLi4xNjY4OGVjIDEwMDY0NA0KLS0tIGEva2VybmVs
L3ByaW50ay5jDQorKysgYi9rZXJuZWwvcHJpbnRrLmMNCkBAIC04MTMsOSArODEzLDkgQEAgc3Rh
dGljIGludCBjb25zb2xlX3RyeWxvY2tfZm9yX3ByaW50ayh1bnNpZ25lZCBpbnQgY3B1KQ0KIAkJ
fQ0KIAl9DQogCXByaW50a19jcHUgPSBVSU5UX01BWDsNCisJcmF3X3NwaW5fdW5sb2NrKCZsb2di
dWZfbG9jayk7DQogCWlmICh3YWtlKQ0KIAkJdXAoJmNvbnNvbGVfc2VtKTsNCi0JcmF3X3NwaW5f
dW5sb2NrKCZsb2didWZfbG9jayk7DQogCXJldHVybiByZXR2YWw7DQogfQ0KIHN0YXRpYyBjb25z
dCBjaGFyIHJlY3Vyc2lvbl9idWdfbXNnIFtdID0NCmRpZmYgLS1naXQgYS9rZXJuZWwvdGltZXIu
YyBiL2tlcm5lbC90aW1lci5jDQppbmRleCBmMmY3MWQ3Li5mOGIwNWE0IDEwMDY0NA0KLS0tIGEv
a2VybmVsL3RpbWVyLmMNCisrKyBiL2tlcm5lbC90aW1lci5jDQpAQCAtMTQ1LDkgKzE0NSwxMSBA
QCBzdGF0aWMgdW5zaWduZWQgbG9uZyByb3VuZF9qaWZmaWVzX2NvbW1vbih1bnNpZ25lZCBsb25n
IGosIGludCBjcHUsDQogCS8qIG5vdyB0aGF0IHdlIGhhdmUgcm91bmRlZCwgc3VidHJhY3QgdGhl
IGV4dHJhIHNrZXcgYWdhaW4gKi8NCiAJaiAtPSBjcHUgKiAzOw0KIA0KLQlpZiAoaiA8PSBqaWZm
aWVzKSAvKiByb3VuZGluZyBhdGUgb3VyIHRpbWVvdXQgZW50aXJlbHk7ICovDQotCQlyZXR1cm4g
b3JpZ2luYWw7DQotCXJldHVybiBqOw0KKwkvKg0KKwkgKiBNYWtlIHN1cmUgaiBpcyBzdGlsbCBp
biB0aGUgZnV0dXJlLiBPdGhlcndpc2UgcmV0dXJuIHRoZQ0KKwkgKiB1bm1vZGlmaWVkIHZhbHVl
Lg0KKwkgKi8NCisJcmV0dXJuIHRpbWVfaXNfYWZ0ZXJfamlmZmllcyhqKSA/IGogOiBvcmlnaW5h
bDsNCiB9DQogDQogLyoqDQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlX3N5c2NhbGxz
LmMgYi9rZXJuZWwvdHJhY2UvdHJhY2Vfc3lzY2FsbHMuYw0KaW5kZXggY2I2NTQ1NC4uN2M3NWJi
YiAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS90cmFjZV9zeXNjYWxscy5jDQorKysgYi9rZXJu
ZWwvdHJhY2UvdHJhY2Vfc3lzY2FsbHMuYw0KQEAgLTMwMyw2ICszMDMsOCBAQCB2b2lkIGZ0cmFj
ZV9zeXNjYWxsX2VudGVyKHZvaWQgKmlnbm9yZSwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIGxvbmcg
aWQpDQogCXN0cnVjdCBzeXNjYWxsX21ldGFkYXRhICpzeXNfZGF0YTsNCiAJc3RydWN0IHJpbmdf
YnVmZmVyX2V2ZW50ICpldmVudDsNCiAJc3RydWN0IHJpbmdfYnVmZmVyICpidWZmZXI7DQorCXVu
c2lnbmVkIGxvbmcgaXJxX2ZsYWdzOw0KKwlpbnQgcGM7DQogCWludCBzaXplOw0KIAlpbnQgc3lz
Y2FsbF9ucjsNCiANCkBAIC0zMTgsOCArMzIwLDExIEBAIHZvaWQgZnRyYWNlX3N5c2NhbGxfZW50
ZXIodm9pZCAqaWdub3JlLCBzdHJ1Y3QgcHRfcmVncyAqcmVncywgbG9uZyBpZCkNCiANCiAJc2l6
ZSA9IHNpemVvZigqZW50cnkpICsgc2l6ZW9mKHVuc2lnbmVkIGxvbmcpICogc3lzX2RhdGEtPm5i
X2FyZ3M7DQogDQorCWxvY2FsX3NhdmVfZmxhZ3MoaXJxX2ZsYWdzKTsNCisJcGMgPSBwcmVlbXB0
X2NvdW50KCk7DQorDQogCWV2ZW50ID0gdHJhY2VfY3VycmVudF9idWZmZXJfbG9ja19yZXNlcnZl
KCZidWZmZXIsDQotCQkJc3lzX2RhdGEtPmVudGVyX2V2ZW50LT5ldmVudC50eXBlLCBzaXplLCAw
LCAwKTsNCisJCQlzeXNfZGF0YS0+ZW50ZXJfZXZlbnQtPmV2ZW50LnR5cGUsIHNpemUsIGlycV9m
bGFncywgcGMpOw0KIAlpZiAoIWV2ZW50KQ0KIAkJcmV0dXJuOw0KIA0KQEAgLTMyOSw3ICszMzQs
OCBAQCB2b2lkIGZ0cmFjZV9zeXNjYWxsX2VudGVyKHZvaWQgKmlnbm9yZSwgc3RydWN0IHB0X3Jl
Z3MgKnJlZ3MsIGxvbmcgaWQpDQogDQogCWlmICghZmlsdGVyX2N1cnJlbnRfY2hlY2tfZGlzY2Fy
ZChidWZmZXIsIHN5c19kYXRhLT5lbnRlcl9ldmVudCwNCiAJCQkJCSAgZW50cnksIGV2ZW50KSkN
Ci0JCXRyYWNlX2N1cnJlbnRfYnVmZmVyX3VubG9ja19jb21taXQoYnVmZmVyLCBldmVudCwgMCwg
MCk7DQorCQl0cmFjZV9jdXJyZW50X2J1ZmZlcl91bmxvY2tfY29tbWl0KGJ1ZmZlciwgZXZlbnQs
DQorCQkJCQkJICAgaXJxX2ZsYWdzLCBwYyk7DQogfQ0KIA0KIHZvaWQgZnRyYWNlX3N5c2NhbGxf
ZXhpdCh2b2lkICppZ25vcmUsIHN0cnVjdCBwdF9yZWdzICpyZWdzLCBsb25nIHJldCkNCkBAIC0z
MzgsNiArMzQ0LDggQEAgdm9pZCBmdHJhY2Vfc3lzY2FsbF9leGl0KHZvaWQgKmlnbm9yZSwgc3Ry
dWN0IHB0X3JlZ3MgKnJlZ3MsIGxvbmcgcmV0KQ0KIAlzdHJ1Y3Qgc3lzY2FsbF9tZXRhZGF0YSAq
c3lzX2RhdGE7DQogCXN0cnVjdCByaW5nX2J1ZmZlcl9ldmVudCAqZXZlbnQ7DQogCXN0cnVjdCBy
aW5nX2J1ZmZlciAqYnVmZmVyOw0KKwl1bnNpZ25lZCBsb25nIGlycV9mbGFnczsNCisJaW50IHBj
Ow0KIAlpbnQgc3lzY2FsbF9ucjsNCiANCiAJc3lzY2FsbF9uciA9IHN5c2NhbGxfZ2V0X25yKGN1
cnJlbnQsIHJlZ3MpOw0KQEAgLTM1MCw4ICszNTgsMTIgQEAgdm9pZCBmdHJhY2Vfc3lzY2FsbF9l
eGl0KHZvaWQgKmlnbm9yZSwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIGxvbmcgcmV0KQ0KIAlpZiAo
IXN5c19kYXRhKQ0KIAkJcmV0dXJuOw0KIA0KKwlsb2NhbF9zYXZlX2ZsYWdzKGlycV9mbGFncyk7
DQorCXBjID0gcHJlZW1wdF9jb3VudCgpOw0KKw0KIAlldmVudCA9IHRyYWNlX2N1cnJlbnRfYnVm
ZmVyX2xvY2tfcmVzZXJ2ZSgmYnVmZmVyLA0KLQkJCXN5c19kYXRhLT5leGl0X2V2ZW50LT5ldmVu
dC50eXBlLCBzaXplb2YoKmVudHJ5KSwgMCwgMCk7DQorCQkJc3lzX2RhdGEtPmV4aXRfZXZlbnQt
PmV2ZW50LnR5cGUsIHNpemVvZigqZW50cnkpLA0KKwkJCWlycV9mbGFncywgcGMpOw0KIAlpZiAo
IWV2ZW50KQ0KIAkJcmV0dXJuOw0KIA0KQEAgLTM2MSw3ICszNzMsOCBAQCB2b2lkIGZ0cmFjZV9z
eXNjYWxsX2V4aXQodm9pZCAqaWdub3JlLCBzdHJ1Y3QgcHRfcmVncyAqcmVncywgbG9uZyByZXQp
DQogDQogCWlmICghZmlsdGVyX2N1cnJlbnRfY2hlY2tfZGlzY2FyZChidWZmZXIsIHN5c19kYXRh
LT5leGl0X2V2ZW50LA0KIAkJCQkJICBlbnRyeSwgZXZlbnQpKQ0KLQkJdHJhY2VfY3VycmVudF9i
dWZmZXJfdW5sb2NrX2NvbW1pdChidWZmZXIsIGV2ZW50LCAwLCAwKTsNCisJCXRyYWNlX2N1cnJl
bnRfYnVmZmVyX3VubG9ja19jb21taXQoYnVmZmVyLCBldmVudCwNCisJCQkJCQkgICBpcnFfZmxh
Z3MsIHBjKTsNCiB9DQogDQogaW50IHJlZ19ldmVudF9zeXNjYWxsX2VudGVyKHN0cnVjdCBmdHJh
Y2VfZXZlbnRfY2FsbCAqY2FsbCkNCmRpZmYgLS1naXQgYS9tbS9odWdldGxiLmMgYi9tbS9odWdl
dGxiLmMNCmluZGV4IDJkY2Q3MTYuLmRkZjIxMjggMTAwNjQ0DQotLS0gYS9tbS9odWdldGxiLmMN
CisrKyBiL21tL2h1Z2V0bGIuYw0KQEAgLTY3OSw2ICs2NzksMjMgQEAgaW50IFBhZ2VIdWdlKHN0
cnVjdCBwYWdlICpwYWdlKQ0KIH0NCiBFWFBPUlRfU1lNQk9MX0dQTChQYWdlSHVnZSk7DQogDQor
cGdvZmZfdCBfX2Jhc2VwYWdlX2luZGV4KHN0cnVjdCBwYWdlICpwYWdlKQ0KK3sNCisJc3RydWN0
IHBhZ2UgKnBhZ2VfaGVhZCA9IGNvbXBvdW5kX2hlYWQocGFnZSk7DQorCXBnb2ZmX3QgaW5kZXgg
PSBwYWdlX2luZGV4KHBhZ2VfaGVhZCk7DQorCXVuc2lnbmVkIGxvbmcgY29tcG91bmRfaWR4Ow0K
Kw0KKwlpZiAoIVBhZ2VIdWdlKHBhZ2VfaGVhZCkpDQorCQlyZXR1cm4gcGFnZV9pbmRleChwYWdl
KTsNCisNCisJaWYgKGNvbXBvdW5kX29yZGVyKHBhZ2VfaGVhZCkgPj0gTUFYX09SREVSKQ0KKwkJ
Y29tcG91bmRfaWR4ID0gcGFnZV90b19wZm4ocGFnZSkgLSBwYWdlX3RvX3BmbihwYWdlX2hlYWQp
Ow0KKwllbHNlDQorCQljb21wb3VuZF9pZHggPSBwYWdlIC0gcGFnZV9oZWFkOw0KKw0KKwlyZXR1
cm4gKGluZGV4IDw8IGNvbXBvdW5kX29yZGVyKHBhZ2VfaGVhZCkpICsgY29tcG91bmRfaWR4Ow0K
K30NCisNCiBzdGF0aWMgc3RydWN0IHBhZ2UgKmFsbG9jX2ZyZXNoX2h1Z2VfcGFnZV9ub2RlKHN0
cnVjdCBoc3RhdGUgKmgsIGludCBuaWQpDQogew0KIAlzdHJ1Y3QgcGFnZSAqcGFnZTsNCmRpZmYg
LS1naXQgYS9uZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYyBiL25ldC9ibHVldG9vdGgvbDJjYXBf
Y29yZS5jDQppbmRleCBhMGI2YzUwLi5kZDdjMDE5IDEwMDY0NA0KLS0tIGEvbmV0L2JsdWV0b290
aC9sMmNhcF9jb3JlLmMNCisrKyBiL25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jDQpAQCAtMTcz
Nyw2ICsxNzM3LDkgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICpsMmNhcF9idWlsZF9jbWQoc3Ry
dWN0IGwyY2FwX2Nvbm4gKmNvbm4sDQogCUJUX0RCRygiY29ubiAlcCwgY29kZSAweCUyLjJ4LCBp
ZGVudCAweCUyLjJ4LCBsZW4gJWQiLA0KIAkJCWNvbm4sIGNvZGUsIGlkZW50LCBkbGVuKTsNCiAN
CisJaWYgKGNvbm4tPm10dSA8IEwyQ0FQX0hEUl9TSVpFICsgTDJDQVBfQ01EX0hEUl9TSVpFKQ0K
KwkJcmV0dXJuIE5VTEw7DQorDQogCWxlbiA9IEwyQ0FQX0hEUl9TSVpFICsgTDJDQVBfQ01EX0hE
Ul9TSVpFICsgZGxlbjsNCiAJY291bnQgPSBtaW5fdCh1bnNpZ25lZCBpbnQsIGNvbm4tPm10dSwg
bGVuKTsNCiANCkBAIC0yODY1LDcgKzI4NjgsNyBAQCBzdGF0aWMgaW5saW5lIGludCBsMmNhcF9p
bmZvcm1hdGlvbl9yc3Aoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sDQogCXN0cnVjdCBsMmNhcF9p
bmZvX3JzcCAqcnNwID0gKHN0cnVjdCBsMmNhcF9pbmZvX3JzcCAqKSBkYXRhOw0KIAl1MTYgdHlw
ZSwgcmVzdWx0Ow0KIA0KLQlpZiAoY21kX2xlbiAhPSBzaXplb2YoKnJzcCkpDQorCWlmIChjbWRf
bGVuIDwgc2l6ZW9mKCpyc3ApKQ0KIAkJcmV0dXJuIC1FUFJPVE87DQogDQogCXR5cGUgICA9IF9f
bGUxNl90b19jcHUocnNwLT50eXBlKTsNCmRpZmYgLS1naXQgYS9uZXQvY2VwaC9hdXRoX25vbmUu
YyBiL25ldC9jZXBoL2F1dGhfbm9uZS5jDQppbmRleCAyMTRjMmJiLi45Zjc4YzVmIDEwMDY0NA0K
LS0tIGEvbmV0L2NlcGgvYXV0aF9ub25lLmMNCisrKyBiL25ldC9jZXBoL2F1dGhfbm9uZS5jDQpA
QCAtMzksNiArMzksMTEgQEAgc3RhdGljIGludCBzaG91bGRfYXV0aGVudGljYXRlKHN0cnVjdCBj
ZXBoX2F1dGhfY2xpZW50ICphYykNCiAJcmV0dXJuIHhpLT5zdGFydGluZzsNCiB9DQogDQorc3Rh
dGljIGludCBidWlsZF9yZXF1ZXN0KHN0cnVjdCBjZXBoX2F1dGhfY2xpZW50ICphYywgdm9pZCAq
YnVmLCB2b2lkICplbmQpDQorew0KKwlyZXR1cm4gMDsNCit9DQorDQogLyoNCiAgKiB0aGUgZ2Vu
ZXJpYyBhdXRoIGNvZGUgZGVjb2RlIHRoZSBnbG9iYWxfaWQsIGFuZCB3ZSBjYXJyeSBubyBhY3R1
YWwNCiAgKiBhdXRoZW50aWNhdGUgc3RhdGUsIHNvIG5vdGhpbmcgaGFwcGVucyBoZXJlLg0KQEAg
LTEwNyw2ICsxMTIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGNlcGhfYXV0aF9jbGllbnRfb3Bz
IGNlcGhfYXV0aF9ub25lX29wcyA9IHsNCiAJLmRlc3Ryb3kgPSBkZXN0cm95LA0KIAkuaXNfYXV0
aGVudGljYXRlZCA9IGlzX2F1dGhlbnRpY2F0ZWQsDQogCS5zaG91bGRfYXV0aGVudGljYXRlID0g
c2hvdWxkX2F1dGhlbnRpY2F0ZSwNCisJLmJ1aWxkX3JlcXVlc3QgPSBidWlsZF9yZXF1ZXN0LA0K
IAkuaGFuZGxlX3JlcGx5ID0gaGFuZGxlX3JlcGx5LA0KIAkuY3JlYXRlX2F1dGhvcml6ZXIgPSBj
ZXBoX2F1dGhfbm9uZV9jcmVhdGVfYXV0aG9yaXplciwNCiAJLmRlc3Ryb3lfYXV0aG9yaXplciA9
IGNlcGhfYXV0aF9ub25lX2Rlc3Ryb3lfYXV0aG9yaXplciwNCmRpZmYgLS1naXQgYS9zb3VuZC9w
Y2kvaGRhL3BhdGNoX2hkbWkuYyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfaGRtaS5jDQppbmRleCAz
YzhiYzZlLi5kMTQ4YTJiIDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL2hkYS9wYXRjaF9oZG1pLmMN
CisrKyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfaGRtaS5jDQpAQCAtOTAyLDcgKzkwMiw3IEBAIHN0
YXRpYyBpbnQgaGRtaV9wY21fb3BlbihzdHJ1Y3QgaGRhX3BjbV9zdHJlYW0gKmhpbmZvLA0KIAlw
ZXJfY3Z0LT5hc3NpZ25lZCA9IDE7DQogCWhpbmZvLT5uaWQgPSBwZXJfY3Z0LT5jdnRfbmlkOw0K
IA0KLQlzbmRfaGRhX2NvZGVjX3dyaXRlKGNvZGVjLCBwZXJfcGluLT5waW5fbmlkLCAwLA0KKwlz
bmRfaGRhX2NvZGVjX3dyaXRlX2NhY2hlKGNvZGVjLCBwZXJfcGluLT5waW5fbmlkLCAwLA0KIAkJ
CSAgICBBQ19WRVJCX1NFVF9DT05ORUNUX1NFTCwNCiAJCQkgICAgbXV4X2lkeCk7DQogCXNuZF9o
ZGFfc3BkaWZfY3Rsc19hc3NpZ24oY29kZWMsIHBpbl9pZHgsIHBlcl9jdnQtPmN2dF9uaWQpOw0K
ZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2RlY3Mvd204OTYyLmMgYi9zb3VuZC9zb2MvY29kZWNz
L3dtODk2Mi5jDQppbmRleCBlOTdkZjI0Li44YjY4N2RhIDEwMDY0NA0KLS0tIGEvc291bmQvc29j
L2NvZGVjcy93bTg5NjIuYw0KKysrIGIvc291bmQvc29jL2NvZGVjcy93bTg5NjIuYw0KQEAgLTIx
MTcsNyArMjExNyw2IEBAIHN0YXRpYyBpbnQgd204OTYyX3B1dF9ocF9zdyhzdHJ1Y3Qgc25kX2tj
b250cm9sICprY29udHJvbCwNCiAJCQkgICAgc3RydWN0IHNuZF9jdGxfZWxlbV92YWx1ZSAqdWNv
bnRyb2wpDQogew0KIAlzdHJ1Y3Qgc25kX3NvY19jb2RlYyAqY29kZWMgPSBzbmRfa2NvbnRyb2xf
Y2hpcChrY29udHJvbCk7DQotCXUxNiAqcmVnX2NhY2hlID0gY29kZWMtPnJlZ19jYWNoZTsNCiAJ
aW50IHJldDsNCiANCiAJLyogQXBwbHkgdGhlIHVwZGF0ZSAoaWYgYW55KSAqLw0KQEAgLTIxMjYs
MTYgKzIxMjUsMTkgQEAgc3RhdGljIGludCB3bTg5NjJfcHV0X2hwX3N3KHN0cnVjdCBzbmRfa2Nv
bnRyb2wgKmtjb250cm9sLA0KIAkJcmV0dXJuIDA7DQogDQogCS8qIElmIHRoZSBsZWZ0IFBHQSBp
cyBlbmFibGVkIGhpdCB0aGF0IFZVIGJpdC4uLiAqLw0KLQlpZiAoc25kX3NvY19yZWFkKGNvZGVj
LCBXTTg5NjJfUFdSX01HTVRfMikgJiBXTTg5NjJfSFBPVVRMX1BHQV9FTkEpDQotCQlyZXR1cm4g
c25kX3NvY193cml0ZShjb2RlYywgV004OTYyX0hQT1VUTF9WT0xVTUUsDQotCQkJCSAgICAgcmVn
X2NhY2hlW1dNODk2Ml9IUE9VVExfVk9MVU1FXSk7DQorCXJldCA9IHNuZF9zb2NfcmVhZChjb2Rl
YywgV004OTYyX1BXUl9NR01UXzIpOw0KKwlpZiAocmV0ICYgV004OTYyX0hQT1VUTF9QR0FfRU5B
KSB7DQorCQlzbmRfc29jX3dyaXRlKGNvZGVjLCBXTTg5NjJfSFBPVVRMX1ZPTFVNRSwNCisJCQkg
ICAgICBzbmRfc29jX3JlYWQoY29kZWMsIFdNODk2Ml9IUE9VVExfVk9MVU1FKSk7DQorCQlyZXR1
cm4gMTsNCisJfQ0KIA0KIAkvKiAuLi5vdGhlcndpc2UgdGhlIHJpZ2h0LiAgVGhlIFZVIGlzIHN0
ZXJlby4gKi8NCi0JaWYgKHNuZF9zb2NfcmVhZChjb2RlYywgV004OTYyX1BXUl9NR01UXzIpICYg
V004OTYyX0hQT1VUUl9QR0FfRU5BKQ0KLQkJcmV0dXJuIHNuZF9zb2Nfd3JpdGUoY29kZWMsIFdN
ODk2Ml9IUE9VVFJfVk9MVU1FLA0KLQkJCQkgICAgIHJlZ19jYWNoZVtXTTg5NjJfSFBPVVRSX1ZP
TFVNRV0pOw0KKwlpZiAocmV0ICYgV004OTYyX0hQT1VUUl9QR0FfRU5BKQ0KKwkJc25kX3NvY193
cml0ZShjb2RlYywgV004OTYyX0hQT1VUUl9WT0xVTUUsDQorCQkJICAgICAgc25kX3NvY19yZWFk
KGNvZGVjLCBXTTg5NjJfSFBPVVRSX1ZPTFVNRSkpOw0KIA0KLQlyZXR1cm4gMDsNCisJcmV0dXJu
IDE7DQogfQ0KIA0KIC8qIFRoZSBWVSBiaXRzIGZvciB0aGUgc3BlYWtlcnMgYXJlIGluIGEgZGlm
ZmVyZW50IHJlZ2lzdGVyIHRvIHRoZSBtdXRlDQpAQCAtMzk0NCw3ICszOTQ2LDYgQEAgc3RhdGlj
IGludCB3bTg5NjJfcHJvYmUoc3RydWN0IHNuZF9zb2NfY29kZWMgKmNvZGVjKQ0KIAlpbnQgcmV0
Ow0KIAlzdHJ1Y3Qgd204OTYyX3ByaXYgKndtODk2MiA9IHNuZF9zb2NfY29kZWNfZ2V0X2RydmRh
dGEoY29kZWMpOw0KIAlzdHJ1Y3Qgd204OTYyX3BkYXRhICpwZGF0YSA9IGRldl9nZXRfcGxhdGRh
dGEoY29kZWMtPmRldik7DQotCXUxNiAqcmVnX2NhY2hlID0gY29kZWMtPnJlZ19jYWNoZTsNCiAJ
aW50IGksIHRyaWdnZXIsIGlycV9wb2w7DQogCWJvb2wgZG1pY2NsaywgZG1pY2RhdDsNCiANCkBA
IC00MDU1LDggKzQwNTYsOSBAQCBzdGF0aWMgaW50IHdtODk2Ml9wcm9iZShzdHJ1Y3Qgc25kX3Nv
Y19jb2RlYyAqY29kZWMpDQogDQogCQkvKiBQdXQgdGhlIHNwZWFrZXJzIGludG8gbW9ubyBtb2Rl
PyAqLw0KIAkJaWYgKHBkYXRhLT5zcGtfbW9ubykNCi0JCQlyZWdfY2FjaGVbV004OTYyX0NMQVNT
X0RfQ09OVFJPTF8yXQ0KLQkJCQl8PSBXTTg5NjJfU1BLX01PTk87DQorCQkJc25kX3NvY191cGRh
dGVfYml0cyhjb2RlYywgV004OTYyX0NMQVNTX0RfQ09OVFJPTF8yLA0KKwkJCQlXTTg5NjJfU1BL
X01PTk9fTUFTSywgV004OTYyX1NQS19NT05PKTsNCisNCiANCiAJCS8qIE1pY2JpYXMgc2V0dXAs
IGRldGVjdGlvbiBlbmFibGUgYW5kIGRldGVjdGlvbg0KIAkJICogdGhyZWFzaG9sZHMuICovDQo=


--=-zTa+OcuBroNTlxkppPYm--

--=-41g9vh8yekW25sSNgMyg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfPWsOe/yOyVhhEJAQrTJg/+OxL+EE9OMe8W3KIC0VXkWpf26nKkcshH
cbWVMrtOWetJVxjJMurNZtxCR+q23oBjlEbn+rfMY1iJmNtGvM+hE1j+tRkt6MNu
9yos5m104ke8qCK+ofQIoaOvaeKES6/9UChri0i4K+86eM5BjULEcABeMhIDgGLm
iiC1PJTTUOq1mzL56hGgMZFxh2ndpq8SypY5glz3R66J66QLG7LwT6gyWho8v0B9
VO+xAvupDdmPGm/T7a4ou4bhx9x4GnNtEFmpiGXhHQVl5HLuGql3A7whPtFLHZY9
REZvblliVB5RN1uwZOCvx+/6up3TSvI40GJ8/6aFrduoTK/5bvaL/7inMwh6TexI
9SWNXGYhd0MhUQnL+0TakEraTVztlo04dKOxh47vpfqxalm2FGL0ESPK148pgK+s
69/U2dyEwcJO5RQmi4Q9wqq+8daavHnsw2F7QI+gnFHXNKIamWRJECk/wOmCMlZ4
ZJIXQP88lPpDPu8GHcIwewaNsOxh6PjnsRlrFt+PT3mC6Spe67DAZ0/xaXdTBxgu
XeoMhVjMiFMqWBJEU4H+d5BxgOL5HMmKZmLjyUykfdZHTL3m3XYG6IVDVHpzKApo
IYzqkZcmV12StuvX0YXJ/H7kBJGooPynTMdRiHQYHvzA7TJqsGLxX2EjV6uHW5u4
JehYl4PbFWg=
=URvG
-----END PGP SIGNATURE-----

--=-41g9vh8yekW25sSNgMyg--
