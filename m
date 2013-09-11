Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3IKA4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:56:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39467 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab3IKA4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:56:41 -0400
Message-ID: <1378860973.32513.48.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.51
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 11 Sep 2013 01:56:13 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ftUD4RZIs3rH+BTUm/cy"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ftUD4RZIs3rH+BTUm/cy
Content-Type: multipart/mixed; boundary="=-g5CTOmIdKae6ziVwk0IY"


--=-g5CTOmIdKae6ziVwk0IY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.51 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.50 is attached to this message.

Ben.

------------

 Makefile                                           |  2 +-
 arch/alpha/Makefile                                |  2 +-
 arch/arm/Kconfig                                   |  1 -
 arch/arm/include/asm/a.out-core.h                  | 45 --------------
 arch/arm/include/asm/a.out.h                       | 34 -----------
 arch/arm/include/asm/processor.h                   |  4 --
 arch/arm/kernel/perf_event.c                       | 10 ++-
 arch/cris/kernel/vmlinux.lds.S                     |  1 +
 arch/hexagon/kernel/dma.c                          |  1 +
 arch/hexagon/kernel/ptrace.c                       |  1 +
 arch/hexagon/kernel/time.c                         |  1 +
 arch/hexagon/kernel/vdso.c                         |  1 +
 arch/m32r/boot/compressed/Makefile                 |  6 +-
 arch/m32r/boot/compressed/misc.c                   | 12 +++-
 arch/m68k/emu/natfeat.c                            | 23 +++++--
 arch/m68k/include/asm/div64.h                      |  9 +--
 arch/microblaze/configs/mmu_defconfig              | 49 ++++++++++-----
 arch/microblaze/configs/nommu_defconfig            | 71 +++++++++++++-----=
----
 arch/microblaze/include/asm/futex.h                |  2 +-
 arch/powerpc/Kconfig                               |  1 +
 arch/powerpc/include/asm/page.h                    | 10 +++
 arch/powerpc/kernel/lparcfg.c                      | 23 +++----
 arch/s390/kvm/kvm-s390.c                           | 17 ++++--
 arch/sparc/Kconfig                                 |  1 +
 arch/sparc/include/asm/atomic_32.h                 |  2 +
 arch/sparc/lib/Makefile                            |  2 +-
 arch/sparc/lib/ucmpdi2.c                           | 19 ++++++
 arch/x86/kernel/i387.c                             |  2 +-
 arch/x86/kernel/sys_x86_64.c                       |  2 +-
 arch/x86/mm/mmap.c                                 |  6 +-
 arch/x86/xen/setup.c                               | 22 +++++++
 drivers/acpi/battery.c                             |  2 +
 drivers/ata/Kconfig                                |  2 +-
 drivers/ata/libata-pmp.c                           | 12 ++--
 drivers/ata/sata_inic162x.c                        | 14 +++++
 drivers/base/memory.c                              |  2 +
 drivers/base/power/domain.c                        |  3 +-
 drivers/bluetooth/ath3k.c                          | 10 +++
 drivers/bluetooth/btusb.c                          |  8 +++
 drivers/char/virtio_console.c                      | 47 ++++++++------
 drivers/gpu/drm/i915/i915_drv.h                    |  1 +
 drivers/gpu/drm/i915/i915_reg.h                    |  5 +-
 drivers/gpu/drm/i915/intel_display.c               | 16 +++++
 drivers/gpu/drm/i915/intel_lvds.c                  | 11 +---
 drivers/gpu/drm/i915/intel_ringbuffer.c            | 12 ++++
 drivers/gpu/drm/radeon/atom.c                      |  5 ++
 drivers/gpu/drm/radeon/evergreen.c                 |  3 +-
 drivers/gpu/drm/radeon/ni.c                        |  3 +-
 drivers/gpu/drm/radeon/r600.c                      |  3 +-
 drivers/gpu/drm/radeon/rv770.c                     |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                | 58 ++++++++++++------
 drivers/hwmon/adt7470.c                            |  2 +-
 drivers/md/raid1.c                                 |  2 +-
 drivers/net/arcnet/arcnet.c                        |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |  3 +-
 drivers/net/ifb.c                                  |  1 +
 drivers/net/usb/smsc75xx.c                         | 12 +---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      | 10 +++
 drivers/net/wireless/hostap/hostap_ioctl.c         |  4 +-
 drivers/net/wireless/iwlegacy/iwl-core.c           |  1 +
 drivers/net/wireless/iwlegacy/iwl4965-base.c       | 18 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  5 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c             |  1 +
 drivers/net/wireless/mwifiex/sdio.c                |  4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          | 18 +++---
 drivers/net/wireless/zd1201.c                      |  4 +-
 drivers/of/fdt.c                                   |  2 +
 drivers/parisc/iommu-helpers.h                     |  2 +
 drivers/pci/Makefile                               |  1 +
 drivers/s390/scsi/zfcp_erp.c                       | 29 ++++++---
 drivers/s390/scsi/zfcp_qdio.c                      |  8 +--
 drivers/scsi/megaraid/megaraid_sas_base.c          | 20 ++++--
 drivers/scsi/nsp32.c                               |  2 +-
 drivers/target/target_core_cdb.c                   | 11 ++--
 drivers/tty/hvc/hvsi_lib.c                         |  4 +-
 drivers/tty/serial/mxs-auart.c                     | 38 +++++++-----
 drivers/usb/core/quirks.c                          |  6 ++
 drivers/usb/misc/adutux.c                          |  2 +-
 drivers/usb/serial/ftdi_sio.c                      | 31 +++++++++-
 drivers/usb/serial/ftdi_sio_ids.h                  | 34 +++++++++--
 drivers/usb/serial/keyspan.c                       |  2 +-
 drivers/usb/serial/mos7720.c                       | 21 ++++---
 drivers/usb/serial/mos7840.c                       | 18 +++++-
 drivers/usb/serial/ti_usb_3410_5052.c              |  9 +--
 drivers/xen/events.c                               | 13 +++-
 fs/bio.c                                           | 32 ++++++----
 fs/cifs/cifsencrypt.c                              |  2 +-
 fs/cifs/cifsglob.h                                 |  1 +
 fs/cifs/readdir.c                                  |  8 +++
 fs/cifs/sess.c                                     |  6 +-
 fs/exofs/ore.c                                     |  2 +-
 fs/exofs/ore_raid.c                                |  2 +-
 fs/ext4/ext4_jbd2.c                                |  8 +--
 fs/ext4/super.c                                    | 17 +++++-
 fs/jfs/jfs_dtree.c                                 | 31 +++++++---
 fs/nfs/callback_xdr.c                              |  6 +-
 fs/nilfs2/segbuf.c                                 |  5 +-
 fs/proc/task_mmu.c                                 |  6 +-
 include/linux/bio.h                                | 17 +++++-
 include/linux/ftrace_event.h                       |  4 +-
 include/linux/mm_types.h                           |  1 +
 include/linux/slab.h                               | 17 +++++-
 include/linux/wait.h                               | 57 +++++++++++++++++
 kernel/events/core.c                               | 20 +++++-
 kernel/sched_fair.c                                |  2 +-
 kernel/trace/trace.c                               |  1 +
 kernel/workqueue.c                                 |  9 +++
 mm/bounce.c                                        |  2 +-
 mm/nommu.c                                         | 10 +++
 mm/page_alloc.c                                    |  4 ++
 net/ipv4/sysctl_net_ipv4.c                         |  6 +-
 net/ipv6/ip6mr.c                                   |  5 ++
 net/key/af_key.c                                   |  5 ++
 net/mac80211/rx.c                                  | 10 ++-
 net/sched/sch_atm.c                                |  1 +
 net/sched/sch_cbq.c                                |  1 +
 net/sctp/outqueue.c                                |  8 +--
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  4 +-
 net/sunrpc/socklib.c                               |  4 +-
 net/sunrpc/xdr.c                                   | 25 ++++----
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  8 +--
 net/wireless/nl80211.c                             |  7 ++-
 sound/i2c/other/ak4xxx-adda.c                      |  2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |  8 +--
 sound/oss/Kconfig                                  |  1 +
 sound/usb/6fire/comm.c                             | 38 ++++++++++--
 sound/usb/6fire/comm.h                             |  2 +-
 sound/usb/6fire/midi.c                             | 16 ++++-
 sound/usb/6fire/midi.h                             |  6 +-
 sound/usb/6fire/pcm.c                              | 41 ++++++++++++-
 sound/usb/6fire/pcm.h                              |  2 +-
 sound/usb/mixer.c                                  | 16 ++++-
 tools/perf/util/map.c                              |  3 +-
 135 files changed, 998 insertions(+), 436 deletions(-)

AceLan Kao (2):
      Bluetooth: Add support for Atheros [0cf3:3121]
      Bluetooth: Add support for Atheros [0cf3:e003]

Alex Deucher (2):
      drm/radeon/atom: initialize more atom interpretor elements to 0
      drm/radeon: always program the MC on startup

Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mista=
ke

Arnd Bergmann (1):
      SCSI: nsp32: use mdelay instead of large udelay constants

Ben Hutchings (3):
      ifb: Include <linux/sched.h>
      Revert "PM / Domains: Fix handling of wakeup devices during system re=
sume"
      Linux 3.2.51

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hype=
rvisor

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset

Cong Wang (2):
      include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h
      sunrpc: remove the second argument of k[un]map_atomic()

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Dan Carpenter (6):
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()
      ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
      NFSv4.1: integer overflow in decode_cb_sequence_args()
      Hostap: copying wrong data prism2_ioctl_giwaplist()

Daniel Vetter (1):
      drm/i915/lvds: ditch ->prepare special case

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

David S. Miller (2):
      net_sched: Fix stack info leak in cbq_dump_wrr().
      sparc32: Add ucmpdi2.o to obj-y instead of lib-y.

David Vrabel (3):
      xen/events: initialize local per-cpu mask for all possible events
      xen/events: mask events when changing their VCPU binding
      x86/xen: do not identity map UNUSABLE regions in the machine E820

Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie

Eldad Zack (1):
      ALSA: usb-audio: skip UAC2 EFFECT_UNIT

Emmanuel Grumbach (1):
      iwlwifi: add DELL SKU for 5150 HMC

Eric Dumazet (1):
      usbnet: do not pretend to support SG/TSO

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Geert Uytterhoeven (4):
      m68k/atari: ARAnyM - Fix NatFeat module support
      m32r: consistently use "suffix-$(...)"
      m32r: add memcpy() for CONFIG_KERNEL_GZIP=3Dy
      m32r: make memset() global for CONFIG_KERNEL_BZIP2=3Dy

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanu=
p

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Jan Kara (1):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Jeff Layton (1):
      cifs: don't instantiate new dentries in readdir for inodes that need =
to be revalidated immediately

Jesper Nilsson (1):
      CRIS: Add _sdata to vmlinux.lds.S

Jiri Olsa (1):
      perf: Fix event group context move

Johan Hovold (5):
      USB: mos7840: fix race in register handling
      USB: adutux: fix big-endian device-type reporting
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Johannes Berg (2):
      mac80211: fix duplicate retransmission detection
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth

Joshua Zhu (1):
      perf tools: Add anonymous huge page recognition

Jussi Kivilinna (2):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
      zd1201: do not use stack as URB transfer_buffer

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Kent Overstreet (1):
      block: Add bio_for_each_segment_all()

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Linus Torvalds (1):
      vm: add no-mmu vm_iomap_memory() stub

Martin Peschke (2):
      zfcp: fix lock imbalance by reworking request queue locking
      zfcp: fix schedule-inside-lock in scsi_device list loops

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Simek (2):
      microblaze: Update microblaze defconfigs
      microblaze: Fix __futex_atomic_op macro register usage

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Neil Horman (1):
      sctp: fully initialize sctp_outq in sctp_outq_init

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

Oleksij Rempel (1):
      ath9k_htc: do some initial hardware configuration

Oliver Neukum (1):
      usb: add two quirky touchscreen

Paul Bolle (1):
      sound: Fix make allmodconfig on MIPS correctly

Paul Gortmaker (1):
      pci: frv architecture needs generic setup-bus infrastructure

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Radu Caragea (1):
      x86 get_unmapped_area: Access mmap_legacy_base through mm_struct memb=
er

Richard Kuo (1):
      Hexagon: misc compile warning/error cleanup due to missing headers

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Roland Dreier (1):
      sg: Fix user memory corruption when SG_IO is interrupted by a signal

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sec=
tions

Sam Ravnborg (2):
      sparc32: support atomic64_t
      sparc32: add ucmpdi2

Stanislaw Gruszka (5):
      rt2x00: fix stop queue
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off
      iwl4965: fix rfkill set state regression

Stephen Boyd (1):
      perf/arm: Fix armpmu_map_hw_event()

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Sumit.Saxena@lsi.com (1):
      megaraid_sas: megaraid_sas driver init fails in kdump kernel

Takashi Iwai (2):
      sound: Fix make allmodconfig on MIPS
      ALSA: opti9xx: Fix conflicting driver object name

Tejun Heo (2):
      libata: make it clear that sata_inic162x is experimental
      workqueue: cond_resched() after processing each work item

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Tomasz Mo=C5=84 (1):
      mwifiex: Add missing endian conversion.

Torstein Hegge (1):
      ALSA: usb: Parse UAC2 extension unit like for UAC1

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Uwe Kleine-K=C3=B6nig (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idl=
e

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPN=
OTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOT=
SUPP error detection

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

Will Deacon (3):
      ARM: 7791/1: a.out: remove partial a.out support
      ARM: 7809/1: perf: fix event validation for software group leaders
      alpha: makefile: don't enforce small data model for kernel builds

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT

Xi Wang (1):
      slab: introduce kmalloc_array()

Zhu Yanhai (1):
      sched: Fix the broken sched_rr_get_interval()

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()



--=-g5CTOmIdKae6ziVwk0IY
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.51.patch"
Content-Disposition: attachment; filename="linux-3.2.51.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDA3OTllOGUuLjBmMTE5MzYg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDUwDQorU1VCTEVWRUwg
PSA1MQ0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL2FscGhhL01ha2VmaWxlIGIvYXJjaC9hbHBoYS9NYWtlZmlsZQ0K
aW5kZXggNDc1OWZlNy4uMmNjM2NjNSAxMDA2NDQNCi0tLSBhL2FyY2gvYWxwaGEvTWFrZWZpbGUN
CisrKyBiL2FyY2gvYWxwaGEvTWFrZWZpbGUNCkBAIC0xMiw3ICsxMiw3IEBAIE5NIDo9ICQoTk0p
IC1CDQogDQogTERGTEFHU192bWxpbnV4CTo9IC1zdGF0aWMgLU4gIy1yZWxheA0KIENIRUNLRkxB
R1MJKz0gLURfX2FscGhhX18gLW02NA0KLWNmbGFncy15CTo9IC1waXBlIC1tbm8tZnAtcmVncyAt
ZmZpeGVkLTggLW1zbWFsbC1kYXRhDQorY2ZsYWdzLXkJOj0gLXBpcGUgLW1uby1mcC1yZWdzIC1m
Zml4ZWQtOA0KIGNmbGFncy15CSs9ICQoY2FsbCBjYy1vcHRpb24sIC1mbm8tanVtcC10YWJsZXMp
DQogDQogY3B1ZmxhZ3MtJChDT05GSUdfQUxQSEFfRVY0KQkJOj0gLW1jcHU9ZXY0DQpkaWZmIC0t
Z2l0IGEvYXJjaC9hcm0vS2NvbmZpZyBiL2FyY2gvYXJtL0tjb25maWcNCmluZGV4IDI3YmNkMTIu
Ljc5MGVhNjggMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9LY29uZmlnDQorKysgYi9hcmNoL2FybS9L
Y29uZmlnDQpAQCAtMSw3ICsxLDYgQEANCiBjb25maWcgQVJNDQogCWJvb2wNCiAJZGVmYXVsdCB5
DQotCXNlbGVjdCBIQVZFX0FPVVQNCiAJc2VsZWN0IEhBVkVfRE1BX0FQSV9ERUJVRw0KIAlzZWxl
Y3QgSEFWRV9JREUgaWYgUENJIHx8IElTQSB8fCBQQ01DSUENCiAJc2VsZWN0IEhBVkVfTUVNQkxP
Q0sNCmRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9hLm91dC1jb3JlLmggYi9hcmNo
L2FybS9pbmNsdWRlL2FzbS9hLm91dC1jb3JlLmgNCmRlbGV0ZWQgZmlsZSBtb2RlIDEwMDY0NA0K
aW5kZXggOTJmMTBjYi4uMDAwMDAwMA0KLS0tIGEvYXJjaC9hcm0vaW5jbHVkZS9hc20vYS5vdXQt
Y29yZS5oDQorKysgL2Rldi9udWxsDQpAQCAtMSw0NSArMCwwIEBADQotLyogYS5vdXQgY29yZWR1
bXAgcmVnaXN0ZXIgZHVtcGVyDQotICoNCi0gKiBDb3B5cmlnaHQgKEMpIDIwMDcgUmVkIEhhdCwg
SW5jLiBBbGwgUmlnaHRzIFJlc2VydmVkLg0KLSAqIFdyaXR0ZW4gYnkgRGF2aWQgSG93ZWxscyAo
ZGhvd2VsbHNAcmVkaGF0LmNvbSkNCi0gKg0KLSAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3
YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3INCi0gKiBtb2RpZnkgaXQgdW5kZXIg
dGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5jZQ0KLSAqIGFzIHB1Ymxp
c2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbg0KLSAq
IDIgb2YgdGhlIExpY2VuY2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24u
DQotICovDQotDQotI2lmbmRlZiBfQVNNX0FfT1VUX0NPUkVfSA0KLSNkZWZpbmUgX0FTTV9BX09V
VF9DT1JFX0gNCi0NCi0jaWZkZWYgX19LRVJORUxfXw0KLQ0KLSNpbmNsdWRlIDxsaW51eC91c2Vy
Lmg+DQotI2luY2x1ZGUgPGxpbnV4L2VsZmNvcmUuaD4NCi0NCi0vKg0KLSAqIGZpbGwgaW4gdGhl
IHVzZXIgc3RydWN0dXJlIGZvciBhbiBhLm91dCBjb3JlIGR1bXANCi0gKi8NCi1zdGF0aWMgaW5s
aW5lIHZvaWQgYW91dF9kdW1wX3RocmVhZChzdHJ1Y3QgcHRfcmVncyAqcmVncywgc3RydWN0IHVz
ZXIgKmR1bXApDQotew0KLQlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzayA9IGN1cnJlbnQ7DQotDQot
CWR1bXAtPm1hZ2ljID0gQ01BR0lDOw0KLQlkdW1wLT5zdGFydF9jb2RlID0gdHNrLT5tbS0+c3Rh
cnRfY29kZTsNCi0JZHVtcC0+c3RhcnRfc3RhY2sgPSByZWdzLT5BUk1fc3AgJiB+KFBBR0VfU0la
RSAtIDEpOw0KLQ0KLQlkdW1wLT51X3RzaXplID0gKHRzay0+bW0tPmVuZF9jb2RlIC0gdHNrLT5t
bS0+c3RhcnRfY29kZSkgPj4gUEFHRV9TSElGVDsNCi0JZHVtcC0+dV9kc2l6ZSA9ICh0c2stPm1t
LT5icmsgLSB0c2stPm1tLT5zdGFydF9kYXRhICsgUEFHRV9TSVpFIC0gMSkgPj4gUEFHRV9TSElG
VDsNCi0JZHVtcC0+dV9zc2l6ZSA9IDA7DQotDQotCW1lbXNldChkdW1wLT51X2RlYnVncmVnLCAw
LCBzaXplb2YoZHVtcC0+dV9kZWJ1Z3JlZykpOw0KLQ0KLQlpZiAoZHVtcC0+c3RhcnRfc3RhY2sg
PCAweDA0MDAwMDAwKQ0KLQkJZHVtcC0+dV9zc2l6ZSA9ICgweDA0MDAwMDAwIC0gZHVtcC0+c3Rh
cnRfc3RhY2spID4+IFBBR0VfU0hJRlQ7DQotDQotCWR1bXAtPnJlZ3MgPSAqcmVnczsNCi0JZHVt
cC0+dV9mcHZhbGlkID0gZHVtcF9mcHUgKHJlZ3MsICZkdW1wLT51X2ZwKTsNCi19DQotDQotI2Vu
ZGlmIC8qIF9fS0VSTkVMX18gKi8NCi0jZW5kaWYgLyogX0FTTV9BX09VVF9DT1JFX0ggKi8NCmRp
ZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9hLm91dC5oIGIvYXJjaC9hcm0vaW5jbHVk
ZS9hc20vYS5vdXQuaA0KZGVsZXRlZCBmaWxlIG1vZGUgMTAwNjQ0DQppbmRleCAwODM4OTRiLi4w
MDAwMDAwDQotLS0gYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9hLm91dC5oDQorKysgL2Rldi9udWxs
DQpAQCAtMSwzNCArMCwwIEBADQotI2lmbmRlZiBfX0FSTV9BX09VVF9IX18NCi0jZGVmaW5lIF9f
QVJNX0FfT1VUX0hfXw0KLQ0KLSNpbmNsdWRlIDxsaW51eC9wZXJzb25hbGl0eS5oPg0KLSNpbmNs
dWRlIDxsaW51eC90eXBlcy5oPg0KLQ0KLXN0cnVjdCBleGVjDQotew0KLSAgX191MzIgYV9pbmZv
OwkJLyogVXNlIG1hY3JvcyBOX01BR0lDLCBldGMgZm9yIGFjY2VzcyAqLw0KLSAgX191MzIgYV90
ZXh0OwkJLyogbGVuZ3RoIG9mIHRleHQsIGluIGJ5dGVzICovDQotICBfX3UzMiBhX2RhdGE7CQkv
KiBsZW5ndGggb2YgZGF0YSwgaW4gYnl0ZXMgKi8NCi0gIF9fdTMyIGFfYnNzOwkJLyogbGVuZ3Ro
IG9mIHVuaW5pdGlhbGl6ZWQgZGF0YSBhcmVhIGZvciBmaWxlLCBpbiBieXRlcyAqLw0KLSAgX191
MzIgYV9zeW1zOwkJLyogbGVuZ3RoIG9mIHN5bWJvbCB0YWJsZSBkYXRhIGluIGZpbGUsIGluIGJ5
dGVzICovDQotICBfX3UzMiBhX2VudHJ5OwkvKiBzdGFydCBhZGRyZXNzICovDQotICBfX3UzMiBh
X3Ryc2l6ZTsJLyogbGVuZ3RoIG9mIHJlbG9jYXRpb24gaW5mbyBmb3IgdGV4dCwgaW4gYnl0ZXMg
Ki8NCi0gIF9fdTMyIGFfZHJzaXplOwkvKiBsZW5ndGggb2YgcmVsb2NhdGlvbiBpbmZvIGZvciBk
YXRhLCBpbiBieXRlcyAqLw0KLX07DQotDQotLyoNCi0gKiBUaGlzIGlzIGFsd2F5cyB0aGUgc2Ft
ZQ0KLSAqLw0KLSNkZWZpbmUgTl9UWFRBRERSKGEpCSgweDAwMDA4MDAwKQ0KLQ0KLSNkZWZpbmUg
Tl9UUlNJWkUoYSkJKChhKS5hX3Ryc2l6ZSkNCi0jZGVmaW5lIE5fRFJTSVpFKGEpCSgoYSkuYV9k
cnNpemUpDQotI2RlZmluZSBOX1NZTVNJWkUoYSkJKChhKS5hX3N5bXMpDQotDQotI2RlZmluZSBN
X0FSTSAxMDMNCi0NCi0jaWZuZGVmIExJQlJBUllfU1RBUlRfVEVYVA0KLSNkZWZpbmUgTElCUkFS
WV9TVEFSVF9URVhUCSgweDAwYzAwMDAwKQ0KLSNlbmRpZg0KLQ0KLSNlbmRpZiAvKiBfX0FfT1VU
X0dOVV9IX18gKi8NCmRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9wcm9jZXNzb3Iu
aCBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oDQppbmRleCBiMmQ5ZGY1Li4zMzUy
NDUxIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0vaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgNCisrKyBi
L2FyY2gvYXJtL2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oDQpAQCAtNTQsNyArNTQsNiBAQCBzdHJ1
Y3QgdGhyZWFkX3N0cnVjdCB7DQogDQogI2RlZmluZSBzdGFydF90aHJlYWQocmVncyxwYyxzcCkJ
CQkJCVwNCiAoewkJCQkJCQkJCVwNCi0JdW5zaWduZWQgbG9uZyAqc3RhY2sgPSAodW5zaWduZWQg
bG9uZyAqKXNwOwkJCVwNCiAJc2V0X2ZzKFVTRVJfRFMpOwkJCQkJCVwNCiAJbWVtc2V0KHJlZ3Mt
PnVyZWdzLCAwLCBzaXplb2YocmVncy0+dXJlZ3MpKTsJCQlcDQogCWlmIChjdXJyZW50LT5wZXJz
b25hbGl0eSAmIEFERFJfTElNSVRfMzJCSVQpCQkJXA0KQEAgLTY2LDkgKzY1LDYgQEAgc3RydWN0
IHRocmVhZF9zdHJ1Y3Qgew0KIAlyZWdzLT5BUk1fY3BzciB8PSBQU1JfRU5EU1RBVEU7CQkJCQlc
DQogCXJlZ3MtPkFSTV9wYyA9IHBjICYgfjE7CQkvKiBwYyAqLwkJCVwNCiAJcmVncy0+QVJNX3Nw
ID0gc3A7CQkvKiBzcCAqLwkJCVwNCi0JcmVncy0+QVJNX3IyID0gc3RhY2tbMl07CS8qIHIyIChl
bnZwKSAqLwkJCVwNCi0JcmVncy0+QVJNX3IxID0gc3RhY2tbMV07CS8qIHIxIChhcmd2KSAqLwkJ
CVwNCi0JcmVncy0+QVJNX3IwID0gc3RhY2tbMF07CS8qIHIwIChhcmdjKSAqLwkJCVwNCiAJbm9t
bXVfc3RhcnRfdGhyZWFkKHJlZ3MpOwkJCQkJXA0KIH0pDQogDQpkaWZmIC0tZ2l0IGEvYXJjaC9h
cm0va2VybmVsL3BlcmZfZXZlbnQuYyBiL2FyY2gvYXJtL2tlcm5lbC9wZXJmX2V2ZW50LmMNCmlu
ZGV4IDc3OGQyNDguLjRhMmRiNDggMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9rZXJuZWwvcGVyZl9l
dmVudC5jDQorKysgYi9hcmNoL2FybS9rZXJuZWwvcGVyZl9ldmVudC5jDQpAQCAtMTE2LDcgKzEx
NiwxMiBAQCBhcm1wbXVfbWFwX2NhY2hlX2V2ZW50KGNvbnN0IHVuc2lnbmVkICgqY2FjaGVfbWFw
KQ0KIHN0YXRpYyBpbnQNCiBhcm1wbXVfbWFwX2V2ZW50KGNvbnN0IHVuc2lnbmVkICgqZXZlbnRf
bWFwKVtQRVJGX0NPVU5UX0hXX01BWF0sIHU2NCBjb25maWcpDQogew0KLQlpbnQgbWFwcGluZyA9
ICgqZXZlbnRfbWFwKVtjb25maWddOw0KKwlpbnQgbWFwcGluZzsNCisNCisJaWYgKGNvbmZpZyA+
PSBQRVJGX0NPVU5UX0hXX01BWCkNCisJCXJldHVybiAtRU5PRU5UOw0KKw0KKwltYXBwaW5nID0g
KCpldmVudF9tYXApW2NvbmZpZ107DQogCXJldHVybiBtYXBwaW5nID09IEhXX09QX1VOU1VQUE9S
VEVEID8gLUVOT0VOVCA6IG1hcHBpbmc7DQogfQ0KIA0KQEAgLTMyNiw2ICszMzEsOSBAQCB2YWxp
ZGF0ZV9ldmVudChzdHJ1Y3QgcG11X2h3X2V2ZW50cyAqaHdfZXZlbnRzLA0KIAlzdHJ1Y3QgaHdf
cGVyZl9ldmVudCBmYWtlX2V2ZW50ID0gZXZlbnQtPmh3Ow0KIAlzdHJ1Y3QgcG11ICpsZWFkZXJf
cG11ID0gZXZlbnQtPmdyb3VwX2xlYWRlci0+cG11Ow0KIA0KKwlpZiAoaXNfc29mdHdhcmVfZXZl
bnQoZXZlbnQpKQ0KKwkJcmV0dXJuIDE7DQorDQogCWlmIChldmVudC0+cG11ICE9IGxlYWRlcl9w
bXUgfHwgZXZlbnQtPnN0YXRlIDwgUEVSRl9FVkVOVF9TVEFURV9PRkYpDQogCQlyZXR1cm4gMTsN
CiANCmRpZmYgLS1naXQgYS9hcmNoL2NyaXMva2VybmVsL3ZtbGludXgubGRzLlMgYi9hcmNoL2Ny
aXMva2VybmVsL3ZtbGludXgubGRzLlMNCmluZGV4IGE2OTkwY2IuLmE2OGI5ODMgMTAwNjQ0DQot
LS0gYS9hcmNoL2NyaXMva2VybmVsL3ZtbGludXgubGRzLlMNCisrKyBiL2FyY2gvY3Jpcy9rZXJu
ZWwvdm1saW51eC5sZHMuUw0KQEAgLTUyLDYgKzUyLDcgQEAgU0VDVElPTlMNCiANCiAJRVhDRVBU
SU9OX1RBQkxFKDQpDQogDQorCV9zZGF0YSA9IC47DQogCVJPREFUQQ0KIA0KIAkuID0gQUxJR04g
KDQpOw0KZGlmZiAtLWdpdCBhL2FyY2gvaGV4YWdvbi9rZXJuZWwvZG1hLmMgYi9hcmNoL2hleGFn
b24va2VybmVsL2RtYS5jDQppbmRleCBlNzExYWNlLi41NDg5MWUxIDEwMDY0NA0KLS0tIGEvYXJj
aC9oZXhhZ29uL2tlcm5lbC9kbWEuYw0KKysrIGIvYXJjaC9oZXhhZ29uL2tlcm5lbC9kbWEuYw0K
QEAgLTIyLDYgKzIyLDcgQEANCiAjaW5jbHVkZSA8bGludXgvYm9vdG1lbS5oPg0KICNpbmNsdWRl
IDxsaW51eC9nZW5hbGxvYy5oPg0KICNpbmNsdWRlIDxhc20vZG1hLW1hcHBpbmcuaD4NCisjaW5j
bHVkZSA8bGludXgvbW9kdWxlLmg+DQogDQogc3RydWN0IGRtYV9tYXBfb3BzICpkbWFfb3BzOw0K
IEVYUE9SVF9TWU1CT0woZG1hX29wcyk7DQpkaWZmIC0tZ2l0IGEvYXJjaC9oZXhhZ29uL2tlcm5l
bC9wdHJhY2UuYyBiL2FyY2gvaGV4YWdvbi9rZXJuZWwvcHRyYWNlLmMNCmluZGV4IGJlYTNmMDgu
LjhmZTAzNDkgMTAwNjQ0DQotLS0gYS9hcmNoL2hleGFnb24va2VybmVsL3B0cmFjZS5jDQorKysg
Yi9hcmNoL2hleGFnb24va2VybmVsL3B0cmFjZS5jDQpAQCAtMjgsNiArMjgsNyBAQA0KICNpbmNs
dWRlIDxsaW51eC9wdHJhY2UuaD4NCiAjaW5jbHVkZSA8bGludXgvcmVnc2V0Lmg+DQogI2luY2x1
ZGUgPGxpbnV4L3VzZXIuaD4NCisjaW5jbHVkZSA8bGludXgvZWxmLmg+DQogDQogI2luY2x1ZGUg
PGFzbS9zeXN0ZW0uaD4NCiAjaW5jbHVkZSA8YXNtL3VzZXIuaD4NCmRpZmYgLS1naXQgYS9hcmNo
L2hleGFnb24va2VybmVsL3RpbWUuYyBiL2FyY2gvaGV4YWdvbi9rZXJuZWwvdGltZS5jDQppbmRl
eCA2YmVlMTVjLi41ZDliMzNiIDEwMDY0NA0KLS0tIGEvYXJjaC9oZXhhZ29uL2tlcm5lbC90aW1l
LmMNCisrKyBiL2FyY2gvaGV4YWdvbi9rZXJuZWwvdGltZS5jDQpAQCAtMjgsNiArMjgsNyBAQA0K
ICNpbmNsdWRlIDxsaW51eC9vZi5oPg0KICNpbmNsdWRlIDxsaW51eC9vZl9hZGRyZXNzLmg+DQog
I2luY2x1ZGUgPGxpbnV4L29mX2lycS5oPg0KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCiAN
CiAjaW5jbHVkZSA8YXNtL3RpbWVyLXJlZ3MuaD4NCiAjaW5jbHVkZSA8YXNtL2hleGFnb25fdm0u
aD4NCmRpZmYgLS1naXQgYS9hcmNoL2hleGFnb24va2VybmVsL3Zkc28uYyBiL2FyY2gvaGV4YWdv
bi9rZXJuZWwvdmRzby5jDQppbmRleCAxNjI3N2MzLi5lNGNlZWRiIDEwMDY0NA0KLS0tIGEvYXJj
aC9oZXhhZ29uL2tlcm5lbC92ZHNvLmMNCisrKyBiL2FyY2gvaGV4YWdvbi9rZXJuZWwvdmRzby5j
DQpAQCAtMjEsNiArMjEsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9lcnIuaD4NCiAjaW5jbHVkZSA8
bGludXgvbW0uaD4NCiAjaW5jbHVkZSA8bGludXgvdm1hbGxvYy5oPg0KKyNpbmNsdWRlIDxsaW51
eC9iaW5mbXRzLmg+DQogDQogI2luY2x1ZGUgPGFzbS92ZHNvLmg+DQogDQpkaWZmIC0tZ2l0IGEv
YXJjaC9tMzJyL2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZSBiL2FyY2gvbTMyci9ib290L2NvbXBy
ZXNzZWQvTWFrZWZpbGUNCmluZGV4IDE3NzcxNmIuLjAxNzI5YzIgMTAwNjQ0DQotLS0gYS9hcmNo
L20zMnIvYm9vdC9jb21wcmVzc2VkL01ha2VmaWxlDQorKysgYi9hcmNoL20zMnIvYm9vdC9jb21w
cmVzc2VkL01ha2VmaWxlDQpAQCAtNDMsOSArNDMsOSBAQCBlbmRpZg0KIA0KIE9CSkNPUFlGTEFH
UyArPSAtUiAuZW1wdHlfemVyb19wYWdlDQogDQotc3VmZml4XyQoQ09ORklHX0tFUk5FTF9HWklQ
KQk9IGd6DQotc3VmZml4XyQoQ09ORklHX0tFUk5FTF9CWklQMikJPSBiejINCi1zdWZmaXhfJChD
T05GSUdfS0VSTkVMX0xaTUEpCT0gbHptYQ0KK3N1ZmZpeC0kKENPTkZJR19LRVJORUxfR1pJUCkJ
PSBneg0KK3N1ZmZpeC0kKENPTkZJR19LRVJORUxfQlpJUDIpCT0gYnoyDQorc3VmZml4LSQoQ09O
RklHX0tFUk5FTF9MWk1BKQk9IGx6bWENCiANCiAkKG9iaikvcGlnZ3kubzogJChvYmopL3ZtbGlu
dXguc2NyICQob2JqKS92bWxpbnV4LmJpbi4kKHN1ZmZpeC15KSBGT1JDRQ0KIAkkKGNhbGwgaWZf
Y2hhbmdlZCxsZCkNCmRpZmYgLS1naXQgYS9hcmNoL20zMnIvYm9vdC9jb21wcmVzc2VkL21pc2Mu
YyBiL2FyY2gvbTMyci9ib290L2NvbXByZXNzZWQvbWlzYy5jDQppbmRleCAzNzBkNjA4Li4yOGEw
OTUyIDEwMDY0NA0KLS0tIGEvYXJjaC9tMzJyL2Jvb3QvY29tcHJlc3NlZC9taXNjLmMNCisrKyBi
L2FyY2gvbTMyci9ib290L2NvbXByZXNzZWQvbWlzYy5jDQpAQCAtMjgsNyArMjgsNyBAQCBzdGF0
aWMgdW5zaWduZWQgbG9uZyBmcmVlX21lbV9wdHI7DQogc3RhdGljIHVuc2lnbmVkIGxvbmcgZnJl
ZV9tZW1fZW5kX3B0cjsNCiANCiAjaWZkZWYgQ09ORklHX0tFUk5FTF9CWklQMg0KLXN0YXRpYyB2
b2lkICptZW1zZXQodm9pZCAqcywgaW50IGMsIHNpemVfdCBuKQ0KK3ZvaWQgKm1lbXNldCh2b2lk
ICpzLCBpbnQgYywgc2l6ZV90IG4pDQogew0KIAljaGFyICpzcyA9IHM7DQogDQpAQCAtMzksNiAr
MzksMTYgQEAgc3RhdGljIHZvaWQgKm1lbXNldCh2b2lkICpzLCBpbnQgYywgc2l6ZV90IG4pDQog
I2VuZGlmDQogDQogI2lmZGVmIENPTkZJR19LRVJORUxfR1pJUA0KK3ZvaWQgKm1lbWNweSh2b2lk
ICpkZXN0LCBjb25zdCB2b2lkICpzcmMsIHNpemVfdCBuKQ0KK3sNCisJY2hhciAqZCA9IGRlc3Q7
DQorCWNvbnN0IGNoYXIgKnMgPSBzcmM7DQorCXdoaWxlIChuLS0pDQorCQkqZCsrID0gKnMrKzsN
CisNCisJcmV0dXJuIGRlc3Q7DQorfQ0KKw0KICNkZWZpbmUgQk9PVF9IRUFQX1NJWkUgICAgICAg
ICAgICAgMHgxMDAwMA0KICNpbmNsdWRlICIuLi8uLi8uLi8uLi9saWIvZGVjb21wcmVzc19pbmZs
YXRlLmMiDQogI2VuZGlmDQpkaWZmIC0tZ2l0IGEvYXJjaC9tNjhrL2VtdS9uYXRmZWF0LmMgYi9h
cmNoL202OGsvZW11L25hdGZlYXQuYw0KaW5kZXggMjI5MWE3ZC4uZmEyNzdhZSAxMDA2NDQNCi0t
LSBhL2FyY2gvbTY4ay9lbXUvbmF0ZmVhdC5jDQorKysgYi9hcmNoL202OGsvZW11L25hdGZlYXQu
Yw0KQEAgLTE4LDkgKzE4LDExIEBADQogI2luY2x1ZGUgPGFzbS9tYWNoZGVwLmg+DQogI2luY2x1
ZGUgPGFzbS9uYXRmZWF0Lmg+DQogDQorZXh0ZXJuIGxvbmcgbmZfZ2V0X2lkMihjb25zdCBjaGFy
ICpmZWF0dXJlX25hbWUpOw0KKw0KIGFzbSgiXG4iDQotIgkuZ2xvYmFsIG5mX2dldF9pZCxuZl9j
YWxsXG4iDQotIm5mX2dldF9pZDpcbiINCisiCS5nbG9iYWwgbmZfZ2V0X2lkMixuZl9jYWxsXG4i
DQorIm5mX2dldF9pZDI6XG4iDQogIgkuc2hvcnQJMHg3MzAwXG4iDQogIglydHNcbiINCiAibmZf
Y2FsbDpcbiINCkBAIC0yOSwxMiArMzEsMjUgQEAgYXNtKCJcbiINCiAiMToJbW92ZXEubAkjMCwl
ZDBcbiINCiAiCXJ0c1xuIg0KICIJLnNlY3Rpb24gX19leF90YWJsZSxcImFcIlxuIg0KLSIJLmxv
bmcJbmZfZ2V0X2lkLDFiXG4iDQorIgkubG9uZwluZl9nZXRfaWQyLDFiXG4iDQogIgkubG9uZwlu
Zl9jYWxsLDFiXG4iDQogIgkucHJldmlvdXMiKTsNCi1FWFBPUlRfU1lNQk9MX0dQTChuZl9nZXRf
aWQpOw0KIEVYUE9SVF9TWU1CT0xfR1BMKG5mX2NhbGwpOw0KIA0KK2xvbmcgbmZfZ2V0X2lkKGNv
bnN0IGNoYXIgKmZlYXR1cmVfbmFtZSkNCit7DQorCS8qIGZlYXR1cmVfbmFtZSBtYXkgYmUgaW4g
dm1hbGxvYygpZWQgbWVtb3J5LCBzbyBtYWtlIGEgY29weSAqLw0KKwljaGFyIG5hbWVfY29weVsz
Ml07DQorCXNpemVfdCBuOw0KKw0KKwluID0gc3RybGNweShuYW1lX2NvcHksIGZlYXR1cmVfbmFt
ZSwgc2l6ZW9mKG5hbWVfY29weSkpOw0KKwlpZiAobiA+PSBzaXplb2YobmFtZV9jb3B5KSkNCisJ
CXJldHVybiAwOw0KKw0KKwlyZXR1cm4gbmZfZ2V0X2lkMihuYW1lX2NvcHkpOw0KK30NCitFWFBP
UlRfU1lNQk9MX0dQTChuZl9nZXRfaWQpOw0KKw0KIHZvaWQgbmZwcmludChjb25zdCBjaGFyICpm
bXQsIC4uLikNCiB7DQogCXN0YXRpYyBjaGFyIGJ1ZlsyNTZdOw0KZGlmZiAtLWdpdCBhL2FyY2gv
bTY4ay9pbmNsdWRlL2FzbS9kaXY2NC5oIGIvYXJjaC9tNjhrL2luY2x1ZGUvYXNtL2RpdjY0LmgN
CmluZGV4IGVkYjY2MTQuLjc1NTgwMzIgMTAwNjQ0DQotLS0gYS9hcmNoL202OGsvaW5jbHVkZS9h
c20vZGl2NjQuaA0KKysrIGIvYXJjaC9tNjhrL2luY2x1ZGUvYXNtL2RpdjY0LmgNCkBAIC0xMywx
NiArMTMsMTcgQEANCiAJCXVuc2lnbmVkIGxvbmcgbG9uZyBuNjQ7CQkJCVwNCiAJfSBfX247CQkJ
CQkJCVwNCiAJdW5zaWduZWQgbG9uZyBfX3JlbSwgX191cHBlcjsJCQkJXA0KKwl1bnNpZ25lZCBs
b25nIF9fYmFzZSA9IChiYXNlKTsJCQkJXA0KIAkJCQkJCQkJXA0KIAlfX24ubjY0ID0gKG4pOwkJ
CQkJCVwNCiAJaWYgKChfX3VwcGVyID0gX19uLm4zMlswXSkpIHsJCQkJXA0KIAkJYXNtICgiZGl2
dWwubCAlMiwlMTolMCIJCQkJXA0KLQkJCTogIj1kIiAoX19uLm4zMlswXSksICI9ZCIgKF9fdXBw
ZXIpCVwNCi0JCQk6ICJkIiAoYmFzZSksICIwIiAoX19uLm4zMlswXSkpOwlcDQorCQkgICAgIDog
Ij1kIiAoX19uLm4zMlswXSksICI9ZCIgKF9fdXBwZXIpCVwNCisJCSAgICAgOiAiZCIgKF9fYmFz
ZSksICIwIiAoX19uLm4zMlswXSkpOwkJXA0KIAl9CQkJCQkJCVwNCiAJYXNtICgiZGl2dS5sICUy
LCUxOiUwIgkJCQkJXA0KLQkJOiAiPWQiIChfX24ubjMyWzFdKSwgIj1kIiAoX19yZW0pCQlcDQot
CQk6ICJkIiAoYmFzZSksICIxIiAoX191cHBlciksICIwIiAoX19uLm4zMlsxXSkpOwlcDQorCSAg
ICAgOiAiPWQiIChfX24ubjMyWzFdKSwgIj1kIiAoX19yZW0pCQkJXA0KKwkgICAgIDogImQiIChf
X2Jhc2UpLCAiMSIgKF9fdXBwZXIpLCAiMCIgKF9fbi5uMzJbMV0pKTsJXA0KIAkobikgPSBfX24u
bjY0OwkJCQkJCVwNCiAJX19yZW07CQkJCQkJCVwNCiB9KQ0KZGlmZiAtLWdpdCBhL2FyY2gvbWlj
cm9ibGF6ZS9jb25maWdzL21tdV9kZWZjb25maWcgYi9hcmNoL21pY3JvYmxhemUvY29uZmlncy9t
bXVfZGVmY29uZmlnDQppbmRleCBiM2Y1ZWVjLi5hNDcwZjU3IDEwMDY0NA0KLS0tIGEvYXJjaC9t
aWNyb2JsYXplL2NvbmZpZ3MvbW11X2RlZmNvbmZpZw0KKysrIGIvYXJjaC9taWNyb2JsYXplL2Nv
bmZpZ3MvbW11X2RlZmNvbmZpZw0KQEAgLTEsMjUgKzEsMjIgQEANCiBDT05GSUdfRVhQRVJJTUVO
VEFMPXkNCiBDT05GSUdfU1lTVklQQz15DQorQ09ORklHX1BPU0lYX01RVUVVRT15DQorQ09ORklH
X0ZIQU5ETEU9eQ0KK0NPTkZJR19BVURJVD15DQorQ09ORklHX0FVRElUX0xPR0lOVUlEX0lNTVVU
QUJMRT15DQogQ09ORklHX0lLQ09ORklHPXkNCiBDT05GSUdfSUtDT05GSUdfUFJPQz15DQorQ09O
RklHX1NZU0ZTX0RFUFJFQ0FURUQ9eQ0KIENPTkZJR19TWVNGU19ERVBSRUNBVEVEX1YyPXkNCi1D
T05GSUdfQkxLX0RFVl9JTklUUkQ9eQ0KLUNPTkZJR19JTklUUkFNRlNfU09VUkNFPSJyb290ZnMu
Y3BpbyINCi1DT05GSUdfSU5JVFJBTUZTX0NPTVBSRVNTSU9OX0daSVA9eQ0KLSMgQ09ORklHX0ND
X09QVElNSVpFX0ZPUl9TSVpFIGlzIG5vdCBzZXQNCi1DT05GSUdfRVhQRVJUPXkNCiBDT05GSUdf
S0FMTFNZTVNfQUxMPXkNCi1DT05GSUdfS0FMTFNZTVNfRVhUUkFfUEFTUz15DQotIyBDT05GSUdf
SE9UUExVRyBpcyBub3Qgc2V0DQogIyBDT05GSUdfQkFTRV9GVUxMIGlzIG5vdCBzZXQNCi0jIENP
TkZJR19GVVRFWCBpcyBub3Qgc2V0DQotIyBDT05GSUdfRVBPTEwgaXMgbm90IHNldA0KLSMgQ09O
RklHX1NJR05BTEZEIGlzIG5vdCBzZXQNCi0jIENPTkZJR19TSE1FTSBpcyBub3Qgc2V0DQorQ09O
RklHX0VNQkVEREVEPXkNCiBDT05GSUdfU0xBQj15DQogQ09ORklHX01PRFVMRVM9eQ0KIENPTkZJ
R19NT0RVTEVfVU5MT0FEPXkNCiAjIENPTkZJR19CTEtfREVWX0JTRyBpcyBub3Qgc2V0DQorQ09O
RklHX1BBUlRJVElPTl9BRFZBTkNFRD15DQorIyBDT05GSUdfRUZJX1BBUlRJVElPTiBpcyBub3Qg
c2V0DQogQ09ORklHX09QVF9MSUJfQVNNPXkNCiBDT05GSUdfWElMSU5YX01JQ1JPQkxBWkUwX1VT
RV9NU1JfSU5TVFI9MQ0KIENPTkZJR19YSUxJTlhfTUlDUk9CTEFaRTBfVVNFX1BDTVBfSU5TVFI9
MQ0KQEAgLTM3LDMzICszNCw1MyBAQCBDT05GSUdfVU5JWD15DQogQ09ORklHX0lORVQ9eQ0KICMg
Q09ORklHX0lORVRfTFJPIGlzIG5vdCBzZXQNCiAjIENPTkZJR19JUFY2IGlzIG5vdCBzZXQNCitD
T05GSUdfTVREPXkNCiBDT05GSUdfUFJPQ19ERVZJQ0VUUkVFPXkNCiBDT05GSUdfQkxLX0RFVl9S
QU09eQ0KIENPTkZJR19CTEtfREVWX1JBTV9TSVpFPTgxOTINCiBDT05GSUdfTkVUREVWSUNFUz15
DQotQ09ORklHX05FVF9FVEhFUk5FVD15DQogQ09ORklHX1hJTElOWF9FTUFDTElURT15DQorQ09O
RklHX1hJTElOWF9MTF9URU1BQz15DQogIyBDT05GSUdfSU5QVVQgaXMgbm90IHNldA0KICMgQ09O
RklHX1NFUklPIGlzIG5vdCBzZXQNCiAjIENPTkZJR19WVCBpcyBub3Qgc2V0DQorQ09ORklHX1NF
UklBTF84MjUwPXkNCitDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15DQogQ09ORklHX1NFUklB
TF9VQVJUTElURT15DQogQ09ORklHX1NFUklBTF9VQVJUTElURV9DT05TT0xFPXkNCiAjIENPTkZJ
R19IV19SQU5ET00gaXMgbm90IHNldA0KK0NPTkZJR19YSUxJTlhfSFdJQ0FQPXkNCitDT05GSUdf
STJDPXkNCitDT05GSUdfSTJDX1hJTElOWD15DQorQ09ORklHX1NQST15DQorQ09ORklHX1NQSV9Y
SUxJTlg9eQ0KK0NPTkZJR19HUElPTElCPXkNCitDT05GSUdfR1BJT19TWVNGUz15DQorQ09ORklH
X0dQSU9fWElMSU5YPXkNCiAjIENPTkZJR19IV01PTiBpcyBub3Qgc2V0DQorQ09ORklHX1dBVENI
RE9HPXkNCitDT05GSUdfWElMSU5YX1dBVENIRE9HPXkNCitDT05GSUdfRkI9eQ0KK0NPTkZJR19G
Ql9YSUxJTlg9eQ0KICMgQ09ORklHX1VTQl9TVVBQT1JUIGlzIG5vdCBzZXQNCitDT05GSUdfVUlP
PXkNCitDT05GSUdfVUlPX1BEUlY9eQ0KK0NPTkZJR19VSU9fUERSVl9HRU5JUlE9eQ0KK0NPTkZJ
R19VSU9fRE1FTV9HRU5JUlE9eQ0KIENPTkZJR19FWFQyX0ZTPXkNCiAjIENPTkZJR19ETk9USUZZ
IGlzIG5vdCBzZXQNCitDT05GSUdfQ1JBTUZTPXkNCitDT05GSUdfUk9NRlNfRlM9eQ0KIENPTkZJ
R19ORlNfRlM9eQ0KLUNPTkZJR19ORlNfVjM9eQ0KIENPTkZJR19DSUZTPXkNCiBDT05GSUdfQ0lG
U19TVEFUUz15DQogQ09ORklHX0NJRlNfU1RBVFMyPXkNCi1DT05GSUdfUEFSVElUSU9OX0FEVkFO
Q0VEPXkNCi1DT05GSUdfREVCVUdfS0VSTkVMPXkNCiBDT05GSUdfREVURUNUX0hVTkdfVEFTSz15
DQogQ09ORklHX0RFQlVHX1NMQUI9eQ0KIENPTkZJR19ERUJVR19TUElOTE9DSz15DQogQ09ORklH
X0RFQlVHX0lORk89eQ0KLSMgQ09ORklHX1JDVV9DUFVfU1RBTExfREVURUNUT1IgaXMgbm90IHNl
dA0KIENPTkZJR19FQVJMWV9QUklOVEs9eQ0KK0NPTkZJR19LRVlTPXkNCitDT05GSUdfRU5DUllQ
VEVEX0tFWVM9eQ0KK0NPTkZJR19LRVlTX0RFQlVHX1BST0NfS0VZUz15DQogIyBDT05GSUdfQ1JZ
UFRPX0FOU0lfQ1BSTkcgaXMgbm90IHNldA0KZGlmZiAtLWdpdCBhL2FyY2gvbWljcm9ibGF6ZS9j
b25maWdzL25vbW11X2RlZmNvbmZpZyBiL2FyY2gvbWljcm9ibGF6ZS9jb25maWdzL25vbW11X2Rl
ZmNvbmZpZw0KaW5kZXggMDI0OWU0Yi4uNTQ1NGE2ZCAxMDA2NDQNCi0tLSBhL2FyY2gvbWljcm9i
bGF6ZS9jb25maWdzL25vbW11X2RlZmNvbmZpZw0KKysrIGIvYXJjaC9taWNyb2JsYXplL2NvbmZp
Z3Mvbm9tbXVfZGVmY29uZmlnDQpAQCAtMSw0MSArMSw0MCBAQA0KIENPTkZJR19FWFBFUklNRU5U
QUw9eQ0KIENPTkZJR19TWVNWSVBDPXkNCiBDT05GSUdfUE9TSVhfTVFVRVVFPXkNCitDT05GSUdf
RkhBTkRMRT15DQorQ09ORklHX0FVRElUPXkNCitDT05GSUdfQVVESVRfTE9HSU5VSURfSU1NVVRB
QkxFPXkNCiBDT05GSUdfQlNEX1BST0NFU1NfQUNDVD15DQogQ09ORklHX0JTRF9QUk9DRVNTX0FD
Q1RfVjM9eQ0KIENPTkZJR19JS0NPTkZJRz15DQogQ09ORklHX0lLQ09ORklHX1BST0M9eQ0KK0NP
TkZJR19TWVNGU19ERVBSRUNBVEVEPXkNCiBDT05GSUdfU1lTRlNfREVQUkVDQVRFRF9WMj15DQot
Q09ORklHX0VYUEVSVD15DQogQ09ORklHX0tBTExTWU1TX0FMTD15DQotQ09ORklHX0tBTExTWU1T
X0VYVFJBX1BBU1M9eQ0KLSMgQ09ORklHX0hPVFBMVUcgaXMgbm90IHNldA0KICMgQ09ORklHX0JB
U0VfRlVMTCBpcyBub3Qgc2V0DQorQ09ORklHX0VNQkVEREVEPXkNCiBDT05GSUdfU0xBQj15DQog
Q09ORklHX01PRFVMRVM9eQ0KIENPTkZJR19NT0RVTEVfVU5MT0FEPXkNCiAjIENPTkZJR19CTEtf
REVWX0JTRyBpcyBub3Qgc2V0DQotIyBDT05GSUdfT1BUX0xJQl9GVU5DVElPTiBpcyBub3Qgc2V0
DQorQ09ORklHX1BBUlRJVElPTl9BRFZBTkNFRD15DQorIyBDT05GSUdfRUZJX1BBUlRJVElPTiBp
cyBub3Qgc2V0DQogQ09ORklHX1hJTElOWF9NSUNST0JMQVpFMF9VU0VfTVNSX0lOU1RSPTENCiBD
T05GSUdfWElMSU5YX01JQ1JPQkxBWkUwX1VTRV9QQ01QX0lOU1RSPTENCiBDT05GSUdfWElMSU5Y
X01JQ1JPQkxBWkUwX1VTRV9CQVJSRUw9MQ0KIENPTkZJR19YSUxJTlhfTUlDUk9CTEFaRTBfVVNF
X0RJVj0xDQogQ09ORklHX1hJTElOWF9NSUNST0JMQVpFMF9VU0VfSFdfTVVMPTINCiBDT05GSUdf
WElMSU5YX01JQ1JPQkxBWkUwX1VTRV9GUFU9Mg0KLUNPTkZJR19ISUdIX1JFU19USU1FUlM9eQ0K
IENPTkZJR19IWl8xMDA9eQ0KIENPTkZJR19DTURMSU5FX0JPT0w9eQ0KLUNPTkZJR19CSU5GTVRf
RkxBVD15DQorQ09ORklHX0NNRExJTkVfRk9SQ0U9eQ0KIENPTkZJR19ORVQ9eQ0KIENPTkZJR19Q
QUNLRVQ9eQ0KIENPTkZJR19VTklYPXkNCiBDT05GSUdfSU5FVD15DQogIyBDT05GSUdfSU5FVF9M
Uk8gaXMgbm90IHNldA0KICMgQ09ORklHX0lQVjYgaXMgbm90IHNldA0KLSMgQ09ORklHX1BSRVZF
TlRfRklSTVdBUkVfQlVJTEQgaXMgbm90IHNldA0KIENPTkZJR19NVEQ9eQ0KLUNPTkZJR19NVERf
Q09OQ0FUPXkNCi1DT05GSUdfTVREX1BBUlRJVElPTlM9eQ0KIENPTkZJR19NVERfQ01ETElORV9Q
QVJUUz15DQogQ09ORklHX01URF9DSEFSPXkNCiBDT05GSUdfTVREX0JMT0NLPXkNCkBAIC00NSw0
MSArNDQsNTUgQEAgQ09ORklHX01URF9DRklfQU1EU1REPXkNCiBDT05GSUdfTVREX1JBTT15DQog
Q09ORklHX01URF9VQ0xJTlVYPXkNCiBDT05GSUdfUFJPQ19ERVZJQ0VUUkVFPXkNCi1DT05GSUdf
QkxLX0RFVl9OQkQ9eQ0KIENPTkZJR19CTEtfREVWX1JBTT15DQorQ09ORklHX0JMS19ERVZfUkFN
X1NJWkU9ODE5Mg0KIENPTkZJR19ORVRERVZJQ0VTPXkNCi1DT05GSUdfTkVUX0VUSEVSTkVUPXkN
CitDT05GSUdfWElMSU5YX0VNQUNMSVRFPXkNCitDT05GSUdfWElMSU5YX0xMX1RFTUFDPXkNCiAj
IENPTkZJR19JTlBVVCBpcyBub3Qgc2V0DQogIyBDT05GSUdfU0VSSU8gaXMgbm90IHNldA0KICMg
Q09ORklHX1ZUIGlzIG5vdCBzZXQNCitDT05GSUdfU0VSSUFMXzgyNTA9eQ0KK0NPTkZJR19TRVJJ
QUxfODI1MF9DT05TT0xFPXkNCiBDT05GSUdfU0VSSUFMX1VBUlRMSVRFPXkNCiBDT05GSUdfU0VS
SUFMX1VBUlRMSVRFX0NPTlNPTEU9eQ0KLUNPTkZJR19IV19SQU5ET009eQ0KKyMgQ09ORklHX0hX
X1JBTkRPTSBpcyBub3Qgc2V0DQorQ09ORklHX1hJTElOWF9IV0lDQVA9eQ0KK0NPTkZJR19JMkM9
eQ0KK0NPTkZJR19JMkNfWElMSU5YPXkNCitDT05GSUdfU1BJPXkNCitDT05GSUdfU1BJX1hJTElO
WD15DQorQ09ORklHX0dQSU9MSUI9eQ0KK0NPTkZJR19HUElPX1NZU0ZTPXkNCitDT05GSUdfR1BJ
T19YSUxJTlg9eQ0KICMgQ09ORklHX0hXTU9OIGlzIG5vdCBzZXQNCi1DT05GSUdfVklERU9fT1VU
UFVUX0NPTlRST0w9eQ0KK0NPTkZJR19XQVRDSERPRz15DQorQ09ORklHX1hJTElOWF9XQVRDSERP
Rz15DQorQ09ORklHX0ZCPXkNCitDT05GSUdfRkJfWElMSU5YPXkNCisjIENPTkZJR19VU0JfU1VQ
UE9SVCBpcyBub3Qgc2V0DQorQ09ORklHX1VJTz15DQorQ09ORklHX1VJT19QRFJWPXkNCitDT05G
SUdfVUlPX1BEUlZfR0VOSVJRPXkNCitDT05GSUdfVUlPX0RNRU1fR0VOSVJRPXkNCiBDT05GSUdf
RVhUMl9GUz15DQogIyBDT05GSUdfRE5PVElGWSBpcyBub3Qgc2V0DQogQ09ORklHX0NSQU1GUz15
DQogQ09ORklHX1JPTUZTX0ZTPXkNCiBDT05GSUdfTkZTX0ZTPXkNCi1DT05GSUdfTkZTX1YzPXkN
CiBDT05GSUdfTkZTX1YzX0FDTD15DQotQ09ORklHX1VOVVNFRF9TWU1CT0xTPXkNCi1DT05GSUdf
REVCVUdfRlM9eQ0KLUNPTkZJR19ERUJVR19LRVJORUw9eQ0KLUNPTkZJR19ERUJVR19TSElSUT15
DQorQ09ORklHX05MUz15DQogQ09ORklHX0RFVEVDVF9IVU5HX1RBU0s9eQ0KLUNPTkZJR19TQ0hF
RFNUQVRTPXkNCi1DT05GSUdfVElNRVJfU1RBVFM9eQ0KLUNPTkZJR19ERUJVR19PQkpFQ1RTPXkN
Ci1DT05GSUdfREVCVUdfT0JKRUNUU19TRUxGVEVTVD15DQotQ09ORklHX0RFQlVHX09CSkVDVFNf
RlJFRT15DQotQ09ORklHX0RFQlVHX09CSkVDVFNfVElNRVJTPXkNCitDT05GSUdfREVCVUdfU0xB
Qj15DQorQ09ORklHX0RFQlVHX1NQSU5MT0NLPXkNCiBDT05GSUdfREVCVUdfSU5GTz15DQotQ09O
RklHX0RFQlVHX0xJU1Q9eQ0KLUNPTkZJR19ERUJVR19TRz15DQotIyBDT05GSUdfUkNVX0NQVV9T
VEFMTF9ERVRFQ1RPUiBpcyBub3Qgc2V0DQotQ09ORklHX1NZU0NUTF9TWVNDQUxMX0NIRUNLPXkN
CiBDT05GSUdfRUFSTFlfUFJJTlRLPXkNCitDT05GSUdfS0VZUz15DQorQ09ORklHX0VOQ1JZUFRF
RF9LRVlTPXkNCitDT05GSUdfS0VZU19ERUJVR19QUk9DX0tFWVM9eQ0KK0NPTkZJR19DUllQVE9f
RUNCPXkNCitDT05GSUdfQ1JZUFRPX01END15DQorQ09ORklHX0NSWVBUT19NRDU9eQ0KK0NPTkZJ
R19DUllQVE9fQVJDND15DQorQ09ORklHX0NSWVBUT19ERVM9eQ0KICMgQ09ORklHX0NSWVBUT19B
TlNJX0NQUk5HIGlzIG5vdCBzZXQNCi0jIENPTkZJR19DUkMzMiBpcyBub3Qgc2V0DQpkaWZmIC0t
Z2l0IGEvYXJjaC9taWNyb2JsYXplL2luY2x1ZGUvYXNtL2Z1dGV4LmggYi9hcmNoL21pY3JvYmxh
emUvaW5jbHVkZS9hc20vZnV0ZXguaA0KaW5kZXggYjA1MjZkMi4uZmY4Y2RlMSAxMDA2NDQNCi0t
LSBhL2FyY2gvbWljcm9ibGF6ZS9pbmNsdWRlL2FzbS9mdXRleC5oDQorKysgYi9hcmNoL21pY3Jv
YmxhemUvaW5jbHVkZS9hc20vZnV0ZXguaA0KQEAgLTI0LDcgKzI0LDcgQEANCiAJCQkud29yZAkx
Yiw0YiwyYiw0YjsJCQkJXA0KIAkJCS5wcmV2aW91czsiCQkJCQlcDQogCTogIj0mciIgKG9sZHZh
bCksICI9JnIiIChyZXQpCQkJCQlcDQotCTogImIiICh1YWRkciksICJpIiAoLUVGQVVMVCksICJy
IiAob3BhcmcpCQkJXA0KKwk6ICJyIiAodWFkZHIpLCAiaSIgKC1FRkFVTFQpLCAiciIgKG9wYXJn
KQkJCVwNCiAJKTsJCQkJCQkJCVwNCiB9KQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9L
Y29uZmlnIGIvYXJjaC9wb3dlcnBjL0tjb25maWcNCmluZGV4IDk1MWUxOGYuLjE2ZWY4MzggMTAw
NjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMvS2NvbmZpZw0KKysrIGIvYXJjaC9wb3dlcnBjL0tjb25m
aWcNCkBAIC05MzcsNiArOTM3LDcgQEAgY29uZmlnIFJFTE9DQVRBQkxFDQogCSAgbXVzdCBsaXZl
IGF0IGEgZGlmZmVyZW50IHBoeXNpY2FsIGFkZHJlc3MgdGhhbiB0aGUgcHJpbWFyeQ0KIAkgIGtl
cm5lbC4NCiANCisjIFRoaXMgdmFsdWUgbXVzdCBoYXZlIHplcm9lcyBpbiB0aGUgYm90dG9tIDYw
IGJpdHMgb3RoZXJ3aXNlIGxvdHMgd2lsbCBicmVhaw0KIGNvbmZpZyBQQUdFX09GRlNFVA0KIAlo
ZXgNCiAJZGVmYXVsdCAiMHhjMDAwMDAwMDAwMDAwMDAwIg0KZGlmZiAtLWdpdCBhL2FyY2gvcG93
ZXJwYy9pbmNsdWRlL2FzbS9wYWdlLmggYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcGFnZS5o
DQppbmRleCBkZDljNGZkLi41YjBiZGUyIDEwMDY0NA0KLS0tIGEvYXJjaC9wb3dlcnBjL2luY2x1
ZGUvYXNtL3BhZ2UuaA0KKysrIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL3BhZ2UuaA0KQEAg
LTEzMiw5ICsxMzIsMTkgQEAgZXh0ZXJuIHBoeXNfYWRkcl90IGtlcm5zdGFydF9hZGRyOw0KICNk
ZWZpbmUgX192YSh4KSAoKHZvaWQgKikodW5zaWduZWQgbG9uZykoKHBoeXNfYWRkcl90KSh4KSAt
IFBIWVNJQ0FMX1NUQVJUICsgS0VSTkVMQkFTRSkpDQogI2RlZmluZSBfX3BhKHgpICgodW5zaWdu
ZWQgbG9uZykoeCkgKyBQSFlTSUNBTF9TVEFSVCAtIEtFUk5FTEJBU0UpDQogI2Vsc2UNCisjaWZk
ZWYgQ09ORklHX1BQQzY0DQorLyoNCisgKiBnY2MgbWlzY29tcGlsZXMgKHVuc2lnbmVkIGxvbmcp
KCZzdGF0aWNfdmFyKSAtIFBBR0VfT0ZGU0VUDQorICogd2l0aCAtbWNtb2RlbD1tZWRpdW0sIHNv
IHdlIHVzZSAmIGFuZCB8IGluc3RlYWQgb2YgLSBhbmQgKyBvbiA2NC1iaXQuDQorICovDQorI2Rl
ZmluZSBfX3ZhKHgpICgodm9pZCAqKSh1bnNpZ25lZCBsb25nKSgocGh5c19hZGRyX3QpKHgpIHwg
UEFHRV9PRkZTRVQpKQ0KKyNkZWZpbmUgX19wYSh4KSAoKHVuc2lnbmVkIGxvbmcpKHgpICYgMHgw
ZmZmZmZmZmZmZmZmZmZmVUwpDQorDQorI2Vsc2UgLyogMzItYml0LCBub24gYm9vayBFICovDQog
I2RlZmluZSBfX3ZhKHgpICgodm9pZCAqKSh1bnNpZ25lZCBsb25nKSgocGh5c19hZGRyX3QpKHgp
ICsgUEFHRV9PRkZTRVQgLSBNRU1PUllfU1RBUlQpKQ0KICNkZWZpbmUgX19wYSh4KSAoKHVuc2ln
bmVkIGxvbmcpKHgpIC0gUEFHRV9PRkZTRVQgKyBNRU1PUllfU1RBUlQpDQogI2VuZGlmDQorI2Vu
ZGlmDQogDQogLyoNCiAgKiBVbmZvcnR1bmF0ZWx5IHRoZSBQTFQgaXMgaW4gdGhlIEJTUyBpbiB0
aGUgUFBDMzIgRUxGIEFCSSwNCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva2VybmVsL2xwYXJj
ZmcuYyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvbHBhcmNmZy5jDQppbmRleCA4NGRhYWJlLi44MjY2
ODFkIDEwMDY0NA0KLS0tIGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9scGFyY2ZnLmMNCisrKyBiL2Fy
Y2gvcG93ZXJwYy9rZXJuZWwvbHBhcmNmZy5jDQpAQCAtMzcsNyArMzcsMTMgQEANCiAjaW5jbHVk
ZSA8YXNtL3Zkc29fZGF0YXBhZ2UuaD4NCiAjaW5jbHVkZSA8YXNtL3Zpby5oPg0KICNpbmNsdWRl
IDxhc20vbW11Lmg+DQorI2luY2x1ZGUgPGFzbS9tYWNoZGVwLmg+DQogDQorDQorLyoNCisgKiBU
aGlzIGlzbid0IGEgbW9kdWxlIGJ1dCB3ZSBleHBvc2UgdGhhdCB0byB1c2Vyc3BhY2UNCisgKiB2
aWEgL3Byb2Mgc28gbGVhdmUgdGhlIGRlZmluaXRpb25zIGhlcmUNCisgKi8NCiAjZGVmaW5lIE1P
RFVMRV9WRVJTICIxLjkiDQogI2RlZmluZSBNT0RVTEVfTkFNRSAibHBhcmNmZyINCiANCkBAIC00
ODcsNyArNDkzLDggQEAgc3RhdGljIHZvaWQgcGFyc2VfZW1fZGF0YShzdHJ1Y3Qgc2VxX2ZpbGUg
Km0pDQogew0KIAl1bnNpZ25lZCBsb25nIHJldGJ1ZltQTFBBUl9IQ0FMTF9CVUZTSVpFXTsNCiAN
Ci0JaWYgKHBscGFyX2hjYWxsKEhfR0VUX0VNX1BBUk1TLCByZXRidWYpID09IEhfU1VDQ0VTUykN
CisJaWYgKGZpcm13YXJlX2hhc19mZWF0dXJlKEZXX0ZFQVRVUkVfTFBBUikgJiYNCisJICAgIHBs
cGFyX2hjYWxsKEhfR0VUX0VNX1BBUk1TLCByZXRidWYpID09IEhfU1VDQ0VTUykNCiAJCXNlcV9w
cmludGYobSwgInBvd2VyX21vZGVfZGF0YT0lMDE2bHhcbiIsIHJldGJ1ZlswXSk7DQogfQ0KIA0K
QEAgLTc3Miw3ICs3NzksNiBAQCBzdGF0aWMgaW50IGxwYXJjZmdfb3BlbihzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCiB9DQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCBm
aWxlX29wZXJhdGlvbnMgbHBhcmNmZ19mb3BzID0gew0KLQkub3duZXIJCT0gVEhJU19NT0RVTEUs
DQogCS5yZWFkCQk9IHNlcV9yZWFkLA0KIAkud3JpdGUJCT0gbHBhcmNmZ193cml0ZSwNCiAJLm9w
ZW4JCT0gbHBhcmNmZ19vcGVuLA0KQEAgLTc5OSwxNSArODA1LDQgQEAgc3RhdGljIGludCBfX2lu
aXQgbHBhcmNmZ19pbml0KHZvaWQpDQogCXByb2NfcHBjNjRfbHBhcmNmZyA9IGVudDsNCiAJcmV0
dXJuIDA7DQogfQ0KLQ0KLXN0YXRpYyB2b2lkIF9fZXhpdCBscGFyY2ZnX2NsZWFudXAodm9pZCkN
Ci17DQotCWlmIChwcm9jX3BwYzY0X2xwYXJjZmcpDQotCQlyZW1vdmVfcHJvY19lbnRyeSgibHBh
cmNmZyIsIHByb2NfcHBjNjRfbHBhcmNmZy0+cGFyZW50KTsNCi19DQotDQotbW9kdWxlX2luaXQo
bHBhcmNmZ19pbml0KTsNCi1tb2R1bGVfZXhpdChscGFyY2ZnX2NsZWFudXApOw0KLU1PRFVMRV9E
RVNDUklQVElPTigiSW50ZXJmYWNlIGZvciBMUEFSIGNvbmZpZ3VyYXRpb24gZGF0YSIpOw0KLU1P
RFVMRV9BVVRIT1IoIkRhdmUgRW5nZWJyZXRzZW4iKTsNCi1NT0RVTEVfTElDRU5TRSgiR1BMIik7
DQorbWFjaGluZV9kZXZpY2VfaW5pdGNhbGwocHNlcmllcywgbHBhcmNmZ19pbml0KTsNCmRpZmYg
LS1naXQgYS9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkw
LmMNCmluZGV4IDRkYjliMWUuLmRkMDcyYjEgMTAwNjQ0DQotLS0gYS9hcmNoL3MzOTAva3ZtL2t2
bS1zMzkwLmMNCisrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KQEAgLTQ2OSw2ICs0Njks
OCBAQCBpbnQga3ZtX2FyY2hfdmNwdV9pb2N0bF9zZXRfbXBzdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsDQogDQogc3RhdGljIHZvaWQgX192Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUp
DQogew0KKwlpbnQgcmM7DQorDQogCW1lbWNweSgmdmNwdS0+YXJjaC5zaWVfYmxvY2stPmdnMTQs
ICZ2Y3B1LT5hcmNoLmd1ZXN0X2dwcnNbMTRdLCAxNik7DQogDQogCWlmIChuZWVkX3Jlc2NoZWQo
KSkNCkBAIC00NzksMjEgKzQ4MSwyNCBAQCBzdGF0aWMgdm9pZCBfX3ZjcHVfcnVuKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCiANCiAJa3ZtX3MzOTBfZGVsaXZlcl9wZW5kaW5nX2ludGVycnVwdHMo
dmNwdSk7DQogDQorCVZDUFVfRVZFTlQodmNwdSwgNiwgImVudGVyaW5nIHNpZSBmbGFncyAleCIs
DQorCQkgICBhdG9taWNfcmVhZCgmdmNwdS0+YXJjaC5zaWVfYmxvY2stPmNwdWZsYWdzKSk7DQor
DQogCXZjcHUtPmFyY2guc2llX2Jsb2NrLT5pY3B0Y29kZSA9IDA7DQogCWxvY2FsX2lycV9kaXNh
YmxlKCk7DQogCWt2bV9ndWVzdF9lbnRlcigpOw0KIAlsb2NhbF9pcnFfZW5hYmxlKCk7DQotCVZD
UFVfRVZFTlQodmNwdSwgNiwgImVudGVyaW5nIHNpZSBmbGFncyAleCIsDQotCQkgICBhdG9taWNf
cmVhZCgmdmNwdS0+YXJjaC5zaWVfYmxvY2stPmNwdWZsYWdzKSk7DQotCWlmIChzaWU2NGEodmNw
dS0+YXJjaC5zaWVfYmxvY2ssIHZjcHUtPmFyY2guZ3Vlc3RfZ3BycykpIHsNCisJcmMgPSBzaWU2
NGEodmNwdS0+YXJjaC5zaWVfYmxvY2ssIHZjcHUtPmFyY2guZ3Vlc3RfZ3Bycyk7DQorCWxvY2Fs
X2lycV9kaXNhYmxlKCk7DQorCWt2bV9ndWVzdF9leGl0KCk7DQorCWxvY2FsX2lycV9lbmFibGUo
KTsNCisNCisJaWYgKHJjKSB7DQogCQlWQ1BVX0VWRU5UKHZjcHUsIDMsICIlcyIsICJmYXVsdCBp
biBzaWUgaW5zdHJ1Y3Rpb24iKTsNCiAJCWt2bV9zMzkwX2luamVjdF9wcm9ncmFtX2ludCh2Y3B1
LCBQR01fQUREUkVTU0lORyk7DQogCX0NCiAJVkNQVV9FVkVOVCh2Y3B1LCA2LCAiZXhpdCBzaWUg
aWNwdGNvZGUgJWQiLA0KIAkJICAgdmNwdS0+YXJjaC5zaWVfYmxvY2stPmljcHRjb2RlKTsNCi0J
bG9jYWxfaXJxX2Rpc2FibGUoKTsNCi0Ja3ZtX2d1ZXN0X2V4aXQoKTsNCi0JbG9jYWxfaXJxX2Vu
YWJsZSgpOw0KIA0KIAltZW1jcHkoJnZjcHUtPmFyY2guZ3Vlc3RfZ3Byc1sxNF0sICZ2Y3B1LT5h
cmNoLnNpZV9ibG9jay0+Z2cxNCwgMTYpOw0KIH0NCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL0tj
b25maWcgYi9hcmNoL3NwYXJjL0tjb25maWcNCmluZGV4IGYyMTBkNTEuLjg3NTM3ZTIgMTAwNjQ0
DQotLS0gYS9hcmNoL3NwYXJjL0tjb25maWcNCisrKyBiL2FyY2gvc3BhcmMvS2NvbmZpZw0KQEAg
LTMxLDYgKzMxLDcgQEAgY29uZmlnIFNQQVJDDQogDQogY29uZmlnIFNQQVJDMzINCiAJZGVmX2Jv
b2wgITY0QklUDQorCXNlbGVjdCBHRU5FUklDX0FUT01JQzY0DQogDQogY29uZmlnIFNQQVJDNjQN
CiAJZGVmX2Jvb2wgNjRCSVQNCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2luY2x1ZGUvYXNtL2F0
b21pY18zMi5oIGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9hdG9taWNfMzIuaA0KaW5kZXggNWMz
YzhiNi4uMDdkZDM1ZSAxMDA2NDQNCi0tLSBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vYXRvbWlj
XzMyLmgNCisrKyBiL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vYXRvbWljXzMyLmgNCkBAIC0xNSw2
ICsxNSw4IEBADQogDQogI2lmZGVmIF9fS0VSTkVMX18NCiANCisjaW5jbHVkZSA8YXNtLWdlbmVy
aWMvYXRvbWljNjQuaD4NCisNCiAjaW5jbHVkZSA8YXNtL3N5c3RlbS5oPg0KIA0KICNkZWZpbmUg
QVRPTUlDX0lOSVQoaSkgIHsgKGkpIH0NCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2xpYi9NYWtl
ZmlsZSBiL2FyY2gvc3BhcmMvbGliL01ha2VmaWxlDQppbmRleCBhM2ZjNDM3Li40OTYxNTE2IDEw
MDY0NA0KLS0tIGEvYXJjaC9zcGFyYy9saWIvTWFrZWZpbGUNCisrKyBiL2FyY2gvc3BhcmMvbGli
L01ha2VmaWxlDQpAQCAtNDAsNyArNDAsNyBAQCBsaWItJChDT05GSUdfU1BBUkM2NCkgKz0gY29w
eV9pbl91c2VyLm8gdXNlcl9maXh1cC5vIG1lbW1vdmUubw0KIGxpYi0kKENPTkZJR19TUEFSQzY0
KSArPSBtY291bnQubyBpcGNzdW0ubyB4b3IubyBod2VpZ2h0Lm8gZmZzLm8NCiANCiBvYmoteSAg
ICAgICAgICAgICAgICAgKz0gaW9tYXAubw0KLW9iai0kKENPTkZJR19TUEFSQzMyKSArPSBhdG9t
aWMzMi5vDQorb2JqLSQoQ09ORklHX1NQQVJDMzIpICs9IGF0b21pYzMyLm8gdWNtcGRpMi5vDQog
b2JqLXkgICAgICAgICAgICAgICAgICs9IGtzeW1zLm8NCiBvYmotJChDT05GSUdfU1BBUkM2NCkg
Kz0gUGVlQ2VlSS5vDQogb2JqLXkgICAgICAgICAgICAgICAgICs9IHVzZXJjb3B5Lm8NCmRpZmYg
LS1naXQgYS9hcmNoL3NwYXJjL2xpYi91Y21wZGkyLmMgYi9hcmNoL3NwYXJjL2xpYi91Y21wZGky
LmMNCm5ldyBmaWxlIG1vZGUgMTAwNjQ0DQppbmRleCAwMDAwMDAwLi4xZTA2ZWQ1DQotLS0gL2Rl
di9udWxsDQorKysgYi9hcmNoL3NwYXJjL2xpYi91Y21wZGkyLmMNCkBAIC0wLDAgKzEsMTkgQEAN
CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQorI2luY2x1ZGUgImxpYmdjYy5oIg0KKw0KK3dv
cmRfdHlwZSBfX3VjbXBkaTIodW5zaWduZWQgbG9uZyBsb25nIGEsIHVuc2lnbmVkIGxvbmcgbG9u
ZyBiKQ0KK3sNCisJY29uc3QgRFd1bmlvbiBhdSA9IHsubGwgPSBhfTsNCisJY29uc3QgRFd1bmlv
biBidSA9IHsubGwgPSBifTsNCisNCisJaWYgKCh1bnNpZ25lZCBpbnQpIGF1LnMuaGlnaCA8ICh1
bnNpZ25lZCBpbnQpIGJ1LnMuaGlnaCkNCisJCXJldHVybiAwOw0KKwllbHNlIGlmICgodW5zaWdu
ZWQgaW50KSBhdS5zLmhpZ2ggPiAodW5zaWduZWQgaW50KSBidS5zLmhpZ2gpDQorCQlyZXR1cm4g
MjsNCisJaWYgKCh1bnNpZ25lZCBpbnQpIGF1LnMubG93IDwgKHVuc2lnbmVkIGludCkgYnUucy5s
b3cpDQorCQlyZXR1cm4gMDsNCisJZWxzZSBpZiAoKHVuc2lnbmVkIGludCkgYXUucy5sb3cgPiAo
dW5zaWduZWQgaW50KSBidS5zLmxvdykNCisJCXJldHVybiAyOw0KKwlyZXR1cm4gMTsNCit9DQor
RVhQT1JUX1NZTUJPTChfX3VjbXBkaTIpOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9p
Mzg3LmMgYi9hcmNoL3g4Ni9rZXJuZWwvaTM4Ny5jDQppbmRleCA3MzlkODU5Li5mYTRlYTA5IDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL2kzODcuYw0KKysrIGIvYXJjaC94ODYva2VybmVs
L2kzODcuYw0KQEAgLTUxLDcgKzUxLDcgQEAgdm9pZCBfX2NwdWluaXQgbXhjc3JfZmVhdHVyZV9t
YXNrX2luaXQodm9pZCkNCiAJY2x0cygpOw0KIAlpZiAoY3B1X2hhc19meHNyKSB7DQogCQltZW1z
ZXQoJmZ4X3NjcmF0Y2gsIDAsIHNpemVvZihzdHJ1Y3QgaTM4N19meHNhdmVfc3RydWN0KSk7DQot
CQlhc20gdm9sYXRpbGUoImZ4c2F2ZSAlMCIgOiA6ICJtIiAoZnhfc2NyYXRjaCkpOw0KKwkJYXNt
IHZvbGF0aWxlKCJmeHNhdmUgJTAiIDogIittIiAoZnhfc2NyYXRjaCkpOw0KIAkJbWFzayA9IGZ4
X3NjcmF0Y2gubXhjc3JfbWFzazsNCiAJCWlmIChtYXNrID09IDApDQogCQkJbWFzayA9IDB4MDAw
MGZmYmY7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3N5c194ODZfNjQuYyBiL2FyY2gv
eDg2L2tlcm5lbC9zeXNfeDg2XzY0LmMNCmluZGV4IDA1MTQ4OTAuLmNkYjJmYzkgMTAwNjQ0DQot
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvc3lzX3g4Nl82NC5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwv
c3lzX3g4Nl82NC5jDQpAQCAtMTE1LDcgKzExNSw3IEBAIHN0YXRpYyB2b2lkIGZpbmRfc3RhcnRf
ZW5kKHVuc2lnbmVkIGxvbmcgZmxhZ3MsIHVuc2lnbmVkIGxvbmcgKmJlZ2luLA0KIAkJCQkqYmVn
aW4gPSBuZXdfYmVnaW47DQogCQl9DQogCX0gZWxzZSB7DQotCQkqYmVnaW4gPSBUQVNLX1VOTUFQ
UEVEX0JBU0U7DQorCQkqYmVnaW4gPSBjdXJyZW50LT5tbS0+bW1hcF9sZWdhY3lfYmFzZTsNCiAJ
CSplbmQgPSBUQVNLX1NJWkU7DQogCX0NCiB9DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvbW0vbW1h
cC5jIGIvYXJjaC94ODYvbW0vbW1hcC5jDQppbmRleCA4NDVkZjY4Li41YzFhZTI4IDEwMDY0NA0K
LS0tIGEvYXJjaC94ODYvbW0vbW1hcC5jDQorKysgYi9hcmNoL3g4Ni9tbS9tbWFwLmMNCkBAIC0x
MTIsMTIgKzExMiwxNCBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBtbWFwX2xlZ2FjeV9iYXNlKHZv
aWQpDQogICovDQogdm9pZCBhcmNoX3BpY2tfbW1hcF9sYXlvdXQoc3RydWN0IG1tX3N0cnVjdCAq
bW0pDQogew0KKwltbS0+bW1hcF9sZWdhY3lfYmFzZSA9IG1tYXBfbGVnYWN5X2Jhc2UoKTsNCisJ
bW0tPm1tYXBfYmFzZSA9IG1tYXBfYmFzZSgpOw0KKw0KIAlpZiAobW1hcF9pc19sZWdhY3koKSkg
ew0KLQkJbW0tPm1tYXBfYmFzZSA9IG1tYXBfbGVnYWN5X2Jhc2UoKTsNCisJCW1tLT5tbWFwX2Jh
c2UgPSBtbS0+bW1hcF9sZWdhY3lfYmFzZTsNCiAJCW1tLT5nZXRfdW5tYXBwZWRfYXJlYSA9IGFy
Y2hfZ2V0X3VubWFwcGVkX2FyZWE7DQogCQltbS0+dW5tYXBfYXJlYSA9IGFyY2hfdW5tYXBfYXJl
YTsNCiAJfSBlbHNlIHsNCi0JCW1tLT5tbWFwX2Jhc2UgPSBtbWFwX2Jhc2UoKTsNCiAJCW1tLT5n
ZXRfdW5tYXBwZWRfYXJlYSA9IGFyY2hfZ2V0X3VubWFwcGVkX2FyZWFfdG9wZG93bjsNCiAJCW1t
LT51bm1hcF9hcmVhID0gYXJjaF91bm1hcF9hcmVhX3RvcGRvd247DQogCX0NCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni94ZW4vc2V0dXAuYyBiL2FyY2gveDg2L3hlbi9zZXR1cC5jDQppbmRleCA2ZTVh
N2YxLi40ZDU0YjM4IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYveGVuL3NldHVwLmMNCisrKyBiL2Fy
Y2gveDg2L3hlbi9zZXR1cC5jDQpAQCAtMjEyLDYgKzIxMiwxNyBAQCBzdGF0aWMgdm9pZCB4ZW5f
YWxpZ25fYW5kX2FkZF9lODIwX3JlZ2lvbih1NjQgc3RhcnQsIHU2NCBzaXplLCBpbnQgdHlwZSkN
CiAJZTgyMF9hZGRfcmVnaW9uKHN0YXJ0LCBlbmQgLSBzdGFydCwgdHlwZSk7DQogfQ0KIA0KK3Zv
aWQgeGVuX2lnbm9yZV91bnVzYWJsZShzdHJ1Y3QgZTgyMGVudHJ5ICpsaXN0LCBzaXplX3QgbWFw
X3NpemUpDQorew0KKwlzdHJ1Y3QgZTgyMGVudHJ5ICplbnRyeTsNCisJdW5zaWduZWQgaW50IGk7
DQorDQorCWZvciAoaSA9IDAsIGVudHJ5ID0gbGlzdDsgaSA8IG1hcF9zaXplOyBpKyssIGVudHJ5
KyspIHsNCisJCWlmIChlbnRyeS0+dHlwZSA9PSBFODIwX1VOVVNBQkxFKQ0KKwkJCWVudHJ5LT50
eXBlID0gRTgyMF9SQU07DQorCX0NCit9DQorDQogLyoqDQogICogbWFjaGluZV9zcGVjaWZpY19t
ZW1vcnlfc2V0dXAgLSBIb29rIGZvciBtYWNoaW5lIHNwZWNpZmljIG1lbW9yeSBzZXR1cC4NCiAg
KiovDQpAQCAtMjUwLDYgKzI2MSwxNyBAQCBjaGFyICogX19pbml0IHhlbl9tZW1vcnlfc2V0dXAo
dm9pZCkNCiAJfQ0KIAlCVUdfT04ocmMpOw0KIA0KKwkvKg0KKwkgKiBYZW4gd29uJ3QgYWxsb3cg
YSAxOjEgbWFwcGluZyB0byBiZSBjcmVhdGVkIHRvIFVOVVNBQkxFDQorCSAqIHJlZ2lvbnMsIHNv
IGlmIHdlJ3JlIHVzaW5nIHRoZSBtYWNoaW5lIG1lbW9yeSBtYXAgbGVhdmUgdGhlDQorCSAqIHJl
Z2lvbiBhcyBSQU0gYXMgaXQgaXMgaW4gdGhlIHBzZXVkby1waHlzaWNhbCBtYXAuDQorCSAqDQor
CSAqIFVOVVNBQkxFIHJlZ2lvbnMgaW4gZG9tVXMgYXJlIG5vdCBoYW5kbGVkIGFuZCB3aWxsIG5l
ZWQNCisJICogYSBwYXRjaCBpbiB0aGUgZnV0dXJlLg0KKwkgKi8NCisJaWYgKHhlbl9pbml0aWFs
X2RvbWFpbigpKQ0KKwkJeGVuX2lnbm9yZV91bnVzYWJsZShtYXAsIG1lbW1hcC5ucl9lbnRyaWVz
KTsNCisNCiAJLyogTWFrZSBzdXJlIHRoZSBYZW4tc3VwcGxpZWQgbWVtb3J5IG1hcCBpcyB3ZWxs
LW9yZGVyZWQuICovDQogCXNhbml0aXplX2U4MjBfbWFwKG1hcCwgbWVtbWFwLm5yX2VudHJpZXMs
ICZtZW1tYXAubnJfZW50cmllcyk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL2JhdHRl
cnkuYyBiL2RyaXZlcnMvYWNwaS9iYXR0ZXJ5LmMNCmluZGV4IGExYTRiOGUuLmM3NDliOTMgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL2FjcGkvYmF0dGVyeS5jDQorKysgYi9kcml2ZXJzL2FjcGkvYmF0
dGVyeS5jDQpAQCAtMTE3LDYgKzExNyw3IEBAIHN0cnVjdCBhY3BpX2JhdHRlcnkgew0KIAlzdHJ1
Y3QgYWNwaV9kZXZpY2UgKmRldmljZTsNCiAJc3RydWN0IG5vdGlmaWVyX2Jsb2NrIHBtX25iOw0K
IAl1bnNpZ25lZCBsb25nIHVwZGF0ZV90aW1lOw0KKwlpbnQgcmV2aXNpb247DQogCWludCByYXRl
X25vdzsNCiAJaW50IGNhcGFjaXR5X25vdzsNCiAJaW50IHZvbHRhZ2Vfbm93Ow0KQEAgLTM1MCw2
ICszNTEsNyBAQCBzdGF0aWMgc3RydWN0IGFjcGlfb2Zmc2V0cyBpbmZvX29mZnNldHNbXSA9IHsN
CiB9Ow0KIA0KIHN0YXRpYyBzdHJ1Y3QgYWNwaV9vZmZzZXRzIGV4dGVuZGVkX2luZm9fb2Zmc2V0
c1tdID0gew0KKwl7b2Zmc2V0b2Yoc3RydWN0IGFjcGlfYmF0dGVyeSwgcmV2aXNpb24pLCAwfSwN
CiAJe29mZnNldG9mKHN0cnVjdCBhY3BpX2JhdHRlcnksIHBvd2VyX3VuaXQpLCAwfSwNCiAJe29m
ZnNldG9mKHN0cnVjdCBhY3BpX2JhdHRlcnksIGRlc2lnbl9jYXBhY2l0eSksIDB9LA0KIAl7b2Zm
c2V0b2Yoc3RydWN0IGFjcGlfYmF0dGVyeSwgZnVsbF9jaGFyZ2VfY2FwYWNpdHkpLCAwfSwNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9LY29uZmlnIGIvZHJpdmVycy9hdGEvS2NvbmZpZw0KaW5k
ZXggY2YwNDdjNC4uZTdiM2E5ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRhL0tjb25maWcNCisr
KyBiL2RyaXZlcnMvYXRhL0tjb25maWcNCkBAIC05Myw3ICs5Myw3IEBAIGNvbmZpZyBTQVRBX0ZT
TA0KIAkgIElmIHVuc3VyZSwgc2F5IE4uDQogDQogY29uZmlnIFNBVEFfSU5JQzE2MlgNCi0JdHJp
c3RhdGUgIkluaXRpbyAxNjJ4IFNBVEEgc3VwcG9ydCINCisJdHJpc3RhdGUgIkluaXRpbyAxNjJ4
IFNBVEEgc3VwcG9ydCAoVmVyeSBFeHBlcmltZW50YWwpIg0KIAlkZXBlbmRzIG9uIFBDSQ0KIAlo
ZWxwDQogCSAgVGhpcyBvcHRpb24gZW5hYmxlcyBzdXBwb3J0IGZvciBJbml0aW8gMTYyeCBTZXJp
YWwgQVRBLg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1wbXAuYyBiL2RyaXZlcnMv
YXRhL2xpYmF0YS1wbXAuYw0KaW5kZXggZjYzYTU4OC4uZjVjMzViZSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvYXRhL2xpYmF0YS1wbXAuYw0KKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLXBtcC5jDQpA
QCAtMjg5LDI0ICsyODksMjQgQEAgc3RhdGljIGludCBzYXRhX3BtcF9jb25maWd1cmUoc3RydWN0
IGF0YV9kZXZpY2UgKmRldiwgaW50IHByaW50X2luZm8pDQogDQogCS8qIERpc2FibGUgc2VuZGlu
ZyBFYXJseSBSX09LLg0KIAkgKiBXaXRoICJjYWNoZWQgcmVhZCIgSEREIHRlc3RpbmcgYW5kIG11
bHRpcGxlIHBvcnRzIGJ1c3kgb24gYSBTQVRBDQotCSAqIGhvc3QgY29udHJvbGxlciwgMzcyNiBQ
TVAgd2lsbCB2ZXJ5IHJhcmVseSBkcm9wIGEgZGVmZXJyZWQNCisJICogaG9zdCBjb250cm9sbGVy
LCAzeDI2IFBNUCB3aWxsIHZlcnkgcmFyZWx5IGRyb3AgYSBkZWZlcnJlZA0KIAkgKiBSX09LIHRo
YXQgd2FzIGludGVuZGVkIGZvciB0aGUgaG9zdC4gU3ltcHRvbSB3aWxsIGJlIGFsbA0KIAkgKiA1
IGRyaXZlcyB1bmRlciB0ZXN0IHdpbGwgdGltZW91dCwgZ2V0IHJlc2V0LCBhbmQgcmVjb3Zlci4N
CiAJICovDQotCWlmICh2ZW5kb3IgPT0gMHgxMDk1ICYmIGRldmlkID09IDB4MzcyNikgew0KKwlp
ZiAodmVuZG9yID09IDB4MTA5NSAmJiAoZGV2aWQgPT0gMHgzNzI2IHx8IGRldmlkID09IDB4Mzgy
NikpIHsNCiAJCXUzMiByZWc7DQogDQogCQllcnJfbWFzayA9IHNhdGFfcG1wX3JlYWQoJmFwLT5s
aW5rLCBQTVBfR1NDUl9TSUlfUE9MLCAmcmVnKTsNCiAJCWlmIChlcnJfbWFzaykgew0KIAkJCXJj
ID0gLUVJTzsNCi0JCQlyZWFzb24gPSAiZmFpbGVkIHRvIHJlYWQgU2lsMzcyNiBQcml2YXRlIFJl
Z2lzdGVyIjsNCisJCQlyZWFzb24gPSAiZmFpbGVkIHRvIHJlYWQgU2lsM3gyNiBQcml2YXRlIFJl
Z2lzdGVyIjsNCiAJCQlnb3RvIGZhaWw7DQogCQl9DQogCQlyZWcgJj0gfjB4MTsNCiAJCWVycl9t
YXNrID0gc2F0YV9wbXBfd3JpdGUoJmFwLT5saW5rLCBQTVBfR1NDUl9TSUlfUE9MLCByZWcpOw0K
IAkJaWYgKGVycl9tYXNrKSB7DQogCQkJcmMgPSAtRUlPOw0KLQkJCXJlYXNvbiA9ICJmYWlsZWQg
dG8gd3JpdGUgU2lsMzcyNiBQcml2YXRlIFJlZ2lzdGVyIjsNCisJCQlyZWFzb24gPSAiZmFpbGVk
IHRvIHdyaXRlIFNpbDN4MjYgUHJpdmF0ZSBSZWdpc3RlciI7DQogCQkJZ290byBmYWlsOw0KIAkJ
fQ0KIAl9DQpAQCAtMzgzLDggKzM4Myw4IEBAIHN0YXRpYyB2b2lkIHNhdGFfcG1wX3F1aXJrcyhz
dHJ1Y3QgYXRhX3BvcnQgKmFwKQ0KIAl1MTYgZGV2aWQgPSBzYXRhX3BtcF9nc2NyX2RldmlkKGdz
Y3IpOw0KIAlzdHJ1Y3QgYXRhX2xpbmsgKmxpbms7DQogDQotCWlmICh2ZW5kb3IgPT0gMHgxMDk1
ICYmIGRldmlkID09IDB4MzcyNikgew0KLQkJLyogc2lsMzcyNiBxdWlya3MgKi8NCisJaWYgKHZl
bmRvciA9PSAweDEwOTUgJiYgKGRldmlkID09IDB4MzcyNiB8fCBkZXZpZCA9PSAweDM4MjYpKSB7
DQorCQkvKiBzaWwzeDI2IHF1aXJrcyAqLw0KIAkJYXRhX2Zvcl9lYWNoX2xpbmsobGluaywgYXAs
IEVER0UpIHsNCiAJCQkvKiBsaW5rIHJlcG9ydHMgb2ZmbGluZSBhZnRlciBMUE0gKi8NCiAJCQls
aW5rLT5mbGFncyB8PSBBVEFfTEZMQUdfTk9fTFBNOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRh
L3NhdGFfaW5pYzE2MnguYyBiL2RyaXZlcnMvYXRhL3NhdGFfaW5pYzE2MnguYw0KaW5kZXggNWM3
ZDcwYy4uM2E4YjU1ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRhL3NhdGFfaW5pYzE2MnguYw0K
KysrIGIvZHJpdmVycy9hdGEvc2F0YV9pbmljMTYyeC5jDQpAQCAtNiw2ICs2LDE4IEBADQogICoN
CiAgKiBUaGlzIGZpbGUgaXMgcmVsZWFzZWQgdW5kZXIgR1BMIHYyLg0KICAqDQorICogKioqKiBX
QVJOSU5HICoqKioNCisgKg0KKyAqIFRoaXMgZHJpdmVyIG5ldmVyIHdvcmtlZCBwcm9wZXJseSBh
bmQgdW5mb3J0dW5hdGVseSBkYXRhIGNvcnJ1cHRpb24gaXMNCisgKiByZWxhdGl2ZWx5IGNvbW1v
bi4gIFRoZXJlIGlzbid0IGFueW9uZSB3b3JraW5nIG9uIHRoZSBkcml2ZXIgYW5kIHRoZXJlJ3MN
CisgKiBubyBzdXBwb3J0IGZyb20gdGhlIHZlbmRvci4gIERvIG5vdCB1c2UgdGhpcyBkcml2ZXIg
aW4gYW55IHByb2R1Y3Rpb24NCisgKiBlbnZpcm9ubWVudC4NCisgKg0KKyAqIGh0dHA6Ly90aHJl
YWQuZ21hbmUub3JnL2dtYW5lLmxpbnV4LmRlYmlhbi5kZXZlbC5idWdzLnJjLzM3ODUyNS9mb2N1
cz01NDQ5MQ0KKyAqIGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9
NjA1NjUNCisgKg0KKyAqICoqKioqKioqKioqKioqKioqDQorICoNCiAgKiBUaGlzIGNvbnRyb2xs
ZXIgaXMgZWNjZW50cmljIGFuZCBlYXNpbHkgbG9ja3MgdXAgaWYgc29tZXRoaW5nIGlzbid0DQog
ICogcmlnaHQuICBEb2N1bWVudGF0aW9uIGlzIGF2YWlsYWJsZSBhdCBpbml0aW8ncyB3ZWJzaXRl
IGJ1dCBpdCBvbmx5DQogICogZG9jdW1lbnRzIHJlZ2lzdGVycyAobm90IHByb2dyYW1taW5nIG1v
ZGVsKS4NCkBAIC04MDksNiArODIxLDggQEAgc3RhdGljIGludCBpbmljX2luaXRfb25lKHN0cnVj
dCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KIA0KIAlh
dGFfcHJpbnRfdmVyc2lvbl9vbmNlKCZwZGV2LT5kZXYsIERSVl9WRVJTSU9OKTsNCiANCisJZGV2
X2FsZXJ0KCZwZGV2LT5kZXYsICJpbmljMTYyeCBzdXBwb3J0IGlzIGJyb2tlbiB3aXRoIGNvbW1v
biBkYXRhIGNvcnJ1cHRpb24gaXNzdWVzIGFuZCB3aWxsIGJlIGRpc2FibGVkIGJ5IGRlZmF1bHQs
IGNvbnRhY3QgbGludXgtaWRlQHZnZXIua2VybmVsLm9yZyBpZiBpbiBwcm9kdWN0aW9uIHVzZVxu
Iik7DQorDQogCS8qIGFsbG9jIGhvc3QgKi8NCiAJaG9zdCA9IGF0YV9ob3N0X2FsbG9jX3BpbmZv
KCZwZGV2LT5kZXYsIHBwaSwgTlJfUE9SVFMpOw0KIAlocHJpdiA9IGRldm1fa3phbGxvYygmcGRl
di0+ZGV2LCBzaXplb2YoKmhwcml2KSwgR0ZQX0tFUk5FTCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9iYXNlL21lbW9yeS5jIGIvZHJpdmVycy9iYXNlL21lbW9yeS5jDQppbmRleCA4MjcyZDkyLi43
MzJhZDBkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9iYXNlL21lbW9yeS5jDQorKysgYi9kcml2ZXJz
L2Jhc2UvbWVtb3J5LmMNCkBAIC0xNzIsNiArMTcyLDggQEAgc3RhdGljIHNzaXplX3Qgc2hvd19t
ZW1fcmVtb3ZhYmxlKHN0cnVjdCBzeXNfZGV2aWNlICpkZXYsDQogCQljb250YWluZXJfb2YoZGV2
LCBzdHJ1Y3QgbWVtb3J5X2Jsb2NrLCBzeXNkZXYpOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgc2Vj
dGlvbnNfcGVyX2Jsb2NrOyBpKyspIHsNCisJCWlmICghcHJlc2VudF9zZWN0aW9uX25yKG1lbS0+
c3RhcnRfc2VjdGlvbl9uciArIGkpKQ0KKwkJCWNvbnRpbnVlOw0KIAkJcGZuID0gc2VjdGlvbl9u
cl90b19wZm4obWVtLT5zdGFydF9zZWN0aW9uX25yICsgaSk7DQogCQlyZXQgJj0gaXNfbWVtX3Nl
Y3Rpb25fcmVtb3ZhYmxlKHBmbiwgUEFHRVNfUEVSX1NFQ1RJT04pOw0KIAl9DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9iYXNlL3Bvd2VyL2RvbWFpbi5jIGIvZHJpdmVycy9iYXNlL3Bvd2VyL2RvbWFp
bi5jDQppbmRleCA3OTAzOGU1Li42NzkwY2Y3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9iYXNlL3Bv
d2VyL2RvbWFpbi5jDQorKysgYi9kcml2ZXJzL2Jhc2UvcG93ZXIvZG9tYWluLmMNCkBAIC03NTEs
OCArNzUxLDcgQEAgc3RhdGljIGludCBwbV9nZW5wZF9yZXN1bWVfbm9pcnEoc3RydWN0IGRldmlj
ZSAqZGV2KQ0KIAlpZiAoSVNfRVJSKGdlbnBkKSkNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KLQlp
ZiAoZ2VucGQtPnN1c3BlbmRfcG93ZXJfb2ZmDQotCSAgICB8fCAoZGV2LT5wb3dlci53YWtldXBf
cGF0aCAmJiBnZW5wZF9kZXZfYWN0aXZlX3dha2V1cChnZW5wZCwgZGV2KSkpDQorCWlmIChnZW5w
ZC0+c3VzcGVuZF9wb3dlcl9vZmYpDQogCQlyZXR1cm4gMDsNCiANCiAJLyoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2JsdWV0b290aC9hdGgzay5jIGIvZHJpdmVycy9ibHVldG9vdGgvYXRoM2suYw0K
aW5kZXggODUzZmRmOC4uYmRlNzJmNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmx1ZXRvb3RoL2F0
aDNrLmMNCisrKyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2F0aDNrLmMNCkBAIC04OSw2ICs4OSwxMSBA
QCBzdGF0aWMgc3RydWN0IHVzYl9kZXZpY2VfaWQgYXRoM2tfdGFibGVbXSA9IHsNCiAJeyBVU0Jf
REVWSUNFKDB4MTNkMywgMHgzMzkzKSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNGUp
IH0sDQogCXsgVVNCX0RFVklDRSgweDA0ODksIDB4ZTA1NikgfSwNCisJeyBVU0JfREVWSUNFKDB4
MDQ4OSwgMHhlMDRkKSB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNGM1LCAweDEzMzApIH0sDQorCXsg
VVNCX0RFVklDRSgweDEzZDMsIDB4MzQwMikgfSwNCisJeyBVU0JfREVWSUNFKDB4MGNmMywgMHgz
MTIxKSB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwY2YzLCAweGUwMDMpIH0sDQogDQogCS8qIEF0aGVy
b3MgQVI1QkJVMTIgd2l0aCBzZmxhc2ggZmlybXdhcmUgKi8NCiAJeyBVU0JfREVWSUNFKDB4MDQ4
OSwgMHhFMDJDKSB9LA0KQEAgLTEyNSw2ICsxMzAsMTEgQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2
aWNlX2lkIGF0aDNrX2JsaXN0X3RibFtdID0gew0KIAl7IFVTQl9ERVZJQ0UoMHgxM2QzLCAweDMz
OTMpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNCX0RFVklDRSgweDA0
ODksIDB4ZTA0ZSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVW
SUNFKDB4MDQ4OSwgMHhlMDU2KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7
IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNGQpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEy
IH0sDQorCXsgVVNCX0RFVklDRSgweDA0YzUsIDB4MTMzMCksIC5kcml2ZXJfaW5mbyA9IEJUVVNC
X0FUSDMwMTIgfSwNCisJeyBVU0JfREVWSUNFKDB4MTNkMywgMHgzNDAyKSwgLmRyaXZlcl9pbmZv
ID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwY2YzLCAweDMxMjEpLCAuZHJp
dmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDBjZjMsIDB4ZTAw
MyksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiANCiAJLyogQXRoZXJvcyBBUjVC
QlUyMiB3aXRoIHNmbGFzaCBmaXJtd2FyZSAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweEUw
M0MpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9ibHVldG9vdGgvYnR1c2IuYyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2J0dXNiLmMNCmluZGV4IDZi
Nzg0YjcuLjFiZDM5MjQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2JsdWV0b290aC9idHVzYi5jDQor
KysgYi9kcml2ZXJzL2JsdWV0b290aC9idHVzYi5jDQpAQCAtNjMsNiArNjMsOSBAQCBzdGF0aWMg
c3RydWN0IHVzYl9kZXZpY2VfaWQgYnR1c2JfdGFibGVbXSA9IHsNCiAJLyogQXBwbGUtc3BlY2lm
aWMgKEJyb2FkY29tKSBkZXZpY2VzICovDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lO
Rk8oMHgwNWFjLCAweGZmLCAweDAxLCAweDAxKSB9LA0KIA0KKwkvKiBNZWRpYVRlayBNVDc2eDBF
ICovDQorCXsgVVNCX0RFVklDRSgweDBlOGQsIDB4NzYzZikgfSwNCisNCiAJLyogQnJvYWRjb20g
U29mdFNhaWxpbmcgcmVwb3J0aW5nIHZlbmRvciBzcGVjaWZpYyAqLw0KIAl7IFVTQl9ERVZJQ0Uo
MHgwYTVjLCAweDIxZTEpIH0sDQogDQpAQCAtMTU2LDYgKzE1OSwxMSBAQCBzdGF0aWMgc3RydWN0
IHVzYl9kZXZpY2VfaWQgYmxhY2tsaXN0X3RhYmxlW10gPSB7DQogCXsgVVNCX0RFVklDRSgweDEz
ZDMsIDB4MzM5MyksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVW
SUNFKDB4MDQ4OSwgMHhlMDRlKSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7
IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNTYpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEy
IH0sDQorCXsgVVNCX0RFVklDRSgweDA0ODksIDB4ZTA0ZCksIC5kcml2ZXJfaW5mbyA9IEJUVVNC
X0FUSDMwMTIgfSwNCisJeyBVU0JfREVWSUNFKDB4MDRjNSwgMHgxMzMwKSwgLmRyaXZlcl9pbmZv
ID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgxM2QzLCAweDM0MDIpLCAuZHJp
dmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDBjZjMsIDB4MzEy
MSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCisJeyBVU0JfREVWSUNFKDB4MGNm
MywgMHhlMDAzKSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIA0KIAkvKiBBdGhl
cm9zIEFSNUJCVTEyIHdpdGggc2ZsYXNoIGZpcm13YXJlICovDQogCXsgVVNCX0RFVklDRSgweDA0
ODksIDB4ZTAyYyksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0lHTk9SRSB9LA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvY2hhci92aXJ0aW9fY29uc29sZS5jIGIvZHJpdmVycy9jaGFyL3ZpcnRpb19jb25z
b2xlLmMNCmluZGV4IGQ1YWU3MzYuLmM2OGI4YWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIv
dmlydGlvX2NvbnNvbGUuYw0KKysrIGIvZHJpdmVycy9jaGFyL3ZpcnRpb19jb25zb2xlLmMNCkBA
IC0yNTcsOSArMjU3LDEyIEBAIHN0YXRpYyBzdHJ1Y3QgcG9ydCAqZmluZF9wb3J0X2J5X2RldnRf
aW5fcG9ydGRldihzdHJ1Y3QgcG9ydHNfZGV2aWNlICpwb3J0ZGV2LA0KIAl1bnNpZ25lZCBsb25n
IGZsYWdzOw0KIA0KIAlzcGluX2xvY2tfaXJxc2F2ZSgmcG9ydGRldi0+cG9ydHNfbG9jaywgZmxh
Z3MpOw0KLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHBvcnQsICZwb3J0ZGV2LT5wb3J0cywgbGlzdCkN
Ci0JCWlmIChwb3J0LT5jZGV2LT5kZXYgPT0gZGV2KQ0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHBv
cnQsICZwb3J0ZGV2LT5wb3J0cywgbGlzdCkgew0KKwkJaWYgKHBvcnQtPmNkZXYtPmRldiA9PSBk
ZXYpIHsNCisJCQlrcmVmX2dldCgmcG9ydC0+a3JlZik7DQogCQkJZ290byBvdXQ7DQorCQl9DQor
CX0NCiAJcG9ydCA9IE5VTEw7DQogb3V0Og0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwb3J0
ZGV2LT5wb3J0c19sb2NrLCBmbGFncyk7DQpAQCAtNjM0LDYgKzYzNywxMCBAQCBzdGF0aWMgc3Np
emVfdCBwb3J0X2ZvcHNfcmVhZChzdHJ1Y3QgZmlsZSAqZmlscCwgY2hhciBfX3VzZXIgKnVidWYs
DQogDQogCXBvcnQgPSBmaWxwLT5wcml2YXRlX2RhdGE7DQogDQorCS8qIFBvcnQgaXMgaG90LXVu
cGx1Z2dlZC4gKi8NCisJaWYgKCFwb3J0LT5ndWVzdF9jb25uZWN0ZWQpDQorCQlyZXR1cm4gLUVO
T0RFVjsNCisNCiAJaWYgKCFwb3J0X2hhc19kYXRhKHBvcnQpKSB7DQogCQkvKg0KIAkJICogSWYg
bm90aGluZydzIGNvbm5lY3RlZCBvbiB0aGUgaG9zdCBqdXN0IHJldHVybiAwIGluDQpAQCAtNjUw
LDcgKzY1Nyw3IEBAIHN0YXRpYyBzc2l6ZV90IHBvcnRfZm9wc19yZWFkKHN0cnVjdCBmaWxlICpm
aWxwLCBjaGFyIF9fdXNlciAqdWJ1ZiwNCiAJCWlmIChyZXQgPCAwKQ0KIAkJCXJldHVybiByZXQ7
DQogCX0NCi0JLyogUG9ydCBnb3QgaG90LXVucGx1Z2dlZC4gKi8NCisJLyogUG9ydCBnb3QgaG90
LXVucGx1Z2dlZCB3aGlsZSB3ZSB3ZXJlIHdhaXRpbmcgYWJvdmUuICovDQogCWlmICghcG9ydC0+
Z3Vlc3RfY29ubmVjdGVkKQ0KIAkJcmV0dXJuIC1FTk9ERVY7DQogCS8qDQpAQCAtNzkzLDE0ICs4
MDAsMTQgQEAgc3RhdGljIGludCBwb3J0X2ZvcHNfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBz
dHJ1Y3QgZmlsZSAqZmlscCkNCiAJc3RydWN0IHBvcnQgKnBvcnQ7DQogCWludCByZXQ7DQogDQor
CS8qIFdlIGdldCB0aGUgcG9ydCB3aXRoIGEga3JlZiBoZXJlICovDQogCXBvcnQgPSBmaW5kX3Bv
cnRfYnlfZGV2dChjZGV2LT5kZXYpOw0KKwlpZiAoIXBvcnQpIHsNCisJCS8qIFBvcnQgd2FzIHVu
cGx1Z2dlZCBiZWZvcmUgd2UgY291bGQgcHJvY2VlZCAqLw0KKwkJcmV0dXJuIC1FTlhJTzsNCisJ
fQ0KIAlmaWxwLT5wcml2YXRlX2RhdGEgPSBwb3J0Ow0KIA0KLQkvKiBQcmV2ZW50IGFnYWluc3Qg
YSBwb3J0IGdldHRpbmcgaG90LXVucGx1Z2dlZCBhdCB0aGUgc2FtZSB0aW1lICovDQotCXNwaW5f
bG9ja19pcnEoJnBvcnQtPnBvcnRkZXYtPnBvcnRzX2xvY2spOw0KLQlrcmVmX2dldCgmcG9ydC0+
a3JlZik7DQotCXNwaW5fdW5sb2NrX2lycSgmcG9ydC0+cG9ydGRldi0+cG9ydHNfbG9jayk7DQot
DQogCS8qDQogCSAqIERvbid0IGFsbG93IG9wZW5pbmcgb2YgY29uc29sZSBwb3J0IGRldmljZXMg
LS0gdGhhdCdzIGRvbmUNCiAJICogdmlhIC9kZXYvaHZjDQpAQCAtMTI2NCwxNCArMTI3MSw2IEBA
IHN0YXRpYyB2b2lkIHJlbW92ZV9wb3J0KHN0cnVjdCBrcmVmICprcmVmKQ0KIA0KIAlwb3J0ID0g
Y29udGFpbmVyX29mKGtyZWYsIHN0cnVjdCBwb3J0LCBrcmVmKTsNCiANCi0Jc3lzZnNfcmVtb3Zl
X2dyb3VwKCZwb3J0LT5kZXYtPmtvYmosICZwb3J0X2F0dHJpYnV0ZV9ncm91cCk7DQotCWRldmlj
ZV9kZXN0cm95KHBkcnZkYXRhLmNsYXNzLCBwb3J0LT5kZXYtPmRldnQpOw0KLQljZGV2X2RlbChw
b3J0LT5jZGV2KTsNCi0NCi0Ja2ZyZWUocG9ydC0+bmFtZSk7DQotDQotCWRlYnVnZnNfcmVtb3Zl
KHBvcnQtPmRlYnVnZnNfZmlsZSk7DQotDQogCWtmcmVlKHBvcnQpOw0KIH0NCiANCkBAIC0xMjg5
LDEyICsxMjg4LDE0IEBAIHN0YXRpYyB2b2lkIHVucGx1Z19wb3J0KHN0cnVjdCBwb3J0ICpwb3J0
KQ0KIAlzcGluX3VubG9ja19pcnEoJnBvcnQtPnBvcnRkZXYtPnBvcnRzX2xvY2spOw0KIA0KIAlp
ZiAocG9ydC0+Z3Vlc3RfY29ubmVjdGVkKSB7DQorCQkvKiBMZXQgdGhlIGFwcCBrbm93IHRoZSBw
b3J0IGlzIGdvaW5nIGRvd24uICovDQorCQlzZW5kX3NpZ2lvX3RvX3BvcnQocG9ydCk7DQorDQor
CQkvKiBEbyB0aGlzIGFmdGVyIHNpZ2lvIGlzIGFjdHVhbGx5IHNlbnQgKi8NCiAJCXBvcnQtPmd1
ZXN0X2Nvbm5lY3RlZCA9IGZhbHNlOw0KIAkJcG9ydC0+aG9zdF9jb25uZWN0ZWQgPSBmYWxzZTsN
Ci0JCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcG9ydC0+d2FpdHF1ZXVlKTsNCiANCi0JCS8qIExl
dCB0aGUgYXBwIGtub3cgdGhlIHBvcnQgaXMgZ29pbmcgZG93bi4gKi8NCi0JCXNlbmRfc2lnaW9f
dG9fcG9ydChwb3J0KTsNCisJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcG9ydC0+d2FpdHF1ZXVl
KTsNCiAJfQ0KIA0KIAlpZiAoaXNfY29uc29sZV9wb3J0KHBvcnQpKSB7DQpAQCAtMTMyMCw2ICsx
MzIxLDE0IEBAIHN0YXRpYyB2b2lkIHVucGx1Z19wb3J0KHN0cnVjdCBwb3J0ICpwb3J0KQ0KIAkg
Ki8NCiAJcG9ydC0+cG9ydGRldiA9IE5VTEw7DQogDQorCXN5c2ZzX3JlbW92ZV9ncm91cCgmcG9y
dC0+ZGV2LT5rb2JqLCAmcG9ydF9hdHRyaWJ1dGVfZ3JvdXApOw0KKwlkZXZpY2VfZGVzdHJveShw
ZHJ2ZGF0YS5jbGFzcywgcG9ydC0+ZGV2LT5kZXZ0KTsNCisJY2Rldl9kZWwocG9ydC0+Y2Rldik7
DQorDQorCWtmcmVlKHBvcnQtPm5hbWUpOw0KKw0KKwlkZWJ1Z2ZzX3JlbW92ZShwb3J0LT5kZWJ1
Z2ZzX2ZpbGUpOw0KKw0KIAkvKg0KIAkgKiBMb2NrcyBhcm91bmQgaGVyZSBhcmUgbm90IG5lY2Vz
c2FyeSAtIGEgcG9ydCBjYW4ndCBiZQ0KIAkgKiBvcGVuZWQgYWZ0ZXIgd2UgcmVtb3ZlZCB0aGUg
cG9ydCBzdHJ1Y3QgZnJvbSBwb3J0c19saXN0DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJt
L2k5MTUvaTkxNV9kcnYuaCBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmgNCmluZGV4
IDE0NGQzN2MuLjYxMjc0YmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1
X2Rydi5oDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2Rydi5oDQpAQCAtMjc1LDYg
KzI3NSw3IEBAIGVudW0gaW50ZWxfcGNoIHsNCiAjZGVmaW5lIFFVSVJLX1BJUEVBX0ZPUkNFICgx
PDwwKQ0KICNkZWZpbmUgUVVJUktfTFZEU19TU0NfRElTQUJMRSAoMTw8MSkNCiAjZGVmaW5lIFFV
SVJLX0lOVkVSVF9CUklHSFRORVNTICgxPDwyKQ0KKyNkZWZpbmUgUVVJUktfTk9fUENIX1BXTV9F
TkFCTEUgKDE8PDMpDQogDQogc3RydWN0IGludGVsX2ZiZGV2Ow0KIHN0cnVjdCBpbnRlbF9mYmNf
d29yazsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X3JlZy5oIGIvZHJp
dmVycy9ncHUvZHJtL2k5MTUvaTkxNV9yZWcuaA0KaW5kZXggMTI0ZGQ4Ny4uOTdhMDUwZiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfcmVnLmgNCisrKyBiL2RyaXZlcnMv
Z3B1L2RybS9pOTE1L2k5MTVfcmVnLmgNCkBAIC0zNjIsNiArMzYyLDcgQEANCiAjZGVmaW5lIElQ
RUlSX0k5NjUJMHgwMjA2NA0KICNkZWZpbmUgSVBFSFJfSTk2NQkweDAyMDY4DQogI2RlZmluZSBJ
TlNURE9ORV9JOTY1CTB4MDIwNmMNCisjZGVmaW5lIFJJTkdfSU5TVFBNKGJhc2UpICAgICAgKChi
YXNlKSsweGMwKQ0KICNkZWZpbmUgSU5TVFBTCQkweDAyMDcwIC8qIDk2NSsgb25seSAqLw0KICNk
ZWZpbmUgSU5TVERPTkUxCTB4MDIwN2MgLyogOTY1KyBvbmx5ICovDQogI2RlZmluZSBBQ1RIRF9J
OTY1CTB4MDIwNzQNCkBAIC00NTgsNiArNDU5LDggQEANCiAJCQkJCXdpbGwgbm90IGFzc2VydCBB
R1BCVVNZIyBhbmQgd2lsbCBvbmx5DQogCQkJCQliZSBkZWxpdmVyZWQgd2hlbiBvdXQgb2YgQzMu
ICovDQogI2RlZmluZSAgIElOU1RQTV9GT1JDRV9PUkRFUklORwkJCQkoMTw8NykgLyogR0VONisg
Ki8NCisjZGVmaW5lICAgSU5TVFBNX1RMQl9JTlZBTElEQVRFCSgxPDw5KQ0KKyNkZWZpbmUgICBJ
TlNUUE1fU1lOQ19GTFVTSAkoMTw8NSkNCiAjZGVmaW5lIEFDVEhECSAgICAgICAgMHgwMjBjOA0K
ICNkZWZpbmUgRldfQkxDCQkweDAyMGQ4DQogI2RlZmluZSBGV19CTEMyCQkweDAyMGRjDQpAQCAt
MzUxMyw3ICszNTE2LDcgQEANCiAjZGVmaW5lIEVEUF9MSU5LX1RSQUlOXzYwME1WXzBEQl9JVkIJ
CSgweDMwIDw8MjIpDQogI2RlZmluZSBFRFBfTElOS19UUkFJTl82MDBNVl8zXzVEQl9JVkIJCSgw
eDM2IDw8MjIpDQogI2RlZmluZSBFRFBfTElOS19UUkFJTl84MDBNVl8wREJfSVZCCQkoMHgzOCA8
PDIyKQ0KLSNkZWZpbmUgRURQX0xJTktfVFJBSU5fODAwTVZfM181REJfSVZCCQkoMHgzMyA8PDIy
KQ0KKyNkZWZpbmUgRURQX0xJTktfVFJBSU5fODAwTVZfM181REJfSVZCCQkoMHgzZSA8PDIyKQ0K
IA0KIC8qIGxlZ2FjeSB2YWx1ZXMgKi8NCiAjZGVmaW5lIEVEUF9MSU5LX1RSQUlOXzUwME1WXzBE
Ql9JVkIJCSgweDAwIDw8MjIpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50
ZWxfZGlzcGxheS5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jDQppbmRl
eCBjZmJiODkzLi5lZTI5YzFmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50
ZWxfZGlzcGxheS5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMN
CkBAIC04ODQyLDYgKzg4NDIsMTcgQEAgc3RhdGljIHZvaWQgcXVpcmtfaW52ZXJ0X2JyaWdodG5l
c3Moc3RydWN0IGRybV9kZXZpY2UgKmRldikNCiAJZGV2X3ByaXYtPnF1aXJrcyB8PSBRVUlSS19J
TlZFUlRfQlJJR0hUTkVTUzsNCiB9DQogDQorLyoNCisgKiBTb21lIG1hY2hpbmVzIChEZWxsIFhQ
UzEzKSBzdWZmZXIgYnJva2VuIGJhY2tsaWdodCBjb250cm9scyBpZg0KKyAqIEJMTV9QQ0hfUFdN
X0VOQUJMRSBpcyBzZXQuDQorICovDQorc3RhdGljIHZvaWQgcXVpcmtfbm9fcGNtX3B3bV9lbmFi
bGUoc3RydWN0IGRybV9kZXZpY2UgKmRldikNCit7DQorCXN0cnVjdCBkcm1faTkxNV9wcml2YXRl
ICpkZXZfcHJpdiA9IGRldi0+ZGV2X3ByaXZhdGU7DQorCWRldl9wcml2LT5xdWlya3MgfD0gUVVJ
UktfTk9fUENIX1BXTV9FTkFCTEU7DQorCURSTV9JTkZPKCJhcHBseWluZyBuby1QQ0hfUFdNX0VO
QUJMRSBxdWlya1xuIik7DQorfQ0KKw0KIHN0cnVjdCBpbnRlbF9xdWlyayB7DQogCWludCBkZXZp
Y2U7DQogCWludCBzdWJzeXN0ZW1fdmVuZG9yOw0KQEAgLTg5MTYsNiArODkyNywxMSBAQCBzdHJ1
Y3QgaW50ZWxfcXVpcmsgaW50ZWxfcXVpcmtzW10gPSB7DQogDQogCS8qIEFjZXIvUGFja2FyZCBC
ZWxsIE5DTDIwICovDQogCXsgMHgyYTQyLCAweDEwMjUsIDB4MDM0YiwgcXVpcmtfaW52ZXJ0X2Jy
aWdodG5lc3MgfSwNCisNCisJLyogRGVsbCBYUFMxMyBIRCBTYW5keSBCcmlkZ2UgKi8NCisJeyAw
eDAxMTYsIDB4MTAyOCwgMHgwNTJlLCBxdWlya19ub19wY21fcHdtX2VuYWJsZSB9LA0KKwkvKiBE
ZWxsIFhQUzEzIEhEIGFuZCBYUFMxMyBGSEQgSXZ5IEJyaWRnZSAqLw0KKwl7IDB4MDE2NiwgMHgx
MDI4LCAweDA1OGIsIHF1aXJrX25vX3BjbV9wd21fZW5hYmxlIH0sDQogfTsNCiANCiBzdGF0aWMg
dm9pZCBpbnRlbF9pbml0X3F1aXJrcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQ0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2x2ZHMuYyBiL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2ludGVsX2x2ZHMuYw0KaW5kZXggMmZmYTc0MC4uNzRkMzEyZiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2x2ZHMuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfbHZkcy5jDQpAQCAtNDAyLDEzICs0MDIsNyBAQCBzdGF0aWMgdm9pZCBpbnRlbF9s
dmRzX3ByZXBhcmUoc3RydWN0IGRybV9lbmNvZGVyICplbmNvZGVyKQ0KIHsNCiAJc3RydWN0IGlu
dGVsX2x2ZHMgKmludGVsX2x2ZHMgPSB0b19pbnRlbF9sdmRzKGVuY29kZXIpOw0KIA0KLQkvKg0K
LQkgKiBQcmlvciB0byBJcm9ubGFrZSwgd2UgbXVzdCBkaXNhYmxlIHRoZSBwaXBlIGlmIHdlIHdh
bnQgdG8gYWRqdXN0DQotCSAqIHRoZSBwYW5lbCBmaXR0ZXIuIEhvd2V2ZXIgYXQgYWxsIG90aGVy
IHRpbWVzIHdlIGNhbiBqdXN0IHJlc2V0DQotCSAqIHRoZSByZWdpc3RlcnMgcmVnYXJkbGVzcy4N
Ci0JICovDQotCWlmICghSEFTX1BDSF9TUExJVChlbmNvZGVyLT5kZXYpICYmIGludGVsX2x2ZHMt
PnBmaXRfZGlydHkpDQotCQlpbnRlbF9sdmRzX2Rpc2FibGUoaW50ZWxfbHZkcyk7DQorCWludGVs
X2x2ZHNfZGlzYWJsZShpbnRlbF9sdmRzKTsNCiB9DQogDQogc3RhdGljIHZvaWQgaW50ZWxfbHZk
c19jb21taXQoc3RydWN0IGRybV9lbmNvZGVyICplbmNvZGVyKQ0KQEAgLTEwNzUsNyArMTA2OSw4
IEBAIGJvb2wgaW50ZWxfbHZkc19pbml0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogCQlnb3Rv
IGZhaWxlZDsNCiANCiBvdXQ6DQotCWlmIChIQVNfUENIX1NQTElUKGRldikpIHsNCisJaWYgKEhB
U19QQ0hfU1BMSVQoZGV2KSAmJg0KKwkgICAgIShkZXZfcHJpdi0+cXVpcmtzICYgUVVJUktfTk9f
UENIX1BXTV9FTkFCTEUpKSB7DQogCQl1MzIgcHdtOw0KIA0KIAkJcGlwZSA9IChJOTE1X1JFQUQo
UENIX0xWRFMpICYgTFZEU19QSVBFQl9TRUxFQ1QpID8gMSA6IDA7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5jIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfcmluZ2J1ZmZlci5jDQppbmRleCAzOGE3NzkzLi4zYzU1Y2Y2IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5jDQorKysgYi9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9pbnRlbF9yaW5nYnVmZmVyLmMNCkBAIC03NzYsNiArNzc2LDE4IEBAIHZv
aWQgaW50ZWxfcmluZ19zZXR1cF9zdGF0dXNfcGFnZShzdHJ1Y3QgaW50ZWxfcmluZ19idWZmZXIg
KnJpbmcpDQogDQogCUk5MTVfV1JJVEUobW1pbywgKHUzMilyaW5nLT5zdGF0dXNfcGFnZS5nZnhf
YWRkcik7DQogCVBPU1RJTkdfUkVBRChtbWlvKTsNCisNCisJLyogRmx1c2ggdGhlIFRMQiBmb3Ig
dGhpcyBwYWdlICovDQorCWlmIChJTlRFTF9JTkZPKGRldiktPmdlbiA+PSA2KSB7DQorCQl1MzIg
cmVnID0gUklOR19JTlNUUE0ocmluZy0+bW1pb19iYXNlKTsNCisJCUk5MTVfV1JJVEUocmVnLA0K
KwkJCSAgIF9NQVNLRURfQklUX0VOQUJMRShJTlNUUE1fVExCX0lOVkFMSURBVEUgfA0KKwkJCQkJ
ICAgICAgSU5TVFBNX1NZTkNfRkxVU0gpKTsNCisJCWlmICh3YWl0X2ZvcigoSTkxNV9SRUFEKHJl
ZykgJiBJTlNUUE1fU1lOQ19GTFVTSCkgPT0gMCwNCisJCQkgICAgIDEwMDApKQ0KKwkJCURSTV9F
UlJPUigiJXM6IHdhaXQgZm9yIFN5bmNGbHVzaCB0byBjb21wbGV0ZSBmb3IgVExCIGludmFsaWRh
dGlvbiB0aW1lZCBvdXRcbiIsDQorCQkJCSAgcmluZy0+bmFtZSk7DQorCX0NCiB9DQogDQogc3Rh
dGljIGludA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbS5jIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tLmMNCmluZGV4IGQ5NjlmM2MuLmFmYjM1MWEgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b20uYw0KKysrIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9hdG9tLmMNCkBAIC0xMjIwLDEyICsxMjIwLDE3IEBAIGludCBhdG9tX2V4ZWN1
dGVfdGFibGUoc3RydWN0IGF0b21fY29udGV4dCAqY3R4LCBpbnQgaW5kZXgsIHVpbnQzMl90ICog
cGFyYW1zKQ0KIAlpbnQgcjsNCiANCiAJbXV0ZXhfbG9jaygmY3R4LT5tdXRleCk7DQorCS8qIHJl
c2V0IGRhdGEgYmxvY2sgKi8NCisJY3R4LT5kYXRhX2Jsb2NrID0gMDsNCiAJLyogcmVzZXQgcmVn
IGJsb2NrICovDQogCWN0eC0+cmVnX2Jsb2NrID0gMDsNCiAJLyogcmVzZXQgZmIgd2luZG93ICov
DQogCWN0eC0+ZmJfYmFzZSA9IDA7DQogCS8qIHJlc2V0IGlvIG1vZGUgKi8NCiAJY3R4LT5pb19t
b2RlID0gQVRPTV9JT19NTTsNCisJLyogcmVzZXQgZGl2bXVsICovDQorCWN0eC0+ZGl2bXVsWzBd
ID0gMDsNCisJY3R4LT5kaXZtdWxbMV0gPSAwOw0KIAlyID0gYXRvbV9leGVjdXRlX3RhYmxlX2xv
Y2tlZChjdHgsIGluZGV4LCBwYXJhbXMpOw0KIAltdXRleF91bmxvY2soJmN0eC0+bXV0ZXgpOw0K
IAlyZXR1cm4gcjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVl
bi5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYw0KaW5kZXggOWJlYTRhNi4u
ZjU5NjJhMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuLmMN
CisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuLmMNCkBAIC0zMDM2LDYgKzMw
MzYsOCBAQCBzdGF0aWMgaW50IGV2ZXJncmVlbl9zdGFydHVwKHN0cnVjdCByYWRlb25fZGV2aWNl
ICpyZGV2KQ0KIAkvKiBlbmFibGUgcGNpZSBnZW4yIGxpbmsgKi8NCiAJZXZlcmdyZWVuX3BjaWVf
Z2VuMl9lbmFibGUocmRldik7DQogDQorCWV2ZXJncmVlbl9tY19wcm9ncmFtKHJkZXYpOw0KKw0K
IAlpZiAoQVNJQ19JU19EQ0U1KHJkZXYpKSB7DQogCQlpZiAoIXJkZXYtPm1lX2Z3IHx8ICFyZGV2
LT5wZnBfZncgfHwgIXJkZXYtPnJsY19mdyB8fCAhcmRldi0+bWNfZncpIHsNCiAJCQlyID0gbmlf
aW5pdF9taWNyb2NvZGUocmRldik7DQpAQCAtMzA2Myw3ICszMDY1LDYgQEAgc3RhdGljIGludCBl
dmVyZ3JlZW5fc3RhcnR1cChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJaWYgKHIpDQog
CQlyZXR1cm4gcjsNCiANCi0JZXZlcmdyZWVuX21jX3Byb2dyYW0ocmRldik7DQogCWlmIChyZGV2
LT5mbGFncyAmIFJBREVPTl9JU19BR1ApIHsNCiAJCWV2ZXJncmVlbl9hZ3BfZW5hYmxlKHJkZXYp
Ow0KIAl9IGVsc2Ugew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vbmkuYyBi
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vbmkuYw0KaW5kZXggM2Y5NzA1Yi4uNzdlNmZiMSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vbmkuYw0KKysrIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9uaS5jDQpAQCAtMTM1Myw2ICsxMzUzLDggQEAgc3RhdGljIGludCBjYXltYW5f
c3RhcnR1cChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJLyogZW5hYmxlIHBjaWUgZ2Vu
MiBsaW5rICovDQogCWV2ZXJncmVlbl9wY2llX2dlbjJfZW5hYmxlKHJkZXYpOw0KIA0KKwlldmVy
Z3JlZW5fbWNfcHJvZ3JhbShyZGV2KTsNCisNCiAJaWYgKCFyZGV2LT5tZV9mdyB8fCAhcmRldi0+
cGZwX2Z3IHx8ICFyZGV2LT5ybGNfZncgfHwgIXJkZXYtPm1jX2Z3KSB7DQogCQlyID0gbmlfaW5p
dF9taWNyb2NvZGUocmRldik7DQogCQlpZiAocikgew0KQEAgLTEzNzAsNyArMTM3Miw2IEBAIHN0
YXRpYyBpbnQgY2F5bWFuX3N0YXJ0dXAoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQogCWlm
IChyKQ0KIAkJcmV0dXJuIHI7DQogDQotCWV2ZXJncmVlbl9tY19wcm9ncmFtKHJkZXYpOw0KIAly
ID0gY2F5bWFuX3BjaWVfZ2FydF9lbmFibGUocmRldik7DQogCWlmIChyKQ0KIAkJcmV0dXJuIHI7
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMgYi9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3I2MDAuYw0KaW5kZXggM2Q0NmQ3ZDQuLjU3ZTQ1YzYgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yNjAwLmMNCkBAIC0yNDE1LDYgKzI0MTUsOCBAQCBpbnQgcjYwMF9zdGFydHVwKHN0cnVj
dCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAkvKiBlbmFibGUgcGNpZSBnZW4yIGxpbmsgKi8NCiAJ
cjYwMF9wY2llX2dlbjJfZW5hYmxlKHJkZXYpOw0KIA0KKwlyNjAwX21jX3Byb2dyYW0ocmRldik7
DQorDQogCWlmICghcmRldi0+bWVfZncgfHwgIXJkZXYtPnBmcF9mdyB8fCAhcmRldi0+cmxjX2Z3
KSB7DQogCQlyID0gcjYwMF9pbml0X21pY3JvY29kZShyZGV2KTsNCiAJCWlmIChyKSB7DQpAQCAt
MjQyNyw3ICsyNDI5LDYgQEAgaW50IHI2MDBfc3RhcnR1cChzdHJ1Y3QgcmFkZW9uX2RldmljZSAq
cmRldikNCiAJaWYgKHIpDQogCQlyZXR1cm4gcjsNCiANCi0JcjYwMF9tY19wcm9ncmFtKHJkZXYp
Ow0KIAlpZiAocmRldi0+ZmxhZ3MgJiBSQURFT05fSVNfQUdQKSB7DQogCQlyNjAwX2FncF9lbmFi
bGUocmRldik7DQogCX0gZWxzZSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9ydjc3MC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjc3MC5jDQppbmRleCA2M2RiNzVk
Li4zZTcyMDc0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjc3MC5jDQor
KysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NzcwLmMNCkBAIC0xMDU3LDYgKzEwNTcsOCBA
QCBzdGF0aWMgaW50IHJ2NzcwX3N0YXJ0dXAoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQog
CS8qIGVuYWJsZSBwY2llIGdlbjIgbGluayAqLw0KIAlydjc3MF9wY2llX2dlbjJfZW5hYmxlKHJk
ZXYpOw0KIA0KKwlydjc3MF9tY19wcm9ncmFtKHJkZXYpOw0KKw0KIAlpZiAoIXJkZXYtPm1lX2Z3
IHx8ICFyZGV2LT5wZnBfZncgfHwgIXJkZXYtPnJsY19mdykgew0KIAkJciA9IHI2MDBfaW5pdF9t
aWNyb2NvZGUocmRldik7DQogCQlpZiAocikgew0KQEAgLTEwNjksNyArMTA3MSw2IEBAIHN0YXRp
YyBpbnQgcnY3NzBfc3RhcnR1cChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJaWYgKHIp
DQogCQlyZXR1cm4gcjsNCiANCi0JcnY3NzBfbWNfcHJvZ3JhbShyZGV2KTsNCiAJaWYgKHJkZXYt
PmZsYWdzICYgUkFERU9OX0lTX0FHUCkgew0KIAkJcnY3NzBfYWdwX2VuYWJsZShyZGV2KTsNCiAJ
fSBlbHNlIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9nbXIu
YyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2dtci5jDQppbmRleCBjNDEyMjZhLi4y
OTUyMjQ5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZ21yLmMN
CisrKyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2dtci5jDQpAQCAtMjksNyArMjks
OSBAQA0KICNpbmNsdWRlICJkcm1QLmgiDQogI2luY2x1ZGUgInR0bS90dG1fYm9fZHJpdmVyLmgi
DQogDQotI2RlZmluZSBWTVdfUFBOX1NJWkUgc2l6ZW9mKHVuc2lnbmVkIGxvbmcpDQorI2RlZmlu
ZSBWTVdfUFBOX1NJWkUgKHNpemVvZih1bnNpZ25lZCBsb25nKSkNCisvKiBBIGZ1dHVyZSBzYWZl
IG1heGltdW0gcmVtYXAgc2l6ZS4gKi8NCisjZGVmaW5lIFZNV19QUE5fUEVSX1JFTUFQICgoMzEg
KiAxMDI0KSAvIFZNV19QUE5fU0laRSkNCiANCiBzdGF0aWMgaW50IHZtd19nbXIyX2JpbmQoc3Ry
dWN0IHZtd19wcml2YXRlICpkZXZfcHJpdiwNCiAJCQkgc3RydWN0IHBhZ2UgKnBhZ2VzW10sDQpA
QCAtMzgsNDMgKzQwLDYxIEBAIHN0YXRpYyBpbnQgdm13X2dtcjJfYmluZChzdHJ1Y3Qgdm13X3By
aXZhdGUgKmRldl9wcml2LA0KIHsNCiAJU1ZHQUZpZm9DbWREZWZpbmVHTVIyIGRlZmluZV9jbWQ7
DQogCVNWR0FGaWZvQ21kUmVtYXBHTVIyIHJlbWFwX2NtZDsNCi0JdWludDMyX3QgZGVmaW5lX3Np
emUgPSBzaXplb2YoZGVmaW5lX2NtZCkgKyA0Ow0KLQl1aW50MzJfdCByZW1hcF9zaXplID0gVk1X
X1BQTl9TSVpFICogbnVtX3BhZ2VzICsgc2l6ZW9mKHJlbWFwX2NtZCkgKyA0Ow0KIAl1aW50MzJf
dCAqY21kOw0KIAl1aW50MzJfdCAqY21kX29yaWc7DQorCXVpbnQzMl90IGRlZmluZV9zaXplID0g
c2l6ZW9mKGRlZmluZV9jbWQpICsgc2l6ZW9mKCpjbWQpOw0KKwl1aW50MzJfdCByZW1hcF9udW0g
PSBudW1fcGFnZXMgLyBWTVdfUFBOX1BFUl9SRU1BUCArICgobnVtX3BhZ2VzICUgVk1XX1BQTl9Q
RVJfUkVNQVApID4gMCk7DQorCXVpbnQzMl90IHJlbWFwX3NpemUgPSBWTVdfUFBOX1NJWkUgKiBu
dW1fcGFnZXMgKyAoc2l6ZW9mKHJlbWFwX2NtZCkgKyBzaXplb2YoKmNtZCkpICogcmVtYXBfbnVt
Ow0KKwl1aW50MzJfdCByZW1hcF9wb3MgPSAwOw0KKwl1aW50MzJfdCBjbWRfc2l6ZSA9IGRlZmlu
ZV9zaXplICsgcmVtYXBfc2l6ZTsNCiAJdWludDMyX3QgaTsNCiANCi0JY21kX29yaWcgPSBjbWQg
PSB2bXdfZmlmb19yZXNlcnZlKGRldl9wcml2LCBkZWZpbmVfc2l6ZSArIHJlbWFwX3NpemUpOw0K
KwljbWRfb3JpZyA9IGNtZCA9IHZtd19maWZvX3Jlc2VydmUoZGV2X3ByaXYsIGNtZF9zaXplKTsN
CiAJaWYgKHVubGlrZWx5KGNtZCA9PSBOVUxMKSkNCiAJCXJldHVybiAtRU5PTUVNOw0KIA0KIAlk
ZWZpbmVfY21kLmdtcklkID0gZ21yX2lkOw0KIAlkZWZpbmVfY21kLm51bVBhZ2VzID0gbnVtX3Bh
Z2VzOw0KIA0KKwkqY21kKysgPSBTVkdBX0NNRF9ERUZJTkVfR01SMjsNCisJbWVtY3B5KGNtZCwg
JmRlZmluZV9jbWQsIHNpemVvZihkZWZpbmVfY21kKSk7DQorCWNtZCArPSBzaXplb2YoZGVmaW5l
X2NtZCkgLyBzaXplb2YoKmNtZCk7DQorDQorCS8qDQorCSAqIE5lZWQgdG8gc3BsaXQgdGhlIGNv
bW1hbmQgaWYgdGhlcmUgYXJlIHRvbyBtYW55DQorCSAqIHBhZ2VzIHRoYXQgZ29lcyBpbnRvIHRo
ZSBnbXIuDQorCSAqLw0KKw0KIAlyZW1hcF9jbWQuZ21ySWQgPSBnbXJfaWQ7DQogCXJlbWFwX2Nt
ZC5mbGFncyA9IChWTVdfUFBOX1NJWkUgPiBzaXplb2YoKmNtZCkpID8NCiAJCVNWR0FfUkVNQVBf
R01SMl9QUE42NCA6IFNWR0FfUkVNQVBfR01SMl9QUE4zMjsNCi0JcmVtYXBfY21kLm9mZnNldFBh
Z2VzID0gMDsNCi0JcmVtYXBfY21kLm51bVBhZ2VzID0gbnVtX3BhZ2VzOw0KIA0KLQkqY21kKysg
PSBTVkdBX0NNRF9ERUZJTkVfR01SMjsNCi0JbWVtY3B5KGNtZCwgJmRlZmluZV9jbWQsIHNpemVv
ZihkZWZpbmVfY21kKSk7DQotCWNtZCArPSBzaXplb2YoZGVmaW5lX2NtZCkgLyBzaXplb2YodWlu
dDMyKTsNCisJd2hpbGUgKG51bV9wYWdlcyA+IDApIHsNCisJCXVuc2lnbmVkIGxvbmcgbnIgPSBt
aW4obnVtX3BhZ2VzLCAodW5zaWduZWQgbG9uZylWTVdfUFBOX1BFUl9SRU1BUCk7DQorDQorCQly
ZW1hcF9jbWQub2Zmc2V0UGFnZXMgPSByZW1hcF9wb3M7DQorCQlyZW1hcF9jbWQubnVtUGFnZXMg
PSBucjsNCiANCi0JKmNtZCsrID0gU1ZHQV9DTURfUkVNQVBfR01SMjsNCi0JbWVtY3B5KGNtZCwg
JnJlbWFwX2NtZCwgc2l6ZW9mKHJlbWFwX2NtZCkpOw0KLQljbWQgKz0gc2l6ZW9mKHJlbWFwX2Nt
ZCkgLyBzaXplb2YodWludDMyKTsNCisJCSpjbWQrKyA9IFNWR0FfQ01EX1JFTUFQX0dNUjI7DQor
CQltZW1jcHkoY21kLCAmcmVtYXBfY21kLCBzaXplb2YocmVtYXBfY21kKSk7DQorCQljbWQgKz0g
c2l6ZW9mKHJlbWFwX2NtZCkgLyBzaXplb2YoKmNtZCk7DQogDQotCWZvciAoaSA9IDA7IGkgPCBu
dW1fcGFnZXM7ICsraSkgew0KLQkJaWYgKFZNV19QUE5fU0laRSA8PSA0KQ0KLQkJCSpjbWQgPSBw
YWdlX3RvX3BmbigqcGFnZXMrKyk7DQotCQllbHNlDQotCQkJKigodWludDY0X3QgKiljbWQpID0g
cGFnZV90b19wZm4oKnBhZ2VzKyspOw0KKwkJZm9yIChpID0gMDsgaSA8IG5yOyArK2kpIHsNCisJ
CQlpZiAoVk1XX1BQTl9TSVpFIDw9IDQpDQorCQkJCSpjbWQgPSBwYWdlX3RvX3BmbigqcGFnZXMr
Kyk7DQorCQkJZWxzZQ0KKwkJCQkqKCh1aW50NjRfdCAqKWNtZCkgPSBwYWdlX3RvX3BmbigqcGFn
ZXMrKyk7DQogDQotCQljbWQgKz0gVk1XX1BQTl9TSVpFIC8gc2l6ZW9mKCpjbWQpOw0KKwkJCWNt
ZCArPSBWTVdfUFBOX1NJWkUgLyBzaXplb2YoKmNtZCk7DQorCQl9DQorDQorCQludW1fcGFnZXMg
LT0gbnI7DQorCQlyZW1hcF9wb3MgKz0gbnI7DQogCX0NCiANCi0Jdm13X2ZpZm9fY29tbWl0KGRl
dl9wcml2LCBkZWZpbmVfc2l6ZSArIHJlbWFwX3NpemUpOw0KKwlCVUdfT04oY21kICE9IGNtZF9v
cmlnICsgY21kX3NpemUgLyBzaXplb2YoKmNtZCkpOw0KKw0KKwl2bXdfZmlmb19jb21taXQoZGV2
X3ByaXYsIGNtZF9zaXplKTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvaHdtb24vYWR0NzQ3MC5jIGIvZHJpdmVycy9od21vbi9hZHQ3NDcwLmMNCmluZGV4IGM2ZDFj
ZTAuLmE5NzI2YzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2h3bW9uL2FkdDc0NzAuYw0KKysrIGIv
ZHJpdmVycy9od21vbi9hZHQ3NDcwLmMNCkBAIC0yMTUsNyArMjE1LDcgQEAgc3RhdGljIGlubGlu
ZSBpbnQgYWR0NzQ3MF93cml0ZV93b3JkX2RhdGEoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCwg
dTggcmVnLA0KIAkJCQkJICB1MTYgdmFsdWUpDQogew0KIAlyZXR1cm4gaTJjX3NtYnVzX3dyaXRl
X2J5dGVfZGF0YShjbGllbnQsIHJlZywgdmFsdWUgJiAweEZGKQ0KLQkgICAgICAgJiYgaTJjX3Nt
YnVzX3dyaXRlX2J5dGVfZGF0YShjbGllbnQsIHJlZyArIDEsIHZhbHVlID4+IDgpOw0KKwkgICAg
ICAgfHwgaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YShjbGllbnQsIHJlZyArIDEsIHZhbHVlID4+
IDgpOw0KIH0NCiANCiBzdGF0aWMgdm9pZCBhZHQ3NDcwX2luaXRfY2xpZW50KHN0cnVjdCBpMmNf
Y2xpZW50ICpjbGllbnQpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS5jIGIvZHJpdmVy
cy9tZC9yYWlkMS5jDQppbmRleCAyOThlMDJhLi5jNzA2YTdiIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9tZC9yYWlkMS5jDQorKysgYi9kcml2ZXJzL21kL3JhaWQxLmMNCkBAIC0xMTM5LDcgKzExMzks
NyBAQCByZWFkX2FnYWluOg0KIAkJCSAqIGtub3cgdGhlIG9yaWdpbmFsIGJpX2lkeCwgc28gd2Ug
anVzdCBmcmVlDQogCQkJICogdGhlbSBhbGwNCiAJCQkgKi8NCi0JCQlfX2Jpb19mb3JfZWFjaF9z
ZWdtZW50KGJ2ZWMsIG1iaW8sIGosIDApDQorCQkJYmlvX2Zvcl9lYWNoX3NlZ21lbnRfYWxsKGJ2
ZWMsIG1iaW8sIGopDQogCQkJCWJ2ZWMtPmJ2X3BhZ2UgPSByMV9iaW8tPmJlaGluZF9idmVjc1tq
XS5idl9wYWdlOw0KIAkJCWlmICh0ZXN0X2JpdChXcml0ZU1vc3RseSwgJmNvbmYtPm1pcnJvcnNb
aV0ucmRldi0+ZmxhZ3MpKQ0KIAkJCQlhdG9taWNfaW5jKCZyMV9iaW8tPmJlaGluZF9yZW1haW5p
bmcpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2FyY25ldC9hcmNuZXQuYyBiL2RyaXZlcnMv
bmV0L2FyY25ldC9hcmNuZXQuYw0KaW5kZXggYTc0NmJhMi4uYTk1NjA1MyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L2FyY25ldC9hcmNuZXQuYw0KKysrIGIvZHJpdmVycy9uZXQvYXJjbmV0L2Fy
Y25ldC5jDQpAQCAtMTAwNyw3ICsxMDA3LDcgQEAgc3RhdGljIHZvaWQgYXJjbmV0X3J4KHN0cnVj
dCBuZXRfZGV2aWNlICpkZXYsIGludCBidWZudW0pDQogDQogCXNvZnQgPSAmcGt0LnNvZnQucmZj
MTIwMTsNCiANCi0JbHAtPmh3LmNvcHlfZnJvbV9jYXJkKGRldiwgYnVmbnVtLCAwLCAmcGt0LCBz
aXplb2YoQVJDX0hEUl9TSVpFKSk7DQorCWxwLT5ody5jb3B5X2Zyb21fY2FyZChkZXYsIGJ1Zm51
bSwgMCwgJnBrdCwgQVJDX0hEUl9TSVpFKTsNCiAJaWYgKHBrdC5oYXJkLm9mZnNldFswXSkgew0K
IAkJb2ZzID0gcGt0LmhhcmQub2Zmc2V0WzBdOw0KIAkJbGVuZ3RoID0gMjU2IC0gb2ZzOw0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX2RjYl84MjU5
OC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfZGNiXzgyNTk4LmMN
CmluZGV4IGZjZDBlNDcuLjJhN2QwOTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9peGdiZS9peGdiZV9kY2JfODI1OTguYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaXhnYmUvaXhnYmVfZGNiXzgyNTk4LmMNCkBAIC0xMDgsOSArMTA4LDggQEAgczMy
IGl4Z2JlX2RjYl9jb25maWdfdHhfZGVzY19hcmJpdGVyXzgyNTk4KHN0cnVjdCBpeGdiZV9odyAq
aHcsDQogDQogCS8qIEVuYWJsZSBhcmJpdGVyICovDQogCXJlZyAmPSB+SVhHQkVfRFBNQ1NfQVJC
RElTOw0KLQkvKiBFbmFibGUgREZQIGFuZCBSZWN5Y2xlIG1vZGUgKi8NCi0JcmVnIHw9IChJWEdC
RV9EUE1DU19URFBBQyB8IElYR0JFX0RQTUNTX1RSTSk7DQogCXJlZyB8PSBJWEdCRV9EUE1DU19U
U09FRjsNCisNCiAJLyogQ29uZmlndXJlIE1heCBUU08gcGFja2V0IHNpemUgMzRLQiBpbmNsdWRp
bmcgcGF5bG9hZCBhbmQgaGVhZGVycyAqLw0KIAlyZWcgfD0gKDB4NCA8PCBJWEdCRV9EUE1DU19N
VFNPU19TSElGVCk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvaWZiLmMgYi9kcml2ZXJz
L25ldC9pZmIuYw0KaW5kZXggYjE5ODQxYS4uMDBmMTM2NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2lmYi5jDQorKysgYi9kcml2ZXJzL25ldC9pZmIuYw0KQEAgLTM0LDYgKzM0LDcgQEANCiAj
aW5jbHVkZSA8bGludXgvaW5pdC5oPg0KICNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4NCiAj
aW5jbHVkZSA8bGludXgvbW9kdWxlcGFyYW0uaD4NCisjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4N
CiAjaW5jbHVkZSA8bmV0L3BrdF9zY2hlZC5oPg0KICNpbmNsdWRlIDxuZXQvbmV0X25hbWVzcGFj
ZS5oPg0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjNzV4eC5jIGIvZHJpdmVy
cy9uZXQvdXNiL3Ntc2M3NXh4LmMNCmluZGV4IGYzZDE3ZjguLmE4ZTQ2NDAgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC91c2Ivc21zYzc1eHguYw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL3Ntc2M3
NXh4LmMNCkBAIC00Myw3ICs0Myw2IEBADQogI2RlZmluZSBFRVBST01fTUFDX09GRlNFVAkJKDB4
MDEpDQogI2RlZmluZSBERUZBVUxUX1RYX0NTVU1fRU5BQkxFCQkodHJ1ZSkNCiAjZGVmaW5lIERF
RkFVTFRfUlhfQ1NVTV9FTkFCTEUJCSh0cnVlKQ0KLSNkZWZpbmUgREVGQVVMVF9UU09fRU5BQkxF
CQkodHJ1ZSkNCiAjZGVmaW5lIFNNU0M3NVhYX0lOVEVSTkFMX1BIWV9JRAkoMSkNCiAjZGVmaW5l
IFNNU0M3NVhYX1RYX09WRVJIRUFECQkoOCkNCiAjZGVmaW5lIE1BWF9SWF9GSUZPX1NJWkUJCSgy
MCAqIDEwMjQpDQpAQCAtMTAzNSwxNyArMTAzNCwxNCBAQCBzdGF0aWMgaW50IHNtc2M3NXh4X2Jp
bmQoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCiANCiAJ
SU5JVF9XT1JLKCZwZGF0YS0+c2V0X211bHRpY2FzdCwgc21zYzc1eHhfZGVmZXJyZWRfbXVsdGlj
YXN0X3dyaXRlKTsNCiANCi0JaWYgKERFRkFVTFRfVFhfQ1NVTV9FTkFCTEUpIHsNCisJaWYgKERF
RkFVTFRfVFhfQ1NVTV9FTkFCTEUpDQogCQlkZXYtPm5ldC0+ZmVhdHVyZXMgfD0gTkVUSUZfRl9J
UF9DU1VNIHwgTkVUSUZfRl9JUFY2X0NTVU07DQotCQlpZiAoREVGQVVMVF9UU09fRU5BQkxFKQ0K
LQkJCWRldi0+bmV0LT5mZWF0dXJlcyB8PSBORVRJRl9GX1NHIHwNCi0JCQkJTkVUSUZfRl9UU08g
fCBORVRJRl9GX1RTTzY7DQotCX0NCisNCiAJaWYgKERFRkFVTFRfUlhfQ1NVTV9FTkFCTEUpDQog
CQlkZXYtPm5ldC0+ZmVhdHVyZXMgfD0gTkVUSUZfRl9SWENTVU07DQogDQogCWRldi0+bmV0LT5o
d19mZWF0dXJlcyA9IE5FVElGX0ZfSVBfQ1NVTSB8IE5FVElGX0ZfSVBWNl9DU1VNIHwNCi0JCU5F
VElGX0ZfU0cgfCBORVRJRl9GX1RTTyB8IE5FVElGX0ZfVFNPNiB8IE5FVElGX0ZfUlhDU1VNOw0K
KwkJCQlORVRJRl9GX1JYQ1NVTTsNCiANCiAJLyogSW5pdCBhbGwgcmVnaXN0ZXJzICovDQogCXJl
dCA9IHNtc2M3NXh4X3Jlc2V0KGRldik7DQpAQCAtMTE3MCw4ICsxMTY2LDYgQEAgc3RhdGljIHN0
cnVjdCBza19idWZmICpzbXNjNzV4eF90eF9maXh1cChzdHJ1Y3QgdXNibmV0ICpkZXYsDQogew0K
IAl1MzIgdHhfY21kX2EsIHR4X2NtZF9iOw0KIA0KLQlza2JfbGluZWFyaXplKHNrYik7DQotDQog
CWlmIChza2JfaGVhZHJvb20oc2tiKSA8IFNNU0M3NVhYX1RYX09WRVJIRUFEKSB7DQogCQlzdHJ1
Y3Qgc2tfYnVmZiAqc2tiMiA9DQogCQkJc2tiX2NvcHlfZXhwYW5kKHNrYiwgU01TQzc1WFhfVFhf
T1ZFUkhFQUQsIDAsIGZsYWdzKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvaHRjX2Rydl9pbml0LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
aHRjX2Rydl9pbml0LmMNCmluZGV4IDg0ODkwZDUuLmVmOTIxZTEgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2Rydl9pbml0LmMNCisrKyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9odGNfZHJ2X2luaXQuYw0KQEAgLTg1MSw2ICs4NTEsNyBA
QCBzdGF0aWMgaW50IGF0aDlrX2luaXRfZGV2aWNlKHN0cnVjdCBhdGg5a19odGNfcHJpdiAqcHJp
diwNCiAJaWYgKGVycm9yICE9IDApDQogCQlnb3RvIGVycl9yeDsNCiANCisJYXRoOWtfaHdfZGlz
YWJsZShwcml2LT5haCk7DQogI2lmZGVmIENPTkZJR19NQUM4MDIxMV9MRURTDQogCS8qIG11c3Qg
YmUgaW5pdGlhbGl6ZWQgYmVmb3JlIGllZWU4MDIxMV9yZWdpc3Rlcl9odyAqLw0KIAlwcml2LT5s
ZWRfY2Rldi5kZWZhdWx0X3RyaWdnZXIgPSBpZWVlODAyMTFfY3JlYXRlX3RwdF9sZWRfdHJpZ2dl
cihwcml2LT5odywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
aHRjX2Rydl90eHJ4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2Rydl90
eHJ4LmMNCmluZGV4IGE0OGJiODMuLjlhNTcxNDkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2Rydl90eHJ4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay9odGNfZHJ2X3R4cnguYw0KQEAgLTQ0OCw2ICs0NDgsNyBAQCBzdGF0aWMg
dm9pZCBhdGg5a19odGNfdHhfcHJvY2VzcyhzdHJ1Y3QgYXRoOWtfaHRjX3ByaXYgKnByaXYsDQog
CXN0cnVjdCBpZWVlODAyMTFfY29uZiAqY3VyX2NvbmYgPSAmcHJpdi0+aHctPmNvbmY7DQogCWJv
b2wgdHhvazsNCiAJaW50IHNsb3Q7DQorCWludCBoZHJsZW4sIHBhZHNpemU7DQogDQogCXNsb3Qg
PSBzdHJpcF9kcnZfaGVhZGVyKHByaXYsIHNrYik7DQogCWlmIChzbG90IDwgMCkgew0KQEAgLTUw
NCw2ICs1MDUsMTUgQEAgc2VuZF9tYWM4MDIxMToNCiANCiAJYXRoOWtfaHRjX3R4X2NsZWFyX3Ns
b3QocHJpdiwgc2xvdCk7DQogDQorCS8qIFJlbW92ZSBwYWRkaW5nIGJlZm9yZSBoYW5kaW5nIGZy
YW1lIGJhY2sgdG8gbWFjODAyMTEgKi8NCisJaGRybGVuID0gaWVlZTgwMjExX2dldF9oZHJsZW5f
ZnJvbV9za2Ioc2tiKTsNCisNCisJcGFkc2l6ZSA9IGhkcmxlbiAmIDM7DQorCWlmIChwYWRzaXpl
ICYmIHNrYi0+bGVuID4gaGRybGVuICsgcGFkc2l6ZSkgew0KKwkJbWVtbW92ZShza2ItPmRhdGEg
KyBwYWRzaXplLCBza2ItPmRhdGEsIGhkcmxlbik7DQorCQlza2JfcHVsbChza2IsIHBhZHNpemUp
Ow0KKwl9DQorDQogCS8qIFNlbmQgc3RhdHVzIHRvIG1hYzgwMjExICovDQogCWllZWU4MDIxMV90
eF9zdGF0dXMocHJpdi0+aHcsIHNrYik7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2hvc3RhcC9ob3N0YXBfaW9jdGwuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2hvc3Rh
cC9ob3N0YXBfaW9jdGwuYw0KaW5kZXggMDQ1YTkzNi4uMjcxZTgxOCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2hvc3RhcC9ob3N0YXBfaW9jdGwuYw0KKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaG9zdGFwL2hvc3RhcF9pb2N0bC5jDQpAQCAtNTIyLDkgKzUyMiw5IEBAIHN0
YXRpYyBpbnQgcHJpc20yX2lvY3RsX2dpd2FwbGlzdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0K
IA0KIAlkYXRhLT5sZW5ndGggPSBwcmlzbTJfYXBfZ2V0X3N0YV9xdWFsKGxvY2FsLCBhZGRyLCBx
dWFsLCBJV19NQVhfQVAsIDEpOw0KIA0KLQltZW1jcHkoZXh0cmEsICZhZGRyLCBzaXplb2Yoc3Ry
dWN0IHNvY2thZGRyKSAqIGRhdGEtPmxlbmd0aCk7DQorCW1lbWNweShleHRyYSwgYWRkciwgc2l6
ZW9mKHN0cnVjdCBzb2NrYWRkcikgKiBkYXRhLT5sZW5ndGgpOw0KIAlkYXRhLT5mbGFncyA9IDE7
IC8qIGhhcyBxdWFsaXR5IGluZm9ybWF0aW9uICovDQotCW1lbWNweShleHRyYSArIHNpemVvZihz
dHJ1Y3Qgc29ja2FkZHIpICogZGF0YS0+bGVuZ3RoLCAmcXVhbCwNCisJbWVtY3B5KGV4dHJhICsg
c2l6ZW9mKHN0cnVjdCBzb2NrYWRkcikgKiBkYXRhLT5sZW5ndGgsIHF1YWwsDQogCSAgICAgICBz
aXplb2Yoc3RydWN0IGl3X3F1YWxpdHkpICogZGF0YS0+bGVuZ3RoKTsNCiANCiAJa2ZyZWUoYWRk
cik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsZWdhY3kvaXdsLWNvcmUu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bGVnYWN5L2l3bC1jb3JlLmMNCmluZGV4IDFiYjY0
YzkuLjA5ODkxZTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2xlZ2FjeS9p
d2wtY29yZS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2xlZ2FjeS9pd2wtY29yZS5j
DQpAQCAtMTc1Nyw2ICsxNzU3LDcgQEAgaW50IGl3bF9sZWdhY3lfZm9yY2VfcmVzZXQoc3RydWN0
IGl3bF9wcml2ICpwcml2LCBib29sIGV4dGVybmFsKQ0KIA0KIAlyZXR1cm4gMDsNCiB9DQorRVhQ
T1JUX1NZTUJPTChpd2xfbGVnYWN5X2ZvcmNlX3Jlc2V0KTsNCiANCiBpbnQNCiBpd2xfbGVnYWN5
X21hY19jaGFuZ2VfaW50ZXJmYWNlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bGVnYWN5L2l3bDQ5NjUtYmFzZS5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaXdsZWdhY3kvaXdsNDk2NS1iYXNlLmMNCmluZGV4IGQyZmJhOWUuLjZl
MjVjN2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2xlZ2FjeS9pd2w0OTY1
LWJhc2UuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsZWdhY3kvaXdsNDk2NS1iYXNl
LmMNCkBAIC04NjgsMTMgKzg2OCwxMyBAQCBzdGF0aWMgdm9pZCBpd2w0OTY1X2lycV90YXNrbGV0
KHN0cnVjdCBpd2xfcHJpdiAqcHJpdikNCiAJCSAqIGlzIGtpbGxlZC4gSGVuY2UgdXBkYXRlIHRo
ZSBraWxsc3dpdGNoIHN0YXRlIGhlcmUuIFRoZQ0KIAkJICogcmZraWxsIGhhbmRsZXIgd2lsbCBj
YXJlIGFib3V0IHJlc3RhcnRpbmcgaWYgbmVlZGVkLg0KIAkJICovDQotCQlpZiAoIXRlc3RfYml0
KFNUQVRVU19BTElWRSwgJnByaXYtPnN0YXR1cykpIHsNCi0JCQlpZiAoaHdfcmZfa2lsbCkNCi0J
CQkJc2V0X2JpdChTVEFUVVNfUkZfS0lMTF9IVywgJnByaXYtPnN0YXR1cyk7DQotCQkJZWxzZQ0K
LQkJCQljbGVhcl9iaXQoU1RBVFVTX1JGX0tJTExfSFcsICZwcml2LT5zdGF0dXMpOw0KLQkJCXdp
cGh5X3Jma2lsbF9zZXRfaHdfc3RhdGUocHJpdi0+aHctPndpcGh5LCBod19yZl9raWxsKTsNCisJ
CWlmIChod19yZl9raWxsKSB7DQorCQkJc2V0X2JpdChTVEFUVVNfUkZfS0lMTF9IVywgJnByaXYt
PnN0YXR1cyk7DQorCQl9IGVsc2Ugew0KKwkJCWNsZWFyX2JpdChTVEFUVVNfUkZfS0lMTF9IVywg
JnByaXYtPnN0YXR1cyk7DQorCQkJaXdsX2xlZ2FjeV9mb3JjZV9yZXNldChwcml2LCB0cnVlKTsN
CiAJCX0NCisJCXdpcGh5X3Jma2lsbF9zZXRfaHdfc3RhdGUocHJpdi0+aHctPndpcGh5LCBod19y
Zl9raWxsKTsNCiANCiAJCWhhbmRsZWQgfD0gQ1NSX0lOVF9CSVRfUkZfS0lMTDsNCiAJfQ0KQEAg
LTE3NjQsNiArMTc2NCw5IEBAIHN0YXRpYyB2b2lkIGl3bDQ5NjVfYWxpdmVfc3RhcnQoc3RydWN0
IGl3bF9wcml2ICpwcml2KQ0KIA0KIAlwcml2LT5hY3RpdmVfcmF0ZSA9IElXTF9SQVRFU19NQVNL
Ow0KIA0KKwlpd2xfbGVnYWN5X3Bvd2VyX3VwZGF0ZV9tb2RlKHByaXYsIHRydWUpOw0KKwlJV0xf
REVCVUdfSU5GTyhwcml2LCAiVXBkYXRlZCBwb3dlciBtb2RlXG4iKTsNCisNCiAJaWYgKGl3bF9s
ZWdhY3lfaXNfYXNzb2NpYXRlZF9jdHgoY3R4KSkgew0KIAkJc3RydWN0IGl3bF9sZWdhY3lfcnhv
bl9jbWQgKmFjdGl2ZV9yeG9uID0NCiAJCQkJKHN0cnVjdCBpd2xfbGVnYWN5X3J4b25fY21kICop
JmN0eC0+YWN0aXZlOw0KQEAgLTE3OTYsOSArMTc5OSw2IEBAIHN0YXRpYyB2b2lkIGl3bDQ5NjVf
YWxpdmVfc3RhcnQoc3RydWN0IGl3bF9wcml2ICpwcml2KQ0KIAlJV0xfREVCVUdfSU5GTyhwcml2
LCAiQUxJVkUgcHJvY2Vzc2luZyBjb21wbGV0ZS5cbiIpOw0KIAl3YWtlX3VwKCZwcml2LT53YWl0
X2NvbW1hbmRfcXVldWUpOw0KIA0KLQlpd2xfbGVnYWN5X3Bvd2VyX3VwZGF0ZV9tb2RlKHByaXYs
IHRydWUpOw0KLQlJV0xfREVCVUdfSU5GTyhwcml2LCAiVXBkYXRlZCBwb3dlciBtb2RlXG4iKTsN
Ci0NCiAJcmV0dXJuOw0KIA0KICByZXN0YXJ0Og0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvaXdsLWFnbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtYWduLmMNCmluZGV4IDE2Y2RkMTIuLjk0ZDM1YWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24uYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9pd2wtYWduLmMNCkBAIC0xMjk3LDcgKzEyOTcsNyBAQCBpbnQgaXdsX2FsaXZlX3N0
YXJ0KHN0cnVjdCBpd2xfcHJpdiAqcHJpdikNCiAJCQkJCSBCVF9DT0VYX1BSSU9fVEJMX0VWVF9J
TklUX0NBTElCMik7DQogCQlpZiAocmV0KQ0KIAkJCXJldHVybiByZXQ7DQotCX0gZWxzZSB7DQor
CX0gZWxzZSBpZiAocHJpdi0+Y2ZnLT5idF9wYXJhbXMpIHsNCiAJCS8qDQogCQkgKiBkZWZhdWx0
IGlzIDItd2lyZSBCVCBjb2V4ZXhpc3RlbmNlIHN1cHBvcnQNCiAJCSAqLw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWNvcmUuYyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvaXdsLWNvcmUuYw0KaW5kZXggODMyZWM0ZC4uNWVmMTc2YSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWNvcmUuYw0KKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtY29yZS5jDQpAQCAtODA4LDggKzgwOCwxMSBA
QCB2b2lkIGl3bF9jaHN3aXRjaF9kb25lKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgYm9vbCBpc19z
dWNjZXNzKQ0KIAlpZiAodGVzdF9iaXQoU1RBVFVTX0VYSVRfUEVORElORywgJnByaXYtPnNocmQt
PnN0YXR1cykpDQogCQlyZXR1cm47DQogDQotCWlmICh0ZXN0X2FuZF9jbGVhcl9iaXQoU1RBVFVT
X0NIQU5ORUxfU1dJVENIX1BFTkRJTkcsDQorCWlmICghdGVzdF9hbmRfY2xlYXJfYml0KFNUQVRV
U19DSEFOTkVMX1NXSVRDSF9QRU5ESU5HLA0KIAkJCQkmcHJpdi0+c2hyZC0+c3RhdHVzKSkNCisJ
CXJldHVybjsNCisNCisJaWYgKGN0eC0+dmlmKQ0KIAkJaWVlZTgwMjExX2Noc3dpdGNoX2RvbmUo
Y3R4LT52aWYsIGlzX3N1Y2Nlc3MpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9pd2x3aWZpL2l3bC1wY2kuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkv
aXdsLXBjaS5jDQppbmRleCAxODAwMDI5Li4zNDZkYzliIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtcGNpLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2l3bHdpZmkvaXdsLXBjaS5jDQpAQCAtMjI3LDYgKzIyNyw3IEBAIHN0YXRpYyBERUZJTkVfUENJ
X0RFVklDRV9UQUJMRShpd2xfaHdfY2FyZF9pZHMpID0gew0KIAl7SVdMX1BDSV9ERVZJQ0UoMHg0
MjNDLCAweDEzMDYsIGl3bDUxNTBfYWJnX2NmZyl9LCAvKiBIYWxmIE1pbmkgQ2FyZCAqLw0KIAl7
SVdMX1BDSV9ERVZJQ0UoMHg0MjNDLCAweDEyMjEsIGl3bDUxNTBfYWduX2NmZyl9LCAvKiBNaW5p
IENhcmQgKi8NCiAJe0lXTF9QQ0lfREVWSUNFKDB4NDIzQywgMHgxMzIxLCBpd2w1MTUwX2Fnbl9j
ZmcpfSwgLyogSGFsZiBNaW5pIENhcmQgKi8NCisJe0lXTF9QQ0lfREVWSUNFKDB4NDIzQywgMHgx
MzI2LCBpd2w1MTUwX2FiZ19jZmcpfSwgLyogSGFsZiBNaW5pIENhcmQgKi8NCiANCiAJe0lXTF9Q
Q0lfREVWSUNFKDB4NDIzRCwgMHgxMjExLCBpd2w1MTUwX2Fnbl9jZmcpfSwgLyogTWluaSBDYXJk
ICovDQogCXtJV0xfUENJX0RFVklDRSgweDQyM0QsIDB4MTMxMSwgaXdsNTE1MF9hZ25fY2ZnKX0s
IC8qIEhhbGYgTWluaSBDYXJkICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bXdpZmlleC9zZGlvLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3NkaW8uYw0KaW5k
ZXggMzU3OWE2OC4uMTdmODcyMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213
aWZpZXgvc2Rpby5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3NkaW8uYw0K
QEAgLTE0MjksOCArMTQyOSw4IEBAIHN0YXRpYyBpbnQgbXdpZmlleF9zZGlvX2hvc3RfdG9fY2Fy
ZChzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyLA0KIAkvKiBBbGxvY2F0ZSBidWZmZXIg
YW5kIGNvcHkgcGF5bG9hZCAqLw0KIAlibGtfc2l6ZSA9IE1XSUZJRVhfU0RJT19CTE9DS19TSVpF
Ow0KIAlidWZfYmxvY2tfbGVuID0gKHBrdF9sZW4gKyBibGtfc2l6ZSAtIDEpIC8gYmxrX3NpemU7
DQotCSoodTE2ICopICZwYXlsb2FkWzBdID0gKHUxNikgcGt0X2xlbjsNCi0JKih1MTYgKikgJnBh
eWxvYWRbMl0gPSB0eXBlOw0KKwkqKF9fbGUxNiAqKSZwYXlsb2FkWzBdID0gY3B1X3RvX2xlMTYo
KHUxNilwa3RfbGVuKTsNCisJKihfX2xlMTYgKikmcGF5bG9hZFsyXSA9IGNwdV90b19sZTE2KHR5
cGUpOw0KIA0KIAkvKg0KIAkgKiBUaGlzIGlzIFNESU8gc3BlY2lmaWMgaGVhZGVyDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MngwMHF1ZXVlLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyeDAwcXVldWUuYw0KaW5kZXggNTBmOTJkNS4uNGQ3OTJh
MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDJ4MDBxdWV1ZS5j
DQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyeDAwcXVldWUuYw0KQEAgLTg1
NiwxMyArODU2LDggQEAgdm9pZCBydDJ4MDBxdWV1ZV9pbmRleF9pbmMoc3RydWN0IHF1ZXVlX2Vu
dHJ5ICplbnRyeSwgZW51bSBxdWV1ZV9pbmRleCBpbmRleCkNCiAJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmcXVldWUtPmluZGV4X2xvY2ssIGlycWZsYWdzKTsNCiB9DQogDQotdm9pZCBydDJ4MDBx
dWV1ZV9wYXVzZV9xdWV1ZShzdHJ1Y3QgZGF0YV9xdWV1ZSAqcXVldWUpDQordm9pZCBydDJ4MDBx
dWV1ZV9wYXVzZV9xdWV1ZV9ub2NoZWNrKHN0cnVjdCBkYXRhX3F1ZXVlICpxdWV1ZSkNCiB7DQot
CWlmICghdGVzdF9iaXQoREVWSUNFX1NUQVRFX1BSRVNFTlQsICZxdWV1ZS0+cnQyeDAwZGV2LT5m
bGFncykgfHwNCi0JICAgICF0ZXN0X2JpdChRVUVVRV9TVEFSVEVELCAmcXVldWUtPmZsYWdzKSB8
fA0KLQkgICAgdGVzdF9hbmRfc2V0X2JpdChRVUVVRV9QQVVTRUQsICZxdWV1ZS0+ZmxhZ3MpKQ0K
LQkJcmV0dXJuOw0KLQ0KIAlzd2l0Y2ggKHF1ZXVlLT5xaWQpIHsNCiAJY2FzZSBRSURfQUNfVk86
DQogCWNhc2UgUUlEX0FDX1ZJOg0KQEAgLTg3OCw2ICs4NzMsMTUgQEAgdm9pZCBydDJ4MDBxdWV1
ZV9wYXVzZV9xdWV1ZShzdHJ1Y3QgZGF0YV9xdWV1ZSAqcXVldWUpDQogCQlicmVhazsNCiAJfQ0K
IH0NCit2b2lkIHJ0MngwMHF1ZXVlX3BhdXNlX3F1ZXVlKHN0cnVjdCBkYXRhX3F1ZXVlICpxdWV1
ZSkNCit7DQorCWlmICghdGVzdF9iaXQoREVWSUNFX1NUQVRFX1BSRVNFTlQsICZxdWV1ZS0+cnQy
eDAwZGV2LT5mbGFncykgfHwNCisJICAgICF0ZXN0X2JpdChRVUVVRV9TVEFSVEVELCAmcXVldWUt
PmZsYWdzKSB8fA0KKwkgICAgdGVzdF9hbmRfc2V0X2JpdChRVUVVRV9QQVVTRUQsICZxdWV1ZS0+
ZmxhZ3MpKQ0KKwkJcmV0dXJuOw0KKw0KKwlydDJ4MDBxdWV1ZV9wYXVzZV9xdWV1ZV9ub2NoZWNr
KHF1ZXVlKTsNCit9DQogRVhQT1JUX1NZTUJPTF9HUEwocnQyeDAwcXVldWVfcGF1c2VfcXVldWUp
Ow0KIA0KIHZvaWQgcnQyeDAwcXVldWVfdW5wYXVzZV9xdWV1ZShzdHJ1Y3QgZGF0YV9xdWV1ZSAq
cXVldWUpDQpAQCAtOTM5LDcgKzk0Myw3IEBAIHZvaWQgcnQyeDAwcXVldWVfc3RvcF9xdWV1ZShz
dHJ1Y3QgZGF0YV9xdWV1ZSAqcXVldWUpDQogCQlyZXR1cm47DQogCX0NCiANCi0JcnQyeDAwcXVl
dWVfcGF1c2VfcXVldWUocXVldWUpOw0KKwlydDJ4MDBxdWV1ZV9wYXVzZV9xdWV1ZV9ub2NoZWNr
KHF1ZXVlKTsNCiANCiAJcXVldWUtPnJ0MngwMGRldi0+b3BzLT5saWItPnN0b3BfcXVldWUocXVl
dWUpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3pkMTIwMS5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvemQxMjAxLmMNCmluZGV4IDhlZmEyZjIuLmY4YzMxOWMgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy96ZDEyMDEuYw0KKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvemQxMjAxLmMNCkBAIC05OCwxMCArOTgsMTIgQEAgc3RhdGljIGludCB6ZDEyMDFf
ZndfdXBsb2FkKHN0cnVjdCB1c2JfZGV2aWNlICpkZXYsIGludCBhcGZ3KQ0KIAkJZ290byBleGl0
Ow0KIA0KIAllcnIgPSB1c2JfY29udHJvbF9tc2coZGV2LCB1c2JfcmN2Y3RybHBpcGUoZGV2LCAw
KSwgMHg0LA0KLQkgICAgVVNCX0RJUl9JTiB8IDB4NDAsIDAsMCwgJnJldCwgc2l6ZW9mKHJldCks
IFpEMTIwMV9GV19USU1FT1VUKTsNCisJICAgIFVTQl9ESVJfSU4gfCAweDQwLCAwLCAwLCBidWYs
IHNpemVvZihyZXQpLCBaRDEyMDFfRldfVElNRU9VVCk7DQogCWlmIChlcnIgPCAwKQ0KIAkJZ290
byBleGl0Ow0KIA0KKwltZW1jcHkoJnJldCwgYnVmLCBzaXplb2YocmV0KSk7DQorDQogCWlmIChy
ZXQgJiAweDgwKSB7DQogCQllcnIgPSAtRUlPOw0KIAkJZ290byBleGl0Ow0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvb2YvZmR0LmMgYi9kcml2ZXJzL29mL2ZkdC5jDQppbmRleCBmZDg1ZmEyLi5iNzc4
MDhjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9vZi9mZHQuYw0KKysrIGIvZHJpdmVycy9vZi9mZHQu
Yw0KQEAgLTM4OSw2ICszODksOCBAQCBzdGF0aWMgdm9pZCBfX3VuZmxhdHRlbl9kZXZpY2VfdHJl
ZShzdHJ1Y3QgYm9vdF9wYXJhbV9oZWFkZXIgKmJsb2IsDQogCW1lbSA9ICh1bnNpZ25lZCBsb25n
KQ0KIAkJZHRfYWxsb2Moc2l6ZSArIDQsIF9fYWxpZ25vZl9fKHN0cnVjdCBkZXZpY2Vfbm9kZSkp
Ow0KIA0KKwltZW1zZXQoKHZvaWQgKiltZW0sIDAsIHNpemUpOw0KKw0KIAkoKF9fYmUzMiAqKW1l
bSlbc2l6ZSAvIDRdID0gY3B1X3RvX2JlMzIoMHhkZWFkYmVlZik7DQogDQogCXByX2RlYnVnKCIg
IHVuZmxhdHRlbmluZyAlbHguLi5cbiIsIG1lbSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wYXJp
c2MvaW9tbXUtaGVscGVycy5oIGIvZHJpdmVycy9wYXJpc2MvaW9tbXUtaGVscGVycy5oDQppbmRl
eCBhOWM0NmNjLi44YzMzNDkxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wYXJpc2MvaW9tbXUtaGVs
cGVycy5oDQorKysgYi9kcml2ZXJzL3BhcmlzYy9pb21tdS1oZWxwZXJzLmgNCkBAIC0xLDMgKzEs
NSBAQA0KKyNpbmNsdWRlIDxsaW51eC9wcmVmZXRjaC5oPg0KKw0KIC8qKg0KICAqIGlvbW11X2Zp
bGxfcGRpciAtIEluc2VydCBjb2FsZXNjZWQgc2NhdHRlci9nYXRoZXIgY2h1bmtzIGludG8gdGhl
IEkvTyBQZGlyLg0KICAqIEBpb2M6IFRoZSBJL08gQ29udHJvbGxlci4NCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3BjaS9NYWtlZmlsZSBiL2RyaXZlcnMvcGNpL01ha2VmaWxlDQppbmRleCAwODNhNDlm
Li4xNjUyNzRjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wY2kvTWFrZWZpbGUNCisrKyBiL2RyaXZl
cnMvcGNpL01ha2VmaWxlDQpAQCAtNDIsNiArNDIsNyBAQCBvYmotJChDT05GSUdfVU5JQ09SRTMy
KSArPSBzZXR1cC1idXMubyBzZXR1cC1pcnEubw0KIG9iai0kKENPTkZJR19QQVJJU0MpICs9IHNl
dHVwLWJ1cy5vDQogb2JqLSQoQ09ORklHX1NVUEVSSCkgKz0gc2V0dXAtYnVzLm8gc2V0dXAtaXJx
Lm8NCiBvYmotJChDT05GSUdfUFBDKSArPSBzZXR1cC1idXMubw0KK29iai0kKENPTkZJR19GUlYp
ICs9IHNldHVwLWJ1cy5vDQogb2JqLSQoQ09ORklHX01JUFMpICs9IHNldHVwLWJ1cy5vIHNldHVw
LWlycS5vDQogb2JqLSQoQ09ORklHX1g4Nl9WSVNXUykgKz0gc2V0dXAtaXJxLm8NCiBvYmotJChD
T05GSUdfTU4xMDMwMCkgKz0gc2V0dXAtYnVzLm8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3MzOTAv
c2NzaS96ZmNwX2VycC5jIGIvZHJpdmVycy9zMzkwL3Njc2kvemZjcF9lcnAuYw0KaW5kZXggZTFi
NGY4MC4uNWM4NzI3MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvczM5MC9zY3NpL3pmY3BfZXJwLmMN
CisrKyBiL2RyaXZlcnMvczM5MC9zY3NpL3pmY3BfZXJwLmMNCkBAIC0xMDIsMTAgKzEwMiwxMyBA
QCBzdGF0aWMgdm9pZCB6ZmNwX2VycF9hY3Rpb25fZGlzbWlzc19wb3J0KHN0cnVjdCB6ZmNwX3Bv
cnQgKnBvcnQpDQogDQogCWlmIChhdG9taWNfcmVhZCgmcG9ydC0+c3RhdHVzKSAmIFpGQ1BfU1RB
VFVTX0NPTU1PTl9FUlBfSU5VU0UpDQogCQl6ZmNwX2VycF9hY3Rpb25fZGlzbWlzcygmcG9ydC0+
ZXJwX2FjdGlvbik7DQotCWVsc2UNCi0JCXNob3N0X2Zvcl9lYWNoX2RldmljZShzZGV2LCBwb3J0
LT5hZGFwdGVyLT5zY3NpX2hvc3QpDQorCWVsc2Ugew0KKwkJc3Bpbl9sb2NrKHBvcnQtPmFkYXB0
ZXItPnNjc2lfaG9zdC0+aG9zdF9sb2NrKTsNCisJCV9fc2hvc3RfZm9yX2VhY2hfZGV2aWNlKHNk
ZXYsIHBvcnQtPmFkYXB0ZXItPnNjc2lfaG9zdCkNCiAJCQlpZiAoc2Rldl90b196ZmNwKHNkZXYp
LT5wb3J0ID09IHBvcnQpDQogCQkJCXpmY3BfZXJwX2FjdGlvbl9kaXNtaXNzX2x1bihzZGV2KTsN
CisJCXNwaW5fdW5sb2NrKHBvcnQtPmFkYXB0ZXItPnNjc2lfaG9zdC0+aG9zdF9sb2NrKTsNCisJ
fQ0KIH0NCiANCiBzdGF0aWMgdm9pZCB6ZmNwX2VycF9hY3Rpb25fZGlzbWlzc19hZGFwdGVyKHN0
cnVjdCB6ZmNwX2FkYXB0ZXIgKmFkYXB0ZXIpDQpAQCAtNTkyLDkgKzU5NSwxMSBAQCBzdGF0aWMg
dm9pZCBfemZjcF9lcnBfbHVuX3Jlb3Blbl9hbGwoc3RydWN0IHpmY3BfcG9ydCAqcG9ydCwgaW50
IGNsZWFyLA0KIHsNCiAJc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2Ow0KIA0KLQlzaG9zdF9mb3Jf
ZWFjaF9kZXZpY2Uoc2RldiwgcG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0KQ0KKwlzcGluX2xvY2so
cG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0LT5ob3N0X2xvY2spOw0KKwlfX3Nob3N0X2Zvcl9lYWNo
X2RldmljZShzZGV2LCBwb3J0LT5hZGFwdGVyLT5zY3NpX2hvc3QpDQogCQlpZiAoc2Rldl90b196
ZmNwKHNkZXYpLT5wb3J0ID09IHBvcnQpDQogCQkJX3pmY3BfZXJwX2x1bl9yZW9wZW4oc2Rldiwg
Y2xlYXIsIGlkLCAwKTsNCisJc3Bpbl91bmxvY2socG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0LT5o
b3N0X2xvY2spOw0KIH0NCiANCiBzdGF0aWMgdm9pZCB6ZmNwX2VycF9zdHJhdGVneV9mb2xsb3d1
cF9mYWlsZWQoc3RydWN0IHpmY3BfZXJwX2FjdGlvbiAqYWN0KQ0KQEAgLTE0MzUsOCArMTQ0MCwx
MCBAQCB2b2lkIHpmY3BfZXJwX3NldF9hZGFwdGVyX3N0YXR1cyhzdHJ1Y3QgemZjcF9hZGFwdGVy
ICphZGFwdGVyLCB1MzIgbWFzaykNCiAJCWF0b21pY19zZXRfbWFzayhjb21tb25fbWFzaywgJnBv
cnQtPnN0YXR1cyk7DQogCXJlYWRfdW5sb2NrX2lycXJlc3RvcmUoJmFkYXB0ZXItPnBvcnRfbGlz
dF9sb2NrLCBmbGFncyk7DQogDQotCXNob3N0X2Zvcl9lYWNoX2RldmljZShzZGV2LCBhZGFwdGVy
LT5zY3NpX2hvc3QpDQorCXNwaW5fbG9ja19pcnFzYXZlKGFkYXB0ZXItPnNjc2lfaG9zdC0+aG9z
dF9sb2NrLCBmbGFncyk7DQorCV9fc2hvc3RfZm9yX2VhY2hfZGV2aWNlKHNkZXYsIGFkYXB0ZXIt
PnNjc2lfaG9zdCkNCiAJCWF0b21pY19zZXRfbWFzayhjb21tb25fbWFzaywgJnNkZXZfdG9femZj
cChzZGV2KS0+c3RhdHVzKTsNCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShhZGFwdGVyLT5zY3Np
X2hvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KIH0NCiANCiAvKioNCkBAIC0xNDcwLDExICsxNDc3
LDEzIEBAIHZvaWQgemZjcF9lcnBfY2xlYXJfYWRhcHRlcl9zdGF0dXMoc3RydWN0IHpmY3BfYWRh
cHRlciAqYWRhcHRlciwgdTMyIG1hc2spDQogCX0NCiAJcmVhZF91bmxvY2tfaXJxcmVzdG9yZSgm
YWRhcHRlci0+cG9ydF9saXN0X2xvY2ssIGZsYWdzKTsNCiANCi0Jc2hvc3RfZm9yX2VhY2hfZGV2
aWNlKHNkZXYsIGFkYXB0ZXItPnNjc2lfaG9zdCkgew0KKwlzcGluX2xvY2tfaXJxc2F2ZShhZGFw
dGVyLT5zY3NpX2hvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KKwlfX3Nob3N0X2Zvcl9lYWNoX2Rl
dmljZShzZGV2LCBhZGFwdGVyLT5zY3NpX2hvc3QpIHsNCiAJCWF0b21pY19jbGVhcl9tYXNrKGNv
bW1vbl9tYXNrLCAmc2Rldl90b196ZmNwKHNkZXYpLT5zdGF0dXMpOw0KIAkJaWYgKGNsZWFyX2Nv
dW50ZXIpDQogCQkJYXRvbWljX3NldCgmc2Rldl90b196ZmNwKHNkZXYpLT5lcnBfY291bnRlciwg
MCk7DQogCX0NCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShhZGFwdGVyLT5zY3NpX2hvc3QtPmhv
c3RfbG9jaywgZmxhZ3MpOw0KIH0NCiANCiAvKioNCkBAIC0xNDg4LDE2ICsxNDk3LDE5IEBAIHZv
aWQgemZjcF9lcnBfc2V0X3BvcnRfc3RhdHVzKHN0cnVjdCB6ZmNwX3BvcnQgKnBvcnQsIHUzMiBt
YXNrKQ0KIHsNCiAJc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2Ow0KIAl1MzIgY29tbW9uX21hc2sg
PSBtYXNrICYgWkZDUF9DT01NT05fRkxBR1M7DQorCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQog
CWF0b21pY19zZXRfbWFzayhtYXNrLCAmcG9ydC0+c3RhdHVzKTsNCiANCiAJaWYgKCFjb21tb25f
bWFzaykNCiAJCXJldHVybjsNCiANCi0Jc2hvc3RfZm9yX2VhY2hfZGV2aWNlKHNkZXYsIHBvcnQt
PmFkYXB0ZXItPnNjc2lfaG9zdCkNCisJc3Bpbl9sb2NrX2lycXNhdmUocG9ydC0+YWRhcHRlci0+
c2NzaV9ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCisJX19zaG9zdF9mb3JfZWFjaF9kZXZpY2Uo
c2RldiwgcG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0KQ0KIAkJaWYgKHNkZXZfdG9femZjcChzZGV2
KS0+cG9ydCA9PSBwb3J0KQ0KIAkJCWF0b21pY19zZXRfbWFzayhjb21tb25fbWFzaywNCiAJCQkJ
CSZzZGV2X3RvX3pmY3Aoc2RldiktPnN0YXR1cyk7DQorCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
cG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiB9DQogDQogLyoq
DQpAQCAtMTUxMiw2ICsxNTI0LDcgQEAgdm9pZCB6ZmNwX2VycF9jbGVhcl9wb3J0X3N0YXR1cyhz
dHJ1Y3QgemZjcF9wb3J0ICpwb3J0LCB1MzIgbWFzaykNCiAJc3RydWN0IHNjc2lfZGV2aWNlICpz
ZGV2Ow0KIAl1MzIgY29tbW9uX21hc2sgPSBtYXNrICYgWkZDUF9DT01NT05fRkxBR1M7DQogCXUz
MiBjbGVhcl9jb3VudGVyID0gbWFzayAmIFpGQ1BfU1RBVFVTX0NPTU1PTl9FUlBfRkFJTEVEOw0K
Kwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIA0KIAlhdG9taWNfY2xlYXJfbWFzayhtYXNrLCAmcG9y
dC0+c3RhdHVzKTsNCiANCkBAIC0xNTIxLDEzICsxNTM0LDE1IEBAIHZvaWQgemZjcF9lcnBfY2xl
YXJfcG9ydF9zdGF0dXMoc3RydWN0IHpmY3BfcG9ydCAqcG9ydCwgdTMyIG1hc2spDQogCWlmIChj
bGVhcl9jb3VudGVyKQ0KIAkJYXRvbWljX3NldCgmcG9ydC0+ZXJwX2NvdW50ZXIsIDApOw0KIA0K
LQlzaG9zdF9mb3JfZWFjaF9kZXZpY2Uoc2RldiwgcG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0KQ0K
KwlzcGluX2xvY2tfaXJxc2F2ZShwb3J0LT5hZGFwdGVyLT5zY3NpX2hvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOw0KKwlfX3Nob3N0X2Zvcl9lYWNoX2RldmljZShzZGV2LCBwb3J0LT5hZGFwdGVyLT5z
Y3NpX2hvc3QpDQogCQlpZiAoc2Rldl90b196ZmNwKHNkZXYpLT5wb3J0ID09IHBvcnQpIHsNCiAJ
CQlhdG9taWNfY2xlYXJfbWFzayhjb21tb25fbWFzaywNCiAJCQkJCSAgJnNkZXZfdG9femZjcChz
ZGV2KS0+c3RhdHVzKTsNCiAJCQlpZiAoY2xlYXJfY291bnRlcikNCiAJCQkJYXRvbWljX3NldCgm
c2Rldl90b196ZmNwKHNkZXYpLT5lcnBfY291bnRlciwgMCk7DQogCQl9DQorCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUocG9ydC0+YWRhcHRlci0+c2NzaV9ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsN
CiB9DQogDQogLyoqDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zMzkwL3Njc2kvemZjcF9xZGlvLmMg
Yi9kcml2ZXJzL3MzOTAvc2NzaS96ZmNwX3FkaW8uYw0KaW5kZXggZTc2ZDAwMy4uNTJjNmI1OSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvczM5MC9zY3NpL3pmY3BfcWRpby5jDQorKysgYi9kcml2ZXJz
L3MzOTAvc2NzaS96ZmNwX3FkaW8uYw0KQEAgLTIyNCwxMSArMjI0LDkgQEAgaW50IHpmY3BfcWRp
b19zYmFsc19mcm9tX3NnKHN0cnVjdCB6ZmNwX3FkaW8gKnFkaW8sIHN0cnVjdCB6ZmNwX3FkaW9f
cmVxICpxX3JlcSwNCiANCiBzdGF0aWMgaW50IHpmY3BfcWRpb19zYmFsX2NoZWNrKHN0cnVjdCB6
ZmNwX3FkaW8gKnFkaW8pDQogew0KLQlzcGluX2xvY2tfaXJxKCZxZGlvLT5yZXFfcV9sb2NrKTsN
CiAJaWYgKGF0b21pY19yZWFkKCZxZGlvLT5yZXFfcV9mcmVlKSB8fA0KIAkgICAgIShhdG9taWNf
cmVhZCgmcWRpby0+YWRhcHRlci0+c3RhdHVzKSAmIFpGQ1BfU1RBVFVTX0FEQVBURVJfUURJT1VQ
KSkNCiAJCXJldHVybiAxOw0KLQlzcGluX3VubG9ja19pcnEoJnFkaW8tPnJlcV9xX2xvY2spOw0K
IAlyZXR1cm4gMDsNCiB9DQogDQpAQCAtMjQ2LDkgKzI0NCw4IEBAIGludCB6ZmNwX3FkaW9fc2Jh
bF9nZXQoc3RydWN0IHpmY3BfcWRpbyAqcWRpbykNCiB7DQogCWxvbmcgcmV0Ow0KIA0KLQlzcGlu
X3VubG9ja19pcnEoJnFkaW8tPnJlcV9xX2xvY2spOw0KLQlyZXQgPSB3YWl0X2V2ZW50X2ludGVy
cnVwdGlibGVfdGltZW91dChxZGlvLT5yZXFfcV93cSwNCi0JCQkgICAgICAgemZjcF9xZGlvX3Ni
YWxfY2hlY2socWRpbyksIDUgKiBIWik7DQorCXJldCA9IHdhaXRfZXZlbnRfaW50ZXJydXB0aWJs
ZV9sb2NrX2lycV90aW1lb3V0KHFkaW8tPnJlcV9xX3dxLA0KKwkJICAgICAgIHpmY3BfcWRpb19z
YmFsX2NoZWNrKHFkaW8pLCBxZGlvLT5yZXFfcV9sb2NrLCA1ICogSFopOw0KIA0KIAlpZiAoIShh
dG9taWNfcmVhZCgmcWRpby0+YWRhcHRlci0+c3RhdHVzKSAmIFpGQ1BfU1RBVFVTX0FEQVBURVJf
UURJT1VQKSkNCiAJCXJldHVybiAtRUlPOw0KQEAgLTI2Miw3ICsyNTksNiBAQCBpbnQgemZjcF9x
ZGlvX3NiYWxfZ2V0KHN0cnVjdCB6ZmNwX3FkaW8gKnFkaW8pDQogCQl6ZmNwX2VycF9hZGFwdGVy
X3Jlb3BlbihxZGlvLT5hZGFwdGVyLCAwLCAicWRzYmdfMSIpOw0KIAl9DQogDQotCXNwaW5fbG9j
a19pcnEoJnFkaW8tPnJlcV9xX2xvY2spOw0KIAlyZXR1cm4gLUVJTzsNCiB9DQogDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMgYi9kcml2ZXJz
L3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYw0KaW5kZXggZmM1YTJlZi4uYjAxODk5
NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
DQorKysgYi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYw0KQEAgLTM1
NDcsMTEgKzM1NDcsMjEgQEAgc3RhdGljIGludCBtZWdhc2FzX2luaXRfZncoc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlKQ0KIAkJYnJlYWs7DQogCX0NCiANCi0JLyoNCi0JICogV2Ug
ZXhwZWN0IHRoZSBGVyBzdGF0ZSB0byBiZSBSRUFEWQ0KLQkgKi8NCi0JaWYgKG1lZ2FzYXNfdHJh
bnNpdGlvbl90b19yZWFkeShpbnN0YW5jZSwgMCkpDQotCQlnb3RvIGZhaWxfcmVhZHlfc3RhdGU7
DQorCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFuY2UsIDApKSB7DQorCQlh
dG9taWNfc2V0KCZpbnN0YW5jZS0+ZndfcmVzZXRfbm9fcGNpX2FjY2VzcywgMSk7DQorCQlpbnN0
YW5jZS0+aW5zdGFuY2V0LT5hZHBfcmVzZXQNCisJCQkoaW5zdGFuY2UsIGluc3RhbmNlLT5yZWdf
c2V0KTsNCisJCWF0b21pY19zZXQoJmluc3RhbmNlLT5md19yZXNldF9ub19wY2lfYWNjZXNzLCAw
KTsNCisJCWRldl9pbmZvKCZpbnN0YW5jZS0+cGRldi0+ZGV2LA0KKwkJCSJtZWdhc2FzOiBGVyBy
ZXN0YXJ0ZWQgc3VjY2Vzc2Z1bGx5IGZyb20gJXMhXG4iLA0KKwkJCV9fZnVuY19fKTsNCisNCisJ
CS8qd2FpdHRpbmcgZm9yIGFib3V0IDMwIHNlY29uZCBiZWZvcmUgcmV0cnkqLw0KKwkJc3NsZWVw
KDMwKTsNCisNCisJCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFuY2UsIDAp
KQ0KKwkJCWdvdG8gZmFpbF9yZWFkeV9zdGF0ZTsNCisJfQ0KIA0KIAkvKiBDaGVjayBpZiBNU0kt
WCBpcyBzdXBwb3J0ZWQgd2hpbGUgaW4gcmVhZHkgc3RhdGUgKi8NCiAJbXNpeF9lbmFibGUgPSAo
aW5zdGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19zdGF0dXNfcmVnKHJlZ19zZXQpICYNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvbnNwMzIuYyBiL2RyaXZlcnMvc2NzaS9uc3AzMi5jDQppbmRl
eCBmNmE1MGM5Li5iZmIwNWI4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL25zcDMyLmMNCisr
KyBiL2RyaXZlcnMvc2NzaS9uc3AzMi5jDQpAQCAtMjkyNyw3ICsyOTI3LDcgQEAgc3RhdGljIHZv
aWQgbnNwMzJfZG9fYnVzX3Jlc2V0KG5zcDMyX2h3X2RhdGEgKmRhdGEpDQogCSAqIHJlc2V0IFND
U0kgYnVzDQogCSAqLw0KIAluc3AzMl93cml0ZTEoYmFzZSwgU0NTSV9CVVNfQ09OVFJPTCwgQlVT
Q1RMX1JTVCk7DQotCXVkZWxheShSRVNFVF9IT0xEX1RJTUUpOw0KKwltZGVsYXkoUkVTRVRfSE9M
RF9USU1FIC8gMTAwMCk7DQogCW5zcDMyX3dyaXRlMShiYXNlLCBTQ1NJX0JVU19DT05UUk9MLCAw
KTsNCiAJZm9yKGkgPSAwOyBpIDwgNTsgaSsrKSB7DQogCQlpbnRyZGF0ID0gbnNwMzJfcmVhZDIo
YmFzZSwgSVJRX1NUQVRVUyk7IC8qIGR1bW15IHJlYWQgKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3RhcmdldC90YXJnZXRfY29yZV9jZGIuYyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2Nk
Yi5jDQppbmRleCA3MTdhOGQ0Li45MDNiMmY1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy90YXJnZXQv
dGFyZ2V0X2NvcmVfY2RiLmMNCisrKyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2NkYi5j
DQpAQCAtMTI3LDExICsxMjcsMTIgQEAgdGFyZ2V0X2VtdWxhdGVfaW5xdWlyeV9zdGQoc3RydWN0
IHNlX2NtZCAqY21kKQ0KIAkJZ290byBvdXQ7DQogCX0NCiANCi0Jc25wcmludGYoKHVuc2lnbmVk
IGNoYXIgKikmYnVmWzhdLCA4LCAiTElPLU9SRyIpOw0KLQlzbnByaW50ZigodW5zaWduZWQgY2hh
ciAqKSZidWZbMTZdLCAxNiwgIiVzIiwNCi0JCSAmZGV2LT5zZV9zdWJfZGV2LT50MTBfd3duLm1v
ZGVsWzBdKTsNCi0Jc25wcmludGYoKHVuc2lnbmVkIGNoYXIgKikmYnVmWzMyXSwgNCwgIiVzIiwN
Ci0JCSAmZGV2LT5zZV9zdWJfZGV2LT50MTBfd3duLnJldmlzaW9uWzBdKTsNCisJbWVtY3B5KCZi
dWZbOF0sICJMSU8tT1JHICIsIDgpOw0KKwltZW1zZXQoJmJ1ZlsxNl0sIDB4MjAsIDE2KTsNCisJ
bWVtY3B5KCZidWZbMTZdLCBkZXYtPnNlX3N1Yl9kZXYtPnQxMF93d24ubW9kZWwsDQorCSAgICAg
ICBtaW5fdChzaXplX3QsIHN0cmxlbihkZXYtPnNlX3N1Yl9kZXYtPnQxMF93d24ubW9kZWwpLCAx
NikpOw0KKwltZW1jcHkoJmJ1ZlszMl0sIGRldi0+c2Vfc3ViX2Rldi0+dDEwX3d3bi5yZXZpc2lv
biwNCisJICAgICAgIG1pbl90KHNpemVfdCwgc3RybGVuKGRldi0+c2Vfc3ViX2Rldi0+dDEwX3d3
bi5yZXZpc2lvbiksIDQpKTsNCiAJYnVmWzRdID0gMzE7IC8qIFNldCBhZGRpdGlvbmFsIGxlbmd0
aCB0byAzMSAqLw0KIA0KIG91dDoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3R0eS9odmMvaHZzaV9s
aWIuYyBiL2RyaXZlcnMvdHR5L2h2Yy9odnNpX2xpYi5jDQppbmRleCA2ZjRkZDgzLi4zNzQ5Njg4
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvaHZjL2h2c2lfbGliLmMNCisrKyBiL2RyaXZlcnMv
dHR5L2h2Yy9odnNpX2xpYi5jDQpAQCAtMzQxLDggKzM0MSw4IEBAIHZvaWQgaHZzaWxpYl9lc3Rh
Ymxpc2goc3RydWN0IGh2c2lfcHJpdiAqcHYpDQogDQogCXByX2RldmVsKCJIVlNJQCV4OiAgIC4u
LiB3YWl0aW5nIGhhbmRzaGFrZVxuIiwgcHYtPnRlcm1ubyk7DQogDQotCS8qIFRyeSBmb3IgdXAg
dG8gMjAwcyAqLw0KLQlmb3IgKHRpbWVvdXQgPSAwOyB0aW1lb3V0IDwgMjA7IHRpbWVvdXQrKykg
ew0KKwkvKiBUcnkgZm9yIHVwIHRvIDQwMG1zICovDQorCWZvciAodGltZW91dCA9IDA7IHRpbWVv
dXQgPCA0MDsgdGltZW91dCsrKSB7DQogCQlpZiAocHYtPmVzdGFibGlzaGVkKQ0KIAkJCWdvdG8g
ZXN0YWJsaXNoZWQ7DQogCQlpZiAoIWh2c2lfZ2V0X3BhY2tldChwdikpDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy90dHkvc2VyaWFsL214cy1hdWFydC5jIGIvZHJpdmVycy90dHkvc2VyaWFsL214cy1h
dWFydC5jDQppbmRleCA1YjNkMDYzLi5hYjdkMTFlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkv
c2VyaWFsL214cy1hdWFydC5jDQorKysgYi9kcml2ZXJzL3R0eS9zZXJpYWwvbXhzLWF1YXJ0LmMN
CkBAIC0zNzQsMTEgKzM3NCwxOCBAQCBzdGF0aWMgdm9pZCBteHNfYXVhcnRfc2V0dGVybWlvcyhz
dHJ1Y3QgdWFydF9wb3J0ICp1LA0KIA0KIHN0YXRpYyBpcnFyZXR1cm5fdCBteHNfYXVhcnRfaXJx
X2hhbmRsZShpbnQgaXJxLCB2b2lkICpjb250ZXh0KQ0KIHsNCi0JdTMyIGlzdGF0dXMsIGlzdGF0
Ow0KKwl1MzIgaXN0YXQ7DQogCXN0cnVjdCBteHNfYXVhcnRfcG9ydCAqcyA9IGNvbnRleHQ7DQog
CXUzMiBzdGF0ID0gcmVhZGwocy0+cG9ydC5tZW1iYXNlICsgQVVBUlRfU1RBVCk7DQogDQotCWlz
dGF0dXMgPSBpc3RhdCA9IHJlYWRsKHMtPnBvcnQubWVtYmFzZSArIEFVQVJUX0lOVFIpOw0KKwlp
c3RhdCA9IHJlYWRsKHMtPnBvcnQubWVtYmFzZSArIEFVQVJUX0lOVFIpOw0KKw0KKwkvKiBhY2sg
aXJxICovDQorCXdyaXRlbChpc3RhdCAmIChBVUFSVF9JTlRSX1JUSVMNCisJCXwgQVVBUlRfSU5U
Ul9UWElTDQorCQl8IEFVQVJUX0lOVFJfUlhJUw0KKwkJfCBBVUFSVF9JTlRSX0NUU01JUyksDQor
CQkJcy0+cG9ydC5tZW1iYXNlICsgQVVBUlRfSU5UUl9DTFIpOw0KIA0KIAlpZiAoaXN0YXQgJiBB
VUFSVF9JTlRSX0NUU01JUykgew0KIAkJdWFydF9oYW5kbGVfY3RzX2NoYW5nZSgmcy0+cG9ydCwg
c3RhdCAmIEFVQVJUX1NUQVRfQ1RTKTsNCkBAIC0zOTcsMTIgKzQwNCw2IEBAIHN0YXRpYyBpcnFy
ZXR1cm5fdCBteHNfYXVhcnRfaXJxX2hhbmRsZShpbnQgaXJxLCB2b2lkICpjb250ZXh0KQ0KIAkJ
aXN0YXQgJj0gfkFVQVJUX0lOVFJfVFhJUzsNCiAJfQ0KIA0KLQl3cml0ZWwoaXN0YXR1cyAmIChB
VUFSVF9JTlRSX1JUSVMNCi0JCXwgQVVBUlRfSU5UUl9UWElTDQotCQl8IEFVQVJUX0lOVFJfUlhJ
Uw0KLQkJfCBBVUFSVF9JTlRSX0NUU01JUyksDQotCQkJcy0+cG9ydC5tZW1iYXNlICsgQVVBUlRf
SU5UUl9DTFIpOw0KLQ0KIAlyZXR1cm4gSVJRX0hBTkRMRUQ7DQogfQ0KIA0KQEAgLTU0Miw3ICs1
NDMsNyBAQCBhdWFydF9jb25zb2xlX3dyaXRlKHN0cnVjdCBjb25zb2xlICpjbywgY29uc3QgY2hh
ciAqc3RyLCB1bnNpZ25lZCBpbnQgY291bnQpDQogCXN0cnVjdCBteHNfYXVhcnRfcG9ydCAqczsN
CiAJc3RydWN0IHVhcnRfcG9ydCAqcG9ydDsNCiAJdW5zaWduZWQgaW50IG9sZF9jdHJsMCwgb2xk
X2N0cmwyOw0KLQl1bnNpZ25lZCBpbnQgdG8gPSAxMDAwOw0KKwl1bnNpZ25lZCBpbnQgdG8gPSAy
MDAwMDsNCiANCiAJaWYgKGNvLT5pbmRleCA+CU1YU19BVUFSVF9QT1JUUyB8fCBjby0+aW5kZXgg
PCAwKQ0KIAkJcmV0dXJuOw0KQEAgLTU2MywxOCArNTY0LDIzIEBAIGF1YXJ0X2NvbnNvbGVfd3Jp
dGUoc3RydWN0IGNvbnNvbGUgKmNvLCBjb25zdCBjaGFyICpzdHIsIHVuc2lnbmVkIGludCBjb3Vu
dCkNCiANCiAJdWFydF9jb25zb2xlX3dyaXRlKHBvcnQsIHN0ciwgY291bnQsIG14c19hdWFydF9j
b25zb2xlX3B1dGNoYXIpOw0KIA0KLQkvKg0KLQkgKiBGaW5hbGx5LCB3YWl0IGZvciB0cmFuc21p
dHRlciB0byBiZWNvbWUgZW1wdHkNCi0JICogYW5kIHJlc3RvcmUgdGhlIFRDUg0KLQkgKi8NCisJ
LyogRmluYWxseSwgd2FpdCBmb3IgdHJhbnNtaXR0ZXIgdG8gYmVjb21lIGVtcHR5IC4uLiAqLw0K
IAl3aGlsZSAocmVhZGwocG9ydC0+bWVtYmFzZSArIEFVQVJUX1NUQVQpICYgQVVBUlRfU1RBVF9C
VVNZKSB7DQorCQl1ZGVsYXkoMSk7DQogCQlpZiAoIXRvLS0pDQogCQkJYnJlYWs7DQotCQl1ZGVs
YXkoMSk7DQogCX0NCiANCi0Jd3JpdGVsKG9sZF9jdHJsMCwgcG9ydC0+bWVtYmFzZSArIEFVQVJU
X0NUUkwwKTsNCi0Jd3JpdGVsKG9sZF9jdHJsMiwgcG9ydC0+bWVtYmFzZSArIEFVQVJUX0NUUkwy
KTsNCisJLyoNCisJICogLi4uIGFuZCByZXN0b3JlIHRoZSBUQ1IgaWYgd2Ugd2FpdGVkIGxvbmcg
ZW5vdWdoIGZvciB0aGUgdHJhbnNtaXR0ZXINCisJICogdG8gYmUgaWRsZS4gVGhpcyBtaWdodCBr
ZWVwIHRoZSB0cmFuc21pdHRlciBlbmFibGVkIGFsdGhvdWdoIGl0IGlzDQorCSAqIHVudXNlZCwg
YnV0IHRoYXQgaXMgYmV0dGVyIHRoYW4gdG8gZGlzYWJsZSBpdCB3aGlsZSBpdCBpcyBzdGlsbA0K
KwkgKiB0cmFuc21pdHRpbmcuDQorCSAqLw0KKwlpZiAoIShyZWFkbChwb3J0LT5tZW1iYXNlICsg
QVVBUlRfU1RBVCkgJiBBVUFSVF9TVEFUX0JVU1kpKSB7DQorCQl3cml0ZWwob2xkX2N0cmwwLCBw
b3J0LT5tZW1iYXNlICsgQVVBUlRfQ1RSTDApOw0KKwkJd3JpdGVsKG9sZF9jdHJsMiwgcG9ydC0+
bWVtYmFzZSArIEFVQVJUX0NUUkwyKTsNCisJfQ0KIA0KIAljbGtfZGlzYWJsZShzLT5jbGspOw0K
IH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb3JlL3F1aXJrcy5jIGIvZHJpdmVycy91c2Iv
Y29yZS9xdWlya3MuYw0KaW5kZXggMmZiY2I3NS4uZjUyMTgyZCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvdXNiL2NvcmUvcXVpcmtzLmMNCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvcXVpcmtzLmMNCkBA
IC03OCw2ICs3OCwxMiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgdXNiX3F1
aXJrX2xpc3RbXSA9IHsNCiAJeyBVU0JfREVWSUNFKDB4MDRkOCwgMHgwMDBjKSwgLmRyaXZlcl9p
bmZvID0NCiAJCQlVU0JfUVVJUktfQ09ORklHX0lOVEZfU1RSSU5HUyB9LA0KIA0KKwkvKiBDYXJy
b2xUb3VjaCA0MDAwVSAqLw0KKwl7IFVTQl9ERVZJQ0UoMHgwNGU3LCAweDAwMDkpLCAuZHJpdmVy
X2luZm8gPSBVU0JfUVVJUktfUkVTRVRfUkVTVU1FIH0sDQorDQorCS8qIENhcnJvbFRvdWNoIDQ1
MDBVICovDQorCXsgVVNCX0RFVklDRSgweDA0ZTcsIDB4MDAzMCksIC5kcml2ZXJfaW5mbyA9IFVT
Ql9RVUlSS19SRVNFVF9SRVNVTUUgfSwNCisNCiAJLyogU2Ftc3VuZyBBbmRyb2lkIHBob25lIG1v
ZGVtIC0gSUQgY29uZmxpY3Qgd2l0aCBTUEgtSTUwMCAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgwNGU4
LCAweDY2MDEpLCAuZHJpdmVyX2luZm8gPQ0KIAkJCVVTQl9RVUlSS19DT05GSUdfSU5URl9TVFJJ
TkdTIH0sDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvbWlzYy9hZHV0dXguYyBiL2RyaXZlcnMv
dXNiL21pc2MvYWR1dHV4LmMNCmluZGV4IGZlODU4NzEuLmRiNTEyOGI3ZSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvdXNiL21pc2MvYWR1dHV4LmMNCisrKyBiL2RyaXZlcnMvdXNiL21pc2MvYWR1dHV4
LmMNCkBAIC04MjksNyArODI5LDcgQEAgc3RhdGljIGludCBhZHVfcHJvYmUoc3RydWN0IHVzYl9p
bnRlcmZhY2UgKmludGVyZmFjZSwNCiANCiAJLyogbGV0IHRoZSB1c2VyIGtub3cgd2hhdCBub2Rl
IHRoaXMgZGV2aWNlIGlzIG5vdyBhdHRhY2hlZCB0byAqLw0KIAlkZXZfaW5mbygmaW50ZXJmYWNl
LT5kZXYsICJBRFUlZCAlcyBub3cgYXR0YWNoZWQgdG8gL2Rldi91c2IvYWR1dHV4JWRcbiIsDQot
CQkgdWRldi0+ZGVzY3JpcHRvci5pZFByb2R1Y3QsIGRldi0+c2VyaWFsX251bWJlciwNCisJCSBs
ZTE2X3RvX2NwdSh1ZGV2LT5kZXNjcmlwdG9yLmlkUHJvZHVjdCksIGRldi0+c2VyaWFsX251bWJl
ciwNCiAJCSAoZGV2LT5taW5vciAtIEFEVV9NSU5PUl9CQVNFKSk7DQogZXhpdDoNCiAJZGJnKDIs
IiAlcyA6IGxlYXZlLCByZXR1cm4gdmFsdWUgJXAgKGRldikiLCBfX2Z1bmNfXywgZGV2KTsNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYyBiL2RyaXZlcnMvdXNiL3Nl
cmlhbC9mdGRpX3Npby5jDQppbmRleCBjZTlmODdmLi5hM2Y2ZmUwIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRp
X3Npby5jDQpAQCAtNzQzLDkgKzc0MywzNCBAQCBzdGF0aWMgc3RydWN0IHVzYl9kZXZpY2VfaWQg
aWRfdGFibGVfY29tYmluZWQgW10gPSB7DQogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9O
RElfQVVST1JBX1NDVV9QSUQpLA0KIAkJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZm
dGRpX05ESV9kZXZpY2VfcXVpcmsgfSwNCiAJeyBVU0JfREVWSUNFKFRFTExEVVNfVklELCBURUxM
RFVTX1RFTExTVElDS19QSUQpIH0sDQotCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZ
U1RFTVNfU0VSSUFMX1ZYN19QSUQpIH0sDQotCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBS
VFNZU1RFTVNfQ1QyOUJfUElEKSB9LA0KLQl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRT
WVNURU1TX1JUUzAxX1BJRCkgfSwNCisJeyBVU0JfREVWSUNFKFJUU1lTVEVNU19WSUQsIFJUU1lT
VEVNU19VU0JfUzAzX1BJRCkgfSwNCisJeyBVU0JfREVWSUNFKFJUU1lTVEVNU19WSUQsIFJUU1lT
VEVNU19VU0JfNTlfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl81N0FfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl81N0JfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl8yOUFfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl8yOUJfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl8yOUZfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl82MkJfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl9TMDFfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNU
RU1TX1VTQl82M19QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCXzI5Q19QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCXzgxQl9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCXzgyQl9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCX0s1RF9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCX0s0WV9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCX0s1R19QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCX1MwNV9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RF
TVNfVVNCXzYwX1BJRCkgfSwNCisJeyBVU0JfREVWSUNFKFJUU1lTVEVNU19WSUQsIFJUU1lTVEVN
U19VU0JfNjFfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNURU1T
X1VTQl82Ml9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RFTVNf
VVNCXzYzQl9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RFTVNf
VVNCXzY0X1BJRCkgfSwNCisJeyBVU0JfREVWSUNFKFJUU1lTVEVNU19WSUQsIFJUU1lTVEVNU19V
U0JfNjVfUElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoUlRTWVNURU1TX1ZJRCwgUlRTWVNURU1TX1VT
Ql85Ml9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RFTVNfVVNC
XzkyRF9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RFTVNfVVNC
X1c1Ul9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RFTVNfVVNC
X0E1Ul9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShSVFNZU1RFTVNfVklELCBSVFNZU1RFTVNfVVNC
X1BXMV9QSUQpIH0sDQogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9NQVhTVFJFQU1fUElE
KSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfUEhJX0ZJU0NPX1BJRCkgfSwNCiAJ
eyBVU0JfREVWSUNFKFRNTF9WSUQsIFRNTF9VU0JfU0VSSUFMX1BJRCkgfSwNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW9faWRzLmggYi9kcml2ZXJzL3VzYi9zZXJpYWwv
ZnRkaV9zaW9faWRzLmgNCmluZGV4IDVkMjVlMjYuLjYxNjg1ZWQgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW9faWRzLmgNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9m
dGRpX3Npb19pZHMuaA0KQEAgLTgxNSwxMSArODE1LDM1IEBADQogLyoNCiAgKiBSVCBTeXN0ZW1z
IHByb2dyYW1taW5nIGNhYmxlcyBmb3IgdmFyaW91cyBoYW0gcmFkaW9zDQogICovDQotI2RlZmlu
ZSBSVFNZU1RFTVNfVklECQkJMHgyMTAwCS8qIFZlbmRvciBJRCAqLw0KLSNkZWZpbmUgUlRTWVNU
RU1TX1NFUklBTF9WWDdfUElECTB4OWU1MgkvKiBTZXJpYWwgY29udmVydGVyIGZvciBWWC03IFJh
ZGlvcyB1c2luZyBGVDIzMlJMICovDQotI2RlZmluZSBSVFNZU1RFTVNfQ1QyOUJfUElECQkweDll
NTQJLyogQ1QyOUIgUmFkaW8gQ2FibGUgKi8NCi0jZGVmaW5lIFJUU1lTVEVNU19SVFMwMV9QSUQJ
CTB4OWU1NwkvKiBVU0ItUlRTMDEgUmFkaW8gQ2FibGUgKi8NCi0NCisjZGVmaW5lIFJUU1lTVEVN
U19WSUQJCTB4MjEwMAkvKiBWZW5kb3IgSUQgKi8NCisjZGVmaW5lIFJUU1lTVEVNU19VU0JfUzAz
X1BJRAkweDkwMDEJLyogUlRTLTAzIFVTQiB0byBTZXJpYWwgQWRhcHRlciAqLw0KKyNkZWZpbmUg
UlRTWVNURU1TX1VTQl81OV9QSUQJMHg5ZTUwCS8qIFVTQi01OSBVU0IgdG8gOCBwaW4gcGx1ZyAq
Lw0KKyNkZWZpbmUgUlRTWVNURU1TX1VTQl81N0FfUElECTB4OWU1MQkvKiBVU0ItNTdBIFVTQiB0
byA0cGluIDMuNW1tIHBsdWcgKi8NCisjZGVmaW5lIFJUU1lTVEVNU19VU0JfNTdCX1BJRAkweDll
NTIJLyogVVNCLTU3QiBVU0IgdG8gZXh0ZW5kZWQgNHBpbiAzLjVtbSBwbHVnICovDQorI2RlZmlu
ZSBSVFNZU1RFTVNfVVNCXzI5QV9QSUQJMHg5ZTUzCS8qIFVTQi0yOUEgVVNCIHRvIDMuNW1tIHN0
ZXJlbyBwbHVnICovDQorI2RlZmluZSBSVFNZU1RFTVNfVVNCXzI5Ql9QSUQJMHg5ZTU0CS8qIFVT
Qi0yOUIgVVNCIHRvIDYgcGluIG1pbmkgZGluICovDQorI2RlZmluZSBSVFNZU1RFTVNfVVNCXzI5
Rl9QSUQJMHg5ZTU1CS8qIFVTQi0yOUYgVVNCIHRvIDYgcGluIG1vZHVsYXIgcGx1ZyAqLw0KKyNk
ZWZpbmUgUlRTWVNURU1TX1VTQl82MkJfUElECTB4OWU1NgkvKiBVU0ItNjJCIFVTQiB0byA4IHBp
biBtaW5pIGRpbiBwbHVnKi8NCisjZGVmaW5lIFJUU1lTVEVNU19VU0JfUzAxX1BJRAkweDllNTcJ
LyogVVNCLVJUUzAxIFVTQiB0byAzLjUgbW0gc3RlcmVvIHBsdWcqLw0KKyNkZWZpbmUgUlRTWVNU
RU1TX1VTQl82M19QSUQJMHg5ZTU4CS8qIFVTQi02MyBVU0IgdG8gOSBwaW4gZmVtYWxlKi8NCisj
ZGVmaW5lIFJUU1lTVEVNU19VU0JfMjlDX1BJRAkweDllNTkJLyogVVNCLTI5QyBVU0IgdG8gNCBw
aW4gbW9kdWxhciBwbHVnKi8NCisjZGVmaW5lIFJUU1lTVEVNU19VU0JfODFCX1BJRAkweDllNUEJ
LyogVVNCLTgxIFVTQiB0byA4IHBpbiBtaW5pIGRpbiBwbHVnKi8NCisjZGVmaW5lIFJUU1lTVEVN
U19VU0JfODJCX1BJRAkweDllNUIJLyogVVNCLTgyIFVTQiB0byAyLjUgbW0gc3RlcmVvIHBsdWcq
Lw0KKyNkZWZpbmUgUlRTWVNURU1TX1VTQl9LNURfUElECTB4OWU1QwkvKiBVU0ItSzVEIFVTQiB0
byA4IHBpbiBtb2R1bGFyIHBsdWcqLw0KKyNkZWZpbmUgUlRTWVNURU1TX1VTQl9LNFlfUElECTB4
OWU1RAkvKiBVU0ItSzRZIFVTQiB0byAyLjUvMy41IG1tIHBsdWdzKi8NCisjZGVmaW5lIFJUU1lT
VEVNU19VU0JfSzVHX1BJRAkweDllNUUJLyogVVNCLUs1RyBVU0IgdG8gOCBwaW4gbW9kdWxhciBw
bHVnKi8NCisjZGVmaW5lIFJUU1lTVEVNU19VU0JfUzA1X1BJRAkweDllNUYJLyogVVNCLVJUUzA1
IFVTQiB0byAyLjUgbW0gc3RlcmVvIHBsdWcqLw0KKyNkZWZpbmUgUlRTWVNURU1TX1VTQl82MF9Q
SUQJMHg5ZTYwCS8qIFVTQi02MCBVU0IgdG8gNiBwaW4gZGluKi8NCisjZGVmaW5lIFJUU1lTVEVN
U19VU0JfNjFfUElECTB4OWU2MQkvKiBVU0ItNjEgVVNCIHRvIDYgcGluIG1pbmkgZGluKi8NCisj
ZGVmaW5lIFJUU1lTVEVNU19VU0JfNjJfUElECTB4OWU2MgkvKiBVU0ItNjIgVVNCIHRvIDggcGlu
IG1pbmkgZGluKi8NCisjZGVmaW5lIFJUU1lTVEVNU19VU0JfNjNCX1BJRAkweDllNjMJLyogVVNC
LTYzIFVTQiB0byA5IHBpbiBmZW1hbGUqLw0KKyNkZWZpbmUgUlRTWVNURU1TX1VTQl82NF9QSUQJ
MHg5ZTY0CS8qIFVTQi02NCBVU0IgdG8gOSBwaW4gbWFsZSovDQorI2RlZmluZSBSVFNZU1RFTVNf
VVNCXzY1X1BJRAkweDllNjUJLyogVVNCLTY1IFVTQiB0byA5IHBpbiBmZW1hbGUgbnVsbCBtb2Rl
bSovDQorI2RlZmluZSBSVFNZU1RFTVNfVVNCXzkyX1BJRAkweDllNjYJLyogVVNCLTkyIFVTQiB0
byAxMiBwaW4gcGx1ZyovDQorI2RlZmluZSBSVFNZU1RFTVNfVVNCXzkyRF9QSUQJMHg5ZTY3CS8q
IFVTQi05MkQgVVNCIHRvIDEyIHBpbiBwbHVnIGRhdGEqLw0KKyNkZWZpbmUgUlRTWVNURU1TX1VT
Ql9XNVJfUElECTB4OWU2OAkvKiBVU0ItVzVSIFVTQiB0byA4IHBpbiBtb2R1bGFyIHBsdWcqLw0K
KyNkZWZpbmUgUlRTWVNURU1TX1VTQl9BNVJfUElECTB4OWU2OQkvKiBVU0ItQTVSIFVTQiB0byA4
IHBpbiBtb2R1bGFyIHBsdWcqLw0KKyNkZWZpbmUgUlRTWVNURU1TX1VTQl9QVzFfUElECTB4OWU2
QQkvKiBVU0ItUFcxIFVTQiB0byA4IHBpbiBtb2R1bGFyIHBsdWcqLw0KIA0KIC8qDQogICogUGh5
c2lrIEluc3RydW1lbnRlDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL2tleXNwYW4u
YyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9rZXlzcGFuLmMNCmluZGV4IDRmNDE1ZTI4Li5iNjY4MDY5
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2tleXNwYW4uYw0KKysrIGIvZHJpdmVy
cy91c2Ivc2VyaWFsL2tleXNwYW4uYw0KQEAgLTI2MjAsNyArMjYyMCw3IEBAIHN0YXRpYyBpbnQg
a2V5c3Bhbl9zdGFydHVwKHN0cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwpDQogCWlmIChkX2RldGFp
bHMgPT0gTlVMTCkgew0KIAkJZGV2X2Vycigmc2VyaWFsLT5kZXYtPmRldiwgIiVzIC0gdW5rbm93
biBwcm9kdWN0IGlkICV4XG4iLA0KIAkJICAgIF9fZnVuY19fLCBsZTE2X3RvX2NwdShzZXJpYWwt
PmRldi0+ZGVzY3JpcHRvci5pZFByb2R1Y3QpKTsNCi0JCXJldHVybiAxOw0KKwkJcmV0dXJuIC1F
Tk9ERVY7DQogCX0NCiANCiAJLyogU2V0dXAgcHJpdmF0ZSBkYXRhIGZvciBzZXJpYWwgZHJpdmVy
ICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL21vczc3MjAuYyBiL2RyaXZlcnMv
dXNiL3NlcmlhbC9tb3M3NzIwLmMNCmluZGV4IDk1ODA2NzkuLjkyNzBkNWMgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3VzYi9zZXJpYWwvbW9zNzcyMC5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwv
bW9zNzcyMC5jDQpAQCAtOTcsNiArOTcsNyBAQCBzdHJ1Y3QgdXJidHJhY2tlciB7DQogCXN0cnVj
dCBsaXN0X2hlYWQgICAgICAgIHVyYmxpc3RfZW50cnk7DQogCXN0cnVjdCBrcmVmICAgICAgICAg
ICAgIHJlZl9jb3VudDsNCiAJc3RydWN0IHVyYiAgICAgICAgICAgICAgKnVyYjsNCisJc3RydWN0
IHVzYl9jdHJscmVxdWVzdAkqc2V0dXA7DQogfTsNCiANCiBlbnVtIG1vczc3MTVfcHBfbW9kZXMg
ew0KQEAgLTI3OSw2ICsyODAsNyBAQCBzdGF0aWMgdm9pZCBkZXN0cm95X3VyYnRyYWNrZXIoc3Ry
dWN0IGtyZWYgKmtyZWYpDQogCXN0cnVjdCBtb3M3NzE1X3BhcnBvcnQgKm1vc19wYXJwb3J0ID0g
dXJidHJhY2stPm1vc19wYXJwb3J0Ow0KIAlkYmcoIiVzIGNhbGxlZCIsIF9fZnVuY19fKTsNCiAJ
dXNiX2ZyZWVfdXJiKHVyYnRyYWNrLT51cmIpOw0KKwlrZnJlZSh1cmJ0cmFjay0+c2V0dXApOw0K
IAlrZnJlZSh1cmJ0cmFjayk7DQogCWtyZWZfcHV0KCZtb3NfcGFycG9ydC0+cmVmX2NvdW50LCBk
ZXN0cm95X21vc19wYXJwb3J0KTsNCiB9DQpAQCAtMzYzLDcgKzM2NSw2IEBAIHN0YXRpYyBpbnQg
d3JpdGVfcGFycG9ydF9yZWdfbm9uYmxvY2soc3RydWN0IG1vczc3MTVfcGFycG9ydCAqbW9zX3Bh
cnBvcnQsDQogCXN0cnVjdCB1cmJ0cmFja2VyICp1cmJ0cmFjazsNCiAJaW50IHJldF92YWw7DQog
CXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQotCXN0cnVjdCB1c2JfY3RybHJlcXVlc3Qgc2V0dXA7DQog
CXN0cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwgPSBtb3NfcGFycG9ydC0+c2VyaWFsOw0KIAlzdHJ1
Y3QgdXNiX2RldmljZSAqdXNiZGV2ID0gc2VyaWFsLT5kZXY7DQogCWRiZygiJXMgY2FsbGVkIiwg
X19mdW5jX18pOw0KQEAgLTM4MiwxNCArMzgzLDIwIEBAIHN0YXRpYyBpbnQgd3JpdGVfcGFycG9y
dF9yZWdfbm9uYmxvY2soc3RydWN0IG1vczc3MTVfcGFycG9ydCAqbW9zX3BhcnBvcnQsDQogCQlr
ZnJlZSh1cmJ0cmFjayk7DQogCQlyZXR1cm4gLUVOT01FTTsNCiAJfQ0KLQlzZXR1cC5iUmVxdWVz
dFR5cGUgPSAoX191OCkweDQwOw0KLQlzZXR1cC5iUmVxdWVzdCA9IChfX3U4KTB4MGU7DQotCXNl
dHVwLndWYWx1ZSA9IGdldF9yZWdfdmFsdWUocmVnLCBkdW1teSk7DQotCXNldHVwLndJbmRleCA9
IGdldF9yZWdfaW5kZXgocmVnKTsNCi0Jc2V0dXAud0xlbmd0aCA9IDA7DQorCXVyYnRyYWNrLT5z
ZXR1cCA9IGttYWxsb2Moc2l6ZW9mKCp1cmJ0cmFjay0+c2V0dXApLCBHRlBfS0VSTkVMKTsNCisJ
aWYgKCF1cmJ0cmFjay0+c2V0dXApIHsNCisJCXVzYl9mcmVlX3VyYih1cmJ0cmFjay0+dXJiKTsN
CisJCWtmcmVlKHVyYnRyYWNrKTsNCisJCXJldHVybiAtRU5PTUVNOw0KKwl9DQorCXVyYnRyYWNr
LT5zZXR1cC0+YlJlcXVlc3RUeXBlID0gKF9fdTgpMHg0MDsNCisJdXJidHJhY2stPnNldHVwLT5i
UmVxdWVzdCA9IChfX3U4KTB4MGU7DQorCXVyYnRyYWNrLT5zZXR1cC0+d1ZhbHVlID0gZ2V0X3Jl
Z192YWx1ZShyZWcsIGR1bW15KTsNCisJdXJidHJhY2stPnNldHVwLT53SW5kZXggPSBnZXRfcmVn
X2luZGV4KHJlZyk7DQorCXVyYnRyYWNrLT5zZXR1cC0+d0xlbmd0aCA9IDA7DQogCXVzYl9maWxs
X2NvbnRyb2xfdXJiKHVyYnRyYWNrLT51cmIsIHVzYmRldiwNCiAJCQkgICAgIHVzYl9zbmRjdHJs
cGlwZSh1c2JkZXYsIDApLA0KLQkJCSAgICAgKHVuc2lnbmVkIGNoYXIgKikmc2V0dXAsDQorCQkJ
ICAgICAodW5zaWduZWQgY2hhciAqKXVyYnRyYWNrLT5zZXR1cCwNCiAJCQkgICAgIE5VTEwsIDAs
IGFzeW5jX2NvbXBsZXRlLCB1cmJ0cmFjayk7DQogCWtyZWZfaW5pdCgmdXJidHJhY2stPnJlZl9j
b3VudCk7DQogCUlOSVRfTElTVF9IRUFEKCZ1cmJ0cmFjay0+dXJibGlzdF9lbnRyeSk7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL21vczc4NDAuYyBiL2RyaXZlcnMvdXNiL3Nlcmlh
bC9tb3M3ODQwLmMNCmluZGV4IDVlOGM3MzYuLjVkMjUwMWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3VzYi9zZXJpYWwvbW9zNzg0MC5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvbW9zNzg0MC5j
DQpAQCAtMTg1LDYgKzE4NSwxMCBAQA0KICNkZWZpbmUgVVJCX1RSQU5TRkVSX0JVRkZFUl9TSVpF
ICAgICAgICAzMgkvKiBVUkIgU2l6ZSAgKi8NCiANCiANCitlbnVtIG1vczc4NDBfZmxhZyB7DQor
CU1PUzc4NDBfRkxBR19DVFJMX0JVU1ksDQorfTsNCisNCiBzdGF0aWMgY29uc3Qgc3RydWN0IHVz
Yl9kZXZpY2VfaWQgbW9zY2hpcF9wb3J0X2lkX3RhYmxlW10gPSB7DQogCXtVU0JfREVWSUNFKFVT
Ql9WRU5ET1JfSURfTU9TQ0hJUCwgTU9TQ0hJUF9ERVZJQ0VfSURfNzg0MCl9LA0KIAl7VVNCX0RF
VklDRShVU0JfVkVORE9SX0lEX01PU0NISVAsIE1PU0NISVBfREVWSUNFX0lEXzc4MjApfSwNCkBA
IC0yNTgsNiArMjYyLDggQEAgc3RydWN0IG1vc2NoaXBfcG9ydCB7DQogCXN0cnVjdCB1cmIgKndy
aXRlX3VyYl9wb29sW05VTV9VUkJTXTsNCiAJY2hhciBidXN5W05VTV9VUkJTXTsNCiAJYm9vbCBy
ZWFkX3VyYl9idXN5Ow0KKw0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIH07DQogDQogDQpAQCAt
NTE5LDExICs1MjUsMTEgQEAgc3RhdGljIHZvaWQgbW9zNzg0MF9jb250cm9sX2NhbGxiYWNrKHN0
cnVjdCB1cmIgKnVyYikNCiAJCS8qIHRoaXMgdXJiIGlzIHRlcm1pbmF0ZWQsIGNsZWFuIHVwICov
DQogCQlkYmcoIiVzIC0gdXJiIHNodXR0aW5nIGRvd24gd2l0aCBzdGF0dXM6ICVkIiwgX19mdW5j
X18sDQogCQkgICAgc3RhdHVzKTsNCi0JCXJldHVybjsNCisJCWdvdG8gb3V0Ow0KIAlkZWZhdWx0
Og0KIAkJZGJnKCIlcyAtIG5vbnplcm8gdXJiIHN0YXR1cyByZWNlaXZlZDogJWQiLCBfX2Z1bmNf
XywNCiAJCSAgICBzdGF0dXMpOw0KLQkJcmV0dXJuOw0KKwkJZ290byBvdXQ7DQogCX0NCiANCiAJ
ZGJnKCIlcyB1cmIgYnVmZmVyIHNpemUgaXMgJWQiLCBfX2Z1bmNfXywgdXJiLT5hY3R1YWxfbGVu
Z3RoKTsNCkBAIC01MzYsNiArNTQyLDggQEAgc3RhdGljIHZvaWQgbW9zNzg0MF9jb250cm9sX2Nh
bGxiYWNrKHN0cnVjdCB1cmIgKnVyYikNCiAJCW1vczc4NDBfaGFuZGxlX25ld19tc3IobW9zNzg0
MF9wb3J0LCByZWd2YWwpOw0KIAllbHNlIGlmIChtb3M3ODQwX3BvcnQtPk1zckxzciA9PSAxKQ0K
IAkJbW9zNzg0MF9oYW5kbGVfbmV3X2xzcihtb3M3ODQwX3BvcnQsIHJlZ3ZhbCk7DQorb3V0Og0K
KwljbGVhcl9iaXRfdW5sb2NrKE1PUzc4NDBfRkxBR19DVFJMX0JVU1ksICZtb3M3ODQwX3BvcnQt
PmZsYWdzKTsNCiB9DQogDQogc3RhdGljIGludCBtb3M3ODQwX2dldF9yZWcoc3RydWN0IG1vc2No
aXBfcG9ydCAqbWNzLCBfX3UxNiBXdmFsLCBfX3UxNiByZWcsDQpAQCAtNTQ2LDYgKzU1NCw5IEBA
IHN0YXRpYyBpbnQgbW9zNzg0MF9nZXRfcmVnKHN0cnVjdCBtb3NjaGlwX3BvcnQgKm1jcywgX191
MTYgV3ZhbCwgX191MTYgcmVnLA0KIAl1bnNpZ25lZCBjaGFyICpidWZmZXIgPSBtY3MtPmN0cmxf
YnVmOw0KIAlpbnQgcmV0Ow0KIA0KKwlpZiAodGVzdF9hbmRfc2V0X2JpdF9sb2NrKE1PUzc4NDBf
RkxBR19DVFJMX0JVU1ksICZtY3MtPmZsYWdzKSkNCisJCXJldHVybiAtRUJVU1k7DQorDQogCWRy
LT5iUmVxdWVzdFR5cGUgPSBNQ1NfUkRfUlRZUEU7DQogCWRyLT5iUmVxdWVzdCA9IE1DU19SRFJF
UTsNCiAJZHItPndWYWx1ZSA9IGNwdV90b19sZTE2KFd2YWwpOwkvKiAwICovDQpAQCAtNTU3LDYg
KzU2OCw5IEBAIHN0YXRpYyBpbnQgbW9zNzg0MF9nZXRfcmVnKHN0cnVjdCBtb3NjaGlwX3BvcnQg
Km1jcywgX191MTYgV3ZhbCwgX191MTYgcmVnLA0KIAkJCSAgICAgbW9zNzg0MF9jb250cm9sX2Nh
bGxiYWNrLCBtY3MpOw0KIAltY3MtPmNvbnRyb2xfdXJiLT50cmFuc2Zlcl9idWZmZXJfbGVuZ3Ro
ID0gMjsNCiAJcmV0ID0gdXNiX3N1Ym1pdF91cmIobWNzLT5jb250cm9sX3VyYiwgR0ZQX0FUT01J
Qyk7DQorCWlmIChyZXQpDQorCQljbGVhcl9iaXRfdW5sb2NrKE1PUzc4NDBfRkxBR19DVFJMX0JV
U1ksICZtY3MtPmZsYWdzKTsNCisNCiAJcmV0dXJuIHJldDsNCiB9DQogDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91c2Ivc2VyaWFsL3RpX3VzYl8zNDEwXzUwNTIuYyBiL2RyaXZlcnMvdXNiL3Nlcmlh
bC90aV91c2JfMzQxMF81MDUyLmMNCmluZGV4IDQyMDM4YmEuLjg4NWQxNWQgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3VzYi9zZXJpYWwvdGlfdXNiXzM0MTBfNTA1Mi5jDQorKysgYi9kcml2ZXJzL3Vz
Yi9zZXJpYWwvdGlfdXNiXzM0MTBfNTA1Mi5jDQpAQCAtMTcxMywxMiArMTcxMywxMyBAQCBzdGF0
aWMgaW50IHRpX2Rvd25sb2FkX2Zpcm13YXJlKHN0cnVjdCB0aV9kZXZpY2UgKnRkZXYpDQogDQog
CWRiZygiJXNcbiIsIF9fZnVuY19fKTsNCiAJLyogdHJ5IElEIHNwZWNpZmljIGZpcm13YXJlIGZp
cnN0LCB0aGVuIHRyeSBnZW5lcmljIGZpcm13YXJlICovDQotCXNwcmludGYoYnVmLCAidGlfdXNi
LXYlMDR4LXAlMDR4LmZ3IiwgZGV2LT5kZXNjcmlwdG9yLmlkVmVuZG9yLA0KLQkgICAgZGV2LT5k
ZXNjcmlwdG9yLmlkUHJvZHVjdCk7DQorCXNwcmludGYoYnVmLCAidGlfdXNiLXYlMDR4LXAlMDR4
LmZ3IiwNCisJCQlsZTE2X3RvX2NwdShkZXYtPmRlc2NyaXB0b3IuaWRWZW5kb3IpLA0KKwkJCWxl
MTZfdG9fY3B1KGRldi0+ZGVzY3JpcHRvci5pZFByb2R1Y3QpKTsNCiAJaWYgKChzdGF0dXMgPSBy
ZXF1ZXN0X2Zpcm13YXJlKCZmd19wLCBidWYsICZkZXYtPmRldikpICE9IDApIHsNCiAJCWJ1Zlsw
XSA9ICdcMCc7DQotCQlpZiAoZGV2LT5kZXNjcmlwdG9yLmlkVmVuZG9yID09IE1UU19WRU5ET1Jf
SUQpIHsNCi0JCQlzd2l0Y2ggKGRldi0+ZGVzY3JpcHRvci5pZFByb2R1Y3QpIHsNCisJCWlmIChs
ZTE2X3RvX2NwdShkZXYtPmRlc2NyaXB0b3IuaWRWZW5kb3IpID09IE1UU19WRU5ET1JfSUQpIHsN
CisJCQlzd2l0Y2ggKGxlMTZfdG9fY3B1KGRldi0+ZGVzY3JpcHRvci5pZFByb2R1Y3QpKSB7DQog
CQkJY2FzZSBNVFNfQ0RNQV9QUk9EVUNUX0lEOg0KIAkJCQlzdHJjcHkoYnVmLCAibXRzX2NkbWEu
ZnciKTsNCiAJCQkJYnJlYWs7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vZXZlbnRzLmMgYi9k
cml2ZXJzL3hlbi9ldmVudHMuYw0KaW5kZXggMTFkN2I2NC4uZjYyMjdjYyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMveGVuL2V2ZW50cy5jDQorKysgYi9kcml2ZXJzL3hlbi9ldmVudHMuYw0KQEAgLTMx
Niw3ICszMTYsNyBAQCBzdGF0aWMgdm9pZCBpbml0X2V2dGNobl9jcHVfYmluZGluZ3Modm9pZCkN
CiANCiAJZm9yX2VhY2hfcG9zc2libGVfY3B1KGkpDQogCQltZW1zZXQocGVyX2NwdShjcHVfZXZ0
Y2huX21hc2ssIGkpLA0KLQkJICAgICAgIChpID09IDApID8gfjAgOiAwLCBzaXplb2YoKnBlcl9j
cHUoY3B1X2V2dGNobl9tYXNrLCBpKSkpOw0KKwkJICAgICAgIChpID09IDApID8gfjAgOiAwLCBO
Ul9FVkVOVF9DSEFOTkVMUy84KTsNCiB9DQogDQogc3RhdGljIGlubGluZSB2b2lkIGNsZWFyX2V2
dGNobihpbnQgcG9ydCkNCkBAIC0xMzQwLDggKzEzNDAsMTAgQEAgdm9pZCByZWJpbmRfZXZ0Y2hu
X2lycShpbnQgZXZ0Y2huLCBpbnQgaXJxKQ0KIC8qIFJlYmluZCBhbiBldnRjaG4gc28gdGhhdCBp
dCBnZXRzIGRlbGl2ZXJlZCB0byBhIHNwZWNpZmljIGNwdSAqLw0KIHN0YXRpYyBpbnQgcmViaW5k
X2lycV90b19jcHUodW5zaWduZWQgaXJxLCB1bnNpZ25lZCB0Y3B1KQ0KIHsNCisJc3RydWN0IHNo
YXJlZF9pbmZvICpzID0gSFlQRVJWSVNPUl9zaGFyZWRfaW5mbzsNCiAJc3RydWN0IGV2dGNobl9i
aW5kX3ZjcHUgYmluZF92Y3B1Ow0KIAlpbnQgZXZ0Y2huID0gZXZ0Y2huX2Zyb21faXJxKGlycSk7
DQorCWludCBtYXNrZWQ7DQogDQogCWlmICghVkFMSURfRVZUQ0hOKGV2dGNobikpDQogCQlyZXR1
cm4gLTE7DQpAQCAtMTM1OCw2ICsxMzYwLDEyIEBAIHN0YXRpYyBpbnQgcmViaW5kX2lycV90b19j
cHUodW5zaWduZWQgaXJxLCB1bnNpZ25lZCB0Y3B1KQ0KIAliaW5kX3ZjcHUudmNwdSA9IHRjcHU7
DQogDQogCS8qDQorCSAqIE1hc2sgdGhlIGV2ZW50IHdoaWxlIGNoYW5naW5nIHRoZSBWQ1BVIGJp
bmRpbmcgdG8gcHJldmVudA0KKwkgKiBpdCBiZWluZyBkZWxpdmVyZWQgb24gYW4gdW5leHBlY3Rl
ZCBWQ1BVLg0KKwkgKi8NCisJbWFza2VkID0gc3luY190ZXN0X2FuZF9zZXRfYml0KGV2dGNobiwg
cy0+ZXZ0Y2huX21hc2spOw0KKw0KKwkvKg0KIAkgKiBJZiB0aGlzIGZhaWxzLCBpdCB1c3VhbGx5
IGp1c3QgaW5kaWNhdGVzIHRoYXQgd2UncmUgZGVhbGluZyB3aXRoIGENCiAJICogdmlycSBvciBJ
UEkgY2hhbm5lbCwgd2hpY2ggZG9uJ3QgYWN0dWFsbHkgbmVlZCB0byBiZSByZWJvdW5kLiBJZ25v
cmUNCiAJICogaXQsIGJ1dCBkb24ndCBkbyB0aGUgeGVubGludXgtbGV2ZWwgcmViaW5kIGluIHRo
YXQgY2FzZS4NCkBAIC0xMzY1LDYgKzEzNzMsOSBAQCBzdGF0aWMgaW50IHJlYmluZF9pcnFfdG9f
Y3B1KHVuc2lnbmVkIGlycSwgdW5zaWduZWQgdGNwdSkNCiAJaWYgKEhZUEVSVklTT1JfZXZlbnRf
Y2hhbm5lbF9vcChFVlRDSE5PUF9iaW5kX3ZjcHUsICZiaW5kX3ZjcHUpID49IDApDQogCQliaW5k
X2V2dGNobl90b19jcHUoZXZ0Y2huLCB0Y3B1KTsNCiANCisJaWYgKCFtYXNrZWQpDQorCQl1bm1h
c2tfZXZ0Y2huKGV2dGNobik7DQorDQogCXJldHVybiAwOw0KIH0NCiANCmRpZmYgLS1naXQgYS9m
cy9iaW8uYyBiL2ZzL2Jpby5jDQppbmRleCA0ZmM0ZGJiLi5iODRkODUxIDEwMDY0NA0KLS0tIGEv
ZnMvYmlvLmMNCisrKyBiL2ZzL2Jpby5jDQpAQCAtNzM0LDcgKzczNCw3IEBAIHN0YXRpYyBpbnQg
X19iaW9fY29weV9pb3Yoc3RydWN0IGJpbyAqYmlvLCBzdHJ1Y3QgYmlvX3ZlYyAqaW92ZWNzLA0K
IAlpbnQgaW92X2lkeCA9IDA7DQogCXVuc2lnbmVkIGludCBpb3Zfb2ZmID0gMDsNCiANCi0JX19i
aW9fZm9yX2VhY2hfc2VnbWVudChidmVjLCBiaW8sIGksIDApIHsNCisJYmlvX2Zvcl9lYWNoX3Nl
Z21lbnRfYWxsKGJ2ZWMsIGJpbywgaSkgew0KIAkJY2hhciAqYnZfYWRkciA9IHBhZ2VfYWRkcmVz
cyhidmVjLT5idl9wYWdlKTsNCiAJCXVuc2lnbmVkIGludCBidl9sZW4gPSBpb3ZlY3NbaV0uYnZf
bGVuOw0KIA0KQEAgLTc4NywxMiArNzg3LDIyIEBAIHN0YXRpYyBpbnQgX19iaW9fY29weV9pb3Yo
c3RydWN0IGJpbyAqYmlvLCBzdHJ1Y3QgYmlvX3ZlYyAqaW92ZWNzLA0KIGludCBiaW9fdW5jb3B5
X3VzZXIoc3RydWN0IGJpbyAqYmlvKQ0KIHsNCiAJc3RydWN0IGJpb19tYXBfZGF0YSAqYm1kID0g
YmlvLT5iaV9wcml2YXRlOw0KLQlpbnQgcmV0ID0gMDsNCisJc3RydWN0IGJpb192ZWMgKmJ2ZWM7
DQorCWludCByZXQgPSAwLCBpOw0KIA0KLQlpZiAoIWJpb19mbGFnZ2VkKGJpbywgQklPX05VTExf
TUFQUEVEKSkNCi0JCXJldCA9IF9fYmlvX2NvcHlfaW92KGJpbywgYm1kLT5pb3ZlY3MsIGJtZC0+
c2d2ZWNzLA0KLQkJCQkgICAgIGJtZC0+bnJfc2d2ZWNzLCBiaW9fZGF0YV9kaXIoYmlvKSA9PSBS
RUFELA0KLQkJCQkgICAgIDAsIGJtZC0+aXNfb3VyX3BhZ2VzKTsNCisJaWYgKCFiaW9fZmxhZ2dl
ZChiaW8sIEJJT19OVUxMX01BUFBFRCkpIHsNCisJCS8qDQorCQkgKiBpZiB3ZSdyZSBpbiBhIHdv
cmtxdWV1ZSwgdGhlIHJlcXVlc3QgaXMgb3JwaGFuZWQsIHNvDQorCQkgKiBkb24ndCBjb3B5IGlu
dG8gYSByYW5kb20gdXNlciBhZGRyZXNzIHNwYWNlLCBqdXN0IGZyZWUuDQorCQkgKi8NCisJCWlm
IChjdXJyZW50LT5tbSkNCisJCQlyZXQgPSBfX2Jpb19jb3B5X2lvdihiaW8sIGJtZC0+aW92ZWNz
LCBibWQtPnNndmVjcywNCisJCQkJCSAgICAgYm1kLT5ucl9zZ3ZlY3MsIGJpb19kYXRhX2Rpcihi
aW8pID09IFJFQUQsDQorCQkJCQkgICAgIDAsIGJtZC0+aXNfb3VyX3BhZ2VzKTsNCisJCWVsc2Ug
aWYgKGJtZC0+aXNfb3VyX3BhZ2VzKQ0KKwkJCWJpb19mb3JfZWFjaF9zZWdtZW50X2FsbChidmVj
LCBiaW8sIGkpDQorCQkJCV9fZnJlZV9wYWdlKGJ2ZWMtPmJ2X3BhZ2UpOw0KKwl9DQogCWJpb19m
cmVlX21hcF9kYXRhKGJtZCk7DQogCWJpb19wdXQoYmlvKTsNCiAJcmV0dXJuIHJldDsNCkBAIC05
MTYsNyArOTI2LDcgQEAgc3RydWN0IGJpbyAqYmlvX2NvcHlfdXNlcl9pb3Yoc3RydWN0IHJlcXVl
c3RfcXVldWUgKnEsDQogCXJldHVybiBiaW87DQogY2xlYW51cDoNCiAJaWYgKCFtYXBfZGF0YSkN
Ci0JCWJpb19mb3JfZWFjaF9zZWdtZW50KGJ2ZWMsIGJpbywgaSkNCisJCWJpb19mb3JfZWFjaF9z
ZWdtZW50X2FsbChidmVjLCBiaW8sIGkpDQogCQkJX19mcmVlX3BhZ2UoYnZlYy0+YnZfcGFnZSk7
DQogDQogCWJpb19wdXQoYmlvKTsNCkBAIC0xMTMwLDcgKzExNDAsNyBAQCBzdGF0aWMgdm9pZCBf
X2Jpb191bm1hcF91c2VyKHN0cnVjdCBiaW8gKmJpbykNCiAJLyoNCiAJICogbWFrZSBzdXJlIHdl
IGRpcnR5IHBhZ2VzIHdlIHdyb3RlIHRvDQogCSAqLw0KLQlfX2Jpb19mb3JfZWFjaF9zZWdtZW50
KGJ2ZWMsIGJpbywgaSwgMCkgew0KKwliaW9fZm9yX2VhY2hfc2VnbWVudF9hbGwoYnZlYywgYmlv
LCBpKSB7DQogCQlpZiAoYmlvX2RhdGFfZGlyKGJpbykgPT0gUkVBRCkNCiAJCQlzZXRfcGFnZV9k
aXJ0eV9sb2NrKGJ2ZWMtPmJ2X3BhZ2UpOw0KIA0KQEAgLTEyMzYsNyArMTI0Niw3IEBAIHN0YXRp
YyB2b2lkIGJpb19jb3B5X2tlcm5fZW5kaW8oc3RydWN0IGJpbyAqYmlvLCBpbnQgZXJyKQ0KIAlp
bnQgaTsNCiAJY2hhciAqcCA9IGJtZC0+c2d2ZWNzWzBdLmlvdl9iYXNlOw0KIA0KLQlfX2Jpb19m
b3JfZWFjaF9zZWdtZW50KGJ2ZWMsIGJpbywgaSwgMCkgew0KKwliaW9fZm9yX2VhY2hfc2VnbWVu
dF9hbGwoYnZlYywgYmlvLCBpKSB7DQogCQljaGFyICphZGRyID0gcGFnZV9hZGRyZXNzKGJ2ZWMt
PmJ2X3BhZ2UpOw0KIAkJaW50IGxlbiA9IGJtZC0+aW92ZWNzW2ldLmJ2X2xlbjsNCiANCkBAIC0x
Mjc2LDcgKzEyODYsNyBAQCBzdHJ1Y3QgYmlvICpiaW9fY29weV9rZXJuKHN0cnVjdCByZXF1ZXN0
X3F1ZXVlICpxLCB2b2lkICpkYXRhLCB1bnNpZ25lZCBpbnQgbGVuLA0KIAlpZiAoIXJlYWRpbmcp
IHsNCiAJCXZvaWQgKnAgPSBkYXRhOw0KIA0KLQkJYmlvX2Zvcl9lYWNoX3NlZ21lbnQoYnZlYywg
YmlvLCBpKSB7DQorCQliaW9fZm9yX2VhY2hfc2VnbWVudF9hbGwoYnZlYywgYmlvLCBpKSB7DQog
CQkJY2hhciAqYWRkciA9IHBhZ2VfYWRkcmVzcyhidmVjLT5idl9wYWdlKTsNCiANCiAJCQltZW1j
cHkoYWRkciwgcCwgYnZlYy0+YnZfbGVuKTsNCkBAIC0xNTU2LDcgKzE1NjYsNyBAQCBzZWN0b3Jf
dCBiaW9fc2VjdG9yX29mZnNldChzdHJ1Y3QgYmlvICpiaW8sIHVuc2lnbmVkIHNob3J0IGluZGV4
LA0KIAlpZiAoaW5kZXggPj0gYmlvLT5iaV9pZHgpDQogCQlpbmRleCA9IGJpby0+YmlfdmNudCAt
IDE7DQogDQotCV9fYmlvX2Zvcl9lYWNoX3NlZ21lbnQoYnYsIGJpbywgaSwgMCkgew0KKwliaW9f
Zm9yX2VhY2hfc2VnbWVudF9hbGwoYnYsIGJpbywgaSkgew0KIAkJaWYgKGkgPT0gaW5kZXgpIHsN
CiAJCQlpZiAob2Zmc2V0ID4gYnYtPmJ2X29mZnNldCkNCiAJCQkJc2VjdG9ycyArPSAob2Zmc2V0
IC0gYnYtPmJ2X29mZnNldCkgLyBzZWN0b3Jfc3o7DQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZz
ZW5jcnlwdC5jIGIvZnMvY2lmcy9jaWZzZW5jcnlwdC5jDQppbmRleCBjZGNkNjY1Li5iNDY3NWJk
IDEwMDY0NA0KLS0tIGEvZnMvY2lmcy9jaWZzZW5jcnlwdC5jDQorKysgYi9mcy9jaWZzL2NpZnNl
bmNyeXB0LmMNCkBAIC0zNjksNyArMzY5LDcgQEAgZmluZF9kb21haW5fbmFtZShzdHJ1Y3QgY2lm
c19zZXMgKnNlcywgY29uc3Qgc3RydWN0IG5sc190YWJsZSAqbmxzX2NwKQ0KIAkJaWYgKGJsb2Jw
dHIgKyBhdHRyc2l6ZSA+IGJsb2JlbmQpDQogCQkJYnJlYWs7DQogCQlpZiAodHlwZSA9PSBOVExN
U1NQX0FWX05CX0RPTUFJTl9OQU1FKSB7DQotCQkJaWYgKCFhdHRyc2l6ZSkNCisJCQlpZiAoIWF0
dHJzaXplIHx8IGF0dHJzaXplID49IENJRlNfTUFYX0RPTUFJTk5BTUVfTEVOKQ0KIAkJCQlicmVh
azsNCiAJCQlpZiAoIXNlcy0+ZG9tYWluTmFtZSkgew0KIAkJCQlzZXMtPmRvbWFpbk5hbWUgPQ0K
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaA0KaW5k
ZXggMmYzZmY1OS4uN2I2ODA4OCAxMDA2NDQNCi0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaA0KKysr
IGIvZnMvY2lmcy9jaWZzZ2xvYi5oDQpAQCAtMzgsNiArMzgsNyBAQA0KICNkZWZpbmUgTUFYX1RS
RUVfU0laRSAoMiArIE1BWF9TRVJWRVJfU0laRSArIDEgKyBNQVhfU0hBUkVfU0laRSArIDEpDQog
I2RlZmluZSBNQVhfU0VSVkVSX1NJWkUgMTUNCiAjZGVmaW5lIE1BWF9TSEFSRV9TSVpFIDgwDQor
I2RlZmluZSBDSUZTX01BWF9ET01BSU5OQU1FX0xFTiAyNTYgLyogbWF4IGRvbWFpbiBuYW1lIGxl
bmd0aCAqLw0KICNkZWZpbmUgTUFYX1VTRVJOQU1FX1NJWkUgMjU2CS8qIHJlYXNvbmFibGUgbWF4
aW11bSBmb3IgY3VycmVudCBzZXJ2ZXJzICovDQogI2RlZmluZSBNQVhfUEFTU1dPUkRfU0laRSA1
MTIJLyogbWF4IGZvciB3aW5kb3dzIHNlZW1zIHRvIGJlIDI1NiB3aWRlIGNoYXJzICovDQogDQpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9yZWFkZGlyLmMgYi9mcy9jaWZzL3JlYWRkaXIuYw0KaW5kZXgg
NGMzN2VkNC4uNTJhODIwYSAxMDA2NDQNCi0tLSBhL2ZzL2NpZnMvcmVhZGRpci5jDQorKysgYi9m
cy9jaWZzL3JlYWRkaXIuYw0KQEAgLTk2LDYgKzk2LDE0IEBAIGNpZnNfcmVhZGRpcl9sb29rdXAo
c3RydWN0IGRlbnRyeSAqcGFyZW50LCBzdHJ1Y3QgcXN0ciAqbmFtZSwNCiAJCWRwdXQoZGVudHJ5
KTsNCiAJfQ0KIA0KKwkvKg0KKwkgKiBJZiB3ZSBrbm93IHRoYXQgdGhlIGlub2RlIHdpbGwgbmVl
ZCB0byBiZSByZXZhbGlkYXRlZCBpbW1lZGlhdGVseSwNCisJICogdGhlbiBkb24ndCBjcmVhdGUg
YSBuZXcgZGVudHJ5IGZvciBpdC4gV2UnbGwgZW5kIHVwIGRvaW5nIGFuIG9uDQorCSAqIHRoZSB3
aXJlIGNhbGwgZWl0aGVyIHdheSBhbmQgdGhpcyBzcGFyZXMgdXMgYW4gaW52YWxpZGF0aW9uLg0K
KwkgKi8NCisJaWYgKGZhdHRyLT5jZl9mbGFncyAmIENJRlNfRkFUVFJfTkVFRF9SRVZBTCkNCisJ
CXJldHVybiBOVUxMOw0KKw0KIAlkZW50cnkgPSBkX2FsbG9jKHBhcmVudCwgbmFtZSk7DQogCWlm
IChkZW50cnkgPT0gTlVMTCkNCiAJCXJldHVybiBOVUxMOw0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c2Vzcy5jIGIvZnMvY2lmcy9zZXNzLmMNCmluZGV4IDI1MDQ4MDkuLmQzNjI2MjYgMTAwNjQ0DQot
LS0gYS9mcy9jaWZzL3Nlc3MuYw0KKysrIGIvZnMvY2lmcy9zZXNzLmMNCkBAIC0xOTgsNyArMTk4
LDcgQEAgc3RhdGljIHZvaWQgdW5pY29kZV9kb21haW5fc3RyaW5nKGNoYXIgKipwYmNjX2FyZWEs
IHN0cnVjdCBjaWZzX3NlcyAqc2VzLA0KIAkJYnl0ZXNfcmV0ID0gMDsNCiAJfSBlbHNlDQogCQli
eXRlc19yZXQgPSBjaWZzX3N0cnRvVUNTKChfX2xlMTYgKikgYmNjX3B0ciwgc2VzLT5kb21haW5O
YW1lLA0KLQkJCQkJICAyNTYsIG5sc19jcCk7DQorCQkJCQkgIENJRlNfTUFYX0RPTUFJTk5BTUVf
TEVOLCBubHNfY3ApOw0KIAliY2NfcHRyICs9IDIgKiBieXRlc19yZXQ7DQogCWJjY19wdHIgKz0g
MjsgIC8qIGFjY291bnQgZm9yIG51bGwgdGVybWluYXRvciAqLw0KIA0KQEAgLTI1Niw4ICsyNTYs
OCBAQCBzdGF0aWMgdm9pZCBhc2NpaV9zc2V0dXBfc3RyaW5ncyhjaGFyICoqcGJjY19hcmVhLCBz
dHJ1Y3QgY2lmc19zZXMgKnNlcywNCiANCiAJLyogY29weSBkb21haW4gKi8NCiAJaWYgKHNlcy0+
ZG9tYWluTmFtZSAhPSBOVUxMKSB7DQotCQlzdHJuY3B5KGJjY19wdHIsIHNlcy0+ZG9tYWluTmFt
ZSwgMjU2KTsNCi0JCWJjY19wdHIgKz0gc3RybmxlbihzZXMtPmRvbWFpbk5hbWUsIDI1Nik7DQor
CQlzdHJuY3B5KGJjY19wdHIsIHNlcy0+ZG9tYWluTmFtZSwgQ0lGU19NQVhfRE9NQUlOTkFNRV9M
RU4pOw0KKwkJYmNjX3B0ciArPSBzdHJubGVuKHNlcy0+ZG9tYWluTmFtZSwgQ0lGU19NQVhfRE9N
QUlOTkFNRV9MRU4pOw0KIAl9IC8qIGVsc2Ugd2Ugd2lsbCBzZW5kIGEgbnVsbCBkb21haW4gbmFt
ZQ0KIAkgICAgIHNvIHRoZSBzZXJ2ZXIgd2lsbCBkZWZhdWx0IHRvIGl0cyBvd24gZG9tYWluICov
DQogCSpiY2NfcHRyID0gMDsNCmRpZmYgLS1naXQgYS9mcy9leG9mcy9vcmUuYyBiL2ZzL2V4b2Zz
L29yZS5jDQppbmRleCAxNTg1ZGIxLi4yNmJiNTEyIDEwMDY0NA0KLS0tIGEvZnMvZXhvZnMvb3Jl
LmMNCisrKyBiL2ZzL2V4b2ZzL29yZS5jDQpAQCAtNDAxLDcgKzQwMSw3IEBAIHN0YXRpYyB2b2lk
IF9jbGVhcl9iaW8oc3RydWN0IGJpbyAqYmlvKQ0KIAlzdHJ1Y3QgYmlvX3ZlYyAqYnY7DQogCXVu
c2lnbmVkIGk7DQogDQotCV9fYmlvX2Zvcl9lYWNoX3NlZ21lbnQoYnYsIGJpbywgaSwgMCkgew0K
KwliaW9fZm9yX2VhY2hfc2VnbWVudF9hbGwoYnYsIGJpbywgaSkgew0KIAkJdW5zaWduZWQgdGhp
c19jb3VudCA9IGJ2LT5idl9sZW47DQogDQogCQlpZiAobGlrZWx5KFBBR0VfU0laRSA9PSB0aGlz
X2NvdW50KSkNCmRpZmYgLS1naXQgYS9mcy9leG9mcy9vcmVfcmFpZC5jIGIvZnMvZXhvZnMvb3Jl
X3JhaWQuYw0KaW5kZXggZmZmMjA3MC4uMmM2NDgyNiAxMDA2NDQNCi0tLSBhL2ZzL2V4b2ZzL29y
ZV9yYWlkLmMNCisrKyBiL2ZzL2V4b2ZzL29yZV9yYWlkLmMNCkBAIC00MzIsNyArNDMyLDcgQEAg
c3RhdGljIHZvaWQgX21hcmtfcmVhZDR3cml0ZV9wYWdlc191cHRvZGF0ZShzdHJ1Y3Qgb3JlX2lv
X3N0YXRlICppb3MsIGludCByZXQpDQogCQlpZiAoIWJpbykNCiAJCQljb250aW51ZTsNCiANCi0J
CV9fYmlvX2Zvcl9lYWNoX3NlZ21lbnQoYnYsIGJpbywgaSwgMCkgew0KKwkJYmlvX2Zvcl9lYWNo
X3NlZ21lbnRfYWxsKGJ2LCBiaW8sIGkpIHsNCiAJCQlzdHJ1Y3QgcGFnZSAqcGFnZSA9IGJ2LT5i
dl9wYWdlOw0KIA0KIAkJCVNldFBhZ2VVcHRvZGF0ZShwYWdlKTsNCmRpZmYgLS1naXQgYS9mcy9l
eHQ0L2V4dDRfamJkMi5jIGIvZnMvZXh0NC9leHQ0X2piZDIuYw0KaW5kZXggYWNhMTc5MC4uZDBi
OGY5OCAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQvZXh0NF9qYmQyLmMNCisrKyBiL2ZzL2V4dDQvZXh0
NF9qYmQyLmMNCkBAIC0xMDksMTAgKzEwOSwxMCBAQCBpbnQgX19leHQ0X2hhbmRsZV9kaXJ0eV9t
ZXRhZGF0YShjb25zdCBjaGFyICp3aGVyZSwgdW5zaWduZWQgaW50IGxpbmUsDQogDQogCWlmIChl
eHQ0X2hhbmRsZV92YWxpZChoYW5kbGUpKSB7DQogCQllcnIgPSBqYmQyX2pvdXJuYWxfZGlydHlf
bWV0YWRhdGEoaGFuZGxlLCBiaCk7DQotCQlpZiAoZXJyKSB7DQotCQkJLyogRXJyb3JzIGNhbiBv
bmx5IGhhcHBlbiBpZiB0aGVyZSBpcyBhIGJ1ZyAqLw0KLQkJCWhhbmRsZS0+aF9lcnIgPSBlcnI7
DQotCQkJX19leHQ0X2pvdXJuYWxfc3RvcCh3aGVyZSwgbGluZSwgaGFuZGxlKTsNCisJCS8qIEVy
cm9ycyBjYW4gb25seSBoYXBwZW4gaWYgdGhlcmUgaXMgYSBidWcgKi8NCisJCWlmIChXQVJOX09O
X09OQ0UoZXJyKSkgew0KKwkJCWV4dDRfam91cm5hbF9hYm9ydF9oYW5kbGUod2hlcmUsIGxpbmUs
IF9fZnVuY19fLCBiaCwNCisJCQkJCQkgIGhhbmRsZSwgZXJyKTsNCiAJCX0NCiAJfSBlbHNlIHsN
CiAJCWlmIChpbm9kZSkNCmRpZmYgLS1naXQgYS9mcy9leHQ0L3N1cGVyLmMgYi9mcy9leHQ0L3N1
cGVyLmMNCmluZGV4IDI1OWU5NTAuLjg0Zjg0YmYgMTAwNjQ0DQotLS0gYS9mcy9leHQ0L3N1cGVy
LmMNCisrKyBiL2ZzL2V4dDQvc3VwZXIuYw0KQEAgLTMzNzIsNyArMzM3Miw3IEBAIHN0YXRpYyBp
bnQgZXh0NF9maWxsX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHZvaWQgKmRhdGEsIGlu
dCBzaWxlbnQpDQogCQl9DQogCQlpZiAodGVzdF9vcHQoc2IsIERJT1JFQURfTk9MT0NLKSkgew0K
IAkJCWV4dDRfbXNnKHNiLCBLRVJOX0VSUiwgImNhbid0IG1vdW50IHdpdGggIg0KLQkJCQkgImJv
dGggZGF0YT1qb3VybmFsIGFuZCBkZWxhbGxvYyIpOw0KKwkJCQkgImJvdGggZGF0YT1qb3VybmFs
IGFuZCBkaW9yZWFkX25vbG9jayIpOw0KIAkJCWdvdG8gZmFpbGVkX21vdW50Ow0KIAkJfQ0KIAkJ
aWYgKHRlc3Rfb3B0KHNiLCBERUxBTExPQykpDQpAQCAtNDUzOSw2ICs0NTM5LDIxIEBAIHN0YXRp
YyBpbnQgZXh0NF9yZW1vdW50KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCAqZmxhZ3MsIGNo
YXIgKmRhdGEpDQogCQlnb3RvIHJlc3RvcmVfb3B0czsNCiAJfQ0KIA0KKwlpZiAodGVzdF9vcHQo
c2IsIERBVEFfRkxBR1MpID09IEVYVDRfTU9VTlRfSk9VUk5BTF9EQVRBKSB7DQorCQlpZiAodGVz
dF9vcHQyKHNiLCBFWFBMSUNJVF9ERUxBTExPQykpIHsNCisJCQlleHQ0X21zZyhzYiwgS0VSTl9F
UlIsICJjYW4ndCBtb3VudCB3aXRoICINCisJCQkJICJib3RoIGRhdGE9am91cm5hbCBhbmQgZGVs
YWxsb2MiKTsNCisJCQllcnIgPSAtRUlOVkFMOw0KKwkJCWdvdG8gcmVzdG9yZV9vcHRzOw0KKwkJ
fQ0KKwkJaWYgKHRlc3Rfb3B0KHNiLCBESU9SRUFEX05PTE9DSykpIHsNCisJCQlleHQ0X21zZyhz
YiwgS0VSTl9FUlIsICJjYW4ndCBtb3VudCB3aXRoICINCisJCQkJICJib3RoIGRhdGE9am91cm5h
bCBhbmQgZGlvcmVhZF9ub2xvY2siKTsNCisJCQllcnIgPSAtRUlOVkFMOw0KKwkJCWdvdG8gcmVz
dG9yZV9vcHRzOw0KKwkJfQ0KKwl9DQorDQogCWlmIChzYmktPnNfbW91bnRfZmxhZ3MgJiBFWFQ0
X01GX0ZTX0FCT1JURUQpDQogCQlleHQ0X2Fib3J0KHNiLCAiQWJvcnQgZm9yY2VkIGJ5IHVzZXIi
KTsNCiANCmRpZmYgLS1naXQgYS9mcy9qZnMvamZzX2R0cmVlLmMgYi9mcy9qZnMvamZzX2R0cmVl
LmMNCmluZGV4IDkxOTdhMWIuLjlmN2M3NTggMTAwNjQ0DQotLS0gYS9mcy9qZnMvamZzX2R0cmVl
LmMNCisrKyBiL2ZzL2pmcy9qZnNfZHRyZWUuYw0KQEAgLTMwNDcsNiArMzA0NywxNCBAQCBpbnQg
amZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKmZpbHAsIHZvaWQgKmRpcmVudCwgZmlsbGRpcl90IGZp
bGxkaXIpDQogDQogCQlkaXJfaW5kZXggPSAodTMyKSBmaWxwLT5mX3BvczsNCiANCisJCS8qDQor
CQkgKiBORlN2NCByZXNlcnZlcyBjb29raWVzIDEgYW5kIDIgZm9yIC4gYW5kIC4uIHNvIHRoZSB2
YWx1ZQ0KKwkJICogd2UgcmV0dXJuIHRvIHRoZSB2ZnMgaXMgb25lIGdyZWF0ZXIgdGhhbiB0aGUg
b25lIHdlIHVzZQ0KKwkJICogaW50ZXJuYWxseS4NCisJCSAqLw0KKwkJaWYgKGRpcl9pbmRleCkN
CisJCQlkaXJfaW5kZXgtLTsNCisNCiAJCWlmIChkaXJfaW5kZXggPiAxKSB7DQogCQkJc3RydWN0
IGRpcl90YWJsZV9zbG90IGRpcnRhYl9zbG90Ow0KIA0KQEAgLTMwODYsNyArMzA5NCw3IEBAIGlu
dCBqZnNfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqZmlscCwgdm9pZCAqZGlyZW50LCBmaWxsZGlyX3Qg
ZmlsbGRpcikNCiAJCQlpZiAocC0+aGVhZGVyLmZsYWcgJiBCVF9JTlRFUk5BTCkgew0KIAkJCQlq
ZnNfZXJyKCJqZnNfcmVhZGRpcjogYmFkIGluZGV4IHRhYmxlIik7DQogCQkJCURUX1BVVFBBR0Uo
bXApOw0KLQkJCQlmaWxwLT5mX3BvcyA9IC0xOw0KKwkJCQlmaWxwLT5mX3BvcyA9IERJUkVORDsN
CiAJCQkJcmV0dXJuIDA7DQogCQkJfQ0KIAkJfSBlbHNlIHsNCkBAIC0zMDk0LDcgKzMxMDIsNyBA
QCBpbnQgamZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKmZpbHAsIHZvaWQgKmRpcmVudCwgZmlsbGRp
cl90IGZpbGxkaXIpDQogCQkJCS8qDQogCQkJCSAqIHNlbGYgIi4iDQogCQkJCSAqLw0KLQkJCQlm
aWxwLT5mX3BvcyA9IDA7DQorCQkJCWZpbHAtPmZfcG9zID0gMTsNCiAJCQkJaWYgKGZpbGxkaXIo
ZGlyZW50LCAiLiIsIDEsIDAsIGlwLT5pX2lubywNCiAJCQkJCSAgICBEVF9ESVIpKQ0KIAkJCQkJ
cmV0dXJuIDA7DQpAQCAtMzEwMiw3ICszMTEwLDcgQEAgaW50IGpmc19yZWFkZGlyKHN0cnVjdCBm
aWxlICpmaWxwLCB2b2lkICpkaXJlbnQsIGZpbGxkaXJfdCBmaWxsZGlyKQ0KIAkJCS8qDQogCQkJ
ICogcGFyZW50ICIuLiINCiAJCQkgKi8NCi0JCQlmaWxwLT5mX3BvcyA9IDE7DQorCQkJZmlscC0+
Zl9wb3MgPSAyOw0KIAkJCWlmIChmaWxsZGlyKGRpcmVudCwgIi4uIiwgMiwgMSwgUEFSRU5UKGlw
KSwgRFRfRElSKSkNCiAJCQkJcmV0dXJuIDA7DQogDQpAQCAtMzEyMywyNCArMzEzMSwyNSBAQCBp
bnQgamZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKmZpbHAsIHZvaWQgKmRpcmVudCwgZmlsbGRpcl90
IGZpbGxkaXIpDQogCQkvKg0KIAkJICogTGVnYWN5IGZpbGVzeXN0ZW0gLSBPUy8yICYgTGludXgg
SkZTIDwgMC4zLjYNCiAJCSAqDQotCQkgKiBwbiA9IGluZGV4ID0gMDoJRmlyc3QgZW50cnkgIi4i
DQotCQkgKiBwbiA9IDA7IGluZGV4ID0gMToJU2Vjb25kIGVudHJ5ICIuLiINCisJCSAqIHBuID0g
MDsgaW5kZXggPSAxOglGaXJzdCBlbnRyeSAiLiINCisJCSAqIHBuID0gMDsgaW5kZXggPSAyOglT
ZWNvbmQgZW50cnkgIi4uIg0KIAkJICogcG4gPiAwOgkJUmVhbCBlbnRyaWVzLCBwbj0xIC0+IGxl
ZnRtb3N0IHBhZ2UNCiAJCSAqIHBuID0gaW5kZXggPSAtMToJTm8gbW9yZSBlbnRyaWVzDQogCQkg
Ki8NCiAJCWR0cG9zID0gZmlscC0+Zl9wb3M7DQotCQlpZiAoZHRwb3MgPT0gMCkgew0KKwkJaWYg
KGR0cG9zIDwgMikgew0KIAkJCS8qIGJ1aWxkICIuIiBlbnRyeSAqLw0KIA0KKwkJCWZpbHAtPmZf
cG9zID0gMTsNCiAJCQlpZiAoZmlsbGRpcihkaXJlbnQsICIuIiwgMSwgZmlscC0+Zl9wb3MsIGlw
LT5pX2lubywNCiAJCQkJICAgIERUX0RJUikpDQogCQkJCXJldHVybiAwOw0KLQkJCWR0b2Zmc2V0
LT5pbmRleCA9IDE7DQorCQkJZHRvZmZzZXQtPmluZGV4ID0gMjsNCiAJCQlmaWxwLT5mX3BvcyA9
IGR0cG9zOw0KIAkJfQ0KIA0KIAkJaWYgKGR0b2Zmc2V0LT5wbiA9PSAwKSB7DQotCQkJaWYgKGR0
b2Zmc2V0LT5pbmRleCA9PSAxKSB7DQorCQkJaWYgKGR0b2Zmc2V0LT5pbmRleCA9PSAyKSB7DQog
CQkJCS8qIGJ1aWxkICIuLiIgZW50cnkgKi8NCiANCiAJCQkJaWYgKGZpbGxkaXIoZGlyZW50LCAi
Li4iLCAyLCBmaWxwLT5mX3BvcywNCkBAIC0zMjMzLDYgKzMyNDIsMTIgQEAgaW50IGpmc19yZWFk
ZGlyKHN0cnVjdCBmaWxlICpmaWxwLCB2b2lkICpkaXJlbnQsIGZpbGxkaXJfdCBmaWxsZGlyKQ0K
IAkJCQkJfQ0KIAkJCQkJamZzX2RpcmVudC0+cG9zaXRpb24gPSB1bmlxdWVfcG9zKys7DQogCQkJ
CX0NCisJCQkJLyoNCisJCQkJICogV2UgYWRkIDEgdG8gdGhlIGluZGV4IGJlY2F1c2Ugd2UgbWF5
DQorCQkJCSAqIHVzZSBhIHZhbHVlIG9mIDIgaW50ZXJuYWxseSwgYW5kIE5GU3Y0DQorCQkJCSAq
IGRvZXNuJ3QgbGlrZSB0aGF0Lg0KKwkJCQkgKi8NCisJCQkJamZzX2RpcmVudC0+cG9zaXRpb24r
KzsNCiAJCQl9IGVsc2Ugew0KIAkJCQlqZnNfZGlyZW50LT5wb3NpdGlvbiA9IGR0cG9zOw0KIAkJ
CQlsZW4gPSBtaW4oZF9uYW1sZWZ0LCBEVExIRFJEQVRBTEVOX0xFR0FDWSk7DQpkaWZmIC0tZ2l0
IGEvZnMvbmZzL2NhbGxiYWNrX3hkci5jIGIvZnMvbmZzL2NhbGxiYWNrX3hkci5jDQppbmRleCAx
NjhjYjkzLi4zZmRlMDU1IDEwMDY0NA0KLS0tIGEvZnMvbmZzL2NhbGxiYWNrX3hkci5jDQorKysg
Yi9mcy9uZnMvY2FsbGJhY2tfeGRyLmMNCkBAIC00NTEsOSArNDUxLDkgQEAgc3RhdGljIF9fYmUz
MiBkZWNvZGVfY2Jfc2VxdWVuY2VfYXJncyhzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLA0KIAlhcmdz
LT5jc2FfbnJjbGlzdHMgPSBudG9obCgqcCsrKTsNCiAJYXJncy0+Y3NhX3JjbGlzdHMgPSBOVUxM
Ow0KIAlpZiAoYXJncy0+Y3NhX25yY2xpc3RzKSB7DQotCQlhcmdzLT5jc2FfcmNsaXN0cyA9IGtt
YWxsb2MoYXJncy0+Y3NhX25yY2xpc3RzICoNCi0JCQkJCSAgICBzaXplb2YoKmFyZ3MtPmNzYV9y
Y2xpc3RzKSwNCi0JCQkJCSAgICBHRlBfS0VSTkVMKTsNCisJCWFyZ3MtPmNzYV9yY2xpc3RzID0g
a21hbGxvY19hcnJheShhcmdzLT5jc2FfbnJjbGlzdHMsDQorCQkJCQkJICBzaXplb2YoKmFyZ3Mt
PmNzYV9yY2xpc3RzKSwNCisJCQkJCQkgIEdGUF9LRVJORUwpOw0KIAkJaWYgKHVubGlrZWx5KGFy
Z3MtPmNzYV9yY2xpc3RzID09IE5VTEwpKQ0KIAkJCWdvdG8gb3V0Ow0KIA0KZGlmZiAtLWdpdCBh
L2ZzL25pbGZzMi9zZWdidWYuYyBiL2ZzL25pbGZzMi9zZWdidWYuYw0KaW5kZXggODUwYTdjMC4u
MDdhNjY2YSAxMDA2NDQNCi0tLSBhL2ZzL25pbGZzMi9zZWdidWYuYw0KKysrIGIvZnMvbmlsZnMy
L3NlZ2J1Zi5jDQpAQCAtMzQ1LDggKzM0NSw3IEBAIHN0YXRpYyB2b2lkIG5pbGZzX2VuZF9iaW9f
d3JpdGUoc3RydWN0IGJpbyAqYmlvLCBpbnQgZXJyKQ0KIA0KIAlpZiAoZXJyID09IC1FT1BOT1RT
VVBQKSB7DQogCQlzZXRfYml0KEJJT19FT1BOT1RTVVBQLCAmYmlvLT5iaV9mbGFncyk7DQotCQli
aW9fcHV0KGJpbyk7DQotCQkvKiB0byBiZSBkZXRlY3RlZCBieSBzdWJtaXRfc2VnX2JpbygpICov
DQorCQkvKiB0byBiZSBkZXRlY3RlZCBieSBuaWxmc19zZWdidWZfc3VibWl0X2JpbygpICovDQog
CX0NCiANCiAJaWYgKCF1cHRvZGF0ZSkNCkBAIC0zNzcsMTIgKzM3NiwxMiBAQCBzdGF0aWMgaW50
IG5pbGZzX3NlZ2J1Zl9zdWJtaXRfYmlvKHN0cnVjdCBuaWxmc19zZWdtZW50X2J1ZmZlciAqc2Vn
YnVmLA0KIAliaW8tPmJpX3ByaXZhdGUgPSBzZWdidWY7DQogCWJpb19nZXQoYmlvKTsNCiAJc3Vi
bWl0X2Jpbyhtb2RlLCBiaW8pOw0KKwlzZWdidWYtPnNiX25iaW8rKzsNCiAJaWYgKGJpb19mbGFn
Z2VkKGJpbywgQklPX0VPUE5PVFNVUFApKSB7DQogCQliaW9fcHV0KGJpbyk7DQogCQllcnIgPSAt
RU9QTk9UU1VQUDsNCiAJCWdvdG8gZmFpbGVkOw0KIAl9DQotCXNlZ2J1Zi0+c2JfbmJpbysrOw0K
IAliaW9fcHV0KGJpbyk7DQogDQogCXdpLT5iaW8gPSBOVUxMOw0KZGlmZiAtLWdpdCBhL2ZzL3By
b2MvdGFza19tbXUuYyBiL2ZzL3Byb2MvdGFza19tbXUuYw0KaW5kZXggM2VmYTcyNS4uZWYxNzQw
ZCAxMDA2NDQNCi0tLSBhL2ZzL3Byb2MvdGFza19tbXUuYw0KKysrIGIvZnMvcHJvYy90YXNrX21t
dS5jDQpAQCAtNjA0LDcgKzYwNCw3IEBAIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgcHJv
Y19jbGVhcl9yZWZzX29wZXJhdGlvbnMgPSB7DQogfTsNCiANCiBzdHJ1Y3QgcGFnZW1hcHJlYWQg
ew0KLQlpbnQgcG9zLCBsZW47DQorCWludCBwb3MsIGxlbjsJCS8qIHVuaXRzOiBQTV9FTlRSWV9C
WVRFUywgbm90IGJ5dGVzICovDQogCXU2NCAqYnVmZmVyOw0KIH07DQogDQpAQCAtNzkyLDggKzc5
Miw4IEBAIHN0YXRpYyBzc2l6ZV90IHBhZ2VtYXBfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hh
ciBfX3VzZXIgKmJ1ZiwNCiAJaWYgKCFjb3VudCkNCiAJCWdvdG8gb3V0X3Rhc2s7DQogDQotCXBt
LmxlbiA9IFBNX0VOVFJZX0JZVEVTICogKFBBR0VNQVBfV0FMS19TSVpFID4+IFBBR0VfU0hJRlQp
Ow0KLQlwbS5idWZmZXIgPSBrbWFsbG9jKHBtLmxlbiwgR0ZQX1RFTVBPUkFSWSk7DQorCXBtLmxl
biA9IChQQUdFTUFQX1dBTEtfU0laRSA+PiBQQUdFX1NISUZUKTsNCisJcG0uYnVmZmVyID0ga21h
bGxvYyhwbS5sZW4gKiBQTV9FTlRSWV9CWVRFUywgR0ZQX1RFTVBPUkFSWSk7DQogCXJldCA9IC1F
Tk9NRU07DQogCWlmICghcG0uYnVmZmVyKQ0KIAkJZ290byBvdXRfdGFzazsNCmRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L2Jpby5oIGIvaW5jbHVkZS9saW51eC9iaW8uaA0KaW5kZXggODQ3OTk0
YS4uZTg2ODU1NCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvYmlvLmgNCisrKyBiL2luY2x1
ZGUvbGludXgvYmlvLmgNCkBAIC0xMzUsMTYgKzEzNSwyNyBAQCBzdGF0aWMgaW5saW5lIGludCBi
aW9faGFzX2FsbG9jYXRlZF92ZWMoc3RydWN0IGJpbyAqYmlvKQ0KICNkZWZpbmUgYmlvX2lvX2Vy
cm9yKGJpbykgYmlvX2VuZGlvKChiaW8pLCAtRUlPKQ0KIA0KIC8qDQotICogZHJpdmVycyBzaG91
bGQgbm90IHVzZSB0aGUgX18gdmVyc2lvbiB1bmxlc3MgdGhleSBfcmVhbGx5XyB3YW50IHRvDQot
ICogcnVuIHRocm91Z2ggdGhlIGVudGlyZSBiaW8gYW5kIG5vdCBqdXN0IHBlbmRpbmcgcGllY2Vz
DQorICogZHJpdmVycyBzaG91bGQgbm90IHVzZSB0aGUgX18gdmVyc2lvbiB1bmxlc3MgdGhleSBf
cmVhbGx5XyBrbm93IHdoYXQNCisgKiB0aGV5J3JlIGRvaW5nDQogICovDQogI2RlZmluZSBfX2Jp
b19mb3JfZWFjaF9zZWdtZW50KGJ2bCwgYmlvLCBpLCBzdGFydF9pZHgpCQkJXA0KIAlmb3IgKGJ2
bCA9IGJpb19pb3ZlY19pZHgoKGJpbyksIChzdGFydF9pZHgpKSwgaSA9IChzdGFydF9pZHgpOwlc
DQogCSAgICAgaSA8IChiaW8pLT5iaV92Y250OwkJCQkJXA0KIAkgICAgIGJ2bCsrLCBpKyspDQog
DQorLyoNCisgKiBkcml2ZXJzIHNob3VsZCBfbmV2ZXJfIHVzZSB0aGUgYWxsIHZlcnNpb24gLSB0
aGUgYmlvIG1heSBoYXZlIGJlZW4gc3BsaXQNCisgKiBiZWZvcmUgaXQgZ290IHRvIHRoZSBkcml2
ZXIgYW5kIHRoZSBkcml2ZXIgd29uJ3Qgb3duIGFsbCBvZiBpdA0KKyAqLw0KKyNkZWZpbmUgYmlv
X2Zvcl9lYWNoX3NlZ21lbnRfYWxsKGJ2bCwgYmlvLCBpKQkJCQlcDQorCWZvciAoaSA9IDA7CQkJ
CQkJCVwNCisJICAgICBidmwgPSBiaW9faW92ZWNfaWR4KChiaW8pLCAoaSkpLCBpIDwgKGJpbykt
PmJpX3ZjbnQ7CVwNCisJICAgICBpKyspDQorDQogI2RlZmluZSBiaW9fZm9yX2VhY2hfc2VnbWVu
dChidmwsIGJpbywgaSkJCQkJXA0KLQlfX2Jpb19mb3JfZWFjaF9zZWdtZW50KGJ2bCwgYmlvLCBp
LCAoYmlvKS0+YmlfaWR4KQ0KKwlmb3IgKGkgPSAoYmlvKS0+YmlfaWR4OwkJCQkJCVwNCisJICAg
ICBidmwgPSBiaW9faW92ZWNfaWR4KChiaW8pLCAoaSkpLCBpIDwgKGJpbyktPmJpX3ZjbnQ7CVwN
CisJICAgICBpKyspDQogDQogLyoNCiAgKiBnZXQgYSByZWZlcmVuY2UgdG8gYSBiaW8sIHNvIGl0
IHdvbid0IGRpc2FwcGVhci4gdGhlIGludGVuZGVkIHVzZSBpcw0KZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvZnRyYWNlX2V2ZW50LmggYi9pbmNsdWRlL2xpbnV4L2Z0cmFjZV9ldmVudC5oDQpp
bmRleCBjM2RhNDJkLi44MjkyNGJmIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9mdHJhY2Vf
ZXZlbnQuaA0KKysrIGIvaW5jbHVkZS9saW51eC9mdHJhY2VfZXZlbnQuaA0KQEAgLTcxLDYgKzcx
LDggQEAgc3RydWN0IHRyYWNlX2l0ZXJhdG9yIHsNCiAJLyogdHJhY2Vfc2VxIGZvciBfX3ByaW50
X2ZsYWdzKCkgYW5kIF9fcHJpbnRfc3ltYm9saWMoKSBldGMuICovDQogCXN0cnVjdCB0cmFjZV9z
ZXEJdG1wX3NlcTsNCiANCisJY3B1bWFza192YXJfdAkJc3RhcnRlZDsNCisNCiAJLyogVGhlIGJl
bG93IGlzIHplcm9lZCBvdXQgaW4gcGlwZV9yZWFkICovDQogCXN0cnVjdCB0cmFjZV9zZXEJc2Vx
Ow0KIAlzdHJ1Y3QgdHJhY2VfZW50cnkJKmVudDsNCkBAIC04Myw3ICs4NSw3IEBAIHN0cnVjdCB0
cmFjZV9pdGVyYXRvciB7DQogCWxvZmZfdAkJCXBvczsNCiAJbG9uZwkJCWlkeDsNCiANCi0JY3B1
bWFza192YXJfdAkJc3RhcnRlZDsNCisJLyogQWxsIG5ldyBmaWVsZCBoZXJlIHdpbGwgYmUgemVy
b2VkIG91dCBpbiBwaXBlX3JlYWQgKi8NCiB9Ow0KIA0KIA0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvbW1fdHlwZXMuaCBiL2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaA0KaW5kZXggNWI0MmYx
Yi4uZGUzYTMyMSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaA0KKysrIGIv
aW5jbHVkZS9saW51eC9tbV90eXBlcy5oDQpAQCAtMjk3LDYgKzI5Nyw3IEBAIHN0cnVjdCBtbV9z
dHJ1Y3Qgew0KIAl2b2lkICgqdW5tYXBfYXJlYSkgKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCB1bnNp
Z25lZCBsb25nIGFkZHIpOw0KICNlbmRpZg0KIAl1bnNpZ25lZCBsb25nIG1tYXBfYmFzZTsJCS8q
IGJhc2Ugb2YgbW1hcCBhcmVhICovDQorCXVuc2lnbmVkIGxvbmcgbW1hcF9sZWdhY3lfYmFzZTsg
ICAgICAgICAvKiBiYXNlIG9mIG1tYXAgYXJlYSBpbiBib3R0b20tdXAgYWxsb2NhdGlvbnMgKi8N
CiAJdW5zaWduZWQgbG9uZyB0YXNrX3NpemU7CQkvKiBzaXplIG9mIHRhc2sgdm0gc3BhY2UgKi8N
CiAJdW5zaWduZWQgbG9uZyBjYWNoZWRfaG9sZV9zaXplOyAJLyogaWYgbm9uLXplcm8sIHRoZSBs
YXJnZXN0IGhvbGUgYmVsb3cgZnJlZV9hcmVhX2NhY2hlICovDQogCXVuc2lnbmVkIGxvbmcgZnJl
ZV9hcmVhX2NhY2hlOwkJLyogZmlyc3QgaG9sZSBvZiBzaXplIGNhY2hlZF9ob2xlX3NpemUgb3Ig
bGFyZ2VyICovDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zbGFiLmggYi9pbmNsdWRlL2xp
bnV4L3NsYWIuaA0KaW5kZXggNTczYzgwOS4uYTU5NWRjZSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUv
bGludXgvc2xhYi5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3NsYWIuaA0KQEAgLTE5MCw3ICsxOTAs
NyBAQCBzaXplX3Qga3NpemUoY29uc3Qgdm9pZCAqKTsNCiAjZW5kaWYNCiANCiAvKioNCi0gKiBr
Y2FsbG9jIC0gYWxsb2NhdGUgbWVtb3J5IGZvciBhbiBhcnJheS4gVGhlIG1lbW9yeSBpcyBzZXQg
dG8gemVyby4NCisgKiBrbWFsbG9jX2FycmF5IC0gYWxsb2NhdGUgbWVtb3J5IGZvciBhbiBhcnJh
eS4NCiAgKiBAbjogbnVtYmVyIG9mIGVsZW1lbnRzLg0KICAqIEBzaXplOiBlbGVtZW50IHNpemUu
DQogICogQGZsYWdzOiB0aGUgdHlwZSBvZiBtZW1vcnkgdG8gYWxsb2NhdGUuDQpAQCAtMjQwLDEx
ICsyNDAsMjIgQEAgc2l6ZV90IGtzaXplKGNvbnN0IHZvaWQgKik7DQogICogZm9yIGdlbmVyYWwg
dXNlLCBhbmQgc28gYXJlIG5vdCBkb2N1bWVudGVkIGhlcmUuIEZvciBhIGZ1bGwgbGlzdCBvZg0K
ICAqIHBvdGVudGlhbCBmbGFncywgYWx3YXlzIHJlZmVyIHRvIGxpbnV4L2dmcC5oLg0KICAqLw0K
LXN0YXRpYyBpbmxpbmUgdm9pZCAqa2NhbGxvYyhzaXplX3Qgbiwgc2l6ZV90IHNpemUsIGdmcF90
IGZsYWdzKQ0KK3N0YXRpYyBpbmxpbmUgdm9pZCAqa21hbGxvY19hcnJheShzaXplX3Qgbiwgc2l6
ZV90IHNpemUsIGdmcF90IGZsYWdzKQ0KIHsNCiAJaWYgKHNpemUgIT0gMCAmJiBuID4gVUxPTkdf
TUFYIC8gc2l6ZSkNCiAJCXJldHVybiBOVUxMOw0KLQlyZXR1cm4gX19rbWFsbG9jKG4gKiBzaXpl
LCBmbGFncyB8IF9fR0ZQX1pFUk8pOw0KKwlyZXR1cm4gX19rbWFsbG9jKG4gKiBzaXplLCBmbGFn
cyk7DQorfQ0KKw0KKy8qKg0KKyAqIGtjYWxsb2MgLSBhbGxvY2F0ZSBtZW1vcnkgZm9yIGFuIGFy
cmF5LiBUaGUgbWVtb3J5IGlzIHNldCB0byB6ZXJvLg0KKyAqIEBuOiBudW1iZXIgb2YgZWxlbWVu
dHMuDQorICogQHNpemU6IGVsZW1lbnQgc2l6ZS4NCisgKiBAZmxhZ3M6IHRoZSB0eXBlIG9mIG1l
bW9yeSB0byBhbGxvY2F0ZSAoc2VlIGttYWxsb2MpLg0KKyAqLw0KK3N0YXRpYyBpbmxpbmUgdm9p
ZCAqa2NhbGxvYyhzaXplX3Qgbiwgc2l6ZV90IHNpemUsIGdmcF90IGZsYWdzKQ0KK3sNCisJcmV0
dXJuIGttYWxsb2NfYXJyYXkobiwgc2l6ZSwgZmxhZ3MgfCBfX0dGUF9aRVJPKTsNCiB9DQogDQog
I2lmICFkZWZpbmVkKENPTkZJR19OVU1BKSAmJiAhZGVmaW5lZChDT05GSUdfU0xPQikNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L3dhaXQuaCBiL2luY2x1ZGUvbGludXgvd2FpdC5oDQppbmRl
eCBiZWE3YWQ1Li5lMDA3Zjc2IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC93YWl0LmgNCisr
KyBiL2luY2x1ZGUvbGludXgvd2FpdC5oDQpAQCAtNTMwLDYgKzUzMCw2MyBAQCBkbyB7CQkJCQkJ
CQkJXA0KIAkgPyAwIDogX193YWl0X2V2ZW50X2ludGVycnVwdGlibGVfbG9ja2VkKHdxLCBjb25k
aXRpb24sIDEsIDEpKQ0KIA0KIA0KKyNkZWZpbmUgX193YWl0X2V2ZW50X2ludGVycnVwdGlibGVf
bG9ja19pcnFfdGltZW91dCh3cSwgY29uZGl0aW9uLAlcDQorCQkJCQkJICAgIGxvY2ssIHJldCkJ
CVwNCitkbyB7CQkJCQkJCQkJXA0KKwlERUZJTkVfV0FJVChfX3dhaXQpOwkJCQkJCVwNCisJCQkJ
CQkJCQlcDQorCWZvciAoOzspIHsJCQkJCQkJXA0KKwkJcHJlcGFyZV90b193YWl0KCZ3cSwgJl9f
d2FpdCwgVEFTS19JTlRFUlJVUFRJQkxFKTsJXA0KKwkJaWYgKGNvbmRpdGlvbikJCQkJCQlcDQor
CQkJYnJlYWs7CQkJCQkJXA0KKwkJaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKSB7CQkJCVwN
CisJCQlyZXQgPSAtRVJFU1RBUlRTWVM7CQkJCVwNCisJCQlicmVhazsJCQkJCQlcDQorCQl9CQkJ
CQkJCVwNCisJCXNwaW5fdW5sb2NrX2lycSgmbG9jayk7CQkJCQlcDQorCQlyZXQgPSBzY2hlZHVs
ZV90aW1lb3V0KHJldCk7CQkJCVwNCisJCXNwaW5fbG9ja19pcnEoJmxvY2spOwkJCQkJXA0KKwkJ
aWYgKCFyZXQpCQkJCQkJXA0KKwkJCWJyZWFrOwkJCQkJCVwNCisJfQkJCQkJCQkJXA0KKwlmaW5p
c2hfd2FpdCgmd3EsICZfX3dhaXQpOwkJCQkJXA0KK30gd2hpbGUgKDApDQorDQorLyoqDQorICog
d2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlX2xvY2tfaXJxX3RpbWVvdXQgLSBzbGVlcCB1bnRpbCBh
IGNvbmRpdGlvbiBnZXRzIHRydWUgb3IgYSB0aW1lb3V0IGVsYXBzZXMuDQorICoJCVRoZSBjb25k
aXRpb24gaXMgY2hlY2tlZCB1bmRlciB0aGUgbG9jay4gVGhpcyBpcyBleHBlY3RlZA0KKyAqCQl0
byBiZSBjYWxsZWQgd2l0aCB0aGUgbG9jayB0YWtlbi4NCisgKiBAd3E6IHRoZSB3YWl0cXVldWUg
dG8gd2FpdCBvbg0KKyAqIEBjb25kaXRpb246IGEgQyBleHByZXNzaW9uIGZvciB0aGUgZXZlbnQg
dG8gd2FpdCBmb3INCisgKiBAbG9jazogYSBsb2NrZWQgc3BpbmxvY2tfdCwgd2hpY2ggd2lsbCBi
ZSByZWxlYXNlZCBiZWZvcmUgc2NoZWR1bGUoKQ0KKyAqCSAgYW5kIHJlYWNxdWlyZWQgYWZ0ZXJ3
YXJkcy4NCisgKiBAdGltZW91dDogdGltZW91dCwgaW4gamlmZmllcw0KKyAqDQorICogVGhlIHBy
b2Nlc3MgaXMgcHV0IHRvIHNsZWVwIChUQVNLX0lOVEVSUlVQVElCTEUpIHVudGlsIHRoZQ0KKyAq
IEBjb25kaXRpb24gZXZhbHVhdGVzIHRvIHRydWUgb3Igc2lnbmFsIGlzIHJlY2VpdmVkLiBUaGUg
QGNvbmRpdGlvbiBpcw0KKyAqIGNoZWNrZWQgZWFjaCB0aW1lIHRoZSB3YWl0cXVldWUgQHdxIGlz
IHdva2VuIHVwLg0KKyAqDQorICogd2FrZV91cCgpIGhhcyB0byBiZSBjYWxsZWQgYWZ0ZXIgY2hh
bmdpbmcgYW55IHZhcmlhYmxlIHRoYXQgY291bGQNCisgKiBjaGFuZ2UgdGhlIHJlc3VsdCBvZiB0
aGUgd2FpdCBjb25kaXRpb24uDQorICoNCisgKiBUaGlzIGlzIHN1cHBvc2VkIHRvIGJlIGNhbGxl
ZCB3aGlsZSBob2xkaW5nIHRoZSBsb2NrLiBUaGUgbG9jayBpcw0KKyAqIGRyb3BwZWQgYmVmb3Jl
IGdvaW5nIHRvIHNsZWVwIGFuZCBpcyByZWFjcXVpcmVkIGFmdGVyd2FyZHMuDQorICoNCisgKiBU
aGUgZnVuY3Rpb24gcmV0dXJucyAwIGlmIHRoZSBAdGltZW91dCBlbGFwc2VkLCAtRVJFU1RBUlRT
WVMgaWYgaXQNCisgKiB3YXMgaW50ZXJydXB0ZWQgYnkgYSBzaWduYWwsIGFuZCB0aGUgcmVtYWlu
aW5nIGppZmZpZXMgb3RoZXJ3aXNlDQorICogaWYgdGhlIGNvbmRpdGlvbiBldmFsdWF0ZWQgdG8g
dHJ1ZSBiZWZvcmUgdGhlIHRpbWVvdXQgZWxhcHNlZC4NCisgKi8NCisjZGVmaW5lIHdhaXRfZXZl
bnRfaW50ZXJydXB0aWJsZV9sb2NrX2lycV90aW1lb3V0KHdxLCBjb25kaXRpb24sIGxvY2ssCVwN
CisJCQkJCQkgIHRpbWVvdXQpCQlcDQorKHsJCQkJCQkJCQlcDQorCWludCBfX3JldCA9IHRpbWVv
dXQ7CQkJCQkJXA0KKwkJCQkJCQkJCVwNCisJaWYgKCEoY29uZGl0aW9uKSkJCQkJCQlcDQorCQlf
X3dhaXRfZXZlbnRfaW50ZXJydXB0aWJsZV9sb2NrX2lycV90aW1lb3V0KAkJXA0KKwkJCQkJd3Es
IGNvbmRpdGlvbiwgbG9jaywgX19yZXQpOwlcDQorCV9fcmV0OwkJCQkJCQkJXA0KK30pDQorDQog
DQogI2RlZmluZSBfX3dhaXRfZXZlbnRfa2lsbGFibGUod3EsIGNvbmRpdGlvbiwgcmV0KQkJCVwN
CiBkbyB7CQkJCQkJCQkJXA0KZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVudHMvY29yZS5jIGIva2Vy
bmVsL2V2ZW50cy9jb3JlLmMNCmluZGV4IDhiZTliNzQ2Li41YmJlNDQzIDEwMDY0NA0KLS0tIGEv
a2VybmVsL2V2ZW50cy9jb3JlLmMNCisrKyBiL2tlcm5lbC9ldmVudHMvY29yZS5jDQpAQCAtOTAw
LDYgKzkwMCwxNSBAQCBsaXN0X2FkZF9ldmVudChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQsIHN0
cnVjdCBwZXJmX2V2ZW50X2NvbnRleHQgKmN0eCkNCiB9DQogDQogLyoNCisgKiBJbml0aWFsaXpl
IGV2ZW50IHN0YXRlIGJhc2VkIG9uIHRoZSBwZXJmX2V2ZW50X2F0dHI6OmRpc2FibGVkLg0KKyAq
Lw0KK3N0YXRpYyBpbmxpbmUgdm9pZCBwZXJmX2V2ZW50X19zdGF0ZV9pbml0KHN0cnVjdCBwZXJm
X2V2ZW50ICpldmVudCkNCit7DQorCWV2ZW50LT5zdGF0ZSA9IGV2ZW50LT5hdHRyLmRpc2FibGVk
ID8gUEVSRl9FVkVOVF9TVEFURV9PRkYgOg0KKwkJCQkJICAgICAgUEVSRl9FVkVOVF9TVEFURV9J
TkFDVElWRTsNCit9DQorDQorLyoNCiAgKiBDYWxsZWQgYXQgcGVyZl9ldmVudCBjcmVhdGlvbiBh
bmQgd2hlbiBldmVudHMgYXJlIGF0dGFjaGVkL2RldGFjaGVkIGZyb20gYQ0KICAqIGdyb3VwLg0K
ICAqLw0KQEAgLTYwNTAsOCArNjA1OSw3IEBAIHBlcmZfZXZlbnRfYWxsb2Moc3RydWN0IHBlcmZf
ZXZlbnRfYXR0ciAqYXR0ciwgaW50IGNwdSwNCiAJZXZlbnQtPm92ZXJmbG93X2hhbmRsZXIJPSBv
dmVyZmxvd19oYW5kbGVyOw0KIAlldmVudC0+b3ZlcmZsb3dfaGFuZGxlcl9jb250ZXh0ID0gY29u
dGV4dDsNCiANCi0JaWYgKGF0dHItPmRpc2FibGVkKQ0KLQkJZXZlbnQtPnN0YXRlID0gUEVSRl9F
VkVOVF9TVEFURV9PRkY7DQorCXBlcmZfZXZlbnRfX3N0YXRlX2luaXQoZXZlbnQpOw0KIA0KIAlw
bXUgPSBOVUxMOw0KIA0KQEAgLTY0MzMsOSArNjQ0MSwxNyBAQCBTWVNDQUxMX0RFRklORTUocGVy
Zl9ldmVudF9vcGVuLA0KIA0KIAkJbXV0ZXhfbG9jaygmZ2N0eC0+bXV0ZXgpOw0KIAkJcGVyZl9y
ZW1vdmVfZnJvbV9jb250ZXh0KGdyb3VwX2xlYWRlcik7DQorDQorCQkvKg0KKwkJICogUmVtb3Zp
bmcgZnJvbSB0aGUgY29udGV4dCBlbmRzIHVwIHdpdGggZGlzYWJsZWQNCisJCSAqIGV2ZW50LiBX
aGF0IHdlIHdhbnQgaGVyZSBpcyBldmVudCBpbiB0aGUgaW5pdGlhbA0KKwkJICogc3RhcnR1cCBz
dGF0ZSwgcmVhZHkgdG8gYmUgYWRkIGludG8gbmV3IGNvbnRleHQuDQorCQkgKi8NCisJCXBlcmZf
ZXZlbnRfX3N0YXRlX2luaXQoZ3JvdXBfbGVhZGVyKTsNCiAJCWxpc3RfZm9yX2VhY2hfZW50cnko
c2libGluZywgJmdyb3VwX2xlYWRlci0+c2libGluZ19saXN0LA0KIAkJCQkgICAgZ3JvdXBfZW50
cnkpIHsNCiAJCQlwZXJmX3JlbW92ZV9mcm9tX2NvbnRleHQoc2libGluZyk7DQorCQkJcGVyZl9l
dmVudF9fc3RhdGVfaW5pdChzaWJsaW5nKTsNCiAJCQlwdXRfY3R4KGdjdHgpOw0KIAkJfQ0KIAkJ
bXV0ZXhfdW5sb2NrKCZnY3R4LT5tdXRleCk7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkX2Zh
aXIuYyBiL2tlcm5lbC9zY2hlZF9mYWlyLmMNCmluZGV4IDY2ZTQ1NzYuLjU5NDc0YzUgMTAwNjQ0
DQotLS0gYS9rZXJuZWwvc2NoZWRfZmFpci5jDQorKysgYi9rZXJuZWwvc2NoZWRfZmFpci5jDQpA
QCAtNTAzMyw3ICs1MDMzLDcgQEAgc3RhdGljIHVuc2lnbmVkIGludCBnZXRfcnJfaW50ZXJ2YWxf
ZmFpcihzdHJ1Y3QgcnEgKnJxLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2sNCiAJICogaWRsZSBy
dW5xdWV1ZToNCiAJICovDQogCWlmIChycS0+Y2ZzLmxvYWQud2VpZ2h0KQ0KLQkJcnJfaW50ZXJ2
YWwgPSBOU19UT19KSUZGSUVTKHNjaGVkX3NsaWNlKCZycS0+Y2ZzLCBzZSkpOw0KKwkJcnJfaW50
ZXJ2YWwgPSBOU19UT19KSUZGSUVTKHNjaGVkX3NsaWNlKGNmc19ycV9vZihzZSksIHNlKSk7DQog
DQogCXJldHVybiBycl9pbnRlcnZhbDsNCiB9DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3Ry
YWNlLmMgYi9rZXJuZWwvdHJhY2UvdHJhY2UuYw0KaW5kZXggYTU4NGFkOS4uY2UxMDY3ZiAxMDA2
NDQNCi0tLSBhL2tlcm5lbC90cmFjZS90cmFjZS5jDQorKysgYi9rZXJuZWwvdHJhY2UvdHJhY2Uu
Yw0KQEAgLTMzNzUsNiArMzM3NSw3IEBAIHdhaXRhZ2FpbjoNCiAJbWVtc2V0KCZpdGVyLT5zZXEs
IDAsDQogCSAgICAgICBzaXplb2Yoc3RydWN0IHRyYWNlX2l0ZXJhdG9yKSAtDQogCSAgICAgICBv
ZmZzZXRvZihzdHJ1Y3QgdHJhY2VfaXRlcmF0b3IsIHNlcSkpOw0KKwljcHVtYXNrX2NsZWFyKGl0
ZXItPnN0YXJ0ZWQpOw0KIAlpdGVyLT5wb3MgPSAtMTsNCiANCiAJdHJhY2VfZXZlbnRfcmVhZF9s
b2NrKCk7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3dvcmtxdWV1ZS5jIGIva2VybmVsL3dvcmtxdWV1
ZS5jDQppbmRleCAwYWQyNDIwLi4wYmM5ZmYwIDEwMDY0NA0KLS0tIGEva2VybmVsL3dvcmtxdWV1
ZS5jDQorKysgYi9rZXJuZWwvd29ya3F1ZXVlLmMNCkBAIC0xOTIwLDYgKzE5MjAsMTUgQEAgX19h
Y3F1aXJlcygmZ2N3cS0+bG9jaykNCiAJCWR1bXBfc3RhY2soKTsNCiAJfQ0KIA0KKwkvKg0KKwkg
KiBUaGUgZm9sbG93aW5nIHByZXZlbnRzIGEga3dvcmtlciBmcm9tIGhvZ2dpbmcgQ1BVIG9uICFQ
UkVFTVBUDQorCSAqIGtlcm5lbHMsIHdoZXJlIGEgcmVxdWV1ZWluZyB3b3JrIGl0ZW0gd2FpdGlu
ZyBmb3Igc29tZXRoaW5nIHRvDQorCSAqIGhhcHBlbiBjb3VsZCBkZWFkbG9jayB3aXRoIHN0b3Bf
bWFjaGluZSBhcyBzdWNoIHdvcmsgaXRlbSBjb3VsZA0KKwkgKiBpbmRlZmluaXRlbHkgcmVxdWV1
ZSBpdHNlbGYgd2hpbGUgYWxsIG90aGVyIENQVXMgYXJlIHRyYXBwZWQgaW4NCisJICogc3RvcF9t
YWNoaW5lLg0KKwkgKi8NCisJY29uZF9yZXNjaGVkKCk7DQorDQogCXNwaW5fbG9ja19pcnEoJmdj
d3EtPmxvY2spOw0KIA0KIAkvKiBjbGVhciBjcHUgaW50ZW5zaXZlIHN0YXR1cyAqLw0KZGlmZiAt
LWdpdCBhL21tL2JvdW5jZS5jIGIvbW0vYm91bmNlLmMNCmluZGV4IDRlOWFlNzIuLmY3MWEzYjM0
IDEwMDY0NA0KLS0tIGEvbW0vYm91bmNlLmMNCisrKyBiL21tL2JvdW5jZS5jDQpAQCAtMTMyLDcg
KzEzMiw3IEBAIHN0YXRpYyB2b2lkIGJvdW5jZV9lbmRfaW8oc3RydWN0IGJpbyAqYmlvLCBtZW1w
b29sX3QgKnBvb2wsIGludCBlcnIpDQogCS8qDQogCSAqIGZyZWUgdXAgYm91bmNlIGluZGlyZWN0
IHBhZ2VzIHVzZWQNCiAJICovDQotCV9fYmlvX2Zvcl9lYWNoX3NlZ21lbnQoYnZlYywgYmlvLCBp
LCAwKSB7DQorCWJpb19mb3JfZWFjaF9zZWdtZW50X2FsbChidmVjLCBiaW8sIGkpIHsNCiAJCW9y
Z192ZWMgPSBiaW9fb3JpZy0+YmlfaW9fdmVjICsgaTsNCiAJCWlmIChidmVjLT5idl9wYWdlID09
IG9yZ192ZWMtPmJ2X3BhZ2UpDQogCQkJY29udGludWU7DQpkaWZmIC0tZ2l0IGEvbW0vbm9tbXUu
YyBiL21tL25vbW11LmMNCmluZGV4IGYwY2Q3YWIuLjFkYjc5NzEgMTAwNjQ0DQotLS0gYS9tbS9u
b21tdS5jDQorKysgYi9tbS9ub21tdS5jDQpAQCAtMTgyNSw2ICsxODI1LDE2IEBAIGludCByZW1h
cF9wZm5fcmFuZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcgYWRk
ciwNCiB9DQogRVhQT1JUX1NZTUJPTChyZW1hcF9wZm5fcmFuZ2UpOw0KIA0KK2ludCB2bV9pb21h
cF9tZW1vcnkoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHBoeXNfYWRkcl90IHN0YXJ0LCB1
bnNpZ25lZCBsb25nIGxlbikNCit7DQorCXVuc2lnbmVkIGxvbmcgcGZuID0gc3RhcnQgPj4gUEFH
RV9TSElGVDsNCisJdW5zaWduZWQgbG9uZyB2bV9sZW4gPSB2bWEtPnZtX2VuZCAtIHZtYS0+dm1f
c3RhcnQ7DQorDQorCXBmbiArPSB2bWEtPnZtX3Bnb2ZmOw0KKwlyZXR1cm4gaW9fcmVtYXBfcGZu
X3JhbmdlKHZtYSwgdm1hLT52bV9zdGFydCwgcGZuLCB2bV9sZW4sIHZtYS0+dm1fcGFnZV9wcm90
KTsNCit9DQorRVhQT1JUX1NZTUJPTCh2bV9pb21hcF9tZW1vcnkpOw0KKw0KIGludCByZW1hcF92
bWFsbG9jX3JhbmdlKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLCB2b2lkICphZGRyLA0KIAkJ
CXVuc2lnbmVkIGxvbmcgcGdvZmYpDQogew0KZGlmZiAtLWdpdCBhL21tL3BhZ2VfYWxsb2MuYyBi
L21tL3BhZ2VfYWxsb2MuYw0KaW5kZXggNWMwMjhlMi4uYjVhZmVhMiAxMDA2NDQNCi0tLSBhL21t
L3BhZ2VfYWxsb2MuYw0KKysrIGIvbW0vcGFnZV9hbGxvYy5jDQpAQCAtNTc3Nyw2ICs1Nzc3LDEw
IEBAIF9fb2ZmbGluZV9pc29sYXRlZF9wYWdlcyh1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwgdW5z
aWduZWQgbG9uZyBlbmRfcGZuKQ0KIAkJem9uZS0+ZnJlZV9hcmVhW29yZGVyXS5ucl9mcmVlLS07
DQogCQlfX21vZF96b25lX3BhZ2Vfc3RhdGUoem9uZSwgTlJfRlJFRV9QQUdFUywNCiAJCQkJICAg
ICAgLSAoMVVMIDw8IG9yZGVyKSk7DQorI2lmZGVmIENPTkZJR19ISUdITUVNDQorCQlpZiAoUGFn
ZUhpZ2hNZW0ocGFnZSkpDQorCQkJdG90YWxoaWdoX3BhZ2VzIC09IDEgPDwgb3JkZXI7DQorI2Vu
ZGlmDQogCQlmb3IgKGkgPSAwOyBpIDwgKDEgPDwgb3JkZXIpOyBpKyspDQogCQkJU2V0UGFnZVJl
c2VydmVkKChwYWdlK2kpKTsNCiAJCXBmbiArPSAoMSA8PCBvcmRlcik7DQpkaWZmIC0tZ2l0IGEv
bmV0L2lwdjQvc3lzY3RsX25ldF9pcHY0LmMgYi9uZXQvaXB2NC9zeXNjdGxfbmV0X2lwdjQuYw0K
aW5kZXggNTQ4NTA3Ny4uNzM5YjA3MyAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L3N5c2N0bF9uZXRf
aXB2NC5jDQorKysgYi9uZXQvaXB2NC9zeXNjdGxfbmV0X2lwdjQuYw0KQEAgLTMyLDYgKzMyLDgg
QEAgc3RhdGljIGludCB0Y3BfYWR2X3dpbl9zY2FsZV9taW4gPSAtMzE7DQogc3RhdGljIGludCB0
Y3BfYWR2X3dpbl9zY2FsZV9tYXggPSAzMTsNCiBzdGF0aWMgaW50IGlwX3R0bF9taW4gPSAxOw0K
IHN0YXRpYyBpbnQgaXBfdHRsX21heCA9IDI1NTsNCitzdGF0aWMgaW50IHRjcF9zeW5fcmV0cmll
c19taW4gPSAxOw0KK3N0YXRpYyBpbnQgdGNwX3N5bl9yZXRyaWVzX21heCA9IE1BWF9UQ1BfU1lO
Q05UOw0KIHN0YXRpYyBpbnQgaXBfcGluZ19ncm91cF9yYW5nZV9taW5bXSA9IHsgMCwgMCB9Ow0K
IHN0YXRpYyBpbnQgaXBfcGluZ19ncm91cF9yYW5nZV9tYXhbXSA9IHsgR0lEX1RfTUFYLCBHSURf
VF9NQVggfTsNCiANCkBAIC0yMzEsNyArMjMzLDkgQEAgc3RhdGljIHN0cnVjdCBjdGxfdGFibGUg
aXB2NF90YWJsZVtdID0gew0KIAkJLmRhdGEJCT0gJnN5c2N0bF90Y3Bfc3luX3JldHJpZXMsDQog
CQkubWF4bGVuCQk9IHNpemVvZihpbnQpLA0KIAkJLm1vZGUJCT0gMDY0NCwNCi0JCS5wcm9jX2hh
bmRsZXIJPSBwcm9jX2RvaW50dmVjDQorCQkucHJvY19oYW5kbGVyCT0gcHJvY19kb2ludHZlY19t
aW5tYXgsDQorCQkuZXh0cmExCQk9ICZ0Y3Bfc3luX3JldHJpZXNfbWluLA0KKwkJLmV4dHJhMgkJ
PSAmdGNwX3N5bl9yZXRyaWVzX21heA0KIAl9LA0KIAl7DQogCQkucHJvY25hbWUJPSAidGNwX3N5
bmFja19yZXRyaWVzIiwNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcDZtci5jIGIvbmV0L2lwdjYv
aXA2bXIuYw0KaW5kZXggNDQ5YTkxOC4uZjVhZjI1OSAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2lw
Nm1yLmMNCisrKyBiL25ldC9pcHY2L2lwNm1yLmMNCkBAIC0yNTcsMTAgKzI1NywxMiBAQCBzdGF0
aWMgdm9pZCBfX25ldF9leGl0IGlwNm1yX3J1bGVzX2V4aXQoc3RydWN0IG5ldCAqbmV0KQ0KIHsN
CiAJc3RydWN0IG1yNl90YWJsZSAqbXJ0LCAqbmV4dDsNCiANCisJcnRubF9sb2NrKCk7DQogCWxp
c3RfZm9yX2VhY2hfZW50cnlfc2FmZShtcnQsIG5leHQsICZuZXQtPmlwdjYubXI2X3RhYmxlcywg
bGlzdCkgew0KIAkJbGlzdF9kZWwoJm1ydC0+bGlzdCk7DQogCQlpcDZtcl9mcmVlX3RhYmxlKG1y
dCk7DQogCX0NCisJcnRubF91bmxvY2soKTsNCiAJZmliX3J1bGVzX3VucmVnaXN0ZXIobmV0LT5p
cHY2Lm1yNl9ydWxlc19vcHMpOw0KIH0NCiAjZWxzZQ0KQEAgLTI4Nyw3ICsyODksMTAgQEAgc3Rh
dGljIGludCBfX25ldF9pbml0IGlwNm1yX3J1bGVzX2luaXQoc3RydWN0IG5ldCAqbmV0KQ0KIA0K
IHN0YXRpYyB2b2lkIF9fbmV0X2V4aXQgaXA2bXJfcnVsZXNfZXhpdChzdHJ1Y3QgbmV0ICpuZXQp
DQogew0KKwlydG5sX2xvY2soKTsNCiAJaXA2bXJfZnJlZV90YWJsZShuZXQtPmlwdjYubXJ0Nik7
DQorCW5ldC0+aXB2Ni5tcnQ2ID0gTlVMTDsNCisJcnRubF91bmxvY2soKTsNCiB9DQogI2VuZGlm
DQogDQpkaWZmIC0tZ2l0IGEvbmV0L2tleS9hZl9rZXkuYyBiL25ldC9rZXkvYWZfa2V5LmMNCmlu
ZGV4IDZmZWZkZmMuLjhkYmRiOGUgMTAwNjQ0DQotLS0gYS9uZXQva2V5L2FmX2tleS5jDQorKysg
Yi9uZXQva2V5L2FmX2tleS5jDQpAQCAtMjA3Myw2ICsyMDczLDcgQEAgc3RhdGljIGludCBwZmtl
eV94ZnJtX3BvbGljeTJtc2coc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgc3RydWN0IHhmcm1f
cG9saWN5ICoNCiAJCQlwb2wtPnNhZGJfeF9wb2xpY3lfdHlwZSA9IElQU0VDX1BPTElDWV9OT05F
Ow0KIAl9DQogCXBvbC0+c2FkYl94X3BvbGljeV9kaXIgPSBkaXIrMTsNCisJcG9sLT5zYWRiX3hf
cG9saWN5X3Jlc2VydmVkID0gMDsNCiAJcG9sLT5zYWRiX3hfcG9saWN5X2lkID0geHAtPmluZGV4
Ow0KIAlwb2wtPnNhZGJfeF9wb2xpY3lfcHJpb3JpdHkgPSB4cC0+cHJpb3JpdHk7DQogDQpAQCAt
MjY4Niw2ICsyNjg3LDcgQEAgc3RhdGljIGludCBrZXlfbm90aWZ5X3BvbGljeV9mbHVzaChjb25z
dCBzdHJ1Y3Qga21fZXZlbnQgKmMpDQogCWhkci0+c2FkYl9tc2dfcGlkID0gYy0+cGlkOw0KIAlo
ZHItPnNhZGJfbXNnX3ZlcnNpb24gPSBQRl9LRVlfVjI7DQogCWhkci0+c2FkYl9tc2dfZXJybm8g
PSAodWludDhfdCkgMDsNCisJaGRyLT5zYWRiX21zZ19zYXR5cGUgPSBTQURCX1NBVFlQRV9VTlNQ
RUM7DQogCWhkci0+c2FkYl9tc2dfbGVuID0gKHNpemVvZihzdHJ1Y3Qgc2FkYl9tc2cpIC8gc2l6
ZW9mKHVpbnQ2NF90KSk7DQogCWhkci0+c2FkYl9tc2dfcmVzZXJ2ZWQgPSAwOw0KIAlwZmtleV9i
cm9hZGNhc3Qoc2tiX291dCwgR0ZQX0FUT01JQywgQlJPQURDQVNUX0FMTCwgTlVMTCwgYy0+bmV0
KTsNCkBAIC0zMTA4LDcgKzMxMTAsOSBAQCBzdGF0aWMgaW50IHBma2V5X3NlbmRfYWNxdWlyZShz
dHJ1Y3QgeGZybV9zdGF0ZSAqeCwgc3RydWN0IHhmcm1fdG1wbCAqdCwgc3RydWN0DQogCXBvbC0+
c2FkYl94X3BvbGljeV9leHR0eXBlID0gU0FEQl9YX0VYVF9QT0xJQ1k7DQogCXBvbC0+c2FkYl94
X3BvbGljeV90eXBlID0gSVBTRUNfUE9MSUNZX0lQU0VDOw0KIAlwb2wtPnNhZGJfeF9wb2xpY3lf
ZGlyID0gZGlyKzE7DQorCXBvbC0+c2FkYl94X3BvbGljeV9yZXNlcnZlZCA9IDA7DQogCXBvbC0+
c2FkYl94X3BvbGljeV9pZCA9IHhwLT5pbmRleDsNCisJcG9sLT5zYWRiX3hfcG9saWN5X3ByaW9y
aXR5ID0geHAtPnByaW9yaXR5Ow0KIA0KIAkvKiBTZXQgc2FkYl9jb21iJ3MuICovDQogCWlmICh4
LT5pZC5wcm90byA9PSBJUFBST1RPX0FIKQ0KQEAgLTM0OTYsNiArMzUwMCw3IEBAIHN0YXRpYyBp
bnQgcGZrZXlfc2VuZF9taWdyYXRlKGNvbnN0IHN0cnVjdCB4ZnJtX3NlbGVjdG9yICpzZWwsIHU4
IGRpciwgdTggdHlwZSwNCiAJcG9sLT5zYWRiX3hfcG9saWN5X2V4dHR5cGUgPSBTQURCX1hfRVhU
X1BPTElDWTsNCiAJcG9sLT5zYWRiX3hfcG9saWN5X3R5cGUgPSBJUFNFQ19QT0xJQ1lfSVBTRUM7
DQogCXBvbC0+c2FkYl94X3BvbGljeV9kaXIgPSBkaXIgKyAxOw0KKwlwb2wtPnNhZGJfeF9wb2xp
Y3lfcmVzZXJ2ZWQgPSAwOw0KIAlwb2wtPnNhZGJfeF9wb2xpY3lfaWQgPSAwOw0KIAlwb2wtPnNh
ZGJfeF9wb2xpY3lfcHJpb3JpdHkgPSAwOw0KIA0KZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9y
eC5jIGIvbmV0L21hYzgwMjExL3J4LmMNCmluZGV4IGNkNmNiZGIuLjdkODgyZmMgMTAwNjQ0DQot
LS0gYS9uZXQvbWFjODAyMTEvcnguYw0KKysrIGIvbmV0L21hYzgwMjExL3J4LmMNCkBAIC04MjEs
OCArODIxLDE0IEBAIGllZWU4MDIxMV9yeF9oX2NoZWNrKHN0cnVjdCBpZWVlODAyMTFfcnhfZGF0
YSAqcngpDQogCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4MDIxMV9o
ZHIgKilyeC0+c2tiLT5kYXRhOw0KIAlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqc3RhdHVz
ID0gSUVFRTgwMjExX1NLQl9SWENCKHJ4LT5za2IpOw0KIA0KLQkvKiBEcm9wIGR1cGxpY2F0ZSA4
MDIuMTEgcmV0cmFuc21pc3Npb25zIChJRUVFIDgwMi4xMSBDaGFwLiA5LjIuOSkgKi8NCi0JaWYg
KHJ4LT5zdGEgJiYgIWlzX211bHRpY2FzdF9ldGhlcl9hZGRyKGhkci0+YWRkcjEpKSB7DQorCS8q
DQorCSAqIERyb3AgZHVwbGljYXRlIDgwMi4xMSByZXRyYW5zbWlzc2lvbnMNCisJICogKElFRUUg
ODAyLjExLTIwMTI6IDkuMy4yLjEwICJEdXBsaWNhdGUgZGV0ZWN0aW9uIGFuZCByZWNvdmVyeSIp
DQorCSAqLw0KKwlpZiAocngtPnNrYi0+bGVuID49IDI0ICYmIHJ4LT5zdGEgJiYNCisJICAgICFp
ZWVlODAyMTFfaXNfY3RsKGhkci0+ZnJhbWVfY29udHJvbCkgJiYNCisJICAgICFpZWVlODAyMTFf
aXNfcW9zX251bGxmdW5jKGhkci0+ZnJhbWVfY29udHJvbCkgJiYNCisJICAgICFpc19tdWx0aWNh
c3RfZXRoZXJfYWRkcihoZHItPmFkZHIxKSkgew0KIAkJaWYgKHVubGlrZWx5KGllZWU4MDIxMV9o
YXNfcmV0cnkoaGRyLT5mcmFtZV9jb250cm9sKSAmJg0KIAkJCSAgICAgcngtPnN0YS0+bGFzdF9z
ZXFfY3RybFtyeC0+c2Vxbm9faWR4XSA9PQ0KIAkJCSAgICAgaGRyLT5zZXFfY3RybCkpIHsNCmRp
ZmYgLS1naXQgYS9uZXQvc2NoZWQvc2NoX2F0bS5jIGIvbmV0L3NjaGVkL3NjaF9hdG0uYw0KaW5k
ZXggZTI1ZTQ5MC4uNmUzOGVmMCAxMDA2NDQNCi0tLSBhL25ldC9zY2hlZC9zY2hfYXRtLmMNCisr
KyBiL25ldC9zY2hlZC9zY2hfYXRtLmMNCkBAIC02MDYsNiArNjA2LDcgQEAgc3RhdGljIGludCBh
dG1fdGNfZHVtcF9jbGFzcyhzdHJ1Y3QgUWRpc2MgKnNjaCwgdW5zaWduZWQgbG9uZyBjbCwNCiAJ
CXN0cnVjdCBzb2NrYWRkcl9hdG1wdmMgcHZjOw0KIAkJaW50IHN0YXRlOw0KIA0KKwkJbWVtc2V0
KCZwdmMsIDAsIHNpemVvZihwdmMpKTsNCiAJCXB2Yy5zYXBfZmFtaWx5ID0gQUZfQVRNUFZDOw0K
IAkJcHZjLnNhcF9hZGRyLml0ZiA9IGZsb3ctPnZjYy0+ZGV2ID8gZmxvdy0+dmNjLT5kZXYtPm51
bWJlciA6IC0xOw0KIAkJcHZjLnNhcF9hZGRyLnZwaSA9IGZsb3ctPnZjYy0+dnBpOw0KZGlmZiAt
LWdpdCBhL25ldC9zY2hlZC9zY2hfY2JxLmMgYi9uZXQvc2NoZWQvc2NoX2NicS5jDQppbmRleCBi
N2NkZGI5Li43ZjU5OTQ0IDEwMDY0NA0KLS0tIGEvbmV0L3NjaGVkL3NjaF9jYnEuYw0KKysrIGIv
bmV0L3NjaGVkL3NjaF9jYnEuYw0KQEAgLTE0NjcsNiArMTQ2Nyw3IEBAIHN0YXRpYyBpbnQgY2Jx
X2R1bXBfd3JyKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBjYnFfY2xhc3MgKmNsKQ0KIAl1
bnNpZ25lZCBjaGFyICpiID0gc2tiX3RhaWxfcG9pbnRlcihza2IpOw0KIAlzdHJ1Y3QgdGNfY2Jx
X3dycm9wdCBvcHQ7DQogDQorCW1lbXNldCgmb3B0LCAwLCBzaXplb2Yob3B0KSk7DQogCW9wdC5m
bGFncyA9IDA7DQogCW9wdC5hbGxvdCA9IGNsLT5hbGxvdDsNCiAJb3B0LnByaW9yaXR5ID0gY2wt
PnByaW9yaXR5ICsgMTsNCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9vdXRxdWV1ZS5jIGIvbmV0L3Nj
dHAvb3V0cXVldWUuYw0KaW5kZXggOTZlYjE2OC4uM2RkNzIwNyAxMDA2NDQNCi0tLSBhL25ldC9z
Y3RwL291dHF1ZXVlLmMNCisrKyBiL25ldC9zY3RwL291dHF1ZXVlLmMNCkBAIC0yMDUsNiArMjA1
LDggQEAgc3RhdGljIGlubGluZSBpbnQgc2N0cF9jYWNjX3NraXAoc3RydWN0IHNjdHBfdHJhbnNw
b3J0ICpwcmltYXJ5LA0KICAqLw0KIHZvaWQgc2N0cF9vdXRxX2luaXQoc3RydWN0IHNjdHBfYXNz
b2NpYXRpb24gKmFzb2MsIHN0cnVjdCBzY3RwX291dHEgKnEpDQogew0KKwltZW1zZXQocSwgMCwg
c2l6ZW9mKHN0cnVjdCBzY3RwX291dHEpKTsNCisNCiAJcS0+YXNvYyA9IGFzb2M7DQogCUlOSVRf
TElTVF9IRUFEKCZxLT5vdXRfY2h1bmtfbGlzdCk7DQogCUlOSVRfTElTVF9IRUFEKCZxLT5jb250
cm9sX2NodW5rX2xpc3QpOw0KQEAgLTIxMiwxMyArMjE0LDcgQEAgdm9pZCBzY3RwX291dHFfaW5p
dChzdHJ1Y3Qgc2N0cF9hc3NvY2lhdGlvbiAqYXNvYywgc3RydWN0IHNjdHBfb3V0cSAqcSkNCiAJ
SU5JVF9MSVNUX0hFQUQoJnEtPnNhY2tlZCk7DQogCUlOSVRfTElTVF9IRUFEKCZxLT5hYmFuZG9u
ZWQpOw0KIA0KLQlxLT5mYXN0X3J0eCA9IDA7DQotCXEtPm91dHN0YW5kaW5nX2J5dGVzID0gMDsN
CiAJcS0+ZW1wdHkgPSAxOw0KLQlxLT5jb3JrICA9IDA7DQotDQotCXEtPm1hbGxvY2VkID0gMDsN
Ci0JcS0+b3V0X3FsZW4gPSAwOw0KIH0NCiANCiAvKiBGcmVlIHRoZSBvdXRxdWV1ZSBzdHJ1Y3R1
cmUgYW5kIGFueSByZWxhdGVkIHBlbmRpbmcgY2h1bmtzLg0KZGlmZiAtLWdpdCBhL25ldC9zdW5y
cGMvYXV0aF9nc3MvZ3NzX2tyYjVfd3JhcC5jIGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9nc3Nfa3Ji
NV93cmFwLmMNCmluZGV4IDI3NjNlM2UuLjM4ZjM4OGMgMTAwNjQ0DQotLS0gYS9uZXQvc3VucnBj
L2F1dGhfZ3NzL2dzc19rcmI1X3dyYXAuYw0KKysrIGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9nc3Nf
a3JiNV93cmFwLmMNCkBAIC04Miw5ICs4Miw5IEBAIGdzc19rcmI1X3JlbW92ZV9wYWRkaW5nKHN0
cnVjdCB4ZHJfYnVmICpidWYsIGludCBibG9ja3NpemUpDQogCQkJCQk+PlBBR0VfQ0FDSEVfU0hJ
RlQ7DQogCQl1bnNpZ25lZCBpbnQgb2Zmc2V0ID0gKGJ1Zi0+cGFnZV9iYXNlICsgbGVuIC0gMSkN
CiAJCQkJCSYgKFBBR0VfQ0FDSEVfU0laRSAtIDEpOw0KLQkJcHRyID0ga21hcF9hdG9taWMoYnVm
LT5wYWdlc1tsYXN0XSwgS01fVVNFUjApOw0KKwkJcHRyID0ga21hcF9hdG9taWMoYnVmLT5wYWdl
c1tsYXN0XSk7DQogCQlwYWQgPSAqKHB0ciArIG9mZnNldCk7DQotCQlrdW5tYXBfYXRvbWljKHB0
ciwgS01fVVNFUjApOw0KKwkJa3VubWFwX2F0b21pYyhwdHIpOw0KIAkJZ290byBvdXQ7DQogCX0g
ZWxzZQ0KIAkJbGVuIC09IGJ1Zi0+cGFnZV9sZW47DQpkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9z
b2NrbGliLmMgYi9uZXQvc3VucnBjL3NvY2tsaWIuYw0KaW5kZXggMTQ1ZTY3ODQuLjBhNjQ4YzUg
MTAwNjQ0DQotLS0gYS9uZXQvc3VucnBjL3NvY2tsaWIuYw0KKysrIGIvbmV0L3N1bnJwYy9zb2Nr
bGliLmMNCkBAIC0xMTQsNyArMTE0LDcgQEAgc3NpemVfdCB4ZHJfcGFydGlhbF9jb3B5X2Zyb21f
c2tiKHN0cnVjdCB4ZHJfYnVmICp4ZHIsIHVuc2lnbmVkIGludCBiYXNlLCBzdHJ1Y3QNCiAJCX0N
CiANCiAJCWxlbiA9IFBBR0VfQ0FDSEVfU0laRTsNCi0JCWthZGRyID0ga21hcF9hdG9taWMoKnBw
YWdlLCBLTV9TS0JfU1VOUlBDX0RBVEEpOw0KKwkJa2FkZHIgPSBrbWFwX2F0b21pYygqcHBhZ2Up
Ow0KIAkJaWYgKGJhc2UpIHsNCiAJCQlsZW4gLT0gYmFzZTsNCiAJCQlpZiAocGdsZW4gPCBsZW4p
DQpAQCAtMTI3LDcgKzEyNyw3IEBAIHNzaXplX3QgeGRyX3BhcnRpYWxfY29weV9mcm9tX3NrYihz
dHJ1Y3QgeGRyX2J1ZiAqeGRyLCB1bnNpZ25lZCBpbnQgYmFzZSwgc3RydWN0DQogCQkJcmV0ID0g
Y29weV9hY3RvcihkZXNjLCBrYWRkciwgbGVuKTsNCiAJCX0NCiAJCWZsdXNoX2RjYWNoZV9wYWdl
KCpwcGFnZSk7DQotCQlrdW5tYXBfYXRvbWljKGthZGRyLCBLTV9TS0JfU1VOUlBDX0RBVEEpOw0K
KwkJa3VubWFwX2F0b21pYyhrYWRkcik7DQogCQljb3BpZWQgKz0gcmV0Ow0KIAkJaWYgKHJldCAh
PSBsZW4gfHwgIWRlc2MtPmNvdW50KQ0KIAkJCWdvdG8gb3V0Ow0KZGlmZiAtLWdpdCBhL25ldC9z
dW5ycGMveGRyLmMgYi9uZXQvc3VucnBjL3hkci5jDQppbmRleCA1OTNmNGM2Li42OTk3Y2RkIDEw
MDY0NA0KLS0tIGEvbmV0L3N1bnJwYy94ZHIuYw0KKysrIGIvbmV0L3N1bnJwYy94ZHIuYw0KQEAg
LTEyMiw5ICsxMjIsOSBAQCB4ZHJfdGVybWluYXRlX3N0cmluZyhzdHJ1Y3QgeGRyX2J1ZiAqYnVm
LCBjb25zdCB1MzIgbGVuKQ0KIHsNCiAJY2hhciAqa2FkZHI7DQogDQotCWthZGRyID0ga21hcF9h
dG9taWMoYnVmLT5wYWdlc1swXSwgS01fVVNFUjApOw0KKwlrYWRkciA9IGttYXBfYXRvbWljKGJ1
Zi0+cGFnZXNbMF0pOw0KIAlrYWRkcltidWYtPnBhZ2VfYmFzZSArIGxlbl0gPSAnXDAnOw0KLQlr
dW5tYXBfYXRvbWljKGthZGRyLCBLTV9VU0VSMCk7DQorCWt1bm1hcF9hdG9taWMoa2FkZHIpOw0K
IH0NCiBFWFBPUlRfU1lNQk9MX0dQTCh4ZHJfdGVybWluYXRlX3N0cmluZyk7DQogDQpAQCAtMjMy
LDEyICsyMzIsMTUgQEAgX3NoaWZ0X2RhdGFfcmlnaHRfcGFnZXMoc3RydWN0IHBhZ2UgKipwYWdl
cywgc2l6ZV90IHBndG9fYmFzZSwNCiAJCXBndG9fYmFzZSAtPSBjb3B5Ow0KIAkJcGdmcm9tX2Jh
c2UgLT0gY29weTsNCiANCi0JCXZ0byA9IGttYXBfYXRvbWljKCpwZ3RvLCBLTV9VU0VSMCk7DQot
CQl2ZnJvbSA9IGttYXBfYXRvbWljKCpwZ2Zyb20sIEtNX1VTRVIxKTsNCi0JCW1lbW1vdmUodnRv
ICsgcGd0b19iYXNlLCB2ZnJvbSArIHBnZnJvbV9iYXNlLCBjb3B5KTsNCisJCXZ0byA9IGttYXBf
YXRvbWljKCpwZ3RvKTsNCisJCWlmICgqcGd0byAhPSAqcGdmcm9tKSB7DQorCQkJdmZyb20gPSBr
bWFwX2F0b21pYygqcGdmcm9tKTsNCisJCQltZW1jcHkodnRvICsgcGd0b19iYXNlLCB2ZnJvbSAr
IHBnZnJvbV9iYXNlLCBjb3B5KTsNCisJCQlrdW5tYXBfYXRvbWljKHZmcm9tKTsNCisJCX0gZWxz
ZQ0KKwkJCW1lbW1vdmUodnRvICsgcGd0b19iYXNlLCB2dG8gKyBwZ2Zyb21fYmFzZSwgY29weSk7
DQogCQlmbHVzaF9kY2FjaGVfcGFnZSgqcGd0byk7DQotCQlrdW5tYXBfYXRvbWljKHZmcm9tLCBL
TV9VU0VSMSk7DQotCQlrdW5tYXBfYXRvbWljKHZ0bywgS01fVVNFUjApOw0KKwkJa3VubWFwX2F0
b21pYyh2dG8pOw0KIA0KIAl9IHdoaWxlICgobGVuIC09IGNvcHkpICE9IDApOw0KIH0NCkBAIC0y
NjcsOSArMjcwLDkgQEAgX2NvcHlfdG9fcGFnZXMoc3RydWN0IHBhZ2UgKipwYWdlcywgc2l6ZV90
IHBnYmFzZSwgY29uc3QgY2hhciAqcCwgc2l6ZV90IGxlbikNCiAJCWlmIChjb3B5ID4gbGVuKQ0K
IAkJCWNvcHkgPSBsZW47DQogDQotCQl2dG8gPSBrbWFwX2F0b21pYygqcGd0bywgS01fVVNFUjAp
Ow0KKwkJdnRvID0ga21hcF9hdG9taWMoKnBndG8pOw0KIAkJbWVtY3B5KHZ0byArIHBnYmFzZSwg
cCwgY29weSk7DQotCQlrdW5tYXBfYXRvbWljKHZ0bywgS01fVVNFUjApOw0KKwkJa3VubWFwX2F0
b21pYyh2dG8pOw0KIA0KIAkJbGVuIC09IGNvcHk7DQogCQlpZiAobGVuID09IDApDQpAQCAtMzEx
LDkgKzMxNCw5IEBAIF9jb3B5X2Zyb21fcGFnZXMoY2hhciAqcCwgc3RydWN0IHBhZ2UgKipwYWdl
cywgc2l6ZV90IHBnYmFzZSwgc2l6ZV90IGxlbikNCiAJCWlmIChjb3B5ID4gbGVuKQ0KIAkJCWNv
cHkgPSBsZW47DQogDQotCQl2ZnJvbSA9IGttYXBfYXRvbWljKCpwZ2Zyb20sIEtNX1VTRVIwKTsN
CisJCXZmcm9tID0ga21hcF9hdG9taWMoKnBnZnJvbSk7DQogCQltZW1jcHkocCwgdmZyb20gKyBw
Z2Jhc2UsIGNvcHkpOw0KLQkJa3VubWFwX2F0b21pYyh2ZnJvbSwgS01fVVNFUjApOw0KKwkJa3Vu
bWFwX2F0b21pYyh2ZnJvbSk7DQogDQogCQlwZ2Jhc2UgKz0gY29weTsNCiAJCWlmIChwZ2Jhc2Ug
PT0gUEFHRV9DQUNIRV9TSVpFKSB7DQpkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy94cHJ0cmRtYS9y
cGNfcmRtYS5jIGIvbmV0L3N1bnJwYy94cHJ0cmRtYS9ycGNfcmRtYS5jDQppbmRleCA1NTRkMDgx
Li4xNzc2ZTU3IDEwMDY0NA0KLS0tIGEvbmV0L3N1bnJwYy94cHJ0cmRtYS9ycGNfcmRtYS5jDQor
KysgYi9uZXQvc3VucnBjL3hwcnRyZG1hL3JwY19yZG1hLmMNCkBAIC0zMzgsOSArMzM4LDkgQEAg
cnBjcmRtYV9pbmxpbmVfcHVsbHVwKHN0cnVjdCBycGNfcnFzdCAqcnFzdCwgaW50IHBhZCkNCiAJ
CQljdXJsZW4gPSBjb3B5X2xlbjsNCiAJCWRwcmludGsoIlJQQzogICAgICAgJXM6IHBhZ2UgJWQg
ZGVzdHAgMHglcCBsZW4gJWQgY3VybGVuICVkXG4iLA0KIAkJCV9fZnVuY19fLCBpLCBkZXN0cCwg
Y29weV9sZW4sIGN1cmxlbik7DQotCQlzcmNwID0ga21hcF9hdG9taWMocHBhZ2VzW2ldLCBLTV9T
S0JfU1VOUlBDX0RBVEEpOw0KKwkJc3JjcCA9IGttYXBfYXRvbWljKHBwYWdlc1tpXSk7DQogCQlt
ZW1jcHkoZGVzdHAsIHNyY3ArcGFnZV9iYXNlLCBjdXJsZW4pOw0KLQkJa3VubWFwX2F0b21pYyhz
cmNwLCBLTV9TS0JfU1VOUlBDX0RBVEEpOw0KKwkJa3VubWFwX2F0b21pYyhzcmNwKTsNCiAJCXJx
c3QtPnJxX3N2ZWNbMF0uaW92X2xlbiArPSBjdXJsZW47DQogCQlkZXN0cCArPSBjdXJsZW47DQog
CQljb3B5X2xlbiAtPSBjdXJsZW47DQpAQCAtNjM5LDEwICs2MzksMTAgQEAgcnBjcmRtYV9pbmxp
bmVfZml4dXAoc3RydWN0IHJwY19ycXN0ICpycXN0LCBjaGFyICpzcmNwLCBpbnQgY29weV9sZW4s
IGludCBwYWQpDQogCQkJZHByaW50aygiUlBDOiAgICAgICAlczogcGFnZSAlZCINCiAJCQkJIiBz
cmNwIDB4JXAgbGVuICVkIGN1cmxlbiAlZFxuIiwNCiAJCQkJX19mdW5jX18sIGksIHNyY3AsIGNv
cHlfbGVuLCBjdXJsZW4pOw0KLQkJCWRlc3RwID0ga21hcF9hdG9taWMocHBhZ2VzW2ldLCBLTV9T
S0JfU1VOUlBDX0RBVEEpOw0KKwkJCWRlc3RwID0ga21hcF9hdG9taWMocHBhZ2VzW2ldKTsNCiAJ
CQltZW1jcHkoZGVzdHAgKyBwYWdlX2Jhc2UsIHNyY3AsIGN1cmxlbik7DQogCQkJZmx1c2hfZGNh
Y2hlX3BhZ2UocHBhZ2VzW2ldKTsNCi0JCQlrdW5tYXBfYXRvbWljKGRlc3RwLCBLTV9TS0JfU1VO
UlBDX0RBVEEpOw0KKwkJCWt1bm1hcF9hdG9taWMoZGVzdHApOw0KIAkJCXNyY3AgKz0gY3VybGVu
Ow0KIAkJCWNvcHlfbGVuIC09IGN1cmxlbjsNCiAJCQlpZiAoY29weV9sZW4gPT0gMCkNCmRpZmYg
LS1naXQgYS9uZXQvd2lyZWxlc3Mvbmw4MDIxMS5jIGIvbmV0L3dpcmVsZXNzL25sODAyMTEuYw0K
aW5kZXggYzA2YzM2NS4uNmQ0ZDI2MyAxMDA2NDQNCi0tLSBhL25ldC93aXJlbGVzcy9ubDgwMjEx
LmMNCisrKyBiL25ldC93aXJlbGVzcy9ubDgwMjExLmMNCkBAIC00ODI2LDEyICs0ODI2LDE0IEBA
IEVYUE9SVF9TWU1CT0woY2ZnODAyMTFfdGVzdG1vZGVfYWxsb2NfZXZlbnRfc2tiKTsNCiANCiB2
b2lkIGNmZzgwMjExX3Rlc3Rtb2RlX2V2ZW50KHN0cnVjdCBza19idWZmICpza2IsIGdmcF90IGdm
cCkNCiB7DQorCXN0cnVjdCBjZmc4MDIxMV9yZWdpc3RlcmVkX2RldmljZSAqcmRldiA9ICgodm9p
ZCAqKilza2ItPmNiKVswXTsNCiAJdm9pZCAqaGRyID0gKCh2b2lkICoqKXNrYi0+Y2IpWzFdOw0K
IAlzdHJ1Y3QgbmxhdHRyICpkYXRhID0gKCh2b2lkICoqKXNrYi0+Y2IpWzJdOw0KIA0KIAlubGFf
bmVzdF9lbmQoc2tiLCBkYXRhKTsNCiAJZ2VubG1zZ19lbmQoc2tiLCBoZHIpOw0KLQlnZW5sbXNn
X211bHRpY2FzdChza2IsIDAsIG5sODAyMTFfdGVzdG1vZGVfbWNncnAuaWQsIGdmcCk7DQorCWdl
bmxtc2dfbXVsdGljYXN0X25ldG5zKHdpcGh5X25ldCgmcmRldi0+d2lwaHkpLCBza2IsIDAsDQor
CQkJCW5sODAyMTFfdGVzdG1vZGVfbWNncnAuaWQsIGdmcCk7DQogfQ0KIEVYUE9SVF9TWU1CT0wo
Y2ZnODAyMTFfdGVzdG1vZGVfZXZlbnQpOw0KICNlbmRpZg0KQEAgLTcyODIsNyArNzI4NCw4IEBA
IHZvaWQgbmw4MDIxMV9zZW5kX21nbXRfdHhfc3RhdHVzKHN0cnVjdCBjZmc4MDIxMV9yZWdpc3Rl
cmVkX2RldmljZSAqcmRldiwNCiAJCXJldHVybjsNCiAJfQ0KIA0KLQlnZW5sbXNnX211bHRpY2Fz
dChtc2csIDAsIG5sODAyMTFfbWxtZV9tY2dycC5pZCwgZ2ZwKTsNCisJZ2VubG1zZ19tdWx0aWNh
c3RfbmV0bnMod2lwaHlfbmV0KCZyZGV2LT53aXBoeSksIG1zZywgMCwNCisJCQkJbmw4MDIxMV9t
bG1lX21jZ3JwLmlkLCBnZnApOw0KIAlyZXR1cm47DQogDQogIG5sYV9wdXRfZmFpbHVyZToNCmRp
ZmYgLS1naXQgYS9zb3VuZC9pMmMvb3RoZXIvYWs0eHh4LWFkZGEuYyBiL3NvdW5kL2kyYy9vdGhl
ci9hazR4eHgtYWRkYS5jDQppbmRleCBjZWY4MTNkLi5lZDcyNmQxIDEwMDY0NA0KLS0tIGEvc291
bmQvaTJjL290aGVyL2FrNHh4eC1hZGRhLmMNCisrKyBiL3NvdW5kL2kyYy9vdGhlci9hazR4eHgt
YWRkYS5jDQpAQCAtNTcxLDcgKzU3MSw3IEBAIHN0YXRpYyBpbnQgYWs0eHh4X2NhcHR1cmVfc291
cmNlX2luZm8oc3RydWN0IHNuZF9rY29udHJvbCAqa2NvbnRyb2wsDQogCXN0cnVjdCBzbmRfYWtt
NHh4eCAqYWsgPSBzbmRfa2NvbnRyb2xfY2hpcChrY29udHJvbCk7DQogCWludCBtaXhlcl9jaCA9
IEFLX0dFVF9TSElGVChrY29udHJvbC0+cHJpdmF0ZV92YWx1ZSk7DQogCWNvbnN0IGNoYXIgKipp
bnB1dF9uYW1lczsNCi0JaW50ICBudW1fbmFtZXMsIGlkeDsNCisJdW5zaWduZWQgaW50IG51bV9u
YW1lcywgaWR4Ow0KIA0KIAludW1fbmFtZXMgPSBhazR4eHhfY2FwdHVyZV9udW1faW5wdXRzKGFr
LCBtaXhlcl9jaCk7DQogCWlmICghbnVtX25hbWVzKQ0KZGlmZiAtLWdpdCBhL3NvdW5kL2lzYS9v
cHRpOXh4L29wdGk5MngtYWQxODQ4LmMgYi9zb3VuZC9pc2Evb3B0aTl4eC9vcHRpOTJ4LWFkMTg0
OC5jDQppbmRleCA5Nzg3MWJlLi5jYmE4NGVmIDEwMDY0NA0KLS0tIGEvc291bmQvaXNhL29wdGk5
eHgvb3B0aTkyeC1hZDE4NDguYw0KKysrIGIvc291bmQvaXNhL29wdGk5eHgvb3B0aTkyeC1hZDE4
NDguYw0KQEAgLTE3MywxMSArMTczLDcgQEAgTU9EVUxFX0RFVklDRV9UQUJMRShwbnBfY2FyZCwg
c25kX29wdGk5eHhfcG5waWRzKTsNCiANCiAjZW5kaWYJLyogQ09ORklHX1BOUCAqLw0KIA0KLSNp
ZmRlZiBPUFRpOTNYDQotI2RlZmluZSBERVZfTkFNRSAib3B0aTkzeCINCi0jZWxzZQ0KLSNkZWZp
bmUgREVWX05BTUUgIm9wdGk5MngiDQotI2VuZGlmDQorI2RlZmluZSBERVZfTkFNRSBLQlVJTERf
TU9ETkFNRQ0KIA0KIHN0YXRpYyBjaGFyICogc25kX29wdGk5eHhfbmFtZXNbXSA9IHsNCiAJInVu
a25vd24iLA0KQEAgLTExMjYsNyArMTEyMiw3IEBAIHN0YXRpYyB2b2lkIF9fZGV2ZXhpdCBzbmRf
b3B0aTl4eF9wbnBfcmVtb3ZlKHN0cnVjdCBwbnBfY2FyZF9saW5rICogcGNhcmQpDQogDQogc3Rh
dGljIHN0cnVjdCBwbnBfY2FyZF9kcml2ZXIgb3B0aTl4eF9wbnBjX2RyaXZlciA9IHsNCiAJLmZs
YWdzCQk9IFBOUF9EUklWRVJfUkVTX0RJU0FCTEUsDQotCS5uYW1lCQk9ICJvcHRpOXh4IiwNCisJ
Lm5hbWUJCT0gREVWX05BTUUsDQogCS5pZF90YWJsZQk9IHNuZF9vcHRpOXh4X3BucGlkcywNCiAJ
LnByb2JlCQk9IHNuZF9vcHRpOXh4X3BucF9wcm9iZSwNCiAJLnJlbW92ZQkJPSBfX2RldmV4aXRf
cChzbmRfb3B0aTl4eF9wbnBfcmVtb3ZlKSwNCmRpZmYgLS1naXQgYS9zb3VuZC9vc3MvS2NvbmZp
ZyBiL3NvdW5kL29zcy9LY29uZmlnDQppbmRleCA2YzllOGU4Li4xZmMyOGY1IDEwMDY0NA0KLS0t
IGEvc291bmQvb3NzL0tjb25maWcNCisrKyBiL3NvdW5kL29zcy9LY29uZmlnDQpAQCAtMjUwLDYg
KzI1MCw3IEBAIGNvbmZpZyBNU05EX0ZJRk9TSVpFDQogbWVudWNvbmZpZyBTT1VORF9PU1MNCiAJ
dHJpc3RhdGUgIk9TUyBzb3VuZCBtb2R1bGVzIg0KIAlkZXBlbmRzIG9uIElTQV9ETUFfQVBJICYm
IFZJUlRfVE9fQlVTDQorCWRlcGVuZHMgb24gIUdFTkVSSUNfSVNBX0RNQV9TVVBQT1JUX0JST0tF
Tg0KIAloZWxwDQogCSAgT1NTIGlzIHRoZSBPcGVuIFNvdW5kIFN5c3RlbSBzdWl0ZSBvZiBzb3Vu
ZCBjYXJkIGRyaXZlcnMuICBUaGV5IG1ha2UNCiAJICBzb3VuZCBwcm9ncmFtbWluZyBlYXNpZXIg
c2luY2UgdGhleSBwcm92aWRlIGEgY29tbW9uIEFQSS4gIFNheSBZIG9yDQpkaWZmIC0tZ2l0IGEv
c291bmQvdXNiLzZmaXJlL2NvbW0uYyBiL3NvdW5kL3VzYi82ZmlyZS9jb21tLmMNCmluZGV4IGM5
OTRkYWEuLmFmNmVjOGQgMTAwNjQ0DQotLS0gYS9zb3VuZC91c2IvNmZpcmUvY29tbS5jDQorKysg
Yi9zb3VuZC91c2IvNmZpcmUvY29tbS5jDQpAQCAtMTExLDE5ICsxMTEsMzcgQEAgc3RhdGljIGlu
dCB1c2I2ZmlyZV9jb21tX3NlbmRfYnVmZmVyKHU4ICpidWZmZXIsIHN0cnVjdCB1c2JfZGV2aWNl
ICpkZXYpDQogc3RhdGljIGludCB1c2I2ZmlyZV9jb21tX3dyaXRlOChzdHJ1Y3QgY29tbV9ydW50
aW1lICpydCwgdTggcmVxdWVzdCwNCiAJCXU4IHJlZywgdTggdmFsdWUpDQogew0KLQl1OCBidWZm
ZXJbMTNdOyAvKiAxMzogbWF4aW11bSBsZW5ndGggb2YgbWVzc2FnZSAqLw0KKwl1OCAqYnVmZmVy
Ow0KKwlpbnQgcmV0Ow0KKw0KKwkvKiAxMzogbWF4aW11bSBsZW5ndGggb2YgbWVzc2FnZSAqLw0K
KwlidWZmZXIgPSBrbWFsbG9jKDEzLCBHRlBfS0VSTkVMKTsNCisJaWYgKCFidWZmZXIpDQorCQly
ZXR1cm4gLUVOT01FTTsNCiANCiAJdXNiNmZpcmVfY29tbV9pbml0X2J1ZmZlcihidWZmZXIsIDB4
MDAsIHJlcXVlc3QsIHJlZywgdmFsdWUsIDB4MDApOw0KLQlyZXR1cm4gdXNiNmZpcmVfY29tbV9z
ZW5kX2J1ZmZlcihidWZmZXIsIHJ0LT5jaGlwLT5kZXYpOw0KKwlyZXQgPSB1c2I2ZmlyZV9jb21t
X3NlbmRfYnVmZmVyKGJ1ZmZlciwgcnQtPmNoaXAtPmRldik7DQorDQorCWtmcmVlKGJ1ZmZlcik7
DQorCXJldHVybiByZXQ7DQogfQ0KIA0KIHN0YXRpYyBpbnQgdXNiNmZpcmVfY29tbV93cml0ZTE2
KHN0cnVjdCBjb21tX3J1bnRpbWUgKnJ0LCB1OCByZXF1ZXN0LA0KIAkJdTggcmVnLCB1OCB2bCwg
dTggdmgpDQogew0KLQl1OCBidWZmZXJbMTNdOyAvKiAxMzogbWF4aW11bSBsZW5ndGggb2YgbWVz
c2FnZSAqLw0KKwl1OCAqYnVmZmVyOw0KKwlpbnQgcmV0Ow0KKw0KKwkvKiAxMzogbWF4aW11bSBs
ZW5ndGggb2YgbWVzc2FnZSAqLw0KKwlidWZmZXIgPSBrbWFsbG9jKDEzLCBHRlBfS0VSTkVMKTsN
CisJaWYgKCFidWZmZXIpDQorCQlyZXR1cm4gLUVOT01FTTsNCiANCiAJdXNiNmZpcmVfY29tbV9p
bml0X2J1ZmZlcihidWZmZXIsIDB4MDAsIHJlcXVlc3QsIHJlZywgdmwsIHZoKTsNCi0JcmV0dXJu
IHVzYjZmaXJlX2NvbW1fc2VuZF9idWZmZXIoYnVmZmVyLCBydC0+Y2hpcC0+ZGV2KTsNCisJcmV0
ID0gdXNiNmZpcmVfY29tbV9zZW5kX2J1ZmZlcihidWZmZXIsIHJ0LT5jaGlwLT5kZXYpOw0KKw0K
KwlrZnJlZShidWZmZXIpOw0KKwlyZXR1cm4gcmV0Ow0KIH0NCiANCiBpbnQgX19kZXZpbml0IHVz
YjZmaXJlX2NvbW1faW5pdChzdHJ1Y3Qgc2ZpcmVfY2hpcCAqY2hpcCkNCkBAIC0xMzYsNiArMTU0
LDEyIEBAIGludCBfX2RldmluaXQgdXNiNmZpcmVfY29tbV9pbml0KHN0cnVjdCBzZmlyZV9jaGlw
ICpjaGlwKQ0KIAlpZiAoIXJ0KQ0KIAkJcmV0dXJuIC1FTk9NRU07DQogDQorCXJ0LT5yZWNlaXZl
cl9idWZmZXIgPSBremFsbG9jKENPTU1fUkVDRUlWRVJfQlVGU0laRSwgR0ZQX0tFUk5FTCk7DQor
CWlmICghcnQtPnJlY2VpdmVyX2J1ZmZlcikgew0KKwkJa2ZyZWUocnQpOw0KKwkJcmV0dXJuIC1F
Tk9NRU07DQorCX0NCisNCiAJcnQtPnNlcmlhbCA9IDE7DQogCXJ0LT5jaGlwID0gY2hpcDsNCiAJ
dXNiX2luaXRfdXJiKHVyYik7DQpAQCAtMTUzLDYgKzE3Nyw3IEBAIGludCBfX2RldmluaXQgdXNi
NmZpcmVfY29tbV9pbml0KHN0cnVjdCBzZmlyZV9jaGlwICpjaGlwKQ0KIAl1cmItPmludGVydmFs
ID0gMTsNCiAJcmV0ID0gdXNiX3N1Ym1pdF91cmIodXJiLCBHRlBfS0VSTkVMKTsNCiAJaWYgKHJl
dCA8IDApIHsNCisJCWtmcmVlKHJ0LT5yZWNlaXZlcl9idWZmZXIpOw0KIAkJa2ZyZWUocnQpOw0K
IAkJc25kX3ByaW50ayhLRVJOX0VSUiBQUkVGSVggImNhbm5vdCBjcmVhdGUgY29tbSBkYXRhIHJl
Y2VpdmVyLiIpOw0KIAkJcmV0dXJuIHJldDsNCkBAIC0xNzEsNiArMTk2LDkgQEAgdm9pZCB1c2I2
ZmlyZV9jb21tX2Fib3J0KHN0cnVjdCBzZmlyZV9jaGlwICpjaGlwKQ0KIA0KIHZvaWQgdXNiNmZp
cmVfY29tbV9kZXN0cm95KHN0cnVjdCBzZmlyZV9jaGlwICpjaGlwKQ0KIHsNCi0Ja2ZyZWUoY2hp
cC0+Y29tbSk7DQorCXN0cnVjdCBjb21tX3J1bnRpbWUgKnJ0ID0gY2hpcC0+Y29tbTsNCisNCisJ
a2ZyZWUocnQtPnJlY2VpdmVyX2J1ZmZlcik7DQorCWtmcmVlKHJ0KTsNCiAJY2hpcC0+Y29tbSA9
IE5VTEw7DQogfQ0KZGlmZiAtLWdpdCBhL3NvdW5kL3VzYi82ZmlyZS9jb21tLmggYi9zb3VuZC91
c2IvNmZpcmUvY29tbS5oDQppbmRleCBlZGM1ZGM4Li4xOWUyZjkyIDEwMDY0NA0KLS0tIGEvc291
bmQvdXNiLzZmaXJlL2NvbW0uaA0KKysrIGIvc291bmQvdXNiLzZmaXJlL2NvbW0uaA0KQEAgLTI1
LDcgKzI1LDcgQEAgc3RydWN0IGNvbW1fcnVudGltZSB7DQogCXN0cnVjdCBzZmlyZV9jaGlwICpj
aGlwOw0KIA0KIAlzdHJ1Y3QgdXJiIHJlY2VpdmVyOw0KLQl1OCByZWNlaXZlcl9idWZmZXJbQ09N
TV9SRUNFSVZFUl9CVUZTSVpFXTsNCisJdTggKnJlY2VpdmVyX2J1ZmZlcjsNCiANCiAJdTggc2Vy
aWFsOyAvKiB1cmIgc2VyaWFsICovDQogDQpkaWZmIC0tZ2l0IGEvc291bmQvdXNiLzZmaXJlL21p
ZGkuYyBiL3NvdW5kL3VzYi82ZmlyZS9taWRpLmMNCmluZGV4IDEzZjQ1MDkuLjgyODNjNWQgMTAw
NjQ0DQotLS0gYS9zb3VuZC91c2IvNmZpcmUvbWlkaS5jDQorKysgYi9zb3VuZC91c2IvNmZpcmUv
bWlkaS5jDQpAQCAtMjAsNiArMjAsMTAgQEANCiAjaW5jbHVkZSAiY2hpcC5oIg0KICNpbmNsdWRl
ICJjb21tLmgiDQogDQorZW51bSB7DQorCU1JRElfQlVGU0laRSA9IDY0DQorfTsNCisNCiBzdGF0
aWMgdm9pZCB1c2I2ZmlyZV9taWRpX291dF9oYW5kbGVyKHN0cnVjdCB1cmIgKnVyYikNCiB7DQog
CXN0cnVjdCBtaWRpX3J1bnRpbWUgKnJ0ID0gdXJiLT5jb250ZXh0Ow0KQEAgLTE1Nyw2ICsxNjEs
MTIgQEAgaW50IF9fZGV2aW5pdCB1c2I2ZmlyZV9taWRpX2luaXQoc3RydWN0IHNmaXJlX2NoaXAg
KmNoaXApDQogCWlmICghcnQpDQogCQlyZXR1cm4gLUVOT01FTTsNCiANCisJcnQtPm91dF9idWZm
ZXIgPSBremFsbG9jKE1JRElfQlVGU0laRSwgR0ZQX0tFUk5FTCk7DQorCWlmICghcnQtPm91dF9i
dWZmZXIpIHsNCisJCWtmcmVlKHJ0KTsNCisJCXJldHVybiAtRU5PTUVNOw0KKwl9DQorDQogCXJ0
LT5jaGlwID0gY2hpcDsNCiAJcnQtPmluX3JlY2VpdmVkID0gdXNiNmZpcmVfbWlkaV9pbl9yZWNl
aXZlZDsNCiAJcnQtPm91dF9idWZmZXJbMF0gPSAweDgwOyAvKiAnc2VuZCBtaWRpJyBjb21tYW5k
ICovDQpAQCAtMTcwLDYgKzE4MCw3IEBAIGludCBfX2RldmluaXQgdXNiNmZpcmVfbWlkaV9pbml0
KHN0cnVjdCBzZmlyZV9jaGlwICpjaGlwKQ0KIA0KIAlyZXQgPSBzbmRfcmF3bWlkaV9uZXcoY2hp
cC0+Y2FyZCwgIjZGaXJlVVNCIiwgMCwgMSwgMSwgJnJ0LT5pbnN0YW5jZSk7DQogCWlmIChyZXQg
PCAwKSB7DQorCQlrZnJlZShydC0+b3V0X2J1ZmZlcik7DQogCQlrZnJlZShydCk7DQogCQlzbmRf
cHJpbnRrKEtFUk5fRVJSIFBSRUZJWCAidW5hYmxlIHRvIGNyZWF0ZSBtaWRpLlxuIik7DQogCQly
ZXR1cm4gcmV0Ow0KQEAgLTE5OCw2ICsyMDksOSBAQCB2b2lkIHVzYjZmaXJlX21pZGlfYWJvcnQo
c3RydWN0IHNmaXJlX2NoaXAgKmNoaXApDQogDQogdm9pZCB1c2I2ZmlyZV9taWRpX2Rlc3Ryb3ko
c3RydWN0IHNmaXJlX2NoaXAgKmNoaXApDQogew0KLQlrZnJlZShjaGlwLT5taWRpKTsNCisJc3Ry
dWN0IG1pZGlfcnVudGltZSAqcnQgPSBjaGlwLT5taWRpOw0KKw0KKwlrZnJlZShydC0+b3V0X2J1
ZmZlcik7DQorCWtmcmVlKHJ0KTsNCiAJY2hpcC0+bWlkaSA9IE5VTEw7DQogfQ0KZGlmZiAtLWdp
dCBhL3NvdW5kL3VzYi82ZmlyZS9taWRpLmggYi9zb3VuZC91c2IvNmZpcmUvbWlkaS5oDQppbmRl
eCA5N2E3YmY2Li43ZjhmNDQ4IDEwMDY0NA0KLS0tIGEvc291bmQvdXNiLzZmaXJlL21pZGkuaA0K
KysrIGIvc291bmQvdXNiLzZmaXJlL21pZGkuaA0KQEAgLTE3LDEwICsxNyw2IEBADQogDQogI2lu
Y2x1ZGUgImNvbW1vbi5oIg0KIA0KLWVudW0gew0KLQlNSURJX0JVRlNJWkUgPSA2NA0KLX07DQot
DQogc3RydWN0IG1pZGlfcnVudGltZSB7DQogCXN0cnVjdCBzZmlyZV9jaGlwICpjaGlwOw0KIAlz
dHJ1Y3Qgc25kX3Jhd21pZGkgKmluc3RhbmNlOw0KQEAgLTMzLDcgKzI5LDcgQEAgc3RydWN0IG1p
ZGlfcnVudGltZSB7DQogCXN0cnVjdCBzbmRfcmF3bWlkaV9zdWJzdHJlYW0gKm91dDsNCiAJc3Ry
dWN0IHVyYiBvdXRfdXJiOw0KIAl1OCBvdXRfc2VyaWFsOyAvKiBzZXJpYWwgbnVtYmVyIG9mIG91
dCBwYWNrZXQgKi8NCi0JdTggb3V0X2J1ZmZlcltNSURJX0JVRlNJWkVdOw0KKwl1OCAqb3V0X2J1
ZmZlcjsNCiAJaW50IGJ1ZmZlcl9vZmZzZXQ7DQogDQogCXZvaWQgKCppbl9yZWNlaXZlZCkoc3Ry
dWN0IG1pZGlfcnVudGltZSAqcnQsIHU4ICpkYXRhLCBpbnQgbGVuZ3RoKTsNCmRpZmYgLS1naXQg
YS9zb3VuZC91c2IvNmZpcmUvcGNtLmMgYi9zb3VuZC91c2IvNmZpcmUvcGNtLmMNCmluZGV4IDg4
OGE3YzcuLjg2MDljNzQgMTAwNjQ0DQotLS0gYS9zb3VuZC91c2IvNmZpcmUvcGNtLmMNCisrKyBi
L3NvdW5kL3VzYi82ZmlyZS9wY20uYw0KQEAgLTU3OSw2ICs1NzksMzMgQEAgc3RhdGljIHZvaWQg
X19kZXZpbml0IHVzYjZmaXJlX3BjbV9pbml0X3VyYihzdHJ1Y3QgcGNtX3VyYiAqdXJiLA0KIAl1
cmItPmluc3RhbmNlLm51bWJlcl9vZl9wYWNrZXRzID0gUENNX05fUEFDS0VUU19QRVJfVVJCOw0K
IH0NCiANCitzdGF0aWMgaW50IHVzYjZmaXJlX3BjbV9idWZmZXJzX2luaXQoc3RydWN0IHBjbV9y
dW50aW1lICpydCkNCit7DQorCWludCBpOw0KKw0KKwlmb3IgKGkgPSAwOyBpIDwgUENNX05fVVJC
UzsgaSsrKSB7DQorCQlydC0+b3V0X3VyYnNbaV0uYnVmZmVyID0ga3phbGxvYyhQQ01fTl9QQUNL
RVRTX1BFUl9VUkINCisJCQkJKiBQQ01fTUFYX1BBQ0tFVF9TSVpFLCBHRlBfS0VSTkVMKTsNCisJ
CWlmICghcnQtPm91dF91cmJzW2ldLmJ1ZmZlcikNCisJCQlyZXR1cm4gLUVOT01FTTsNCisJCXJ0
LT5pbl91cmJzW2ldLmJ1ZmZlciA9IGt6YWxsb2MoUENNX05fUEFDS0VUU19QRVJfVVJCDQorCQkJ
CSogUENNX01BWF9QQUNLRVRfU0laRSwgR0ZQX0tFUk5FTCk7DQorCQlpZiAoIXJ0LT5pbl91cmJz
W2ldLmJ1ZmZlcikNCisJCQlyZXR1cm4gLUVOT01FTTsNCisJfQ0KKwlyZXR1cm4gMDsNCit9DQor
DQorc3RhdGljIHZvaWQgdXNiNmZpcmVfcGNtX2J1ZmZlcnNfZGVzdHJveShzdHJ1Y3QgcGNtX3J1
bnRpbWUgKnJ0KQ0KK3sNCisJaW50IGk7DQorDQorCWZvciAoaSA9IDA7IGkgPCBQQ01fTl9VUkJT
OyBpKyspIHsNCisJCWtmcmVlKHJ0LT5vdXRfdXJic1tpXS5idWZmZXIpOw0KKwkJa2ZyZWUocnQt
PmluX3VyYnNbaV0uYnVmZmVyKTsNCisJfQ0KK30NCisNCiBpbnQgX19kZXZpbml0IHVzYjZmaXJl
X3BjbV9pbml0KHN0cnVjdCBzZmlyZV9jaGlwICpjaGlwKQ0KIHsNCiAJaW50IGk7DQpAQCAtNTkw
LDYgKzYxNywxMyBAQCBpbnQgX19kZXZpbml0IHVzYjZmaXJlX3BjbV9pbml0KHN0cnVjdCBzZmly
ZV9jaGlwICpjaGlwKQ0KIAlpZiAoIXJ0KQ0KIAkJcmV0dXJuIC1FTk9NRU07DQogDQorCXJldCA9
IHVzYjZmaXJlX3BjbV9idWZmZXJzX2luaXQocnQpOw0KKwlpZiAocmV0KSB7DQorCQl1c2I2Zmly
ZV9wY21fYnVmZmVyc19kZXN0cm95KHJ0KTsNCisJCWtmcmVlKHJ0KTsNCisJCXJldHVybiByZXQ7
DQorCX0NCisNCiAJcnQtPmNoaXAgPSBjaGlwOw0KIAlydC0+c3RyZWFtX3N0YXRlID0gU1RSRUFN
X0RJU0FCTEVEOw0KIAlydC0+cmF0ZSA9IEFSUkFZX1NJWkUocmF0ZXMpOw0KQEAgLTYxMSw2ICs2
NDUsNyBAQCBpbnQgX19kZXZpbml0IHVzYjZmaXJlX3BjbV9pbml0KHN0cnVjdCBzZmlyZV9jaGlw
ICpjaGlwKQ0KIA0KIAlyZXQgPSBzbmRfcGNtX25ldyhjaGlwLT5jYXJkLCAiRE1YNkZpcmVVU0Ii
LCAwLCAxLCAxLCAmcGNtKTsNCiAJaWYgKHJldCA8IDApIHsNCisJCXVzYjZmaXJlX3BjbV9idWZm
ZXJzX2Rlc3Ryb3kocnQpOw0KIAkJa2ZyZWUocnQpOw0KIAkJc25kX3ByaW50ayhLRVJOX0VSUiBQ
UkVGSVggImNhbm5vdCBjcmVhdGUgcGNtIGluc3RhbmNlLlxuIik7DQogCQlyZXR1cm4gcmV0Ow0K
QEAgLTYyNiw2ICs2NjEsNyBAQCBpbnQgX19kZXZpbml0IHVzYjZmaXJlX3BjbV9pbml0KHN0cnVj
dCBzZmlyZV9jaGlwICpjaGlwKQ0KIAkJCXNuZF9kbWFfY29udGludW91c19kYXRhKEdGUF9LRVJO
RUwpLA0KIAkJCU1BWF9CVUZTSVpFLCBNQVhfQlVGU0laRSk7DQogCWlmIChyZXQpIHsNCisJCXVz
YjZmaXJlX3BjbV9idWZmZXJzX2Rlc3Ryb3kocnQpOw0KIAkJa2ZyZWUocnQpOw0KIAkJc25kX3By
aW50ayhLRVJOX0VSUiBQUkVGSVgNCiAJCQkJImVycm9yIHByZWFsbG9jYXRpbmcgcGNtIGJ1ZmZl
cnMuXG4iKTsNCkBAIC02NzAsNiArNzA2LDkgQEAgdm9pZCB1c2I2ZmlyZV9wY21fYWJvcnQoc3Ry
dWN0IHNmaXJlX2NoaXAgKmNoaXApDQogDQogdm9pZCB1c2I2ZmlyZV9wY21fZGVzdHJveShzdHJ1
Y3Qgc2ZpcmVfY2hpcCAqY2hpcCkNCiB7DQotCWtmcmVlKGNoaXAtPnBjbSk7DQorCXN0cnVjdCBw
Y21fcnVudGltZSAqcnQgPSBjaGlwLT5wY207DQorDQorCXVzYjZmaXJlX3BjbV9idWZmZXJzX2Rl
c3Ryb3kocnQpOw0KKwlrZnJlZShydCk7DQogCWNoaXAtPnBjbSA9IE5VTEw7DQogfQ0KZGlmZiAt
LWdpdCBhL3NvdW5kL3VzYi82ZmlyZS9wY20uaCBiL3NvdW5kL3VzYi82ZmlyZS9wY20uaA0KaW5k
ZXggMmJlZTgxMy4uYThlODg5OSAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi82ZmlyZS9wY20uaA0K
KysrIGIvc291bmQvdXNiLzZmaXJlL3BjbS5oDQpAQCAtMzMsNyArMzMsNyBAQCBzdHJ1Y3QgcGNt
X3VyYiB7DQogCXN0cnVjdCB1cmIgaW5zdGFuY2U7DQogCXN0cnVjdCB1c2JfaXNvX3BhY2tldF9k
ZXNjcmlwdG9yIHBhY2tldHNbUENNX05fUEFDS0VUU19QRVJfVVJCXTsNCiAJLyogRU5EIERPIE5P
VCBTRVBBUkFURSAqLw0KLQl1OCBidWZmZXJbUENNX05fUEFDS0VUU19QRVJfVVJCICogUENNX01B
WF9QQUNLRVRfU0laRV07DQorCXU4ICpidWZmZXI7DQogDQogCXN0cnVjdCBwY21fdXJiICpwZWVy
Ow0KIH07DQpkaWZmIC0tZ2l0IGEvc291bmQvdXNiL21peGVyLmMgYi9zb3VuZC91c2IvbWl4ZXIu
Yw0KaW5kZXggYWViMjZlYi4uNDFiOWZlMCAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi9taXhlci5j
DQorKysgYi9zb3VuZC91c2IvbWl4ZXIuYw0KQEAgLTcyMCw4ICs3MjAsMjAgQEAgc3RhdGljIGlu
dCBjaGVja19pbnB1dF90ZXJtKHN0cnVjdCBtaXhlcl9idWlsZCAqc3RhdGUsIGludCBpZCwgc3Ry
dWN0IHVzYl9hdWRpb18NCiAJCQlyZXR1cm4gMDsNCiAJCX0NCiAJCWNhc2UgVUFDMV9QUk9DRVNT
SU5HX1VOSVQ6DQotCQljYXNlIFVBQzFfRVhURU5TSU9OX1VOSVQ6IHsNCisJCWNhc2UgVUFDMV9F
WFRFTlNJT05fVU5JVDoNCisJCS8qIFVBQzJfUFJPQ0VTU0lOR19VTklUX1YyICovDQorCQkvKiBV
QUMyX0VGRkVDVF9VTklUICovDQorCQljYXNlIFVBQzJfRVhURU5TSU9OX1VOSVRfVjI6IHsNCiAJ
CQlzdHJ1Y3QgdWFjX3Byb2Nlc3NpbmdfdW5pdF9kZXNjcmlwdG9yICpkID0gcDE7DQorDQorCQkJ
aWYgKHN0YXRlLT5taXhlci0+cHJvdG9jb2wgPT0gVUFDX1ZFUlNJT05fMiAmJg0KKwkJCQloZHJb
Ml0gPT0gVUFDMl9FRkZFQ1RfVU5JVCkgew0KKwkJCQkvKiBVQUMyL1VBQzEgdW5pdCBJRHMgb3Zl
cmxhcCBoZXJlIGluIGFuDQorCQkJCSAqIHVuY29tcGF0aWJsZSB3YXkuIElnbm9yZSB0aGlzIHVu
aXQgZm9yIG5vdy4NCisJCQkJICovDQorCQkJCXJldHVybiAwOw0KKwkJCX0NCisNCiAJCQlpZiAo
ZC0+Yk5ySW5QaW5zKSB7DQogCQkJCWlkID0gZC0+YmFTb3VyY2VJRFswXTsNCiAJCQkJYnJlYWs7
IC8qIGNvbnRpbnVlIHRvIHBhcnNlICovDQpAQCAtMTk1Niw2ICsxOTY4LDggQEAgc3RhdGljIGlu
dCBwYXJzZV9hdWRpb191bml0KHN0cnVjdCBtaXhlcl9idWlsZCAqc3RhdGUsIGludCB1bml0aWQp
DQogCQkJcmV0dXJuIHBhcnNlX2F1ZGlvX2V4dGVuc2lvbl91bml0KHN0YXRlLCB1bml0aWQsIHAx
KTsNCiAJCWVsc2UgLyogVUFDX1ZFUlNJT05fMiAqLw0KIAkJCXJldHVybiBwYXJzZV9hdWRpb19w
cm9jZXNzaW5nX3VuaXQoc3RhdGUsIHVuaXRpZCwgcDEpOw0KKwljYXNlIFVBQzJfRVhURU5TSU9O
X1VOSVRfVjI6DQorCQlyZXR1cm4gcGFyc2VfYXVkaW9fZXh0ZW5zaW9uX3VuaXQoc3RhdGUsIHVu
aXRpZCwgcDEpOw0KIAlkZWZhdWx0Og0KIAkJc25kX3ByaW50ayhLRVJOX0VSUiAidXNiYXVkaW86
IHVuaXQgJXU6IHVuZXhwZWN0ZWQgdHlwZSAweCUwMnhcbiIsIHVuaXRpZCwgcDFbMl0pOw0KIAkJ
cmV0dXJuIC1FSU5WQUw7DQpkaWZmIC0tZ2l0IGEvdG9vbHMvcGVyZi91dGlsL21hcC5jIGIvdG9v
bHMvcGVyZi91dGlsL21hcC5jDQppbmRleCA3ODI4NGIxLi40MmRmZmEwIDEwMDY0NA0KLS0tIGEv
dG9vbHMvcGVyZi91dGlsL21hcC5jDQorKysgYi90b29scy9wZXJmL3V0aWwvbWFwLmMNCkBAIC0x
NSw3ICsxNSw4IEBAIGNvbnN0IGNoYXIgKm1hcF90eXBlX19uYW1lW01BUF9fTlJfVFlQRVNdID0g
ew0KIA0KIHN0YXRpYyBpbmxpbmUgaW50IGlzX2Fub25fbWVtb3J5KGNvbnN0IGNoYXIgKmZpbGVu
YW1lKQ0KIHsNCi0JcmV0dXJuIHN0cmNtcChmaWxlbmFtZSwgIi8vYW5vbiIpID09IDA7DQorCXJl
dHVybiAhc3RyY21wKGZpbGVuYW1lLCAiLy9hbm9uIikgfHwNCisJICAgICAgICFzdHJjbXAoZmls
ZW5hbWUsICIvYW5vbl9odWdlcGFnZSAoZGVsZXRlZCkiKTsNCiB9DQogDQogc3RhdGljIGlubGlu
ZSBpbnQgaXNfbm9fZHNvX21lbW9yeShjb25zdCBjaGFyICpmaWxlbmFtZSkNCi==


--=-g5CTOmIdKae6ziVwk0IY--

--=-ftUD4RZIs3rH+BTUm/cy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUi+/ree/yOyVhhEJAQqkdQ/9FWC4QfaxXOa4Qp2Ma4JB/5w4OHDLmiLZ
T6zZTvEvPBKs2sY8sgARpmH7cCjG4QWtnZZ8UX3ckd+gKFGdjlIjdyVB9/gwjsuM
ge+x9aUQJIdgHk+G9CEkRYA4mVc8EGBgVieIFer+1GT0fm4bTnqQHLKPA/PoaB1Q
nAFD6zyTIlMGHL+Ge4le3nyb5zNOE3Vr1rAK2o/uRoYivFRn/tuXT+voMH75CFuI
GNMQy85b8koxfG71a498KH8LRTjamhJxU1MBQ/9ytVdRb9aDlgVB1w5wRu/DYnJZ
hP87DXp4b4H5cSWAj5fqeJOwKC4sIp18jstJKlg+bmWIcEIWzMnbKaFYfGolnNDX
WSIEDjmmjd3z4fy77tQnKZQuROsELfs6X9WOVPOFVhFUGQZaI2KG5W2pEW5QpDV+
1YO8LjcMY9YbKVnUaKgSi5u30Mk/rC6V7Uk84D8ODToUb1KD9acAbYTL50yffOw7
hvLi30u9PTLW14YwPUmvRdaNyr/Ka+4XRNj0mk9pIb6EVtwQVPwoibcHwEGbZpGT
Pg1ApVDPjegT3kpcXRJl+8Z2LJFjM8j4Bleo5juLXED6TA79DEEeNvvVcRBRNI1T
cNNBHh31UvW4sxB+YcPFyYsLIaqGDFIPBZ9hFF19RF9lY+lNnEbjNzVlu3c1DTya
Br7Z+FjM1gI=
=+303
-----END PGP SIGNATURE-----

--=-ftUD4RZIs3rH+BTUm/cy--
