Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3DZLmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:42:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54783 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909Ab3DZLms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:42:48 -0400
Message-ID: <1366976557.5955.1.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.44
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 26 Apr 2013 12:42:37 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fA47neVmN5lZ3ET9C6Qr"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f95e:74f6:4873:febb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fA47neVmN5lZ3ET9C6Qr
Content-Type: multipart/mixed; boundary="=-0qPRDH71gJHOZvXRVSSI"


--=-0qPRDH71gJHOZvXRVSSI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.44 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.43 is attached to this message.

Ben.

------------

 Documentation/kernel-parameters.txt                |   14 +++++
 Makefile                                           |    2 +-
 arch/alpha/kernel/sys_nautilus.c                   |    5 ++
 arch/arm/kernel/perf_event.c                       |    5 +-
 arch/arm/mm/cache-feroceon-l2.c                    |    1 +
 arch/arm/mm/proc-arm920.S                          |    2 +-
 arch/arm/mm/proc-arm926.S                          |    2 +-
 arch/arm/mm/proc-sa1100.S                          |    2 +-
 arch/arm/mm/proc-v6.S                              |    2 +-
 arch/arm/mm/proc-xsc3.S                            |    2 +-
 arch/arm/mm/proc-xscale.S                          |    2 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 ++-
 arch/x86/include/asm/kvm_host.h                    |    4 +-
 arch/x86/include/asm/paravirt.h                    |    5 +-
 arch/x86/include/asm/paravirt_types.h              |    2 +
 arch/x86/kernel/paravirt.c                         |   25 ++++-----
 arch/x86/kvm/x86.c                                 |   43 +++++++--------
 arch/x86/lguest/boot.c                             |    1 +
 arch/x86/mm/fault.c                                |    6 ++-
 arch/x86/xen/mmu.c                                 |    1 +
 block/blk-sysfs.c                                  |    2 +
 crypto/gcm.c                                       |   17 ++++--
 drivers/ata/ata_piix.c                             |   14 ++++-
 drivers/ata/libata-core.c                          |    4 ++
 drivers/gpu/drm/i915/i915_drv.h                    |    1 +
 drivers/gpu/drm/i915/intel_display.c               |   55 ++++++++++++++++=
++++
 drivers/gpu/drm/i915/intel_panel.c                 |   24 +++++++++
 drivers/gpu/vga/vga_switcheroo.c                   |    3 ++
 drivers/hwspinlock/hwspinlock_core.c               |    2 +
 drivers/mtd/mtdchar.c                              |    6 ++-
 drivers/net/can/sja1000/sja1000_of_platform.c      |   31 ++++++-----
 drivers/net/ethernet/realtek/r8169.c               |   28 ++++++++--
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    4 +-
 drivers/platform/x86/msi-wmi.c                     |    4 +-
 drivers/target/target_core_alua.c                  |    9 ++--
 drivers/target/target_core_transport.c             |    3 +-
 drivers/thermal/thermal_sys.c                      |    1 +
 drivers/usb/serial/ark3116.c                       |   10 ++--
 drivers/usb/serial/ch341.c                         |   11 ++--
 drivers/usb/serial/cypress_m8.c                    |   14 ++---
 drivers/usb/serial/ftdi_sio.c                      |   19 +++----
 drivers/usb/serial/io_edgeport.c                   |   12 +++--
 drivers/usb/serial/io_ti.c                         |   12 ++---
 drivers/usb/serial/mct_u232.c                      |   13 ++---
 drivers/usb/serial/mos7840.c                       |   16 +++---
 drivers/usb/serial/oti6858.c                       |   10 ++--
 drivers/usb/serial/pl2303.c                        |   11 ++--
 drivers/usb/serial/spcp8x5.c                       |    9 ++--
 drivers/usb/serial/ssu100.c                        |   12 +++--
 drivers/usb/serial/ti_usb_3410_5052.c              |   10 ++--
 drivers/usb/serial/usb-serial.c                    |    1 +
 drivers/video/console/fbcon.c                      |   11 ++--
 drivers/video/fbmem.c                              |    2 +
 fs/btrfs/extent_io.c                               |   33 ++++++++++++
 fs/btrfs/extent_io.h                               |    2 +
 fs/btrfs/inode.c                                   |   14 +++++
 fs/btrfs/tree-log.c                                |   48 ++++++++++++++--=
-
 fs/hfsplus/extents.c                               |    2 +-
 fs/inode.c                                         |    2 +-
 include/linux/ata.h                                |    2 +-
 include/linux/kref.h                               |   21 ++++++++
 include/linux/kvm_host.h                           |    2 +-
 include/linux/kvm_types.h                          |    1 +
 include/linux/libata.h                             |    1 +
 include/linux/of.h                                 |   16 ++++++
 include/linux/preempt.h                            |   18 ++++---
 include/linux/socket.h                             |    1 +
 include/linux/spinlock_up.h                        |   29 +++++++----
 include/linux/usb/serial.h                         |    2 +
 include/linux/writeback.h                          |    2 +
 include/net/scm.h                                  |    2 +-
 kernel/hrtimer.c                                   |    3 +-
 kernel/sched.c                                     |    6 ++-
 kernel/sched_clock.c                               |   26 +++++++++
 kernel/signal.c                                    |    2 +-
 kernel/sys.c                                       |    3 +-
 kernel/trace/ftrace.c                              |   19 +++----
 lib/kobject.c                                      |    9 +++-
 mm/hugetlb.c                                       |   12 ++++-
 mm/page-writeback.c                                |   19 +++++++
 net/can/gw.c                                       |    6 +--
 net/core/sock.c                                    |   14 +++++
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/patch_realtek.c                      |    4 +-
 sound/soc/codecs/wm8903.c                          |    2 +
 sound/usb/mixer_quirks.c                           |    4 +-
 sound/usb/quirks.c                                 |    2 +-
 virt/kvm/ioapic.c                                  |    7 ++-
 virt/kvm/kvm_main.c                                |   47 +++++++++++++---=
-
 91 files changed, 678 insertions(+), 226 deletions(-)

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is runn=
ing

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

Andy Honig (3):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME =
(CVE-2013-1796)
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functio=
ns (CVE-2013-1797)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-=
1798)

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Ben Hutchings (1):
      Linux 3.2.44

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare me=
tal

Carsten Emde (3):
      drm/i915: panel: invert brightness via parameter
      drm/i915: panel: invert brightness via quirk
      drm/i915: panel: invert brightness acer aspire 5734z

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Dave Airlie (1):
      fbcon: fix locking harder

David Henningsson (1):
      ALSA: hda - fix typo in proc output

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems

Egbert Eich (1):
      DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Jean-Christophe PLAGNIOL-VILLARD (1):
      of: introduce helper to manage boolean

Johan Hovold (15):
      USB: serial: add modem-status-change wait queue
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Linus Torvalds (3):
      spinlocks and preemption points need to be at least compiler barriers
      kobject: fix kset_find_obj() race with concurrent last kobject_put()
      net: fix incorrect credentials passing

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being =
performed before the ANDCOND test

Ming Lei (1):
      USB: serial: fix hang when opening port

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
      tracing: Fix possible NULL pointer dereferences

Naoya Horiguchi (1):
      hugetlbfs: add swap entry check in follow_hugetlb_page()

Nicholas Bellinger (2):
      target: Fix MAINTENANCE_IN service action CDB checks to use lower 5 b=
its
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition =
CDBs

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support=
) properly

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

Thomas Hellstrom (1):
      kref: Implement kref_get_unless_zero v3

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure=
 once

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Wei Yongjun (1):
      can: gw: use kmem_cache_free() instead of kfree()

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec

Wu Fengguang (1):
      writeback: fix dirtied pages accounting on redirty

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

hayeswang (1):
      r8169: fix auto speed down issue



--=-0qPRDH71gJHOZvXRVSSI
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.44.patch"
Content-Disposition: attachment; filename="linux-3.2.44.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0IGIvRG9jdW1l
bnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQNCmluZGV4IGRkYmYxOGUuLjg5N2YyMjMgMTAw
NjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dA0KKysrIGIvRG9j
dW1lbnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQNCkBAIC05NDgsNiArOTQ4LDIwIEBAIGJ5
dGVzIHJlc3BlY3RpdmVseS4gU3VjaCBsZXR0ZXIgc3VmZml4ZXMgY2FuIGFsc28gYmUgZW50aXJl
bHkgb21pdHRlZC4NCiAJaThrLnJlc3RyaWN0ZWQJW0hXXSBBbGxvdyBjb250cm9sbGluZyBmYW5z
IG9ubHkgaWYgU1lTX0FETUlODQogCQkJY2FwYWJpbGl0eSBpcyBzZXQuDQogDQorCWk5MTUuaW52
ZXJ0X2JyaWdodG5lc3M9DQorCQkJW0RSTV0gSW52ZXJ0IHRoZSBzZW5zZSBvZiB0aGUgdmFyaWFi
bGUgdGhhdCBpcyB1c2VkIHRvDQorCQkJc2V0IHRoZSBicmlnaHRuZXNzIG9mIHRoZSBwYW5lbCBi
YWNrbGlnaHQuIE5vcm1hbGx5IGENCisJCQlicmlnaHRuZXNzIHZhbHVlIG9mIDAgaW5kaWNhdGVz
IGJhY2tsaWdodCBzd2l0Y2hlZCBvZmYsDQorCQkJYW5kIHRoZSBtYXhpbXVtIG9mIHRoZSBicmln
aHRuZXNzIHZhbHVlIHNldHMgdGhlIGJhY2tsaWdodA0KKwkJCXRvIG1heGltdW0gYnJpZ2h0bmVz
cy4gSWYgdGhpcyBwYXJhbWV0ZXIgaXMgc2V0IHRvIDANCisJCQkoZGVmYXVsdCkgYW5kIHRoZSBt
YWNoaW5lIHJlcXVpcmVzIGl0LCBvciB0aGlzIHBhcmFtZXRlcg0KKwkJCWlzIHNldCB0byAxLCBh
IGJyaWdodG5lc3MgdmFsdWUgb2YgMCBzZXRzIHRoZSBiYWNrbGlnaHQNCisJCQl0byBtYXhpbXVt
IGJyaWdodG5lc3MsIGFuZCB0aGUgbWF4aW11bSBvZiB0aGUgYnJpZ2h0bmVzcw0KKwkJCXZhbHVl
IHN3aXRjaGVzIHRoZSBiYWNrbGlnaHQgb2ZmLg0KKwkJCS0xIC0tIG5ldmVyIGludmVydCBicmln
aHRuZXNzDQorCQkJIDAgLS0gbWFjaGluZSBkZWZhdWx0DQorCQkJIDEgLS0gZm9yY2UgYnJpZ2h0
bmVzcyBpbnZlcnNpb24NCisNCiAJaWNuPQkJW0hXLElTRE5dDQogCQkJRm9ybWF0OiA8aW8+Wyw8
bWVtYmFzZT5bLDxpY25faWQ+Wyw8aWNuX2lkMj5dXV0NCiANCmRpZmYgLS1naXQgYS9NYWtlZmls
ZSBiL01ha2VmaWxlDQppbmRleCA1OTEzMGRiLi41NjY3NTBjIDEwMDY0NA0KLS0tIGEvTWFrZWZp
bGUNCisrKyBiL01ha2VmaWxlDQpAQCAtMSw2ICsxLDYgQEANCiBWRVJTSU9OID0gMw0KIFBBVENI
TEVWRUwgPSAyDQotU1VCTEVWRUwgPSA0Mw0KK1NVQkxFVkVMID0gNDQNCiBFWFRSQVZFUlNJT04g
PQ0KIE5BTUUgPSBTYWJlci10b290aGVkIFNxdWlycmVsDQogDQpkaWZmIC0tZ2l0IGEvYXJjaC9h
bHBoYS9rZXJuZWwvc3lzX25hdXRpbHVzLmMgYi9hcmNoL2FscGhhL2tlcm5lbC9zeXNfbmF1dGls
dXMuYw0KaW5kZXggNDExMjIwMC4uYzUyYThlZiAxMDA2NDQNCi0tLSBhL2FyY2gvYWxwaGEva2Vy
bmVsL3N5c19uYXV0aWx1cy5jDQorKysgYi9hcmNoL2FscGhhL2tlcm5lbC9zeXNfbmF1dGlsdXMu
Yw0KQEAgLTE4OSw2ICsxODksMTAgQEAgbmF1dGlsdXNfbWFjaGluZV9jaGVjayh1bnNpZ25lZCBs
b25nIHZlY3RvciwgdW5zaWduZWQgbG9uZyBsYV9wdHIpDQogZXh0ZXJuIHZvaWQgZnJlZV9yZXNl
cnZlZF9tZW0odm9pZCAqLCB2b2lkICopOw0KIGV4dGVybiB2b2lkIHBjaWJpb3NfY2xhaW1fb25l
X2J1cyhzdHJ1Y3QgcGNpX2J1cyAqKTsNCiANCitzdGF0aWMgc3RydWN0IHJlc291cmNlIGlyb25n
YXRlX2lvID0gew0KKwkubmFtZQk9ICJJcm9uZ2F0ZSBQQ0kgSU8iLA0KKwkuZmxhZ3MJPSBJT1JF
U09VUkNFX0lPLA0KK307DQogc3RhdGljIHN0cnVjdCByZXNvdXJjZSBpcm9uZ2F0ZV9tZW0gPSB7
DQogCS5uYW1lCT0gIklyb25nYXRlIFBDSSBNRU0iLA0KIAkuZmxhZ3MJPSBJT1JFU09VUkNFX01F
TSwNCkBAIC0yMTAsNiArMjE0LDcgQEAgbmF1dGlsdXNfaW5pdF9wY2kodm9pZCkNCiANCiAJaXJv
bmdhdGUgPSBwY2lfZ2V0X2J1c19hbmRfc2xvdCgwLCAwKTsNCiAJYnVzLT5zZWxmID0gaXJvbmdh
dGU7DQorCWJ1cy0+cmVzb3VyY2VbMF0gPSAmaXJvbmdhdGVfaW87DQogCWJ1cy0+cmVzb3VyY2Vb
MV0gPSAmaXJvbmdhdGVfbWVtOw0KIA0KIAlwY2lfYnVzX3NpemVfYnJpZGdlcyhidXMpOw0KZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtL2tlcm5lbC9wZXJmX2V2ZW50LmMgYi9hcmNoL2FybS9rZXJuZWwv
cGVyZl9ldmVudC5jDQppbmRleCBlY2ViYjg5Li5hNTU5ZWU3IDEwMDY0NA0KLS0tIGEvYXJjaC9h
cm0va2VybmVsL3BlcmZfZXZlbnQuYw0KKysrIGIvYXJjaC9hcm0va2VybmVsL3BlcmZfZXZlbnQu
Yw0KQEAgLTMyNiw3ICszMjYsMTAgQEAgdmFsaWRhdGVfZXZlbnQoc3RydWN0IHBtdV9od19ldmVu
dHMgKmh3X2V2ZW50cywNCiAJc3RydWN0IGh3X3BlcmZfZXZlbnQgZmFrZV9ldmVudCA9IGV2ZW50
LT5odzsNCiAJc3RydWN0IHBtdSAqbGVhZGVyX3BtdSA9IGV2ZW50LT5ncm91cF9sZWFkZXItPnBt
dTsNCiANCi0JaWYgKGV2ZW50LT5wbXUgIT0gbGVhZGVyX3BtdSB8fCBldmVudC0+c3RhdGUgPD0g
UEVSRl9FVkVOVF9TVEFURV9PRkYpDQorCWlmIChldmVudC0+cG11ICE9IGxlYWRlcl9wbXUgfHwg
ZXZlbnQtPnN0YXRlIDwgUEVSRl9FVkVOVF9TVEFURV9PRkYpDQorCQlyZXR1cm4gMTsNCisNCisJ
aWYgKGV2ZW50LT5zdGF0ZSA9PSBQRVJGX0VWRU5UX1NUQVRFX09GRiAmJiAhZXZlbnQtPmF0dHIu
ZW5hYmxlX29uX2V4ZWMpDQogCQlyZXR1cm4gMTsNCiANCiAJcmV0dXJuIGFybXBtdS0+Z2V0X2V2
ZW50X2lkeChod19ldmVudHMsICZmYWtlX2V2ZW50KSA+PSAwOw0KZGlmZiAtLWdpdCBhL2FyY2gv
YXJtL21tL2NhY2hlLWZlcm9jZW9uLWwyLmMgYi9hcmNoL2FybS9tbS9jYWNoZS1mZXJvY2Vvbi1s
Mi5jDQppbmRleCBlMGIwZTdhLi4wOWY4ODUxIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0vbW0vY2Fj
aGUtZmVyb2Nlb24tbDIuYw0KKysrIGIvYXJjaC9hcm0vbW0vY2FjaGUtZmVyb2Nlb24tbDIuYw0K
QEAgLTM0Miw2ICszNDIsNyBAQCB2b2lkIF9faW5pdCBmZXJvY2Vvbl9sMl9pbml0KGludCBfX2wy
X3d0X292ZXJyaWRlKQ0KIAlvdXRlcl9jYWNoZS5pbnZfcmFuZ2UgPSBmZXJvY2Vvbl9sMl9pbnZf
cmFuZ2U7DQogCW91dGVyX2NhY2hlLmNsZWFuX3JhbmdlID0gZmVyb2Nlb25fbDJfY2xlYW5fcmFu
Z2U7DQogCW91dGVyX2NhY2hlLmZsdXNoX3JhbmdlID0gZmVyb2Nlb25fbDJfZmx1c2hfcmFuZ2U7
DQorCW91dGVyX2NhY2hlLmludl9hbGwgPSBsMl9pbnZfYWxsOw0KIA0KIAllbmFibGVfbDIoKTsN
CiANCmRpZmYgLS1naXQgYS9hcmNoL2FybS9tbS9wcm9jLWFybTkyMC5TIGIvYXJjaC9hcm0vbW0v
cHJvYy1hcm05MjAuUw0KaW5kZXggODhmYjNkOS4uOTI3YTYzOSAxMDA2NDQNCi0tLSBhL2FyY2gv
YXJtL21tL3Byb2MtYXJtOTIwLlMNCisrKyBiL2FyY2gvYXJtL21tL3Byb2MtYXJtOTIwLlMNCkBA
IC0zODAsNyArMzgwLDcgQEAgRU5UUlkoY3B1X2FybTkyMF9zZXRfcHRlX2V4dCkNCiAvKiBTdXNw
ZW5kL3Jlc3VtZSBzdXBwb3J0OiB0YWtlbiBmcm9tIGFyY2gvYXJtL3BsYXQtczNjMjR4eC9zbGVl
cC5TICovDQogLmdsb2JsCWNwdV9hcm05MjBfc3VzcGVuZF9zaXplDQogLmVxdQljcHVfYXJtOTIw
X3N1c3BlbmRfc2l6ZSwgNCAqIDMNCi0jaWZkZWYgQ09ORklHX1BNX1NMRUVQDQorI2lmZGVmIENP
TkZJR19BUk1fQ1BVX1NVU1BFTkQNCiBFTlRSWShjcHVfYXJtOTIwX2RvX3N1c3BlbmQpDQogCXN0
bWZkCXNwISwge3I0IC0gcjYsIGxyfQ0KIAltcmMJcDE1LCAwLCByNCwgYzEzLCBjMCwgMAlAIFBJ
RA0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21tL3Byb2MtYXJtOTI2LlMgYi9hcmNoL2FybS9tbS9w
cm9jLWFybTkyNi5TDQppbmRleCA5ZjhmZDkxLi4wOTBmMThmIDEwMDY0NA0KLS0tIGEvYXJjaC9h
cm0vbW0vcHJvYy1hcm05MjYuUw0KKysrIGIvYXJjaC9hcm0vbW0vcHJvYy1hcm05MjYuUw0KQEAg
LTM5NSw3ICszOTUsNyBAQCBFTlRSWShjcHVfYXJtOTI2X3NldF9wdGVfZXh0KQ0KIC8qIFN1c3Bl
bmQvcmVzdW1lIHN1cHBvcnQ6IHRha2VuIGZyb20gYXJjaC9hcm0vcGxhdC1zM2MyNHh4L3NsZWVw
LlMgKi8NCiAuZ2xvYmwJY3B1X2FybTkyNl9zdXNwZW5kX3NpemUNCiAuZXF1CWNwdV9hcm05MjZf
c3VzcGVuZF9zaXplLCA0ICogMw0KLSNpZmRlZiBDT05GSUdfUE1fU0xFRVANCisjaWZkZWYgQ09O
RklHX0FSTV9DUFVfU1VTUEVORA0KIEVOVFJZKGNwdV9hcm05MjZfZG9fc3VzcGVuZCkNCiAJc3Rt
ZmQJc3AhLCB7cjQgLSByNiwgbHJ9DQogCW1yYwlwMTUsIDAsIHI0LCBjMTMsIGMwLCAwCUAgUElE
DQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vbW0vcHJvYy1zYTExMDAuUyBiL2FyY2gvYXJtL21tL3By
b2Mtc2ExMTAwLlMNCmluZGV4IDdkOTE1NDUuLjY1OTRhZWYgMTAwNjQ0DQotLS0gYS9hcmNoL2Fy
bS9tbS9wcm9jLXNhMTEwMC5TDQorKysgYi9hcmNoL2FybS9tbS9wcm9jLXNhMTEwMC5TDQpAQCAt
MTY5LDcgKzE2OSw3IEBAIEVOVFJZKGNwdV9zYTExMDBfc2V0X3B0ZV9leHQpDQogDQogLmdsb2Js
CWNwdV9zYTExMDBfc3VzcGVuZF9zaXplDQogLmVxdQljcHVfc2ExMTAwX3N1c3BlbmRfc2l6ZSwg
NCAqIDMNCi0jaWZkZWYgQ09ORklHX1BNX1NMRUVQDQorI2lmZGVmIENPTkZJR19BUk1fQ1BVX1NV
U1BFTkQNCiBFTlRSWShjcHVfc2ExMTAwX2RvX3N1c3BlbmQpDQogCXN0bWZkCXNwISwge3I0IC0g
cjYsIGxyfQ0KIAltcmMJcDE1LCAwLCByNCwgYzMsIGMwLCAwCQlAIGRvbWFpbiBJRA0KZGlmZiAt
LWdpdCBhL2FyY2gvYXJtL21tL3Byb2MtdjYuUyBiL2FyY2gvYXJtL21tL3Byb2MtdjYuUw0KaW5k
ZXggZDA2MWQyZi4uODE2OGQ5OSAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21tL3Byb2MtdjYuUw0K
KysrIGIvYXJjaC9hcm0vbW0vcHJvYy12Ni5TDQpAQCAtMTI5LDcgKzEyOSw3IEBAIEVOVFJZKGNw
dV92Nl9zZXRfcHRlX2V4dCkNCiAvKiBTdXNwZW5kL3Jlc3VtZSBzdXBwb3J0OiB0YWtlbiBmcm9t
IGFyY2gvYXJtL21hY2gtczNjNjR4eC9zbGVlcC5TICovDQogLmdsb2JsCWNwdV92Nl9zdXNwZW5k
X3NpemUNCiAuZXF1CWNwdV92Nl9zdXNwZW5kX3NpemUsIDQgKiA2DQotI2lmZGVmIENPTkZJR19Q
TV9TTEVFUA0KKyNpZmRlZiBDT05GSUdfQVJNX0NQVV9TVVNQRU5EDQogRU5UUlkoY3B1X3Y2X2Rv
X3N1c3BlbmQpDQogCXN0bWZkCXNwISwge3I0IC0gcjksIGxyfQ0KIAltcmMJcDE1LCAwLCByNCwg
YzEzLCBjMCwgMAlAIEZDU0UvUElEDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vbW0vcHJvYy14c2Mz
LlMgYi9hcmNoL2FybS9tbS9wcm9jLXhzYzMuUw0KaW5kZXggYWJmMDUwNy4uNWM0OTY5ZCAxMDA2
NDQNCi0tLSBhL2FyY2gvYXJtL21tL3Byb2MteHNjMy5TDQorKysgYi9hcmNoL2FybS9tbS9wcm9j
LXhzYzMuUw0KQEAgLTQwNyw3ICs0MDcsNyBAQCBFTlRSWShjcHVfeHNjM19zZXRfcHRlX2V4dCkN
CiANCiAuZ2xvYmwJY3B1X3hzYzNfc3VzcGVuZF9zaXplDQogLmVxdQljcHVfeHNjM19zdXNwZW5k
X3NpemUsIDQgKiA2DQotI2lmZGVmIENPTkZJR19QTV9TTEVFUA0KKyNpZmRlZiBDT05GSUdfQVJN
X0NQVV9TVVNQRU5EDQogRU5UUlkoY3B1X3hzYzNfZG9fc3VzcGVuZCkNCiAJc3RtZmQJc3AhLCB7
cjQgLSByOSwgbHJ9DQogCW1yYwlwMTQsIDAsIHI0LCBjNiwgYzAsIDAJQCBjbG9jayBjb25maWd1
cmF0aW9uLCBmb3IgdHVyYm8gbW9kZQ0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21tL3Byb2MteHNj
YWxlLlMgYi9hcmNoL2FybS9tbS9wcm9jLXhzY2FsZS5TDQppbmRleCAzMjc3OTA0Li5iMDlkMDM2
IDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0vbW0vcHJvYy14c2NhbGUuUw0KKysrIGIvYXJjaC9hcm0v
bW0vcHJvYy14c2NhbGUuUw0KQEAgLTUyMSw3ICs1MjEsNyBAQCBFTlRSWShjcHVfeHNjYWxlX3Nl
dF9wdGVfZXh0KQ0KIA0KIC5nbG9ibAljcHVfeHNjYWxlX3N1c3BlbmRfc2l6ZQ0KIC5lcXUJY3B1
X3hzY2FsZV9zdXNwZW5kX3NpemUsIDQgKiA2DQotI2lmZGVmIENPTkZJR19QTV9TTEVFUA0KKyNp
ZmRlZiBDT05GSUdfQVJNX0NQVV9TVVNQRU5EDQogRU5UUlkoY3B1X3hzY2FsZV9kb19zdXNwZW5k
KQ0KIAlzdG1mZAlzcCEsIHtyNCAtIHI5LCBscn0NCiAJbXJjCXAxNCwgMCwgcjQsIGM2LCBjMCwg
MAlAIGNsb2NrIGNvbmZpZ3VyYXRpb24sIGZvciB0dXJibyBtb2RlDQpkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL2xwYXIuYyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9y
bXMvcHNlcmllcy9scGFyLmMNCmluZGV4IGRjMzZlYTYuLmViMTliNmMgMTAwNjQ0DQotLS0gYS9h
cmNoL3Bvd2VycGMvcGxhdGZvcm1zL3BzZXJpZXMvbHBhci5jDQorKysgYi9hcmNoL3Bvd2VycGMv
cGxhdGZvcm1zL3BzZXJpZXMvbHBhci5jDQpAQCAtMTg2LDcgKzE4NiwxMyBAQCBzdGF0aWMgbG9u
ZyBwU2VyaWVzX2xwYXJfaHB0ZV9yZW1vdmUodW5zaWduZWQgbG9uZyBocHRlX2dyb3VwKQ0KIAkJ
CQkJICAgKDB4MVVMIDw8IDQpLCAmZHVtbXkxLCAmZHVtbXkyKTsNCiAJCWlmIChscGFyX3JjID09
IEhfU1VDQ0VTUykNCiAJCQlyZXR1cm4gaTsNCi0JCUJVR19PTihscGFyX3JjICE9IEhfTk9UX0ZP
VU5EKTsNCisNCisJCS8qDQorCQkgKiBUaGUgdGVzdCBmb3IgYWRqdW5jdCBwYXJ0aXRpb24gaXMg
cGVyZm9ybWVkIGJlZm9yZSB0aGUNCisJCSAqIEFORENPTkQgdGVzdC4gIEhfUkVTT1VSQ0UgbWF5
IGJlIHJldHVybmVkLCBzbyB3ZSBuZWVkIHRvDQorCQkgKiBjaGVjayBmb3IgdGhhdCBhcyB3ZWxs
Lg0KKwkJICovDQorCQlCVUdfT04obHBhcl9yYyAhPSBIX05PVF9GT1VORCAmJiBscGFyX3JjICE9
IEhfUkVTT1VSQ0UpOw0KIA0KIAkJc2xvdF9vZmZzZXQrKzsNCiAJCXNsb3Rfb2Zmc2V0ICY9IDB4
NzsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KaW5kZXggYjQ5NzNmNC4uY2ZiNWE0MCAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCisrKyBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmgNCkBAIC0zOTMsOCArMzkzLDggQEAgc3RydWN0IGt2bV92Y3B1
X2FyY2ggew0KIAlncGFfdCB0aW1lOw0KIAlzdHJ1Y3QgcHZjbG9ja192Y3B1X3RpbWVfaW5mbyBo
dl9jbG9jazsNCiAJdW5zaWduZWQgaW50IGh3X3RzY19raHo7DQotCXVuc2lnbmVkIGludCB0aW1l
X29mZnNldDsNCi0Jc3RydWN0IHBhZ2UgKnRpbWVfcGFnZTsNCisJc3RydWN0IGdmbl90b19odmFf
Y2FjaGUgcHZfdGltZTsNCisJYm9vbCBwdl90aW1lX2VuYWJsZWQ7DQogDQogCXN0cnVjdCB7DQog
CQl1NjQgbXNyX3ZhbDsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmly
dC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaA0KaW5kZXggYTdkMmRiOS4uOTFl
NzU4YiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmgNCisrKyBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmgNCkBAIC03NDAsNyArNzQwLDEwIEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBhcmNoX2xlYXZlX2xhenlfbW11X21vZGUodm9pZCkNCiAJUFZPUF9W
Q0FMTDAocHZfbW11X29wcy5sYXp5X21vZGUubGVhdmUpOw0KIH0NCiANCi12b2lkIGFyY2hfZmx1
c2hfbGF6eV9tbXVfbW9kZSh2b2lkKTsNCitzdGF0aWMgaW5saW5lIHZvaWQgYXJjaF9mbHVzaF9s
YXp5X21tdV9tb2RlKHZvaWQpDQorew0KKwlQVk9QX1ZDQUxMMChwdl9tbXVfb3BzLmxhenlfbW9k
ZS5mbHVzaCk7DQorfQ0KIA0KIHN0YXRpYyBpbmxpbmUgdm9pZCBfX3NldF9maXhtYXAodW5zaWdu
ZWQgLyogZW51bSBmaXhlZF9hZGRyZXNzZXMgKi8gaWR4LA0KIAkJCQlwaHlzX2FkZHJfdCBwaHlz
LCBwZ3Byb3RfdCBmbGFncykNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJh
dmlydF90eXBlcy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnRfdHlwZXMuaA0KaW5k
ZXggOGU4YjlhNC4uZmFmMmMwNCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Bh
cmF2aXJ0X3R5cGVzLmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X3R5cGVz
LmgNCkBAIC05MSw2ICs5MSw3IEBAIHN0cnVjdCBwdl9sYXp5X29wcyB7DQogCS8qIFNldCBkZWZl
cnJlZCB1cGRhdGUgbW9kZSwgdXNlZCBmb3IgYmF0Y2hpbmcgb3BlcmF0aW9ucy4gKi8NCiAJdm9p
ZCAoKmVudGVyKSh2b2lkKTsNCiAJdm9pZCAoKmxlYXZlKSh2b2lkKTsNCisJdm9pZCAoKmZsdXNo
KSh2b2lkKTsNCiB9Ow0KIA0KIHN0cnVjdCBwdl90aW1lX29wcyB7DQpAQCAtNjgwLDYgKzY4MSw3
IEBAIHZvaWQgcGFyYXZpcnRfZW5kX2NvbnRleHRfc3dpdGNoKHN0cnVjdCB0YXNrX3N0cnVjdCAq
bmV4dCk7DQogDQogdm9pZCBwYXJhdmlydF9lbnRlcl9sYXp5X21tdSh2b2lkKTsNCiB2b2lkIHBh
cmF2aXJ0X2xlYXZlX2xhenlfbW11KHZvaWQpOw0KK3ZvaWQgcGFyYXZpcnRfZmx1c2hfbGF6eV9t
bXUodm9pZCk7DQogDQogdm9pZCBfcGFyYXZpcnRfbm9wKHZvaWQpOw0KIHUzMiBfcGFyYXZpcnRf
aWRlbnRfMzIodTMyKTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvcGFyYXZpcnQuYyBi
L2FyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jDQppbmRleCBkOTAyNzJlLi44NGM5MzhmIDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL3BhcmF2aXJ0LmMNCisrKyBiL2FyY2gveDg2L2tlcm5l
bC9wYXJhdmlydC5jDQpAQCAtMjYxLDYgKzI2MSwxOCBAQCB2b2lkIHBhcmF2aXJ0X2xlYXZlX2xh
enlfbW11KHZvaWQpDQogCWxlYXZlX2xhenkoUEFSQVZJUlRfTEFaWV9NTVUpOw0KIH0NCiANCit2
b2lkIHBhcmF2aXJ0X2ZsdXNoX2xhenlfbW11KHZvaWQpDQorew0KKwlwcmVlbXB0X2Rpc2FibGUo
KTsNCisNCisJaWYgKHBhcmF2aXJ0X2dldF9sYXp5X21vZGUoKSA9PSBQQVJBVklSVF9MQVpZX01N
VSkgew0KKwkJYXJjaF9sZWF2ZV9sYXp5X21tdV9tb2RlKCk7DQorCQlhcmNoX2VudGVyX2xhenlf
bW11X21vZGUoKTsNCisJfQ0KKw0KKwlwcmVlbXB0X2VuYWJsZSgpOw0KK30NCisNCiB2b2lkIHBh
cmF2aXJ0X3N0YXJ0X2NvbnRleHRfc3dpdGNoKHN0cnVjdCB0YXNrX3N0cnVjdCAqcHJldikNCiB7
DQogCUJVR19PTihwcmVlbXB0aWJsZSgpKTsNCkBAIC0yOTAsMTggKzMwMiw2IEBAIGVudW0gcGFy
YXZpcnRfbGF6eV9tb2RlIHBhcmF2aXJ0X2dldF9sYXp5X21vZGUodm9pZCkNCiAJcmV0dXJuIHBl
cmNwdV9yZWFkKHBhcmF2aXJ0X2xhenlfbW9kZSk7DQogfQ0KIA0KLXZvaWQgYXJjaF9mbHVzaF9s
YXp5X21tdV9tb2RlKHZvaWQpDQotew0KLQlwcmVlbXB0X2Rpc2FibGUoKTsNCi0NCi0JaWYgKHBh
cmF2aXJ0X2dldF9sYXp5X21vZGUoKSA9PSBQQVJBVklSVF9MQVpZX01NVSkgew0KLQkJYXJjaF9s
ZWF2ZV9sYXp5X21tdV9tb2RlKCk7DQotCQlhcmNoX2VudGVyX2xhenlfbW11X21vZGUoKTsNCi0J
fQ0KLQ0KLQlwcmVlbXB0X2VuYWJsZSgpOw0KLX0NCi0NCiBzdHJ1Y3QgcHZfaW5mbyBwdl9pbmZv
ID0gew0KIAkubmFtZSA9ICJiYXJlIGhhcmR3YXJlIiwNCiAJLnBhcmF2aXJ0X2VuYWJsZWQgPSAw
LA0KQEAgLTQ3NSw2ICs0NzUsNyBAQCBzdHJ1Y3QgcHZfbW11X29wcyBwdl9tbXVfb3BzID0gew0K
IAkubGF6eV9tb2RlID0gew0KIAkJLmVudGVyID0gcGFyYXZpcnRfbm9wLA0KIAkJLmxlYXZlID0g
cGFyYXZpcnRfbm9wLA0KKwkJLmZsdXNoID0gcGFyYXZpcnRfbm9wLA0KIAl9LA0KIA0KIAkuc2V0
X2ZpeG1hcCA9IG5hdGl2ZV9zZXRfZml4bWFwLA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94
ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KaW5kZXggZjQwNjNmZC4uZTgyYTUzYSAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQpAQCAt
MTEwNSw3ICsxMTA1LDYgQEAgc3RhdGljIGludCBrdm1fZ3Vlc3RfdGltZV91cGRhdGUoc3RydWN0
IGt2bV92Y3B1ICp2KQ0KIHsNCiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCiAJc3RydWN0IGt2bV92
Y3B1X2FyY2ggKnZjcHUgPSAmdi0+YXJjaDsNCi0Jdm9pZCAqc2hhcmVkX2thZGRyOw0KIAl1bnNp
Z25lZCBsb25nIHRoaXNfdHNjX2toejsNCiAJczY0IGtlcm5lbF9ucywgbWF4X2tlcm5lbF9uczsN
CiAJdTY0IHRzY190aW1lc3RhbXA7DQpAQCAtMTE0MSw3ICsxMTQwLDcgQEAgc3RhdGljIGludCBr
dm1fZ3Vlc3RfdGltZV91cGRhdGUoc3RydWN0IGt2bV92Y3B1ICp2KQ0KIA0KIAlsb2NhbF9pcnFf
cmVzdG9yZShmbGFncyk7DQogDQotCWlmICghdmNwdS0+dGltZV9wYWdlKQ0KKwlpZiAoIXZjcHUt
PnB2X3RpbWVfZW5hYmxlZCkNCiAJCXJldHVybiAwOw0KIA0KIAkvKg0KQEAgLTExOTksMTQgKzEx
OTgsOSBAQCBzdGF0aWMgaW50IGt2bV9ndWVzdF90aW1lX3VwZGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUg
KnYpDQogCSAqLw0KIAl2Y3B1LT5odl9jbG9jay52ZXJzaW9uICs9IDI7DQogDQotCXNoYXJlZF9r
YWRkciA9IGttYXBfYXRvbWljKHZjcHUtPnRpbWVfcGFnZSwgS01fVVNFUjApOw0KLQ0KLQltZW1j
cHkoc2hhcmVkX2thZGRyICsgdmNwdS0+dGltZV9vZmZzZXQsICZ2Y3B1LT5odl9jbG9jaywNCi0J
ICAgICAgIHNpemVvZih2Y3B1LT5odl9jbG9jaykpOw0KLQ0KLQlrdW5tYXBfYXRvbWljKHNoYXJl
ZF9rYWRkciwgS01fVVNFUjApOw0KLQ0KLQltYXJrX3BhZ2VfZGlydHkodi0+a3ZtLCB2Y3B1LT50
aW1lID4+IFBBR0VfU0hJRlQpOw0KKwlrdm1fd3JpdGVfZ3Vlc3RfY2FjaGVkKHYtPmt2bSwgJnZj
cHUtPnB2X3RpbWUsDQorCQkJCSZ2Y3B1LT5odl9jbG9jaywNCisJCQkJc2l6ZW9mKHZjcHUtPmh2
X2Nsb2NrKSk7DQogCXJldHVybiAwOw0KIH0NCiANCkBAIC0xNDg2LDcgKzE0ODAsOCBAQCBzdGF0
aWMgaW50IGt2bV9wdl9lbmFibGVfYXN5bmNfcGYoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
ZGF0YSkNCiAJCXJldHVybiAwOw0KIAl9DQogDQotCWlmIChrdm1fZ2ZuX3RvX2h2YV9jYWNoZV9p
bml0KHZjcHUtPmt2bSwgJnZjcHUtPmFyY2guYXBmLmRhdGEsIGdwYSkpDQorCWlmIChrdm1fZ2Zu
X3RvX2h2YV9jYWNoZV9pbml0KHZjcHUtPmt2bSwgJnZjcHUtPmFyY2guYXBmLmRhdGEsIGdwYSwN
CisJCQkJCXNpemVvZih1MzIpKSkNCiAJCXJldHVybiAxOw0KIA0KIAl2Y3B1LT5hcmNoLmFwZi5z
ZW5kX3VzZXJfb25seSA9ICEoZGF0YSAmIEtWTV9BU1lOQ19QRl9TRU5EX0FMV0FZUyk7DQpAQCAt
MTQ5NiwxMCArMTQ5MSw3IEBAIHN0YXRpYyBpbnQga3ZtX3B2X2VuYWJsZV9hc3luY19wZihzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBkYXRhKQ0KIA0KIHN0YXRpYyB2b2lkIGt2bWNsb2NrX3Jl
c2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiB7DQotCWlmICh2Y3B1LT5hcmNoLnRpbWVfcGFn
ZSkgew0KLQkJa3ZtX3JlbGVhc2VfcGFnZV9kaXJ0eSh2Y3B1LT5hcmNoLnRpbWVfcGFnZSk7DQot
CQl2Y3B1LT5hcmNoLnRpbWVfcGFnZSA9IE5VTEw7DQotCX0NCisJdmNwdS0+YXJjaC5wdl90aW1l
X2VuYWJsZWQgPSBmYWxzZTsNCiB9DQogDQogc3RhdGljIHZvaWQgYWNjdW11bGF0ZV9zdGVhbF90
aW1lKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCkBAIC0xNTkxLDYgKzE1ODMsNyBAQCBpbnQga3Zt
X3NldF9tc3JfY29tbW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1zciwgdTY0IGRhdGEp
DQogCQlicmVhazsNCiAJY2FzZSBNU1JfS1ZNX1NZU1RFTV9USU1FX05FVzoNCiAJY2FzZSBNU1Jf
S1ZNX1NZU1RFTV9USU1FOiB7DQorCQl1NjQgZ3BhX29mZnNldDsNCiAJCWt2bWNsb2NrX3Jlc2V0
KHZjcHUpOw0KIA0KIAkJdmNwdS0+YXJjaC50aW1lID0gZGF0YTsNCkBAIC0xNjAwLDE2ICsxNTkz
LDE0IEBAIGludCBrdm1fc2V0X21zcl9jb21tb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIg
bXNyLCB1NjQgZGF0YSkNCiAJCWlmICghKGRhdGEgJiAxKSkNCiAJCQlicmVhazsNCiANCi0JCS8q
IC4uLmJ1dCBjbGVhbiBpdCBiZWZvcmUgZG9pbmcgdGhlIGFjdHVhbCB3cml0ZSAqLw0KLQkJdmNw
dS0+YXJjaC50aW1lX29mZnNldCA9IGRhdGEgJiB+KFBBR0VfTUFTSyB8IDEpOw0KKwkJZ3BhX29m
ZnNldCA9IGRhdGEgJiB+KFBBR0VfTUFTSyB8IDEpOw0KIA0KLQkJdmNwdS0+YXJjaC50aW1lX3Bh
Z2UgPQ0KLQkJCQlnZm5fdG9fcGFnZSh2Y3B1LT5rdm0sIGRhdGEgPj4gUEFHRV9TSElGVCk7DQot
DQotCQlpZiAoaXNfZXJyb3JfcGFnZSh2Y3B1LT5hcmNoLnRpbWVfcGFnZSkpIHsNCi0JCQlrdm1f
cmVsZWFzZV9wYWdlX2NsZWFuKHZjcHUtPmFyY2gudGltZV9wYWdlKTsNCi0JCQl2Y3B1LT5hcmNo
LnRpbWVfcGFnZSA9IE5VTEw7DQotCQl9DQorCQlpZiAoa3ZtX2dmbl90b19odmFfY2FjaGVfaW5p
dCh2Y3B1LT5rdm0sDQorCQkgICAgICZ2Y3B1LT5hcmNoLnB2X3RpbWUsIGRhdGEgJiB+MVVMTCwN
CisJCSAgICAgc2l6ZW9mKHN0cnVjdCBwdmNsb2NrX3ZjcHVfdGltZV9pbmZvKSkpDQorCQkJdmNw
dS0+YXJjaC5wdl90aW1lX2VuYWJsZWQgPSBmYWxzZTsNCisJCWVsc2UNCisJCQl2Y3B1LT5hcmNo
LnB2X3RpbWVfZW5hYmxlZCA9IHRydWU7DQogCQlicmVhazsNCiAJfQ0KIAljYXNlIE1TUl9LVk1f
QVNZTkNfUEZfRU46DQpAQCAtMTYyNSw3ICsxNjE2LDggQEAgaW50IGt2bV9zZXRfbXNyX2NvbW1v
bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBtc3IsIHU2NCBkYXRhKQ0KIAkJCXJldHVybiAx
Ow0KIA0KIAkJaWYgKGt2bV9nZm5fdG9faHZhX2NhY2hlX2luaXQodmNwdS0+a3ZtLCAmdmNwdS0+
YXJjaC5zdC5zdGltZSwNCi0JCQkJCQkJZGF0YSAmIEtWTV9TVEVBTF9WQUxJRF9CSVRTKSkNCisJ
CQkJCQlkYXRhICYgS1ZNX1NURUFMX1ZBTElEX0JJVFMsDQorCQkJCQkJc2l6ZW9mKHN0cnVjdCBr
dm1fc3RlYWxfdGltZSkpKQ0KIAkJCXJldHVybiAxOw0KIA0KIAkJdmNwdS0+YXJjaC5zdC5tc3Jf
dmFsID0gZGF0YTsNCkBAIC02NTQ5LDYgKzY1NDEsNyBAQCBpbnQga3ZtX2FyY2hfdmNwdV9pbml0
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiAJaWYgKCF6YWxsb2NfY3B1bWFza192YXIoJnZjcHUt
PmFyY2gud2JpbnZkX2RpcnR5X21hc2ssIEdGUF9LRVJORUwpKQ0KIAkJZ290byBmYWlsX2ZyZWVf
bWNlX2JhbmtzOw0KIA0KKwl2Y3B1LT5hcmNoLnB2X3RpbWVfZW5hYmxlZCA9IGZhbHNlOw0KIAlr
dm1fYXN5bmNfcGZfaGFzaF9yZXNldCh2Y3B1KTsNCiANCiAJcmV0dXJuIDA7DQpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvbGd1ZXN0L2Jvb3QuYyBiL2FyY2gveDg2L2xndWVzdC9ib290LmMNCmluZGV4
IGNmNDYwM2IuLjhmNGZkYTQgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9sZ3Vlc3QvYm9vdC5jDQor
KysgYi9hcmNoL3g4Ni9sZ3Vlc3QvYm9vdC5jDQpAQCAtMTMyOCw2ICsxMzI4LDcgQEAgX19pbml0
IHZvaWQgbGd1ZXN0X2luaXQodm9pZCkNCiAJcHZfbW11X29wcy5yZWFkX2NyMyA9IGxndWVzdF9y
ZWFkX2NyMzsNCiAJcHZfbW11X29wcy5sYXp5X21vZGUuZW50ZXIgPSBwYXJhdmlydF9lbnRlcl9s
YXp5X21tdTsNCiAJcHZfbW11X29wcy5sYXp5X21vZGUubGVhdmUgPSBsZ3Vlc3RfbGVhdmVfbGF6
eV9tbXVfbW9kZTsNCisJcHZfbW11X29wcy5sYXp5X21vZGUuZmx1c2ggPSBwYXJhdmlydF9mbHVz
aF9sYXp5X21tdTsNCiAJcHZfbW11X29wcy5wdGVfdXBkYXRlID0gbGd1ZXN0X3B0ZV91cGRhdGU7
DQogCXB2X21tdV9vcHMucHRlX3VwZGF0ZV9kZWZlciA9IGxndWVzdF9wdGVfdXBkYXRlOw0KIA0K
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2ZhdWx0LmMgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jDQpp
bmRleCA3YjczYzg4Li41M2E3YjY5IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvbW0vZmF1bHQuYw0K
KysrIGIvYXJjaC94ODYvbW0vZmF1bHQuYw0KQEAgLTM3NywxMCArMzc3LDEyIEBAIHN0YXRpYyBu
b2lubGluZSBfX2twcm9iZXMgaW50IHZtYWxsb2NfZmF1bHQodW5zaWduZWQgbG9uZyBhZGRyZXNz
KQ0KIAlpZiAocGdkX25vbmUoKnBnZF9yZWYpKQ0KIAkJcmV0dXJuIC0xOw0KIA0KLQlpZiAocGdk
X25vbmUoKnBnZCkpDQorCWlmIChwZ2Rfbm9uZSgqcGdkKSkgew0KIAkJc2V0X3BnZChwZ2QsICpw
Z2RfcmVmKTsNCi0JZWxzZQ0KKwkJYXJjaF9mbHVzaF9sYXp5X21tdV9tb2RlKCk7DQorCX0gZWxz
ZSB7DQogCQlCVUdfT04ocGdkX3BhZ2VfdmFkZHIoKnBnZCkgIT0gcGdkX3BhZ2VfdmFkZHIoKnBn
ZF9yZWYpKTsNCisJfQ0KIA0KIAkvKg0KIAkgKiBCZWxvdyBoZXJlIG1pc21hdGNoZXMgYXJlIGJ1
Z3MgYmVjYXVzZSB0aGVzZSBsb3dlciB0YWJsZXMNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4v
bW11LmMgYi9hcmNoL3g4Ni94ZW4vbW11LmMNCmluZGV4IDJiOGIwZGUuLmZlMDBiZTY5IDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYveGVuL21tdS5jDQorKysgYi9hcmNoL3g4Ni94ZW4vbW11LmMNCkBA
IC0yMDc5LDYgKzIwNzksNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHB2X21tdV9vcHMgeGVuX21t
dV9vcHMgX19pbml0Y29uc3QgPSB7DQogCS5sYXp5X21vZGUgPSB7DQogCQkuZW50ZXIgPSBwYXJh
dmlydF9lbnRlcl9sYXp5X21tdSwNCiAJCS5sZWF2ZSA9IHhlbl9sZWF2ZV9sYXp5X21tdSwNCisJ
CS5mbHVzaCA9IHBhcmF2aXJ0X2ZsdXNoX2xhenlfbW11LA0KIAl9LA0KIA0KIAkuc2V0X2ZpeG1h
cCA9IHhlbl9zZXRfZml4bWFwLA0KZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1zeXNmcy5jIGIvYmxv
Y2svYmxrLXN5c2ZzLmMNCmluZGV4IGYwYjJjYTguLjE3ODllN2EgMTAwNjQ0DQotLS0gYS9ibG9j
ay9ibGstc3lzZnMuYw0KKysrIGIvYmxvY2svYmxrLXN5c2ZzLmMNCkBAIC0yMDAsNiArMjAwLDgg
QEAgcXVldWVfc3RvcmVfIyNuYW1lKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBjb25zdCBjaGFy
ICpwYWdlLCBzaXplX3QgY291bnQpIFwNCiAJdW5zaWduZWQgbG9uZyB2YWw7CQkJCQkJXA0KIAlz
c2l6ZV90IHJldDsJCQkJCQkJXA0KIAlyZXQgPSBxdWV1ZV92YXJfc3RvcmUoJnZhbCwgcGFnZSwg
Y291bnQpOwkJCVwNCisJaWYgKHJldCA8IDApCQkJCQkJCVwNCisJCSByZXR1cm4gcmV0OwkJCQkJ
CVwNCiAJaWYgKG5lZykJCQkJCQkJXA0KIAkJdmFsID0gIXZhbDsJCQkJCQlcDQogCQkJCQkJCQkJ
XA0KZGlmZiAtLWdpdCBhL2NyeXB0by9nY20uYyBiL2NyeXB0by9nY20uYw0KaW5kZXggMWEyNTI2
My4uYjk3YjE4NiAxMDA2NDQNCi0tLSBhL2NyeXB0by9nY20uYw0KKysrIGIvY3J5cHRvL2djbS5j
DQpAQCAtNDQsNiArNDQsNyBAQCBzdHJ1Y3QgY3J5cHRvX3JmYzQ1NDNfY3R4IHsNCiANCiBzdHJ1
Y3QgY3J5cHRvX3JmYzQ1NDNfcmVxX2N0eCB7DQogCXU4IGF1dGhfdGFnWzE2XTsNCisJdTggYXNz
b2NidWZbMzJdOw0KIAlzdHJ1Y3Qgc2NhdHRlcmxpc3QgY2lwaGVyWzFdOw0KIAlzdHJ1Y3Qgc2Nh
dHRlcmxpc3QgcGF5bG9hZFsyXTsNCiAJc3RydWN0IHNjYXR0ZXJsaXN0IGFzc29jWzJdOw0KQEAg
LTExNDIsOSArMTE0MywxOSBAQCBzdGF0aWMgc3RydWN0IGFlYWRfcmVxdWVzdCAqY3J5cHRvX3Jm
YzQ1NDNfY3J5cHQoc3RydWN0IGFlYWRfcmVxdWVzdCAqcmVxLA0KIAlzY2F0dGVyd2Fsa19jcnlw
dG9fY2hhaW4ocGF5bG9hZCwgZHN0LCB2ZHN0ID09IHJlcS0+aXYgKyA4LCAyKTsNCiAJYXNzb2Ns
ZW4gKz0gOCArIHJlcS0+Y3J5cHRsZW4gLSAoZW5jID8gMCA6IGF1dGhzaXplKTsNCiANCi0Jc2df
aW5pdF90YWJsZShhc3NvYywgMik7DQotCXNnX3NldF9wYWdlKGFzc29jLCBzZ19wYWdlKHJlcS0+
YXNzb2MpLCByZXEtPmFzc29jLT5sZW5ndGgsDQotCQkgICAgcmVxLT5hc3NvYy0+b2Zmc2V0KTsN
CisJaWYgKHJlcS0+YXNzb2MtPmxlbmd0aCA9PSByZXEtPmFzc29jbGVuKSB7DQorCQlzZ19pbml0
X3RhYmxlKGFzc29jLCAyKTsNCisJCXNnX3NldF9wYWdlKGFzc29jLCBzZ19wYWdlKHJlcS0+YXNz
b2MpLCByZXEtPmFzc29jLT5sZW5ndGgsDQorCQkJICAgIHJlcS0+YXNzb2MtPm9mZnNldCk7DQor
CX0gZWxzZSB7DQorCQlCVUdfT04ocmVxLT5hc3NvY2xlbiA+IHNpemVvZihyY3R4LT5hc3NvY2J1
ZikpOw0KKw0KKwkJc2NhdHRlcndhbGtfbWFwX2FuZF9jb3B5KHJjdHgtPmFzc29jYnVmLCByZXEt
PmFzc29jLCAwLA0KKwkJCQkJIHJlcS0+YXNzb2NsZW4sIDApOw0KKw0KKwkJc2dfaW5pdF90YWJs
ZShhc3NvYywgMik7DQorCQlzZ19zZXRfYnVmKGFzc29jLCByY3R4LT5hc3NvY2J1ZiwgcmVxLT5h
c3NvY2xlbik7DQorCX0NCiAJc2NhdHRlcndhbGtfY3J5cHRvX2NoYWluKGFzc29jLCBwYXlsb2Fk
LCAwLCAyKTsNCiANCiAJYWVhZF9yZXF1ZXN0X3NldF90Zm0oc3VicmVxLCBjdHgtPmNoaWxkKTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9hdGFfcGlpeC5jIGIvZHJpdmVycy9hdGEvYXRhX3Bp
aXguYw0KaW5kZXggZGY0NzM5Ny4uZGRmYzFjMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRhL2F0
YV9waWl4LmMNCisrKyBiL2RyaXZlcnMvYXRhL2F0YV9waWl4LmMNCkBAIC0xNTAsNiArMTUwLDcg
QEAgZW51bSBwaWl4X2NvbnRyb2xsZXJfaWRzIHsNCiAJdG9sYXBhaV9zYXRhLA0KIAlwaWl4X3Bh
dGFfdm13LAkJCS8qIFBJSVg0IGZvciBWTXdhcmUsIHNwdXJpb3VzIERNQV9FUlIgKi8NCiAJaWNo
OF9zYXRhX3NuYiwNCisJaWNoOF8ycG9ydF9zYXRhX3NuYiwNCiB9Ow0KIA0KIHN0cnVjdCBwaWl4
X21hcF9kYiB7DQpAQCAtMzI2LDcgKzMyNyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpX2Rl
dmljZV9pZCBwaWl4X3BjaV90YmxbXSA9IHsNCiAJLyogU0FUQSBDb250cm9sbGVyIElERSAoTHlu
eCBQb2ludCkgKi8NCiAJeyAweDgwODYsIDB4OGMwMSwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgaWNoOF9zYXRhX3NuYiB9LA0KIAkvKiBTQVRBIENvbnRyb2xsZXIgSURFIChMeW54IFBv
aW50KSAqLw0KLQl7IDB4ODA4NiwgMHg4YzA4LCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAw
LCBpY2g4XzJwb3J0X3NhdGEgfSwNCisJeyAweDgwODYsIDB4OGMwOCwgUENJX0FOWV9JRCwgUENJ
X0FOWV9JRCwgMCwgMCwgaWNoOF8ycG9ydF9zYXRhX3NuYiB9LA0KIAkvKiBTQVRBIENvbnRyb2xs
ZXIgSURFIChMeW54IFBvaW50KSAqLw0KIAl7IDB4ODA4NiwgMHg4YzA5LCBQQ0lfQU5ZX0lELCBQ
Q0lfQU5ZX0lELCAwLCAwLCBpY2g4XzJwb3J0X3NhdGEgfSwNCiAJLyogU0FUQSBDb250cm9sbGVy
IElERSAoTHlueCBQb2ludC1MUCkgKi8NCkBAIC01MTksNiArNTIwLDcgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCBwaWl4X21hcF9kYiAqcGlpeF9tYXBfZGJfdGFibGVbXSA9IHsNCiAJW2ljaDhtX2Fw
cGxlX3NhdGFdCT0gJmljaDhtX2FwcGxlX21hcF9kYiwNCiAJW3RvbGFwYWlfc2F0YV0JCT0gJnRv
bGFwYWlfbWFwX2RiLA0KIAlbaWNoOF9zYXRhX3NuYl0JCT0gJmljaDhfbWFwX2RiLA0KKwlbaWNo
OF8ycG9ydF9zYXRhX3NuYl0JPSAmaWNoOF8ycG9ydF9tYXBfZGIsDQogfTsNCiANCiBzdGF0aWMg
c3RydWN0IGF0YV9wb3J0X2luZm8gcGlpeF9wb3J0X2luZm9bXSA9IHsNCkBAIC02NjAsNiArNjYy
LDE2IEBAIHN0YXRpYyBzdHJ1Y3QgYXRhX3BvcnRfaW5mbyBwaWl4X3BvcnRfaW5mb1tdID0gew0K
IAkJLnBvcnRfb3BzCT0gJnBpaXhfc2F0YV9vcHMsDQogCX0sDQogDQorCVtpY2g4XzJwb3J0X3Nh
dGFfc25iXSA9DQorCXsNCisJCS5mbGFncwkJPSBQSUlYX1NBVEFfRkxBR1MgfCBQSUlYX0ZMQUdf
U0lEUFINCisJCQkJCXwgUElJWF9GTEFHX1BJTzE2LA0KKwkJLnBpb19tYXNrCT0gQVRBX1BJTzQs
DQorCQkubXdkbWFfbWFzawk9IEFUQV9NV0RNQTIsDQorCQkudWRtYV9tYXNrCT0gQVRBX1VETUE2
LA0KKwkJLnBvcnRfb3BzCT0gJnBpaXhfc2F0YV9vcHMsDQorCX0sDQorDQogfTsNCiANCiBzdGF0
aWMgc3RydWN0IHBjaV9iaXRzIHBpaXhfZW5hYmxlX2JpdHNbXSA9IHsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2F0YS9saWJhdGEtY29yZS5jIGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYw0KaW5k
ZXggYzk1NDBjMC4uMjg4YjYzNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3Jl
LmMNCisrKyBiL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMNCkBAIC0yNDAxLDYgKzI0MDEsOSBA
QCBpbnQgYXRhX2Rldl9jb25maWd1cmUoc3RydWN0IGF0YV9kZXZpY2UgKmRldikNCiAJCWRldi0+
bWF4X3NlY3RvcnMgPSBtaW5fdCh1bnNpZ25lZCBpbnQsIEFUQV9NQVhfU0VDVE9SU18xMjgsDQog
CQkJCQkgZGV2LT5tYXhfc2VjdG9ycyk7DQogDQorCWlmIChkZXYtPmhvcmthZ2UgJiBBVEFfSE9S
S0FHRV9NQVhfU0VDX0xCQTQ4KQ0KKwkJZGV2LT5tYXhfc2VjdG9ycyA9IEFUQV9NQVhfU0VDVE9S
U19MQkE0ODsNCisNCiAJaWYgKGFwLT5vcHMtPmRldl9jb25maWcpDQogCQlhcC0+b3BzLT5kZXZf
Y29uZmlnKGRldik7DQogDQpAQCAtNDA1Nyw2ICs0MDYwLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVj
dCBhdGFfYmxhY2tsaXN0X2VudHJ5IGF0YV9kZXZpY2VfYmxhY2tsaXN0IFtdID0gew0KIAkvKiBX
ZWlyZCBBVEFQSSBkZXZpY2VzICovDQogCXsgIlRPUmlTQU4gRFZELVJPTSBEUkQtTjIxNiIsIE5V
TEwsCUFUQV9IT1JLQUdFX01BWF9TRUNfMTI4IH0sDQogCXsgIlFVQU5UVU0gREFUICAgIERBVDcy
LTAwMCIsIE5VTEwsCUFUQV9IT1JLQUdFX0FUQVBJX01PRDE2X0RNQSB9LA0KKwl7ICJTbGltdHlw
ZSBEVkQgQSAgRFM4QThTSCIsIE5VTEwsCUFUQV9IT1JLQUdFX01BWF9TRUNfTEJBNDggfSwNCiAN
CiAJLyogRGV2aWNlcyB3ZSBleHBlY3QgdG8gZmFpbCBkaWFnbm9zdGljcyAqLw0KIA0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmggYi9kcml2ZXJzL2dwdS9kcm0v
aTkxNS9pOTE1X2Rydi5oDQppbmRleCAwMTJhOWQyLi4xNDRkMzdjIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaA0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUv
aTkxNV9kcnYuaA0KQEAgLTI3NCw2ICsyNzQsNyBAQCBlbnVtIGludGVsX3BjaCB7DQogDQogI2Rl
ZmluZSBRVUlSS19QSVBFQV9GT1JDRSAoMTw8MCkNCiAjZGVmaW5lIFFVSVJLX0xWRFNfU1NDX0RJ
U0FCTEUgKDE8PDEpDQorI2RlZmluZSBRVUlSS19JTlZFUlRfQlJJR0hUTkVTUyAoMTw8MikNCiAN
CiBzdHJ1Y3QgaW50ZWxfZmJkZXY7DQogc3RydWN0IGludGVsX2ZiY193b3JrOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYyBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KaW5kZXggMTc5NjFkZi4uODk3Y2EwNiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KKysrIGIvZHJpdmVycy9n
cHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jDQpAQCAtMjUsNiArMjUsNyBAQA0KICAqLw0KIA0K
ICNpbmNsdWRlIDxsaW51eC9jcHVmcmVxLmg+DQorI2luY2x1ZGUgPGxpbnV4L2RtaS5oPg0KICNp
bmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvaW5wdXQuaD4NCiAjaW5j
bHVkZSA8bGludXgvaTJjLmg+DQpAQCAtODgzMSw2ICs4ODMyLDE2IEBAIHN0YXRpYyB2b2lkIHF1
aXJrX3NzY19mb3JjZV9kaXNhYmxlKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogCWRldl9wcml2
LT5xdWlya3MgfD0gUVVJUktfTFZEU19TU0NfRElTQUJMRTsNCiB9DQogDQorLyoNCisgKiBBIG1h
Y2hpbmUgKGUuZy4gQWNlciBBc3BpcmUgNTczNFopIG1heSBuZWVkIHRvIGludmVydCB0aGUgcGFu
ZWwgYmFja2xpZ2h0DQorICogYnJpZ2h0bmVzcyB2YWx1ZQ0KKyAqLw0KK3N0YXRpYyB2b2lkIHF1
aXJrX2ludmVydF9icmlnaHRuZXNzKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQorew0KKwlzdHJ1
Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYgPSBkZXYtPmRldl9wcml2YXRlOw0KKwlkZXZf
cHJpdi0+cXVpcmtzIHw9IFFVSVJLX0lOVkVSVF9CUklHSFRORVNTOw0KK30NCisNCiBzdHJ1Y3Qg
aW50ZWxfcXVpcmsgew0KIAlpbnQgZGV2aWNlOw0KIAlpbnQgc3Vic3lzdGVtX3ZlbmRvcjsNCkBA
IC04ODM4LDYgKzg4NDksMzQgQEAgc3RydWN0IGludGVsX3F1aXJrIHsNCiAJdm9pZCAoKmhvb2sp
KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpOw0KIH07DQogDQorLyogRm9yIHN5c3RlbXMgdGhhdCBk
b24ndCBoYXZlIGEgbWVhbmluZ2Z1bCBQQ0kgc3ViZGV2aWNlL3N1YnZlbmRvciBJRCAqLw0KK3N0
cnVjdCBpbnRlbF9kbWlfcXVpcmsgew0KKwl2b2lkICgqaG9vaykoc3RydWN0IGRybV9kZXZpY2Ug
KmRldik7DQorCWNvbnN0IHN0cnVjdCBkbWlfc3lzdGVtX2lkICgqZG1pX2lkX2xpc3QpW107DQor
fTsNCisNCitzdGF0aWMgaW50IGludGVsX2RtaV9yZXZlcnNlX2JyaWdodG5lc3MoY29uc3Qgc3Ry
dWN0IGRtaV9zeXN0ZW1faWQgKmlkKQ0KK3sNCisJRFJNX0lORk8oIkJhY2tsaWdodCBwb2xhcml0
eSByZXZlcnNlZCBvbiAlc1xuIiwgaWQtPmlkZW50KTsNCisJcmV0dXJuIDE7DQorfQ0KKw0KK3N0
YXRpYyBjb25zdCBzdHJ1Y3QgaW50ZWxfZG1pX3F1aXJrIGludGVsX2RtaV9xdWlya3NbXSA9IHsN
CisJew0KKwkJLmRtaV9pZF9saXN0ID0gJihjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZFtdKSB7
DQorCQkJew0KKwkJCQkuY2FsbGJhY2sgPSBpbnRlbF9kbWlfcmV2ZXJzZV9icmlnaHRuZXNzLA0K
KwkJCQkuaWRlbnQgPSAiTkNSIENvcnBvcmF0aW9uIiwNCisJCQkJLm1hdGNoZXMgPSB7RE1JX01B
VENIKERNSV9TWVNfVkVORE9SLCAiTkNSIENvcnBvcmF0aW9uIiksDQorCQkJCQkgICAgRE1JX01B
VENIKERNSV9QUk9EVUNUX05BTUUsICIiKSwNCisJCQkJfSwNCisJCQl9LA0KKwkJCXsgfSAgLyog
dGVybWluYXRpbmcgZW50cnkgKi8NCisJCX0sDQorCQkuaG9vayA9IHF1aXJrX2ludmVydF9icmln
aHRuZXNzLA0KKwl9LA0KK307DQorDQogc3RydWN0IGludGVsX3F1aXJrIGludGVsX3F1aXJrc1td
ID0gew0KIAkvKiBIUCBDb21wYXEgMjczMHAgbmVlZHMgcGlwZSBBIGZvcmNlIHF1aXJrIChMUDog
IzI5MTU1NSkgKi8NCiAJeyAweDJhNDIsIDB4MTAzYywgMHgzMGViLCBxdWlya19waXBlYV9mb3Jj
ZSB9LA0KQEAgLTg4NjUsNiArODkwNCwxOCBAQCBzdHJ1Y3QgaW50ZWxfcXVpcmsgaW50ZWxfcXVp
cmtzW10gPSB7DQogDQogCS8qIFNvbnkgVmFpbyBZIGNhbm5vdCB1c2UgU1NDIG9uIExWRFMgKi8N
CiAJeyAweDAwNDYsIDB4MTA0ZCwgMHg5MDc2LCBxdWlya19zc2NfZm9yY2VfZGlzYWJsZSB9LA0K
Kw0KKwkvKiBBY2VyIEFzcGlyZSA1NzM0WiBtdXN0IGludmVydCBiYWNrbGlnaHQgYnJpZ2h0bmVz
cyAqLw0KKwl7IDB4MmE0MiwgMHgxMDI1LCAweDA0NTksIHF1aXJrX2ludmVydF9icmlnaHRuZXNz
IH0sDQorDQorCS8qIEFjZXIvZU1hY2hpbmVzIEc3MjUgKi8NCisJeyAweDJhNDIsIDB4MTAyNSwg
MHgwMjEwLCBxdWlya19pbnZlcnRfYnJpZ2h0bmVzcyB9LA0KKw0KKwkvKiBBY2VyL2VNYWNoaW5l
cyBlNzI1ICovDQorCXsgMHgyYTQyLCAweDEwMjUsIDB4MDIxMiwgcXVpcmtfaW52ZXJ0X2JyaWdo
dG5lc3MgfSwNCisNCisJLyogQWNlci9QYWNrYXJkIEJlbGwgTkNMMjAgKi8NCisJeyAweDJhNDIs
IDB4MTAyNSwgMHgwMzRiLCBxdWlya19pbnZlcnRfYnJpZ2h0bmVzcyB9LA0KIH07DQogDQogc3Rh
dGljIHZvaWQgaW50ZWxfaW5pdF9xdWlya3Moc3RydWN0IGRybV9kZXZpY2UgKmRldikNCkBAIC04
ODgyLDYgKzg5MzMsMTAgQEAgc3RhdGljIHZvaWQgaW50ZWxfaW5pdF9xdWlya3Moc3RydWN0IGRy
bV9kZXZpY2UgKmRldikNCiAJCSAgICAgcS0+c3Vic3lzdGVtX2RldmljZSA9PSBQQ0lfQU5ZX0lE
KSkNCiAJCQlxLT5ob29rKGRldik7DQogCX0NCisJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUo
aW50ZWxfZG1pX3F1aXJrcyk7IGkrKykgew0KKwkJaWYgKGRtaV9jaGVja19zeXN0ZW0oKmludGVs
X2RtaV9xdWlya3NbaV0uZG1pX2lkX2xpc3QpICE9IDApDQorCQkJaW50ZWxfZG1pX3F1aXJrc1tp
XS5ob29rKGRldik7DQorCX0NCiB9DQogDQogLyogRGlzYWJsZSB0aGUgVkdBIHBsYW5lIHRoYXQg
d2UgbmV2ZXIgdXNlICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxf
cGFuZWwuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3BhbmVsLmMNCmluZGV4IDA0ZDc5
ZmQuLjcyYjg5NDkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9wYW5l
bC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9wYW5lbC5jDQpAQCAtMjgsNiAr
MjgsNyBAQA0KICAqICAgICAgQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJpcy13aWxzb24uY28udWs+
DQogICovDQogDQorI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFtLmg+DQogI2luY2x1ZGUgImlu
dGVsX2Rydi5oIg0KIA0KICNkZWZpbmUgUENJX0xCUEMgMHhmNCAvKiBsZWdhY3kvY29tYmluYXRp
b24gYmFja2xpZ2h0IG1vZGVzICovDQpAQCAtMTkxLDYgKzE5MiwyNyBAQCB1MzIgaW50ZWxfcGFu
ZWxfZ2V0X21heF9iYWNrbGlnaHQoc3RydWN0IGRybV9kZXZpY2UgKmRldikNCiAJcmV0dXJuIG1h
eDsNCiB9DQogDQorc3RhdGljIGludCBpOTE1X3BhbmVsX2ludmVydF9icmlnaHRuZXNzOw0KK01P
RFVMRV9QQVJNX0RFU0MoaW52ZXJ0X2JyaWdodG5lc3MsICJJbnZlcnQgYmFja2xpZ2h0IGJyaWdo
dG5lc3MgIg0KKwkiKC0xIGZvcmNlIG5vcm1hbCwgMCBtYWNoaW5lIGRlZmF1bHRzLCAxIGZvcmNl
IGludmVyc2lvbiksIHBsZWFzZSAiDQorCSJyZXBvcnQgUENJIGRldmljZSBJRCwgc3Vic3lzdGVt
IHZlbmRvciBhbmQgc3Vic3lzdGVtIGRldmljZSBJRCAiDQorCSJ0byBkcmktZGV2ZWxAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnLCBpZiB5b3VyIG1hY2hpbmUgbmVlZHMgaXQuICINCisJIkl0IHdpbGwg
dGhlbiBiZSBpbmNsdWRlZCBpbiBhbiB1cGNvbWluZyBtb2R1bGUgdmVyc2lvbi4iKTsNCittb2R1
bGVfcGFyYW1fbmFtZWQoaW52ZXJ0X2JyaWdodG5lc3MsIGk5MTVfcGFuZWxfaW52ZXJ0X2JyaWdo
dG5lc3MsIGludCwgMDYwMCk7DQorc3RhdGljIHUzMiBpbnRlbF9wYW5lbF9jb21wdXRlX2JyaWdo
dG5lc3Moc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdTMyIHZhbCkNCit7DQorCXN0cnVjdCBkcm1f
aTkxNV9wcml2YXRlICpkZXZfcHJpdiA9IGRldi0+ZGV2X3ByaXZhdGU7DQorDQorCWlmIChpOTE1
X3BhbmVsX2ludmVydF9icmlnaHRuZXNzIDwgMCkNCisJCXJldHVybiB2YWw7DQorDQorCWlmIChp
OTE1X3BhbmVsX2ludmVydF9icmlnaHRuZXNzID4gMCB8fA0KKwkgICAgZGV2X3ByaXYtPnF1aXJr
cyAmIFFVSVJLX0lOVkVSVF9CUklHSFRORVNTKQ0KKwkJcmV0dXJuIGludGVsX3BhbmVsX2dldF9t
YXhfYmFja2xpZ2h0KGRldikgLSB2YWw7DQorDQorCXJldHVybiB2YWw7DQorfQ0KKw0KIHUzMiBp
bnRlbF9wYW5lbF9nZXRfYmFja2xpZ2h0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogew0KIAlz
dHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYgPSBkZXYtPmRldl9wcml2YXRlOw0KQEAg
LTIxMSw2ICsyMzMsNyBAQCB1MzIgaW50ZWxfcGFuZWxfZ2V0X2JhY2tsaWdodChzdHJ1Y3QgZHJt
X2RldmljZSAqZGV2KQ0KIAkJfQ0KIAl9DQogDQorCXZhbCA9IGludGVsX3BhbmVsX2NvbXB1dGVf
YnJpZ2h0bmVzcyhkZXYsIHZhbCk7DQogCURSTV9ERUJVR19EUklWRVIoImdldCBiYWNrbGlnaHQg
UFdNID0gJWRcbiIsIHZhbCk7DQogCXJldHVybiB2YWw7DQogfQ0KQEAgLTIyOCw2ICsyNTEsNyBA
QCBzdGF0aWMgdm9pZCBpbnRlbF9wYW5lbF9hY3R1YWxseV9zZXRfYmFja2xpZ2h0KHN0cnVjdCBk
cm1fZGV2aWNlICpkZXYsIHUzMiBsZXZlbA0KIAl1MzIgdG1wOw0KIA0KIAlEUk1fREVCVUdfRFJJ
VkVSKCJzZXQgYmFja2xpZ2h0IFBXTSA9ICVkXG4iLCBsZXZlbCk7DQorCWxldmVsID0gaW50ZWxf
cGFuZWxfY29tcHV0ZV9icmlnaHRuZXNzKGRldiwgbGV2ZWwpOw0KIA0KIAlpZiAoSEFTX1BDSF9T
UExJVChkZXYpKQ0KIAkJcmV0dXJuIGludGVsX3BjaF9wYW5lbF9zZXRfYmFja2xpZ2h0KGRldiwg
bGV2ZWwpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L3ZnYS92Z2Ffc3dpdGNoZXJvby5jIGIv
ZHJpdmVycy9ncHUvdmdhL3ZnYV9zd2l0Y2hlcm9vLmMNCmluZGV4IDU4NDM0ZTguLjM3ZmUyNDYg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS92Z2EvdmdhX3N3aXRjaGVyb28uYw0KKysrIGIvZHJp
dmVycy9ncHUvdmdhL3ZnYV9zd2l0Y2hlcm9vLmMNCkBAIC0yNiw2ICsyNiw3IEBADQogI2luY2x1
ZGUgPGxpbnV4L2ZiLmg+DQogDQogI2luY2x1ZGUgPGxpbnV4L3BjaS5oPg0KKyNpbmNsdWRlIDxs
aW51eC9jb25zb2xlLmg+DQogI2luY2x1ZGUgPGxpbnV4L3ZnYV9zd2l0Y2hlcm9vLmg+DQogDQog
c3RydWN0IHZnYV9zd2l0Y2hlcm9vX2NsaWVudCB7DQpAQCAtMjU2LDggKzI1NywxMCBAQCBzdGF0
aWMgaW50IHZnYV9zd2l0Y2h0b19zdGFnZTIoc3RydWN0IHZnYV9zd2l0Y2hlcm9vX2NsaWVudCAq
bmV3X2NsaWVudCkNCiANCiAJaWYgKG5ld19jbGllbnQtPmZiX2luZm8pIHsNCiAJCXN0cnVjdCBm
Yl9ldmVudCBldmVudDsNCisJCWNvbnNvbGVfbG9jaygpOw0KIAkJZXZlbnQuaW5mbyA9IG5ld19j
bGllbnQtPmZiX2luZm87DQogCQlmYl9ub3RpZmllcl9jYWxsX2NoYWluKEZCX0VWRU5UX1JFTUFQ
X0FMTF9DT05TT0xFLCAmZXZlbnQpOw0KKwkJY29uc29sZV91bmxvY2soKTsNCiAJfQ0KIA0KIAly
ZXQgPSB2Z2Fzcl9wcml2LmhhbmRsZXItPnN3aXRjaHRvKG5ld19jbGllbnQtPmlkKTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2h3c3BpbmxvY2svaHdzcGlubG9ja19jb3JlLmMgYi9kcml2ZXJzL2h3
c3BpbmxvY2svaHdzcGlubG9ja19jb3JlLmMNCmluZGV4IDEyMDFhMTUuLjA4ZTdlNzIgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2h3c3BpbmxvY2svaHdzcGlubG9ja19jb3JlLmMNCisrKyBiL2RyaXZl
cnMvaHdzcGlubG9jay9od3NwaW5sb2NrX2NvcmUuYw0KQEAgLTQxNiw2ICs0MTYsOCBAQCBzdGF0
aWMgaW50IF9faHdzcGluX2xvY2tfcmVxdWVzdChzdHJ1Y3QgaHdzcGlubG9jayAqaHdsb2NrKQ0K
IAlyZXQgPSBwbV9ydW50aW1lX2dldF9zeW5jKGRldik7DQogCWlmIChyZXQgPCAwKSB7DQogCQlk
ZXZfZXJyKGRldiwgIiVzOiBjYW4ndCBwb3dlciBvbiBkZXZpY2VcbiIsIF9fZnVuY19fKTsNCisJ
CXBtX3J1bnRpbWVfcHV0X25vaWRsZShkZXYpOw0KKwkJbW9kdWxlX3B1dChkZXYtPmRyaXZlci0+
b3duZXIpOw0KIAkJcmV0dXJuIHJldDsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbXRk
L210ZGNoYXIuYyBiL2RyaXZlcnMvbXRkL210ZGNoYXIuYw0KaW5kZXggZTdkYzczMi4uMWQ5MGUy
NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbXRkL210ZGNoYXIuYw0KKysrIGIvZHJpdmVycy9tdGQv
bXRkY2hhci5jDQpAQCAtMTE1NCw3ICsxMTU0LDExIEBAIHN0YXRpYyBpbnQgbXRkX21tYXAoc3Ry
dWN0IGZpbGUgKmZpbGUsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQ0KIAl1bnNpZ25lZCBs
b25nIG9mZjsNCiAJdTMyIGxlbjsNCiANCi0JaWYgKG10ZC0+dHlwZSA9PSBNVERfUkFNIHx8IG10
ZC0+dHlwZSA9PSBNVERfUk9NKSB7DQorICAgICAgICAvKiBUaGlzIGlzIGJyb2tlbiBiZWNhdXNl
IGl0IGFzc3VtZXMgdGhlIE1URCBkZXZpY2UgaXMgbWFwLWJhc2VkDQorCSAgIGFuZCB0aGF0IG10
ZC0+cHJpdiBpcyBhIHZhbGlkIHN0cnVjdCBtYXBfaW5mby4gIEl0IHNob3VsZCBiZQ0KKwkgICBy
ZXBsYWNlZCB3aXRoIHNvbWV0aGluZyB0aGF0IHVzZXMgdGhlIG10ZF9nZXRfdW5tYXBwZWRfYXJl
YSgpDQorCSAgIG9wZXJhdGlvbiBwcm9wZXJseS4gKi8NCisJaWYgKDAgLyptdGQtPnR5cGUgPT0g
TVREX1JBTSB8fCBtdGQtPnR5cGUgPT0gTVREX1JPTSovKSB7DQogCQlvZmYgPSB2bWEtPnZtX3Bn
b2ZmIDw8IFBBR0VfU0hJRlQ7DQogCQlzdGFydCA9IG1hcC0+cGh5czsNCiAJCWxlbiA9IFBBR0Vf
QUxJR04oKHN0YXJ0ICYgflBBR0VfTUFTSykgKyBtYXAtPnNpemUpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDBfb2ZfcGxhdGZvcm0uYyBiL2RyaXZlcnMvbmV0
L2Nhbi9zamExMDAwL3NqYTEwMDBfb2ZfcGxhdGZvcm0uYw0KaW5kZXggYzNkZDlkMC4uMWVlNWYw
YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDBfb2ZfcGxhdGZv
cm0uYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMF9vZl9wbGF0Zm9ybS5j
DQpAQCAtOTQsOCArOTQsOCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBzamExMDAwX29mcF9wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpvZmRldikNCiAJc3RydWN0IG5ldF9kZXZpY2UgKmRl
djsNCiAJc3RydWN0IHNqYTEwMDBfcHJpdiAqcHJpdjsNCiAJc3RydWN0IHJlc291cmNlIHJlczsN
Ci0JY29uc3QgdTMyICpwcm9wOw0KLQlpbnQgZXJyLCBpcnEsIHJlc19zaXplLCBwcm9wX3NpemU7
DQorCXUzMiBwcm9wOw0KKwlpbnQgZXJyLCBpcnEsIHJlc19zaXplOw0KIAl2b2lkIF9faW9tZW0g
KmJhc2U7DQogDQogCWVyciA9IG9mX2FkZHJlc3NfdG9fcmVzb3VyY2UobnAsIDAsICZyZXMpOw0K
QEAgLTEzNiwyNyArMTM2LDI3IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHNqYTEwMDBfb2ZwX3By
b2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKm9mZGV2KQ0KIAlwcml2LT5yZWFkX3JlZyA9IHNq
YTEwMDBfb2ZwX3JlYWRfcmVnOw0KIAlwcml2LT53cml0ZV9yZWcgPSBzamExMDAwX29mcF93cml0
ZV9yZWc7DQogDQotCXByb3AgPSBvZl9nZXRfcHJvcGVydHkobnAsICJueHAsZXh0ZXJuYWwtY2xv
Y2stZnJlcXVlbmN5IiwgJnByb3Bfc2l6ZSk7DQotCWlmIChwcm9wICYmIChwcm9wX3NpemUgPT0g
IHNpemVvZih1MzIpKSkNCi0JCXByaXYtPmNhbi5jbG9jay5mcmVxID0gKnByb3AgLyAyOw0KKwll
cnIgPSBvZl9wcm9wZXJ0eV9yZWFkX3UzMihucCwgIm54cCxleHRlcm5hbC1jbG9jay1mcmVxdWVu
Y3kiLCAmcHJvcCk7DQorCWlmICghZXJyKQ0KKwkJcHJpdi0+Y2FuLmNsb2NrLmZyZXEgPSBwcm9w
IC8gMjsNCiAJZWxzZQ0KIAkJcHJpdi0+Y2FuLmNsb2NrLmZyZXEgPSBTSkExMDAwX09GUF9DQU5f
Q0xPQ0s7IC8qIGRlZmF1bHQgKi8NCiANCi0JcHJvcCA9IG9mX2dldF9wcm9wZXJ0eShucCwgIm54
cCx0eC1vdXRwdXQtbW9kZSIsICZwcm9wX3NpemUpOw0KLQlpZiAocHJvcCAmJiAocHJvcF9zaXpl
ID09IHNpemVvZih1MzIpKSkNCi0JCXByaXYtPm9jciB8PSAqcHJvcCAmIE9DUl9NT0RFX01BU0s7
DQorCWVyciA9IG9mX3Byb3BlcnR5X3JlYWRfdTMyKG5wLCAibnhwLHR4LW91dHB1dC1tb2RlIiwg
JnByb3ApOw0KKwlpZiAoIWVycikNCisJCXByaXYtPm9jciB8PSBwcm9wICYgT0NSX01PREVfTUFT
SzsNCiAJZWxzZQ0KIAkJcHJpdi0+b2NyIHw9IE9DUl9NT0RFX05PUk1BTDsgLyogZGVmYXVsdCAq
Lw0KIA0KLQlwcm9wID0gb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibnhwLHR4LW91dHB1dC1jb25maWci
LCAmcHJvcF9zaXplKTsNCi0JaWYgKHByb3AgJiYgKHByb3Bfc2l6ZSA9PSBzaXplb2YodTMyKSkp
DQotCQlwcml2LT5vY3IgfD0gKCpwcm9wIDw8IE9DUl9UWF9TSElGVCkgJiBPQ1JfVFhfTUFTSzsN
CisJZXJyID0gb2ZfcHJvcGVydHlfcmVhZF91MzIobnAsICJueHAsdHgtb3V0cHV0LWNvbmZpZyIs
ICZwcm9wKTsNCisJaWYgKCFlcnIpDQorCQlwcml2LT5vY3IgfD0gKHByb3AgPDwgT0NSX1RYX1NI
SUZUKSAmIE9DUl9UWF9NQVNLOw0KIAllbHNlDQogCQlwcml2LT5vY3IgfD0gT0NSX1RYMF9QVUxM
RE9XTjsgLyogZGVmYXVsdCAqLw0KIA0KLQlwcm9wID0gb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibnhw
LGNsb2NrLW91dC1mcmVxdWVuY3kiLCAmcHJvcF9zaXplKTsNCi0JaWYgKHByb3AgJiYgKHByb3Bf
c2l6ZSA9PSBzaXplb2YodTMyKSkgJiYgKnByb3ApIHsNCi0JCXUzMiBkaXZpZGVyID0gcHJpdi0+
Y2FuLmNsb2NrLmZyZXEgKiAyIC8gKnByb3A7DQorCWVyciA9IG9mX3Byb3BlcnR5X3JlYWRfdTMy
KG5wLCAibnhwLGNsb2NrLW91dC1mcmVxdWVuY3kiLCAmcHJvcCk7DQorCWlmICghZXJyICYmIHBy
b3ApIHsNCisJCXUzMiBkaXZpZGVyID0gcHJpdi0+Y2FuLmNsb2NrLmZyZXEgKiAyIC8gcHJvcDsN
CiANCiAJCWlmIChkaXZpZGVyID4gMSkNCiAJCQlwcml2LT5jZHIgfD0gZGl2aWRlciAvIDIgLSAx
Ow0KQEAgLTE2Niw4ICsxNjYsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBzamExMDAwX29mcF9w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpvZmRldikNCiAJCXByaXYtPmNkciB8PSBDRFJf
Q0xLX09GRjsgLyogZGVmYXVsdCAqLw0KIAl9DQogDQotCXByb3AgPSBvZl9nZXRfcHJvcGVydHko
bnAsICJueHAsbm8tY29tcGFyYXRvci1ieXBhc3MiLCBOVUxMKTsNCi0JaWYgKCFwcm9wKQ0KKwlp
ZiAoIW9mX3Byb3BlcnR5X3JlYWRfYm9vbChucCwgIm54cCxuby1jb21wYXJhdG9yLWJ5cGFzcyIp
KQ0KIAkJcHJpdi0+Y2RyIHw9IENEUl9DQlA7IC8qIGRlZmF1bHQgKi8NCiANCiAJcHJpdi0+aXJx
X2ZsYWdzID0gSVJRRl9TSEFSRUQ7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVhbHRlay9yODE2OS5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OS5jDQpp
bmRleCBhNjE1M2YxLi5kODEyNzkwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVhbHRlay9yODE2OS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5
LmMNCkBAIC0zNTE2LDYgKzM1MTYsMzAgQEAgc3RhdGljIHZvaWQgX19kZXZpbml0IHJ0bF9pbml0
X21kaW9fb3BzKHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwKQ0KIAl9DQogfQ0KIA0KK3N0YXRp
YyB2b2lkIHJ0bF9zcGVlZF9kb3duKHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwKQ0KK3sNCisJ
dTMyIGFkdjsNCisJaW50IGxwYTsNCisNCisJcnRsX3dyaXRlcGh5KHRwLCAweDFmLCAweDAwMDAp
Ow0KKwlscGEgPSBydGxfcmVhZHBoeSh0cCwgTUlJX0xQQSk7DQorDQorCWlmIChscGEgJiAoTFBB
XzEwSEFMRiB8IExQQV8xMEZVTEwpKQ0KKwkJYWR2ID0gQURWRVJUSVNFRF8xMGJhc2VUX0hhbGYg
fCBBRFZFUlRJU0VEXzEwYmFzZVRfRnVsbDsNCisJZWxzZSBpZiAobHBhICYgKExQQV8xMDBIQUxG
IHwgTFBBXzEwMEZVTEwpKQ0KKwkJYWR2ID0gQURWRVJUSVNFRF8xMGJhc2VUX0hhbGYgfCBBRFZF
UlRJU0VEXzEwYmFzZVRfRnVsbCB8DQorCQkgICAgICBBRFZFUlRJU0VEXzEwMGJhc2VUX0hhbGYg
fCBBRFZFUlRJU0VEXzEwMGJhc2VUX0Z1bGw7DQorCWVsc2UNCisJCWFkdiA9IEFEVkVSVElTRURf
MTBiYXNlVF9IYWxmIHwgQURWRVJUSVNFRF8xMGJhc2VUX0Z1bGwgfA0KKwkJICAgICAgQURWRVJU
SVNFRF8xMDBiYXNlVF9IYWxmIHwgQURWRVJUSVNFRF8xMDBiYXNlVF9GdWxsIHwNCisJCSAgICAg
ICh0cC0+bWlpLnN1cHBvcnRzX2dtaWkgPw0KKwkJICAgICAgIEFEVkVSVElTRURfMTAwMGJhc2VU
X0hhbGYgfA0KKwkJICAgICAgIEFEVkVSVElTRURfMTAwMGJhc2VUX0Z1bGwgOiAwKTsNCisNCisJ
cnRsODE2OV9zZXRfc3BlZWQodHAtPmRldiwgQVVUT05FR19FTkFCTEUsIFNQRUVEXzEwMDAsIERV
UExFWF9GVUxMLA0KKwkJCSAgYWR2KTsNCit9DQorDQogc3RhdGljIHZvaWQgcnRsX3dvbF9zdXNw
ZW5kX3F1aXJrKHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwKQ0KIHsNCiAJdm9pZCBfX2lvbWVt
ICppb2FkZHIgPSB0cC0+bW1pb19hZGRyOw0KQEAgLTM1NDEsOSArMzU2NSw3IEBAIHN0YXRpYyBi
b29sIHJ0bF93b2xfcGxsX3Bvd2VyX2Rvd24oc3RydWN0IHJ0bDgxNjlfcHJpdmF0ZSAqdHApDQog
CWlmICghKF9fcnRsODE2OV9nZXRfd29sKHRwKSAmIFdBS0VfQU5ZKSkNCiAJCXJldHVybiBmYWxz
ZTsNCiANCi0JcnRsX3dyaXRlcGh5KHRwLCAweDFmLCAweDAwMDApOw0KLQlydGxfd3JpdGVwaHko
dHAsIE1JSV9CTUNSLCAweDAwMDApOw0KLQ0KKwlydGxfc3BlZWRfZG93bih0cCk7DQogCXJ0bF93
b2xfc3VzcGVuZF9xdWlyayh0cCk7DQogDQogCXJldHVybiB0cnVlOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjk1ODBfMXAwX2luaXR2YWxzLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXI5NTgwXzFwMF9pbml0dmFscy5oDQppbmRleCAw
NmIzZjBkLi5jMTZiZWE0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0
aDlrL2FyOTU4MF8xcDBfaW5pdHZhbHMuaA0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL2FyOTU4MF8xcDBfaW5pdHZhbHMuaA0KQEAgLTY0OCw3ICs2NDgsNyBAQCBzdGF0aWMg
Y29uc3QgdTMyIGFyOTU4MF8xcDBfbWFjX2NvcmVbXVsyXSA9IHsNCiAJezB4MDAwMDgyNTgsIDB4
MDAwMDAwMDB9LA0KIAl7MHgwMDAwODI1YywgMHg0MDAwMDAwMH0sDQogCXsweDAwMDA4MjYwLCAw
eDAwMDgwOTIyfSwNCi0JezB4MDAwMDgyNjQsIDB4OWJjMDAwMTB9LA0KKwl7MHgwMDAwODI2NCwg
MHg5ZDQwMDAxMH0sDQogCXsweDAwMDA4MjY4LCAweGZmZmZmZmZmfSwNCiAJezB4MDAwMDgyNmMs
IDB4MDAwMGZmZmZ9LA0KIAl7MHgwMDAwODI3MCwgMHgwMDAwMDAwMH0sDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h0Y19kcnZfaW5pdC5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h0Y19kcnZfaW5pdC5jDQppbmRleCA5NjY2NjFjLi44NDg5
MGQ1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2h0Y19kcnZf
aW5pdC5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2Rydl9pbml0
LmMNCkBAIC04MDEsNyArODAxLDcgQEAgc3RhdGljIGludCBhdGg5a19pbml0X2Zpcm13YXJlX3Zl
cnNpb24oc3RydWN0IGF0aDlrX2h0Y19wcml2ICpwcml2KQ0KIAkgKiByZXF1aXJlZCB2ZXJzaW9u
Lg0KIAkgKi8NCiAJaWYgKHByaXYtPmZ3X3ZlcnNpb25fbWFqb3IgIT0gTUFKT1JfVkVSU0lPTl9S
RVEgfHwNCi0JICAgIHByaXYtPmZ3X3ZlcnNpb25fbWlub3IgIT0gTUlOT1JfVkVSU0lPTl9SRVEp
IHsNCisJICAgIHByaXYtPmZ3X3ZlcnNpb25fbWlub3IgPCBNSU5PUl9WRVJTSU9OX1JFUSkgew0K
IAkJZGV2X2Vycihwcml2LT5kZXYsICJhdGg5a19odGM6IFBsZWFzZSB1cGdyYWRlIHRvIEZXIHZl
cnNpb24gJWQuJWRcbiIsDQogCQkJTUFKT1JfVkVSU0lPTl9SRVEsIE1JTk9SX1ZFUlNJT05fUkVR
KTsNCiAJCXJldHVybiAtRUlOVkFMOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3J0MngwMC9ydDJ4MDBwY2kuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDJ4MDBw
Y2kuYw0KaW5kZXggMTcxNDhiYi4uMTBmZTA3ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3J0MngwMC9ydDJ4MDBwY2kuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQy
eDAwL3J0MngwMHBjaS5jDQpAQCAtNTIsOCArNTIsOCBAQCBpbnQgcnQyeDAwcGNpX3JlZ2J1c3lf
cmVhZChzdHJ1Y3QgcnQyeDAwX2RldiAqcnQyeDAwZGV2LA0KIAkJdWRlbGF5KFJFR0lTVEVSX0JV
U1lfREVMQVkpOw0KIAl9DQogDQotCUVSUk9SKHJ0MngwMGRldiwgIkluZGlyZWN0IHJlZ2lzdGVy
IGFjY2VzcyBmYWlsZWQ6ICINCi0JICAgICAgIm9mZnNldD0weCUuMDh4LCB2YWx1ZT0weCUuMDh4
XG4iLCBvZmZzZXQsICpyZWcpOw0KKwlwcmludGtfb25jZShLRVJOX0VSUiAiJXMoKSBJbmRpcmVj
dCByZWdpc3RlciBhY2Nlc3MgZmFpbGVkOiAiDQorCSAgICAgICJvZmZzZXQ9MHglLjA4eCwgdmFs
dWU9MHglLjA4eFxuIiwgX19mdW5jX18sIG9mZnNldCwgKnJlZyk7DQogCSpyZWcgPSB+MDsNCiAN
CiAJcmV0dXJuIDA7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvbXNpLXdtaS5j
IGIvZHJpdmVycy9wbGF0Zm9ybS94ODYvbXNpLXdtaS5jDQppbmRleCAyMjY0MzMxLi5iOTY3NjZi
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvbXNpLXdtaS5jDQorKysgYi9kcml2
ZXJzL3BsYXRmb3JtL3g4Ni9tc2ktd21pLmMNCkBAIC0xNzYsNyArMTc2LDcgQEAgc3RhdGljIHZv
aWQgbXNpX3dtaV9ub3RpZnkodTMyIHZhbHVlLCB2b2lkICpjb250ZXh0KQ0KIAkJCQlwcl9kZWJ1
ZygiU3VwcHJlc3NlZCBrZXkgZXZlbnQgMHglWCAtICINCiAJCQkJCSAiTGFzdCBwcmVzcyB3YXMg
JWxsZCB1cyBhZ29cbiIsDQogCQkJCQkga2V5LT5jb2RlLCBrdGltZV90b191cyhkaWZmKSk7DQot
CQkJCXJldHVybjsNCisJCQkJZ290byBtc2lfd21pX25vdGlmeV9leGl0Ow0KIAkJCX0NCiAJCQls
YXN0X3ByZXNzZWRba2V5LT5jb2RlIC0gU0NBTkNPREVfQkFTRV0gPSBjdXI7DQogDQpAQCAtMTk1
LDYgKzE5NSw4IEBAIHN0YXRpYyB2b2lkIG1zaV93bWlfbm90aWZ5KHUzMiB2YWx1ZSwgdm9pZCAq
Y29udGV4dCkNCiAJCQlwcl9pbmZvKCJVbmtub3duIGtleSBwcmVzc2VkIC0gJXhcbiIsIGV2ZW50
Y29kZSk7DQogCX0gZWxzZQ0KIAkJcHJfaW5mbygiVW5rbm93biBldmVudCByZWNlaXZlZFxuIik7
DQorDQorbXNpX3dtaV9ub3RpZnlfZXhpdDoNCiAJa2ZyZWUocmVzcG9uc2UucG9pbnRlcik7DQog
fQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2FsdWEuYyBiL2Ry
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2FsdWEuYw0KaW5kZXggMDM2NGNhMi4uZDVmNGViOCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2FsdWEuYw0KKysrIGIvZHJp
dmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfYWx1YS5jDQpAQCAtMzkzLDggKzM5Myw5IEBAIHN0YXRp
YyBpbmxpbmUgaW50IGNvcmVfYWx1YV9zdGF0ZV9zdGFuZGJ5KA0KIAljYXNlIFJFUE9SVF9MVU5T
Og0KIAljYXNlIFJFQ0VJVkVfRElBR05PU1RJQzoNCiAJY2FzZSBTRU5EX0RJQUdOT1NUSUM6DQor
CQlyZXR1cm4gMDsNCiAJY2FzZSBNQUlOVEVOQU5DRV9JTjoNCi0JCXN3aXRjaCAoY2RiWzFdKSB7
DQorCQlzd2l0Y2ggKGNkYlsxXSAmIDB4MWYpIHsNCiAJCWNhc2UgTUlfUkVQT1JUX1RBUkdFVF9Q
R1M6DQogCQkJcmV0dXJuIDA7DQogCQlkZWZhdWx0Og0KQEAgLTQzNSw4ICs0MzYsOSBAQCBzdGF0
aWMgaW5saW5lIGludCBjb3JlX2FsdWFfc3RhdGVfdW5hdmFpbGFibGUoDQogCXN3aXRjaCAoY2Ri
WzBdKSB7DQogCWNhc2UgSU5RVUlSWToNCiAJY2FzZSBSRVBPUlRfTFVOUzoNCisJCXJldHVybiAw
Ow0KIAljYXNlIE1BSU5URU5BTkNFX0lOOg0KLQkJc3dpdGNoIChjZGJbMV0pIHsNCisJCXN3aXRj
aCAoY2RiWzFdICYgMHgxZikgew0KIAkJY2FzZSBNSV9SRVBPUlRfVEFSR0VUX1BHUzoNCiAJCQly
ZXR1cm4gMDsNCiAJCWRlZmF1bHQ6DQpAQCAtNDc1LDggKzQ3Nyw5IEBAIHN0YXRpYyBpbmxpbmUg
aW50IGNvcmVfYWx1YV9zdGF0ZV90cmFuc2l0aW9uKA0KIAlzd2l0Y2ggKGNkYlswXSkgew0KIAlj
YXNlIElOUVVJUlk6DQogCWNhc2UgUkVQT1JUX0xVTlM6DQorCQlyZXR1cm4gMDsNCiAJY2FzZSBN
QUlOVEVOQU5DRV9JTjoNCi0JCXN3aXRjaCAoY2RiWzFdKSB7DQorCQlzd2l0Y2ggKGNkYlsxXSAm
IDB4MWYpIHsNCiAJCWNhc2UgTUlfUkVQT1JUX1RBUkdFVF9QR1M6DQogCQkJcmV0dXJuIDA7DQog
CQlkZWZhdWx0Og0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5z
cG9ydC5jIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMNCmluZGV4IDkx
NzZiMmUuLjg5OGMxZGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90
cmFuc3BvcnQuYw0KKysrIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMN
CkBAIC0xNDQ1LDYgKzE0NDUsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgdHJhbnNwb3J0X2dlbmVy
aWNfcHJlcGFyZV9jZGIoDQogCWNhc2UgVkVSSUZZXzE2OiAvKiBTQkMgLSBWUlByb3RlY3QgKi8N
CiAJY2FzZSBXUklURV9WRVJJRlk6IC8qIFNCQyAtIFZSUHJvdGVjdCAqLw0KIAljYXNlIFdSSVRF
X1ZFUklGWV8xMjogLyogU0JDIC0gVlJQcm90ZWN0ICovDQorCWNhc2UgTUFJTlRFTkFOQ0VfSU46
IC8qIFNQQyAtIFBhcmFtZXRlciBEYXRhIEZvcm1hdCBmb3IgU0EgUlRQRyAqLw0KIAkJYnJlYWs7
DQogCWRlZmF1bHQ6DQogCQljZGJbMV0gJj0gMHgxZjsgLyogY2xlYXIgbG9naWNhbCB1bml0IG51
bWJlciAqLw0KQEAgLTI2ODMsNyArMjY4NCw3IEBAIHN0YXRpYyBpbnQgdHJhbnNwb3J0X2dlbmVy
aWNfY21kX3NlcXVlbmNlcigNCiAJCQkvKg0KIAkJCSAqIENoZWNrIGZvciBlbXVsYXRlZCBNSV9S
RVBPUlRfVEFSR0VUX1BHUy4NCiAJCQkgKi8NCi0JCQlpZiAoY2RiWzFdID09IE1JX1JFUE9SVF9U
QVJHRVRfUEdTICYmDQorCQkJaWYgKChjZGJbMV0gJiAweDFmKSA9PSBNSV9SRVBPUlRfVEFSR0VU
X1BHUyAmJg0KIAkJCSAgICBzdV9kZXYtPnQxMF9hbHVhLmFsdWFfdHlwZSA9PSBTUEMzX0FMVUFf
RU1VTEFURUQpIHsNCiAJCQkJY21kLT5leGVjdXRlX3Rhc2sgPQ0KIAkJCQkJdGFyZ2V0X2VtdWxh
dGVfcmVwb3J0X3RhcmdldF9wb3J0X2dyb3VwczsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJt
YWwvdGhlcm1hbF9zeXMuYyBiL2RyaXZlcnMvdGhlcm1hbC90aGVybWFsX3N5cy5jDQppbmRleCBk
ZDlhNTc0Li5mNmZiMjkyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90aGVybWFsL3RoZXJtYWxfc3lz
LmMNCisrKyBiL2RyaXZlcnMvdGhlcm1hbC90aGVybWFsX3N5cy5jDQpAQCAtMTM5OSw2ICsxMzk5
LDcgQEAgc3RhdGljIGludCBfX2luaXQgdGhlcm1hbF9pbml0KHZvaWQpDQogCQlpZHJfZGVzdHJv
eSgmdGhlcm1hbF9jZGV2X2lkcik7DQogCQltdXRleF9kZXN0cm95KCZ0aGVybWFsX2lkcl9sb2Nr
KTsNCiAJCW11dGV4X2Rlc3Ryb3koJnRoZXJtYWxfbGlzdF9sb2NrKTsNCisJCXJldHVybiByZXN1
bHQ7DQogCX0NCiAJcmVzdWx0ID0gZ2VuZXRsaW5rX2luaXQoKTsNCiAJcmV0dXJuIHJlc3VsdDsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvYXJrMzExNi5jIGIvZHJpdmVycy91c2Iv
c2VyaWFsL2FyazMxMTYuYw0KaW5kZXggMThlODc1Yi4uM2NhNmMwZCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdXNiL3NlcmlhbC9hcmszMTE2LmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9hcmsz
MTE2LmMNCkBAIC02OCw3ICs2OCw2IEBAIHN0YXRpYyBpbnQgaXNfaXJkYShzdHJ1Y3QgdXNiX3Nl
cmlhbCAqc2VyaWFsKQ0KIH0NCiANCiBzdHJ1Y3QgYXJrMzExNl9wcml2YXRlIHsNCi0Jd2FpdF9x
dWV1ZV9oZWFkX3QgICAgICAgZGVsdGFfbXNyX3dhaXQ7DQogCXN0cnVjdCBhc3luY19pY291bnQJ
aWNvdW50Ow0KIAlpbnQJCQlpcmRhOwkvKiAxIGZvciBpcmRhIGRldmljZSAqLw0KIA0KQEAgLTE0
OCw3ICsxNDcsNiBAQCBzdGF0aWMgaW50IGFyazMxMTZfYXR0YWNoKHN0cnVjdCB1c2Jfc2VyaWFs
ICpzZXJpYWwpDQogCWlmICghcHJpdikNCiAJCXJldHVybiAtRU5PTUVNOw0KIA0KLQlpbml0X3dh
aXRxdWV1ZV9oZWFkKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQogCW11dGV4X2luaXQoJnByaXYt
Pmh3X2xvY2spOw0KIAlzcGluX2xvY2tfaW5pdCgmcHJpdi0+c3RhdHVzX2xvY2spOw0KIA0KQEAg
LTQ2MCwxMCArNDU4LDE0IEBAIHN0YXRpYyBpbnQgYXJrMzExNl9pb2N0bChzdHJ1Y3QgdHR5X3N0
cnVjdCAqdHR5LA0KIAljYXNlIFRJT0NNSVdBSVQ6DQogCQlmb3IgKDs7KSB7DQogCQkJc3RydWN0
IGFzeW5jX2ljb3VudCBwcmV2ID0gcHJpdi0+aWNvdW50Ow0KLQkJCWludGVycnVwdGlibGVfc2xl
ZXBfb24oJnByaXYtPmRlbHRhX21zcl93YWl0KTsNCisJCQlpbnRlcnJ1cHRpYmxlX3NsZWVwX29u
KCZwb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQkJLyogc2VlIGlmIGEgc2lnbmFsIGRpZCBpdCAq
Lw0KIAkJCWlmIChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkNCiAJCQkJcmV0dXJuIC1FUkVTVEFS
VFNZUzsNCisNCisJCQlpZiAocG9ydC0+c2VyaWFsLT5kaXNjb25uZWN0ZWQpDQorCQkJCXJldHVy
biAtRUlPOw0KKw0KIAkJCWlmICgocHJldi5ybmcgPT0gcHJpdi0+aWNvdW50LnJuZykgJiYNCiAJ
CQkgICAgKHByZXYuZHNyID09IHByaXYtPmljb3VudC5kc3IpICYmDQogCQkJICAgIChwcmV2LmRj
ZCA9PSBwcml2LT5pY291bnQuZGNkKSAmJg0KQEAgLTU4NCw3ICs1ODYsNyBAQCBzdGF0aWMgdm9p
ZCBhcmszMTE2X3VwZGF0ZV9tc3Ioc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwgX191OCBt
c3IpDQogCQkJcHJpdi0+aWNvdW50LmRjZCsrOw0KIAkJaWYgKG1zciAmIFVBUlRfTVNSX1RFUkkp
DQogCQkJcHJpdi0+aWNvdW50LnJuZysrOw0KLQkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwcml2
LT5kZWx0YV9tc3Jfd2FpdCk7DQorCQl3YWtlX3VwX2ludGVycnVwdGlibGUoJnBvcnQtPmRlbHRh
X21zcl93YWl0KTsNCiAJfQ0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwv
Y2gzNDEuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9jaDM0MS5jDQppbmRleCA2YWUxYzA2Li5jNGQ5
NWIwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2NoMzQxLmMNCisrKyBiL2RyaXZl
cnMvdXNiL3NlcmlhbC9jaDM0MS5jDQpAQCAtODIsNyArODIsNiBAQCBNT0RVTEVfREVWSUNFX1RB
QkxFKHVzYiwgaWRfdGFibGUpOw0KIA0KIHN0cnVjdCBjaDM0MV9wcml2YXRlIHsNCiAJc3Bpbmxv
Y2tfdCBsb2NrOyAvKiBhY2Nlc3MgbG9jayAqLw0KLQl3YWl0X3F1ZXVlX2hlYWRfdCBkZWx0YV9t
c3Jfd2FpdDsgLyogd2FpdCBxdWV1ZSBmb3IgbW9kZW0gc3RhdHVzICovDQogCXVuc2lnbmVkIGJh
dWRfcmF0ZTsgLyogc2V0IGJhdWQgcmF0ZSAqLw0KIAl1OCBsaW5lX2NvbnRyb2w7IC8qIHNldCBs
aW5lIGNvbnRyb2wgdmFsdWUgUlRTL0RUUiAqLw0KIAl1OCBsaW5lX3N0YXR1czsgLyogYWN0aXZl
IHN0YXR1cyBvZiBtb2RlbSBjb250cm9sIGlucHV0cyAqLw0KQEAgLTI2Miw3ICsyNjEsNiBAQCBz
dGF0aWMgaW50IGNoMzQxX2F0dGFjaChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsKQ0KIAkJcmV0
dXJuIC1FTk9NRU07DQogDQogCXNwaW5fbG9ja19pbml0KCZwcml2LT5sb2NrKTsNCi0JaW5pdF93
YWl0cXVldWVfaGVhZCgmcHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KIAlwcml2LT5iYXVkX3JhdGUg
PSBERUZBVUxUX0JBVURfUkFURTsNCiAJcHJpdi0+bGluZV9jb250cm9sID0gQ0gzNDFfQklUX1JU
UyB8IENIMzQxX0JJVF9EVFI7DQogDQpAQCAtMjk5LDcgKzI5Nyw3IEBAIHN0YXRpYyB2b2lkIGNo
MzQxX2R0cl9ydHMoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwgaW50IG9uKQ0KIAkJcHJp
di0+bGluZV9jb250cm9sICY9IH4oQ0gzNDFfQklUX1JUUyB8IENIMzQxX0JJVF9EVFIpOw0KIAlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7DQogCWNoMzQxX3NldF9o
YW5kc2hha2UocG9ydC0+c2VyaWFsLT5kZXYsIHByaXYtPmxpbmVfY29udHJvbCk7DQotCXdha2Vf
dXBfaW50ZXJydXB0aWJsZSgmcHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KKwl3YWtlX3VwX2ludGVy
cnVwdGlibGUoJnBvcnQtPmRlbHRhX21zcl93YWl0KTsNCiB9DQogDQogc3RhdGljIHZvaWQgY2gz
NDFfY2xvc2Uoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCkNCkBAIC01MDMsNyArNTAxLDcg
QEAgc3RhdGljIHZvaWQgY2gzNDFfcmVhZF9pbnRfY2FsbGJhY2soc3RydWN0IHVyYiAqdXJiKQ0K
IAkJCXR0eV9rcmVmX3B1dCh0dHkpOw0KIAkJfQ0KIA0KLQkJd2FrZV91cF9pbnRlcnJ1cHRpYmxl
KCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQorCQl3YWtlX3VwX2ludGVycnVwdGlibGUoJnBvcnQt
PmRlbHRhX21zcl93YWl0KTsNCiAJfQ0KIA0KIGV4aXQ6DQpAQCAtNTI5LDExICs1MjcsMTQgQEAg
c3RhdGljIGludCB3YWl0X21vZGVtX2luZm8oc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwg
dW5zaWduZWQgaW50IGFyZykNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdi0+bG9jaywg
ZmxhZ3MpOw0KIA0KIAl3aGlsZSAoIW11bHRpX2NoYW5nZSkgew0KLQkJaW50ZXJydXB0aWJsZV9z
bGVlcF9vbigmcHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KKwkJaW50ZXJydXB0aWJsZV9zbGVlcF9v
bigmcG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KIAkJLyogc2VlIGlmIGEgc2lnbmFsIGRpZCBpdCAq
Lw0KIAkJaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KIAkJCXJldHVybiAtRVJFU1RBUlRT
WVM7DQogDQorCQlpZiAocG9ydC0+c2VyaWFsLT5kaXNjb25uZWN0ZWQpDQorCQkJcmV0dXJuIC1F
SU87DQorDQogCQlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0KIAkJc3Rh
dHVzID0gcHJpdi0+bGluZV9zdGF0dXM7DQogCQltdWx0aV9jaGFuZ2UgPSBwcml2LT5tdWx0aV9z
dGF0dXNfY2hhbmdlOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9jeXByZXNzX204
LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvY3lwcmVzc19tOC5jDQppbmRleCBkOTkwNmViLi4wMWE0
NGQzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2N5cHJlc3NfbTguYw0KKysrIGIv
ZHJpdmVycy91c2Ivc2VyaWFsL2N5cHJlc3NfbTguYw0KQEAgLTE1MCw3ICsxNTAsNiBAQCBzdHJ1
Y3QgY3lwcmVzc19wcml2YXRlIHsNCiAJaW50IGJhdWRfcmF0ZTsJCQkgICAvKiBzdG9yZXMgY3Vy
cmVudCBiYXVkIHJhdGUgaW4NCiAJCQkJCSAgICAgIGludGVnZXIgZm9ybSAqLw0KIAlpbnQgaXN0
aHJvdHRsZWQ7CQkgICAvKiBpZiB0aHJvdHRsZWQsIGRpc2NhcmQgcmVhZHMgKi8NCi0Jd2FpdF9x
dWV1ZV9oZWFkX3QgZGVsdGFfbXNyX3dhaXQ7ICAvKiB1c2VkIGZvciBUSU9DTUlXQUlUICovDQog
CWNoYXIgcHJldl9zdGF0dXMsIGRpZmZfc3RhdHVzOwkgICAvKiB1c2VkIGZvciBUSU9DTUlXQUlU
ICovDQogCS8qIHdlIHBhc3MgYSBwb2ludGVyIHRvIHRoaXMgYXMgdGhlIGFyZ3VtZW50IHNlbnQg
dG8NCiAJICAgY3lwcmVzc19zZXRfdGVybWlvcyBvbGRfdGVybWlvcyAqLw0KQEAgLTQ4OCw3ICs0
ODcsNiBAQCBzdGF0aWMgaW50IGdlbmVyaWNfc3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2Vy
aWFsKQ0KIAkJa2ZyZWUocHJpdik7DQogCQlyZXR1cm4gLUVOT01FTTsNCiAJfQ0KLQlpbml0X3dh
aXRxdWV1ZV9oZWFkKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQogDQogCXVzYl9yZXNldF9jb25m
aWd1cmF0aW9uKHNlcmlhbC0+ZGV2KTsNCiANCkBAIC05MjgsMTIgKzkyNiwxNiBAQCBzdGF0aWMg
aW50IGN5cHJlc3NfaW9jdGwoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJc3dpdGNoIChjbWQp
IHsNCiAJLyogVGhpcyBjb2RlIGNvbWVzIGZyb20gZHJpdmVycy9jaGFyL3NlcmlhbC5jIGFuZCBm
dGRpX3Npby5jICovDQogCWNhc2UgVElPQ01JV0FJVDoNCi0JCXdoaWxlIChwcml2ICE9IE5VTEwp
IHsNCi0JCQlpbnRlcnJ1cHRpYmxlX3NsZWVwX29uKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQor
CQlmb3IgKDs7KSB7DQorCQkJaW50ZXJydXB0aWJsZV9zbGVlcF9vbigmcG9ydC0+ZGVsdGFfbXNy
X3dhaXQpOw0KIAkJCS8qIHNlZSBpZiBhIHNpZ25hbCBkaWQgaXQgKi8NCiAJCQlpZiAoc2lnbmFs
X3BlbmRpbmcoY3VycmVudCkpDQogCQkJCXJldHVybiAtRVJFU1RBUlRTWVM7DQotCQkJZWxzZSB7
DQorDQorCQkJaWYgKHBvcnQtPnNlcmlhbC0+ZGlzY29ubmVjdGVkKQ0KKwkJCQlyZXR1cm4gLUVJ
TzsNCisNCisJCQl7DQogCQkJCWNoYXIgZGlmZiA9IHByaXYtPmRpZmZfc3RhdHVzOw0KIAkJCQlp
ZiAoZGlmZiA9PSAwKQ0KIAkJCQkJcmV0dXJuIC1FSU87IC8qIG5vIGNoYW5nZSA9PiBlcnJvciAq
Lw0KQEAgLTEyNjEsNyArMTI2Myw3IEBAIHN0YXRpYyB2b2lkIGN5cHJlc3NfcmVhZF9pbnRfY2Fs
bGJhY2soc3RydWN0IHVyYiAqdXJiKQ0KIAlpZiAocHJpdi0+Y3VycmVudF9zdGF0dXMgIT0gcHJp
di0+cHJldl9zdGF0dXMpIHsNCiAJCXByaXYtPmRpZmZfc3RhdHVzIHw9IHByaXYtPmN1cnJlbnRf
c3RhdHVzIF4NCiAJCQlwcml2LT5wcmV2X3N0YXR1czsNCi0JCXdha2VfdXBfaW50ZXJydXB0aWJs
ZSgmcHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KKwkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwb3J0
LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQlwcml2LT5wcmV2X3N0YXR1cyA9IHByaXYtPmN1cnJlbnRf
c3RhdHVzOw0KIAl9DQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdz
KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYyBiL2RyaXZlcnMv
dXNiL3NlcmlhbC9mdGRpX3Npby5jDQppbmRleCA4NzhmZjA1Li4wNjM5NGU1YSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJp
YWwvZnRkaV9zaW8uYw0KQEAgLTc0LDkgKzc0LDcgQEAgc3RydWN0IGZ0ZGlfcHJpdmF0ZSB7DQog
CWludCBmbGFnczsJCS8qIHNvbWUgQVNZTkNfeHh4eCBmbGFncyBhcmUgc3VwcG9ydGVkICovDQog
CXVuc2lnbmVkIGxvbmcgbGFzdF9kdHJfcnRzOwkvKiBzYXZlZCBtb2RlbSBjb250cm9sIG91dHB1
dHMgKi8NCiAJc3RydWN0IGFzeW5jX2ljb3VudAlpY291bnQ7DQotCXdhaXRfcXVldWVfaGVhZF90
IGRlbHRhX21zcl93YWl0OyAvKiBVc2VkIGZvciBUSU9DTUlXQUlUICovDQogCWNoYXIgcHJldl9z
dGF0dXM7ICAgICAgICAvKiBVc2VkIGZvciBUSU9DTUlXQUlUICovDQotCWJvb2wgZGV2X2dvbmU7
ICAgICAgICAvKiBVc2VkIHRvIGFib3J0IFRJT0NNSVdBSVQgKi8NCiAJY2hhciB0cmFuc21pdF9l
bXB0eTsJLyogSWYgdHJhbnNtaXR0ZXIgaXMgZW1wdHkgb3Igbm90ICovDQogCXN0cnVjdCB1c2Jf
c2VyaWFsX3BvcnQgKnBvcnQ7DQogCV9fdTE2IGludGVyZmFjZTsJLyogRlQyMjMyQywgRlQyMjMy
SCBvciBGVDQyMzJIIHBvcnQgaW50ZXJmYWNlDQpAQCAtMTcwOCwxMCArMTcwNiw4IEBAIHN0YXRp
YyBpbnQgZnRkaV9zaW9fcG9ydF9wcm9iZShzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0K
IAlrcmVmX2luaXQoJnByaXYtPmtyZWYpOw0KIAltdXRleF9pbml0KCZwcml2LT5jZmdfbG9jayk7
DQogCW1lbXNldCgmcHJpdi0+aWNvdW50LCAweDAwLCBzaXplb2YocHJpdi0+aWNvdW50KSk7DQot
CWluaXRfd2FpdHF1ZXVlX2hlYWQoJnByaXYtPmRlbHRhX21zcl93YWl0KTsNCiANCiAJcHJpdi0+
ZmxhZ3MgPSBBU1lOQ19MT1dfTEFURU5DWTsNCi0JcHJpdi0+ZGV2X2dvbmUgPSBmYWxzZTsNCiAN
CiAJaWYgKHF1aXJrICYmIHF1aXJrLT5wb3J0X3Byb2JlKQ0KIAkJcXVpcmstPnBvcnRfcHJvYmUo
cHJpdik7DQpAQCAtMTg2OSw4ICsxODY1LDcgQEAgc3RhdGljIGludCBmdGRpX3Npb19wb3J0X3Jl
bW92ZShzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIA0KIAlkYmcoIiVzIiwgX19mdW5j
X18pOw0KIA0KLQlwcml2LT5kZXZfZ29uZSA9IHRydWU7DQotCXdha2VfdXBfaW50ZXJydXB0aWJs
ZV9hbGwoJnByaXYtPmRlbHRhX21zcl93YWl0KTsNCisJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZw
b3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogDQogCXJlbW92ZV9zeXNmc19hdHRycyhwb3J0KTsNCiAN
CkBAIC0yMDI1LDcgKzIwMjAsNyBAQCBzdGF0aWMgaW50IGZ0ZGlfcHJvY2Vzc19wYWNrZXQoc3Ry
dWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJCWlmIChkaWZmX3N0YXR1cyAmIEZURElfUlMwX1JMU0Qp
DQogCQkJcHJpdi0+aWNvdW50LmRjZCsrOw0KIA0KLQkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlX2Fs
bCgmcHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KKwkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwb3J0
LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQlwcml2LT5wcmV2X3N0YXR1cyA9IHN0YXR1czsNCiAJfQ0K
IA0KQEAgLTI0MjQsMTEgKzI0MTksMTUgQEAgc3RhdGljIGludCBmdGRpX2lvY3RsKHN0cnVjdCB0
dHlfc3RydWN0ICp0dHksDQogCSAqLw0KIAljYXNlIFRJT0NNSVdBSVQ6DQogCQljcHJldiA9IHBy
aXYtPmljb3VudDsNCi0JCXdoaWxlICghcHJpdi0+ZGV2X2dvbmUpIHsNCi0JCQlpbnRlcnJ1cHRp
YmxlX3NsZWVwX29uKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQorCQlmb3IgKDs7KSB7DQorCQkJ
aW50ZXJydXB0aWJsZV9zbGVlcF9vbigmcG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KIAkJCS8qIHNl
ZSBpZiBhIHNpZ25hbCBkaWQgaXQgKi8NCiAJCQlpZiAoc2lnbmFsX3BlbmRpbmcoY3VycmVudCkp
DQogCQkJCXJldHVybiAtRVJFU1RBUlRTWVM7DQorDQorCQkJaWYgKHBvcnQtPnNlcmlhbC0+ZGlz
Y29ubmVjdGVkKQ0KKwkJCQlyZXR1cm4gLUVJTzsNCisNCiAJCQljbm93ID0gcHJpdi0+aWNvdW50
Ow0KIAkJCWlmICgoKGFyZyAmIFRJT0NNX1JORykgJiYgKGNub3cucm5nICE9IGNwcmV2LnJuZykp
IHx8DQogCQkJICAgICgoYXJnICYgVElPQ01fRFNSKSAmJiAoY25vdy5kc3IgIT0gY3ByZXYuZHNy
KSkgfHwNCkBAIC0yNDM4LDggKzI0MzcsNiBAQCBzdGF0aWMgaW50IGZ0ZGlfaW9jdGwoc3RydWN0
IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJCQl9DQogCQkJY3ByZXYgPSBjbm93Ow0KIAkJfQ0KLQkJcmV0
dXJuIC1FSU87DQotCQlicmVhazsNCiAJY2FzZSBUSU9DU0VSR0VUTFNSOg0KIAkJcmV0dXJuIGdl
dF9sc3JfaW5mbyhwb3J0LCAoc3RydWN0IHNlcmlhbF9zdHJ1Y3QgX191c2VyICopYXJnKTsNCiAJ
CWJyZWFrOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9pb19lZGdlcG9ydC5jIGIv
ZHJpdmVycy91c2Ivc2VyaWFsL2lvX2VkZ2Vwb3J0LmMNCmluZGV4IDJlZTgwNzUuLjBhZjBiNDEg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvaW9fZWRnZXBvcnQuYw0KKysrIGIvZHJp
dmVycy91c2Ivc2VyaWFsL2lvX2VkZ2Vwb3J0LmMNCkBAIC0xMTQsNyArMTE0LDYgQEAgc3RydWN0
IGVkZ2Vwb3J0X3BvcnQgew0KIAl3YWl0X3F1ZXVlX2hlYWRfdAl3YWl0X2NoYXNlOwkJLyogZm9y
IGhhbmRsaW5nIHNsZWVwaW5nIHdoaWxlIHdhaXRpbmcgZm9yIGNoYXNlIHRvIGZpbmlzaCAqLw0K
IAl3YWl0X3F1ZXVlX2hlYWRfdAl3YWl0X29wZW47CQkvKiBmb3IgaGFuZGxpbmcgc2xlZXBpbmcg
d2hpbGUgd2FpdGluZyBmb3Igb3BlbiB0byBmaW5pc2ggKi8NCiAJd2FpdF9xdWV1ZV9oZWFkX3QJ
d2FpdF9jb21tYW5kOwkJLyogZm9yIGhhbmRsaW5nIHNsZWVwaW5nIHdoaWxlIHdhaXRpbmcgZm9y
IGNvbW1hbmQgdG8gZmluaXNoICovDQotCXdhaXRfcXVldWVfaGVhZF90CWRlbHRhX21zcl93YWl0
OwkJLyogZm9yIGhhbmRsaW5nIHNsZWVwaW5nIHdoaWxlIHdhaXRpbmcgZm9yIG1zciBjaGFuZ2Ug
dG8gaGFwcGVuICovDQogDQogCXN0cnVjdCBhc3luY19pY291bnQJaWNvdW50Ow0KIAlzdHJ1Y3Qg
dXNiX3NlcmlhbF9wb3J0CSpwb3J0OwkJCS8qIGxvb3AgYmFjayB0byB0aGUgb3duZXIgb2YgdGhp
cyBvYmplY3QgKi8NCkBAIC04ODUsNyArODg0LDYgQEAgc3RhdGljIGludCBlZGdlX29wZW4oc3Ry
dWN0IHR0eV9zdHJ1Y3QgKnR0eSwgc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCkNCiAJLyog
aW5pdGlhbGl6ZSBvdXIgd2FpdCBxdWV1ZXMgKi8NCiAJaW5pdF93YWl0cXVldWVfaGVhZCgmZWRn
ZV9wb3J0LT53YWl0X29wZW4pOw0KIAlpbml0X3dhaXRxdWV1ZV9oZWFkKCZlZGdlX3BvcnQtPndh
aXRfY2hhc2UpOw0KLQlpbml0X3dhaXRxdWV1ZV9oZWFkKCZlZGdlX3BvcnQtPmRlbHRhX21zcl93
YWl0KTsNCiAJaW5pdF93YWl0cXVldWVfaGVhZCgmZWRnZV9wb3J0LT53YWl0X2NvbW1hbmQpOw0K
IA0KIAkvKiBpbml0aWFsaXplIG91ciBpY291bnQgc3RydWN0dXJlICovDQpAQCAtMTcwMywxMyAr
MTcwMSwxNyBAQCBzdGF0aWMgaW50IGVkZ2VfaW9jdGwoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwN
CiAJCWRiZygiJXMgKCVkKSBUSU9DTUlXQUlUIiwgX19mdW5jX18sICBwb3J0LT5udW1iZXIpOw0K
IAkJY3ByZXYgPSBlZGdlX3BvcnQtPmljb3VudDsNCiAJCXdoaWxlICgxKSB7DQotCQkJcHJlcGFy
ZV90b193YWl0KCZlZGdlX3BvcnQtPmRlbHRhX21zcl93YWl0LA0KKwkJCXByZXBhcmVfdG9fd2Fp
dCgmcG9ydC0+ZGVsdGFfbXNyX3dhaXQsDQogCQkJCQkJJndhaXQsIFRBU0tfSU5URVJSVVBUSUJM
RSk7DQogCQkJc2NoZWR1bGUoKTsNCi0JCQlmaW5pc2hfd2FpdCgmZWRnZV9wb3J0LT5kZWx0YV9t
c3Jfd2FpdCwgJndhaXQpOw0KKwkJCWZpbmlzaF93YWl0KCZwb3J0LT5kZWx0YV9tc3Jfd2FpdCwg
JndhaXQpOw0KIAkJCS8qIHNlZSBpZiBhIHNpZ25hbCBkaWQgaXQgKi8NCiAJCQlpZiAoc2lnbmFs
X3BlbmRpbmcoY3VycmVudCkpDQogCQkJCXJldHVybiAtRVJFU1RBUlRTWVM7DQorDQorCQkJaWYg
KHBvcnQtPnNlcmlhbC0+ZGlzY29ubmVjdGVkKQ0KKwkJCQlyZXR1cm4gLUVJTzsNCisNCiAJCQlj
bm93ID0gZWRnZV9wb3J0LT5pY291bnQ7DQogCQkJaWYgKGNub3cucm5nID09IGNwcmV2LnJuZyAm
JiBjbm93LmRzciA9PSBjcHJldi5kc3IgJiYNCiAJCQkgICAgY25vdy5kY2QgPT0gY3ByZXYuZGNk
ICYmIGNub3cuY3RzID09IGNwcmV2LmN0cykNCkBAIC0yMDkwLDcgKzIwOTIsNyBAQCBzdGF0aWMg
dm9pZCBoYW5kbGVfbmV3X21zcihzdHJ1Y3QgZWRnZXBvcnRfcG9ydCAqZWRnZV9wb3J0LCBfX3U4
IG5ld01zcikNCiAJCQlpY291bnQtPmRjZCsrOw0KIAkJaWYgKG5ld01zciAmIEVER0VQT1JUX01T
Ul9ERUxUQV9SSSkNCiAJCQlpY291bnQtPnJuZysrOw0KLQkJd2FrZV91cF9pbnRlcnJ1cHRpYmxl
KCZlZGdlX3BvcnQtPmRlbHRhX21zcl93YWl0KTsNCisJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgm
ZWRnZV9wb3J0LT5wb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogCX0NCiANCiAJLyogU2F2ZSB0aGUg
bmV3IG1vZGVtIHN0YXR1cyAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9pb190
aS5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL2lvX3RpLmMNCmluZGV4IDFmMTQ1YmYuLmY0MjExOWQg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvaW9fdGkuYw0KKysrIGIvZHJpdmVycy91
c2Ivc2VyaWFsL2lvX3RpLmMNCkBAIC05OCw5ICs5OCw2IEBAIHN0cnVjdCBlZGdlcG9ydF9wb3J0
IHsNCiAJaW50IGNsb3NlX3BlbmRpbmc7DQogCWludCBsc3JfZXZlbnQ7DQogCXN0cnVjdCBhc3lu
Y19pY291bnQJaWNvdW50Ow0KLQl3YWl0X3F1ZXVlX2hlYWRfdAlkZWx0YV9tc3Jfd2FpdDsJLyog
Zm9yIGhhbmRsaW5nIHNsZWVwaW5nIHdoaWxlDQotCQkJCQkJICAgd2FpdGluZyBmb3IgbXNyIGNo
YW5nZSB0bw0KLQkJCQkJCSAgIGhhcHBlbiAqLw0KIAlzdHJ1Y3QgZWRnZXBvcnRfc2VyaWFsCSpl
ZGdlX3NlcmlhbDsNCiAJc3RydWN0IHVzYl9zZXJpYWxfcG9ydAkqcG9ydDsNCiAJX191OCBiVWFy
dE1vZGU7CQkvKiBQb3J0IHR5cGUsIDA6IFJTMjMyLCBldGMuICovDQpAQCAtMTU1Nyw3ICsxNTU0
LDcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX25ld19tc3Ioc3RydWN0IGVkZ2Vwb3J0X3BvcnQgKmVk
Z2VfcG9ydCwgX191OCBtc3IpDQogCQkJaWNvdW50LT5kY2QrKzsNCiAJCWlmIChtc3IgJiBFREdF
UE9SVF9NU1JfREVMVEFfUkkpDQogCQkJaWNvdW50LT5ybmcrKzsNCi0JCXdha2VfdXBfaW50ZXJy
dXB0aWJsZSgmZWRnZV9wb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQorCQl3YWtlX3VwX2ludGVycnVw
dGlibGUoJmVkZ2VfcG9ydC0+cG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KIAl9DQogDQogCS8qIFNh
dmUgdGhlIG5ldyBtb2RlbSBzdGF0dXMgKi8NCkBAIC0xODc2LDcgKzE4NzMsNiBAQCBzdGF0aWMg
aW50IGVkZ2Vfb3BlbihzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LCBzdHJ1Y3QgdXNiX3NlcmlhbF9w
b3J0ICpwb3J0KQ0KIAlkZXYgPSBwb3J0LT5zZXJpYWwtPmRldjsNCiANCiAJbWVtc2V0KCYoZWRn
ZV9wb3J0LT5pY291bnQpLCAweDAwLCBzaXplb2YoZWRnZV9wb3J0LT5pY291bnQpKTsNCi0JaW5p
dF93YWl0cXVldWVfaGVhZCgmZWRnZV9wb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogDQogCS8qIHR1
cm4gb2ZmIGxvb3BiYWNrICovDQogCXN0YXR1cyA9IHRpX2RvX2NvbmZpZyhlZGdlX3BvcnQsIFVN
UENfU0VUX0NMUl9MT09QQkFDSywgMCk7DQpAQCAtMjU3NCwxMCArMjU3MCwxNCBAQCBzdGF0aWMg
aW50IGVkZ2VfaW9jdGwoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJCWRiZygiJXMgLSAoJWQp
IFRJT0NNSVdBSVQiLCBfX2Z1bmNfXywgcG9ydC0+bnVtYmVyKTsNCiAJCWNwcmV2ID0gZWRnZV9w
b3J0LT5pY291bnQ7DQogCQl3aGlsZSAoMSkgew0KLQkJCWludGVycnVwdGlibGVfc2xlZXBfb24o
JmVkZ2VfcG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KKwkJCWludGVycnVwdGlibGVfc2xlZXBfb24o
JnBvcnQtPmRlbHRhX21zcl93YWl0KTsNCiAJCQkvKiBzZWUgaWYgYSBzaWduYWwgZGlkIGl0ICov
DQogCQkJaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KIAkJCQlyZXR1cm4gLUVSRVNUQVJU
U1lTOw0KKw0KKwkJCWlmIChwb3J0LT5zZXJpYWwtPmRpc2Nvbm5lY3RlZCkNCisJCQkJcmV0dXJu
IC1FSU87DQorDQogCQkJY25vdyA9IGVkZ2VfcG9ydC0+aWNvdW50Ow0KIAkJCWlmIChjbm93LnJu
ZyA9PSBjcHJldi5ybmcgJiYgY25vdy5kc3IgPT0gY3ByZXYuZHNyICYmDQogCQkJICAgIGNub3cu
ZGNkID09IGNwcmV2LmRjZCAmJiBjbm93LmN0cyA9PSBjcHJldi5jdHMpDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91c2Ivc2VyaWFsL21jdF91MjMyLmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvbWN0X3Uy
MzIuYw0KaW5kZXggZGUwYmI4ZS4uOTZhNjJkZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3Nl
cmlhbC9tY3RfdTIzMi5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvbWN0X3UyMzIuYw0KQEAg
LTE2OCw4ICsxNjgsNiBAQCBzdHJ1Y3QgbWN0X3UyMzJfcHJpdmF0ZSB7DQogCXVuc2lnbmVkIGNo
YXIJICAgICBsYXN0X21zcjsgICAgICAvKiBNb2RlbSBTdGF0dXMgUmVnaXN0ZXIgKi8NCiAJdW5z
aWduZWQgaW50CSAgICAgcnhfZmxhZ3M7ICAgICAgLyogVGhyb3R0bGluZyBmbGFncyAqLw0KIAlz
dHJ1Y3QgYXN5bmNfaWNvdW50ICBpY291bnQ7DQotCXdhaXRfcXVldWVfaGVhZF90ICAgIG1zcl93
YWl0OwkvKiBmb3IgaGFuZGxpbmcgc2xlZXBpbmcgd2hpbGUgd2FpdGluZw0KLQkJCQkJCWZvciBt
c3IgY2hhbmdlIHRvIGhhcHBlbiAqLw0KIH07DQogDQogI2RlZmluZSBUSFJPVFRMRUQJCTB4MDEN
CkBAIC00NDksNyArNDQ3LDYgQEAgc3RhdGljIGludCBtY3RfdTIzMl9zdGFydHVwKHN0cnVjdCB1
c2Jfc2VyaWFsICpzZXJpYWwpDQogCWlmICghcHJpdikNCiAJCXJldHVybiAtRU5PTUVNOw0KIAlz
cGluX2xvY2tfaW5pdCgmcHJpdi0+bG9jayk7DQotCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnByaXYt
Pm1zcl93YWl0KTsNCiAJdXNiX3NldF9zZXJpYWxfcG9ydF9kYXRhKHNlcmlhbC0+cG9ydFswXSwg
cHJpdik7DQogDQogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnNlcmlhbC0+cG9ydFswXS0+d3JpdGVf
d2FpdCk7DQpAQCAtNjc1LDcgKzY3Miw3IEBAIHN0YXRpYyB2b2lkIG1jdF91MjMyX3JlYWRfaW50
X2NhbGxiYWNrKHN0cnVjdCB1cmIgKnVyYikNCiAJCXR0eV9rcmVmX3B1dCh0dHkpOw0KIAl9DQog
I2VuZGlmDQotCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcHJpdi0+bXNyX3dhaXQpOw0KKwl3YWtl
X3VwX2ludGVycnVwdGlibGUoJnBvcnQtPmRlbHRhX21zcl93YWl0KTsNCiAJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0KIGV4aXQ6DQogCXJldHZhbCA9IHVzYl9z
dWJtaXRfdXJiKHVyYiwgR0ZQX0FUT01JQyk7DQpAQCAtODk2LDEzICs4OTMsMTcgQEAgc3RhdGlj
IGludCAgbWN0X3UyMzJfaW9jdGwoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJCWNwcmV2ID0g
bWN0X3UyMzJfcG9ydC0+aWNvdW50Ow0KIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmbWN0X3Uy
MzJfcG9ydC0+bG9jaywgZmxhZ3MpOw0KIAkJZm9yICggOyA7ICkgew0KLQkJCXByZXBhcmVfdG9f
d2FpdCgmbWN0X3UyMzJfcG9ydC0+bXNyX3dhaXQsDQorCQkJcHJlcGFyZV90b193YWl0KCZwb3J0
LT5kZWx0YV9tc3Jfd2FpdCwNCiAJCQkJCSZ3YWl0LCBUQVNLX0lOVEVSUlVQVElCTEUpOw0KIAkJ
CXNjaGVkdWxlKCk7DQotCQkJZmluaXNoX3dhaXQoJm1jdF91MjMyX3BvcnQtPm1zcl93YWl0LCAm
d2FpdCk7DQorCQkJZmluaXNoX3dhaXQoJnBvcnQtPmRlbHRhX21zcl93YWl0LCAmd2FpdCk7DQog
CQkJLyogc2VlIGlmIGEgc2lnbmFsIGRpZCBpdCAqLw0KIAkJCWlmIChzaWduYWxfcGVuZGluZyhj
dXJyZW50KSkNCiAJCQkJcmV0dXJuIC1FUkVTVEFSVFNZUzsNCisNCisJCQlpZiAocG9ydC0+c2Vy
aWFsLT5kaXNjb25uZWN0ZWQpDQorCQkJCXJldHVybiAtRUlPOw0KKw0KIAkJCXNwaW5fbG9ja19p
cnFzYXZlKCZtY3RfdTIzMl9wb3J0LT5sb2NrLCBmbGFncyk7DQogCQkJY25vdyA9IG1jdF91MjMy
X3BvcnQtPmljb3VudDsNCiAJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZtY3RfdTIzMl9wb3J0
LT5sb2NrLCBmbGFncyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL21vczc4NDAu
YyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9tb3M3ODQwLmMNCmluZGV4IDQzYTM4YWEuLmU4OWVlNDgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvbW9zNzg0MC5jDQorKysgYi9kcml2ZXJz
L3VzYi9zZXJpYWwvbW9zNzg0MC5jDQpAQCAtMjQwLDcgKzI0MCw2IEBAIHN0cnVjdCBtb3NjaGlw
X3BvcnQgew0KIAljaGFyIG9wZW47DQogCWNoYXIgb3Blbl9wb3J0czsNCiAJd2FpdF9xdWV1ZV9o
ZWFkX3Qgd2FpdF9jaGFzZTsJLyogZm9yIGhhbmRsaW5nIHNsZWVwaW5nIHdoaWxlIHdhaXRpbmcg
Zm9yIGNoYXNlIHRvIGZpbmlzaCAqLw0KLQl3YWl0X3F1ZXVlX2hlYWRfdCBkZWx0YV9tc3Jfd2Fp
dDsJLyogZm9yIGhhbmRsaW5nIHNsZWVwaW5nIHdoaWxlIHdhaXRpbmcgZm9yIG1zciBjaGFuZ2Ug
dG8gaGFwcGVuICovDQogCWludCBkZWx0YV9tc3JfY29uZDsNCiAJc3RydWN0IGFzeW5jX2ljb3Vu
dCBpY291bnQ7DQogCXN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQ7CS8qIGxvb3AgYmFjayB0
byB0aGUgb3duZXIgb2YgdGhpcyBvYmplY3QgKi8NCkBAIC00NTMsNiArNDUyLDkgQEAgc3RhdGlj
IHZvaWQgbW9zNzg0MF9oYW5kbGVfbmV3X21zcihzdHJ1Y3QgbW9zY2hpcF9wb3J0ICpwb3J0LCBf
X3U4IG5ld19tc3IpDQogCQkJaWNvdW50LT5ybmcrKzsNCiAJCQlzbXBfd21iKCk7DQogCQl9DQor
DQorCQltb3M3ODQwX3BvcnQtPmRlbHRhX21zcl9jb25kID0gMTsNCisJCXdha2VfdXBfaW50ZXJy
dXB0aWJsZSgmcG9ydC0+cG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KIAl9DQogfQ0KIA0KQEAgLTEx
MTUsNyArMTExNyw2IEBAIHN0YXRpYyBpbnQgbW9zNzg0MF9vcGVuKHN0cnVjdCB0dHlfc3RydWN0
ICp0dHksIHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQpDQogDQogCS8qIGluaXRpYWxpemUg
b3VyIHdhaXQgcXVldWVzICovDQogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJm1vczc4NDBfcG9ydC0+
d2FpdF9jaGFzZSk7DQotCWluaXRfd2FpdHF1ZXVlX2hlYWQoJm1vczc4NDBfcG9ydC0+ZGVsdGFf
bXNyX3dhaXQpOw0KIA0KIAkvKiBpbml0aWFsaXplIG91ciBpY291bnQgc3RydWN0dXJlICovDQog
CW1lbXNldCgmKG1vczc4NDBfcG9ydC0+aWNvdW50KSwgMHgwMCwgc2l6ZW9mKG1vczc4NDBfcG9y
dC0+aWNvdW50KSk7DQpAQCAtMjA3Myw4ICsyMDc0LDYgQEAgc3RhdGljIHZvaWQgbW9zNzg0MF9j
aGFuZ2VfcG9ydF9zZXR0aW5ncyhzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LA0KIAkJCW1vczc4NDBf
cG9ydC0+cmVhZF91cmJfYnVzeSA9IGZhbHNlOw0KIAkJfQ0KIAl9DQotCXdha2VfdXAoJm1vczc4
NDBfcG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KLQltb3M3ODQwX3BvcnQtPmRlbHRhX21zcl9jb25k
ID0gMTsNCiAJZGJnKCJtb3M3ODQwX2NoYW5nZV9wb3J0X3NldHRpbmdzIG1vczc4NDBfcG9ydC0+
c2hhZG93TENSIGlzIEVuZCAleCIsDQogCSAgICBtb3M3ODQwX3BvcnQtPnNoYWRvd0xDUik7DQog
fQ0KQEAgLTIyODQsMTMgKzIyODMsMTggQEAgc3RhdGljIGludCBtb3M3ODQwX2lvY3RsKHN0cnVj
dCB0dHlfc3RydWN0ICp0dHksDQogCQl3aGlsZSAoMSkgew0KIAkJCS8qIGludGVycnVwdGlibGVf
c2xlZXBfb24oJm1vczc4NDBfcG9ydC0+ZGVsdGFfbXNyX3dhaXQpOyAqLw0KIAkJCW1vczc4NDBf
cG9ydC0+ZGVsdGFfbXNyX2NvbmQgPSAwOw0KLQkJCXdhaXRfZXZlbnRfaW50ZXJydXB0aWJsZSht
b3M3ODQwX3BvcnQtPmRlbHRhX21zcl93YWl0LA0KLQkJCQkJCSAobW9zNzg0MF9wb3J0LT4NCisJ
CQl3YWl0X2V2ZW50X2ludGVycnVwdGlibGUocG9ydC0+ZGVsdGFfbXNyX3dhaXQsDQorCQkJCQkJ
IChwb3J0LT5zZXJpYWwtPmRpc2Nvbm5lY3RlZCB8fA0KKwkJCQkJCSAgbW9zNzg0MF9wb3J0LT4N
CiAJCQkJCQkgIGRlbHRhX21zcl9jb25kID09IDEpKTsNCiANCiAJCQkvKiBzZWUgaWYgYSBzaWdu
YWwgZGlkIGl0ICovDQogCQkJaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KIAkJCQlyZXR1
cm4gLUVSRVNUQVJUU1lTOw0KKw0KKwkJCWlmIChwb3J0LT5zZXJpYWwtPmRpc2Nvbm5lY3RlZCkN
CisJCQkJcmV0dXJuIC1FSU87DQorDQogCQkJY25vdyA9IG1vczc4NDBfcG9ydC0+aWNvdW50Ow0K
IAkJCXNtcF9ybWIoKTsNCiAJCQlpZiAoY25vdy5ybmcgPT0gY3ByZXYucm5nICYmIGNub3cuZHNy
ID09IGNwcmV2LmRzciAmJg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9vdGk2ODU4
LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvb3RpNjg1OC5jDQppbmRleCA0YzI5ZTZjLi44Y2VhYTg5
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL290aTY4NTguYw0KKysrIGIvZHJpdmVy
cy91c2Ivc2VyaWFsL290aTY4NTguYw0KQEAgLTE5Niw3ICsxOTYsNiBAQCBzdHJ1Y3Qgb3RpNjg1
OF9wcml2YXRlIHsNCiAJdTggc2V0dXBfZG9uZTsNCiAJc3RydWN0IGRlbGF5ZWRfd29yayBkZWxh
eWVkX3NldHVwX3dvcms7DQogDQotCXdhaXRfcXVldWVfaGVhZF90IGludHJfd2FpdDsNCiAJc3Ry
dWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydDsgICAvKiBVU0IgcG9ydCB3aXRoIHdoaWNoIGFzc29j
aWF0ZWQgKi8NCiB9Ow0KIA0KQEAgLTM1Nyw3ICszNTYsNiBAQCBzdGF0aWMgaW50IG90aTY4NThf
c3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsKQ0KIAkJCWJyZWFrOw0KIA0KIAkJc3Bp
bl9sb2NrX2luaXQoJnByaXYtPmxvY2spOw0KLQkJaW5pdF93YWl0cXVldWVfaGVhZCgmcHJpdi0+
aW50cl93YWl0KTsNCiAvKgkJSU5JVF9XT1JLKCZwcml2LT5zZXR1cF93b3JrLCBzZXR1cF9saW5l
LCBzZXJpYWwtPnBvcnRbaV0pOyAqLw0KIC8qCQlJTklUX1dPUksoJnByaXYtPndyaXRlX3dvcmss
IHNlbmRfZGF0YSwgc2VyaWFsLT5wb3J0W2ldKTsgKi8NCiAJCXByaXYtPnBvcnQgPSBwb3J0Ow0K
QEAgLTcwNSwxMSArNzAzLDE1IEBAIHN0YXRpYyBpbnQgd2FpdF9tb2RlbV9pbmZvKHN0cnVjdCB1
c2Jfc2VyaWFsX3BvcnQgKnBvcnQsIHVuc2lnbmVkIGludCBhcmcpDQogCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiANCiAJd2hpbGUgKDEpIHsNCi0JCXdhaXRf
ZXZlbnRfaW50ZXJydXB0aWJsZShwcml2LT5pbnRyX3dhaXQsDQorCQl3YWl0X2V2ZW50X2ludGVy
cnVwdGlibGUocG9ydC0+ZGVsdGFfbXNyX3dhaXQsDQorCQkJCQlwb3J0LT5zZXJpYWwtPmRpc2Nv
bm5lY3RlZCB8fA0KIAkJCQkJcHJpdi0+c3RhdHVzLnBpbl9zdGF0ZSAhPSBwcmV2KTsNCiAJCWlm
IChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkNCiAJCQlyZXR1cm4gLUVSRVNUQVJUU1lTOw0KIA0K
KwkJaWYgKHBvcnQtPnNlcmlhbC0+ZGlzY29ubmVjdGVkKQ0KKwkJCXJldHVybiAtRUlPOw0KKw0K
IAkJc3Bpbl9sb2NrX2lycXNhdmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiAJCXN0YXR1cyA9IHBy
aXYtPnN0YXR1cy5waW5fc3RhdGUgJiBQSU5fTUFTSzsNCiAJCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCkBAIC04MjEsNyArODIzLDcgQEAgc3RhdGljIHZvaWQg
b3RpNjg1OF9yZWFkX2ludF9jYWxsYmFjayhzdHJ1Y3QgdXJiICp1cmIpDQogDQogCQlpZiAoIXBy
aXYtPnRyYW5zaWVudCkgew0KIAkJCWlmICh4cy0+cGluX3N0YXRlICE9IHByaXYtPnN0YXR1cy5w
aW5fc3RhdGUpDQotCQkJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcHJpdi0+aW50cl93YWl0KTsN
CisJCQkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQkJ
bWVtY3B5KCZwcml2LT5zdGF0dXMsIHhzLCBPVEk2ODU4X0NUUkxfUEtUX1NJWkUpOw0KIAkJfQ0K
IA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9wbDIzMDMuYyBiL2RyaXZlcnMvdXNi
L3NlcmlhbC9wbDIzMDMuYw0KaW5kZXggNTUzMmVhNS4uZmQ4NmUwZSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdXNiL3NlcmlhbC9wbDIzMDMuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL3BsMjMw
My5jDQpAQCAtMTUwLDcgKzE1MCw2IEBAIGVudW0gcGwyMzAzX3R5cGUgew0KIA0KIHN0cnVjdCBw
bDIzMDNfcHJpdmF0ZSB7DQogCXNwaW5sb2NrX3QgbG9jazsNCi0Jd2FpdF9xdWV1ZV9oZWFkX3Qg
ZGVsdGFfbXNyX3dhaXQ7DQogCXU4IGxpbmVfY29udHJvbDsNCiAJdTggbGluZV9zdGF0dXM7DQog
CWVudW0gcGwyMzAzX3R5cGUgdHlwZTsNCkBAIC0yMDQsNyArMjAzLDYgQEAgc3RhdGljIGludCBw
bDIzMDNfc3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsKQ0KIAkJaWYgKCFwcml2KQ0K
IAkJCWdvdG8gY2xlYW51cDsNCiAJCXNwaW5fbG9ja19pbml0KCZwcml2LT5sb2NrKTsNCi0JCWlu
aXRfd2FpdHF1ZXVlX2hlYWQoJnByaXYtPmRlbHRhX21zcl93YWl0KTsNCiAJCXByaXYtPnR5cGUg
PSB0eXBlOw0KIAkJdXNiX3NldF9zZXJpYWxfcG9ydF9kYXRhKHNlcmlhbC0+cG9ydFtpXSwgcHJp
dik7DQogCX0NCkBAIC01OTksMTEgKzU5NywxNCBAQCBzdGF0aWMgaW50IHdhaXRfbW9kZW1faW5m
byhzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0LCB1bnNpZ25lZCBpbnQgYXJnKQ0KIAlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7DQogDQogCXdoaWxlICgxKSB7
DQotCQlpbnRlcnJ1cHRpYmxlX3NsZWVwX29uKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQorCQlp
bnRlcnJ1cHRpYmxlX3NsZWVwX29uKCZwb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQkvKiBzZWUg
aWYgYSBzaWduYWwgZGlkIGl0ICovDQogCQlpZiAoc2lnbmFsX3BlbmRpbmcoY3VycmVudCkpDQog
CQkJcmV0dXJuIC1FUkVTVEFSVFNZUzsNCiANCisJCWlmIChwb3J0LT5zZXJpYWwtPmRpc2Nvbm5l
Y3RlZCkNCisJCQlyZXR1cm4gLUVJTzsNCisNCiAJCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5s
b2NrLCBmbGFncyk7DQogCQlzdGF0dXMgPSBwcml2LT5saW5lX3N0YXR1czsNCiAJCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCkBAIC03MjUsNyArNzI2LDcgQEAg
c3RhdGljIHZvaWQgcGwyMzAzX3VwZGF0ZV9saW5lX3N0YXR1cyhzdHJ1Y3QgdXNiX3NlcmlhbF9w
b3J0ICpwb3J0LA0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7
DQogCWlmIChwcml2LT5saW5lX3N0YXR1cyAmIFVBUlRfQlJFQUtfRVJST1IpDQogCQl1c2Jfc2Vy
aWFsX2hhbmRsZV9icmVhayhwb3J0KTsNCi0Jd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwcml2LT5k
ZWx0YV9tc3Jfd2FpdCk7DQorCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcG9ydC0+ZGVsdGFfbXNy
X3dhaXQpOw0KIA0KIAl0dHkgPSB0dHlfcG9ydF90dHlfZ2V0KCZwb3J0LT5wb3J0KTsNCiAJaWYg
KCF0dHkpDQpAQCAtNzkyLDcgKzc5Myw3IEBAIHN0YXRpYyB2b2lkIHBsMjMwM19wcm9jZXNzX3Jl
YWRfdXJiKHN0cnVjdCB1cmIgKnVyYikNCiAJbGluZV9zdGF0dXMgPSBwcml2LT5saW5lX3N0YXR1
czsNCiAJcHJpdi0+bGluZV9zdGF0dXMgJj0gflVBUlRfU1RBVEVfVFJBTlNJRU5UX01BU0s7DQog
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCi0Jd2FrZV91cF9p
bnRlcnJ1cHRpYmxlKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQorCXdha2VfdXBfaW50ZXJydXB0
aWJsZSgmcG9ydC0+ZGVsdGFfbXNyX3dhaXQpOw0KIA0KIAlpZiAoIXVyYi0+YWN0dWFsX2xlbmd0
aCkNCiAJCXJldHVybjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvc3BjcDh4NS5j
IGIvZHJpdmVycy91c2Ivc2VyaWFsL3NwY3A4eDUuYw0KaW5kZXggMTgwZWE2Yy4uYmE2YjQzOCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9zcGNwOHg1LmMNCisrKyBiL2RyaXZlcnMv
dXNiL3NlcmlhbC9zcGNwOHg1LmMNCkBAIC0xNjMsNyArMTYzLDYgQEAgc3RhdGljIHN0cnVjdCB1
c2JfZHJpdmVyIHNwY3A4eDVfZHJpdmVyID0gew0KIHN0cnVjdCBzcGNwOHg1X3ByaXZhdGUgew0K
IAlzcGlubG9ja190IAlsb2NrOw0KIAllbnVtIHNwY3A4eDVfdHlwZQl0eXBlOw0KLQl3YWl0X3F1
ZXVlX2hlYWRfdAlkZWx0YV9tc3Jfd2FpdDsNCiAJdTggCQkJbGluZV9jb250cm9sOw0KIAl1OCAJ
CQlsaW5lX3N0YXR1czsNCiB9Ow0KQEAgLTE5Nyw3ICsxOTYsNiBAQCBzdGF0aWMgaW50IHNwY3A4
eDVfc3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsKQ0KIAkJCWdvdG8gY2xlYW51cDsN
CiANCiAJCXNwaW5fbG9ja19pbml0KCZwcml2LT5sb2NrKTsNCi0JCWluaXRfd2FpdHF1ZXVlX2hl
YWQoJnByaXYtPmRlbHRhX21zcl93YWl0KTsNCiAJCXByaXYtPnR5cGUgPSB0eXBlOw0KIAkJdXNi
X3NldF9zZXJpYWxfcG9ydF9kYXRhKHNlcmlhbC0+cG9ydFtpXSAsIHByaXYpOw0KIAl9DQpAQCAt
NTAyLDcgKzUwMCw3IEBAIHN0YXRpYyB2b2lkIHNwY3A4eDVfcHJvY2Vzc19yZWFkX3VyYihzdHJ1
Y3QgdXJiICp1cmIpDQogCXByaXYtPmxpbmVfc3RhdHVzICY9IH5VQVJUX1NUQVRFX1RSQU5TSUVO
VF9NQVNLOw0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7DQog
CS8qIHdha2UgdXAgdGhlIHdhaXQgZm9yIHRlcm1pb3MgKi8NCi0Jd2FrZV91cF9pbnRlcnJ1cHRp
YmxlKCZwcml2LT5kZWx0YV9tc3Jfd2FpdCk7DQorCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcG9y
dC0+ZGVsdGFfbXNyX3dhaXQpOw0KIA0KIAlpZiAoIXVyYi0+YWN0dWFsX2xlbmd0aCkNCiAJCXJl
dHVybjsNCkBAIC01NTIsMTIgKzU1MCwxNSBAQCBzdGF0aWMgaW50IHNwY3A4eDVfd2FpdF9tb2Rl
bV9pbmZvKHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQsDQogDQogCXdoaWxlICgxKSB7DQog
CQkvKiB3YWtlIHVwIGluIGJ1bGsgcmVhZCAqLw0KLQkJaW50ZXJydXB0aWJsZV9zbGVlcF9vbigm
cHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KKwkJaW50ZXJydXB0aWJsZV9zbGVlcF9vbigmcG9ydC0+
ZGVsdGFfbXNyX3dhaXQpOw0KIA0KIAkJLyogc2VlIGlmIGEgc2lnbmFsIGRpZCBpdCAqLw0KIAkJ
aWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KIAkJCXJldHVybiAtRVJFU1RBUlRTWVM7DQog
DQorCQlpZiAocG9ydC0+c2VyaWFsLT5kaXNjb25uZWN0ZWQpDQorCQkJcmV0dXJuIC1FSU87DQor
DQogCQlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0KIAkJc3RhdHVzID0g
cHJpdi0+bGluZV9zdGF0dXM7DQogCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2Nr
LCBmbGFncyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL3NzdTEwMC5jIGIvZHJp
dmVycy91c2Ivc2VyaWFsL3NzdTEwMC5jDQppbmRleCBmZmY3ZjE3Li5iZjFmOGVhIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL3NzdTEwMC5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJp
YWwvc3N1MTAwLmMNCkBAIC03OCw3ICs3OCw2IEBAIHN0cnVjdCBzc3UxMDBfcG9ydF9wcml2YXRl
IHsNCiAJc3BpbmxvY2tfdCBzdGF0dXNfbG9jazsNCiAJdTggc2hhZG93TFNSOw0KIAl1OCBzaGFk
b3dNU1I7DQotCXdhaXRfcXVldWVfaGVhZF90IGRlbHRhX21zcl93YWl0OyAvKiBVc2VkIGZvciBU
SU9DTUlXQUlUICovDQogCXN0cnVjdCBhc3luY19pY291bnQgaWNvdW50Ow0KIH07DQogDQpAQCAt
Mzg3LDggKzM4Niw5IEBAIHN0YXRpYyBpbnQgd2FpdF9tb2RlbV9pbmZvKHN0cnVjdCB1c2Jfc2Vy
aWFsX3BvcnQgKnBvcnQsIHVuc2lnbmVkIGludCBhcmcpDQogCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJnByaXYtPnN0YXR1c19sb2NrLCBmbGFncyk7DQogDQogCXdoaWxlICgxKSB7DQotCQl3YWl0
X2V2ZW50X2ludGVycnVwdGlibGUocHJpdi0+ZGVsdGFfbXNyX3dhaXQsDQotCQkJCQkgKChwcml2
LT5pY291bnQucm5nICE9IHByZXYucm5nKSB8fA0KKwkJd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxl
KHBvcnQtPmRlbHRhX21zcl93YWl0LA0KKwkJCQkJIChwb3J0LT5zZXJpYWwtPmRpc2Nvbm5lY3Rl
ZCB8fA0KKwkJCQkJICAocHJpdi0+aWNvdW50LnJuZyAhPSBwcmV2LnJuZykgfHwNCiAJCQkJCSAg
KHByaXYtPmljb3VudC5kc3IgIT0gcHJldi5kc3IpIHx8DQogCQkJCQkgIChwcml2LT5pY291bnQu
ZGNkICE9IHByZXYuZGNkKSB8fA0KIAkJCQkJICAocHJpdi0+aWNvdW50LmN0cyAhPSBwcmV2LmN0
cykpKTsNCkBAIC0zOTYsNiArMzk2LDkgQEAgc3RhdGljIGludCB3YWl0X21vZGVtX2luZm8oc3Ry
dWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwgdW5zaWduZWQgaW50IGFyZykNCiAJCWlmIChzaWdu
YWxfcGVuZGluZyhjdXJyZW50KSkNCiAJCQlyZXR1cm4gLUVSRVNUQVJUU1lTOw0KIA0KKwkJaWYg
KHBvcnQtPnNlcmlhbC0+ZGlzY29ubmVjdGVkKQ0KKwkJCXJldHVybiAtRUlPOw0KKw0KIAkJc3Bp
bl9sb2NrX2lycXNhdmUoJnByaXYtPnN0YXR1c19sb2NrLCBmbGFncyk7DQogCQljdXIgPSBwcml2
LT5pY291bnQ7DQogCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5zdGF0dXNfbG9jaywg
ZmxhZ3MpOw0KQEAgLTQ3OCw3ICs0ODEsNiBAQCBzdGF0aWMgaW50IHNzdTEwMF9hdHRhY2goc3Ry
dWN0IHVzYl9zZXJpYWwgKnNlcmlhbCkNCiAJfQ0KIA0KIAlzcGluX2xvY2tfaW5pdCgmcHJpdi0+
c3RhdHVzX2xvY2spOw0KLQlpbml0X3dhaXRxdWV1ZV9oZWFkKCZwcml2LT5kZWx0YV9tc3Jfd2Fp
dCk7DQogCXVzYl9zZXRfc2VyaWFsX3BvcnRfZGF0YShwb3J0LCBwcml2KTsNCiANCiAJcmV0dXJu
IHNzdTEwMF9pbml0ZGV2aWNlKHNlcmlhbC0+ZGV2KTsNCkBAIC01NjQsNyArNTY2LDcgQEAgc3Rh
dGljIHZvaWQgc3N1MTAwX3VwZGF0ZV9tc3Ioc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwg
dTggbXNyKQ0KIAkJCXByaXYtPmljb3VudC5kY2QrKzsNCiAJCWlmIChtc3IgJiBVQVJUX01TUl9U
RVJJKQ0KIAkJCXByaXYtPmljb3VudC5ybmcrKzsNCi0JCXdha2VfdXBfaW50ZXJydXB0aWJsZSgm
cHJpdi0+ZGVsdGFfbXNyX3dhaXQpOw0KKwkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwb3J0LT5k
ZWx0YV9tc3Jfd2FpdCk7DQogCX0NCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2Vy
aWFsL3RpX3VzYl8zNDEwXzUwNTIuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC90aV91c2JfMzQxMF81
MDUyLmMNCmluZGV4IDI4NTY0NzQuLjRiODA1YmUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9z
ZXJpYWwvdGlfdXNiXzM0MTBfNTA1Mi5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvdGlfdXNi
XzM0MTBfNTA1Mi5jDQpAQCAtNzUsNyArNzUsNiBAQCBzdHJ1Y3QgdGlfcG9ydCB7DQogCWludAkJ
CXRwX2ZsYWdzOw0KIAlpbnQJCQl0cF9jbG9zaW5nX3dhaXQ7LyogaW4gLjAxIHNlY3MgKi8NCiAJ
c3RydWN0IGFzeW5jX2ljb3VudAl0cF9pY291bnQ7DQotCXdhaXRfcXVldWVfaGVhZF90CXRwX21z
cl93YWl0OwkvKiB3YWl0IGZvciBtc3IgY2hhbmdlICovDQogCXdhaXRfcXVldWVfaGVhZF90CXRw
X3dyaXRlX3dhaXQ7DQogCXN0cnVjdCB0aV9kZXZpY2UJKnRwX3RkZXY7DQogCXN0cnVjdCB1c2Jf
c2VyaWFsX3BvcnQJKnRwX3BvcnQ7DQpAQCAtNDQ3LDcgKzQ0Niw2IEBAIHN0YXRpYyBpbnQgdGlf
c3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsKQ0KIAkJdHBvcnQtPnRwX3VhcnRfYmFz
ZV9hZGRyID0gKGkgPT0gMCA/DQogCQkJCVRJX1VBUlQxX0JBU0VfQUREUiA6IFRJX1VBUlQyX0JB
U0VfQUREUik7DQogCQl0cG9ydC0+dHBfY2xvc2luZ193YWl0ID0gY2xvc2luZ193YWl0Ow0KLQkJ
aW5pdF93YWl0cXVldWVfaGVhZCgmdHBvcnQtPnRwX21zcl93YWl0KTsNCiAJCWluaXRfd2FpdHF1
ZXVlX2hlYWQoJnRwb3J0LT50cF93cml0ZV93YWl0KTsNCiAJCWlmIChrZmlmb19hbGxvYygmdHBv
cnQtPndyaXRlX2ZpZm8sIFRJX1dSSVRFX0JVRl9TSVpFLA0KIAkJCQkJCQkJR0ZQX0tFUk5FTCkp
IHsNCkBAIC04NDgsOSArODQ2LDEzIEBAIHN0YXRpYyBpbnQgdGlfaW9jdGwoc3RydWN0IHR0eV9z
dHJ1Y3QgKnR0eSwNCiAJCWRiZygiJXMgLSAoJWQpIFRJT0NNSVdBSVQiLCBfX2Z1bmNfXywgcG9y
dC0+bnVtYmVyKTsNCiAJCWNwcmV2ID0gdHBvcnQtPnRwX2ljb3VudDsNCiAJCXdoaWxlICgxKSB7
DQotCQkJaW50ZXJydXB0aWJsZV9zbGVlcF9vbigmdHBvcnQtPnRwX21zcl93YWl0KTsNCisJCQlp
bnRlcnJ1cHRpYmxlX3NsZWVwX29uKCZwb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQkJaWYgKHNp
Z25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KIAkJCQlyZXR1cm4gLUVSRVNUQVJUU1lTOw0KKw0KKwkJ
CWlmIChwb3J0LT5zZXJpYWwtPmRpc2Nvbm5lY3RlZCkNCisJCQkJcmV0dXJuIC1FSU87DQorDQog
CQkJY25vdyA9IHRwb3J0LT50cF9pY291bnQ7DQogCQkJaWYgKGNub3cucm5nID09IGNwcmV2LnJu
ZyAmJiBjbm93LmRzciA9PSBjcHJldi5kc3IgJiYNCiAJCQkgICAgY25vdy5kY2QgPT0gY3ByZXYu
ZGNkICYmIGNub3cuY3RzID09IGNwcmV2LmN0cykNCkBAIC0xNDgxLDcgKzE0ODMsNyBAQCBzdGF0
aWMgdm9pZCB0aV9oYW5kbGVfbmV3X21zcihzdHJ1Y3QgdGlfcG9ydCAqdHBvcnQsIF9fdTggbXNy
KQ0KIAkJCWljb3VudC0+ZGNkKys7DQogCQlpZiAobXNyICYgVElfTVNSX0RFTFRBX1JJKQ0KIAkJ
CWljb3VudC0+cm5nKys7DQotCQl3YWtlX3VwX2ludGVycnVwdGlibGUoJnRwb3J0LT50cF9tc3Jf
d2FpdCk7DQorCQl3YWtlX3VwX2ludGVycnVwdGlibGUoJnRwb3J0LT50cF9wb3J0LT5kZWx0YV9t
c3Jfd2FpdCk7DQogCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZ0cG9ydC0+dHBfbG9jaywgZmxh
Z3MpOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL3VzYi1zZXJpYWwu
YyBiL2RyaXZlcnMvdXNiL3NlcmlhbC91c2Itc2VyaWFsLmMNCmluZGV4IDI0ODJkNWUuLjg1MGZh
YTQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvdXNiLXNlcmlhbC5jDQorKysgYi9k
cml2ZXJzL3VzYi9zZXJpYWwvdXNiLXNlcmlhbC5jDQpAQCAtOTA1LDYgKzkwNSw3IEBAIGludCB1
c2Jfc2VyaWFsX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRlcmZhY2UsDQogCQlwb3J0
LT5wb3J0Lm9wcyA9ICZzZXJpYWxfcG9ydF9vcHM7DQogCQlwb3J0LT5zZXJpYWwgPSBzZXJpYWw7
DQogCQlzcGluX2xvY2tfaW5pdCgmcG9ydC0+bG9jayk7DQorCQlpbml0X3dhaXRxdWV1ZV9oZWFk
KCZwb3J0LT5kZWx0YV9tc3Jfd2FpdCk7DQogCQkvKiBLZWVwIHRoaXMgZm9yIHByaXZhdGUgZHJp
dmVyIHVzZSBmb3IgdGhlIG1vbWVudCBidXQNCiAJCSAgIHNob3VsZCBwcm9iYWJseSBnbyBhd2F5
ICovDQogCQlJTklUX1dPUksoJnBvcnQtPndvcmssIHVzYl9zZXJpYWxfcG9ydF93b3JrKTsNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2NvbnNvbGUvZmJjb24uYyBiL2RyaXZlcnMvdmlkZW8v
Y29uc29sZS9mYmNvbi5jDQppbmRleCA5YjhiY2FiLi43YTM2ZGZmIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy92aWRlby9jb25zb2xlL2ZiY29uLmMNCisrKyBiL2RyaXZlcnMvdmlkZW8vY29uc29sZS9m
YmNvbi5jDQpAQCAtODQzLDYgKzg0Myw4IEBAIHN0YXRpYyB2b2lkIGNvbjJmYl9pbml0X2Rpc3Bs
YXkoc3RydWN0IHZjX2RhdGEgKnZjLCBzdHJ1Y3QgZmJfaW5mbyAqaW5mbywNCiAgKg0KICAqCU1h
cHMgYSB2aXJ0dWFsIGNvbnNvbGUgQHVuaXQgdG8gYSBmcmFtZSBidWZmZXIgZGV2aWNlDQogICoJ
QG5ld2lkeC4NCisgKg0KKyAqCVRoaXMgc2hvdWxkIGJlIGNhbGxlZCB3aXRoIHRoZSBjb25zb2xl
IGxvY2sgaGVsZC4NCiAgKi8NCiBzdGF0aWMgaW50IHNldF9jb24yZmJfbWFwKGludCB1bml0LCBp
bnQgbmV3aWR4LCBpbnQgdXNlcikNCiB7DQpAQCAtODYwLDcgKzg2Miw3IEBAIHN0YXRpYyBpbnQg
c2V0X2NvbjJmYl9tYXAoaW50IHVuaXQsIGludCBuZXdpZHgsIGludCB1c2VyKQ0KIA0KIAlpZiAo
IXNlYXJjaF9mb3JfbWFwcGVkX2NvbigpIHx8ICFjb25faXNfYm91bmQoJmZiX2NvbikpIHsNCiAJ
CWluZm9faWR4ID0gbmV3aWR4Ow0KLQkJcmV0dXJuIGZiY29uX3Rha2VvdmVyKDApOw0KKwkJcmV0
dXJuIGRvX2ZiY29uX3Rha2VvdmVyKDApOw0KIAl9DQogDQogCWlmIChvbGRpZHggIT0gLTEpDQpA
QCAtODY4LDcgKzg3MCw2IEBAIHN0YXRpYyBpbnQgc2V0X2NvbjJmYl9tYXAoaW50IHVuaXQsIGlu
dCBuZXdpZHgsIGludCB1c2VyKQ0KIA0KIAlmb3VuZCA9IHNlYXJjaF9mYl9pbl9tYXAobmV3aWR4
KTsNCiANCi0JY29uc29sZV9sb2NrKCk7DQogCWNvbjJmYl9tYXBbdW5pdF0gPSBuZXdpZHg7DQog
CWlmICghZXJyICYmICFmb3VuZCkNCiAgCQllcnIgPSBjb24yZmJfYWNxdWlyZV9uZXdpbmZvKHZj
LCBpbmZvLCB1bml0LCBvbGRpZHgpOw0KQEAgLTg5NSw3ICs4OTYsNiBAQCBzdGF0aWMgaW50IHNl
dF9jb24yZmJfbWFwKGludCB1bml0LCBpbnQgbmV3aWR4LCBpbnQgdXNlcikNCiAJaWYgKCFzZWFy
Y2hfZmJfaW5fbWFwKGluZm9faWR4KSkNCiAJCWluZm9faWR4ID0gbmV3aWR4Ow0KIA0KLQljb25z
b2xlX3VubG9jaygpOw0KICAJcmV0dXJuIGVycjsNCiB9DQogDQpAQCAtMzAyNiw2ICszMDI2LDcg
QEAgc3RhdGljIGlubGluZSBpbnQgZmJjb25fdW5iaW5kKHZvaWQpDQogfQ0KICNlbmRpZiAvKiBD
T05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HICovDQogDQorLyogY2FsbGVkIHdpdGggY29uc29s
ZV9sb2NrIGhlbGQgKi8NCiBzdGF0aWMgaW50IGZiY29uX2ZiX3VuYmluZChpbnQgaWR4KQ0KIHsN
CiAJaW50IGksIG5ld19pZHggPSAtMSwgcmV0ID0gMDsNCkBAIC0zMDUyLDYgKzMwNTMsNyBAQCBz
dGF0aWMgaW50IGZiY29uX2ZiX3VuYmluZChpbnQgaWR4KQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiAN
CisvKiBjYWxsZWQgd2l0aCBjb25zb2xlX2xvY2sgaGVsZCAqLw0KIHN0YXRpYyBpbnQgZmJjb25f
ZmJfdW5yZWdpc3RlcmVkKHN0cnVjdCBmYl9pbmZvICppbmZvKQ0KIHsNCiAJaW50IGksIGlkeDsN
CkBAIC0zMDg5LDYgKzMwOTEsNyBAQCBzdGF0aWMgaW50IGZiY29uX2ZiX3VucmVnaXN0ZXJlZChz
dHJ1Y3QgZmJfaW5mbyAqaW5mbykNCiAJcmV0dXJuIDA7DQogfQ0KIA0KKy8qIGNhbGxlZCB3aXRo
IGNvbnNvbGVfbG9jayBoZWxkICovDQogc3RhdGljIHZvaWQgZmJjb25fcmVtYXBfYWxsKGludCBp
ZHgpDQogew0KIAlpbnQgaTsNCkBAIC0zMTMzLDYgKzMxMzYsNyBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgZmJjb25fc2VsZWN0X3ByaW1hcnkoc3RydWN0IGZiX2luZm8gKmluZm8pDQogfQ0KICNlbmRp
ZiAvKiBDT05GSUdfRlJBTUVCVUZGRVJfREVURUNUX1BSSU1BUlkgKi8NCiANCisvKiBjYWxsZWQg
d2l0aCBjb25zb2xlX2xvY2sgaGVsZCAqLw0KIHN0YXRpYyBpbnQgZmJjb25fZmJfcmVnaXN0ZXJl
ZChzdHJ1Y3QgZmJfaW5mbyAqaW5mbykNCiB7DQogCWludCByZXQgPSAwLCBpLCBpZHg7DQpAQCAt
MzI4NSw2ICszMjg5LDcgQEAgc3RhdGljIGludCBmYmNvbl9ldmVudF9ub3RpZnkoc3RydWN0IG5v
dGlmaWVyX2Jsb2NrICpzZWxmLA0KIAkJcmV0ID0gZmJjb25fZmJfdW5yZWdpc3RlcmVkKGluZm8p
Ow0KIAkJYnJlYWs7DQogCWNhc2UgRkJfRVZFTlRfU0VUX0NPTlNPTEVfTUFQOg0KKwkJLyogY2Fs
bGVkIHdpdGggY29uc29sZSBsb2NrIGhlbGQgKi8NCiAJCWNvbjJmYiA9IGV2ZW50LT5kYXRhOw0K
IAkJcmV0ID0gc2V0X2NvbjJmYl9tYXAoY29uMmZiLT5jb25zb2xlIC0gMSwNCiAJCQkJICAgICBj
b24yZmItPmZyYW1lYnVmZmVyLCAxKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2ZibWVt
LmMgYi9kcml2ZXJzL3ZpZGVvL2ZibWVtLmMNCmluZGV4IGMxMzNkZGUuLmJhYmJiMDcgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3ZpZGVvL2ZibWVtLmMNCisrKyBiL2RyaXZlcnMvdmlkZW8vZmJtZW0u
Yw0KQEAgLTExNTQsOCArMTE1NCwxMCBAQCBzdGF0aWMgbG9uZyBkb19mYl9pb2N0bChzdHJ1Y3Qg
ZmJfaW5mbyAqaW5mbywgdW5zaWduZWQgaW50IGNtZCwNCiAJCWV2ZW50LmRhdGEgPSAmY29uMmZi
Ow0KIAkJaWYgKCFsb2NrX2ZiX2luZm8oaW5mbykpDQogCQkJcmV0dXJuIC1FTk9ERVY7DQorCQlj
b25zb2xlX2xvY2soKTsNCiAJCWV2ZW50LmluZm8gPSBpbmZvOw0KIAkJcmV0ID0gZmJfbm90aWZp
ZXJfY2FsbF9jaGFpbihGQl9FVkVOVF9TRVRfQ09OU09MRV9NQVAsICZldmVudCk7DQorCQljb25z
b2xlX3VubG9jaygpOw0KIAkJdW5sb2NrX2ZiX2luZm8oaW5mbyk7DQogCQlicmVhazsNCiAJY2Fz
ZSBGQklPQkxBTks6DQpkaWZmIC0tZ2l0IGEvZnMvYnRyZnMvZXh0ZW50X2lvLmMgYi9mcy9idHJm
cy9leHRlbnRfaW8uYw0KaW5kZXggNDlmM2M5ZC4uNzNlNGNiYyAxMDA2NDQNCi0tLSBhL2ZzL2J0
cmZzL2V4dGVudF9pby5jDQorKysgYi9mcy9idHJmcy9leHRlbnRfaW8uYw0KQEAgLTEyMDksNiAr
MTIwOSwzOSBAQCBpbnQgdW5sb2NrX2V4dGVudChzdHJ1Y3QgZXh0ZW50X2lvX3RyZWUgKnRyZWUs
IHU2NCBzdGFydCwgdTY0IGVuZCwgZ2ZwX3QgbWFzaykNCiAJCQkJbWFzayk7DQogfQ0KIA0KK2lu
dCBleHRlbnRfcmFuZ2VfY2xlYXJfZGlydHlfZm9yX2lvKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHU2
NCBzdGFydCwgdTY0IGVuZCkNCit7DQorCXVuc2lnbmVkIGxvbmcgaW5kZXggPSBzdGFydCA+PiBQ
QUdFX0NBQ0hFX1NISUZUOw0KKwl1bnNpZ25lZCBsb25nIGVuZF9pbmRleCA9IGVuZCA+PiBQQUdF
X0NBQ0hFX1NISUZUOw0KKwlzdHJ1Y3QgcGFnZSAqcGFnZTsNCisNCisJd2hpbGUgKGluZGV4IDw9
IGVuZF9pbmRleCkgew0KKwkJcGFnZSA9IGZpbmRfZ2V0X3BhZ2UoaW5vZGUtPmlfbWFwcGluZywg
aW5kZXgpOw0KKwkJQlVHX09OKCFwYWdlKTsgLyogUGFnZXMgc2hvdWxkIGJlIGluIHRoZSBleHRl
bnRfaW9fdHJlZSAqLw0KKwkJY2xlYXJfcGFnZV9kaXJ0eV9mb3JfaW8ocGFnZSk7DQorCQlwYWdl
X2NhY2hlX3JlbGVhc2UocGFnZSk7DQorCQlpbmRleCsrOw0KKwl9DQorCXJldHVybiAwOw0KK30N
CisNCitpbnQgZXh0ZW50X3JhbmdlX3JlZGlydHlfZm9yX2lvKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IHU2NCBzdGFydCwgdTY0IGVuZCkNCit7DQorCXVuc2lnbmVkIGxvbmcgaW5kZXggPSBzdGFydCA+
PiBQQUdFX0NBQ0hFX1NISUZUOw0KKwl1bnNpZ25lZCBsb25nIGVuZF9pbmRleCA9IGVuZCA+PiBQ
QUdFX0NBQ0hFX1NISUZUOw0KKwlzdHJ1Y3QgcGFnZSAqcGFnZTsNCisNCisJd2hpbGUgKGluZGV4
IDw9IGVuZF9pbmRleCkgew0KKwkJcGFnZSA9IGZpbmRfZ2V0X3BhZ2UoaW5vZGUtPmlfbWFwcGlu
ZywgaW5kZXgpOw0KKwkJQlVHX09OKCFwYWdlKTsgLyogUGFnZXMgc2hvdWxkIGJlIGluIHRoZSBl
eHRlbnRfaW9fdHJlZSAqLw0KKwkJYWNjb3VudF9wYWdlX3JlZGlydHkocGFnZSk7DQorCQlfX3Nl
dF9wYWdlX2RpcnR5X25vYnVmZmVycyhwYWdlKTsNCisJCXBhZ2VfY2FjaGVfcmVsZWFzZShwYWdl
KTsNCisJCWluZGV4Kys7DQorCX0NCisJcmV0dXJuIDA7DQorfQ0KKw0KIC8qDQogICogaGVscGVy
IGZ1bmN0aW9uIHRvIHNldCBib3RoIHBhZ2VzIGFuZCBleHRlbnRzIGluIHRoZSB0cmVlIHdyaXRl
YmFjaw0KICAqLw0KZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2V4dGVudF9pby5oIGIvZnMvYnRyZnMv
ZXh0ZW50X2lvLmgNCmluZGV4IDc2MDRjMzAuLjJlMzI1MTAgMTAwNjQ0DQotLS0gYS9mcy9idHJm
cy9leHRlbnRfaW8uaA0KKysrIGIvZnMvYnRyZnMvZXh0ZW50X2lvLmgNCkBAIC0zMDQsNiArMzA0
LDggQEAgaW50IG1hcF9wcml2YXRlX2V4dGVudF9idWZmZXIoc3RydWN0IGV4dGVudF9idWZmZXIg
KmViLCB1bnNpZ25lZCBsb25nIG9mZnNldCwNCiAJCSAgICAgIHVuc2lnbmVkIGxvbmcgKm1hcF9s
ZW4pOw0KIGludCBleHRlbnRfcmFuZ2VfdXB0b2RhdGUoc3RydWN0IGV4dGVudF9pb190cmVlICp0
cmVlLA0KIAkJCSAgdTY0IHN0YXJ0LCB1NjQgZW5kKTsNCitpbnQgZXh0ZW50X3JhbmdlX2NsZWFy
X2RpcnR5X2Zvcl9pbyhzdHJ1Y3QgaW5vZGUgKmlub2RlLCB1NjQgc3RhcnQsIHU2NCBlbmQpOw0K
K2ludCBleHRlbnRfcmFuZ2VfcmVkaXJ0eV9mb3JfaW8oc3RydWN0IGlub2RlICppbm9kZSwgdTY0
IHN0YXJ0LCB1NjQgZW5kKTsNCiBpbnQgZXh0ZW50X2NsZWFyX3VubG9ja19kZWxhbGxvYyhzdHJ1
Y3QgaW5vZGUgKmlub2RlLA0KIAkJCQlzdHJ1Y3QgZXh0ZW50X2lvX3RyZWUgKnRyZWUsDQogCQkJ
CXU2NCBzdGFydCwgdTY0IGVuZCwgc3RydWN0IHBhZ2UgKmxvY2tlZF9wYWdlLA0KZGlmZiAtLWdp
dCBhL2ZzL2J0cmZzL2lub2RlLmMgYi9mcy9idHJmcy9pbm9kZS5jDQppbmRleCBmZDFhMDZkLi4x
MzcyNjM0IDEwMDY0NA0KLS0tIGEvZnMvYnRyZnMvaW5vZGUuYw0KKysrIGIvZnMvYnRyZnMvaW5v
ZGUuYw0KQEAgLTM0Myw2ICszNDMsNyBAQCBzdGF0aWMgbm9pbmxpbmUgaW50IGNvbXByZXNzX2Zp
bGVfcmFuZ2Uoc3RydWN0IGlub2RlICppbm9kZSwNCiAJaW50IGk7DQogCWludCB3aWxsX2NvbXBy
ZXNzOw0KIAlpbnQgY29tcHJlc3NfdHlwZSA9IHJvb3QtPmZzX2luZm8tPmNvbXByZXNzX3R5cGU7
DQorCWludCByZWRpcnR5ID0gMDsNCiANCiAJLyogaWYgdGhpcyBpcyBhIHNtYWxsIHdyaXRlIGlu
c2lkZSBlb2YsIGtpY2sgb2ZmIGEgZGVmcmFnYm90ICovDQogCWlmIChlbmQgPD0gQlRSRlNfSShp
bm9kZSktPmRpc2tfaV9zaXplICYmIChlbmQgLSBzdGFydCArIDEpIDwgMTYgKiAxMDI0KQ0KQEAg
LTQwNCw2ICs0MDUsMTcgQEAgYWdhaW46DQogCQlpZiAoQlRSRlNfSShpbm9kZSktPmZvcmNlX2Nv
bXByZXNzKQ0KIAkJCWNvbXByZXNzX3R5cGUgPSBCVFJGU19JKGlub2RlKS0+Zm9yY2VfY29tcHJl
c3M7DQogDQorCQkvKg0KKwkJICogd2UgbmVlZCB0byBjYWxsIGNsZWFyX3BhZ2VfZGlydHlfZm9y
X2lvIG9uIGVhY2gNCisJCSAqIHBhZ2UgaW4gdGhlIHJhbmdlLiAgT3RoZXJ3aXNlIGFwcGxpY2F0
aW9ucyB3aXRoIHRoZSBmaWxlDQorCQkgKiBtbWFwJ2QgY2FuIHdhbmRlciBpbiBhbmQgY2hhbmdl
IHRoZSBwYWdlIGNvbnRlbnRzIHdoaWxlDQorCQkgKiB3ZSBhcmUgY29tcHJlc3NpbmcgdGhlbS4N
CisJCSAqDQorCQkgKiBJZiB0aGUgY29tcHJlc3Npb24gZmFpbHMgZm9yIGFueSByZWFzb24sIHdl
IHNldCB0aGUgcGFnZXMNCisJCSAqIGRpcnR5IGFnYWluIGxhdGVyIG9uLg0KKwkJICovDQorCQll
eHRlbnRfcmFuZ2VfY2xlYXJfZGlydHlfZm9yX2lvKGlub2RlLCBzdGFydCwgZW5kKTsNCisJCXJl
ZGlydHkgPSAxOw0KIAkJcmV0ID0gYnRyZnNfY29tcHJlc3NfcGFnZXMoY29tcHJlc3NfdHlwZSwN
CiAJCQkJCSAgIGlub2RlLT5pX21hcHBpbmcsIHN0YXJ0LA0KIAkJCQkJICAgdG90YWxfY29tcHJl
c3NlZCwgcGFnZXMsDQpAQCAtNTQxLDYgKzU1Myw4IEBAIGNsZWFudXBfYW5kX2JhaWxfdW5jb21w
cmVzc2VkOg0KIAkJCV9fc2V0X3BhZ2VfZGlydHlfbm9idWZmZXJzKGxvY2tlZF9wYWdlKTsNCiAJ
CQkvKiB1bmxvY2tlZCBsYXRlciBvbiBpbiB0aGUgYXN5bmMgaGFuZGxlcnMgKi8NCiAJCX0NCisJ
CWlmIChyZWRpcnR5KQ0KKwkJCWV4dGVudF9yYW5nZV9yZWRpcnR5X2Zvcl9pbyhpbm9kZSwgc3Rh
cnQsIGVuZCk7DQogCQlhZGRfYXN5bmNfZXh0ZW50KGFzeW5jX2Nvdywgc3RhcnQsIGVuZCAtIHN0
YXJ0ICsgMSwNCiAJCQkJIDAsIE5VTEwsIDAsIEJUUkZTX0NPTVBSRVNTX05PTkUpOw0KIAkJKm51
bV9hZGRlZCArPSAxOw0KZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL3RyZWUtbG9nLmMgYi9mcy9idHJm
cy90cmVlLWxvZy5jDQppbmRleCAxOWIxMjdjLi4yMWZhYTEyIDEwMDY0NA0KLS0tIGEvZnMvYnRy
ZnMvdHJlZS1sb2cuYw0KKysrIGIvZnMvYnRyZnMvdHJlZS1sb2cuYw0KQEAgLTMxNiw2ICszMTYs
NyBAQCBzdGF0aWMgbm9pbmxpbmUgaW50IG92ZXJ3cml0ZV9pdGVtKHN0cnVjdCBidHJmc190cmFu
c19oYW5kbGUgKnRyYW5zLA0KIAl1bnNpZ25lZCBsb25nIHNyY19wdHI7DQogCXVuc2lnbmVkIGxv
bmcgZHN0X3B0cjsNCiAJaW50IG92ZXJ3cml0ZV9yb290ID0gMDsNCisJYm9vbCBpbm9kZV9pdGVt
ID0ga2V5LT50eXBlID09IEJUUkZTX0lOT0RFX0lURU1fS0VZOw0KIA0KIAlpZiAocm9vdC0+cm9v
dF9rZXkub2JqZWN0aWQgIT0gQlRSRlNfVFJFRV9MT0dfT0JKRUNUSUQpDQogCQlvdmVyd3JpdGVf
cm9vdCA9IDE7DQpAQCAtMzI1LDYgKzMyNiw5IEBAIHN0YXRpYyBub2lubGluZSBpbnQgb3Zlcndy
aXRlX2l0ZW0oc3RydWN0IGJ0cmZzX3RyYW5zX2hhbmRsZSAqdHJhbnMsDQogDQogCS8qIGxvb2sg
Zm9yIHRoZSBrZXkgaW4gdGhlIGRlc3RpbmF0aW9uIHRyZWUgKi8NCiAJcmV0ID0gYnRyZnNfc2Vh
cmNoX3Nsb3QoTlVMTCwgcm9vdCwga2V5LCBwYXRoLCAwLCAwKTsNCisJaWYgKHJldCA8IDApDQor
CQlyZXR1cm4gcmV0Ow0KKw0KIAlpZiAocmV0ID09IDApIHsNCiAJCWNoYXIgKnNyY19jb3B5Ow0K
IAkJY2hhciAqZHN0X2NvcHk7DQpAQCAtMzY2LDYgKzM3MCwzMCBAQCBzdGF0aWMgbm9pbmxpbmUg
aW50IG92ZXJ3cml0ZV9pdGVtKHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0KIAkJ
CXJldHVybiAwOw0KIAkJfQ0KIA0KKwkJLyoNCisJCSAqIFdlIG5lZWQgdG8gbG9hZCB0aGUgb2xk
IG5ieXRlcyBpbnRvIHRoZSBpbm9kZSBzbyB3aGVuIHdlDQorCQkgKiByZXBsYXkgdGhlIGV4dGVu
dHMgd2UndmUgbG9nZ2VkIHdlIGdldCB0aGUgcmlnaHQgbmJ5dGVzLg0KKwkJICovDQorCQlpZiAo
aW5vZGVfaXRlbSkgew0KKwkJCXN0cnVjdCBidHJmc19pbm9kZV9pdGVtICppdGVtOw0KKwkJCXU2
NCBuYnl0ZXM7DQorDQorCQkJaXRlbSA9IGJ0cmZzX2l0ZW1fcHRyKHBhdGgtPm5vZGVzWzBdLCBw
YXRoLT5zbG90c1swXSwNCisJCQkJCSAgICAgIHN0cnVjdCBidHJmc19pbm9kZV9pdGVtKTsNCisJ
CQluYnl0ZXMgPSBidHJmc19pbm9kZV9uYnl0ZXMocGF0aC0+bm9kZXNbMF0sIGl0ZW0pOw0KKwkJ
CWl0ZW0gPSBidHJmc19pdGVtX3B0cihlYiwgc2xvdCwNCisJCQkJCSAgICAgIHN0cnVjdCBidHJm
c19pbm9kZV9pdGVtKTsNCisJCQlidHJmc19zZXRfaW5vZGVfbmJ5dGVzKGViLCBpdGVtLCBuYnl0
ZXMpOw0KKwkJfQ0KKwl9IGVsc2UgaWYgKGlub2RlX2l0ZW0pIHsNCisJCXN0cnVjdCBidHJmc19p
bm9kZV9pdGVtICppdGVtOw0KKw0KKwkJLyoNCisJCSAqIE5ldyBpbm9kZSwgc2V0IG5ieXRlcyB0
byAwIHNvIHRoYXQgdGhlIG5ieXRlcyBjb21lcyBvdXQNCisJCSAqIHByb3Blcmx5IHdoZW4gd2Ug
cmVwbGF5IHRoZSBleHRlbnRzLg0KKwkJICovDQorCQlpdGVtID0gYnRyZnNfaXRlbV9wdHIoZWIs
IHNsb3QsIHN0cnVjdCBidHJmc19pbm9kZV9pdGVtKTsNCisJCWJ0cmZzX3NldF9pbm9kZV9uYnl0
ZXMoZWIsIGl0ZW0sIDApOw0KIAl9DQogaW5zZXJ0Og0KIAlidHJmc19yZWxlYXNlX3BhdGgocGF0
aCk7DQpAQCAtNDg4LDcgKzUxNiw3IEBAIHN0YXRpYyBub2lubGluZSBpbnQgcmVwbGF5X29uZV9l
eHRlbnQoc3RydWN0IGJ0cmZzX3RyYW5zX2hhbmRsZSAqdHJhbnMsDQogCXU2NCBleHRlbnRfZW5k
Ow0KIAl1NjQgYWxsb2NfaGludDsNCiAJdTY0IHN0YXJ0ID0ga2V5LT5vZmZzZXQ7DQotCXU2NCBz
YXZlZF9uYnl0ZXM7DQorCXU2NCBuYnl0ZXMgPSAwOw0KIAlzdHJ1Y3QgYnRyZnNfZmlsZV9leHRl
bnRfaXRlbSAqaXRlbTsNCiAJc3RydWN0IGlub2RlICppbm9kZSA9IE5VTEw7DQogCXVuc2lnbmVk
IGxvbmcgc2l6ZTsNCkBAIC00OTgsMTAgKzUyNiwxOSBAQCBzdGF0aWMgbm9pbmxpbmUgaW50IHJl
cGxheV9vbmVfZXh0ZW50KHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0KIAlmb3Vu
ZF90eXBlID0gYnRyZnNfZmlsZV9leHRlbnRfdHlwZShlYiwgaXRlbSk7DQogDQogCWlmIChmb3Vu
ZF90eXBlID09IEJUUkZTX0ZJTEVfRVhURU5UX1JFRyB8fA0KLQkgICAgZm91bmRfdHlwZSA9PSBC
VFJGU19GSUxFX0VYVEVOVF9QUkVBTExPQykNCi0JCWV4dGVudF9lbmQgPSBzdGFydCArIGJ0cmZz
X2ZpbGVfZXh0ZW50X251bV9ieXRlcyhlYiwgaXRlbSk7DQotCWVsc2UgaWYgKGZvdW5kX3R5cGUg
PT0gQlRSRlNfRklMRV9FWFRFTlRfSU5MSU5FKSB7DQorCSAgICBmb3VuZF90eXBlID09IEJUUkZT
X0ZJTEVfRVhURU5UX1BSRUFMTE9DKSB7DQorCQluYnl0ZXMgPSBidHJmc19maWxlX2V4dGVudF9u
dW1fYnl0ZXMoZWIsIGl0ZW0pOw0KKwkJZXh0ZW50X2VuZCA9IHN0YXJ0ICsgbmJ5dGVzOw0KKw0K
KwkJLyoNCisJCSAqIFdlIGRvbid0IGFkZCB0byB0aGUgaW5vZGVzIG5ieXRlcyBpZiB3ZSBhcmUg
cHJlYWxsb2Mgb3IgYQ0KKwkJICogaG9sZS4NCisJCSAqLw0KKwkJaWYgKGJ0cmZzX2ZpbGVfZXh0
ZW50X2Rpc2tfYnl0ZW5yKGViLCBpdGVtKSA9PSAwKQ0KKwkJCW5ieXRlcyA9IDA7DQorCX0gZWxz
ZSBpZiAoZm91bmRfdHlwZSA9PSBCVFJGU19GSUxFX0VYVEVOVF9JTkxJTkUpIHsNCiAJCXNpemUg
PSBidHJmc19maWxlX2V4dGVudF9pbmxpbmVfbGVuKGViLCBpdGVtKTsNCisJCW5ieXRlcyA9IGJ0
cmZzX2ZpbGVfZXh0ZW50X3JhbV9ieXRlcyhlYiwgaXRlbSk7DQogCQlleHRlbnRfZW5kID0gKHN0
YXJ0ICsgc2l6ZSArIG1hc2spICYgfm1hc2s7DQogCX0gZWxzZSB7DQogCQlyZXQgPSAwOw0KQEAg
LTU1MCw3ICs1ODcsNiBAQCBzdGF0aWMgbm9pbmxpbmUgaW50IHJlcGxheV9vbmVfZXh0ZW50KHN0
cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0KIAl9DQogCWJ0cmZzX3JlbGVhc2VfcGF0
aChwYXRoKTsNCiANCi0Jc2F2ZWRfbmJ5dGVzID0gaW5vZGVfZ2V0X2J5dGVzKGlub2RlKTsNCiAJ
LyogZHJvcCBhbnkgb3ZlcmxhcHBpbmcgZXh0ZW50cyAqLw0KIAlyZXQgPSBidHJmc19kcm9wX2V4
dGVudHModHJhbnMsIGlub2RlLCBzdGFydCwgZXh0ZW50X2VuZCwNCiAJCQkJICZhbGxvY19oaW50
LCAxKTsNCkBAIC02MzgsNyArNjc0LDcgQEAgc3RhdGljIG5vaW5saW5lIGludCByZXBsYXlfb25l
X2V4dGVudChzdHJ1Y3QgYnRyZnNfdHJhbnNfaGFuZGxlICp0cmFucywNCiAJCUJVR19PTihyZXQp
Ow0KIAl9DQogDQotCWlub2RlX3NldF9ieXRlcyhpbm9kZSwgc2F2ZWRfbmJ5dGVzKTsNCisJaW5v
ZGVfYWRkX2J5dGVzKGlub2RlLCBuYnl0ZXMpOw0KIAlidHJmc191cGRhdGVfaW5vZGUodHJhbnMs
IHJvb3QsIGlub2RlKTsNCiBvdXQ6DQogCWlmIChpbm9kZSkNCmRpZmYgLS1naXQgYS9mcy9oZnNw
bHVzL2V4dGVudHMuYyBiL2ZzL2hmc3BsdXMvZXh0ZW50cy5jDQppbmRleCA1ODQ5ZTNlLi4zMmIx
MmU1IDEwMDY0NA0KLS0tIGEvZnMvaGZzcGx1cy9leHRlbnRzLmMNCisrKyBiL2ZzL2hmc3BsdXMv
ZXh0ZW50cy5jDQpAQCAtNTE3LDcgKzUxNyw3IEBAIHZvaWQgaGZzcGx1c19maWxlX3RydW5jYXRl
KHN0cnVjdCBpbm9kZSAqaW5vZGUpDQogCQlzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZyA9
IGlub2RlLT5pX21hcHBpbmc7DQogCQlzdHJ1Y3QgcGFnZSAqcGFnZTsNCiAJCXZvaWQgKmZzZGF0
YTsNCi0JCXUzMiBzaXplID0gaW5vZGUtPmlfc2l6ZTsNCisJCWxvZmZfdCBzaXplID0gaW5vZGUt
Pmlfc2l6ZTsNCiANCiAJCXJlcyA9IHBhZ2VjYWNoZV93cml0ZV9iZWdpbihOVUxMLCBtYXBwaW5n
LCBzaXplLCAwLA0KIAkJCQkJCUFPUF9GTEFHX1VOSU5URVJSVVBUSUJMRSwNCmRpZmYgLS1naXQg
YS9mcy9pbm9kZS5jIGIvZnMvaW5vZGUuYw0KaW5kZXggZWU0ZTY2Yi4uZTJkMzYzMyAxMDA2NDQN
Ci0tLSBhL2ZzL2lub2RlLmMNCisrKyBiL2ZzL2lub2RlLmMNCkBAIC02MzQsNyArNjM0LDcgQEAg
dm9pZCBwcnVuZV9pY2FjaGVfc2Ioc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgaW50IG5yX3RvX3Nj
YW4pDQogCQkgKiBpbm9kZSB0byB0aGUgYmFjayBvZiB0aGUgbGlzdCBzbyB3ZSBkb24ndCBzcGlu
IG9uIGl0Lg0KIAkJICovDQogCQlpZiAoIXNwaW5fdHJ5bG9jaygmaW5vZGUtPmlfbG9jaykpIHsN
Ci0JCQlsaXN0X21vdmVfdGFpbCgmaW5vZGUtPmlfbHJ1LCAmc2ItPnNfaW5vZGVfbHJ1KTsNCisJ
CQlsaXN0X21vdmUoJmlub2RlLT5pX2xydSwgJnNiLT5zX2lub2RlX2xydSk7DQogCQkJY29udGlu
dWU7DQogCQl9DQogDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9hdGEuaCBiL2luY2x1ZGUv
bGludXgvYXRhLmgNCmluZGV4IDMyZGYyYjYuLjU4NTZjOWUgMTAwNjQ0DQotLS0gYS9pbmNsdWRl
L2xpbnV4L2F0YS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2F0YS5oDQpAQCAtOTM3LDcgKzkzNyw3
IEBAIHN0YXRpYyBpbmxpbmUgaW50IGF0YXBpX2NkYl9sZW4oY29uc3QgdTE2ICpkZXZfaWQpDQog
CX0NCiB9DQogDQotc3RhdGljIGlubGluZSBib29sIGF0YXBpX2NvbW1hbmRfcGFja2V0X3NldChj
b25zdCB1MTYgKmRldl9pZCkNCitzdGF0aWMgaW5saW5lIGludCBhdGFwaV9jb21tYW5kX3BhY2tl
dF9zZXQoY29uc3QgdTE2ICpkZXZfaWQpDQogew0KIAlyZXR1cm4gKGRldl9pZFtBVEFfSURfQ09O
RklHXSA+PiA4KSAmIDB4MWY7DQogfQ0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3JlZi5o
IGIvaW5jbHVkZS9saW51eC9rcmVmLmgNCmluZGV4IGQ0YTYyYWIuLmQwNjQ1MDIgMTAwNjQ0DQot
LS0gYS9pbmNsdWRlL2xpbnV4L2tyZWYuaA0KKysrIGIvaW5jbHVkZS9saW51eC9rcmVmLmgNCkBA
IC0xNiw2ICsxNiw3IEBADQogI2RlZmluZSBfS1JFRl9IXw0KIA0KICNpbmNsdWRlIDxsaW51eC90
eXBlcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9hdG9taWMuaD4NCiANCiBzdHJ1Y3Qga3JlZiB7DQog
CWF0b21pY190IHJlZmNvdW50Ow0KQEAgLTI3LDQgKzI4LDI0IEBAIGludCBrcmVmX3B1dChzdHJ1
Y3Qga3JlZiAqa3JlZiwgdm9pZCAoKnJlbGVhc2UpIChzdHJ1Y3Qga3JlZiAqa3JlZikpOw0KIGlu
dCBrcmVmX3N1YihzdHJ1Y3Qga3JlZiAqa3JlZiwgdW5zaWduZWQgaW50IGNvdW50LA0KIAkgICAg
IHZvaWQgKCpyZWxlYXNlKSAoc3RydWN0IGtyZWYgKmtyZWYpKTsNCiANCisvKioNCisgKiBrcmVm
X2dldF91bmxlc3NfemVybyAtIEluY3JlbWVudCByZWZjb3VudCBmb3Igb2JqZWN0IHVubGVzcyBp
dCBpcyB6ZXJvLg0KKyAqIEBrcmVmOiBvYmplY3QuDQorICoNCisgKiBSZXR1cm4gbm9uLXplcm8g
aWYgdGhlIGluY3JlbWVudCBzdWNjZWVkZWQuIE90aGVyd2lzZSByZXR1cm4gMC4NCisgKg0KKyAq
IFRoaXMgZnVuY3Rpb24gaXMgaW50ZW5kZWQgdG8gc2ltcGxpZnkgbG9ja2luZyBhcm91bmQgcmVm
Y291bnRpbmcgZm9yDQorICogb2JqZWN0cyB0aGF0IGNhbiBiZSBsb29rZWQgdXAgZnJvbSBhIGxv
b2t1cCBzdHJ1Y3R1cmUsIGFuZCB3aGljaCBhcmUNCisgKiByZW1vdmVkIGZyb20gdGhhdCBsb29r
dXAgc3RydWN0dXJlIGluIHRoZSBvYmplY3QgZGVzdHJ1Y3Rvci4NCisgKiBPcGVyYXRpb25zIG9u
IHN1Y2ggb2JqZWN0cyByZXF1aXJlIGF0IGxlYXN0IGEgcmVhZCBsb2NrIGFyb3VuZA0KKyAqIGxv
b2t1cCArIGtyZWZfZ2V0LCBhbmQgYSB3cml0ZSBsb2NrIGFyb3VuZCBrcmVmX3B1dCArIHJlbW92
ZSBmcm9tIGxvb2t1cA0KKyAqIHN0cnVjdHVyZS4gRnVydGhlcm1vcmUsIFJDVSBpbXBsZW1lbnRh
dGlvbnMgYmVjb21lIGV4dHJlbWVseSB0cmlja3kuDQorICogV2l0aCBhIGxvb2t1cCBmb2xsb3dl
ZCBieSBhIGtyZWZfZ2V0X3VubGVzc196ZXJvICp3aXRoIHJldHVybiB2YWx1ZSBjaGVjayoNCisg
KiBsb2NraW5nIGluIHRoZSBrcmVmX3B1dCBwYXRoIGNhbiBiZSBkZWZlcnJlZCB0byB0aGUgYWN0
dWFsIHJlbW92YWwgZnJvbQ0KKyAqIHRoZSBsb29rdXAgc3RydWN0dXJlIGFuZCBSQ1UgbG9va3Vw
cyBiZWNvbWUgdHJpdmlhbC4NCisgKi8NCitzdGF0aWMgaW5saW5lIGludCBfX211c3RfY2hlY2sg
a3JlZl9nZXRfdW5sZXNzX3plcm8oc3RydWN0IGtyZWYgKmtyZWYpDQorew0KKwlyZXR1cm4gYXRv
bWljX2FkZF91bmxlc3MoJmtyZWYtPnJlZmNvdW50LCAxLCAwKTsNCit9DQogI2VuZGlmIC8qIF9L
UkVGX0hfICovDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIGIvaW5jbHVk
ZS9saW51eC9rdm1faG9zdC5oDQppbmRleCA2MTM2ODIxLi5lNjc5NmMxIDEwMDY0NA0KLS0tIGEv
aW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgN
CkBAIC0zOTYsNyArMzk2LDcgQEAgaW50IGt2bV93cml0ZV9ndWVzdChzdHJ1Y3Qga3ZtICprdm0s
IGdwYV90IGdwYSwgY29uc3Qgdm9pZCAqZGF0YSwNCiBpbnQga3ZtX3dyaXRlX2d1ZXN0X2NhY2hl
ZChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBnZm5fdG9faHZhX2NhY2hlICpnaGMsDQogCQkJICAg
dm9pZCAqZGF0YSwgdW5zaWduZWQgbG9uZyBsZW4pOw0KIGludCBrdm1fZ2ZuX3RvX2h2YV9jYWNo
ZV9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGdmbl90b19odmFfY2FjaGUgKmdoYywNCi0J
CQkgICAgICBncGFfdCBncGEpOw0KKwkJCSAgICAgIGdwYV90IGdwYSwgdW5zaWduZWQgbG9uZyBs
ZW4pOw0KIGludCBrdm1fY2xlYXJfZ3Vlc3RfcGFnZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdm
biwgaW50IG9mZnNldCwgaW50IGxlbik7DQogaW50IGt2bV9jbGVhcl9ndWVzdChzdHJ1Y3Qga3Zt
ICprdm0sIGdwYV90IGdwYSwgdW5zaWduZWQgbG9uZyBsZW4pOw0KIHN0cnVjdCBrdm1fbWVtb3J5
X3Nsb3QgKmdmbl90b19tZW1zbG90KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuKTsNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV90eXBlcy5oIGIvaW5jbHVkZS9saW51eC9rdm1fdHlw
ZXMuaA0KaW5kZXggZmE3Y2M3Mi4uYjBiY2NlMCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgv
a3ZtX3R5cGVzLmgNCisrKyBiL2luY2x1ZGUvbGludXgva3ZtX3R5cGVzLmgNCkBAIC03MSw2ICs3
MSw3IEBAIHN0cnVjdCBnZm5fdG9faHZhX2NhY2hlIHsNCiAJdTY0IGdlbmVyYXRpb247DQogCWdw
YV90IGdwYTsNCiAJdW5zaWduZWQgbG9uZyBodmE7DQorCXVuc2lnbmVkIGxvbmcgbGVuOw0KIAlz
dHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICptZW1zbG90Ow0KIH07DQogDQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9saWJhdGEuaCBiL2luY2x1ZGUvbGludXgvbGliYXRhLmgNCmluZGV4IGNhZmMw
OWEuLjYyNDY3Y2EgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2xpYmF0YS5oDQorKysgYi9p
bmNsdWRlL2xpbnV4L2xpYmF0YS5oDQpAQCAtMzkyLDYgKzM5Miw3IEBAIGVudW0gew0KIAlBVEFf
SE9SS0FHRV9OT1NFVFhGRVIJPSAoMSA8PCAxNCksCS8qIHNraXAgU0VUWEZFUiwgU0FUQSBvbmx5
ICovDQogCUFUQV9IT1JLQUdFX0JST0tFTl9GUERNQV9BQQk9ICgxIDw8IDE1KSwJLyogc2tpcCBB
QSAqLw0KIAlBVEFfSE9SS0FHRV9EVU1QX0lECT0gKDEgPDwgMTYpLAkvKiBkdW1wIElERU5USUZZ
IGRhdGEgKi8NCisJQVRBX0hPUktBR0VfTUFYX1NFQ19MQkE0OCA9ICgxIDw8IDE3KSwJLyogU2V0
IG1heCBzZWN0cyB0byA2NTUzNSAqLw0KIA0KIAkgLyogRE1BIG1hc2sgZm9yIHVzZXIgRE1BIGNv
bnRyb2w6IFVzZXIgdmlzaWJsZSB2YWx1ZXM7IERPIE5PVA0KIAkgICAgcmVudW1iZXIgKi8NCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L29mLmggYi9pbmNsdWRlL2xpbnV4L29mLmgNCmluZGV4
IDQ5NDg1NTIuLjliZjk2MTEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L29mLmgNCisrKyBi
L2luY2x1ZGUvbGludXgvb2YuaA0KQEAgLTMzNiw2ICszMzYsMjIgQEAgc3RhdGljIGlubGluZSBp
bnQgb2ZfbWFjaGluZV9pc19jb21wYXRpYmxlKGNvbnN0IGNoYXIgKmNvbXBhdCkNCiAjZGVmaW5l
IG9mX21hdGNoX25vZGUoX21hdGNoZXMsIF9ub2RlKQlOVUxMDQogI2VuZGlmIC8qIENPTkZJR19P
RiAqLw0KIA0KKy8qKg0KKyAqIG9mX3Byb3BlcnR5X3JlYWRfYm9vbCAtIEZpbmRmcm9tIGEgcHJv
cGVydHkNCisgKiBAbnA6CQlkZXZpY2Ugbm9kZSBmcm9tIHdoaWNoIHRoZSBwcm9wZXJ0eSB2YWx1
ZSBpcyB0byBiZSByZWFkLg0KKyAqIEBwcm9wbmFtZToJbmFtZSBvZiB0aGUgcHJvcGVydHkgdG8g
YmUgc2VhcmNoZWQuDQorICoNCisgKiBTZWFyY2ggZm9yIGEgcHJvcGVydHkgaW4gYSBkZXZpY2Ug
bm9kZS4NCisgKiBSZXR1cm5zIHRydWUgaWYgdGhlIHByb3BlcnR5IGV4aXN0IGZhbHNlIG90aGVy
d2lzZS4NCisgKi8NCitzdGF0aWMgaW5saW5lIGJvb2wgb2ZfcHJvcGVydHlfcmVhZF9ib29sKGNv
bnN0IHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAsDQorCQkJCQkgY29uc3QgY2hhciAqcHJvcG5hbWUp
DQorew0KKwlzdHJ1Y3QgcHJvcGVydHkgKnByb3AgPSBvZl9maW5kX3Byb3BlcnR5KG5wLCBwcm9w
bmFtZSwgTlVMTCk7DQorDQorCXJldHVybiBwcm9wID8gdHJ1ZSA6IGZhbHNlOw0KK30NCisNCiBz
dGF0aWMgaW5saW5lIGludCBvZl9wcm9wZXJ0eV9yZWFkX3UzMihjb25zdCBzdHJ1Y3QgZGV2aWNl
X25vZGUgKm5wLA0KIAkJCQkgICAgICAgY29uc3QgY2hhciAqcHJvcG5hbWUsDQogCQkJCSAgICAg
ICB1MzIgKm91dF92YWx1ZSkNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ByZWVtcHQuaCBi
L2luY2x1ZGUvbGludXgvcHJlZW1wdC5oDQppbmRleCA1ODk2OWIyLi5lODZiZjAxIDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS9saW51eC9wcmVlbXB0LmgNCisrKyBiL2luY2x1ZGUvbGludXgvcHJlZW1w
dC5oDQpAQCAtOTEsMTMgKzkxLDE5IEBAIGRvIHsgXA0KIA0KICNlbHNlIC8qICFDT05GSUdfUFJF
RU1QVF9DT1VOVCAqLw0KIA0KLSNkZWZpbmUgcHJlZW1wdF9kaXNhYmxlKCkJCWRvIHsgfSB3aGls
ZSAoMCkNCi0jZGVmaW5lIHByZWVtcHRfZW5hYmxlX25vX3Jlc2NoZWQoKQlkbyB7IH0gd2hpbGUg
KDApDQotI2RlZmluZSBwcmVlbXB0X2VuYWJsZSgpCQlkbyB7IH0gd2hpbGUgKDApDQorLyoNCisg
KiBFdmVuIGlmIHdlIGRvbid0IGhhdmUgYW55IHByZWVtcHRpb24sIHdlIG5lZWQgcHJlZW1wdCBk
aXNhYmxlL2VuYWJsZQ0KKyAqIHRvIGJlIGJhcnJpZXJzLCBzbyB0aGF0IHdlIGRvbid0IGhhdmUg
dGhpbmdzIGxpa2UgZ2V0X3VzZXIvcHV0X3VzZXINCisgKiB0aGF0IGNhbiBjYXVzZSBmYXVsdHMg
YW5kIHNjaGVkdWxpbmcgbWlncmF0ZSBpbnRvIG91ciBwcmVlbXB0LXByb3RlY3RlZA0KKyAqIHJl
Z2lvbi4NCisgKi8NCisjZGVmaW5lIHByZWVtcHRfZGlzYWJsZSgpCQliYXJyaWVyKCkNCisjZGVm
aW5lIHByZWVtcHRfZW5hYmxlX25vX3Jlc2NoZWQoKQliYXJyaWVyKCkNCisjZGVmaW5lIHByZWVt
cHRfZW5hYmxlKCkJCWJhcnJpZXIoKQ0KIA0KLSNkZWZpbmUgcHJlZW1wdF9kaXNhYmxlX25vdHJh
Y2UoKQkJZG8geyB9IHdoaWxlICgwKQ0KLSNkZWZpbmUgcHJlZW1wdF9lbmFibGVfbm9fcmVzY2hl
ZF9ub3RyYWNlKCkJZG8geyB9IHdoaWxlICgwKQ0KLSNkZWZpbmUgcHJlZW1wdF9lbmFibGVfbm90
cmFjZSgpCQlkbyB7IH0gd2hpbGUgKDApDQorI2RlZmluZSBwcmVlbXB0X2Rpc2FibGVfbm90cmFj
ZSgpCQliYXJyaWVyKCkNCisjZGVmaW5lIHByZWVtcHRfZW5hYmxlX25vX3Jlc2NoZWRfbm90cmFj
ZSgpCWJhcnJpZXIoKQ0KKyNkZWZpbmUgcHJlZW1wdF9lbmFibGVfbm90cmFjZSgpCQliYXJyaWVy
KCkNCiANCiAjZW5kaWYgLyogQ09ORklHX1BSRUVNUFRfQ09VTlQgKi8NCiANCmRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L3NvY2tldC5oIGIvaW5jbHVkZS9saW51eC9zb2NrZXQuaA0KaW5kZXgg
YWQ5MTllMC4uMmFjZDJlMiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvc29ja2V0LmgNCisr
KyBiL2luY2x1ZGUvbGludXgvc29ja2V0LmgNCkBAIC0zMTcsNiArMzE3LDcgQEAgc3RydWN0IHVj
cmVkIHsNCiAjZGVmaW5lIElQWF9UWVBFCTENCiANCiBleHRlcm4gdm9pZCBjcmVkX3RvX3VjcmVk
KHN0cnVjdCBwaWQgKnBpZCwgY29uc3Qgc3RydWN0IGNyZWQgKmNyZWQsIHN0cnVjdCB1Y3JlZCAq
dWNyZWQpOw0KK2V4dGVybiB2b2lkIGNyZWRfcmVhbF90b191Y3JlZChzdHJ1Y3QgcGlkICpwaWQs
IGNvbnN0IHN0cnVjdCBjcmVkICpjcmVkLCBzdHJ1Y3QgdWNyZWQgKnVjcmVkKTsNCiANCiBleHRl
cm4gaW50IG1lbWNweV9mcm9taW92ZWModW5zaWduZWQgY2hhciAqa2RhdGEsIHN0cnVjdCBpb3Zl
YyAqaW92LCBpbnQgbGVuKTsNCiBleHRlcm4gaW50IG1lbWNweV9mcm9taW92ZWNlbmQodW5zaWdu
ZWQgY2hhciAqa2RhdGEsIGNvbnN0IHN0cnVjdCBpb3ZlYyAqaW92LA0KZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvc3BpbmxvY2tfdXAuaCBiL2luY2x1ZGUvbGludXgvc3BpbmxvY2tfdXAuaA0K
aW5kZXggYTI2ZTJmYi4uZTIzNjljMSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvc3Bpbmxv
Y2tfdXAuaA0KKysrIGIvaW5jbHVkZS9saW51eC9zcGlubG9ja191cC5oDQpAQCAtMTYsNyArMTYs
MTAgQEANCiAgKiBJbiB0aGUgZGVidWcgY2FzZSwgMSBtZWFucyB1bmxvY2tlZCwgMCBtZWFucyBs
b2NrZWQuICh0aGUgdmFsdWVzDQogICogYXJlIGludmVydGVkLCB0byBjYXRjaCBpbml0aWFsaXph
dGlvbiBidWdzKQ0KICAqDQotICogTm8gYXRvbWljaXR5IGFueXdoZXJlLCB3ZSBhcmUgb24gVVAu
DQorICogTm8gYXRvbWljaXR5IGFueXdoZXJlLCB3ZSBhcmUgb24gVVAuIEhvd2V2ZXIsIHdlIHN0
aWxsIG5lZWQNCisgKiB0aGUgY29tcGlsZXIgYmFycmllcnMsIGJlY2F1c2Ugd2UgZG8gbm90IHdh
bnQgdGhlIGNvbXBpbGVyIHRvDQorICogbW92ZSBwb3RlbnRpYWxseSBmYXVsdGluZyBpbnN0cnVj
dGlvbnMgKG5vdGFibHkgdXNlciBhY2Nlc3NlcykNCisgKiBpbnRvIHRoZSBsb2NrZWQgc2VxdWVu
Y2UsIHJlc3VsdGluZyBpbiBub24tYXRvbWljIGV4ZWN1dGlvbi4NCiAgKi8NCiANCiAjaWZkZWYg
Q09ORklHX0RFQlVHX1NQSU5MT0NLDQpAQCAtMjUsNiArMjgsNyBAQA0KIHN0YXRpYyBpbmxpbmUg
dm9pZCBhcmNoX3NwaW5fbG9jayhhcmNoX3NwaW5sb2NrX3QgKmxvY2spDQogew0KIAlsb2NrLT5z
bG9jayA9IDA7DQorCWJhcnJpZXIoKTsNCiB9DQogDQogc3RhdGljIGlubGluZSB2b2lkDQpAQCAt
MzIsNiArMzYsNyBAQCBhcmNoX3NwaW5fbG9ja19mbGFncyhhcmNoX3NwaW5sb2NrX3QgKmxvY2ss
IHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQogew0KIAlsb2NhbF9pcnFfc2F2ZShmbGFncyk7DQogCWxv
Y2stPnNsb2NrID0gMDsNCisJYmFycmllcigpOw0KIH0NCiANCiBzdGF0aWMgaW5saW5lIGludCBh
cmNoX3NwaW5fdHJ5bG9jayhhcmNoX3NwaW5sb2NrX3QgKmxvY2spDQpAQCAtMzksMzIgKzQ0LDM0
IEBAIHN0YXRpYyBpbmxpbmUgaW50IGFyY2hfc3Bpbl90cnlsb2NrKGFyY2hfc3BpbmxvY2tfdCAq
bG9jaykNCiAJY2hhciBvbGR2YWwgPSBsb2NrLT5zbG9jazsNCiANCiAJbG9jay0+c2xvY2sgPSAw
Ow0KKwliYXJyaWVyKCk7DQogDQogCXJldHVybiBvbGR2YWwgPiAwOw0KIH0NCiANCiBzdGF0aWMg
aW5saW5lIHZvaWQgYXJjaF9zcGluX3VubG9jayhhcmNoX3NwaW5sb2NrX3QgKmxvY2spDQogew0K
KwliYXJyaWVyKCk7DQogCWxvY2stPnNsb2NrID0gMTsNCiB9DQogDQogLyoNCiAgKiBSZWFkLXdy
aXRlIHNwaW5sb2Nrcy4gTm8gZGVidWcgdmVyc2lvbi4NCiAgKi8NCi0jZGVmaW5lIGFyY2hfcmVh
ZF9sb2NrKGxvY2spCQlkbyB7ICh2b2lkKShsb2NrKTsgfSB3aGlsZSAoMCkNCi0jZGVmaW5lIGFy
Y2hfd3JpdGVfbG9jayhsb2NrKQkJZG8geyAodm9pZCkobG9jayk7IH0gd2hpbGUgKDApDQotI2Rl
ZmluZSBhcmNoX3JlYWRfdHJ5bG9jayhsb2NrKQkoeyAodm9pZCkobG9jayk7IDE7IH0pDQotI2Rl
ZmluZSBhcmNoX3dyaXRlX3RyeWxvY2sobG9jaykJKHsgKHZvaWQpKGxvY2spOyAxOyB9KQ0KLSNk
ZWZpbmUgYXJjaF9yZWFkX3VubG9jayhsb2NrKQkJZG8geyAodm9pZCkobG9jayk7IH0gd2hpbGUg
KDApDQotI2RlZmluZSBhcmNoX3dyaXRlX3VubG9jayhsb2NrKQlkbyB7ICh2b2lkKShsb2NrKTsg
fSB3aGlsZSAoMCkNCisjZGVmaW5lIGFyY2hfcmVhZF9sb2NrKGxvY2spCQlkbyB7IGJhcnJpZXIo
KTsgKHZvaWQpKGxvY2spOyB9IHdoaWxlICgwKQ0KKyNkZWZpbmUgYXJjaF93cml0ZV9sb2NrKGxv
Y2spCQlkbyB7IGJhcnJpZXIoKTsgKHZvaWQpKGxvY2spOyB9IHdoaWxlICgwKQ0KKyNkZWZpbmUg
YXJjaF9yZWFkX3RyeWxvY2sobG9jaykJKHsgYmFycmllcigpOyAodm9pZCkobG9jayk7IDE7IH0p
DQorI2RlZmluZSBhcmNoX3dyaXRlX3RyeWxvY2sobG9jaykJKHsgYmFycmllcigpOyAodm9pZCko
bG9jayk7IDE7IH0pDQorI2RlZmluZSBhcmNoX3JlYWRfdW5sb2NrKGxvY2spCQlkbyB7IGJhcnJp
ZXIoKTsgKHZvaWQpKGxvY2spOyB9IHdoaWxlICgwKQ0KKyNkZWZpbmUgYXJjaF93cml0ZV91bmxv
Y2sobG9jaykJZG8geyBiYXJyaWVyKCk7ICh2b2lkKShsb2NrKTsgfSB3aGlsZSAoMCkNCiANCiAj
ZWxzZSAvKiBERUJVR19TUElOTE9DSyAqLw0KICNkZWZpbmUgYXJjaF9zcGluX2lzX2xvY2tlZChs
b2NrKQkoKHZvaWQpKGxvY2spLCAwKQ0KIC8qIGZvciBzY2hlZC5jIGFuZCBrZXJuZWxfbG9jay5j
OiAqLw0KLSMgZGVmaW5lIGFyY2hfc3Bpbl9sb2NrKGxvY2spCQlkbyB7ICh2b2lkKShsb2NrKTsg
fSB3aGlsZSAoMCkNCi0jIGRlZmluZSBhcmNoX3NwaW5fbG9ja19mbGFncyhsb2NrLCBmbGFncykJ
ZG8geyAodm9pZCkobG9jayk7IH0gd2hpbGUgKDApDQotIyBkZWZpbmUgYXJjaF9zcGluX3VubG9j
ayhsb2NrKQlkbyB7ICh2b2lkKShsb2NrKTsgfSB3aGlsZSAoMCkNCi0jIGRlZmluZSBhcmNoX3Nw
aW5fdHJ5bG9jayhsb2NrKQkoeyAodm9pZCkobG9jayk7IDE7IH0pDQorIyBkZWZpbmUgYXJjaF9z
cGluX2xvY2sobG9jaykJCWRvIHsgYmFycmllcigpOyAodm9pZCkobG9jayk7IH0gd2hpbGUgKDAp
DQorIyBkZWZpbmUgYXJjaF9zcGluX2xvY2tfZmxhZ3MobG9jaywgZmxhZ3MpCWRvIHsgYmFycmll
cigpOyAodm9pZCkobG9jayk7IH0gd2hpbGUgKDApDQorIyBkZWZpbmUgYXJjaF9zcGluX3VubG9j
ayhsb2NrKQlkbyB7IGJhcnJpZXIoKTsgKHZvaWQpKGxvY2spOyB9IHdoaWxlICgwKQ0KKyMgZGVm
aW5lIGFyY2hfc3Bpbl90cnlsb2NrKGxvY2spCSh7IGJhcnJpZXIoKTsgKHZvaWQpKGxvY2spOyAx
OyB9KQ0KICNlbmRpZiAvKiBERUJVR19TUElOTE9DSyAqLw0KIA0KICNkZWZpbmUgYXJjaF9zcGlu
X2lzX2NvbnRlbmRlZChsb2NrKQkoKCh2b2lkKShsb2NrKSwgMCkpDQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC91c2Ivc2VyaWFsLmggYi9pbmNsdWRlL2xpbnV4L3VzYi9zZXJpYWwuaA0KaW5k
ZXggYjI5ZjcwYi4uMjM3ZDVmOCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvdXNiL3Nlcmlh
bC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3VzYi9zZXJpYWwuaA0KQEAgLTcxLDYgKzcxLDcgQEAg
ZW51bSBwb3J0X2Rldl9zdGF0ZSB7DQogICoJcG9ydC4NCiAgKiBAZmxhZ3M6IHVzYiBzZXJpYWwg
cG9ydCBmbGFncw0KICAqIEB3cml0ZV93YWl0OiBhIHdhaXRfcXVldWVfaGVhZF90IHVzZWQgYnkg
dGhlIHBvcnQuDQorICogQGRlbHRhX21zcl93YWl0OiBtb2RlbS1zdGF0dXMtY2hhbmdlIHdhaXQg
cXVldWUNCiAgKiBAd29yazogd29yayBxdWV1ZSBlbnRyeSBmb3IgdGhlIGxpbmUgZGlzY2lwbGlu
ZSB3YWtpbmcgdXAuDQogICogQHRocm90dGxlZDogbm9uemVybyBpZiB0aGUgcmVhZCB1cmIgaXMg
aW5hY3RpdmUgdG8gdGhyb3R0bGUgdGhlIGRldmljZQ0KICAqIEB0aHJvdHRsZV9yZXE6IG5vbnpl
cm8gaWYgdGhlIHR0eSB3YW50cyB0byB0aHJvdHRsZSB1cw0KQEAgLTExNCw2ICsxMTUsNyBAQCBz
dHJ1Y3QgdXNiX3NlcmlhbF9wb3J0IHsNCiANCiAJdW5zaWduZWQgbG9uZwkJZmxhZ3M7DQogCXdh
aXRfcXVldWVfaGVhZF90CXdyaXRlX3dhaXQ7DQorCXdhaXRfcXVldWVfaGVhZF90CWRlbHRhX21z
cl93YWl0Ow0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJd29yazsNCiAJY2hhcgkJCXRocm90dGxlZDsN
CiAJY2hhcgkJCXRocm90dGxlX3JlcTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3dyaXRl
YmFjay5oIGIvaW5jbHVkZS9saW51eC93cml0ZWJhY2suaA0KaW5kZXggYTM3OGMyOS4uN2U4NWQ0
NSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvd3JpdGViYWNrLmgNCisrKyBiL2luY2x1ZGUv
bGludXgvd3JpdGViYWNrLmgNCkBAIC0xOTUsNiArMTk1LDggQEAgdm9pZCB3cml0ZWJhY2tfc2V0
X3JhdGVsaW1pdCh2b2lkKTsNCiB2b2lkIHRhZ19wYWdlc19mb3Jfd3JpdGViYWNrKHN0cnVjdCBh
ZGRyZXNzX3NwYWNlICptYXBwaW5nLA0KIAkJCSAgICAgcGdvZmZfdCBzdGFydCwgcGdvZmZfdCBl
bmQpOw0KIA0KK3ZvaWQgYWNjb3VudF9wYWdlX3JlZGlydHkoc3RydWN0IHBhZ2UgKnBhZ2UpOw0K
Kw0KIC8qIHBkZmx1c2guYyAqLw0KIGV4dGVybiBpbnQgbnJfcGRmbHVzaF90aHJlYWRzOwkvKiBH
bG9iYWwgc28gaXQgY2FuIGJlIGV4cG9ydGVkIHRvIHN5c2N0bA0KIAkJCQkgICByZWFkLW9ubHku
ICovDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvc2NtLmggYi9pbmNsdWRlL25ldC9zY20uaA0K
aW5kZXggMGMwMDE3Yy4uNWRhMGE3YiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L3NjbS5oDQor
KysgYi9pbmNsdWRlL25ldC9zY20uaA0KQEAgLTUwLDcgKzUwLDcgQEAgc3RhdGljIF9faW5saW5l
X18gdm9pZCBzY21fc2V0X2NyZWQoc3RydWN0IHNjbV9jb29raWUgKnNjbSwNCiB7DQogCXNjbS0+
cGlkICA9IGdldF9waWQocGlkKTsNCiAJc2NtLT5jcmVkID0gY3JlZCA/IGdldF9jcmVkKGNyZWQp
IDogTlVMTDsNCi0JY3JlZF90b191Y3JlZChwaWQsIGNyZWQsICZzY20tPmNyZWRzKTsNCisJY3Jl
ZF9yZWFsX3RvX3VjcmVkKHBpZCwgY3JlZCwgJnNjbS0+Y3JlZHMpOw0KIH0NCiANCiBzdGF0aWMg
X19pbmxpbmVfXyB2b2lkIHNjbV9kZXN0cm95X2NyZWQoc3RydWN0IHNjbV9jb29raWUgKnNjbSkN
CmRpZmYgLS1naXQgYS9rZXJuZWwvaHJ0aW1lci5jIGIva2VybmVsL2hydGltZXIuYw0KaW5kZXgg
Y2RkNTYwNy4uZTRjZWU4ZCAxMDA2NDQNCi0tLSBhL2tlcm5lbC9ocnRpbWVyLmMNCisrKyBiL2tl
cm5lbC9ocnRpbWVyLmMNCkBAIC02MSw2ICs2MSw3IEBADQogREVGSU5FX1BFUl9DUFUoc3RydWN0
IGhydGltZXJfY3B1X2Jhc2UsIGhydGltZXJfYmFzZXMpID0NCiB7DQogDQorCS5sb2NrID0gX19S
QVdfU1BJTl9MT0NLX1VOTE9DS0VEKGhydGltZXJfYmFzZXMubG9jayksDQogCS5jbG9ja19iYXNl
ID0NCiAJew0KIAkJew0KQEAgLTE2NDAsOCArMTY0MSw2IEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5p
dCBpbml0X2hydGltZXJzX2NwdShpbnQgY3B1KQ0KIAlzdHJ1Y3QgaHJ0aW1lcl9jcHVfYmFzZSAq
Y3B1X2Jhc2UgPSAmcGVyX2NwdShocnRpbWVyX2Jhc2VzLCBjcHUpOw0KIAlpbnQgaTsNCiANCi0J
cmF3X3NwaW5fbG9ja19pbml0KCZjcHVfYmFzZS0+bG9jayk7DQotDQogCWZvciAoaSA9IDA7IGkg
PCBIUlRJTUVSX01BWF9DTE9DS19CQVNFUzsgaSsrKSB7DQogCQljcHVfYmFzZS0+Y2xvY2tfYmFz
ZVtpXS5jcHVfYmFzZSA9IGNwdV9iYXNlOw0KIAkJdGltZXJxdWV1ZV9pbml0X2hlYWQoJmNwdV9i
YXNlLT5jbG9ja19iYXNlW2ldLmFjdGl2ZSk7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkLmMg
Yi9rZXJuZWwvc2NoZWQuYw0KaW5kZXggZWVlZWM0ZS4uZDA4YzlmNCAxMDA2NDQNCi0tLSBhL2tl
cm5lbC9zY2hlZC5jDQorKysgYi9rZXJuZWwvc2NoZWQuYw0KQEAgLTI4ODksOCArMjg4OSwxMCBA
QCBzdGF0aWMgdm9pZCB0cnlfdG9fd2FrZV91cF9sb2NhbChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAp
DQogew0KIAlzdHJ1Y3QgcnEgKnJxID0gdGFza19ycShwKTsNCiANCi0JQlVHX09OKHJxICE9IHRo
aXNfcnEoKSk7DQotCUJVR19PTihwID09IGN1cnJlbnQpOw0KKwlpZiAoV0FSTl9PTl9PTkNFKHJx
ICE9IHRoaXNfcnEoKSkgfHwNCisJICAgIFdBUk5fT05fT05DRShwID09IGN1cnJlbnQpKQ0KKwkJ
cmV0dXJuOw0KKw0KIAlsb2NrZGVwX2Fzc2VydF9oZWxkKCZycS0+bG9jayk7DQogDQogCWlmICgh
cmF3X3NwaW5fdHJ5bG9jaygmcC0+cGlfbG9jaykpIHsNCmRpZmYgLS1naXQgYS9rZXJuZWwvc2No
ZWRfY2xvY2suYyBiL2tlcm5lbC9zY2hlZF9jbG9jay5jDQppbmRleCBjNjg1ZTMxLi5jM2FlMTQ0
IDEwMDY0NA0KLS0tIGEva2VybmVsL3NjaGVkX2Nsb2NrLmMNCisrKyBiL2tlcm5lbC9zY2hlZF9j
bG9jay5jDQpAQCAtMTc2LDEwICsxNzYsMzYgQEAgc3RhdGljIHU2NCBzY2hlZF9jbG9ja19yZW1v
dGUoc3RydWN0IHNjaGVkX2Nsb2NrX2RhdGEgKnNjZCkNCiAJdTY0IHRoaXNfY2xvY2ssIHJlbW90
ZV9jbG9jazsNCiAJdTY0ICpwdHIsIG9sZF92YWwsIHZhbDsNCiANCisjaWYgQklUU19QRVJfTE9O
RyAhPSA2NA0KK2FnYWluOg0KKwkvKg0KKwkgKiBDYXJlZnVsIGhlcmU6IFRoZSBsb2NhbCBhbmQg
dGhlIHJlbW90ZSBjbG9jayB2YWx1ZXMgbmVlZCB0bw0KKwkgKiBiZSByZWFkIG91dCBhdG9taWMg
YXMgd2UgbmVlZCB0byBjb21wYXJlIHRoZSB2YWx1ZXMgYW5kDQorCSAqIHRoZW4gdXBkYXRlIGVp
dGhlciB0aGUgbG9jYWwgb3IgdGhlIHJlbW90ZSBzaWRlLiBTbyB0aGUNCisJICogY21weGNoZzY0
IGJlbG93IG9ubHkgcHJvdGVjdHMgb25lIHJlYWRvdXQuDQorCSAqDQorCSAqIFdlIG11c3QgcmVy
ZWFkIHZpYSBzY2hlZF9jbG9ja19sb2NhbCgpIGluIHRoZSByZXRyeSBjYXNlIG9uDQorCSAqIDMy
Yml0IGFzIGFuIE5NSSBjb3VsZCB1c2Ugc2NoZWRfY2xvY2tfbG9jYWwoKSB2aWEgdGhlDQorCSAq
IHRyYWNlciBhbmQgaGl0IGJldHdlZW4gdGhlIHJlYWRvdXQgb2YNCisJICogdGhlIGxvdzMyYml0
IGFuZCB0aGUgaGlnaCAzMmJpdCBwb3J0aW9uLg0KKwkgKi8NCisJdGhpc19jbG9jayA9IHNjaGVk
X2Nsb2NrX2xvY2FsKG15X3NjZCk7DQorCS8qDQorCSAqIFdlIG11c3QgZW5mb3JjZSBhdG9taWMg
cmVhZG91dCBvbiAzMmJpdCwgb3RoZXJ3aXNlIHRoZQ0KKwkgKiB1cGRhdGUgb24gdGhlIHJlbW90
ZSBjcHUgY2FuIGhpdCBpbmJldHdlZW4gdGhlIHJlYWRvdXQgb2YNCisJICogdGhlIGxvdzMyYml0
IGFuZCB0aGUgaGlnaCAzMmJpdCBwb3J0aW9uLg0KKwkgKi8NCisJcmVtb3RlX2Nsb2NrID0gY21w
eGNoZzY0KCZzY2QtPmNsb2NrLCAwLCAwKTsNCisjZWxzZQ0KKwkvKg0KKwkgKiBPbiA2NGJpdCB0
aGUgcmVhZCBvZiBbbXldc2NkLT5jbG9jayBpcyBhdG9taWMgdmVyc3VzIHRoZQ0KKwkgKiB1cGRh
dGUsIHNvIHdlIGNhbiBhdm9pZCB0aGUgYWJvdmUgMzJiaXQgZGFuY2UuDQorCSAqLw0KIAlzY2hl
ZF9jbG9ja19sb2NhbChteV9zY2QpOw0KIGFnYWluOg0KIAl0aGlzX2Nsb2NrID0gbXlfc2NkLT5j
bG9jazsNCiAJcmVtb3RlX2Nsb2NrID0gc2NkLT5jbG9jazsNCisjZW5kaWYNCiANCiAJLyoNCiAJ
ICogVXNlIHRoZSBvcHBvcnR1bml0eSB0aGF0IHdlIGhhdmUgYm90aCBsb2Nrcw0KZGlmZiAtLWdp
dCBhL2tlcm5lbC9zaWduYWwuYyBiL2tlcm5lbC9zaWduYWwuYw0KaW5kZXggZWE3NmQzMC4uM2Vj
ZjU3NCAxMDA2NDQNCi0tLSBhL2tlcm5lbC9zaWduYWwuYw0KKysrIGIva2VybmVsL3NpZ25hbC5j
DQpAQCAtMjc5MCw3ICsyNzkwLDcgQEAgZG9fc2VuZF9zcGVjaWZpYyhwaWRfdCB0Z2lkLCBwaWRf
dCBwaWQsIGludCBzaWcsIHN0cnVjdCBzaWdpbmZvICppbmZvKQ0KIA0KIHN0YXRpYyBpbnQgZG9f
dGtpbGwocGlkX3QgdGdpZCwgcGlkX3QgcGlkLCBpbnQgc2lnKQ0KIHsNCi0Jc3RydWN0IHNpZ2lu
Zm8gaW5mbzsNCisJc3RydWN0IHNpZ2luZm8gaW5mbyA9IHt9Ow0KIA0KIAlpbmZvLnNpX3NpZ25v
ID0gc2lnOw0KIAlpbmZvLnNpX2Vycm5vID0gMDsNCmRpZmYgLS1naXQgYS9rZXJuZWwvc3lzLmMg
Yi9rZXJuZWwvc3lzLmMNCmluZGV4IGY1OTM5YzIuLmJlNWZhOGIgMTAwNjQ0DQotLS0gYS9rZXJu
ZWwvc3lzLmMNCisrKyBiL2tlcm5lbC9zeXMuYw0KQEAgLTMyMCw3ICszMjAsNiBAQCB2b2lkIGtl
cm5lbF9yZXN0YXJ0X3ByZXBhcmUoY2hhciAqY21kKQ0KIAlzeXN0ZW1fc3RhdGUgPSBTWVNURU1f
UkVTVEFSVDsNCiAJdXNlcm1vZGVoZWxwZXJfZGlzYWJsZSgpOw0KIAlkZXZpY2Vfc2h1dGRvd24o
KTsNCi0Jc3lzY29yZV9zaHV0ZG93bigpOw0KIH0NCiANCiAvKioNCkBAIC0zNjYsNiArMzY1LDcg
QEAgdm9pZCBrZXJuZWxfcmVzdGFydChjaGFyICpjbWQpDQogew0KIAlrZXJuZWxfcmVzdGFydF9w
cmVwYXJlKGNtZCk7DQogCWRpc2FibGVfbm9uYm9vdF9jcHVzKCk7DQorCXN5c2NvcmVfc2h1dGRv
d24oKTsNCiAJaWYgKCFjbWQpDQogCQlwcmludGsoS0VSTl9FTUVSRyAiUmVzdGFydGluZyBzeXN0
ZW0uXG4iKTsNCiAJZWxzZQ0KQEAgLTM5MSw2ICszOTEsNyBAQCBzdGF0aWMgdm9pZCBrZXJuZWxf
c2h1dGRvd25fcHJlcGFyZShlbnVtIHN5c3RlbV9zdGF0ZXMgc3RhdGUpDQogdm9pZCBrZXJuZWxf
aGFsdCh2b2lkKQ0KIHsNCiAJa2VybmVsX3NodXRkb3duX3ByZXBhcmUoU1lTVEVNX0hBTFQpOw0K
KwlkaXNhYmxlX25vbmJvb3RfY3B1cygpOw0KIAlzeXNjb3JlX3NodXRkb3duKCk7DQogCXByaW50
ayhLRVJOX0VNRVJHICJTeXN0ZW0gaGFsdGVkLlxuIik7DQogCWttc2dfZHVtcChLTVNHX0RVTVBf
SEFMVCk7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL2Z0cmFjZS5jIGIva2VybmVsL3RyYWNl
L2Z0cmFjZS5jDQppbmRleCAwOTQzZDJhLi41NTI3MjExIDEwMDY0NA0KLS0tIGEva2VybmVsL3Ry
YWNlL2Z0cmFjZS5jDQorKysgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCkBAIC01NzIsNyArNTcy
LDYgQEAgaW50IGZ0cmFjZV9wcm9maWxlX3BhZ2VzX2luaXQoc3RydWN0IGZ0cmFjZV9wcm9maWxl
X3N0YXQgKnN0YXQpDQogCQlmcmVlX3BhZ2UodG1wKTsNCiAJfQ0KIA0KLQlmcmVlX3BhZ2UoKHVu
c2lnbmVkIGxvbmcpc3RhdC0+cGFnZXMpOw0KIAlzdGF0LT5wYWdlcyA9IE5VTEw7DQogCXN0YXQt
PnN0YXJ0ID0gTlVMTDsNCiANCkBAIC0yMzE3LDcgKzIzMTYsNyBAQCBmdHJhY2Vfbm90cmFjZV9v
cGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQ0KIH0NCiANCiBzdGF0
aWMgbG9mZl90DQotZnRyYWNlX3JlZ2V4X2xzZWVrKHN0cnVjdCBmaWxlICpmaWxlLCBsb2ZmX3Qg
b2Zmc2V0LCBpbnQgb3JpZ2luKQ0KK2Z0cmFjZV9maWx0ZXJfbHNlZWsoc3RydWN0IGZpbGUgKmZp
bGUsIGxvZmZfdCBvZmZzZXQsIGludCBvcmlnaW4pDQogew0KIAlsb2ZmX3QgcmV0Ow0KIA0KQEAg
LTMxMzUsNyArMzEzNCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGZ0
cmFjZV9maWx0ZXJfZm9wcyA9IHsNCiAJLm9wZW4gPSBmdHJhY2VfZmlsdGVyX29wZW4sDQogCS5y
ZWFkID0gc2VxX3JlYWQsDQogCS53cml0ZSA9IGZ0cmFjZV9maWx0ZXJfd3JpdGUsDQotCS5sbHNl
ZWsgPSBmdHJhY2VfcmVnZXhfbHNlZWssDQorCS5sbHNlZWsgPSBmdHJhY2VfZmlsdGVyX2xzZWVr
LA0KIAkucmVsZWFzZSA9IGZ0cmFjZV9yZWdleF9yZWxlYXNlLA0KIH07DQogDQpAQCAtMzE0Myw3
ICszMTQyLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgZnRyYWNlX25v
dHJhY2VfZm9wcyA9IHsNCiAJLm9wZW4gPSBmdHJhY2Vfbm90cmFjZV9vcGVuLA0KIAkucmVhZCA9
IHNlcV9yZWFkLA0KIAkud3JpdGUgPSBmdHJhY2Vfbm90cmFjZV93cml0ZSwNCi0JLmxsc2VlayA9
IGZ0cmFjZV9yZWdleF9sc2VlaywNCisJLmxsc2VlayA9IGZ0cmFjZV9maWx0ZXJfbHNlZWssDQog
CS5yZWxlYXNlID0gZnRyYWNlX3JlZ2V4X3JlbGVhc2UsDQogfTsNCiANCkBAIC0zMzUxLDggKzMz
NTAsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBmdHJhY2VfZ3JhcGhf
Zm9wcyA9IHsNCiAJLm9wZW4JCT0gZnRyYWNlX2dyYXBoX29wZW4sDQogCS5yZWFkCQk9IHNlcV9y
ZWFkLA0KIAkud3JpdGUJCT0gZnRyYWNlX2dyYXBoX3dyaXRlLA0KKwkubGxzZWVrCQk9IGZ0cmFj
ZV9maWx0ZXJfbHNlZWssDQogCS5yZWxlYXNlCT0gZnRyYWNlX2dyYXBoX3JlbGVhc2UsDQotCS5s
bHNlZWsJCT0gc2VxX2xzZWVrLA0KIH07DQogI2VuZGlmIC8qIENPTkZJR19GVU5DVElPTl9HUkFQ
SF9UUkFDRVIgKi8NCiANCkBAIC0zODQ0LDcgKzM4NDMsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGZpbGVfb3BlcmF0aW9ucyBmdHJhY2VfcGlkX2ZvcHMgPSB7DQogCS5vcGVuCQk9IGZ0cmFjZV9w
aWRfb3BlbiwNCiAJLndyaXRlCQk9IGZ0cmFjZV9waWRfd3JpdGUsDQogCS5yZWFkCQk9IHNlcV9y
ZWFkLA0KLQkubGxzZWVrCQk9IHNlcV9sc2VlaywNCisJLmxsc2VlawkJPSBmdHJhY2VfZmlsdGVy
X2xzZWVrLA0KIAkucmVsZWFzZQk9IGZ0cmFjZV9waWRfcmVsZWFzZSwNCiB9Ow0KIA0KQEAgLTM5
NjQsMTIgKzM5NjMsOCBAQCBmdHJhY2VfZW5hYmxlX3N5c2N0bChzdHJ1Y3QgY3RsX3RhYmxlICp0
YWJsZSwgaW50IHdyaXRlLA0KIAkJZnRyYWNlX3N0YXJ0dXBfc3lzY3RsKCk7DQogDQogCQkvKiB3
ZSBhcmUgc3RhcnRpbmcgZnRyYWNlIGFnYWluICovDQotCQlpZiAoZnRyYWNlX29wc19saXN0ICE9
ICZmdHJhY2VfbGlzdF9lbmQpIHsNCi0JCQlpZiAoZnRyYWNlX29wc19saXN0LT5uZXh0ID09ICZm
dHJhY2VfbGlzdF9lbmQpDQotCQkJCWZ0cmFjZV90cmFjZV9mdW5jdGlvbiA9IGZ0cmFjZV9vcHNf
bGlzdC0+ZnVuYzsNCi0JCQllbHNlDQotCQkJCWZ0cmFjZV90cmFjZV9mdW5jdGlvbiA9IGZ0cmFj
ZV9vcHNfbGlzdF9mdW5jOw0KLQkJfQ0KKwkJaWYgKGZ0cmFjZV9vcHNfbGlzdCAhPSAmZnRyYWNl
X2xpc3RfZW5kKQ0KKwkJCXVwZGF0ZV9mdHJhY2VfZnVuY3Rpb24oKTsNCiANCiAJfSBlbHNlIHsN
CiAJCS8qIHN0b3BwaW5nIGZ0cmFjZSBjYWxscyAoanVzdCBzZW5kIHRvIGZ0cmFjZV9zdHViKSAq
Lw0KZGlmZiAtLWdpdCBhL2xpYi9rb2JqZWN0LmMgYi9saWIva29iamVjdC5jDQppbmRleCA2NDBi
ZDk4Li44M2JkNWIzIDEwMDY0NA0KLS0tIGEvbGliL2tvYmplY3QuYw0KKysrIGIvbGliL2tvYmpl
Y3QuYw0KQEAgLTUzMSw2ICs1MzEsMTMgQEAgc3RydWN0IGtvYmplY3QgKmtvYmplY3RfZ2V0KHN0
cnVjdCBrb2JqZWN0ICprb2JqKQ0KIAlyZXR1cm4ga29iajsNCiB9DQogDQorc3RhdGljIHN0cnVj
dCBrb2JqZWN0ICprb2JqZWN0X2dldF91bmxlc3NfemVybyhzdHJ1Y3Qga29iamVjdCAqa29iaikN
Cit7DQorCWlmICgha3JlZl9nZXRfdW5sZXNzX3plcm8oJmtvYmotPmtyZWYpKQ0KKwkJa29iaiA9
IE5VTEw7DQorCXJldHVybiBrb2JqOw0KK30NCisNCiAvKg0KICAqIGtvYmplY3RfY2xlYW51cCAt
IGZyZWUga29iamVjdCByZXNvdXJjZXMuDQogICogQGtvYmo6IG9iamVjdCB0byBjbGVhbnVwDQpA
QCAtNzg1LDcgKzc5Miw3IEBAIHN0cnVjdCBrb2JqZWN0ICprc2V0X2ZpbmRfb2JqX2hpbnRlZChz
dHJ1Y3Qga3NldCAqa3NldCwgY29uc3QgY2hhciAqbmFtZSwNCiBzbG93X3NlYXJjaDoNCiAJbGlz
dF9mb3JfZWFjaF9lbnRyeShrLCAma3NldC0+bGlzdCwgZW50cnkpIHsNCiAJCWlmIChrb2JqZWN0
X25hbWUoaykgJiYgIXN0cmNtcChrb2JqZWN0X25hbWUoayksIG5hbWUpKSB7DQotCQkJcmV0ID0g
a29iamVjdF9nZXQoayk7DQorCQkJcmV0ID0ga29iamVjdF9nZXRfdW5sZXNzX3plcm8oayk7DQog
CQkJYnJlYWs7DQogCQl9DQogCX0NCmRpZmYgLS1naXQgYS9tbS9odWdldGxiLmMgYi9tbS9odWdl
dGxiLmMNCmluZGV4IDRjN2Q0MmEuLjcwYjQ3MzMgMTAwNjQ0DQotLS0gYS9tbS9odWdldGxiLmMN
CisrKyBiL21tL2h1Z2V0bGIuYw0KQEAgLTI4ODksNyArMjg4OSwxNyBAQCBpbnQgZm9sbG93X2h1
Z2V0bGJfcGFnZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2
bWEsDQogCQkJYnJlYWs7DQogCQl9DQogDQotCQlpZiAoYWJzZW50IHx8DQorCQkvKg0KKwkJICog
V2UgbmVlZCBjYWxsIGh1Z2V0bGJfZmF1bHQgZm9yIGJvdGggaHVnZXBhZ2VzIHVuZGVyIG1pZ3Jh
dGlvbg0KKwkJICogKGluIHdoaWNoIGNhc2UgaHVnZXRsYl9mYXVsdCB3YWl0cyBmb3IgdGhlIG1p
Z3JhdGlvbiwpIGFuZA0KKwkJICogaHdwb2lzb25lZCBodWdlcGFnZXMgKGluIHdoaWNoIGNhc2Ug
d2UgbmVlZCB0byBwcmV2ZW50IHRoZQ0KKwkJICogY2FsbGVyIGZyb20gYWNjZXNzaW5nIHRvIHRo
ZW0uKSBJbiBvcmRlciB0byBkbyB0aGlzLCB3ZSB1c2UNCisJCSAqIGhlcmUgaXNfc3dhcF9wdGUg
aW5zdGVhZCBvZiBpc19odWdldGxiX2VudHJ5X21pZ3JhdGlvbiBhbmQNCisJCSAqIGlzX2h1Z2V0
bGJfZW50cnlfaHdwb2lzb25lZC4gVGhpcyBpcyBiZWNhdXNlIGl0IHNpbXBseSBjb3ZlcnMNCisJ
CSAqIGJvdGggY2FzZXMsIGFuZCBiZWNhdXNlIHdlIGNhbid0IGZvbGxvdyBjb3JyZWN0IHBhZ2Vz
DQorCQkgKiBkaXJlY3RseSBmcm9tIGFueSBraW5kIG9mIHN3YXAgZW50cmllcy4NCisJCSAqLw0K
KwkJaWYgKGFic2VudCB8fCBpc19zd2FwX3B0ZShodWdlX3B0ZXBfZ2V0KHB0ZSkpIHx8DQogCQkg
ICAgKChmbGFncyAmIEZPTExfV1JJVEUpICYmICFwdGVfd3JpdGUoaHVnZV9wdGVwX2dldChwdGUp
KSkpIHsNCiAJCQlpbnQgcmV0Ow0KIA0KZGlmZiAtLWdpdCBhL21tL3BhZ2Utd3JpdGViYWNrLmMg
Yi9tbS9wYWdlLXdyaXRlYmFjay5jDQppbmRleCA1MGYwODI0Li5lYTNmODNiIDEwMDY0NA0KLS0t
IGEvbW0vcGFnZS13cml0ZWJhY2suYw0KKysrIGIvbW0vcGFnZS13cml0ZWJhY2suYw0KQEAgLTE4
MDEsNiArMTgwMSwyNCBAQCBpbnQgX19zZXRfcGFnZV9kaXJ0eV9ub2J1ZmZlcnMoc3RydWN0IHBh
Z2UgKnBhZ2UpDQogRVhQT1JUX1NZTUJPTChfX3NldF9wYWdlX2RpcnR5X25vYnVmZmVycyk7DQog
DQogLyoNCisgKiBDYWxsIHRoaXMgd2hlbmV2ZXIgcmVkaXJ0eWluZyBhIHBhZ2UsIHRvIGRlLWFj
Y291bnQgdGhlIGRpcnR5IGNvdW50ZXJzDQorICogKE5SX0RJUlRJRUQsIEJESV9ESVJUSUVELCB0
c2stPm5yX2RpcnRpZWQpLCBzbyB0aGF0IHRoZXkgbWF0Y2ggdGhlIHdyaXR0ZW4NCisgKiBjb3Vu
dGVycyAoTlJfV1JJVFRFTiwgQkRJX1dSSVRURU4pIGluIGxvbmcgdGVybS4gVGhlIG1pc21hdGNo
ZXMgd2lsbCBsZWFkIHRvDQorICogc3lzdGVtYXRpYyBlcnJvcnMgaW4gYmFsYW5jZWRfZGlydHlf
cmF0ZWxpbWl0IGFuZCB0aGUgZGlydHkgcGFnZXMgcG9zaXRpb24NCisgKiBjb250cm9sLg0KKyAq
Lw0KK3ZvaWQgYWNjb3VudF9wYWdlX3JlZGlydHkoc3RydWN0IHBhZ2UgKnBhZ2UpDQorew0KKwlz
dHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZyA9IHBhZ2UtPm1hcHBpbmc7DQorCWlmIChtYXBw
aW5nICYmIG1hcHBpbmdfY2FwX2FjY291bnRfZGlydHkobWFwcGluZykpIHsNCisJCWN1cnJlbnQt
Pm5yX2RpcnRpZWQtLTsNCisJCWRlY196b25lX3BhZ2Vfc3RhdGUocGFnZSwgTlJfRElSVElFRCk7
DQorCQlkZWNfYmRpX3N0YXQobWFwcGluZy0+YmFja2luZ19kZXZfaW5mbywgQkRJX0RJUlRJRUQp
Ow0KKwl9DQorfQ0KK0VYUE9SVF9TWU1CT0woYWNjb3VudF9wYWdlX3JlZGlydHkpOw0KKw0KKy8q
DQogICogV2hlbiBhIHdyaXRlcGFnZSBpbXBsZW1lbnRhdGlvbiBkZWNpZGVzIHRoYXQgaXQgZG9l
c24ndCB3YW50IHRvIHdyaXRlIHRoaXMNCiAgKiBwYWdlIGZvciBzb21lIHJlYXNvbiwgaXQgc2hv
dWxkIHJlZGlydHkgdGhlIGxvY2tlZCBwYWdlIHZpYQ0KICAqIHJlZGlydHlfcGFnZV9mb3Jfd3Jp
dGVwYWdlKCkgYW5kIGl0IHNob3VsZCB0aGVuIHVubG9jayB0aGUgcGFnZSBhbmQgcmV0dXJuIDAN
CkBAIC0xODA4LDYgKzE4MjYsNyBAQCBFWFBPUlRfU1lNQk9MKF9fc2V0X3BhZ2VfZGlydHlfbm9i
dWZmZXJzKTsNCiBpbnQgcmVkaXJ0eV9wYWdlX2Zvcl93cml0ZXBhZ2Uoc3RydWN0IHdyaXRlYmFj
a19jb250cm9sICp3YmMsIHN0cnVjdCBwYWdlICpwYWdlKQ0KIHsNCiAJd2JjLT5wYWdlc19za2lw
cGVkKys7DQorCWFjY291bnRfcGFnZV9yZWRpcnR5KHBhZ2UpOw0KIAlyZXR1cm4gX19zZXRfcGFn
ZV9kaXJ0eV9ub2J1ZmZlcnMocGFnZSk7DQogfQ0KIEVYUE9SVF9TWU1CT0wocmVkaXJ0eV9wYWdl
X2Zvcl93cml0ZXBhZ2UpOw0KZGlmZiAtLWdpdCBhL25ldC9jYW4vZ3cuYyBiL25ldC9jYW4vZ3cu
Yw0KaW5kZXggM2Q3OWIxMi4uZjc4Zjg5OCAxMDA2NDQNCi0tLSBhL25ldC9jYW4vZ3cuYw0KKysr
IGIvbmV0L2Nhbi9ndy5jDQpAQCAtNDM2LDcgKzQzNiw3IEBAIHN0YXRpYyBpbnQgY2d3X25vdGlm
aWVyKHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsDQogCQkJaWYgKGd3ai0+c3JjLmRldiA9PSBk
ZXYgfHwgZ3dqLT5kc3QuZGV2ID09IGRldikgew0KIAkJCQlobGlzdF9kZWwoJmd3ai0+bGlzdCk7
DQogCQkJCWNnd191bnJlZ2lzdGVyX2ZpbHRlcihnd2opOw0KLQkJCQlrZnJlZShnd2opOw0KKwkJ
CQlrbWVtX2NhY2hlX2ZyZWUoY2d3X2NhY2hlLCBnd2opOw0KIAkJCX0NCiAJCX0NCiAJfQ0KQEAg
LTg1MCw3ICs4NTAsNyBAQCBzdGF0aWMgdm9pZCBjZ3dfcmVtb3ZlX2FsbF9qb2JzKHZvaWQpDQog
CWhsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoZ3dqLCBuLCBueCwgJmNnd19saXN0LCBsaXN0KSB7
DQogCQlobGlzdF9kZWwoJmd3ai0+bGlzdCk7DQogCQljZ3dfdW5yZWdpc3Rlcl9maWx0ZXIoZ3dq
KTsNCi0JCWtmcmVlKGd3aik7DQorCQlrbWVtX2NhY2hlX2ZyZWUoY2d3X2NhY2hlLCBnd2opOw0K
IAl9DQogfQ0KIA0KQEAgLTkwMyw3ICs5MDMsNyBAQCBzdGF0aWMgaW50IGNnd19yZW1vdmVfam9i
KHN0cnVjdCBza19idWZmICpza2IsICBzdHJ1Y3Qgbmxtc2doZHIgKm5saCwgdm9pZCAqYXJnKQ0K
IA0KIAkJaGxpc3RfZGVsKCZnd2otPmxpc3QpOw0KIAkJY2d3X3VucmVnaXN0ZXJfZmlsdGVyKGd3
aik7DQotCQlrZnJlZShnd2opOw0KKwkJa21lbV9jYWNoZV9mcmVlKGNnd19jYWNoZSwgZ3dqKTsN
CiAJCWVyciA9IDA7DQogCQlicmVhazsNCiAJfQ0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NvY2su
YyBiL25ldC9jb3JlL3NvY2suYw0KaW5kZXggMWU4YTg4Mi4uMmM3M2FkZiAxMDA2NDQNCi0tLSBh
L25ldC9jb3JlL3NvY2suYw0KKysrIGIvbmV0L2NvcmUvc29jay5jDQpAQCAtNzYxLDYgKzc2MSwy
MCBAQCB2b2lkIGNyZWRfdG9fdWNyZWQoc3RydWN0IHBpZCAqcGlkLCBjb25zdCBzdHJ1Y3QgY3Jl
ZCAqY3JlZCwNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoY3JlZF90b191Y3JlZCk7DQogDQordm9p
ZCBjcmVkX3JlYWxfdG9fdWNyZWQoc3RydWN0IHBpZCAqcGlkLCBjb25zdCBzdHJ1Y3QgY3JlZCAq
Y3JlZCwNCisJCQlzdHJ1Y3QgdWNyZWQgKnVjcmVkKQ0KK3sNCisJdWNyZWQtPnBpZCA9IHBpZF92
bnIocGlkKTsNCisJdWNyZWQtPnVpZCA9IHVjcmVkLT5naWQgPSAtMTsNCisJaWYgKGNyZWQpIHsN
CisJCXN0cnVjdCB1c2VyX25hbWVzcGFjZSAqY3VycmVudF9ucyA9IGN1cnJlbnRfdXNlcl9ucygp
Ow0KKw0KKwkJdWNyZWQtPnVpZCA9IHVzZXJfbnNfbWFwX3VpZChjdXJyZW50X25zLCBjcmVkLCBj
cmVkLT51aWQpOw0KKwkJdWNyZWQtPmdpZCA9IHVzZXJfbnNfbWFwX2dpZChjdXJyZW50X25zLCBj
cmVkLCBjcmVkLT5naWQpOw0KKwl9DQorfQ0KK0VYUE9SVF9TWU1CT0xfR1BMKGNyZWRfcmVhbF90
b191Y3JlZCk7DQorDQogaW50IHNvY2tfZ2V0c29ja29wdChzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBp
bnQgbGV2ZWwsIGludCBvcHRuYW1lLA0KIAkJICAgIGNoYXIgX191c2VyICpvcHR2YWwsIGludCBf
X3VzZXIgKm9wdGxlbikNCiB7DQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9oZGFfY29kZWMu
YyBiL3NvdW5kL3BjaS9oZGEvaGRhX2NvZGVjLmMNCmluZGV4IDc3NDdkMjYuLjQ3MDdiNmMgMTAw
NjQ0DQotLS0gYS9zb3VuZC9wY2kvaGRhL2hkYV9jb2RlYy5jDQorKysgYi9zb3VuZC9wY2kvaGRh
L2hkYV9jb2RlYy5jDQpAQCAtMTYzLDcgKzE2Myw3IEBAIGNvbnN0IGNoYXIgKnNuZF9oZGFfZ2V0
X2phY2tfdHlwZSh1MzIgY2ZnKQ0KIAkJIkxpbmUgT3V0IiwgIlNwZWFrZXIiLCAiSFAgT3V0Iiwg
IkNEIiwNCiAJCSJTUERJRiBPdXQiLCAiRGlnaXRhbCBPdXQiLCAiTW9kZW0gTGluZSIsICJNb2Rl
bSBIYW5kIiwNCiAJCSJMaW5lIEluIiwgIkF1eCIsICJNaWMiLCAiVGVsZXBob255IiwNCi0JCSJT
UERJRiBJbiIsICJEaWdpdGlhbCBJbiIsICJSZXNlcnZlZCIsICJPdGhlciINCisJCSJTUERJRiBJ
biIsICJEaWdpdGFsIEluIiwgIlJlc2VydmVkIiwgIk90aGVyIg0KIAl9Ow0KIA0KIAlyZXR1cm4g
amFja190eXBlc1soY2ZnICYgQUNfREVGQ0ZHX0RFVklDRSkNCmRpZmYgLS1naXQgYS9zb3VuZC9w
Y2kvaGRhL3BhdGNoX3JlYWx0ZWsuYyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jDQpp
bmRleCBmM2UwYjI0Li4xYjQzZmRlIDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL2hkYS9wYXRjaF9y
ZWFsdGVrLmMNCisrKyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jDQpAQCAtNTU5NSw3
ICs1NTk1LDggQEAgc3RhdGljIGludCBhbGM2NjJfcGFyc2VfYXV0b19jb25maWcoc3RydWN0IGhk
YV9jb2RlYyAqY29kZWMpDQogCWNvbnN0IGhkYV9uaWRfdCAqc3NpZHM7DQogDQogCWlmIChjb2Rl
Yy0+dmVuZG9yX2lkID09IDB4MTBlYzAyNzIgfHwgY29kZWMtPnZlbmRvcl9pZCA9PSAweDEwZWMw
NjYzIHx8DQotCSAgICBjb2RlYy0+dmVuZG9yX2lkID09IDB4MTBlYzA2NjUgfHwgY29kZWMtPnZl
bmRvcl9pZCA9PSAweDEwZWMwNjcwKQ0KKwkgICAgY29kZWMtPnZlbmRvcl9pZCA9PSAweDEwZWMw
NjY1IHx8IGNvZGVjLT52ZW5kb3JfaWQgPT0gMHgxMGVjMDY3MCB8fA0KKwkgICAgY29kZWMtPnZl
bmRvcl9pZCA9PSAweDEwZWMwNjcxKQ0KIAkJc3NpZHMgPSBhbGM2NjNfc3NpZHM7DQogCWVsc2UN
CiAJCXNzaWRzID0gYWxjNjYyX3NzaWRzOw0KQEAgLTYwNDUsNiArNjA0Niw3IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRhX3ByZXNldF9yZWFsdGVrW10gPSB7
DQogCXsgLmlkID0gMHgxMGVjMDY2NSwgLm5hbWUgPSAiQUxDNjY1IiwgLnBhdGNoID0gcGF0Y2hf
YWxjNjYyIH0sDQogCXsgLmlkID0gMHgxMGVjMDY2OCwgLm5hbWUgPSAiQUxDNjY4IiwgLnBhdGNo
ID0gcGF0Y2hfYWxjNjYyIH0sDQogCXsgLmlkID0gMHgxMGVjMDY3MCwgLm5hbWUgPSAiQUxDNjcw
IiwgLnBhdGNoID0gcGF0Y2hfYWxjNjYyIH0sDQorCXsgLmlkID0gMHgxMGVjMDY3MSwgLm5hbWUg
PSAiQUxDNjcxIiwgLnBhdGNoID0gcGF0Y2hfYWxjNjYyIH0sDQogCXsgLmlkID0gMHgxMGVjMDY4
MCwgLm5hbWUgPSAiQUxDNjgwIiwgLnBhdGNoID0gcGF0Y2hfYWxjNjgwIH0sDQogCXsgLmlkID0g
MHgxMGVjMDg4MCwgLm5hbWUgPSAiQUxDODgwIiwgLnBhdGNoID0gcGF0Y2hfYWxjODgwIH0sDQog
CXsgLmlkID0gMHgxMGVjMDg4MiwgLm5hbWUgPSAiQUxDODgyIiwgLnBhdGNoID0gcGF0Y2hfYWxj
ODgyIH0sDQpkaWZmIC0tZ2l0IGEvc291bmQvc29jL2NvZGVjcy93bTg5MDMuYyBiL3NvdW5kL3Nv
Yy9jb2RlY3Mvd204OTAzLmMNCmluZGV4IDRhZDhlYmQuLjQzNTJmZmIgMTAwNjQ0DQotLS0gYS9z
b3VuZC9zb2MvY29kZWNzL3dtODkwMy5jDQorKysgYi9zb3VuZC9zb2MvY29kZWNzL3dtODkwMy5j
DQpAQCAtMTEwMSw2ICsxMTAxLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzbmRfc29jX2RhcG1f
cm91dGUgd204OTAzX2ludGVyY29uW10gPSB7DQogCXsgIlJPUCIsIE5VTEwsICJSaWdodCBTcGVh
a2VyIFBHQSIgfSwNCiAJeyAiUk9OIiwgTlVMTCwgIlJpZ2h0IFNwZWFrZXIgUEdBIiB9LA0KIA0K
Kwl7ICJDaGFyZ2UgUHVtcCIsIE5VTEwsICJDTEtfRFNQIiB9LA0KKw0KIAl7ICJMZWZ0IEhlYWRw
aG9uZSBPdXRwdXQgUEdBIiwgTlVMTCwgIkNoYXJnZSBQdW1wIiB9LA0KIAl7ICJSaWdodCBIZWFk
cGhvbmUgT3V0cHV0IFBHQSIsIE5VTEwsICJDaGFyZ2UgUHVtcCIgfSwNCiAJeyAiTGVmdCBMaW5l
IE91dHB1dCBQR0EiLCBOVUxMLCAiQ2hhcmdlIFB1bXAiIH0sDQpkaWZmIC0tZ2l0IGEvc291bmQv
dXNiL21peGVyX3F1aXJrcy5jIGIvc291bmQvdXNiL21peGVyX3F1aXJrcy5jDQppbmRleCAzOGE2
MDdhLi5mYjk1MDY5IDEwMDY0NA0KLS0tIGEvc291bmQvdXNiL21peGVyX3F1aXJrcy5jDQorKysg
Yi9zb3VuZC91c2IvbWl4ZXJfcXVpcmtzLmMNCkBAIC0zOTYsNyArMzk2LDcgQEAgc3RhdGljIGlu
dCBzbmRfbmF0aXZlaW5zdHJ1bWVudHNfY29udHJvbF9nZXQoc3RydWN0IHNuZF9rY29udHJvbCAq
a2NvbnRyb2wsDQogCWVsc2UNCiAJCXJldCA9IHVzYl9jb250cm9sX21zZyhkZXYsIHVzYl9yY3Zj
dHJscGlwZShkZXYsIDApLCBiUmVxdWVzdCwNCiAJCQkJICBVU0JfVFlQRV9WRU5ET1IgfCBVU0Jf
UkVDSVBfREVWSUNFIHwgVVNCX0RJUl9JTiwNCi0JCQkJICAwLCBjcHVfdG9fbGUxNih3SW5kZXgp
LA0KKwkJCQkgIDAsIHdJbmRleCwNCiAJCQkJICAmdG1wLCBzaXplb2YodG1wKSwgMTAwMCk7DQog
CXVwX3JlYWQoJm1peGVyLT5jaGlwLT5zaHV0ZG93bl9yd3NlbSk7DQogDQpAQCAtNDI3LDcgKzQy
Nyw3IEBAIHN0YXRpYyBpbnQgc25kX25hdGl2ZWluc3RydW1lbnRzX2NvbnRyb2xfcHV0KHN0cnVj
dCBzbmRfa2NvbnRyb2wgKmtjb250cm9sLA0KIAllbHNlDQogCQlyZXQgPSB1c2JfY29udHJvbF9t
c2coZGV2LCB1c2Jfc25kY3RybHBpcGUoZGV2LCAwKSwgYlJlcXVlc3QsDQogCQkJCSAgVVNCX1RZ
UEVfVkVORE9SIHwgVVNCX1JFQ0lQX0RFVklDRSB8IFVTQl9ESVJfT1VULA0KLQkJCQkgIGNwdV90
b19sZTE2KHdWYWx1ZSksIGNwdV90b19sZTE2KHdJbmRleCksDQorCQkJCSAgd1ZhbHVlLCB3SW5k
ZXgsDQogCQkJCSAgTlVMTCwgMCwgMTAwMCk7DQogCXVwX3JlYWQoJm1peGVyLT5jaGlwLT5zaHV0
ZG93bl9yd3NlbSk7DQogDQpkaWZmIC0tZ2l0IGEvc291bmQvdXNiL3F1aXJrcy5jIGIvc291bmQv
dXNiL3F1aXJrcy5jDQppbmRleCAxYjI3NWYwLi5kZmJkNjVkIDEwMDY0NA0KLS0tIGEvc291bmQv
dXNiL3F1aXJrcy5jDQorKysgYi9zb3VuZC91c2IvcXVpcmtzLmMNCkBAIC00ODIsNyArNDgyLDcg
QEAgc3RhdGljIGludCBzbmRfdXNiX25hdGl2ZWluc3RydW1lbnRzX2Jvb3RfcXVpcmsoc3RydWN0
IHVzYl9kZXZpY2UgKmRldikNCiB7DQogCWludCByZXQgPSB1c2JfY29udHJvbF9tc2coZGV2LCB1
c2Jfc25kY3RybHBpcGUoZGV2LCAwKSwNCiAJCQkJICAweGFmLCBVU0JfVFlQRV9WRU5ET1IgfCBV
U0JfUkVDSVBfREVWSUNFLA0KLQkJCQkgIGNwdV90b19sZTE2KDEpLCAwLCBOVUxMLCAwLCAxMDAw
KTsNCisJCQkJICAxLCAwLCBOVUxMLCAwLCAxMDAwKTsNCiANCiAJaWYgKHJldCA8IDApDQogCQly
ZXR1cm4gcmV0Ow0KZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2lvYXBpYy5jIGIvdmlydC9rdm0vaW9h
cGljLmMNCmluZGV4IDNlZWQ2MWUuLjc5NjQ3Y2QgMTAwNjQ0DQotLS0gYS92aXJ0L2t2bS9pb2Fw
aWMuYw0KKysrIGIvdmlydC9rdm0vaW9hcGljLmMNCkBAIC03Myw5ICs3MywxMiBAQCBzdGF0aWMg
dW5zaWduZWQgbG9uZyBpb2FwaWNfcmVhZF9pbmRpcmVjdChzdHJ1Y3Qga3ZtX2lvYXBpYyAqaW9h
cGljLA0KIAkJCXUzMiByZWRpcl9pbmRleCA9IChpb2FwaWMtPmlvcmVnc2VsIC0gMHgxMCkgPj4g
MTsNCiAJCQl1NjQgcmVkaXJfY29udGVudDsNCiANCi0JCQlBU1NFUlQocmVkaXJfaW5kZXggPCBJ
T0FQSUNfTlVNX1BJTlMpOw0KKwkJCWlmIChyZWRpcl9pbmRleCA8IElPQVBJQ19OVU1fUElOUykN
CisJCQkJcmVkaXJfY29udGVudCA9DQorCQkJCQlpb2FwaWMtPnJlZGlydGJsW3JlZGlyX2luZGV4
XS5iaXRzOw0KKwkJCWVsc2UNCisJCQkJcmVkaXJfY29udGVudCA9IH4wVUxMOw0KIA0KLQkJCXJl
ZGlyX2NvbnRlbnQgPSBpb2FwaWMtPnJlZGlydGJsW3JlZGlyX2luZGV4XS5iaXRzOw0KIAkJCXJl
c3VsdCA9IChpb2FwaWMtPmlvcmVnc2VsICYgMHgxKSA/DQogCQkJICAgIChyZWRpcl9jb250ZW50
ID4+IDMyKSAmIDB4ZmZmZmZmZmYgOg0KIAkJCSAgICByZWRpcl9jb250ZW50ICYgMHhmZmZmZmZm
ZjsNCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4u
Yw0KaW5kZXggZWM3NDdkYy4uOGJmMDVmMCAxMDA2NDQNCi0tLSBhL3ZpcnQva3ZtL2t2bV9tYWlu
LmMNCisrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCkBAIC0xNDAxLDIxICsxNDAxLDM4IEBAIGlu
dCBrdm1fd3JpdGVfZ3Vlc3Qoc3RydWN0IGt2bSAqa3ZtLCBncGFfdCBncGEsIGNvbnN0IHZvaWQg
KmRhdGEsDQogfQ0KIA0KIGludCBrdm1fZ2ZuX3RvX2h2YV9jYWNoZV9pbml0KHN0cnVjdCBrdm0g
Kmt2bSwgc3RydWN0IGdmbl90b19odmFfY2FjaGUgKmdoYywNCi0JCQkgICAgICBncGFfdCBncGEp
DQorCQkJICAgICAgZ3BhX3QgZ3BhLCB1bnNpZ25lZCBsb25nIGxlbikNCiB7DQogCXN0cnVjdCBr
dm1fbWVtc2xvdHMgKnNsb3RzID0ga3ZtX21lbXNsb3RzKGt2bSk7DQogCWludCBvZmZzZXQgPSBv
ZmZzZXRfaW5fcGFnZShncGEpOw0KLQlnZm5fdCBnZm4gPSBncGEgPj4gUEFHRV9TSElGVDsNCisJ
Z2ZuX3Qgc3RhcnRfZ2ZuID0gZ3BhID4+IFBBR0VfU0hJRlQ7DQorCWdmbl90IGVuZF9nZm4gPSAo
Z3BhICsgbGVuIC0gMSkgPj4gUEFHRV9TSElGVDsNCisJZ2ZuX3QgbnJfcGFnZXNfbmVlZGVkID0g
ZW5kX2dmbiAtIHN0YXJ0X2dmbiArIDE7DQorCWdmbl90IG5yX3BhZ2VzX2F2YWlsOw0KIA0KIAln
aGMtPmdwYSA9IGdwYTsNCiAJZ2hjLT5nZW5lcmF0aW9uID0gc2xvdHMtPmdlbmVyYXRpb247DQot
CWdoYy0+bWVtc2xvdCA9IF9fZ2ZuX3RvX21lbXNsb3Qoc2xvdHMsIGdmbik7DQotCWdoYy0+aHZh
ID0gZ2ZuX3RvX2h2YV9tYW55KGdoYy0+bWVtc2xvdCwgZ2ZuLCBOVUxMKTsNCi0JaWYgKCFrdm1f
aXNfZXJyb3JfaHZhKGdoYy0+aHZhKSkNCisJZ2hjLT5sZW4gPSBsZW47DQorCWdoYy0+bWVtc2xv
dCA9IF9fZ2ZuX3RvX21lbXNsb3Qoc2xvdHMsIHN0YXJ0X2dmbik7DQorCWdoYy0+aHZhID0gZ2Zu
X3RvX2h2YV9tYW55KGdoYy0+bWVtc2xvdCwgc3RhcnRfZ2ZuLCAmbnJfcGFnZXNfYXZhaWwpOw0K
KwlpZiAoIWt2bV9pc19lcnJvcl9odmEoZ2hjLT5odmEpICYmIG5yX3BhZ2VzX2F2YWlsID49IG5y
X3BhZ2VzX25lZWRlZCkgew0KIAkJZ2hjLT5odmEgKz0gb2Zmc2V0Ow0KLQllbHNlDQotCQlyZXR1
cm4gLUVGQVVMVDsNCi0NCisJfSBlbHNlIHsNCisJCS8qDQorCQkgKiBJZiB0aGUgcmVxdWVzdGVk
IHJlZ2lvbiBjcm9zc2VzIHR3byBtZW1zbG90cywgd2Ugc3RpbGwNCisJCSAqIHZlcmlmeSB0aGF0
IHRoZSBlbnRpcmUgcmVnaW9uIGlzIHZhbGlkIGhlcmUuDQorCQkgKi8NCisJCXdoaWxlIChzdGFy
dF9nZm4gPD0gZW5kX2dmbikgew0KKwkJCWdoYy0+bWVtc2xvdCA9IF9fZ2ZuX3RvX21lbXNsb3Qo
c2xvdHMsIHN0YXJ0X2dmbik7DQorCQkJZ2hjLT5odmEgPSBnZm5fdG9faHZhX21hbnkoZ2hjLT5t
ZW1zbG90LCBzdGFydF9nZm4sDQorCQkJCQkJICAgJm5yX3BhZ2VzX2F2YWlsKTsNCisJCQlpZiAo
a3ZtX2lzX2Vycm9yX2h2YShnaGMtPmh2YSkpDQorCQkJCXJldHVybiAtRUZBVUxUOw0KKwkJCXN0
YXJ0X2dmbiArPSBucl9wYWdlc19hdmFpbDsNCisJCX0NCisJCS8qIFVzZSB0aGUgc2xvdyBwYXRo
IGZvciBjcm9zcyBwYWdlIHJlYWRzIGFuZCB3cml0ZXMuICovDQorCQlnaGMtPm1lbXNsb3QgPSBO
VUxMOw0KKwl9DQogCXJldHVybiAwOw0KIH0NCiBFWFBPUlRfU1lNQk9MX0dQTChrdm1fZ2ZuX3Rv
X2h2YV9jYWNoZV9pbml0KTsNCkBAIC0xNDI2LDggKzE0NDMsMTMgQEAgaW50IGt2bV93cml0ZV9n
dWVzdF9jYWNoZWQoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QgZ2ZuX3RvX2h2YV9jYWNoZSAqZ2hj
LA0KIAlzdHJ1Y3Qga3ZtX21lbXNsb3RzICpzbG90cyA9IGt2bV9tZW1zbG90cyhrdm0pOw0KIAlp
bnQgcjsNCiANCisJQlVHX09OKGxlbiA+IGdoYy0+bGVuKTsNCisNCiAJaWYgKHNsb3RzLT5nZW5l
cmF0aW9uICE9IGdoYy0+Z2VuZXJhdGlvbikNCi0JCWt2bV9nZm5fdG9faHZhX2NhY2hlX2luaXQo
a3ZtLCBnaGMsIGdoYy0+Z3BhKTsNCisJCWt2bV9nZm5fdG9faHZhX2NhY2hlX2luaXQoa3ZtLCBn
aGMsIGdoYy0+Z3BhLCBnaGMtPmxlbik7DQorDQorCWlmICh1bmxpa2VseSghZ2hjLT5tZW1zbG90
KSkNCisJCXJldHVybiBrdm1fd3JpdGVfZ3Vlc3Qoa3ZtLCBnaGMtPmdwYSwgZGF0YSwgbGVuKTsN
CiANCiAJaWYgKGt2bV9pc19lcnJvcl9odmEoZ2hjLT5odmEpKQ0KIAkJcmV0dXJuIC1FRkFVTFQ7
DQpAQCAtMTQ0Nyw4ICsxNDY5LDEzIEBAIGludCBrdm1fcmVhZF9ndWVzdF9jYWNoZWQoc3RydWN0
IGt2bSAqa3ZtLCBzdHJ1Y3QgZ2ZuX3RvX2h2YV9jYWNoZSAqZ2hjLA0KIAlzdHJ1Y3Qga3ZtX21l
bXNsb3RzICpzbG90cyA9IGt2bV9tZW1zbG90cyhrdm0pOw0KIAlpbnQgcjsNCiANCisJQlVHX09O
KGxlbiA+IGdoYy0+bGVuKTsNCisNCiAJaWYgKHNsb3RzLT5nZW5lcmF0aW9uICE9IGdoYy0+Z2Vu
ZXJhdGlvbikNCi0JCWt2bV9nZm5fdG9faHZhX2NhY2hlX2luaXQoa3ZtLCBnaGMsIGdoYy0+Z3Bh
KTsNCisJCWt2bV9nZm5fdG9faHZhX2NhY2hlX2luaXQoa3ZtLCBnaGMsIGdoYy0+Z3BhLCBnaGMt
Pmxlbik7DQorDQorCWlmICh1bmxpa2VseSghZ2hjLT5tZW1zbG90KSkNCisJCXJldHVybiBrdm1f
cmVhZF9ndWVzdChrdm0sIGdoYy0+Z3BhLCBkYXRhLCBsZW4pOw0KIA0KIAlpZiAoa3ZtX2lzX2Vy
cm9yX2h2YShnaGMtPmh2YSkpDQogCQlyZXR1cm4gLUVGQVVMVDsNCi==


--=-0qPRDH71gJHOZvXRVSSI--

--=-fA47neVmN5lZ3ET9C6Qr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXpoLee/yOyVhhEJAQrALA/8DxnZ5ZbrSJde/IgflwYISKx7zFGnOfhp
CvM9Ztid9aCa0nyNJ0hP4F3JFewsBBx1PjARAfG/SirvTBgYw2ilqu6Q+gtxumrB
M24sEUO4zNc5Db08ESo1fg2zdqx/92amgwHM8vepSq+7CY6oU0YHYZCrzd/C7mqu
7R9t9Rs9fKHHxSMMzIX5REgaTnsZcUThNpLk5GcRNcJ6UvZcHIZYJnJgLwB3Bbn7
XeoDxhkPNNUQVnzoqpewBwufP4Uf8f17KnuXDL1GQAqgQhH4qk8UnyEc2zbmBDQ7
N42dl1sOn0hDY3DcjmaClTMYYy/IJEiv+VUNADcbT7IPWUgNmYvBwTYM5HogSfEN
d8w15y8PQwXoPN+xXw0jjCoEm+3i9uQRnUim9TTJYtcon5+KyYIzEJiVEUgKxwzF
s115Krj4rVjc/gmfJ+nsUT5xP5ZnyGdce+2zMTqyNuIZLMyZZc7NqSHMrnmWJeNa
hG5tlyiDdh3y+QP9p4kLLv5aPs/3jW+Ifj20058+42bXS/aRkPYPMFRDAWAy9rlT
dABmCrs8caVS+LM4zKsT359yPkSYF9hSul82dkc1IwlNwHx0rWJF0YDYSEMofHXI
uFfcd/WgTym9EmRteY6GmMvrPdWx0LYSVxSX6YJDpV4obEseoYMqHrch/r8doAan
hM4KDoPqvZg=
=NoOq
-----END PGP SIGNATURE-----

--=-fA47neVmN5lZ3ET9C6Qr--
