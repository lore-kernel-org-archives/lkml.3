Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3FSC2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:28:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55765 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933857Ab3FSC2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:28:48 -0400
Message-ID: <1371608907.3495.143.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.47
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 19 Jun 2013 03:28:27 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PdLgs3HuNq9nZclyTwTk"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PdLgs3HuNq9nZclyTwTk
Content-Type: multipart/mixed; boundary="=-C+iZ7s23r6Ie63Brk+ei"


--=-C+iZ7s23r6Ie63Brk+ei
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.47 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.46 is attached to this message.

Ben.

------------

 Makefile                                       |    2 +-
 arch/arm/boot/compressed/Makefile              |    1 -
 arch/arm/boot/compressed/head-sa1100.S         |    1 +
 arch/arm/boot/compressed/head-shark.S          |    1 +
 arch/arm/boot/compressed/head.S                |    1 +
 arch/arm/kernel/topology.c                     |    2 +
 arch/powerpc/kernel/exceptions-64s.S           |    2 +-
 arch/powerpc/kernel/traps.c                    |   10 +
 arch/x86/kernel/relocate_kernel_64.S           |    2 +-
 drivers/acpi/video.c                           |   32 +++
 drivers/ata/ata_piix.c                         |   14 ++
 drivers/ata/libata-core.c                      |    6 +
 drivers/block/cciss.c                          |   32 +--
 drivers/gpu/drm/drm_irq.c                      |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c              |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c              |   12 +-
 drivers/gpu/drm/radeon/evergreen.c             |   10 +-
 drivers/gpu/drm/radeon/ni.c                    |   10 +-
 drivers/gpu/drm/radeon/r100.c                  |    9 +-
 drivers/gpu/drm/radeon/r300.c                  |    9 +-
 drivers/gpu/drm/radeon/r420.c                  |   10 +-
 drivers/gpu/drm/radeon/r520.c                  |    9 +-
 drivers/gpu/drm/radeon/r600.c                  |   10 +-
 drivers/gpu/drm/radeon/radeon_device.c         |   19 +-
 drivers/gpu/drm/radeon/rs400.c                 |    9 +-
 drivers/gpu/drm/radeon/rs600.c                 |    9 +-
 drivers/gpu/drm/radeon/rs690.c                 |    9 +-
 drivers/gpu/drm/radeon/rv515.c                 |    9 +-
 drivers/gpu/drm/radeon/rv770.c                 |   10 +-
 drivers/hwmon/adm1021.c                        |   58 ++++-
 drivers/md/raid1.c                             |   12 +-
 drivers/md/raid10.c                            |   12 +-
 drivers/net/ethernet/broadcom/tg3.c            |   42 ++++
 drivers/net/ethernet/broadcom/tg3.h            |    8 +-
 drivers/net/wireless/ath/ath9k/Kconfig         |   10 +-
 drivers/net/wireless/ath/ath9k/Makefile        |    2 +-
 drivers/net/wireless/ath/ath9k/init.c          |    7 +-
 drivers/net/wireless/ath/ath9k/rc.h            |    2 +-
 drivers/net/wireless/b43/main.c                |    2 +-
 drivers/net/wireless/b43legacy/main.c          |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    2 +-
 drivers/net/xen-netback/netback.c              |  315 +++++++++++++++++++-=
----
 drivers/net/xen-netfront.c                     |   17 +-
 drivers/platform/x86/thinkpad_acpi.c           |    7 +
 drivers/rapidio/devices/tsi721.c               |    2 +-
 drivers/rtc/rtc-twl.c                          |    1 +
 drivers/staging/gma500/cdv_intel_display.c     |   14 ++
 drivers/staging/gma500/framebuffer.c           |    4 +-
 drivers/staging/gma500/psb_intel_display.c     |   14 ++
 drivers/target/iscsi/iscsi_target_parameters.c |    8 +-
 drivers/target/iscsi/iscsi_target_parameters.h |    4 +-
 drivers/usb/dwc3/gadget.c                      |   15 +-
 drivers/usb/host/ehci-sched.c                  |    2 +-
 drivers/usb/host/xhci-mem.c                    |   10 +-
 drivers/usb/host/xhci.c                        |   12 +-
 drivers/usb/serial/ark3116.c                   |    2 +-
 drivers/usb/serial/cypress_m8.c                |   18 +-
 drivers/usb/serial/cypress_m8.h                |    4 +
 drivers/usb/serial/ftdi_sio.c                  |    4 +
 drivers/usb/serial/iuu_phoenix.c               |    4 +-
 drivers/usb/serial/keyspan.c                   |    2 +-
 drivers/usb/serial/mos7720.c                   |   25 +-
 drivers/usb/serial/option.c                    |    2 +
 drivers/usb/serial/pl2303.c                    |   10 +-
 drivers/usb/serial/qcserial.c                  |    1 +
 drivers/usb/serial/spcp8x5.c                   |   10 +-
 drivers/usb/serial/visor.c                     |    2 +
 drivers/usb/serial/whiteheat.c                 |    2 +-
 drivers/xen/events.c                           |   19 +-
 fs/cifs/cifs_dfs_ref.c                         |    4 +-
 fs/ext4/super.c                                |    2 +
 fs/jfs/inode.c                                 |    2 +-
 fs/jfs/jfs_logmgr.c                            |    3 +-
 fs/xfs/xfs_iops.c                              |   47 ++--
 include/linux/cpu.h                            |    4 +
 include/linux/net.h                            |   23 ++
 include/linux/swapops.h                        |    3 +
 include/xen/interface/io/netif.h               |   19 ++
 kernel/audit.c                                 |    2 +-
 kernel/cpu.c                                   |   55 ++---
 kernel/sys.c                                   |   29 ++-
 kernel/trace/ftrace.c                          |   26 +-
 mm/hugetlb.c                                   |    2 +-
 mm/migrate.c                                   |   23 +-
 mm/swap_state.c                                |   18 +-
 net/bluetooth/l2cap_core.c                     |   85 +++++--
 net/mac80211/iface.c                           |    9 +
 net/wireless/sme.c                             |    3 +
 sound/usb/card.h                               |    1 +
 sound/usb/format.c                             |    6 +-
 sound/usb/mixer.c                              |    1 +
 sound/usb/quirks-table.h                       |    8 +-
 sound/usb/quirks.c                             |    6 +-
 93 files changed, 1024 insertions(+), 306 deletions(-)

Adis Hamzi=C4=87 (1):
      radeon: Fix system hang issue when using KMS with older cards

Alan Stern (1):
      USB: revert periodic scheduling bugfix

Alex Deucher (1):
      drm/radeon: fix card_posted check for newer asics

Alex Hung (2):
      ACPI video: ignore BIOS initial backlight value for HP 1000
      ACPI / video: ignore BIOS initial backlight value for HP m4

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Fault=
y and non-rebuilding drive completed it.

Andrew Worsley (1):
      USB: serial: ftdi_sio: Handle the old_termios =3D=3D 0 case e.g. uart=
_resume_port()

Arnd Bergmann (2):
      ARM: 7742/1: topology: export cpu_topology
      ARM: 7743/1: compressed/head.S: work around new binutils warning

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Ben Hutchings (2):
      rapidio/tsi721: Fix interrupt mask when handling MSI
      Linux 3.2.47

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Bj=C3=B8rn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.

Dave Kleikamp (1):
      jfs: fix a couple races

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DD=
C.

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1=
617

Gustavo Maciel Dias Vieira (1):
      ACPI video: ignore BIOS backlight value for HP dm4

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Jeff Layton (1):
      cifs: fix potential buffer overrun when composing a new options strin=
g

Joe Perches (1):
      net: Add net_ratelimited_function and net_<level>_ratelimited macros

Johan Hedberg (1):
      Bluetooth: Fix missing length checks for L2CAP signalling PDUs

Johan Hovold (11):
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: mos7720: fix DMA to stack
      USB: ark3116: fix control-message timeout
      USB: iuu_phoenix: fix bulk-message timeout
      USB: mos7720: fix message timeouts
      USB: keyspan: fix bogus array index
      USB: mos7720: fix hardware flow control
      USB: whiteheat: fix broken port configuration
      USB: spcp8x5: fix device initialisation at open
      USB: pl2303: fix device initialisation at open

Johannes Berg (2):
      cfg80211: check wdev->netdev in connection work
      mac80211: close AP_VLAN interfaces before unregistering all

Kees Cook (3):
      iscsi-target: fix heap buffer overflow on error
      b43: stop format string leaking into error msgs
      x86: Fix typo in kexec register clearing

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Larry Finger (1):
      b43legacy: Fix crash on unload when firmware not available

Manoj Iyer (1):
      thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Michael Chan (1):
      tg3: Add New 5719 Read DMA workaround

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

Nithin Sujir (2):
      tg3: Add read dma workaround for 5720
      tg3: Wait for boot code to finish after power on

Oleg Nesterov (1):
      audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

Patrik Jakobsson (3):
      drm/gma500: Increase max resolution for mode setting
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on=
 discard I/O completion

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl

Steven Rostedt (Red Hat) (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
      ath9k: Use minstrel rate control by default

Takashi Iwai (2):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audi=
o iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam=
 c270

Theodore Ts'o (1):
      ext4: lock i_mutex when truncating orphan inodes

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted w=
ith device tree

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Vladimir Murzin (1):
      xhci: fix list access before init

Wei Liu (8):
      xen-netback: remove skb in xen_netbk_alloc_page
      netback: remove redundant assignment
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet
      xen-netback: remove redundent parameter in netbk_count_requests
      xen-netback: avoid allocating variable size array on stack
      xen-netback: better names for thresholds
      xen-netfront: reduce gso_max_size to account for max TCP header

Xi Wang (2):
      ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_=
rate_range()
      ALSA: usb-audio: avoid integer overflow in create_fixed_stream_quirk(=
)

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL =
pointer

stephen hemminger (1):
      xen-netback: fix sparse warning


--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-C+iZ7s23r6Ie63Brk+ei
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.47.patch"
Content-Disposition: attachment; filename="linux-3.2.47.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IGY2MDA1ODIuLjQwZTJhMTEg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDQ2DQorU1VCTEVWRUwg
PSA0Nw0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUgYi9hcmNoL2Fy
bS9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUNCmluZGV4IDIxZjU2ZmYuLjU5NTRhMWEgMTAwNjQ0
DQotLS0gYS9hcmNoL2FybS9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUNCisrKyBiL2FyY2gvYXJt
L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQ0KQEAgLTEyMyw3ICsxMjMsNiBAQCBLQlVJTERfQ0ZM
QUdTID0gJChzdWJzdCAtcGcsICwgJChPUklHX0NGTEFHUykpDQogZW5kaWYNCiANCiBjY2ZsYWdz
LXkgOj0gLWZwaWMgLWZuby1idWlsdGluIC1JJChvYmopDQotYXNmbGFncy15IDo9IC1XYSwtbWFy
Y2g9YWxsDQogDQogIyBTdXBwbHkga2VybmVsIEJTUyBzaXplIHRvIHRoZSBkZWNvbXByZXNzb3Ig
dmlhIGEgbGlua2VyIHN5bWJvbC4NCiBLQlNTX1NaID0gJChzaGVsbCBzaXplICQob2JqKS8uLi8u
Li8uLi8uLi92bWxpbnV4IHwgYXdrICdFTkR7cHJpbnQgJCQzfScpDQpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm0vYm9vdC9jb21wcmVzc2VkL2hlYWQtc2ExMTAwLlMgYi9hcmNoL2FybS9ib290L2NvbXBy
ZXNzZWQvaGVhZC1zYTExMDAuUw0KaW5kZXggNjE3OWQ5NC4uMzExNWUzMSAxMDA2NDQNCi0tLSBh
L2FyY2gvYXJtL2Jvb3QvY29tcHJlc3NlZC9oZWFkLXNhMTEwMC5TDQorKysgYi9hcmNoL2FybS9i
b290L2NvbXByZXNzZWQvaGVhZC1zYTExMDAuUw0KQEAgLTExLDYgKzExLDcgQEANCiAjaW5jbHVk
ZSA8YXNtL21hY2gtdHlwZXMuaD4NCiANCiAJCS5zZWN0aW9uICAgICAgICAiLnN0YXJ0IiwgImF4
Ig0KKwkJLmFyY2gJYXJtdjQNCiANCiBfX1NBMTEwMF9zdGFydDoNCiANCmRpZmYgLS1naXQgYS9h
cmNoL2FybS9ib290L2NvbXByZXNzZWQvaGVhZC1zaGFyay5TIGIvYXJjaC9hcm0vYm9vdC9jb21w
cmVzc2VkL2hlYWQtc2hhcmsuUw0KaW5kZXggMDg5YzU2MC4uOTJiNTY4OSAxMDA2NDQNCi0tLSBh
L2FyY2gvYXJtL2Jvb3QvY29tcHJlc3NlZC9oZWFkLXNoYXJrLlMNCisrKyBiL2FyY2gvYXJtL2Jv
b3QvY29tcHJlc3NlZC9oZWFkLXNoYXJrLlMNCkBAIC0xOCw2ICsxOCw3IEBADQogCQ0KIAkJLnNl
Y3Rpb24JIi5zdGFydCIsICJheCINCiANCisJCS5hcmNoIGFybXY0DQogCQliCV9fYmVnaW5uaW5n
DQogCQ0KIF9fb2Z3X2RhdGE6CS5sb25nCTAJCQkJQCB0aGUgbnVtYmVyIG9mIG1lbW9yeSBibG9j
a3MNCmRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2NvbXByZXNzZWQvaGVhZC5TIGIvYXJjaC9h
cm0vYm9vdC9jb21wcmVzc2VkL2hlYWQuUw0KaW5kZXggZDYzNjMyZi4uOGM1NzM1OSAxMDA2NDQN
Ci0tLSBhL2FyY2gvYXJtL2Jvb3QvY29tcHJlc3NlZC9oZWFkLlMNCisrKyBiL2FyY2gvYXJtL2Jv
b3QvY29tcHJlc3NlZC9oZWFkLlMNCkBAIC0xMCw2ICsxMCw3IEBADQogICovDQogI2luY2x1ZGUg
PGxpbnV4L2xpbmthZ2UuaD4NCiANCisJLmFyY2gJYXJtdjctYQ0KIC8qDQogICogRGVidWdnaW5n
IHN0dWZmDQogICoNCmRpZmYgLS1naXQgYS9hcmNoL2FybS9rZXJuZWwvdG9wb2xvZ3kuYyBiL2Fy
Y2gvYXJtL2tlcm5lbC90b3BvbG9neS5jDQppbmRleCA4MjAwZGVhLi4xNDBjODE3IDEwMDY0NA0K
LS0tIGEvYXJjaC9hcm0va2VybmVsL3RvcG9sb2d5LmMNCisrKyBiL2FyY2gvYXJtL2tlcm5lbC90
b3BvbG9neS5jDQpAQCAtMTMsNiArMTMsNyBAQA0KIA0KICNpbmNsdWRlIDxsaW51eC9jcHUuaD4N
CiAjaW5jbHVkZSA8bGludXgvY3B1bWFzay5oPg0KKyNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4N
CiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPg0KICNpbmNsdWRlIDxsaW51eC9wZXJjcHUuaD4NCiAj
aW5jbHVkZSA8bGludXgvbm9kZS5oPg0KQEAgLTQyLDYgKzQzLDcgQEANCiAjZGVmaW5lIE1QSURS
X0xFVkVMMl9TSElGVCAxNg0KIA0KIHN0cnVjdCBjcHV0b3BvX2FybSBjcHVfdG9wb2xvZ3lbTlJf
Q1BVU107DQorRVhQT1JUX1NZTUJPTF9HUEwoY3B1X3RvcG9sb2d5KTsNCiANCiBjb25zdCBzdHJ1
Y3QgY3B1bWFzayAqY3B1X2NvcmVncm91cF9tYXNrKGludCBjcHUpDQogew0KZGlmZiAtLWdpdCBh
L2FyY2gvcG93ZXJwYy9rZXJuZWwvZXhjZXB0aW9ucy02NHMuUyBiL2FyY2gvcG93ZXJwYy9rZXJu
ZWwvZXhjZXB0aW9ucy02NHMuUw0KaW5kZXggY2Y5YzY5Yi4uOGMzYmFhMCAxMDA2NDQNCi0tLSBh
L2FyY2gvcG93ZXJwYy9rZXJuZWwvZXhjZXB0aW9ucy02NHMuUw0KKysrIGIvYXJjaC9wb3dlcnBj
L2tlcm5lbC9leGNlcHRpb25zLTY0cy5TDQpAQCAtNDYzLDcgKzQ2Myw3IEBAIG1hY2hpbmVfY2hl
Y2tfY29tbW9uOg0KIAlTVERfRVhDRVBUSU9OX0NPTU1PTigweGIwMCwgdHJhcF8wYiwgLnVua25v
d25fZXhjZXB0aW9uKQ0KIAlTVERfRVhDRVBUSU9OX0NPTU1PTigweGQwMCwgc2luZ2xlX3N0ZXAs
IC5zaW5nbGVfc3RlcF9leGNlcHRpb24pDQogCVNURF9FWENFUFRJT05fQ09NTU9OKDB4ZTAwLCB0
cmFwXzBlLCAudW5rbm93bl9leGNlcHRpb24pDQotICAgICAgICBTVERfRVhDRVBUSU9OX0NPTU1P
TigweGU0MCwgZW11bGF0aW9uX2Fzc2lzdCwgLnByb2dyYW1fY2hlY2tfZXhjZXB0aW9uKQ0KKwlT
VERfRVhDRVBUSU9OX0NPTU1PTigweGU0MCwgZW11bGF0aW9uX2Fzc2lzdCwgLmVtdWxhdGlvbl9h
c3Npc3RfaW50ZXJydXB0KQ0KICAgICAgICAgU1REX0VYQ0VQVElPTl9DT01NT04oMHhlNjAsIGht
aV9leGNlcHRpb24sIC51bmtub3duX2V4Y2VwdGlvbikNCiAJU1REX0VYQ0VQVElPTl9DT01NT05f
SURMRSgweGYwMCwgcGVyZm9ybWFuY2VfbW9uaXRvciwgLnBlcmZvcm1hbmNlX21vbml0b3JfZXhj
ZXB0aW9uKQ0KIAlTVERfRVhDRVBUSU9OX0NPTU1PTigweDEzMDAsIGluc3RydWN0aW9uX2JyZWFr
cG9pbnQsIC5pbnN0cnVjdGlvbl9icmVha3BvaW50X2V4Y2VwdGlvbikNCmRpZmYgLS1naXQgYS9h
cmNoL3Bvd2VycGMva2VybmVsL3RyYXBzLmMgYi9hcmNoL3Bvd2VycGMva2VybmVsL3RyYXBzLmMN
CmluZGV4IDgyZGNkNGQuLjk4NDQ2NjIgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVs
L3RyYXBzLmMNCisrKyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvdHJhcHMuYw0KQEAgLTEwMzYsNiAr
MTAzNiwxNiBAQCB2b2lkIF9fa3Byb2JlcyBwcm9ncmFtX2NoZWNrX2V4Y2VwdGlvbihzdHJ1Y3Qg
cHRfcmVncyAqcmVncykNCiAJCV9leGNlcHRpb24oU0lHSUxMLCByZWdzLCBJTExfSUxMT1BDLCBy
ZWdzLT5uaXApOw0KIH0NCiANCisvKg0KKyAqIFRoaXMgb2NjdXJzIHdoZW4gcnVubmluZyBpbiBo
eXBlcnZpc29yIG1vZGUgb24gUE9XRVI2IG9yIGxhdGVyDQorICogYW5kIGFuIGlsbGVnYWwgaW5z
dHJ1Y3Rpb24gaXMgZW5jb3VudGVyZWQuDQorICovDQordm9pZCBfX2twcm9iZXMgZW11bGF0aW9u
X2Fzc2lzdF9pbnRlcnJ1cHQoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpDQorew0KKwlyZWdzLT5tc3Ig
fD0gUkVBU09OX0lMTEVHQUw7DQorCXByb2dyYW1fY2hlY2tfZXhjZXB0aW9uKHJlZ3MpOw0KK30N
CisNCiB2b2lkIGFsaWdubWVudF9leGNlcHRpb24oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpDQogew0K
IAlpbnQgc2lnLCBjb2RlLCBmaXhlZCA9IDA7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVs
L3JlbG9jYXRlX2tlcm5lbF82NC5TIGIvYXJjaC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82
NC5TDQppbmRleCA3YTZmM2IzLi5mMmJiOWM5IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVs
L3JlbG9jYXRlX2tlcm5lbF82NC5TDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwvcmVsb2NhdGVfa2Vy
bmVsXzY0LlMNCkBAIC0xNjAsNyArMTYwLDcgQEAgaWRlbnRpdHlfbWFwcGVkOg0KIAl4b3JxICAg
ICVyYnAsICVyYnANCiAJeG9ycQklcjgsICAlcjgNCiAJeG9ycQklcjksICAlcjkNCi0JeG9ycQkl
cjEwLCAlcjkNCisJeG9ycQklcjEwLCAlcjEwDQogCXhvcnEJJXIxMSwgJXIxMQ0KIAl4b3JxCSVy
MTIsICVyMTINCiAJeG9ycQklcjEzLCAlcjEzDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3Zp
ZGVvLmMgYi9kcml2ZXJzL2FjcGkvdmlkZW8uYw0KaW5kZXggMGU0Nzk0OS4uZTE5ODk4ZCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvYWNwaS92aWRlby5jDQorKysgYi9kcml2ZXJzL2FjcGkvdmlkZW8u
Yw0KQEAgLTQ0Nyw2ICs0NDcsMzggQEAgc3RhdGljIHN0cnVjdCBkbWlfc3lzdGVtX2lkIHZpZGVv
X2RtaV90YWJsZVtdIF9faW5pdGRhdGEgPSB7DQogCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFN
RSwgIkhQIEZvbGlvIDEzIC0gMjAwMCBOb3RlYm9vayBQQyIpLA0KIAkJfSwNCiAJfSwNCisJew0K
KwkgLmNhbGxiYWNrID0gdmlkZW9faWdub3JlX2luaXRpYWxfYmFja2xpZ2h0LA0KKwkgLmlkZW50
ID0gIkhQIFBhdmlsaW9uIGRtNCIsDQorCSAubWF0Y2hlcyA9IHsNCisJCURNSV9NQVRDSChETUlf
Qk9BUkRfVkVORE9SLCAiSGV3bGV0dC1QYWNrYXJkIiksDQorCQlETUlfTUFUQ0goRE1JX1BST0RV
Q1RfTkFNRSwgIkhQIFBhdmlsaW9uIGRtNCBOb3RlYm9vayBQQyIpLA0KKwkJfSwNCisJfSwNCisJ
ew0KKwkgLmNhbGxiYWNrID0gdmlkZW9faWdub3JlX2luaXRpYWxfYmFja2xpZ2h0LA0KKwkgLmlk
ZW50ID0gIkhQIFBhdmlsaW9uIGc2IE5vdGVib29rIFBDIiwNCisJIC5tYXRjaGVzID0gew0KKwkJ
IERNSV9NQVRDSChETUlfQk9BUkRfVkVORE9SLCAiSGV3bGV0dC1QYWNrYXJkIiksDQorCQkgRE1J
X01BVENIKERNSV9QUk9EVUNUX05BTUUsICJIUCBQYXZpbGlvbiBnNiBOb3RlYm9vayBQQyIpLA0K
KwkJfSwNCisJfSwNCisJew0KKwkgLmNhbGxiYWNrID0gdmlkZW9faWdub3JlX2luaXRpYWxfYmFj
a2xpZ2h0LA0KKwkgLmlkZW50ID0gIkhQIDEwMDAgTm90ZWJvb2sgUEMiLA0KKwkgLm1hdGNoZXMg
PSB7DQorCQlETUlfTUFUQ0goRE1JX0JPQVJEX1ZFTkRPUiwgIkhld2xldHQtUGFja2FyZCIpLA0K
KwkJRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJIUCAxMDAwIE5vdGVib29rIFBDIiksDQor
CQl9LA0KKwl9LA0KKwl7DQorCSAuY2FsbGJhY2sgPSB2aWRlb19pZ25vcmVfaW5pdGlhbF9iYWNr
bGlnaHQsDQorCSAuaWRlbnQgPSAiSFAgUGF2aWxpb24gbTQiLA0KKwkgLm1hdGNoZXMgPSB7DQor
CQlETUlfTUFUQ0goRE1JX0JPQVJEX1ZFTkRPUiwgIkhld2xldHQtUGFja2FyZCIpLA0KKwkJRE1J
X01BVENIKERNSV9QUk9EVUNUX05BTUUsICJIUCBQYXZpbGlvbiBtNCBOb3RlYm9vayBQQyIpLA0K
KwkJfSwNCisJfSwNCiAJe30NCiB9Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2F0YV9w
aWl4LmMgYi9kcml2ZXJzL2F0YS9hdGFfcGlpeC5jDQppbmRleCBkZGZjMWMxLi4wZTkyMzI2IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvYXRhX3BpaXguYw0KKysrIGIvZHJpdmVycy9hdGEvYXRh
X3BpaXguYw0KQEAgLTE1MSw2ICsxNTEsNyBAQCBlbnVtIHBpaXhfY29udHJvbGxlcl9pZHMgew0K
IAlwaWl4X3BhdGFfdm13LAkJCS8qIFBJSVg0IGZvciBWTXdhcmUsIHNwdXJpb3VzIERNQV9FUlIg
Ki8NCiAJaWNoOF9zYXRhX3NuYiwNCiAJaWNoOF8ycG9ydF9zYXRhX3NuYiwNCisJaWNoOF8ycG9y
dF9zYXRhX2J5dCwNCiB9Ow0KIA0KIHN0cnVjdCBwaWl4X21hcF9kYiB7DQpAQCAtMzU2LDYgKzM1
Nyw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBwaWl4X3BjaV90YmxbXSA9
IHsNCiAJeyAweDgwODYsIDB4OGQ2MCwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgaWNo
OF9zYXRhX3NuYiB9LA0KIAkvKiBTQVRBIENvbnRyb2xsZXIgSURFIChXZWxsc2J1cmcpICovDQog
CXsgMHg4MDg2LCAweDhkNjgsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIGljaDhfMnBv
cnRfc2F0YSB9LA0KKwkvKiBTQVRBIENvbnRyb2xsZXIgSURFIChCYXlUcmFpbCkgKi8NCisJeyAw
eDgwODYsIDB4MEYyMCwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgaWNoOF8ycG9ydF9z
YXRhX2J5dCB9LA0KKwl7IDB4ODA4NiwgMHgwRjIxLCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAw
LCAwLCBpY2g4XzJwb3J0X3NhdGFfYnl0IH0sDQogDQogCXsgfQkvKiB0ZXJtaW5hdGUgbGlzdCAq
Lw0KIH07DQpAQCAtNTIxLDYgKzUyNSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGlpeF9tYXBf
ZGIgKnBpaXhfbWFwX2RiX3RhYmxlW10gPSB7DQogCVt0b2xhcGFpX3NhdGFdCQk9ICZ0b2xhcGFp
X21hcF9kYiwNCiAJW2ljaDhfc2F0YV9zbmJdCQk9ICZpY2g4X21hcF9kYiwNCiAJW2ljaDhfMnBv
cnRfc2F0YV9zbmJdCT0gJmljaDhfMnBvcnRfbWFwX2RiLA0KKwlbaWNoOF8ycG9ydF9zYXRhX2J5
dF0JPSAmaWNoOF8ycG9ydF9tYXBfZGIsDQogfTsNCiANCiBzdGF0aWMgc3RydWN0IGF0YV9wb3J0
X2luZm8gcGlpeF9wb3J0X2luZm9bXSA9IHsNCkBAIC02NzIsNiArNjc3LDE1IEBAIHN0YXRpYyBz
dHJ1Y3QgYXRhX3BvcnRfaW5mbyBwaWl4X3BvcnRfaW5mb1tdID0gew0KIAkJLnBvcnRfb3BzCT0g
JnBpaXhfc2F0YV9vcHMsDQogCX0sDQogDQorCVtpY2g4XzJwb3J0X3NhdGFfYnl0XSA9DQorCXsN
CisJCS5mbGFncyAgICAgICAgICA9IFBJSVhfU0FUQV9GTEFHUyB8IFBJSVhfRkxBR19TSURQUiB8
IFBJSVhfRkxBR19QSU8xNiwNCisJCS5waW9fbWFzayAgICAgICA9IEFUQV9QSU80LA0KKwkJLm13
ZG1hX21hc2sgICAgID0gQVRBX01XRE1BMiwNCisJCS51ZG1hX21hc2sgICAgICA9IEFUQV9VRE1B
NiwNCisJCS5wb3J0X29wcyAgICAgICA9ICZwaWl4X3NhdGFfb3BzLA0KKwl9LA0KKw0KIH07DQog
DQogc3RhdGljIHN0cnVjdCBwY2lfYml0cyBwaWl4X2VuYWJsZV9iaXRzW10gPSB7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYyBiL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3Jl
LmMNCmluZGV4IDI4OGI2MzUuLmQ1NGI3ZDYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2F0YS9saWJh
dGEtY29yZS5jDQorKysgYi9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQpAQCAtMTU5OCw2ICsx
NTk4LDEyIEBAIHVuc2lnbmVkIGF0YV9leGVjX2ludGVybmFsX3NnKHN0cnVjdCBhdGFfZGV2aWNl
ICpkZXYsDQogCXFjLT50ZiA9ICp0ZjsNCiAJaWYgKGNkYikNCiAJCW1lbWNweShxYy0+Y2RiLCBj
ZGIsIEFUQVBJX0NEQl9MRU4pOw0KKw0KKwkvKiBzb21lIFNBVEEgYnJpZGdlcyBuZWVkIHVzIHRv
IGluZGljYXRlIGRhdGEgeGZlciBkaXJlY3Rpb24gKi8NCisJaWYgKHRmLT5wcm90b2NvbCA9PSBB
VEFQSV9QUk9UX0RNQSAmJiAoZGV2LT5mbGFncyAmIEFUQV9ERkxBR19ETUFESVIpICYmDQorCSAg
ICBkbWFfZGlyID09IERNQV9GUk9NX0RFVklDRSkNCisJCXFjLT50Zi5mZWF0dXJlIHw9IEFUQVBJ
X0RNQURJUjsNCisNCiAJcWMtPmZsYWdzIHw9IEFUQV9RQ0ZMQUdfUkVTVUxUX1RGOw0KIAlxYy0+
ZG1hX2RpciA9IGRtYV9kaXI7DQogCWlmIChkbWFfZGlyICE9IERNQV9OT05FKSB7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ibG9jay9jY2lzcy5jIGIvZHJpdmVycy9ibG9jay9jY2lzcy5jDQppbmRl
eCBiMGY1NTNiLi5kMzQ0NmY2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ibG9jay9jY2lzcy5jDQor
KysgYi9kcml2ZXJzL2Jsb2NrL2NjaXNzLmMNCkBAIC0xNjEsOCArMTYxLDYgQEAgc3RhdGljIGly
cXJldHVybl90IGRvX2NjaXNzX21zaXhfaW50cihpbnQgaXJxLCB2b2lkICpkZXZfaWQpOw0KIHN0
YXRpYyBpbnQgY2Npc3Nfb3BlbihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90IG1v
ZGUpOw0KIHN0YXRpYyBpbnQgY2Npc3NfdW5sb2NrZWRfb3BlbihzdHJ1Y3QgYmxvY2tfZGV2aWNl
ICpiZGV2LCBmbW9kZV90IG1vZGUpOw0KIHN0YXRpYyBpbnQgY2Npc3NfcmVsZWFzZShzdHJ1Y3Qg
Z2VuZGlzayAqZGlzaywgZm1vZGVfdCBtb2RlKTsNCi1zdGF0aWMgaW50IGRvX2lvY3RsKHN0cnVj
dCBibG9ja19kZXZpY2UgKmJkZXYsIGZtb2RlX3QgbW9kZSwNCi0JCSAgICB1bnNpZ25lZCBpbnQg
Y21kLCB1bnNpZ25lZCBsb25nIGFyZyk7DQogc3RhdGljIGludCBjY2lzc19pb2N0bChzdHJ1Y3Qg
YmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsDQogCQkgICAgICAgdW5zaWduZWQgaW50
IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpOw0KIHN0YXRpYyBpbnQgY2Npc3NfZ2V0Z2VvKHN0cnVj
dCBibG9ja19kZXZpY2UgKmJkZXYsIHN0cnVjdCBoZF9nZW9tZXRyeSAqZ2VvKTsNCkBAIC0yMjks
NyArMjI3LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBibG9ja19kZXZpY2Vfb3BlcmF0aW9ucyBj
Y2lzc19mb3BzID0gew0KIAkub3duZXIgPSBUSElTX01PRFVMRSwNCiAJLm9wZW4gPSBjY2lzc191
bmxvY2tlZF9vcGVuLA0KIAkucmVsZWFzZSA9IGNjaXNzX3JlbGVhc2UsDQotCS5pb2N0bCA9IGRv
X2lvY3RsLA0KKwkuaW9jdGwgPSBjY2lzc19pb2N0bCwNCiAJLmdldGdlbyA9IGNjaXNzX2dldGdl
bywNCiAjaWZkZWYgQ09ORklHX0NPTVBBVA0KIAkuY29tcGF0X2lvY3RsID0gY2Npc3NfY29tcGF0
X2lvY3RsLA0KQEAgLTExNDAsMTYgKzExMzgsNiBAQCBzdGF0aWMgaW50IGNjaXNzX3JlbGVhc2Uo
c3RydWN0IGdlbmRpc2sgKmRpc2ssIGZtb2RlX3QgbW9kZSkNCiAJcmV0dXJuIDA7DQogfQ0KIA0K
LXN0YXRpYyBpbnQgZG9faW9jdGwoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgZm1vZGVfdCBt
b2RlLA0KLQkJICAgIHVuc2lnbmVkIGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpDQotew0KLQlpbnQg
cmV0Ow0KLQltdXRleF9sb2NrKCZjY2lzc19tdXRleCk7DQotCXJldCA9IGNjaXNzX2lvY3RsKGJk
ZXYsIG1vZGUsIGNtZCwgYXJnKTsNCi0JbXV0ZXhfdW5sb2NrKCZjY2lzc19tdXRleCk7DQotCXJl
dHVybiByZXQ7DQotfQ0KLQ0KICNpZmRlZiBDT05GSUdfQ09NUEFUDQogDQogc3RhdGljIGludCBj
Y2lzc19pb2N0bDMyX3Bhc3N0aHJ1KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGZtb2RlX3Qg
bW9kZSwNCkBAIC0xMTc2LDcgKzExNjQsNyBAQCBzdGF0aWMgaW50IGNjaXNzX2NvbXBhdF9pb2N0
bChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsDQogCWNhc2UgQ0NJU1Nf
UkVHTkVXRDoNCiAJY2FzZSBDQ0lTU19SRVNDQU5ESVNLOg0KIAljYXNlIENDSVNTX0dFVExVTklO
Rk86DQotCQlyZXR1cm4gZG9faW9jdGwoYmRldiwgbW9kZSwgY21kLCBhcmcpOw0KKwkJcmV0dXJu
IGNjaXNzX2lvY3RsKGJkZXYsIG1vZGUsIGNtZCwgYXJnKTsNCiANCiAJY2FzZSBDQ0lTU19QQVNT
VEhSVTMyOg0KIAkJcmV0dXJuIGNjaXNzX2lvY3RsMzJfcGFzc3RocnUoYmRldiwgbW9kZSwgY21k
LCBhcmcpOw0KQEAgLTEyMTYsNyArMTIwNCw3IEBAIHN0YXRpYyBpbnQgY2Npc3NfaW9jdGwzMl9w
YXNzdGhydShzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsDQogCWlmIChl
cnIpDQogCQlyZXR1cm4gLUVGQVVMVDsNCiANCi0JZXJyID0gZG9faW9jdGwoYmRldiwgbW9kZSwg
Q0NJU1NfUEFTU1RIUlUsICh1bnNpZ25lZCBsb25nKXApOw0KKwllcnIgPSBjY2lzc19pb2N0bChi
ZGV2LCBtb2RlLCBDQ0lTU19QQVNTVEhSVSwgKHVuc2lnbmVkIGxvbmcpcCk7DQogCWlmIChlcnIp
DQogCQlyZXR1cm4gZXJyOw0KIAllcnIgfD0NCkBAIC0xMjU4LDcgKzEyNDYsNyBAQCBzdGF0aWMg
aW50IGNjaXNzX2lvY3RsMzJfYmlnX3Bhc3N0aHJ1KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYs
IGZtb2RlX3QgbW9kZSwNCiAJaWYgKGVycikNCiAJCXJldHVybiAtRUZBVUxUOw0KIA0KLQllcnIg
PSBkb19pb2N0bChiZGV2LCBtb2RlLCBDQ0lTU19CSUdfUEFTU1RIUlUsICh1bnNpZ25lZCBsb25n
KXApOw0KKwllcnIgPSBjY2lzc19pb2N0bChiZGV2LCBtb2RlLCBDQ0lTU19CSUdfUEFTU1RIUlUs
ICh1bnNpZ25lZCBsb25nKXApOw0KIAlpZiAoZXJyKQ0KIAkJcmV0dXJuIGVycjsNCiAJZXJyIHw9
DQpAQCAtMTMwOCwxMSArMTI5NiwxNCBAQCBzdGF0aWMgaW50IGNjaXNzX2dldHBjaWluZm8oY3Rs
cl9pbmZvX3QgKmgsIHZvaWQgX191c2VyICphcmdwKQ0KIHN0YXRpYyBpbnQgY2Npc3NfZ2V0aW50
aW5mbyhjdGxyX2luZm9fdCAqaCwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogew0KIAljY2lzc19jb2Fs
aW50X3N0cnVjdCBpbnRpbmZvOw0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIA0KIAlpZiAoIWFy
Z3ApDQogCQlyZXR1cm4gLUVJTlZBTDsNCisJc3Bpbl9sb2NrX2lycXNhdmUoJmgtPmxvY2ssIGZs
YWdzKTsNCiAJaW50aW5mby5kZWxheSA9IHJlYWRsKCZoLT5jZmd0YWJsZS0+SG9zdFdyaXRlLkNv
YWxJbnREZWxheSk7DQogCWludGluZm8uY291bnQgPSByZWFkbCgmaC0+Y2ZndGFibGUtPkhvc3RX
cml0ZS5Db2FsSW50Q291bnQpOw0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoLT5sb2NrLCBm
bGFncyk7DQogCWlmIChjb3B5X3RvX3VzZXINCiAJICAgIChhcmdwLCAmaW50aW5mbywgc2l6ZW9m
KGNjaXNzX2NvYWxpbnRfc3RydWN0KSkpDQogCQlyZXR1cm4gLUVGQVVMVDsNCkBAIC0xMzUzLDEy
ICsxMzQ0LDE1IEBAIHN0YXRpYyBpbnQgY2Npc3Nfc2V0aW50aW5mbyhjdGxyX2luZm9fdCAqaCwg
dm9pZCBfX3VzZXIgKmFyZ3ApDQogc3RhdGljIGludCBjY2lzc19nZXRub2RlbmFtZShjdGxyX2lu
Zm9fdCAqaCwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogew0KIAlOb2RlTmFtZV90eXBlIE5vZGVOYW1l
Ow0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIAlpbnQgaTsNCiANCiAJaWYgKCFhcmdwKQ0KIAkJ
cmV0dXJuIC1FSU5WQUw7DQorCXNwaW5fbG9ja19pcnFzYXZlKCZoLT5sb2NrLCBmbGFncyk7DQog
CWZvciAoaSA9IDA7IGkgPCAxNjsgaSsrKQ0KIAkJTm9kZU5hbWVbaV0gPSByZWFkYigmaC0+Y2Zn
dGFibGUtPlNlcnZlck5hbWVbaV0pOw0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoLT5sb2Nr
LCBmbGFncyk7DQogCWlmIChjb3B5X3RvX3VzZXIoYXJncCwgTm9kZU5hbWUsIHNpemVvZihOb2Rl
TmFtZV90eXBlKSkpDQogCQlyZXR1cm4gLUVGQVVMVDsNCiAJcmV0dXJuIDA7DQpAQCAtMTM5NSwx
MCArMTM4OSwxMyBAQCBzdGF0aWMgaW50IGNjaXNzX3NldG5vZGVuYW1lKGN0bHJfaW5mb190ICpo
LCB2b2lkIF9fdXNlciAqYXJncCkNCiBzdGF0aWMgaW50IGNjaXNzX2dldGhlYXJ0YmVhdChjdGxy
X2luZm9fdCAqaCwgdm9pZCBfX3VzZXIgKmFyZ3ApDQogew0KIAlIZWFydGJlYXRfdHlwZSBoZWFy
dGJlYXQ7DQorCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQogCWlmICghYXJncCkNCiAJCXJldHVy
biAtRUlOVkFMOw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmaC0+bG9jaywgZmxhZ3MpOw0KIAloZWFy
dGJlYXQgPSByZWFkbCgmaC0+Y2ZndGFibGUtPkhlYXJ0QmVhdCk7DQorCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmgtPmxvY2ssIGZsYWdzKTsNCiAJaWYgKGNvcHlfdG9fdXNlcihhcmdwLCAmaGVh
cnRiZWF0LCBzaXplb2YoSGVhcnRiZWF0X3R5cGUpKSkNCiAJCXJldHVybiAtRUZBVUxUOw0KIAly
ZXR1cm4gMDsNCkBAIC0xNDA3LDEwICsxNDA0LDEzIEBAIHN0YXRpYyBpbnQgY2Npc3NfZ2V0aGVh
cnRiZWF0KGN0bHJfaW5mb190ICpoLCB2b2lkIF9fdXNlciAqYXJncCkNCiBzdGF0aWMgaW50IGNj
aXNzX2dldGJ1c3R5cGVzKGN0bHJfaW5mb190ICpoLCB2b2lkIF9fdXNlciAqYXJncCkNCiB7DQog
CUJ1c1R5cGVzX3R5cGUgQnVzVHlwZXM7DQorCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQogCWlm
ICghYXJncCkNCiAJCXJldHVybiAtRUlOVkFMOw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmaC0+bG9j
aywgZmxhZ3MpOw0KIAlCdXNUeXBlcyA9IHJlYWRsKCZoLT5jZmd0YWJsZS0+QnVzVHlwZXMpOw0K
KwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoLT5sb2NrLCBmbGFncyk7DQogCWlmIChjb3B5X3Rv
X3VzZXIoYXJncCwgJkJ1c1R5cGVzLCBzaXplb2YoQnVzVHlwZXNfdHlwZSkpKQ0KIAkJcmV0dXJu
IC1FRkFVTFQ7DQogCXJldHVybiAwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1f
aXJxLmMgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2lycS5jDQppbmRleCA0NGE1ZDBhLi43M2FmODg1
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9pcnEuYw0KKysrIGIvZHJpdmVycy9n
cHUvZHJtL2RybV9pcnEuYw0KQEAgLTk4MSw3ICs5ODEsNyBAQCBFWFBPUlRfU1lNQk9MKGRybV92
Ymxhbmtfb2ZmKTsNCiAgKi8NCiB2b2lkIGRybV92YmxhbmtfcHJlX21vZGVzZXQoc3RydWN0IGRy
bV9kZXZpY2UgKmRldiwgaW50IGNydGMpDQogew0KLQkvKiB2YmxhbmsgaXMgbm90IGluaXRpYWxp
emVkIChJUlEgbm90IGluc3RhbGxlZCA/KSAqLw0KKwkvKiB2YmxhbmsgaXMgbm90IGluaXRpYWxp
emVkIChJUlEgbm90IGluc3RhbGxlZCA/KSwgb3IgaGFzIGJlZW4gZnJlZWQgKi8NCiAJaWYgKCFk
ZXYtPm51bV9jcnRjcykNCiAJCXJldHVybjsNCiAJLyoNCkBAIC0xMDAzLDYgKzEwMDMsMTAgQEAg
dm9pZCBkcm1fdmJsYW5rX3Bvc3RfbW9kZXNldChzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LCBpbnQg
Y3J0YykNCiB7DQogCXVuc2lnbmVkIGxvbmcgaXJxZmxhZ3M7DQogDQorCS8qIHZibGFuayBpcyBu
b3QgaW5pdGlhbGl6ZWQgKElSUSBub3QgaW5zdGFsbGVkID8pLCBvciBoYXMgYmVlbiBmcmVlZCAq
Lw0KKwlpZiAoIWRldi0+bnVtX2NydGNzKQ0KKwkJcmV0dXJuOw0KKw0KIAlpZiAoZGV2LT52Ymxh
bmtfaW5tb2Rlc2V0W2NydGNdKSB7DQogCQlzcGluX2xvY2tfaXJxc2F2ZSgmZGV2LT52YmxfbG9j
aywgaXJxZmxhZ3MpOw0KIAkJZGV2LT52YmxhbmtfZGlzYWJsZV9hbGxvd2VkID0gMTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9sdmRzLmMgYi9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9pbnRlbF9sdmRzLmMNCmluZGV4IDg3NmJhYzAuLjJmZmE3NDAgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9sdmRzLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2ludGVsX2x2ZHMuYw0KQEAgLTc0MCwxMCArNzQwLDEwIEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgZG1pX3N5c3RlbV9pZCBpbnRlbF9ub19sdmRzW10gPSB7DQogCX0sDQogCXsNCiAJCS5j
YWxsYmFjayA9IGludGVsX25vX2x2ZHNfZG1pX2NhbGxiYWNrLA0KLQkJLmlkZW50ID0gIkhld2xl
dHQtUGFja2FyZCBIUCB0NTc0MGUgVGhpbiBDbGllbnQiLA0KKwkJLmlkZW50ID0gIkhld2xldHQt
UGFja2FyZCBIUCB0NTc0MCIsDQogCQkubWF0Y2hlcyA9IHsNCiAJCQlETUlfTUFUQ0goRE1JX0JP
QVJEX1ZFTkRPUiwgIkhld2xldHQtUGFja2FyZCIpLA0KLQkJCURNSV9NQVRDSChETUlfUFJPRFVD
VF9OQU1FLCAiSFAgdDU3NDBlIFRoaW4gQ2xpZW50IiksDQorCQkJRE1JX01BVENIKERNSV9QUk9E
VUNUX05BTUUsICIgdDU3NDAiKSwNCiAJCX0sDQogCX0sDQogCXsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9zZHZvLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRl
bF9zZHZvLmMNCmluZGV4IDllMjQ2NzAuLjAwZWMwZGQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pbnRlbF9zZHZvLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVs
X3Nkdm8uYw0KQEAgLTE1ODIsMTEgKzE1ODIsMTQgQEAgc3RhdGljIHZvaWQgaW50ZWxfc2R2b19n
ZXRfbHZkc19tb2RlcyhzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yKQ0KIAkgKiBBc3N1
bWUgdGhhdCB0aGUgcHJlZmVycmVkIG1vZGVzIGFyZQ0KIAkgKiBhcnJhbmdlZCBpbiBwcmlvcml0
eSBvcmRlci4NCiAJICovDQotCWludGVsX2RkY19nZXRfbW9kZXMoY29ubmVjdG9yLCBpbnRlbF9z
ZHZvLT5pMmMpOw0KLQlpZiAobGlzdF9lbXB0eSgmY29ubmVjdG9yLT5wcm9iZWRfbW9kZXMpID09
IGZhbHNlKQ0KLQkJZ290byBlbmQ7DQorCWludGVsX2RkY19nZXRfbW9kZXMoY29ubmVjdG9yLCAm
aW50ZWxfc2R2by0+ZGRjKTsNCiANCi0JLyogRmV0Y2ggbW9kZXMgZnJvbSBWQlQgKi8NCisJLyoN
CisJICogRmV0Y2ggbW9kZXMgZnJvbSBWQlQuIEZvciBTRFZPIHByZWZlciB0aGUgVkJUIG1vZGUg
c2luY2Ugc29tZQ0KKwkgKiBTRFZPLT5MVkRTIHRyYW5zY29kZXJzIGNhbid0IGNvcGUgd2l0aCB0
aGUgRURJRCBtb2RlLiBTaW5jZQ0KKwkgKiBkcm1fbW9kZV9wcm9iZWRfYWRkIGFkZHMgdGhlIG1v
ZGUgYXQgdGhlIGhlYWQgb2YgdGhlIGxpc3Qgd2UgYWRkIGl0DQorCSAqIGxhc3QuDQorCSAqLw0K
IAlpZiAoZGV2X3ByaXYtPnNkdm9fbHZkc192YnRfbW9kZSAhPSBOVUxMKSB7DQogCQluZXdtb2Rl
ID0gZHJtX21vZGVfZHVwbGljYXRlKGNvbm5lY3Rvci0+ZGV2LA0KIAkJCQkJICAgICBkZXZfcHJp
di0+c2R2b19sdmRzX3ZidF9tb2RlKTsNCkBAIC0xNTk4LDcgKzE2MDEsNiBAQCBzdGF0aWMgdm9p
ZCBpbnRlbF9zZHZvX2dldF9sdmRzX21vZGVzKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0
b3IpDQogCQl9DQogCX0NCiANCi1lbmQ6DQogCWxpc3RfZm9yX2VhY2hfZW50cnkobmV3bW9kZSwg
JmNvbm5lY3Rvci0+cHJvYmVkX21vZGVzLCBoZWFkKSB7DQogCQlpZiAobmV3bW9kZS0+dHlwZSAm
IERSTV9NT0RFX1RZUEVfUFJFRkVSUkVEKSB7DQogCQkJaW50ZWxfc2R2by0+c2R2b19sdmRzX2Zp
eGVkX21vZGUgPQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVu
LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jDQppbmRleCAwNDk1YTUwLi45
YmVhNGE2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYw0K
KysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYw0KQEAgLTMwODYsNiArMzA4
NiwxMiBAQCBzdGF0aWMgaW50IGV2ZXJncmVlbl9zdGFydHVwKHN0cnVjdCByYWRlb25fZGV2aWNl
ICpyZGV2KQ0KIAkJcmV0dXJuIHI7DQogDQogCS8qIEVuYWJsZSBJUlEgKi8NCisJaWYgKCFyZGV2
LT5pcnEuaW5zdGFsbGVkKSB7DQorCQlyID0gcmFkZW9uX2lycV9rbXNfaW5pdChyZGV2KTsNCisJ
CWlmIChyKQ0KKwkJCXJldHVybiByOw0KKwl9DQorDQogCXIgPSByNjAwX2lycV9pbml0KHJkZXYp
Ow0KIAlpZiAocikgew0KIAkJRFJNX0VSUk9SKCJyYWRlb246IElIIGluaXQgZmFpbGVkICglZCku
XG4iLCByKTsNCkBAIC0zMjE4LDEwICszMjI0LDYgQEAgaW50IGV2ZXJncmVlbl9pbml0KHN0cnVj
dCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAlpZiAocikNCiAJCXJldHVybiByOw0KIA0KLQlyID0g
cmFkZW9uX2lycV9rbXNfaW5pdChyZGV2KTsNCi0JaWYgKHIpDQotCQlyZXR1cm4gcjsNCi0NCiAJ
cmRldi0+Y3AucmluZ19vYmogPSBOVUxMOw0KIAlyNjAwX3JpbmdfaW5pdChyZGV2LCAxMDI0ICog
MTAyNCk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9uaS5jIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9uaS5jDQppbmRleCA2MzYyNTViLi4zZjk3MDViIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9uaS5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL25pLmMNCkBAIC0xMzg5LDYgKzEzODksMTIgQEAgc3RhdGljIGludCBjYXltYW5fc3Rh
cnR1cChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJCXJldHVybiByOw0KIA0KIAkvKiBF
bmFibGUgSVJRICovDQorCWlmICghcmRldi0+aXJxLmluc3RhbGxlZCkgew0KKwkJciA9IHJhZGVv
bl9pcnFfa21zX2luaXQocmRldik7DQorCQlpZiAocikNCisJCQlyZXR1cm4gcjsNCisJfQ0KKw0K
IAlyID0gcjYwMF9pcnFfaW5pdChyZGV2KTsNCiAJaWYgKHIpIHsNCiAJCURSTV9FUlJPUigicmFk
ZW9uOiBJSCBpbml0IGZhaWxlZCAoJWQpLlxuIiwgcik7DQpAQCAtMTUwNiwxMCArMTUxMiw2IEBA
IGludCBjYXltYW5faW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJaWYgKHIpDQog
CQlyZXR1cm4gcjsNCiANCi0JciA9IHJhZGVvbl9pcnFfa21zX2luaXQocmRldik7DQotCWlmIChy
KQ0KLQkJcmV0dXJuIHI7DQotDQogCXJkZXYtPmNwLnJpbmdfb2JqID0gTlVMTDsNCiAJcjYwMF9y
aW5nX2luaXQocmRldiwgMTAyNCAqIDEwMjQpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vcjEwMC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMTAwLmMNCmluZGV4
IGZhZDdjZDEuLjc2YzEyOTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3Ix
MDAuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMTAwLmMNCkBAIC0zOTA1LDYgKzM5
MDUsMTIgQEAgc3RhdGljIGludCByMTAwX3N0YXJ0dXAoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJk
ZXYpDQogCQlyZXR1cm4gcjsNCiANCiAJLyogRW5hYmxlIElSUSAqLw0KKwlpZiAoIXJkZXYtPmly
cS5pbnN0YWxsZWQpIHsNCisJCXIgPSByYWRlb25faXJxX2ttc19pbml0KHJkZXYpOw0KKwkJaWYg
KHIpDQorCQkJcmV0dXJuIHI7DQorCX0NCisNCiAJcjEwMF9pcnFfc2V0KHJkZXYpOw0KIAlyZGV2
LT5jb25maWcucjEwMC5oZHBfY250bCA9IFJSRUczMihSQURFT05fSE9TVF9QQVRIX0NOVEwpOw0K
IAkvKiAxTSByaW5nIGJ1ZmZlciAqLw0KQEAgLTQwNTAsOSArNDA1Niw2IEBAIGludCByMTAwX2lu
aXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQogCXIgPSByYWRlb25fZmVuY2VfZHJpdmVy
X2luaXQocmRldik7DQogCWlmIChyKQ0KIAkJcmV0dXJuIHI7DQotCXIgPSByYWRlb25faXJxX2tt
c19pbml0KHJkZXYpOw0KLQlpZiAocikNCi0JCXJldHVybiByOw0KIAkvKiBNZW1vcnkgbWFuYWdl
ciAqLw0KIAlyID0gcmFkZW9uX2JvX2luaXQocmRldik7DQogCWlmIChyKQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjMwMC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
MzAwLmMNCmluZGV4IGM5M2JjNjQuLjQ0MTU3MGIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL3IzMDAuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMzAwLmMNCkBA
IC0xMzk3LDYgKzEzOTcsMTIgQEAgc3RhdGljIGludCByMzAwX3N0YXJ0dXAoc3RydWN0IHJhZGVv
bl9kZXZpY2UgKnJkZXYpDQogCQlyZXR1cm4gcjsNCiANCiAJLyogRW5hYmxlIElSUSAqLw0KKwlp
ZiAoIXJkZXYtPmlycS5pbnN0YWxsZWQpIHsNCisJCXIgPSByYWRlb25faXJxX2ttc19pbml0KHJk
ZXYpOw0KKwkJaWYgKHIpDQorCQkJcmV0dXJuIHI7DQorCX0NCisNCiAJcjEwMF9pcnFfc2V0KHJk
ZXYpOw0KIAlyZGV2LT5jb25maWcucjMwMC5oZHBfY250bCA9IFJSRUczMihSQURFT05fSE9TVF9Q
QVRIX0NOVEwpOw0KIAkvKiAxTSByaW5nIGJ1ZmZlciAqLw0KQEAgLTE1MjEsOSArMTUyNyw2IEBA
IGludCByMzAwX2luaXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQogCXIgPSByYWRlb25f
ZmVuY2VfZHJpdmVyX2luaXQocmRldik7DQogCWlmIChyKQ0KIAkJcmV0dXJuIHI7DQotCXIgPSBy
YWRlb25faXJxX2ttc19pbml0KHJkZXYpOw0KLQlpZiAocikNCi0JCXJldHVybiByOw0KIAkvKiBN
ZW1vcnkgbWFuYWdlciAqLw0KIAlyID0gcmFkZW9uX2JvX2luaXQocmRldik7DQogCWlmIChyKQ0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjQyMC5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yNDIwLmMNCmluZGV4IDQxN2ZhYjguLjViMjE5YjggMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I0MjAuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yNDIwLmMNCkBAIC0yNTUsNiArMjU1LDEyIEBAIHN0YXRpYyBpbnQgcjQyMF9zdGFydHVwKHN0
cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAkJcmV0dXJuIHI7DQogDQogCS8qIEVuYWJsZSBJ
UlEgKi8NCisJaWYgKCFyZGV2LT5pcnEuaW5zdGFsbGVkKSB7DQorCQlyID0gcmFkZW9uX2lycV9r
bXNfaW5pdChyZGV2KTsNCisJCWlmIChyKQ0KKwkJCXJldHVybiByOw0KKwl9DQorDQogCXIxMDBf
aXJxX3NldChyZGV2KTsNCiAJcmRldi0+Y29uZmlnLnIzMDAuaGRwX2NudGwgPSBSUkVHMzIoUkFE
RU9OX0hPU1RfUEFUSF9DTlRMKTsNCiAJLyogMU0gcmluZyBidWZmZXIgKi8NCkBAIC0zOTEsMTAg
KzM5Nyw2IEBAIGludCByNDIwX2luaXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQogCWlm
IChyKSB7DQogCQlyZXR1cm4gcjsNCiAJfQ0KLQlyID0gcmFkZW9uX2lycV9rbXNfaW5pdChyZGV2
KTsNCi0JaWYgKHIpIHsNCi0JCXJldHVybiByOw0KLQl9DQogCS8qIE1lbW9yeSBtYW5hZ2VyICov
DQogCXIgPSByYWRlb25fYm9faW5pdChyZGV2KTsNCiAJaWYgKHIpIHsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I1MjAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUy
MC5jDQppbmRleCAzMDgxZDA3Li5mMzZhNWM5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9yNTIwLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUyMC5jDQpAQCAt
MTg4LDYgKzE4OCwxMiBAQCBzdGF0aWMgaW50IHI1MjBfc3RhcnR1cChzdHJ1Y3QgcmFkZW9uX2Rl
dmljZSAqcmRldikNCiAJCXJldHVybiByOw0KIA0KIAkvKiBFbmFibGUgSVJRICovDQorCWlmICgh
cmRldi0+aXJxLmluc3RhbGxlZCkgew0KKwkJciA9IHJhZGVvbl9pcnFfa21zX2luaXQocmRldik7
DQorCQlpZiAocikNCisJCQlyZXR1cm4gcjsNCisJfQ0KKw0KIAlyczYwMF9pcnFfc2V0KHJkZXYp
Ow0KIAlyZGV2LT5jb25maWcucjMwMC5oZHBfY250bCA9IFJSRUczMihSQURFT05fSE9TVF9QQVRI
X0NOVEwpOw0KIAkvKiAxTSByaW5nIGJ1ZmZlciAqLw0KQEAgLTI4MSw5ICsyODcsNiBAQCBpbnQg
cjUyMF9pbml0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAlyID0gcmFkZW9uX2ZlbmNl
X2RyaXZlcl9pbml0KHJkZXYpOw0KIAlpZiAocikNCiAJCXJldHVybiByOw0KLQlyID0gcmFkZW9u
X2lycV9rbXNfaW5pdChyZGV2KTsNCi0JaWYgKHIpDQotCQlyZXR1cm4gcjsNCiAJLyogTWVtb3J5
IG1hbmFnZXIgKi8NCiAJciA9IHJhZGVvbl9ib19pbml0KHJkZXYpOw0KIAlpZiAocikNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyBiL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vcjYwMC5jDQppbmRleCBiZGZhODJhLi4zZDQ2ZDdkNCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2
MDAuYw0KQEAgLTI0NDksNiArMjQ0OSwxMiBAQCBpbnQgcjYwMF9zdGFydHVwKHN0cnVjdCByYWRl
b25fZGV2aWNlICpyZGV2KQ0KIAkJcmV0dXJuIHI7DQogDQogCS8qIEVuYWJsZSBJUlEgKi8NCisJ
aWYgKCFyZGV2LT5pcnEuaW5zdGFsbGVkKSB7DQorCQlyID0gcmFkZW9uX2lycV9rbXNfaW5pdChy
ZGV2KTsNCisJCWlmIChyKQ0KKwkJCXJldHVybiByOw0KKwl9DQorDQogCXIgPSByNjAwX2lycV9p
bml0KHJkZXYpOw0KIAlpZiAocikgew0KIAkJRFJNX0VSUk9SKCJyYWRlb246IElIIGluaXQgZmFp
bGVkICglZCkuXG4iLCByKTsNCkBAIC0yNTkyLDEwICsyNTk4LDYgQEAgaW50IHI2MDBfaW5pdChz
dHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJaWYgKHIpDQogCQlyZXR1cm4gcjsNCiANCi0J
ciA9IHJhZGVvbl9pcnFfa21zX2luaXQocmRldik7DQotCWlmIChyKQ0KLQkJcmV0dXJuIHI7DQot
DQogCXJkZXYtPmNwLnJpbmdfb2JqID0gTlVMTDsNCiAJcjYwMF9yaW5nX2luaXQocmRldiwgMTAy
NCAqIDEwMjQpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9u
X2RldmljZS5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZGV2aWNlLmMNCmluZGV4
IGJkOTU5YzEuLmNkOTRhYmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3Jh
ZGVvbl9kZXZpY2UuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZGV2aWNl
LmMNCkBAIC0zNTksMTggKzM1OSwxNyBAQCBib29sIHJhZGVvbl9jYXJkX3Bvc3RlZChzdHJ1Y3Qg
cmFkZW9uX2RldmljZSAqcmRldikNCiAJCXJldHVybiBmYWxzZTsNCiANCiAJLyogZmlyc3QgY2hl
Y2sgQ1JUQ3MgKi8NCi0JaWYgKEFTSUNfSVNfRENFNDEocmRldikpIHsNCisJaWYgKEFTSUNfSVNf
RENFNChyZGV2KSkgew0KIAkJcmVnID0gUlJFRzMyKEVWRVJHUkVFTl9DUlRDX0NPTlRST0wgKyBF
VkVSR1JFRU5fQ1JUQzBfUkVHSVNURVJfT0ZGU0VUKSB8DQogCQkJUlJFRzMyKEVWRVJHUkVFTl9D
UlRDX0NPTlRST0wgKyBFVkVSR1JFRU5fQ1JUQzFfUkVHSVNURVJfT0ZGU0VUKTsNCi0JCWlmIChy
ZWcgJiBFVkVSR1JFRU5fQ1JUQ19NQVNURVJfRU4pDQotCQkJcmV0dXJuIHRydWU7DQotCX0gZWxz
ZSBpZiAoQVNJQ19JU19EQ0U0KHJkZXYpKSB7DQotCQlyZWcgPSBSUkVHMzIoRVZFUkdSRUVOX0NS
VENfQ09OVFJPTCArIEVWRVJHUkVFTl9DUlRDMF9SRUdJU1RFUl9PRkZTRVQpIHwNCi0JCQlSUkVH
MzIoRVZFUkdSRUVOX0NSVENfQ09OVFJPTCArIEVWRVJHUkVFTl9DUlRDMV9SRUdJU1RFUl9PRkZT
RVQpIHwNCi0JCQlSUkVHMzIoRVZFUkdSRUVOX0NSVENfQ09OVFJPTCArIEVWRVJHUkVFTl9DUlRD
Ml9SRUdJU1RFUl9PRkZTRVQpIHwNCi0JCQlSUkVHMzIoRVZFUkdSRUVOX0NSVENfQ09OVFJPTCAr
IEVWRVJHUkVFTl9DUlRDM19SRUdJU1RFUl9PRkZTRVQpIHwNCi0JCQlSUkVHMzIoRVZFUkdSRUVO
X0NSVENfQ09OVFJPTCArIEVWRVJHUkVFTl9DUlRDNF9SRUdJU1RFUl9PRkZTRVQpIHwNCi0JCQlS
UkVHMzIoRVZFUkdSRUVOX0NSVENfQ09OVFJPTCArIEVWRVJHUkVFTl9DUlRDNV9SRUdJU1RFUl9P
RkZTRVQpOw0KKwkJCWlmIChyZGV2LT5udW1fY3J0YyA+PSA0KSB7DQorCQkJCXJlZyB8PSBSUkVH
MzIoRVZFUkdSRUVOX0NSVENfQ09OVFJPTCArIEVWRVJHUkVFTl9DUlRDMl9SRUdJU1RFUl9PRkZT
RVQpIHwNCisJCQkJCVJSRUczMihFVkVSR1JFRU5fQ1JUQ19DT05UUk9MICsgRVZFUkdSRUVOX0NS
VEMzX1JFR0lTVEVSX09GRlNFVCk7DQorCQkJfQ0KKwkJCWlmIChyZGV2LT5udW1fY3J0YyA+PSA2
KSB7DQorCQkJCXJlZyB8PSBSUkVHMzIoRVZFUkdSRUVOX0NSVENfQ09OVFJPTCArIEVWRVJHUkVF
Tl9DUlRDNF9SRUdJU1RFUl9PRkZTRVQpIHwNCisJCQkJCVJSRUczMihFVkVSR1JFRU5fQ1JUQ19D
T05UUk9MICsgRVZFUkdSRUVOX0NSVEM1X1JFR0lTVEVSX09GRlNFVCk7DQorCQkJfQ0KIAkJaWYg
KHJlZyAmIEVWRVJHUkVFTl9DUlRDX01BU1RFUl9FTikNCiAJCQlyZXR1cm4gdHJ1ZTsNCiAJfSBl
bHNlIGlmIChBU0lDX0lTX0FWSVZPKHJkZXYpKSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yczQwMC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczQwMC5jDQppbmRl
eCAwNmI5MGM4Li40ZGQ5NTEyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
czQwMC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNDAwLmMNCkBAIC00MTEsNiAr
NDExLDEyIEBAIHN0YXRpYyBpbnQgcnM0MDBfc3RhcnR1cChzdHJ1Y3QgcmFkZW9uX2RldmljZSAq
cmRldikNCiAJCXJldHVybiByOw0KIA0KIAkvKiBFbmFibGUgSVJRICovDQorCWlmICghcmRldi0+
aXJxLmluc3RhbGxlZCkgew0KKwkJciA9IHJhZGVvbl9pcnFfa21zX2luaXQocmRldik7DQorCQlp
ZiAocikNCisJCQlyZXR1cm4gcjsNCisJfQ0KKw0KIAlyMTAwX2lycV9zZXQocmRldik7DQogCXJk
ZXYtPmNvbmZpZy5yMzAwLmhkcF9jbnRsID0gUlJFRzMyKFJBREVPTl9IT1NUX1BBVEhfQ05UTCk7
DQogCS8qIDFNIHJpbmcgYnVmZmVyICovDQpAQCAtNTE5LDkgKzUyNSw2IEBAIGludCByczQwMF9p
bml0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAlyID0gcmFkZW9uX2ZlbmNlX2RyaXZl
cl9pbml0KHJkZXYpOw0KIAlpZiAocikNCiAJCXJldHVybiByOw0KLQlyID0gcmFkZW9uX2lycV9r
bXNfaW5pdChyZGV2KTsNCi0JaWYgKHIpDQotCQlyZXR1cm4gcjsNCiAJLyogTWVtb3J5IG1hbmFn
ZXIgKi8NCiAJciA9IHJhZGVvbl9ib19pbml0KHJkZXYpOw0KIAlpZiAocikNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjAwLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JzNjAwLmMNCmluZGV4IGVlODk4ZTkuLmNlYTQ4MmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JzNjAwLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2MDAu
Yw0KQEAgLTg0OCw2ICs4NDgsMTIgQEAgc3RhdGljIGludCByczYwMF9zdGFydHVwKHN0cnVjdCBy
YWRlb25fZGV2aWNlICpyZGV2KQ0KIAkJcmV0dXJuIHI7DQogDQogCS8qIEVuYWJsZSBJUlEgKi8N
CisJaWYgKCFyZGV2LT5pcnEuaW5zdGFsbGVkKSB7DQorCQlyID0gcmFkZW9uX2lycV9rbXNfaW5p
dChyZGV2KTsNCisJCWlmIChyKQ0KKwkJCXJldHVybiByOw0KKwl9DQorDQogCXJzNjAwX2lycV9z
ZXQocmRldik7DQogCXJkZXYtPmNvbmZpZy5yMzAwLmhkcF9jbnRsID0gUlJFRzMyKFJBREVPTl9I
T1NUX1BBVEhfQ05UTCk7DQogCS8qIDFNIHJpbmcgYnVmZmVyICovDQpAQCAtOTYzLDkgKzk2OSw2
IEBAIGludCByczYwMF9pbml0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAlyID0gcmFk
ZW9uX2ZlbmNlX2RyaXZlcl9pbml0KHJkZXYpOw0KIAlpZiAocikNCiAJCXJldHVybiByOw0KLQly
ID0gcmFkZW9uX2lycV9rbXNfaW5pdChyZGV2KTsNCi0JaWYgKHIpDQotCQlyZXR1cm4gcjsNCiAJ
LyogTWVtb3J5IG1hbmFnZXIgKi8NCiAJciA9IHJhZGVvbl9ib19pbml0KHJkZXYpOw0KIAlpZiAo
cikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjkwLmMgYi9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3JzNjkwLmMNCmluZGV4IGE5MDQ5ZWQuLjkzYmNlNzIgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjkwLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcnM2OTAuYw0KQEAgLTYyMiw2ICs2MjIsMTIgQEAgc3RhdGljIGludCByczY5MF9z
dGFydHVwKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAkJcmV0dXJuIHI7DQogDQogCS8q
IEVuYWJsZSBJUlEgKi8NCisJaWYgKCFyZGV2LT5pcnEuaW5zdGFsbGVkKSB7DQorCQlyID0gcmFk
ZW9uX2lycV9rbXNfaW5pdChyZGV2KTsNCisJCWlmIChyKQ0KKwkJCXJldHVybiByOw0KKwl9DQor
DQogCXJzNjAwX2lycV9zZXQocmRldik7DQogCXJkZXYtPmNvbmZpZy5yMzAwLmhkcF9jbnRsID0g
UlJFRzMyKFJBREVPTl9IT1NUX1BBVEhfQ05UTCk7DQogCS8qIDFNIHJpbmcgYnVmZmVyICovDQpA
QCAtNzM4LDkgKzc0NCw2IEBAIGludCByczY5MF9pbml0KHN0cnVjdCByYWRlb25fZGV2aWNlICpy
ZGV2KQ0KIAlyID0gcmFkZW9uX2ZlbmNlX2RyaXZlcl9pbml0KHJkZXYpOw0KIAlpZiAocikNCiAJ
CXJldHVybiByOw0KLQlyID0gcmFkZW9uX2lycV9rbXNfaW5pdChyZGV2KTsNCi0JaWYgKHIpDQot
CQlyZXR1cm4gcjsNCiAJLyogTWVtb3J5IG1hbmFnZXIgKi8NCiAJciA9IHJhZGVvbl9ib19pbml0
KHJkZXYpOw0KIAlpZiAocikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2
NTE1LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NTE1LmMNCmluZGV4IGQ1ZjQ1YjQuLjkx
MDM2MzggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NTE1LmMNCisrKyBi
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnY1MTUuYw0KQEAgLTM4MCw2ICszODAsMTIgQEAgc3Rh
dGljIGludCBydjUxNV9zdGFydHVwKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAkJcmV0
dXJuIHI7DQogDQogCS8qIEVuYWJsZSBJUlEgKi8NCisJaWYgKCFyZGV2LT5pcnEuaW5zdGFsbGVk
KSB7DQorCQlyID0gcmFkZW9uX2lycV9rbXNfaW5pdChyZGV2KTsNCisJCWlmIChyKQ0KKwkJCXJl
dHVybiByOw0KKwl9DQorDQogCXJzNjAwX2lycV9zZXQocmRldik7DQogCXJkZXYtPmNvbmZpZy5y
MzAwLmhkcF9jbnRsID0gUlJFRzMyKFJBREVPTl9IT1NUX1BBVEhfQ05UTCk7DQogCS8qIDFNIHJp
bmcgYnVmZmVyICovDQpAQCAtNTAwLDkgKzUwNiw2IEBAIGludCBydjUxNV9pbml0KHN0cnVjdCBy
YWRlb25fZGV2aWNlICpyZGV2KQ0KIAlyID0gcmFkZW9uX2ZlbmNlX2RyaXZlcl9pbml0KHJkZXYp
Ow0KIAlpZiAocikNCiAJCXJldHVybiByOw0KLQlyID0gcmFkZW9uX2lycV9rbXNfaW5pdChyZGV2
KTsNCi0JaWYgKHIpDQotCQlyZXR1cm4gcjsNCiAJLyogTWVtb3J5IG1hbmFnZXIgKi8NCiAJciA9
IHJhZGVvbl9ib19pbml0KHJkZXYpOw0KIAlpZiAocikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3J2NzcwLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NzcwLmMNCmlu
ZGV4IGNjNzk0NDkuLjYzZGI3NWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3J2NzcwLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnY3NzAuYw0KQEAgLTEwOTIs
NiArMTA5MiwxMiBAQCBzdGF0aWMgaW50IHJ2NzcwX3N0YXJ0dXAoc3RydWN0IHJhZGVvbl9kZXZp
Y2UgKnJkZXYpDQogCQlyZXR1cm4gcjsNCiANCiAJLyogRW5hYmxlIElSUSAqLw0KKwlpZiAoIXJk
ZXYtPmlycS5pbnN0YWxsZWQpIHsNCisJCXIgPSByYWRlb25faXJxX2ttc19pbml0KHJkZXYpOw0K
KwkJaWYgKHIpDQorCQkJcmV0dXJuIHI7DQorCX0NCisNCiAJciA9IHI2MDBfaXJxX2luaXQocmRl
dik7DQogCWlmIChyKSB7DQogCQlEUk1fRVJST1IoInJhZGVvbjogSUggaW5pdCBmYWlsZWQgKCVk
KS5cbiIsIHIpOw0KQEAgLTEyMjAsMTAgKzEyMjYsNiBAQCBpbnQgcnY3NzBfaW5pdChzdHJ1Y3Qg
cmFkZW9uX2RldmljZSAqcmRldikNCiAJaWYgKHIpDQogCQlyZXR1cm4gcjsNCiANCi0JciA9IHJh
ZGVvbl9pcnFfa21zX2luaXQocmRldik7DQotCWlmIChyKQ0KLQkJcmV0dXJuIHI7DQotDQogCXJk
ZXYtPmNwLnJpbmdfb2JqID0gTlVMTDsNCiAJcjYwMF9yaW5nX2luaXQocmRldiwgMTAyNCAqIDEw
MjQpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vYWRtMTAyMS5jIGIvZHJpdmVycy9o
d21vbi9hZG0xMDIxLmMNCmluZGV4IDFhZDBhODguLjgxNzg5MjcgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2h3bW9uL2FkbTEwMjEuYw0KKysrIGIvZHJpdmVycy9od21vbi9hZG0xMDIxLmMNCkBAIC0z
MTEsMjYgKzMxMSw2OCBAQCBzdGF0aWMgaW50IGFkbTEwMjFfZGV0ZWN0KHN0cnVjdCBpMmNfY2xp
ZW50ICpjbGllbnQsDQogCW1hbl9pZCA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQs
IEFETTEwMjFfUkVHX01BTl9JRCk7DQogCWRldl9pZCA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0
YShjbGllbnQsIEFETTEwMjFfUkVHX0RFVl9JRCk7DQogDQorCWlmIChtYW5faWQgPCAwIHx8IGRl
dl9pZCA8IDApDQorCQlyZXR1cm4gLUVOT0RFVjsNCisNCiAJaWYgKG1hbl9pZCA9PSAweDRkICYm
IGRldl9pZCA9PSAweDAxKQ0KIAkJdHlwZV9uYW1lID0gIm1heDE2MTdhIjsNCiAJZWxzZSBpZiAo
bWFuX2lkID09IDB4NDEpIHsNCiAJCWlmICgoZGV2X2lkICYgMHhGMCkgPT0gMHgzMCkNCiAJCQl0
eXBlX25hbWUgPSAiYWRtMTAyMyI7DQotCQllbHNlDQorCQllbHNlIGlmICgoZGV2X2lkICYgMHhG
MCkgPT0gMHgwMCkNCiAJCQl0eXBlX25hbWUgPSAiYWRtMTAyMSI7DQorCQllbHNlDQorCQkJcmV0
dXJuIC1FTk9ERVY7DQogCX0gZWxzZSBpZiAobWFuX2lkID09IDB4NDkpDQogCQl0eXBlX25hbWUg
PSAidGhtYzEwIjsNCiAJZWxzZSBpZiAobWFuX2lkID09IDB4MjMpDQogCQl0eXBlX25hbWUgPSAi
Z2w1MjNzbSI7DQogCWVsc2UgaWYgKG1hbl9pZCA9PSAweDU0KQ0KIAkJdHlwZV9uYW1lID0gIm1j
MTA2NiI7DQotCS8qIExNODQgTWZyIElEIGluIGEgZGlmZmVyZW50IHBsYWNlLCBhbmQgaXQgaGFz
IG1vcmUgdW51c2VkIGJpdHMgKi8NCi0JZWxzZSBpZiAoY29udl9yYXRlID09IDB4MDANCi0JCSAm
JiAoY29uZmlnICYgMHg3RikgPT0gMHgwMA0KLQkJICYmIChzdGF0dXMgJiAweEFCKSA9PSAweDAw
KQ0KLQkJdHlwZV9uYW1lID0gImxtODQiOw0KLQllbHNlDQotCQl0eXBlX25hbWUgPSAibWF4MTYx
NyI7DQorCWVsc2Ugew0KKwkJaW50IGx0ZSwgcnRlLCBsaGksIHJoaSwgbGxvLCBybG87DQorDQor
CQkvKiBleHRyYSBjaGVja3MgZm9yIExNODQgYW5kIE1BWDE2MTcgdG8gYXZvaWQgbWlzZGV0ZWN0
aW9ucyAqLw0KKw0KKwkJbGxvID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwgQURN
MTAyMV9SRUdfVEhZU1RfUigwKSk7DQorCQlybG8gPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEo
Y2xpZW50LCBBRE0xMDIxX1JFR19USFlTVF9SKDEpKTsNCisNCisJCS8qIGZhaWwgaWYgYW55IG9m
IHRoZSBhZGRpdGlvbmFsIHJlZ2lzdGVyIHJlYWRzIGZhaWxlZCAqLw0KKwkJaWYgKGxsbyA8IDAg
fHwgcmxvIDwgMCkNCisJCQlyZXR1cm4gLUVOT0RFVjsNCisNCisJCWx0ZSA9IGkyY19zbWJ1c19y
ZWFkX2J5dGVfZGF0YShjbGllbnQsIEFETTEwMjFfUkVHX1RFTVAoMCkpOw0KKwkJcnRlID0gaTJj
X3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwgQURNMTAyMV9SRUdfVEVNUCgxKSk7DQorCQls
aGkgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LCBBRE0xMDIxX1JFR19UT1NfUigw
KSk7DQorCQlyaGkgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LCBBRE0xMDIxX1JF
R19UT1NfUigxKSk7DQorDQorCQkvKg0KKwkJICogRmFpbCBmb3IgbmVnYXRpdmUgdGVtcGVyYXR1
cmVzIGFuZCBuZWdhdGl2ZSBoaWdoIGxpbWl0cy4NCisJCSAqIFRoaXMgY2hlY2sgYWxzbyBjYXRj
aGVzIHJlYWQgZXJyb3JzIG9uIHRoZSB0ZXN0ZWQgcmVnaXN0ZXJzLg0KKwkJICovDQorCQlpZiAo
KHM4KWx0ZSA8IDAgfHwgKHM4KXJ0ZSA8IDAgfHwgKHM4KWxoaSA8IDAgfHwgKHM4KXJoaSA8IDAp
DQorCQkJcmV0dXJuIC1FTk9ERVY7DQorDQorCQkvKiBmYWlsIGlmIGFsbCByZWdpc3RlcnMgaG9s
ZCB0aGUgc2FtZSB2YWx1ZSAqLw0KKwkJaWYgKGx0ZSA9PSBydGUgJiYgbHRlID09IGxoaSAmJiBs
dGUgPT0gcmhpICYmIGx0ZSA9PSBsbG8NCisJCSAgICAmJiBsdGUgPT0gcmxvKQ0KKwkJCXJldHVy
biAtRU5PREVWOw0KKw0KKwkJLyoNCisJCSAqIExNODQgTWZyIElEIGlzIGluIGEgZGlmZmVyZW50
IHBsYWNlLA0KKwkJICogYW5kIGl0IGhhcyBtb3JlIHVudXNlZCBiaXRzLg0KKwkJICovDQorCQlp
ZiAoY29udl9yYXRlID09IDB4MDANCisJCSAgICAmJiAoY29uZmlnICYgMHg3RikgPT0gMHgwMA0K
KwkJICAgICYmIChzdGF0dXMgJiAweEFCKSA9PSAweDAwKSB7DQorCQkJdHlwZV9uYW1lID0gImxt
ODQiOw0KKwkJfSBlbHNlIHsNCisJCQkvKiBmYWlsIGlmIGxvdyBsaW1pdHMgYXJlIGxhcmdlciB0
aGFuIGhpZ2ggbGltaXRzICovDQorCQkJaWYgKChzOClsbG8gPiBsaGkgfHwgKHM4KXJsbyA+IHJo
aSkNCisJCQkJcmV0dXJuIC1FTk9ERVY7DQorCQkJdHlwZV9uYW1lID0gIm1heDE2MTciOw0KKwkJ
fQ0KKwl9DQogDQogCXByX2RlYnVnKCJhZG0xMDIxOiBEZXRlY3RlZCBjaGlwICVzIGF0IGFkYXB0
ZXIgJWQsIGFkZHJlc3MgMHglMDJ4LlxuIiwNCiAJCSB0eXBlX25hbWUsIGkyY19hZGFwdGVyX2lk
KGFkYXB0ZXIpLCBjbGllbnQtPmFkZHIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEu
YyBiL2RyaXZlcnMvbWQvcmFpZDEuYw0KaW5kZXggNjIzMDZlNS4uMjk4ZTAyYSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbWQvcmFpZDEuYw0KKysrIGIvZHJpdmVycy9tZC9yYWlkMS5jDQpAQCAtNDA3
LDcgKzQwNywxNyBAQCBzdGF0aWMgdm9pZCByYWlkMV9lbmRfd3JpdGVfcmVxdWVzdChzdHJ1Y3Qg
YmlvICpiaW8sIGludCBlcnJvcikNCiANCiAJCXIxX2Jpby0+Ymlvc1ttaXJyb3JdID0gTlVMTDsN
CiAJCXRvX3B1dCA9IGJpbzsNCi0JCXNldF9iaXQoUjFCSU9fVXB0b2RhdGUsICZyMV9iaW8tPnN0
YXRlKTsNCisJCS8qDQorCQkgKiBEbyBub3Qgc2V0IFIxQklPX1VwdG9kYXRlIGlmIHRoZSBjdXJy
ZW50IGRldmljZSBpcw0KKwkJICogcmVidWlsZGluZyBvciBGYXVsdHkuIFRoaXMgaXMgYmVjYXVz
ZSB3ZSBjYW5ub3QgdXNlDQorCQkgKiBzdWNoIGRldmljZSBmb3IgcHJvcGVybHkgcmVhZGluZyB0
aGUgZGF0YSBiYWNrICh3ZSBjb3VsZA0KKwkJICogcG90ZW50aWFsbHkgdXNlIGl0LCBpZiB0aGUg
Y3VycmVudCB3cml0ZSB3b3VsZCBoYXZlIGZlbHQNCisJCSAqIGJlZm9yZSByZGV2LT5yZWNvdmVy
eV9vZmZzZXQsIGJ1dCBmb3Igc2ltcGxpY2l0eSB3ZSBkb24ndA0KKwkJICogY2hlY2sgdGhpcyBo
ZXJlLg0KKwkJICovDQorCQlpZiAodGVzdF9iaXQoSW5fc3luYywgJmNvbmYtPm1pcnJvcnNbbWly
cm9yXS5yZGV2LT5mbGFncykgJiYNCisJCSAgICAhdGVzdF9iaXQoRmF1bHR5LCAmY29uZi0+bWly
cm9yc1ttaXJyb3JdLnJkZXYtPmZsYWdzKSkNCisJCQlzZXRfYml0KFIxQklPX1VwdG9kYXRlLCAm
cjFfYmlvLT5zdGF0ZSk7DQogDQogCQkvKiBNYXliZSB3ZSBjYW4gY2xlYXIgc29tZSBiYWQgYmxv
Y2tzLiAqLw0KIAkJaWYgKGlzX2JhZGJsb2NrKGNvbmYtPm1pcnJvcnNbbWlycm9yXS5yZGV2LA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEwLmMgYi9kcml2ZXJzL21kL3JhaWQxMC5jDQpp
bmRleCA4ZjY3YzRkLi44YmJhNDM4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9yYWlkMTAuYw0K
KysrIGIvZHJpdmVycy9tZC9yYWlkMTAuYw0KQEAgLTM5MCw3ICszOTAsMTcgQEAgc3RhdGljIHZv
aWQgcmFpZDEwX2VuZF93cml0ZV9yZXF1ZXN0KHN0cnVjdCBiaW8gKmJpbywgaW50IGVycm9yKQ0K
IAkJc2VjdG9yX3QgZmlyc3RfYmFkOw0KIAkJaW50IGJhZF9zZWN0b3JzOw0KIA0KLQkJc2V0X2Jp
dChSMTBCSU9fVXB0b2RhdGUsICZyMTBfYmlvLT5zdGF0ZSk7DQorCQkvKg0KKwkJICogRG8gbm90
IHNldCBSMTBCSU9fVXB0b2RhdGUgaWYgdGhlIGN1cnJlbnQgZGV2aWNlIGlzDQorCQkgKiByZWJ1
aWxkaW5nIG9yIEZhdWx0eS4gVGhpcyBpcyBiZWNhdXNlIHdlIGNhbm5vdCB1c2UNCisJCSAqIHN1
Y2ggZGV2aWNlIGZvciBwcm9wZXJseSByZWFkaW5nIHRoZSBkYXRhIGJhY2sgKHdlIGNvdWxkDQor
CQkgKiBwb3RlbnRpYWxseSB1c2UgaXQsIGlmIHRoZSBjdXJyZW50IHdyaXRlIHdvdWxkIGhhdmUg
ZmVsdA0KKwkJICogYmVmb3JlIHJkZXYtPnJlY292ZXJ5X29mZnNldCwgYnV0IGZvciBzaW1wbGlj
aXR5IHdlIGRvbid0DQorCQkgKiBjaGVjayB0aGlzIGhlcmUuDQorCQkgKi8NCisJCWlmICh0ZXN0
X2JpdChJbl9zeW5jLCAmY29uZi0+bWlycm9yc1tkZXZdLnJkZXYtPmZsYWdzKSAmJg0KKwkJICAg
ICF0ZXN0X2JpdChGYXVsdHksICZjb25mLT5taXJyb3JzW2Rldl0ucmRldi0+ZmxhZ3MpKQ0KKwkJ
CXNldF9iaXQoUjEwQklPX1VwdG9kYXRlLCAmcjEwX2Jpby0+c3RhdGUpOw0KIA0KIAkJLyogTWF5
YmUgd2UgY2FuIGNsZWFyIHNvbWUgYmFkIGJsb2Nrcy4gKi8NCiAJCWlmIChpc19iYWRibG9jayhj
b25mLT5taXJyb3JzW2Rldl0ucmRldiwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9icm9hZGNvbS90ZzMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jDQpp
bmRleCBlYzEzYTU5Li4xYmM5MjdhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
YnJvYWRjb20vdGczLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5j
DQpAQCAtMTYyMCw2ICsxNjIwLDkgQEAgc3RhdGljIGludCB0ZzNfcG9sbF9mdyhzdHJ1Y3QgdGcz
ICp0cCkNCiAJaW50IGk7DQogCXUzMiB2YWw7DQogDQorCWlmICh0ZzNfZmxhZyh0cCwgTk9fRldB
UkVfUkVQT1JURUQpKQ0KKwkJcmV0dXJuIDA7DQorDQogCWlmIChHRVRfQVNJQ19SRVYodHAtPnBj
aV9jaGlwX3Jldl9pZCkgPT0gQVNJQ19SRVZfNTkwNikgew0KIAkJLyogV2FpdCB1cCB0byAyMG1z
IGZvciBpbml0IGRvbmUuICovDQogCQlmb3IgKGkgPSAwOyBpIDwgMjAwOyBpKyspIHsNCkBAIC04
MjgyLDYgKzgyODUsMTQgQEAgc3RhdGljIHZvaWQgdGczX3NldHVwX3J4YmRfdGhyZXNob2xkcyhz
dHJ1Y3QgdGczICp0cCkNCiAJCXR3MzIoSk1CX1JFUExFTklTSF9MV00sIGJkY2FjaGVfbWF4Y250
KTsNCiB9DQogDQorc3RhdGljIGlubGluZSB1MzIgdGczX2xzb19yZF9kbWFfd29ya2Fyb3VuZF9i
aXQoc3RydWN0IHRnMyAqdHApDQorew0KKwlpZiAoR0VUX0FTSUNfUkVWKHRwLT5wY2lfY2hpcF9y
ZXZfaWQpID09IEFTSUNfUkVWXzU3MTkpDQorCQlyZXR1cm4gVEczX0xTT19SRF9ETUFfVFhfTEVO
R1RIX1dBXzU3MTk7DQorCWVsc2UNCisJCXJldHVybiBURzNfTFNPX1JEX0RNQV9UWF9MRU5HVEhf
V0FfNTcyMDsNCit9DQorDQogLyogdHAtPmxvY2sgaXMgaGVsZC4gKi8NCiBzdGF0aWMgaW50IHRn
M19yZXNldF9odyhzdHJ1Y3QgdGczICp0cCwgaW50IHJlc2V0X3BoeSkNCiB7DQpAQCAtODkyMCw2
ICs4OTMxLDIwIEBAIHN0YXRpYyBpbnQgdGczX3Jlc2V0X2h3KHN0cnVjdCB0ZzMgKnRwLCBpbnQg
cmVzZXRfcGh5KQ0KIAl0dzMyX2YoUkRNQUNfTU9ERSwgcmRtYWNfbW9kZSk7DQogCXVkZWxheSg0
MCk7DQogDQorCWlmIChHRVRfQVNJQ19SRVYodHAtPnBjaV9jaGlwX3Jldl9pZCkgPT0gQVNJQ19S
RVZfNTcxOSB8fA0KKwkgICAgR0VUX0FTSUNfUkVWKHRwLT5wY2lfY2hpcF9yZXZfaWQpID09IEFT
SUNfUkVWXzU3MjApIHsNCisJCWZvciAoaSA9IDA7IGkgPCBURzNfTlVNX1JETUFfQ0hBTk5FTFM7
IGkrKykgew0KKwkJCWlmICh0cjMyKFRHM19SRE1BX0xFTkdUSCArIChpIDw8IDIpKSA+IFRHM19N
QVhfTVRVKHRwKSkNCisJCQkJYnJlYWs7DQorCQl9DQorCQlpZiAoaSA8IFRHM19OVU1fUkRNQV9D
SEFOTkVMUykgew0KKwkJCXZhbCA9IHRyMzIoVEczX0xTT19SRF9ETUFfQ1JQVEVOX0NUUkwpOw0K
KwkJCXZhbCB8PSB0ZzNfbHNvX3JkX2RtYV93b3JrYXJvdW5kX2JpdCh0cCk7DQorCQkJdHczMihU
RzNfTFNPX1JEX0RNQV9DUlBURU5fQ1RSTCwgdmFsKTsNCisJCQl0ZzNfZmxhZ19zZXQodHAsIDU3
MTlfNTcyMF9SRE1BX0JVRyk7DQorCQl9DQorCX0NCisNCiAJdHczMihSQ1ZEQ0NfTU9ERSwgUkNW
RENDX01PREVfRU5BQkxFIHwgUkNWRENDX01PREVfQVRUTl9FTkFCTEUpOw0KIAlpZiAoIXRnM19m
bGFnKHRwLCA1NzA1X1BMVVMpKQ0KIAkJdHczMihNQkZSRUVfTU9ERSwgTUJGUkVFX01PREVfRU5B
QkxFKTsNCkBAIC05MTY2LDYgKzkxOTEsMTMgQEAgc3RhdGljIGludCB0ZzNfcmVzZXRfaHcoc3Ry
dWN0IHRnMyAqdHAsIGludCByZXNldF9waHkpDQogICovDQogc3RhdGljIGludCB0ZzNfaW5pdF9o
dyhzdHJ1Y3QgdGczICp0cCwgaW50IHJlc2V0X3BoeSkNCiB7DQorCS8qIENoaXAgbWF5IGhhdmUg
YmVlbiBqdXN0IHBvd2VyZWQgb24uIElmIHNvLCB0aGUgYm9vdCBjb2RlIG1heSBzdGlsbA0KKwkg
KiBiZSBydW5uaW5nIGluaXRpYWxpemF0aW9uLiBXYWl0IGZvciBpdCB0byBmaW5pc2ggdG8gYXZv
aWQgcmFjZXMgaW4NCisJICogYWNjZXNzaW5nIHRoZSBoYXJkd2FyZS4NCisJICovDQorCXRnM19l
bmFibGVfcmVnaXN0ZXJfYWNjZXNzKHRwKTsNCisJdGczX3BvbGxfZncodHApOw0KKw0KIAl0ZzNf
c3dpdGNoX2Nsb2Nrcyh0cCk7DQogDQogCXR3MzIoVEczUENJX01FTV9XSU5fQkFTRV9BRERSLCAw
KTsNCkBAIC05MjAwLDYgKzkyMzIsMTYgQEAgc3RhdGljIHZvaWQgdGczX3BlcmlvZGljX2ZldGNo
X3N0YXRzKHN0cnVjdCB0ZzMgKnRwKQ0KIAlURzNfU1RBVF9BREQzMigmc3AtPnR4X3VjYXN0X3Bh
Y2tldHMsIE1BQ19UWF9TVEFUU19VQ0FTVCk7DQogCVRHM19TVEFUX0FERDMyKCZzcC0+dHhfbWNh
c3RfcGFja2V0cywgTUFDX1RYX1NUQVRTX01DQVNUKTsNCiAJVEczX1NUQVRfQUREMzIoJnNwLT50
eF9iY2FzdF9wYWNrZXRzLCBNQUNfVFhfU1RBVFNfQkNBU1QpOw0KKwlpZiAodW5saWtlbHkodGcz
X2ZsYWcodHAsIDU3MTlfNTcyMF9SRE1BX0JVRykgJiYNCisJCSAgICAgKHNwLT50eF91Y2FzdF9w
YWNrZXRzLmxvdyArIHNwLT50eF9tY2FzdF9wYWNrZXRzLmxvdyArDQorCQkgICAgICBzcC0+dHhf
YmNhc3RfcGFja2V0cy5sb3cpID4gVEczX05VTV9SRE1BX0NIQU5ORUxTKSkgew0KKwkJdTMyIHZh
bDsNCisNCisJCXZhbCA9IHRyMzIoVEczX0xTT19SRF9ETUFfQ1JQVEVOX0NUUkwpOw0KKwkJdmFs
ICY9IH50ZzNfbHNvX3JkX2RtYV93b3JrYXJvdW5kX2JpdCh0cCk7DQorCQl0dzMyKFRHM19MU09f
UkRfRE1BX0NSUFRFTl9DVFJMLCB2YWwpOw0KKwkJdGczX2ZsYWdfY2xlYXIodHAsIDU3MTlfNTcy
MF9SRE1BX0JVRyk7DQorCX0NCiANCiAJVEczX1NUQVRfQUREMzIoJnNwLT5yeF9vY3RldHMsIE1B
Q19SWF9TVEFUU19PQ1RFVFMpOw0KIAlURzNfU1RBVF9BREQzMigmc3AtPnJ4X2ZyYWdtZW50cywg
TUFDX1JYX1NUQVRTX0ZSQUdNRU5UUyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vdGczLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuaA0K
aW5kZXggOTRiNGJkMC4uZGE5MGJhNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL3RnMy5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMu
aA0KQEAgLTEzNjgsNyArMTM2OCwxMiBAQA0KICNkZWZpbmUgVEczX0xTT19SRF9ETUFfQ1JQVEVO
X0NUUkwJMHgwMDAwNDkxMA0KICNkZWZpbmUgVEczX0xTT19SRF9ETUFfQ1JQVEVOX0NUUkxfQkxF
Tl9CRF80SwkgMHgwMDAzMDAwMA0KICNkZWZpbmUgVEczX0xTT19SRF9ETUFfQ1JQVEVOX0NUUkxf
QkxFTl9MU09fNEsJIDB4MDAwYzAwMDANCi0vKiAweDQ5MTQgLS0+IDB4NGMwMCB1bnVzZWQgKi8N
CisjZGVmaW5lIFRHM19MU09fUkRfRE1BX1RYX0xFTkdUSF9XQV81NzE5CSAweDAyMDAwMDAwDQor
I2RlZmluZSBURzNfTFNPX1JEX0RNQV9UWF9MRU5HVEhfV0FfNTcyMAkgMHgwMDIwMDAwMA0KKy8q
IDB4NDkxNCAtLT4gMHg0YmUwIHVudXNlZCAqLw0KKw0KKyNkZWZpbmUgVEczX05VTV9SRE1BX0NI
QU5ORUxTCQk0DQorI2RlZmluZSBURzNfUkRNQV9MRU5HVEgJCQkweDAwMDA0YmUwDQogDQogLyog
V3JpdGUgRE1BIGNvbnRyb2wgcmVnaXN0ZXJzICovDQogI2RlZmluZSBXRE1BQ19NT0RFCQkJMHgw
MDAwNGMwMA0KQEAgLTI5MjEsNiArMjkyNiw3IEBAIGVudW0gVEczX0ZMQUdTIHsNCiAJVEczX0ZM
QUdfQVBFX0hBU19OQ1NJLA0KIAlURzNfRkxBR181NzE3X1BMVVMsDQogCVRHM19GTEFHXzRLX0ZJ
Rk9fTElNSVQsDQorCVRHM19GTEFHXzU3MTlfNTcyMF9SRE1BX0JVRywNCiAJVEczX0ZMQUdfUkVT
RVRfVEFTS19QRU5ESU5HLA0KIA0KIAkvKiBBZGQgbmV3IGZsYWdzIGJlZm9yZSB0aGlzIGNvbW1l
bnQgYW5kIFRHM19GTEFHX05VTUJFUl9PRl9GTEFHUyAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9LY29uZmlnIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL0tjb25maWcNCmluZGV4IGQ5YzA4YzYuLmY0ZWQ0ZDggMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDlrL0tjb25maWcNCkBAIC01MCwxMyArNTAsMTcgQEAgY29uZmlnIEFUSDlL
X0RFQlVHRlMNCiANCiAJICBBbHNvIHJlcXVpcmVkIGZvciBjaGFuZ2luZyBkZWJ1ZyBtZXNzYWdl
IGZsYWdzIGF0IHJ1biB0aW1lLg0KIA0KLWNvbmZpZyBBVEg5S19SQVRFX0NPTlRST0wNCitjb25m
aWcgQVRIOUtfTEVHQUNZX1JBVEVfQ09OVFJPTA0KIAlib29sICJBdGhlcm9zIGF0aDlrIHJhdGUg
Y29udHJvbCINCiAJZGVwZW5kcyBvbiBBVEg5Sw0KLQlkZWZhdWx0IHkNCisJZGVmYXVsdCBuDQog
CS0tLWhlbHAtLS0NCiAJICBTYXkgWSwgaWYgeW91IHdhbnQgdG8gdXNlIHRoZSBhdGg5ayBzcGVj
aWZpYyByYXRlIGNvbnRyb2wNCi0JICBtb2R1bGUgaW5zdGVhZCBvZiBtaW5zdHJlbF9odC4NCisJ
ICBtb2R1bGUgaW5zdGVhZCBvZiBtaW5zdHJlbF9odC4gQmUgd2FybmVkIHRoYXQgdGhlcmUgYXJl
IHZhcmlvdXMNCisJICBpc3N1ZXMgd2l0aCB0aGUgYXRoOWsgUkMgYW5kIG1pbnN0cmVsIGlzIGEg
bW9yZSByb2J1c3QgYWxnb3JpdGhtLg0KKwkgIE5vdGUgdGhhdCBldmVuIGlmIHRoaXMgb3B0aW9u
IGlzIHNlbGVjdGVkLCAiYXRoOWtfcmF0ZV9jb250cm9sIg0KKwkgIGhhcyB0byBiZSBwYXNzZWQg
dG8gbWFjODAyMTEgdXNpbmcgdGhlIG1vZHVsZSBwYXJhbWV0ZXIsDQorCSAgaWVlZTgwMjExX2Rl
ZmF1bHRfcmNfYWxnby4NCiANCiBjb25maWcgQVRIOUtfSFRDDQogICAgICAgIHRyaXN0YXRlICJB
dGhlcm9zIEhUQyBiYXNlZCB3aXJlbGVzcyBjYXJkcyBzdXBwb3J0Ig0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay9NYWtlZmlsZQ0KaW5kZXggMzZlZDNjNC4uMWNkYjI0NiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9NYWtlZmlsZQ0KKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL01ha2VmaWxlDQpAQCAtNSw3ICs1LDcgQEAgYXRoOWst
eSArPQliZWFjb24ubyBcDQogCQlyZWN2Lm8gXA0KIAkJeG1pdC5vIFwNCiANCi1hdGg5ay0kKENP
TkZJR19BVEg5S19SQVRFX0NPTlRST0wpICs9IHJjLm8NCithdGg5ay0kKENPTkZJR19BVEg5S19M
RUdBQ1lfUkFURV9DT05UUk9MKSArPSByYy5vDQogYXRoOWstJChDT05GSUdfQVRIOUtfUENJKSAr
PSBwY2kubw0KIGF0aDlrLSQoQ09ORklHX0FUSDlLX0FIQikgKz0gYWhiLm8NCiBhdGg5ay0kKENP
TkZJR19BVEg5S19ERUJVR0ZTKSArPSBkZWJ1Zy5vDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDlrL2luaXQuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5
ay9pbml0LmMNCmluZGV4IDU3NjIyZTAuLmJhNmE0OWMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvaW5pdC5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvaW5pdC5jDQpAQCAtNjkxLDggKzY5MSw3IEBAIHZvaWQgYXRoOWtfc2V0X2h3X2Nh
cGFiKHN0cnVjdCBhdGhfc29mdGMgKnNjLCBzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiAJCUJJ
VChOTDgwMjExX0lGVFlQRV9BREhPQykgfA0KIAkJQklUKE5MODAyMTFfSUZUWVBFX01FU0hfUE9J
TlQpOw0KIA0KLQlpZiAoQVJfU1JFVl81NDE2KHNjLT5zY19haCkpDQotCQlody0+d2lwaHktPmZs
YWdzICY9IH5XSVBIWV9GTEFHX1BTX09OX0JZX0RFRkFVTFQ7DQorCWh3LT53aXBoeS0+ZmxhZ3Mg
Jj0gfldJUEhZX0ZMQUdfUFNfT05fQllfREVGQVVMVDsNCiANCiAJaHctPndpcGh5LT5mbGFncyB8
PSBXSVBIWV9GTEFHX0lCU1NfUlNOOw0KIA0KQEAgLTcxNCwxMCArNzEzLDYgQEAgdm9pZCBhdGg5
a19zZXRfaHdfY2FwYWIoc3RydWN0IGF0aF9zb2Z0YyAqc2MsIHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3KQ0KIAlzYy0+YW50X3J4ID0gaHctPndpcGh5LT5hdmFpbGFibGVfYW50ZW5uYXNfcng7DQog
CXNjLT5hbnRfdHggPSBody0+d2lwaHktPmF2YWlsYWJsZV9hbnRlbm5hc190eDsNCiANCi0jaWZk
ZWYgQ09ORklHX0FUSDlLX1JBVEVfQ09OVFJPTA0KLQlody0+cmF0ZV9jb250cm9sX2FsZ29yaXRo
bSA9ICJhdGg5a19yYXRlX2NvbnRyb2wiOw0KLSNlbmRpZg0KLQ0KIAlpZiAoc2MtPnNjX2FoLT5j
YXBzLmh3X2NhcHMgJiBBVEg5S19IV19DQVBfMkdIWikNCiAJCWh3LT53aXBoeS0+YmFuZHNbSUVF
RTgwMjExX0JBTkRfMkdIWl0gPQ0KIAkJCSZzYy0+c2JhbmRzW0lFRUU4MDIxMV9CQU5EXzJHSFpd
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9yYy5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3JjLmgNCmluZGV4IGI3YTRiY2QuLmU4ZTE5MDEg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvcmMuaA0KKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3JjLmgNCkBAIC0yMjEsNyArMjIxLDcgQEAg
c3RydWN0IGF0aF9yYXRlX3ByaXYgew0KIAlzdHJ1Y3QgYXRoX3JjX3N0YXRzIHJjc3RhdHNbUkFU
RV9UQUJMRV9TSVpFXTsNCiB9Ow0KIA0KLSNpZmRlZiBDT05GSUdfQVRIOUtfUkFURV9DT05UUk9M
DQorI2lmZGVmIENPTkZJR19BVEg5S19MRUdBQ1lfUkFURV9DT05UUk9MDQogaW50IGF0aF9yYXRl
X2NvbnRyb2xfcmVnaXN0ZXIodm9pZCk7DQogdm9pZCBhdGhfcmF0ZV9jb250cm9sX3VucmVnaXN0
ZXIodm9pZCk7DQogI2Vsc2UNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMv
bWFpbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL21haW4uYw0KaW5kZXggYzBmMjA0MS4u
YjBjMjgwMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9tYWluLmMNCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9tYWluLmMNCkBAIC0yNDIxLDcgKzI0MjEsNyBA
QCBzdGF0aWMgaW50IGI0M19yZXF1ZXN0X2Zpcm13YXJlKHN0cnVjdCBiNDNfd2xkZXYgKmRldikN
CiAJZm9yIChpID0gMDsgaSA8IEI0M19OUl9GV1RZUEVTOyBpKyspIHsNCiAJCWVycm1zZyA9IGN0
eC0+ZXJyb3JzW2ldOw0KIAkJaWYgKHN0cmxlbihlcnJtc2cpKQ0KLQkJCWI0M2VycihkZXYtPnds
LCBlcnJtc2cpOw0KKwkJCWI0M2VycihkZXYtPndsLCAiJXMiLCBlcnJtc2cpOw0KIAl9DQogCWI0
M19wcmludF9md19oZWxwdGV4dChkZXYtPndsLCAxKTsNCiAJZXJyID0gLUVOT0VOVDsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDNsZWdhY3kvbWFpbi5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYjQzbGVnYWN5L21haW4uYw0KaW5kZXggYzVjZTE2My4uNzExOTVjYiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0M2xlZ2FjeS9tYWluLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2I0M2xlZ2FjeS9tYWluLmMNCkBAIC0zODM3LDYgKzM4MzcsOCBA
QCBzdGF0aWMgdm9pZCBiNDNsZWdhY3lfcmVtb3ZlKHN0cnVjdCBzc2JfZGV2aWNlICpkZXYpDQog
CWNhbmNlbF93b3JrX3N5bmMoJndsZGV2LT5yZXN0YXJ0X3dvcmspOw0KIA0KIAlCNDNsZWdhY3lf
V0FSTl9PTighd2wpOw0KKwlpZiAoIXdsZGV2LT5mdy51Y29kZSkNCisJCXJldHVybjsJCQkvKiBO
VUxMIGlmIGZ3IG5ldmVyIGxvYWRlZCAqLw0KIAlpZiAod2wtPmN1cnJlbnRfZGV2ID09IHdsZGV2
KQ0KIAkJaWVlZTgwMjExX3VucmVnaXN0ZXJfaHcod2wtPmh3KTsNCiANCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tc3RhLmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tc3RhLmMNCmluZGV4IDM5MzU5OTQuLmJjMzBhNWYgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tc3RhLmMNCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1zdGEuYw0KQEAgLTYwNCw3
ICs2MDQsNyBAQCB2b2lkIGl3bF9yZXN0b3JlX3N0YXRpb25zKHN0cnVjdCBpd2xfcHJpdiAqcHJp
diwgc3RydWN0IGl3bF9yeG9uX2NvbnRleHQgKmN0eCkNCiAJCQkJCW1lbWNweSgmbHEsIHByaXYt
PnN0YXRpb25zW2ldLmxxLA0KIAkJCQkJICAgICAgIHNpemVvZihzdHJ1Y3QgaXdsX2xpbmtfcXVh
bGl0eV9jbWQpKTsNCiANCi0JCQkJaWYgKCFtZW1jbXAoJmxxLCAmemVyb19scSwgc2l6ZW9mKGxx
KSkpDQorCQkJCWlmIChtZW1jbXAoJmxxLCAmemVyb19scSwgc2l6ZW9mKGxxKSkpDQogCQkJCQlz
ZW5kX2xxID0gdHJ1ZTsNCiAJCQl9DQogCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdi0+
c2hyZC0+c3RhX2xvY2ssDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0
YmFjay5jIGIvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5jDQppbmRleCAxODVhMGVi
Li5mZDJiOTJkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5j
DQorKysgYi9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9uZXRiYWNrLmMNCkBAIC00NiwxMSArNDYs
MzMgQEANCiAjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4NCiAjaW5jbHVkZSA8YXNtL3hl
bi9wYWdlLmg+DQogDQorLyoNCisgKiBUaGlzIGlzIHRoZSBtYXhpbXVtIHNsb3RzIGEgc2tiIGNh
biBoYXZlLiBJZiBhIGd1ZXN0IHNlbmRzIGEgc2tiDQorICogd2hpY2ggZXhjZWVkcyB0aGlzIGxp
bWl0IGl0IGlzIGNvbnNpZGVyZWQgbWFsaWNpb3VzLg0KKyAqLw0KKyNkZWZpbmUgRkFUQUxfU0tC
X1NMT1RTX0RFRkFVTFQgMjANCitzdGF0aWMgdW5zaWduZWQgaW50IGZhdGFsX3NrYl9zbG90cyA9
IEZBVEFMX1NLQl9TTE9UU19ERUZBVUxUOw0KK21vZHVsZV9wYXJhbShmYXRhbF9za2Jfc2xvdHMs
IHVpbnQsIDA0NDQpOw0KKw0KKy8qDQorICogVG8gYXZvaWQgY29uZnVzaW9uLCB3ZSBkZWZpbmUg
WEVOX05FVEJLX0xFR0FDWV9TTE9UU19NQVggaW5kaWNhdGluZw0KKyAqIHRoZSBtYXhpbXVtIHNs
b3RzIGEgdmFsaWQgcGFja2V0IGNhbiB1c2UuIE5vdyB0aGlzIHZhbHVlIGlzIGRlZmluZWQNCisg
KiB0byBiZSBYRU5fTkVUSUZfTlJfU0xPVFNfTUlOLCB3aGljaCBpcyBzdXBwb3NlZCB0byBiZSBz
dXBwb3J0ZWQgYnkNCisgKiBhbGwgYmFja2VuZC4NCisgKi8NCisjZGVmaW5lIFhFTl9ORVRCS19M
RUdBQ1lfU0xPVFNfTUFYIFhFTl9ORVRJRl9OUl9TTE9UU19NSU4NCisNCit0eXBlZGVmIHVuc2ln
bmVkIGludCBwZW5kaW5nX3JpbmdfaWR4X3Q7DQorI2RlZmluZSBJTlZBTElEX1BFTkRJTkdfUklO
R19JRFggKH4wVSkNCisNCiBzdHJ1Y3QgcGVuZGluZ190eF9pbmZvIHsNCi0Jc3RydWN0IHhlbl9u
ZXRpZl90eF9yZXF1ZXN0IHJlcTsNCisJc3RydWN0IHhlbl9uZXRpZl90eF9yZXF1ZXN0IHJlcTsg
LyogY29hbGVzY2VkIHR4IHJlcXVlc3QgKi8NCiAJc3RydWN0IHhlbnZpZiAqdmlmOw0KKwlwZW5k
aW5nX3JpbmdfaWR4X3QgaGVhZDsgLyogaGVhZCAhPSBJTlZBTElEX1BFTkRJTkdfUklOR19JRFgN
CisJCQkJICAqIGlmIGl0IGlzIGhlYWQgb2Ygb25lIG9yIG1vcmUgdHgNCisJCQkJICAqIHJlcXMN
CisJCQkJICAqLw0KIH07DQotdHlwZWRlZiB1bnNpZ25lZCBpbnQgcGVuZGluZ19yaW5nX2lkeF90
Ow0KIA0KIHN0cnVjdCBuZXRia19yeF9tZXRhIHsNCiAJaW50IGlkOw0KQEAgLTEwMSw3ICsxMjMs
MTEgQEAgc3RydWN0IHhlbl9uZXRiayB7DQogCWF0b21pY190IG5ldGZyb250X2NvdW50Ow0KIA0K
IAlzdHJ1Y3QgcGVuZGluZ190eF9pbmZvIHBlbmRpbmdfdHhfaW5mb1tNQVhfUEVORElOR19SRVFT
XTsNCi0Jc3RydWN0IGdudHRhYl9jb3B5IHR4X2NvcHlfb3BzW01BWF9QRU5ESU5HX1JFUVNdOw0K
KwkvKiBDb2FsZXNjaW5nIHR4IHJlcXVlc3RzIGJlZm9yZSBjb3B5aW5nIG1ha2VzIG51bWJlciBv
ZiBncmFudA0KKwkgKiBjb3B5IG9wcyBncmVhdGVyIG9yIGVxdWFsIHRvIG51bWJlciBvZiBzbG90
cyByZXF1aXJlZC4gSW4NCisJICogd29yc3QgY2FzZSBhIHR4IHJlcXVlc3QgY29uc3VtZXMgMiBn
bnR0YWJfY29weS4NCisJICovDQorCXN0cnVjdCBnbnR0YWJfY29weSB0eF9jb3B5X29wc1syKk1B
WF9QRU5ESU5HX1JFUVNdOw0KIA0KIAl1MTYgcGVuZGluZ19yaW5nW01BWF9QRU5ESU5HX1JFUVNd
Ow0KIA0KQEAgLTExNyw2ICsxNDMsMTYgQEAgc3RydWN0IHhlbl9uZXRiayB7DQogc3RhdGljIHN0
cnVjdCB4ZW5fbmV0YmsgKnhlbl9uZXRiazsNCiBzdGF0aWMgaW50IHhlbl9uZXRia19ncm91cF9u
cjsNCiANCisvKg0KKyAqIElmIGhlYWQgIT0gSU5WQUxJRF9QRU5ESU5HX1JJTkdfSURYLCBpdCBt
ZWFucyB0aGlzIHR4IHJlcXVlc3QgaXMgaGVhZCBvZg0KKyAqIG9uZSBvciBtb3JlIG1lcmdlZCB0
eCByZXF1ZXN0cywgb3RoZXJ3aXNlIGl0IGlzIHRoZSBjb250aW51YXRpb24gb2YNCisgKiBwcmV2
aW91cyB0eCByZXF1ZXN0Lg0KKyAqLw0KK3N0YXRpYyBpbmxpbmUgaW50IHBlbmRpbmdfdHhfaXNf
aGVhZChzdHJ1Y3QgeGVuX25ldGJrICpuZXRiaywgUklOR19JRFggaWR4KQ0KK3sNCisJcmV0dXJu
IG5ldGJrLT5wZW5kaW5nX3R4X2luZm9baWR4XS5oZWFkICE9IElOVkFMSURfUEVORElOR19SSU5H
X0lEWDsNCit9DQorDQogdm9pZCB4ZW5fbmV0YmtfYWRkX3hlbnZpZihzdHJ1Y3QgeGVudmlmICp2
aWYpDQogew0KIAlpbnQgaTsNCkBAIC0yNDksNiArMjg1LDcgQEAgc3RhdGljIGludCBtYXhfcmVx
dWlyZWRfcnhfc2xvdHMoc3RydWN0IHhlbnZpZiAqdmlmKQ0KIHsNCiAJaW50IG1heCA9IERJVl9S
T1VORF9VUCh2aWYtPmRldi0+bXR1LCBQQUdFX1NJWkUpOw0KIA0KKwkvKiBYWFggRklYTUU6IFJY
IHBhdGggZGVwZW5kZW50IG9uIE1BWF9TS0JfRlJBR1MgKi8NCiAJaWYgKHZpZi0+Y2FuX3NnIHx8
IHZpZi0+Z3NvIHx8IHZpZi0+Z3NvX3ByZWZpeCkNCiAJCW1heCArPSBNQVhfU0tCX0ZSQUdTICsg
MTsgLyogZXh0cmFfaW5mbyArIGZyYWdzICovDQogDQpAQCAtNjI3LDYgKzY2NCw3IEBAIHN0YXRp
YyB2b2lkIHhlbl9uZXRia19yeF9hY3Rpb24oc3RydWN0IHhlbl9uZXRiayAqbmV0YmspDQogCQlf
X3NrYl9xdWV1ZV90YWlsKCZyeHEsIHNrYik7DQogDQogCQkvKiBGaWxsZWQgdGhlIGJhdGNoIHF1
ZXVlPyAqLw0KKwkJLyogWFhYIEZJWE1FOiBSWCBwYXRoIGRlcGVuZGVudCBvbiBNQVhfU0tCX0ZS
QUdTICovDQogCQlpZiAoY291bnQgKyBNQVhfU0tCX0ZSQUdTID49IFhFTl9ORVRJRl9SWF9SSU5H
X1NJWkUpDQogCQkJYnJlYWs7DQogCX0NCkBAIC04NzQsNDcgKzkxMiw5OSBAQCBzdGF0aWMgaW50
IG5ldGJrX2NvdW50X3JlcXVlc3RzKHN0cnVjdCB4ZW52aWYgKnZpZiwNCiAJCQkJaW50IHdvcmtf
dG9fZG8pDQogew0KIAlSSU5HX0lEWCBjb25zID0gdmlmLT50eC5yZXFfY29uczsNCi0JaW50IGZy
YWdzID0gMDsNCisJaW50IHNsb3RzID0gMDsNCisJaW50IGRyb3BfZXJyID0gMDsNCisJaW50IG1v
cmVfZGF0YTsNCiANCiAJaWYgKCEoZmlyc3QtPmZsYWdzICYgWEVOX05FVFRYRl9tb3JlX2RhdGEp
KQ0KIAkJcmV0dXJuIDA7DQogDQogCWRvIHsNCi0JCWlmIChmcmFncyA+PSB3b3JrX3RvX2RvKSB7
DQotCQkJbmV0ZGV2X2Vycih2aWYtPmRldiwgIk5lZWQgbW9yZSBmcmFnc1xuIik7DQorCQlzdHJ1
Y3QgeGVuX25ldGlmX3R4X3JlcXVlc3QgZHJvcHBlZF90eCA9IHsgMCB9Ow0KKw0KKwkJaWYgKHNs
b3RzID49IHdvcmtfdG9fZG8pIHsNCisJCQluZXRkZXZfZXJyKHZpZi0+ZGV2LA0KKwkJCQkgICAi
QXNrZWQgZm9yICVkIHNsb3RzIGJ1dCBleGNlZWRzIHRoaXMgbGltaXRcbiIsDQorCQkJCSAgIHdv
cmtfdG9fZG8pOw0KIAkJCW5ldGJrX2ZhdGFsX3R4X2Vycih2aWYpOw0KIAkJCXJldHVybiAtRU5P
REFUQTsNCiAJCX0NCiANCi0JCWlmICh1bmxpa2VseShmcmFncyA+PSBNQVhfU0tCX0ZSQUdTKSkg
ew0KLQkJCW5ldGRldl9lcnIodmlmLT5kZXYsICJUb28gbWFueSBmcmFnc1xuIik7DQorCQkvKiBU
aGlzIGd1ZXN0IGlzIHJlYWxseSB1c2luZyB0b28gbWFueSBzbG90cyBhbmQNCisJCSAqIGNvbnNp
ZGVyZWQgbWFsaWNpb3VzLg0KKwkJICovDQorCQlpZiAodW5saWtlbHkoc2xvdHMgPj0gZmF0YWxf
c2tiX3Nsb3RzKSkgew0KKwkJCW5ldGRldl9lcnIodmlmLT5kZXYsDQorCQkJCSAgICJNYWxpY2lv
dXMgZnJvbnRlbmQgdXNpbmcgJWQgc2xvdHMsIHRocmVzaG9sZCAldVxuIiwNCisJCQkJICAgc2xv
dHMsIGZhdGFsX3NrYl9zbG90cyk7DQogCQkJbmV0YmtfZmF0YWxfdHhfZXJyKHZpZik7DQogCQkJ
cmV0dXJuIC1FMkJJRzsNCiAJCX0NCiANCi0JCW1lbWNweSh0eHAsIFJJTkdfR0VUX1JFUVVFU1Qo
JnZpZi0+dHgsIGNvbnMgKyBmcmFncyksDQorCQkvKiBYZW4gbmV0d29yayBwcm90b2NvbCBoYWQg
aW1wbGljaXQgZGVwZW5kZW5jeSBvbg0KKwkJICogTUFYX1NLQl9GUkFHUy4gWEVOX05FVEJLX0xF
R0FDWV9TTE9UU19NQVggaXMgc2V0IHRvDQorCQkgKiB0aGUgaGlzdG9yaWNhbCBNQVhfU0tCX0ZS
QUdTIHZhbHVlIDE4IHRvIGhvbm9yIHRoZQ0KKwkJICogc2FtZSBiZWhhdmlvciBhcyBiZWZvcmUu
IEFueSBwYWNrZXQgdXNpbmcgbW9yZSB0aGFuDQorCQkgKiAxOCBzbG90cyBidXQgbGVzcyB0aGFu
IGZhdGFsX3NrYl9zbG90cyBzbG90cyBpcw0KKwkJICogZHJvcHBlZA0KKwkJICovDQorCQlpZiAo
IWRyb3BfZXJyICYmIHNsb3RzID49IFhFTl9ORVRCS19MRUdBQ1lfU0xPVFNfTUFYKSB7DQorCQkJ
aWYgKG5ldF9yYXRlbGltaXQoKSkNCisJCQkJbmV0ZGV2X2RiZyh2aWYtPmRldiwNCisJCQkJCSAg
ICJUb28gbWFueSBzbG90cyAoJWQpIGV4Y2VlZGluZyBsaW1pdCAoJWQpLCBkcm9wcGluZyBwYWNr
ZXRcbiIsDQorCQkJCQkgICBzbG90cywgWEVOX05FVEJLX0xFR0FDWV9TTE9UU19NQVgpOw0KKwkJ
CWRyb3BfZXJyID0gLUUyQklHOw0KKwkJfQ0KKw0KKwkJaWYgKGRyb3BfZXJyKQ0KKwkJCXR4cCA9
ICZkcm9wcGVkX3R4Ow0KKw0KKwkJbWVtY3B5KHR4cCwgUklOR19HRVRfUkVRVUVTVCgmdmlmLT50
eCwgY29ucyArIHNsb3RzKSwNCiAJCSAgICAgICBzaXplb2YoKnR4cCkpOw0KLQkJaWYgKHR4cC0+
c2l6ZSA+IGZpcnN0LT5zaXplKSB7DQotCQkJbmV0ZGV2X2Vycih2aWYtPmRldiwgIkZyYWcgaXMg
YmlnZ2VyIHRoYW4gZnJhbWUuXG4iKTsNCi0JCQluZXRia19mYXRhbF90eF9lcnIodmlmKTsNCi0J
CQlyZXR1cm4gLUVJTzsNCisNCisJCS8qIElmIHRoZSBndWVzdCBzdWJtaXR0ZWQgYSBmcmFtZSA+
PSA2NCBLaUIgdGhlbg0KKwkJICogZmlyc3QtPnNpemUgb3ZlcmZsb3dlZCBhbmQgZm9sbG93aW5n
IHNsb3RzIHdpbGwNCisJCSAqIGFwcGVhciB0byBiZSBsYXJnZXIgdGhhbiB0aGUgZnJhbWUuDQor
CQkgKg0KKwkJICogVGhpcyBjYW5ub3QgYmUgZmF0YWwgZXJyb3IgYXMgdGhlcmUgYXJlIGJ1Z2d5
DQorCQkgKiBmcm9udGVuZHMgdGhhdCBkbyB0aGlzLg0KKwkJICoNCisJCSAqIENvbnN1bWUgYWxs
IHNsb3RzIGFuZCBkcm9wIHRoZSBwYWNrZXQuDQorCQkgKi8NCisJCWlmICghZHJvcF9lcnIgJiYg
dHhwLT5zaXplID4gZmlyc3QtPnNpemUpIHsNCisJCQlpZiAobmV0X3JhdGVsaW1pdCgpKQ0KKwkJ
CQluZXRkZXZfZGJnKHZpZi0+ZGV2LA0KKwkJCQkJICAgIkludmFsaWQgdHggcmVxdWVzdCwgc2xv
dCBzaXplICV1ID4gcmVtYWluaW5nIHNpemUgJXVcbiIsDQorCQkJCQkgICB0eHAtPnNpemUsIGZp
cnN0LT5zaXplKTsNCisJCQlkcm9wX2VyciA9IC1FSU87DQogCQl9DQogDQogCQlmaXJzdC0+c2l6
ZSAtPSB0eHAtPnNpemU7DQotCQlmcmFncysrOw0KKwkJc2xvdHMrKzsNCiANCiAJCWlmICh1bmxp
a2VseSgodHhwLT5vZmZzZXQgKyB0eHAtPnNpemUpID4gUEFHRV9TSVpFKSkgew0KLQkJCW5ldGRl
dl9lcnIodmlmLT5kZXYsICJ0eHAtPm9mZnNldDogJXgsIHNpemU6ICV1XG4iLA0KKwkJCW5ldGRl
dl9lcnIodmlmLT5kZXYsICJDcm9zcyBwYWdlIGJvdW5kYXJ5LCB0eHAtPm9mZnNldDogJXgsIHNp
emU6ICV1XG4iLA0KIAkJCQkgdHhwLT5vZmZzZXQsIHR4cC0+c2l6ZSk7DQogCQkJbmV0YmtfZmF0
YWxfdHhfZXJyKHZpZik7DQogCQkJcmV0dXJuIC1FSU5WQUw7DQogCQl9DQotCX0gd2hpbGUgKCh0
eHArKyktPmZsYWdzICYgWEVOX05FVFRYRl9tb3JlX2RhdGEpOw0KLQlyZXR1cm4gZnJhZ3M7DQor
DQorCQltb3JlX2RhdGEgPSB0eHAtPmZsYWdzICYgWEVOX05FVFRYRl9tb3JlX2RhdGE7DQorDQor
CQlpZiAoIWRyb3BfZXJyKQ0KKwkJCXR4cCsrOw0KKw0KKwl9IHdoaWxlIChtb3JlX2RhdGEpOw0K
Kw0KKwlpZiAoZHJvcF9lcnIpIHsNCisJCW5ldGJrX3R4X2Vycih2aWYsIGZpcnN0LCBjb25zICsg
c2xvdHMpOw0KKwkJcmV0dXJuIGRyb3BfZXJyOw0KKwl9DQorDQorCXJldHVybiBzbG90czsNCiB9
DQogDQogc3RhdGljIHN0cnVjdCBwYWdlICp4ZW5fbmV0YmtfYWxsb2NfcGFnZShzdHJ1Y3QgeGVu
X25ldGJrICpuZXRiaywNCi0JCQkJCSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAkJCQkJIHUxNiBw
ZW5kaW5nX2lkeCkNCiB7DQogCXN0cnVjdCBwYWdlICpwYWdlOw0KQEAgLTkzNSw1MCArMTAyNSwx
MTQgQEAgc3RhdGljIHN0cnVjdCBnbnR0YWJfY29weSAqeGVuX25ldGJrX2dldF9yZXF1ZXN0cyhz
dHJ1Y3QgeGVuX25ldGJrICpuZXRiaywNCiAJc3RydWN0IHNrYl9zaGFyZWRfaW5mbyAqc2hpbmZv
ID0gc2tiX3NoaW5mbyhza2IpOw0KIAlza2JfZnJhZ190ICpmcmFncyA9IHNoaW5mby0+ZnJhZ3M7
DQogCXUxNiBwZW5kaW5nX2lkeCA9ICooKHUxNiAqKXNrYi0+ZGF0YSk7DQotCWludCBpLCBzdGFy
dDsNCisJdTE2IGhlYWRfaWR4ID0gMDsNCisJaW50IHNsb3QsIHN0YXJ0Ow0KKwlzdHJ1Y3QgcGFn
ZSAqcGFnZTsNCisJcGVuZGluZ19yaW5nX2lkeF90IGluZGV4LCBzdGFydF9pZHggPSAwOw0KKwl1
aW50MTZfdCBkc3Rfb2Zmc2V0Ow0KKwl1bnNpZ25lZCBpbnQgbnJfc2xvdHM7DQorCXN0cnVjdCBw
ZW5kaW5nX3R4X2luZm8gKmZpcnN0ID0gTlVMTDsNCisNCisJLyogQXQgdGhpcyBwb2ludCBzaGlu
Zm8tPm5yX2ZyYWdzIGlzIGluIGZhY3QgdGhlIG51bWJlciBvZg0KKwkgKiBzbG90cywgd2hpY2gg
Y2FuIGJlIGFzIGxhcmdlIGFzIFhFTl9ORVRCS19MRUdBQ1lfU0xPVFNfTUFYLg0KKwkgKi8NCisJ
bnJfc2xvdHMgPSBzaGluZm8tPm5yX2ZyYWdzOw0KIA0KIAkvKiBTa2lwIGZpcnN0IHNrYiBmcmFn
bWVudCBpZiBpdCBpcyBvbiBzYW1lIHBhZ2UgYXMgaGVhZGVyIGZyYWdtZW50LiAqLw0KIAlzdGFy
dCA9IChmcmFnX2dldF9wZW5kaW5nX2lkeCgmc2hpbmZvLT5mcmFnc1swXSkgPT0gcGVuZGluZ19p
ZHgpOw0KIA0KLQlmb3IgKGkgPSBzdGFydDsgaSA8IHNoaW5mby0+bnJfZnJhZ3M7IGkrKywgdHhw
KyspIHsNCi0JCXN0cnVjdCBwYWdlICpwYWdlOw0KLQkJcGVuZGluZ19yaW5nX2lkeF90IGluZGV4
Ow0KKwkvKiBDb2FsZXNjZSB0eCByZXF1ZXN0cywgYXQgdGhpcyBwb2ludCB0aGUgcGFja2V0IHBh
c3NlZCBpbg0KKwkgKiBzaG91bGQgYmUgPD0gNjRLLiBBbnkgcGFja2V0cyBsYXJnZXIgdGhhbiA2
NEsgaGF2ZSBiZWVuDQorCSAqIGhhbmRsZWQgaW4gbmV0YmtfY291bnRfcmVxdWVzdHMoKS4NCisJ
ICovDQorCWZvciAoc2hpbmZvLT5ucl9mcmFncyA9IHNsb3QgPSBzdGFydDsgc2xvdCA8IG5yX3Ns
b3RzOw0KKwkgICAgIHNoaW5mby0+bnJfZnJhZ3MrKykgew0KIAkJc3RydWN0IHBlbmRpbmdfdHhf
aW5mbyAqcGVuZGluZ190eF9pbmZvID0NCiAJCQluZXRiay0+cGVuZGluZ190eF9pbmZvOw0KIA0K
LQkJaW5kZXggPSBwZW5kaW5nX2luZGV4KG5ldGJrLT5wZW5kaW5nX2NvbnMrKyk7DQotCQlwZW5k
aW5nX2lkeCA9IG5ldGJrLT5wZW5kaW5nX3JpbmdbaW5kZXhdOw0KLQkJcGFnZSA9IHhlbl9uZXRi
a19hbGxvY19wYWdlKG5ldGJrLCBza2IsIHBlbmRpbmdfaWR4KTsNCisJCXBhZ2UgPSBhbGxvY19w
YWdlKEdGUF9LRVJORUx8X19HRlBfQ09MRCk7DQogCQlpZiAoIXBhZ2UpDQogCQkJZ290byBlcnI7
DQogDQotCQluZXRiay0+bW1hcF9wYWdlc1twZW5kaW5nX2lkeF0gPSBwYWdlOw0KLQ0KLQkJZ29w
LT5zb3VyY2UudS5yZWYgPSB0eHAtPmdyZWY7DQotCQlnb3AtPnNvdXJjZS5kb21pZCA9IHZpZi0+
ZG9taWQ7DQotCQlnb3AtPnNvdXJjZS5vZmZzZXQgPSB0eHAtPm9mZnNldDsNCi0NCi0JCWdvcC0+
ZGVzdC51LmdtZm4gPSB2aXJ0X3RvX21mbihwYWdlX2FkZHJlc3MocGFnZSkpOw0KLQkJZ29wLT5k
ZXN0LmRvbWlkID0gRE9NSURfU0VMRjsNCi0JCWdvcC0+ZGVzdC5vZmZzZXQgPSB0eHAtPm9mZnNl
dDsNCi0NCi0JCWdvcC0+bGVuID0gdHhwLT5zaXplOw0KLQkJZ29wLT5mbGFncyA9IEdOVENPUFlf
c291cmNlX2dyZWY7DQorCQlkc3Rfb2Zmc2V0ID0gMDsNCisJCWZpcnN0ID0gTlVMTDsNCisJCXdo
aWxlIChkc3Rfb2Zmc2V0IDwgUEFHRV9TSVpFICYmIHNsb3QgPCBucl9zbG90cykgew0KKwkJCWdv
cC0+ZmxhZ3MgPSBHTlRDT1BZX3NvdXJjZV9ncmVmOw0KKw0KKwkJCWdvcC0+c291cmNlLnUucmVm
ID0gdHhwLT5ncmVmOw0KKwkJCWdvcC0+c291cmNlLmRvbWlkID0gdmlmLT5kb21pZDsNCisJCQln
b3AtPnNvdXJjZS5vZmZzZXQgPSB0eHAtPm9mZnNldDsNCisNCisJCQlnb3AtPmRlc3QuZG9taWQg
PSBET01JRF9TRUxGOw0KKw0KKwkJCWdvcC0+ZGVzdC5vZmZzZXQgPSBkc3Rfb2Zmc2V0Ow0KKwkJ
CWdvcC0+ZGVzdC51LmdtZm4gPSB2aXJ0X3RvX21mbihwYWdlX2FkZHJlc3MocGFnZSkpOw0KKw0K
KwkJCWlmIChkc3Rfb2Zmc2V0ICsgdHhwLT5zaXplID4gUEFHRV9TSVpFKSB7DQorCQkJCS8qIFRo
aXMgcGFnZSBjYW4gb25seSBtZXJnZSBhIHBvcnRpb24NCisJCQkJICogb2YgdHggcmVxdWVzdC4g
RG8gbm90IGluY3JlbWVudCBhbnkNCisJCQkJICogcG9pbnRlciAvIGNvdW50ZXIgaGVyZS4gVGhl
IHR4cA0KKwkJCQkgKiB3aWxsIGJlIGRlYWx0IHdpdGggaW4gZnV0dXJlDQorCQkJCSAqIHJvdW5k
cywgZXZlbnR1YWxseSBoaXR0aW5nIHRoZQ0KKwkJCQkgKiBgZWxzZWAgYnJhbmNoLg0KKwkJCQkg
Ki8NCisJCQkJZ29wLT5sZW4gPSBQQUdFX1NJWkUgLSBkc3Rfb2Zmc2V0Ow0KKwkJCQl0eHAtPm9m
ZnNldCArPSBnb3AtPmxlbjsNCisJCQkJdHhwLT5zaXplIC09IGdvcC0+bGVuOw0KKwkJCQlkc3Rf
b2Zmc2V0ICs9IGdvcC0+bGVuOyAvKiBxdWl0IGxvb3AgKi8NCisJCQl9IGVsc2Ugew0KKwkJCQkv
KiBUaGlzIHR4IHJlcXVlc3QgY2FuIGJlIG1lcmdlZCBpbiB0aGUgcGFnZSAqLw0KKwkJCQlnb3At
PmxlbiA9IHR4cC0+c2l6ZTsNCisJCQkJZHN0X29mZnNldCArPSBnb3AtPmxlbjsNCisNCisJCQkJ
aW5kZXggPSBwZW5kaW5nX2luZGV4KG5ldGJrLT5wZW5kaW5nX2NvbnMrKyk7DQorDQorCQkJCXBl
bmRpbmdfaWR4ID0gbmV0YmstPnBlbmRpbmdfcmluZ1tpbmRleF07DQorDQorCQkJCW1lbWNweSgm
cGVuZGluZ190eF9pbmZvW3BlbmRpbmdfaWR4XS5yZXEsIHR4cCwNCisJCQkJICAgICAgIHNpemVv
ZigqdHhwKSk7DQorCQkJCXhlbnZpZl9nZXQodmlmKTsNCisNCisJCQkJcGVuZGluZ190eF9pbmZv
W3BlbmRpbmdfaWR4XS52aWYgPSB2aWY7DQorDQorCQkJCS8qIFBvaXNvbiB0aGVzZSBmaWVsZHMs
IGNvcnJlc3BvbmRpbmcNCisJCQkJICogZmllbGRzIGZvciBoZWFkIHR4IHJlcSB3aWxsIGJlIHNl
dA0KKwkJCQkgKiB0byBjb3JyZWN0IHZhbHVlcyBhZnRlciB0aGUgbG9vcC4NCisJCQkJICovDQor
CQkJCW5ldGJrLT5tbWFwX3BhZ2VzW3BlbmRpbmdfaWR4XSA9ICh2b2lkICopKH4wVUwpOw0KKwkJ
CQlwZW5kaW5nX3R4X2luZm9bcGVuZGluZ19pZHhdLmhlYWQgPQ0KKwkJCQkJSU5WQUxJRF9QRU5E
SU5HX1JJTkdfSURYOw0KKw0KKwkJCQlpZiAoIWZpcnN0KSB7DQorCQkJCQlmaXJzdCA9ICZwZW5k
aW5nX3R4X2luZm9bcGVuZGluZ19pZHhdOw0KKwkJCQkJc3RhcnRfaWR4ID0gaW5kZXg7DQorCQkJ
CQloZWFkX2lkeCA9IHBlbmRpbmdfaWR4Ow0KKwkJCQl9DQorDQorCQkJCXR4cCsrOw0KKwkJCQlz
bG90Kys7DQorCQkJfQ0KIA0KLQkJZ29wKys7DQorCQkJZ29wKys7DQorCQl9DQogDQotCQltZW1j
cHkoJnBlbmRpbmdfdHhfaW5mb1twZW5kaW5nX2lkeF0ucmVxLCB0eHAsIHNpemVvZigqdHhwKSk7
DQotCQl4ZW52aWZfZ2V0KHZpZik7DQotCQlwZW5kaW5nX3R4X2luZm9bcGVuZGluZ19pZHhdLnZp
ZiA9IHZpZjsNCi0JCWZyYWdfc2V0X3BlbmRpbmdfaWR4KCZmcmFnc1tpXSwgcGVuZGluZ19pZHgp
Ow0KKwkJZmlyc3QtPnJlcS5vZmZzZXQgPSAwOw0KKwkJZmlyc3QtPnJlcS5zaXplID0gZHN0X29m
ZnNldDsNCisJCWZpcnN0LT5oZWFkID0gc3RhcnRfaWR4Ow0KKwkJc2V0X3BhZ2VfZXh0KHBhZ2Us
IG5ldGJrLCBoZWFkX2lkeCk7DQorCQluZXRiay0+bW1hcF9wYWdlc1toZWFkX2lkeF0gPSBwYWdl
Ow0KKwkJZnJhZ19zZXRfcGVuZGluZ19pZHgoJmZyYWdzW3NoaW5mby0+bnJfZnJhZ3NdLCBoZWFk
X2lkeCk7DQogCX0NCiANCisJQlVHX09OKHNoaW5mby0+bnJfZnJhZ3MgPiBNQVhfU0tCX0ZSQUdT
KTsNCisNCiAJcmV0dXJuIGdvcDsNCiBlcnI6DQogCS8qIFVud2luZCwgZnJlZWluZyBhbGwgcGFn
ZXMgYW5kIHNlbmRpbmcgZXJyb3IgcmVzcG9uc2VzLiAqLw0KLQl3aGlsZSAoaS0tID4gc3RhcnQp
IHsNCi0JCXhlbl9uZXRia19pZHhfcmVsZWFzZShuZXRiaywgZnJhZ19nZXRfcGVuZGluZ19pZHgo
JmZyYWdzW2ldKSwNCi0JCQkJICAgICAgWEVOX05FVElGX1JTUF9FUlJPUik7DQorCXdoaWxlIChz
aGluZm8tPm5yX2ZyYWdzLS0gPiBzdGFydCkgew0KKwkJeGVuX25ldGJrX2lkeF9yZWxlYXNlKG5l
dGJrLA0KKwkJCQlmcmFnX2dldF9wZW5kaW5nX2lkeCgmZnJhZ3Nbc2hpbmZvLT5ucl9mcmFnc10p
LA0KKwkJCQlYRU5fTkVUSUZfUlNQX0VSUk9SKTsNCiAJfQ0KIAkvKiBUaGUgaGVhZCB0b28sIGlm
IG5lY2Vzc2FyeS4gKi8NCiAJaWYgKHN0YXJ0KQ0KQEAgLTk5NCw4ICsxMTQ4LDEwIEBAIHN0YXRp
YyBpbnQgeGVuX25ldGJrX3R4X2NoZWNrX2dvcChzdHJ1Y3QgeGVuX25ldGJrICpuZXRiaywNCiAJ
c3RydWN0IGdudHRhYl9jb3B5ICpnb3AgPSAqZ29wcDsNCiAJdTE2IHBlbmRpbmdfaWR4ID0gKigo
dTE2ICopc2tiLT5kYXRhKTsNCiAJc3RydWN0IHNrYl9zaGFyZWRfaW5mbyAqc2hpbmZvID0gc2ti
X3NoaW5mbyhza2IpOw0KKwlzdHJ1Y3QgcGVuZGluZ190eF9pbmZvICp0eF9pbmZvOw0KIAlpbnQg
bnJfZnJhZ3MgPSBzaGluZm8tPm5yX2ZyYWdzOw0KIAlpbnQgaSwgZXJyLCBzdGFydDsNCisJdTE2
IHBlZWs7IC8qIHBlZWsgaW50byBuZXh0IHR4IHJlcXVlc3QgKi8NCiANCiAJLyogQ2hlY2sgc3Rh
dHVzIG9mIGhlYWRlci4gKi8NCiAJZXJyID0gZ29wLT5zdGF0dXM7DQpAQCAtMTAwNywxMSArMTE2
MywyMCBAQCBzdGF0aWMgaW50IHhlbl9uZXRia190eF9jaGVja19nb3Aoc3RydWN0IHhlbl9uZXRi
ayAqbmV0YmssDQogDQogCWZvciAoaSA9IHN0YXJ0OyBpIDwgbnJfZnJhZ3M7IGkrKykgew0KIAkJ
aW50IGosIG5ld2VycjsNCisJCXBlbmRpbmdfcmluZ19pZHhfdCBoZWFkOw0KIA0KIAkJcGVuZGlu
Z19pZHggPSBmcmFnX2dldF9wZW5kaW5nX2lkeCgmc2hpbmZvLT5mcmFnc1tpXSk7DQorCQl0eF9p
bmZvID0gJm5ldGJrLT5wZW5kaW5nX3R4X2luZm9bcGVuZGluZ19pZHhdOw0KKwkJaGVhZCA9IHR4
X2luZm8tPmhlYWQ7DQogDQogCQkvKiBDaGVjayBlcnJvciBzdGF0dXM6IGlmIG9rYXkgdGhlbiBy
ZW1lbWJlciBncmFudCBoYW5kbGUuICovDQotCQluZXdlcnIgPSAoKytnb3ApLT5zdGF0dXM7DQor
CQlkbyB7DQorCQkJbmV3ZXJyID0gKCsrZ29wKS0+c3RhdHVzOw0KKwkJCWlmIChuZXdlcnIpDQor
CQkJCWJyZWFrOw0KKwkJCXBlZWsgPSBuZXRiay0+cGVuZGluZ19yaW5nW3BlbmRpbmdfaW5kZXgo
KytoZWFkKV07DQorCQl9IHdoaWxlICghcGVuZGluZ190eF9pc19oZWFkKG5ldGJrLCBwZWVrKSk7
DQorDQogCQlpZiAobGlrZWx5KCFuZXdlcnIpKSB7DQogCQkJLyogSGFkIGEgcHJldmlvdXMgZXJy
b3I/IEludmFsaWRhdGUgdGhpcyBmcmFnbWVudC4gKi8NCiAJCQlpZiAodW5saWtlbHkoZXJyKSkN
CkBAIC0xMjM2LDExICsxNDAxLDEyIEBAIHN0YXRpYyB1bnNpZ25lZCB4ZW5fbmV0YmtfdHhfYnVp
bGRfZ29wcyhzdHJ1Y3QgeGVuX25ldGJrICpuZXRiaykNCiAJc3RydWN0IHNrX2J1ZmYgKnNrYjsN
CiAJaW50IHJldDsNCiANCi0Jd2hpbGUgKCgobnJfcGVuZGluZ19yZXFzKG5ldGJrKSArIE1BWF9T
S0JfRlJBR1MpIDwgTUFYX1BFTkRJTkdfUkVRUykgJiYNCisJd2hpbGUgKChucl9wZW5kaW5nX3Jl
cXMobmV0YmspICsgWEVOX05FVEJLX0xFR0FDWV9TTE9UU19NQVgNCisJCTwgTUFYX1BFTkRJTkdf
UkVRUykgJiYNCiAJCSFsaXN0X2VtcHR5KCZuZXRiay0+bmV0X3NjaGVkdWxlX2xpc3QpKSB7DQog
CQlzdHJ1Y3QgeGVudmlmICp2aWY7DQogCQlzdHJ1Y3QgeGVuX25ldGlmX3R4X3JlcXVlc3QgdHhy
ZXE7DQotCQlzdHJ1Y3QgeGVuX25ldGlmX3R4X3JlcXVlc3QgdHhmcmFnc1tNQVhfU0tCX0ZSQUdT
XTsNCisJCXN0cnVjdCB4ZW5fbmV0aWZfdHhfcmVxdWVzdCB0eGZyYWdzW1hFTl9ORVRCS19MRUdB
Q1lfU0xPVFNfTUFYXTsNCiAJCXN0cnVjdCBwYWdlICpwYWdlOw0KIAkJc3RydWN0IHhlbl9uZXRp
Zl9leHRyYV9pbmZvIGV4dHJhc1tYRU5fTkVUSUZfRVhUUkFfVFlQRV9NQVgtMV07DQogCQl1MTYg
cGVuZGluZ19pZHg7DQpAQCAtMTMyOCw3ICsxNDk0LDcgQEAgc3RhdGljIHVuc2lnbmVkIHhlbl9u
ZXRia190eF9idWlsZF9nb3BzKHN0cnVjdCB4ZW5fbmV0YmsgKm5ldGJrKQ0KIAkJcGVuZGluZ19p
ZHggPSBuZXRiay0+cGVuZGluZ19yaW5nW2luZGV4XTsNCiANCiAJCWRhdGFfbGVuID0gKHR4cmVx
LnNpemUgPiBQS1RfUFJPVF9MRU4gJiYNCi0JCQkgICAgcmV0IDwgTUFYX1NLQl9GUkFHUykgPw0K
KwkJCSAgICByZXQgPCBYRU5fTkVUQktfTEVHQUNZX1NMT1RTX01BWCkgPw0KIAkJCVBLVF9QUk9U
X0xFTiA6IHR4cmVxLnNpemU7DQogDQogCQlza2IgPSBhbGxvY19za2IoZGF0YV9sZW4gKyBORVRf
U0tCX1BBRCArIE5FVF9JUF9BTElHTiwNCkBAIC0xMzU1LDE1ICsxNTIxLDEzIEBAIHN0YXRpYyB1
bnNpZ25lZCB4ZW5fbmV0YmtfdHhfYnVpbGRfZ29wcyhzdHJ1Y3QgeGVuX25ldGJrICpuZXRiaykN
CiAJCX0NCiANCiAJCS8qIFhYWCBjb3VsZCBjb3B5IHN0cmFpZ2h0IHRvIGhlYWQgKi8NCi0JCXBh
Z2UgPSB4ZW5fbmV0YmtfYWxsb2NfcGFnZShuZXRiaywgc2tiLCBwZW5kaW5nX2lkeCk7DQorCQlw
YWdlID0geGVuX25ldGJrX2FsbG9jX3BhZ2UobmV0YmssIHBlbmRpbmdfaWR4KTsNCiAJCWlmICgh
cGFnZSkgew0KIAkJCWtmcmVlX3NrYihza2IpOw0KIAkJCW5ldGJrX3R4X2Vycih2aWYsICZ0eHJl
cSwgaWR4KTsNCiAJCQljb250aW51ZTsNCiAJCX0NCiANCi0JCW5ldGJrLT5tbWFwX3BhZ2VzW3Bl
bmRpbmdfaWR4XSA9IHBhZ2U7DQotDQogCQlnb3AtPnNvdXJjZS51LnJlZiA9IHR4cmVxLmdyZWY7
DQogCQlnb3AtPnNvdXJjZS5kb21pZCA9IHZpZi0+ZG9taWQ7DQogCQlnb3AtPnNvdXJjZS5vZmZz
ZXQgPSB0eHJlcS5vZmZzZXQ7DQpAQCAtMTM4MCw2ICsxNTQ0LDcgQEAgc3RhdGljIHVuc2lnbmVk
IHhlbl9uZXRia190eF9idWlsZF9nb3BzKHN0cnVjdCB4ZW5fbmV0YmsgKm5ldGJrKQ0KIAkJbWVt
Y3B5KCZuZXRiay0+cGVuZGluZ190eF9pbmZvW3BlbmRpbmdfaWR4XS5yZXEsDQogCQkgICAgICAg
JnR4cmVxLCBzaXplb2YodHhyZXEpKTsNCiAJCW5ldGJrLT5wZW5kaW5nX3R4X2luZm9bcGVuZGlu
Z19pZHhdLnZpZiA9IHZpZjsNCisJCW5ldGJrLT5wZW5kaW5nX3R4X2luZm9bcGVuZGluZ19pZHhd
LmhlYWQgPSBpbmRleDsNCiAJCSooKHUxNiAqKXNrYi0+ZGF0YSkgPSBwZW5kaW5nX2lkeDsNCiAN
CiAJCV9fc2tiX3B1dChza2IsIGRhdGFfbGVuKTsNCkBAIC0xNTEwLDcgKzE2NzUsMTAgQEAgc3Rh
dGljIHZvaWQgeGVuX25ldGJrX2lkeF9yZWxlYXNlKHN0cnVjdCB4ZW5fbmV0YmsgKm5ldGJrLCB1
MTYgcGVuZGluZ19pZHgsDQogew0KIAlzdHJ1Y3QgeGVudmlmICp2aWY7DQogCXN0cnVjdCBwZW5k
aW5nX3R4X2luZm8gKnBlbmRpbmdfdHhfaW5mbzsNCi0JcGVuZGluZ19yaW5nX2lkeF90IGluZGV4
Ow0KKwlwZW5kaW5nX3JpbmdfaWR4X3QgaGVhZDsNCisJdTE2IHBlZWs7IC8qIHBlZWsgaW50byBu
ZXh0IHR4IHJlcXVlc3QgKi8NCisNCisJQlVHX09OKG5ldGJrLT5tbWFwX3BhZ2VzW3BlbmRpbmdf
aWR4XSA9PSAodm9pZCAqKSh+MFVMKSk7DQogDQogCS8qIEFscmVhZHkgY29tcGxldGU/ICovDQog
CWlmIChuZXRiay0+bW1hcF9wYWdlc1twZW5kaW5nX2lkeF0gPT0gTlVMTCkNCkBAIC0xNTE5LDE5
ICsxNjg3LDQwIEBAIHN0YXRpYyB2b2lkIHhlbl9uZXRia19pZHhfcmVsZWFzZShzdHJ1Y3QgeGVu
X25ldGJrICpuZXRiaywgdTE2IHBlbmRpbmdfaWR4LA0KIAlwZW5kaW5nX3R4X2luZm8gPSAmbmV0
YmstPnBlbmRpbmdfdHhfaW5mb1twZW5kaW5nX2lkeF07DQogDQogCXZpZiA9IHBlbmRpbmdfdHhf
aW5mby0+dmlmOw0KKwloZWFkID0gcGVuZGluZ190eF9pbmZvLT5oZWFkOw0KKw0KKwlCVUdfT04o
IXBlbmRpbmdfdHhfaXNfaGVhZChuZXRiaywgaGVhZCkpOw0KKwlCVUdfT04obmV0YmstPnBlbmRp
bmdfcmluZ1twZW5kaW5nX2luZGV4KGhlYWQpXSAhPSBwZW5kaW5nX2lkeCk7DQogDQotCW1ha2Vf
dHhfcmVzcG9uc2UodmlmLCAmcGVuZGluZ190eF9pbmZvLT5yZXEsIHN0YXR1cyk7DQorCWRvIHsN
CisJCXBlbmRpbmdfcmluZ19pZHhfdCBpbmRleDsNCisJCXBlbmRpbmdfcmluZ19pZHhfdCBpZHgg
PSBwZW5kaW5nX2luZGV4KGhlYWQpOw0KKwkJdTE2IGluZm9faWR4ID0gbmV0YmstPnBlbmRpbmdf
cmluZ1tpZHhdOw0KIA0KLQlpbmRleCA9IHBlbmRpbmdfaW5kZXgobmV0YmstPnBlbmRpbmdfcHJv
ZCsrKTsNCi0JbmV0YmstPnBlbmRpbmdfcmluZ1tpbmRleF0gPSBwZW5kaW5nX2lkeDsNCisJCXBl
bmRpbmdfdHhfaW5mbyA9ICZuZXRiay0+cGVuZGluZ190eF9pbmZvW2luZm9faWR4XTsNCisJCW1h
a2VfdHhfcmVzcG9uc2UodmlmLCAmcGVuZGluZ190eF9pbmZvLT5yZXEsIHN0YXR1cyk7DQogDQot
CXhlbnZpZl9wdXQodmlmKTsNCisJCS8qIFNldHRpbmcgYW55IG51bWJlciBvdGhlciB0aGFuDQor
CQkgKiBJTlZBTElEX1BFTkRJTkdfUklOR19JRFggaW5kaWNhdGVzIHRoaXMgc2xvdCBpcw0KKwkJ
ICogc3RhcnRpbmcgYSBuZXcgcGFja2V0IC8gZW5kaW5nIGEgcHJldmlvdXMgcGFja2V0Lg0KKwkJ
ICovDQorCQlwZW5kaW5nX3R4X2luZm8tPmhlYWQgPSAwOw0KKw0KKwkJaW5kZXggPSBwZW5kaW5n
X2luZGV4KG5ldGJrLT5wZW5kaW5nX3Byb2QrKyk7DQorCQluZXRiay0+cGVuZGluZ19yaW5nW2lu
ZGV4XSA9IG5ldGJrLT5wZW5kaW5nX3JpbmdbaW5mb19pZHhdOw0KKw0KKwkJeGVudmlmX3B1dCh2
aWYpOw0KKw0KKwkJcGVlayA9IG5ldGJrLT5wZW5kaW5nX3JpbmdbcGVuZGluZ19pbmRleCgrK2hl
YWQpXTsNCisNCisJfSB3aGlsZSAoIXBlbmRpbmdfdHhfaXNfaGVhZChuZXRiaywgcGVlaykpOw0K
IA0KIAluZXRiay0+bW1hcF9wYWdlc1twZW5kaW5nX2lkeF0tPm1hcHBpbmcgPSAwOw0KIAlwdXRf
cGFnZShuZXRiay0+bW1hcF9wYWdlc1twZW5kaW5nX2lkeF0pOw0KIAluZXRiay0+bW1hcF9wYWdl
c1twZW5kaW5nX2lkeF0gPSBOVUxMOw0KIH0NCiANCisNCiBzdGF0aWMgdm9pZCBtYWtlX3R4X3Jl
c3BvbnNlKHN0cnVjdCB4ZW52aWYgKnZpZiwNCiAJCQkgICAgIHN0cnVjdCB4ZW5fbmV0aWZfdHhf
cmVxdWVzdCAqdHhwLA0KIAkJCSAgICAgczggICAgICAgc3QpDQpAQCAtMTU4NCw4ICsxNzczLDkg
QEAgc3RhdGljIGlubGluZSBpbnQgcnhfd29ya190b2RvKHN0cnVjdCB4ZW5fbmV0YmsgKm5ldGJr
KQ0KIHN0YXRpYyBpbmxpbmUgaW50IHR4X3dvcmtfdG9kbyhzdHJ1Y3QgeGVuX25ldGJrICpuZXRi
aykNCiB7DQogDQotCWlmICgoKG5yX3BlbmRpbmdfcmVxcyhuZXRiaykgKyBNQVhfU0tCX0ZSQUdT
KSA8IE1BWF9QRU5ESU5HX1JFUVMpICYmDQotCQkJIWxpc3RfZW1wdHkoJm5ldGJrLT5uZXRfc2No
ZWR1bGVfbGlzdCkpDQorCWlmICgobnJfcGVuZGluZ19yZXFzKG5ldGJrKSArIFhFTl9ORVRCS19M
RUdBQ1lfU0xPVFNfTUFYDQorCSAgICAgPCBNQVhfUEVORElOR19SRVFTKSAmJg0KKwkgICAgICFs
aXN0X2VtcHR5KCZuZXRiay0+bmV0X3NjaGVkdWxlX2xpc3QpKQ0KIAkJcmV0dXJuIDE7DQogDQog
CXJldHVybiAwOw0KQEAgLTE2NjgsNiArMTg1OCwxMyBAQCBzdGF0aWMgaW50IF9faW5pdCBuZXRi
YWNrX2luaXQodm9pZCkNCiAJaWYgKCF4ZW5fcHZfZG9tYWluKCkpDQogCQlyZXR1cm4gLUVOT0RF
VjsNCiANCisJaWYgKGZhdGFsX3NrYl9zbG90cyA8IFhFTl9ORVRCS19MRUdBQ1lfU0xPVFNfTUFY
KSB7DQorCQlwcmludGsoS0VSTl9JTkZPDQorCQkgICAgICAgInhlbi1uZXRiYWNrOiBmYXRhbF9z
a2Jfc2xvdHMgdG9vIHNtYWxsICglZCksIGJ1bXAgaXQgdG8gWEVOX05FVEJLX0xFR0FDWV9TTE9U
U19NQVggKCVkKVxuIiwNCisJCSAgICAgICBmYXRhbF9za2Jfc2xvdHMsIFhFTl9ORVRCS19MRUdB
Q1lfU0xPVFNfTUFYKTsNCisJCWZhdGFsX3NrYl9zbG90cyA9IFhFTl9ORVRCS19MRUdBQ1lfU0xP
VFNfTUFYOw0KKwl9DQorDQogCXhlbl9uZXRia19ncm91cF9uciA9IG51bV9vbmxpbmVfY3B1cygp
Ow0KIAl4ZW5fbmV0YmsgPSB2emFsbG9jKHNpemVvZihzdHJ1Y3QgeGVuX25ldGJrKSAqIHhlbl9u
ZXRia19ncm91cF9ucik7DQogCWlmICgheGVuX25ldGJrKSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQveGVuLW5ldGZyb250LmMgYi9kcml2ZXJzL25ldC94ZW4tbmV0ZnJvbnQuYw0KaW5kZXgg
OWI5ODQzZS4uMGQ5OTE0YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3hlbi1uZXRmcm9udC5j
DQorKysgYi9kcml2ZXJzL25ldC94ZW4tbmV0ZnJvbnQuYw0KQEAgLTM2LDcgKzM2LDcgQEANCiAj
aW5jbHVkZSA8bGludXgvc2tidWZmLmg+DQogI2luY2x1ZGUgPGxpbnV4L2V0aHRvb2wuaD4NCiAj
aW5jbHVkZSA8bGludXgvaWZfZXRoZXIuaD4NCi0jaW5jbHVkZSA8bGludXgvdGNwLmg+DQorI2lu
Y2x1ZGUgPG5ldC90Y3AuaD4NCiAjaW5jbHVkZSA8bGludXgvdWRwLmg+DQogI2luY2x1ZGUgPGxp
bnV4L21vZHVsZXBhcmFtLmg+DQogI2luY2x1ZGUgPGxpbnV4L21tLmg+DQpAQCAtNDkwLDYgKzQ5
MCwxNiBAQCBzdGF0aWMgaW50IHhlbm5ldF9zdGFydF94bWl0KHN0cnVjdCBza19idWZmICpza2Is
IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQogCXVuc2lnbmVkIGludCBvZmZzZXQgPSBvZmZzZXRf
aW5fcGFnZShkYXRhKTsNCiAJdW5zaWduZWQgaW50IGxlbiA9IHNrYl9oZWFkbGVuKHNrYik7DQog
DQorCS8qIElmIHNrYi0+bGVuIGlzIHRvbyBiaWcgZm9yIHdpcmUgZm9ybWF0LCBkcm9wIHNrYiBh
bmQgYWxlcnQNCisJICogdXNlciBhYm91dCBtaXNjb25maWd1cmF0aW9uLg0KKwkgKi8NCisJaWYg
KHVubGlrZWx5KHNrYi0+bGVuID4gWEVOX05FVElGX01BWF9UWF9TSVpFKSkgew0KKwkJbmV0X2Fs
ZXJ0X3JhdGVsaW1pdGVkKA0KKwkJCSJ4ZW5uZXQ6IHNrYi0+bGVuID0gJXUsIHRvbyBiaWcgZm9y
IHdpcmUgZm9ybWF0XG4iLA0KKwkJCXNrYi0+bGVuKTsNCisJCWdvdG8gZHJvcDsNCisJfQ0KKw0K
IAlmcmFncyArPSBESVZfUk9VTkRfVVAob2Zmc2V0ICsgbGVuLCBQQUdFX1NJWkUpOw0KIAlpZiAo
dW5saWtlbHkoZnJhZ3MgPiBNQVhfU0tCX0ZSQUdTICsgMSkpIHsNCiAJCXByaW50ayhLRVJOX0FM
RVJUICJ4ZW5uZXQ6IHNrYiByaWRlcyB0aGUgcm9ja2V0OiAlZCBmcmFnc1xuIiwNCkBAIC0xMDQz
LDcgKzEwNTMsOCBAQCBlcnI6DQogDQogc3RhdGljIGludCB4ZW5uZXRfY2hhbmdlX210dShzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2LCBpbnQgbXR1KQ0KIHsNCi0JaW50IG1heCA9IHhlbm5ldF9jYW5f
c2coZGV2KSA/IDY1NTM1IC0gRVRIX0hMRU4gOiBFVEhfREFUQV9MRU47DQorCWludCBtYXggPSB4
ZW5uZXRfY2FuX3NnKGRldikgPw0KKwkJWEVOX05FVElGX01BWF9UWF9TSVpFIC0gTUFYX1RDUF9I
RUFERVIgOiBFVEhfREFUQV9MRU47DQogDQogCWlmIChtdHUgPiBtYXgpDQogCQlyZXR1cm4gLUVJ
TlZBTDsNCkBAIC0xMzE4LDYgKzEzMjksOCBAQCBzdGF0aWMgc3RydWN0IG5ldF9kZXZpY2UgKiBf
X2RldmluaXQgeGVubmV0X2NyZWF0ZV9kZXYoc3RydWN0IHhlbmJ1c19kZXZpY2UgKmRldg0KIAlT
RVRfRVRIVE9PTF9PUFMobmV0ZGV2LCAmeGVubmV0X2V0aHRvb2xfb3BzKTsNCiAJU0VUX05FVERF
Vl9ERVYobmV0ZGV2LCAmZGV2LT5kZXYpOw0KIA0KKwluZXRpZl9zZXRfZ3NvX21heF9zaXplKG5l
dGRldiwgWEVOX05FVElGX01BWF9UWF9TSVpFIC0gTUFYX1RDUF9IRUFERVIpOw0KKw0KIAlucC0+
bmV0ZGV2ID0gbmV0ZGV2Ow0KIA0KIAluZXRpZl9jYXJyaWVyX29mZihuZXRkZXYpOw0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L3RoaW5rcGFkX2FjcGkuYyBiL2RyaXZlcnMvcGxh
dGZvcm0veDg2L3RoaW5rcGFkX2FjcGkuYw0KaW5kZXggN2I4Mjg2OC4uOGU2YzRmYSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L3RoaW5rcGFkX2FjcGkuYw0KKysrIGIvZHJpdmVy
cy9wbGF0Zm9ybS94ODYvdGhpbmtwYWRfYWNwaS5jDQpAQCAtODY2NSw2ICs4NjY1LDEzIEBAIHN0
YXRpYyBpbnQgX19tdXN0X2NoZWNrIF9faW5pdCBnZXRfdGhpbmtwYWRfbW9kZWxfZGF0YSgNCiAJ
CXRwLT5tb2RlbF9zdHIgPSBrc3RyZHVwKHMsIEdGUF9LRVJORUwpOw0KIAkJaWYgKCF0cC0+bW9k
ZWxfc3RyKQ0KIAkJCXJldHVybiAtRU5PTUVNOw0KKwl9IGVsc2Ugew0KKwkJcyA9IGRtaV9nZXRf
c3lzdGVtX2luZm8oRE1JX0JJT1NfVkVORE9SKTsNCisJCWlmIChzICYmICEoc3RybmljbXAocywg
Ikxlbm92byIsIDYpKSkgew0KKwkJCXRwLT5tb2RlbF9zdHIgPSBrc3RyZHVwKHMsIEdGUF9LRVJO
RUwpOw0KKwkJCWlmICghdHAtPm1vZGVsX3N0cikNCisJCQkJcmV0dXJuIC1FTk9NRU07DQorCQl9
DQogCX0NCiANCiAJcyA9IGRtaV9nZXRfc3lzdGVtX2luZm8oRE1JX1BST0RVQ1RfTkFNRSk7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9yYXBpZGlvL2RldmljZXMvdHNpNzIxLmMgYi9kcml2ZXJzL3Jh
cGlkaW8vZGV2aWNlcy90c2k3MjEuYw0KaW5kZXggMjNlZjE2Yy4uODRlYWIzZiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvcmFwaWRpby9kZXZpY2VzL3RzaTcyMS5jDQorKysgYi9kcml2ZXJzL3JhcGlk
aW8vZGV2aWNlcy90c2k3MjEuYw0KQEAgLTU1NSw3ICs1NTUsNyBAQCBzdGF0aWMgaXJxcmV0dXJu
X3QgdHNpNzIxX2lycWhhbmRsZXIoaW50IGlycSwgdm9pZCAqcHRyKQ0KIAkvKiBGb3IgTVNJIG1v
ZGUgcmUtZW5hYmxlIGRldmljZS1sZXZlbCBpbnRlcnJ1cHRzICovDQogCWlmIChwcml2LT5mbGFn
cyAmIFRTSTcyMV9VU0lOR19NU0kpIHsNCiAJCWRldl9pbnQgPSBUU0k3MjFfREVWX0lOVF9TUjJQ
Q19DSCB8IFRTSTcyMV9ERVZfSU5UX1NSSU8gfA0KLQkJCVRTSTcyMV9ERVZfSU5UX1NNU0dfQ0gg
fCBUU0k3MjFfREVWX0lOVF9CRE1BX0NIOw0KKwkJCVRTSTcyMV9ERVZfSU5UX1NNU0dfQ0g7DQog
CQlpb3dyaXRlMzIoZGV2X2ludCwgcHJpdi0+cmVncyArIFRTSTcyMV9ERVZfSU5URSk7DQogCX0N
CiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3J0Yy9ydGMtdHdsLmMgYi9kcml2ZXJzL3J0Yy9ydGMt
dHdsLmMNCmluZGV4IGEzZTk4ZjEuLmIzN2M4YjAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3J0Yy9y
dGMtdHdsLmMNCisrKyBiL2RyaXZlcnMvcnRjL3J0Yy10d2wuYw0KQEAgLTQ5MCw2ICs0OTAsNyBA
QCBzdGF0aWMgaW50IF9fZGV2aW5pdCB0d2xfcnRjX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpDQogCX0NCiANCiAJcGxhdGZvcm1fc2V0X2RydmRhdGEocGRldiwgcnRjKTsNCisJ
ZGV2aWNlX2luaXRfd2FrZXVwKCZwZGV2LT5kZXYsIDEpOw0KIAlyZXR1cm4gMDsNCiANCiBvdXQy
Og0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9nbWE1MDAvY2R2X2ludGVsX2Rpc3BsYXku
YyBiL2RyaXZlcnMvc3RhZ2luZy9nbWE1MDAvY2R2X2ludGVsX2Rpc3BsYXkuYw0KaW5kZXggN2I5
N2M2MC4uNjI2YWU0NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9nbWE1MDAvY2R2X2lu
dGVsX2Rpc3BsYXkuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL2dtYTUwMC9jZHZfaW50ZWxfZGlz
cGxheS5jDQpAQCAtMTQ1Nyw2ICsxNDU3LDE5IEBAIHN0YXRpYyB2b2lkIGNkdl9pbnRlbF9jcnRj
X2Rlc3Ryb3koc3RydWN0IGRybV9jcnRjICpjcnRjKQ0KIAlrZnJlZShwc2JfaW50ZWxfY3J0Yyk7
DQogfQ0KIA0KK3N0YXRpYyB2b2lkIGNkdl9pbnRlbF9jcnRjX2Rpc2FibGUoc3RydWN0IGRybV9j
cnRjICpjcnRjKQ0KK3sNCisJc3RydWN0IGd0dF9yYW5nZSAqZ3Q7DQorCXN0cnVjdCBkcm1fY3J0
Y19oZWxwZXJfZnVuY3MgKmNydGNfZnVuY3MgPSBjcnRjLT5oZWxwZXJfcHJpdmF0ZTsNCisNCisJ
Y3J0Y19mdW5jcy0+ZHBtcyhjcnRjLCBEUk1fTU9ERV9EUE1TX09GRik7DQorDQorCWlmIChjcnRj
LT5mYikgew0KKwkJZ3QgPSB0b19wc2JfZmIoY3J0Yy0+ZmIpLT5ndHQ7DQorCQlwc2JfZ3R0X3Vu
cGluKGd0KTsNCisJfQ0KK30NCisNCiBjb25zdCBzdHJ1Y3QgZHJtX2NydGNfaGVscGVyX2Z1bmNz
IGNkdl9pbnRlbF9oZWxwZXJfZnVuY3MgPSB7DQogCS5kcG1zID0gY2R2X2ludGVsX2NydGNfZHBt
cywNCiAJLm1vZGVfZml4dXAgPSBjZHZfaW50ZWxfY3J0Y19tb2RlX2ZpeHVwLA0KQEAgLTE0NjQs
NiArMTQ3Nyw3IEBAIGNvbnN0IHN0cnVjdCBkcm1fY3J0Y19oZWxwZXJfZnVuY3MgY2R2X2ludGVs
X2hlbHBlcl9mdW5jcyA9IHsNCiAJLm1vZGVfc2V0X2Jhc2UgPSBjZHZfaW50ZWxfcGlwZV9zZXRf
YmFzZSwNCiAJLnByZXBhcmUgPSBjZHZfaW50ZWxfY3J0Y19wcmVwYXJlLA0KIAkuY29tbWl0ID0g
Y2R2X2ludGVsX2NydGNfY29tbWl0LA0KKwkuZGlzYWJsZSA9IGNkdl9pbnRlbF9jcnRjX2Rpc2Fi
bGUsDQogfTsNCiANCiBjb25zdCBzdHJ1Y3QgZHJtX2NydGNfZnVuY3MgY2R2X2ludGVsX2NydGNf
ZnVuY3MgPSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL2dtYTUwMC9mcmFtZWJ1ZmZl
ci5jIGIvZHJpdmVycy9zdGFnaW5nL2dtYTUwMC9mcmFtZWJ1ZmZlci5jDQppbmRleCAzZjM5YTM3
Li5kMjhmZGMyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL2dtYTUwMC9mcmFtZWJ1ZmZl
ci5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvZ21hNTAwL2ZyYW1lYnVmZmVyLmMNCkBAIC04MzEs
OCArODMxLDggQEAgdm9pZCBwc2JfbW9kZXNldF9pbml0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYp
DQogCWZvciAoaSA9IDA7IGkgPCBkZXZfcHJpdi0+bnVtX3BpcGU7IGkrKykNCiAJCXBzYl9pbnRl
bF9jcnRjX2luaXQoZGV2LCBpLCBtb2RlX2Rldik7DQogDQotCWRldi0+bW9kZV9jb25maWcubWF4
X3dpZHRoID0gMjA0ODsNCi0JZGV2LT5tb2RlX2NvbmZpZy5tYXhfaGVpZ2h0ID0gMjA0ODsNCisJ
ZGV2LT5tb2RlX2NvbmZpZy5tYXhfd2lkdGggPSA0MDk2Ow0KKwlkZXYtPm1vZGVfY29uZmlnLm1h
eF9oZWlnaHQgPSA0MDk2Ow0KIA0KIAlwc2Jfc2V0dXBfb3V0cHV0cyhkZXYpOw0KIH0NCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvZ21hNTAwL3BzYl9pbnRlbF9kaXNwbGF5LmMgYi9kcml2
ZXJzL3N0YWdpbmcvZ21hNTAwL3BzYl9pbnRlbF9kaXNwbGF5LmMNCmluZGV4IGNhYTlkODYuLjBk
ODcyZTkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvZ21hNTAwL3BzYl9pbnRlbF9kaXNw
bGF5LmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9nbWE1MDAvcHNiX2ludGVsX2Rpc3BsYXkuYw0K
QEAgLTEyNTUsNiArMTI1NSwxOSBAQCB2b2lkIHBzYl9pbnRlbF9jcnRjX2Rlc3Ryb3koc3RydWN0
IGRybV9jcnRjICpjcnRjKQ0KIAlrZnJlZShwc2JfaW50ZWxfY3J0Yyk7DQogfQ0KIA0KK3N0YXRp
YyB2b2lkIHBzYl9pbnRlbF9jcnRjX2Rpc2FibGUoc3RydWN0IGRybV9jcnRjICpjcnRjKQ0KK3sN
CisJc3RydWN0IGd0dF9yYW5nZSAqZ3Q7DQorCXN0cnVjdCBkcm1fY3J0Y19oZWxwZXJfZnVuY3Mg
KmNydGNfZnVuY3MgPSBjcnRjLT5oZWxwZXJfcHJpdmF0ZTsNCisNCisJY3J0Y19mdW5jcy0+ZHBt
cyhjcnRjLCBEUk1fTU9ERV9EUE1TX09GRik7DQorDQorCWlmIChjcnRjLT5mYikgew0KKwkJZ3Qg
PSB0b19wc2JfZmIoY3J0Yy0+ZmIpLT5ndHQ7DQorCQlwc2JfZ3R0X3VucGluKGd0KTsNCisJfQ0K
K30NCisNCiBjb25zdCBzdHJ1Y3QgZHJtX2NydGNfaGVscGVyX2Z1bmNzIHBzYl9pbnRlbF9oZWxw
ZXJfZnVuY3MgPSB7DQogCS5kcG1zID0gcHNiX2ludGVsX2NydGNfZHBtcywNCiAJLm1vZGVfZml4
dXAgPSBwc2JfaW50ZWxfY3J0Y19tb2RlX2ZpeHVwLA0KQEAgLTEyNjIsNiArMTI3NSw3IEBAIGNv
bnN0IHN0cnVjdCBkcm1fY3J0Y19oZWxwZXJfZnVuY3MgcHNiX2ludGVsX2hlbHBlcl9mdW5jcyA9
IHsNCiAJLm1vZGVfc2V0X2Jhc2UgPSBwc2JfaW50ZWxfcGlwZV9zZXRfYmFzZSwNCiAJLnByZXBh
cmUgPSBwc2JfaW50ZWxfY3J0Y19wcmVwYXJlLA0KIAkuY29tbWl0ID0gcHNiX2ludGVsX2NydGNf
Y29tbWl0LA0KKwkuZGlzYWJsZSA9IHBzYl9pbnRlbF9jcnRjX2Rpc2FibGUsDQogfTsNCiANCiBj
b25zdCBzdHJ1Y3QgZHJtX2NydGNfZnVuY3MgcHNiX2ludGVsX2NydGNfZnVuY3MgPSB7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X3BhcmFtZXRlcnMuYyBi
L2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9wYXJhbWV0ZXJzLmMNCmluZGV4IDVi
NzczMTYuLmRiMzEzYmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90
YXJnZXRfcGFyYW1ldGVycy5jDQorKysgYi9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJn
ZXRfcGFyYW1ldGVycy5jDQpAQCAtNzEzLDkgKzcxMyw5IEBAIHN0YXRpYyBpbnQgaXNjc2lfYWRk
X25vdHVuZGVyc3Rvb2RfcmVzcG9uc2UoDQogCX0NCiAJSU5JVF9MSVNUX0hFQUQoJmV4dHJhX3Jl
c3BvbnNlLT5lcl9saXN0KTsNCiANCi0Jc3RybmNweShleHRyYV9yZXNwb25zZS0+a2V5LCBrZXks
IHN0cmxlbihrZXkpICsgMSk7DQotCXN0cm5jcHkoZXh0cmFfcmVzcG9uc2UtPnZhbHVlLCBOT1RV
TkRFUlNUT09ELA0KLQkJCXN0cmxlbihOT1RVTkRFUlNUT09EKSArIDEpOw0KKwlzdHJsY3B5KGV4
dHJhX3Jlc3BvbnNlLT5rZXksIGtleSwgc2l6ZW9mKGV4dHJhX3Jlc3BvbnNlLT5rZXkpKTsNCisJ
c3RybGNweShleHRyYV9yZXNwb25zZS0+dmFsdWUsIE5PVFVOREVSU1RPT0QsDQorCQlzaXplb2Yo
ZXh0cmFfcmVzcG9uc2UtPnZhbHVlKSk7DQogDQogCWxpc3RfYWRkX3RhaWwoJmV4dHJhX3Jlc3Bv
bnNlLT5lcl9saXN0LA0KIAkJCSZwYXJhbV9saXN0LT5leHRyYV9yZXNwb25zZV9saXN0KTsNCkBA
IC0xNTcyLDggKzE1NzIsNiBAQCBpbnQgaXNjc2lfZGVjb2RlX3RleHRfaW5wdXQoDQogDQogCQlp
ZiAocGhhc2UgJiBQSEFTRV9TRUNVUklUWSkgew0KIAkJCWlmIChpc2NzaV9jaGVja19mb3JfYXV0
aF9rZXkoa2V5KSA+IDApIHsNCi0JCQkJY2hhciAqdG1wcHRyID0ga2V5ICsgc3RybGVuKGtleSk7
DQotCQkJCSp0bXBwdHIgPSAnPSc7DQogCQkJCWtmcmVlKHRtcGJ1Zik7DQogCQkJCXJldHVybiAx
Ow0KIAkJCX0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXRf
cGFyYW1ldGVycy5oIGIvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X3BhcmFtZXRl
cnMuaA0KaW5kZXggNmEzN2ZkNi4uODNlZWQ2NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdGFyZ2V0
L2lzY3NpL2lzY3NpX3RhcmdldF9wYXJhbWV0ZXJzLmgNCisrKyBiL2RyaXZlcnMvdGFyZ2V0L2lz
Y3NpL2lzY3NpX3RhcmdldF9wYXJhbWV0ZXJzLmgNCkBAIC0xLDggKzEsMTAgQEANCiAjaWZuZGVm
IElTQ1NJX1BBUkFNRVRFUlNfSA0KICNkZWZpbmUgSVNDU0lfUEFSQU1FVEVSU19IDQogDQorI2lu
Y2x1ZGUgPHNjc2kvaXNjc2lfcHJvdG8uaD4NCisNCiBzdHJ1Y3QgaXNjc2lfZXh0cmFfcmVzcG9u
c2Ugew0KLQljaGFyIGtleVs2NF07DQorCWNoYXIga2V5W0tFWV9NQVhMRU5dOw0KIAljaGFyIHZh
bHVlWzMyXTsNCiAJc3RydWN0IGxpc3RfaGVhZCBlcl9saXN0Ow0KIH0gX19fX2NhY2hlbGluZV9h
bGlnbmVkOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2ZXJz
L3VzYi9kd2MzL2dhZGdldC5jDQppbmRleCBlOTYzN2Y5Li5iMzY4YjgzIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KKysrIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQu
Yw0KQEAgLTEzMTAsMTAgKzEzMTAsMTkgQEAgc3RhdGljIHZvaWQgZHdjM19nYWRnZXRfZnJlZV9l
bmRwb2ludHMoc3RydWN0IGR3YzMgKmR3YykNCiANCiAJZm9yIChlcG51bSA9IDA7IGVwbnVtIDwg
RFdDM19FTkRQT0lOVFNfTlVNOyBlcG51bSsrKSB7DQogCQlkZXAgPSBkd2MtPmVwc1tlcG51bV07
DQotCQlkd2MzX2ZyZWVfdHJiX3Bvb2woZGVwKTsNCi0NCi0JCWlmIChlcG51bSAhPSAwICYmIGVw
bnVtICE9IDEpDQorCQkvKg0KKwkJICogUGh5c2ljYWwgZW5kcG9pbnRzIDAgYW5kIDEgYXJlIHNw
ZWNpYWw7IHRoZXkgZm9ybSB0aGUNCisJCSAqIGJpLWRpcmVjdGlvbmFsIFVTQiBlbmRwb2ludCAw
Lg0KKwkJICoNCisJCSAqIEZvciB0aG9zZSB0d28gcGh5c2ljYWwgZW5kcG9pbnRzLCB3ZSBkb24n
dCBhbGxvY2F0ZSBhIFRSQg0KKwkJICogcG9vbCBub3IgZG8gd2UgYWRkIHRoZW0gdGhlIGVuZHBv
aW50cyBsaXN0LiBEdWUgdG8gdGhhdCwgd2UNCisJCSAqIHNob3VsZG4ndCBkbyB0aGVzZSB0d28g
b3BlcmF0aW9ucyBvdGhlcndpc2Ugd2Ugd291bGQgZW5kIHVwDQorCQkgKiB3aXRoIGFsbCBzb3J0
cyBvZiBidWdzIHdoZW4gcmVtb3ZpbmcgZHdjMy5rby4NCisJCSAqLw0KKwkJaWYgKGVwbnVtICE9
IDAgJiYgZXBudW0gIT0gMSkgew0KKwkJCWR3YzNfZnJlZV90cmJfcG9vbChkZXApOw0KIAkJCWxp
c3RfZGVsKCZkZXAtPmVuZHBvaW50LmVwX2xpc3QpOw0KKwkJfQ0KIA0KIAkJa2ZyZWUoZGVwKTsN
CiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1zY2hlZC5jIGIvZHJpdmVy
cy91c2IvaG9zdC9laGNpLXNjaGVkLmMNCmluZGV4IDA4ZTQ3MGYuLjM0NjU1ZDAgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3VzYi9ob3N0L2VoY2ktc2NoZWQuYw0KKysrIGIvZHJpdmVycy91c2IvaG9z
dC9laGNpLXNjaGVkLmMNCkBAIC0yMzYsNyArMjM2LDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25l
ZCBjaGFyIHR0X3N0YXJ0X3VmcmFtZShzdHJ1Y3QgZWhjaV9oY2QgKmVoY2ksIF9faGMzMiBtYXNr
KQ0KIH0NCiANCiBzdGF0aWMgY29uc3QgdW5zaWduZWQgY2hhcg0KLW1heF90dF91c2Vjc1tdID0g
eyAxMjUsIDEyNSwgMTI1LCAxMjUsIDEyNSwgMTI1LCAxMjUsIDI1IH07DQorbWF4X3R0X3VzZWNz
W10gPSB7IDEyNSwgMTI1LCAxMjUsIDEyNSwgMTI1LCAxMjUsIDMwLCAwIH07DQogDQogLyogY2Fy
cnlvdmVyIGxvdy9mdWxsc3BlZWQgYmFuZHdpZHRoIHRoYXQgY3Jvc3NlcyB1ZnJhbWUgYm91bmRy
aWVzICovDQogc3RhdGljIGlubGluZSB2b2lkIGNhcnJ5b3Zlcl90dF9iYW5kd2lkdGgodW5zaWdu
ZWQgc2hvcnQgdHRfdXNlY3NbOF0pDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNp
LW1lbS5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLW1lbS5jDQppbmRleCA0MzBjMWQ1Li41MDE4
ZTMzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvaG9zdC94aGNpLW1lbS5jDQorKysgYi9kcml2
ZXJzL3VzYi9ob3N0L3hoY2ktbWVtLmMNCkBAIC0xNzU1LDYgKzE3NTUsOSBAQCB2b2lkIHhoY2lf
bWVtX2NsZWFudXAoc3RydWN0IHhoY2lfaGNkICp4aGNpKQ0KIAl9DQogCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJnhoY2ktPmxvY2ssIGZsYWdzKTsNCiANCisJaWYgKCF4aGNpLT5yaF9idykNCisJ
CWdvdG8gbm9fYnc7DQorDQogCW51bV9wb3J0cyA9IEhDU19NQVhfUE9SVFMoeGhjaS0+aGNzX3Bh
cmFtczEpOw0KIAlmb3IgKGkgPSAwOyBpIDwgbnVtX3BvcnRzOyBpKyspIHsNCiAJCXN0cnVjdCB4
aGNpX2ludGVydmFsX2J3X3RhYmxlICpid3QgPSAmeGhjaS0+cmhfYndbaV0uYndfdGFibGU7DQpA
QCAtMTc3Myw2ICsxNzc2LDcgQEAgdm9pZCB4aGNpX21lbV9jbGVhbnVwKHN0cnVjdCB4aGNpX2hj
ZCAqeGhjaSkNCiAJCX0NCiAJfQ0KIA0KK25vX2J3Og0KIAl4aGNpLT5udW1fdXNiMl9wb3J0cyA9
IDA7DQogCXhoY2ktPm51bV91c2IzX3BvcnRzID0gMDsNCiAJeGhjaS0+bnVtX2FjdGl2ZV9lcHMg
PSAwOw0KQEAgLTIxODQsNiArMjE4OCw5IEBAIGludCB4aGNpX21lbV9pbml0KHN0cnVjdCB4aGNp
X2hjZCAqeGhjaSwgZ2ZwX3QgZmxhZ3MpDQogCXUzMiBwYWdlX3NpemU7DQogCWludCBpOw0KIA0K
KwlJTklUX0xJU1RfSEVBRCgmeGhjaS0+bHBtX2ZhaWxlZF9kZXZzKTsNCisJSU5JVF9MSVNUX0hF
QUQoJnhoY2ktPmNhbmNlbF9jbWRfbGlzdCk7DQorDQogCXBhZ2Vfc2l6ZSA9IHhoY2lfcmVhZGwo
eGhjaSwgJnhoY2ktPm9wX3JlZ3MtPnBhZ2Vfc2l6ZSk7DQogCXhoY2lfZGJnKHhoY2ksICJTdXBw
b3J0ZWQgcGFnZSBzaXplIHJlZ2lzdGVyID0gMHgleFxuIiwgcGFnZV9zaXplKTsNCiAJZm9yIChp
ID0gMDsgaSA8IDE2OyBpKyspIHsNCkBAIC0yMjYyLDcgKzIyNjksNiBAQCBpbnQgeGhjaV9tZW1f
aW5pdChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksIGdmcF90IGZsYWdzKQ0KIAl4aGNpLT5jbWRfcmlu
ZyA9IHhoY2lfcmluZ19hbGxvYyh4aGNpLCAxLCB0cnVlLCBmYWxzZSwgZmxhZ3MpOw0KIAlpZiAo
IXhoY2ktPmNtZF9yaW5nKQ0KIAkJZ290byBmYWlsOw0KLQlJTklUX0xJU1RfSEVBRCgmeGhjaS0+
Y2FuY2VsX2NtZF9saXN0KTsNCiAJeGhjaV9kYmcoeGhjaSwgIkFsbG9jYXRlZCBjb21tYW5kIHJp
bmcgYXQgJXBcbiIsIHhoY2ktPmNtZF9yaW5nKTsNCiAJeGhjaV9kYmcoeGhjaSwgIkZpcnN0IHNl
Z21lbnQgRE1BIGlzIDB4JWxseFxuIiwNCiAJCQkodW5zaWduZWQgbG9uZyBsb25nKXhoY2ktPmNt
ZF9yaW5nLT5maXJzdF9zZWctPmRtYSk7DQpAQCAtMjM2Myw4ICsyMzY5LDYgQEAgaW50IHhoY2lf
bWVtX2luaXQoc3RydWN0IHhoY2lfaGNkICp4aGNpLCBnZnBfdCBmbGFncykNCiAJaWYgKHhoY2lf
c2V0dXBfcG9ydF9hcnJheXMoeGhjaSwgZmxhZ3MpKQ0KIAkJZ290byBmYWlsOw0KIA0KLQlJTklU
X0xJU1RfSEVBRCgmeGhjaS0+bHBtX2ZhaWxlZF9kZXZzKTsNCi0NCiAJcmV0dXJuIDA7DQogDQog
ZmFpbDoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2kuYyBiL2RyaXZlcnMvdXNi
L2hvc3QveGhjaS5jDQppbmRleCAyYzAzNTBmLi4xMzZjMzU3IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy91c2IvaG9zdC94aGNpLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jDQpAQCAtOTM4
LDYgKzkzOCw3IEBAIGludCB4aGNpX3Jlc3VtZShzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksIGJvb2wg
aGliZXJuYXRlZCkNCiAJc3RydWN0IHVzYl9oY2QJCSpoY2QgPSB4aGNpX3RvX2hjZCh4aGNpKTsN
CiAJc3RydWN0IHVzYl9oY2QJCSpzZWNvbmRhcnlfaGNkOw0KIAlpbnQJCQlyZXR2YWwgPSAwOw0K
Kwlib29sCQkJY29tcF90aW1lcl9ydW5uaW5nID0gZmFsc2U7DQogDQogCS8qIFdhaXQgYSBiaXQg
aWYgZWl0aGVyIG9mIHRoZSByb290aHVicyBuZWVkIHRvIHNldHRsZSBmcm9tIHRoZQ0KIAkgKiB0
cmFuc2l0aW9uIGludG8gYnVzIHN1c3BlbmQuDQpAQCAtOTc1LDYgKzk3NiwxMyBAQCBpbnQgeGhj
aV9yZXN1bWUoc3RydWN0IHhoY2lfaGNkICp4aGNpLCBib29sIGhpYmVybmF0ZWQpDQogDQogCS8q
IElmIHJlc3RvcmUgb3BlcmF0aW9uIGZhaWxzLCByZS1pbml0aWFsaXplIHRoZSBIQyBkdXJpbmcg
cmVzdW1lICovDQogCWlmICgodGVtcCAmIFNUU19TUkUpIHx8IGhpYmVybmF0ZWQpIHsNCisNCisJ
CWlmICgoeGhjaS0+cXVpcmtzICYgWEhDSV9DT01QX01PREVfUVVJUkspICYmDQorCQkJCSEoeGhj
aV9hbGxfcG9ydHNfc2Vlbl91MCh4aGNpKSkpIHsNCisJCQlkZWxfdGltZXJfc3luYygmeGhjaS0+
Y29tcF9tb2RlX3JlY292ZXJ5X3RpbWVyKTsNCisJCQl4aGNpX2RiZyh4aGNpLCAiQ29tcGxpYW5j
ZSBNb2RlIFJlY292ZXJ5IFRpbWVyIGRlbGV0ZWQhXG4iKTsNCisJCX0NCisNCiAJCS8qIExldCB0
aGUgVVNCIGNvcmUga25vdyBfYm90aF8gcm9vdGh1YnMgbG9zdCBwb3dlci4gKi8NCiAJCXVzYl9y
b290X2h1Yl9sb3N0X3Bvd2VyKHhoY2ktPm1haW5faGNkLT5zZWxmLnJvb3RfaHViKTsNCiAJCXVz
Yl9yb290X2h1Yl9sb3N0X3Bvd2VyKHhoY2ktPnNoYXJlZF9oY2QtPnNlbGYucm9vdF9odWIpOw0K
QEAgLTEwMTcsNiArMTAyNSw4IEBAIGludCB4aGNpX3Jlc3VtZShzdHJ1Y3QgeGhjaV9oY2QgKnho
Y2ksIGJvb2wgaGliZXJuYXRlZCkNCiAJCXJldHZhbCA9IHhoY2lfaW5pdChoY2QtPnByaW1hcnlf
aGNkKTsNCiAJCWlmIChyZXR2YWwpDQogCQkJcmV0dXJuIHJldHZhbDsNCisJCWNvbXBfdGltZXJf
cnVubmluZyA9IHRydWU7DQorDQogCQl4aGNpX2RiZyh4aGNpLCAiU3RhcnQgdGhlIHByaW1hcnkg
SENEXG4iKTsNCiAJCXJldHZhbCA9IHhoY2lfcnVuKGhjZC0+cHJpbWFyeV9oY2QpOw0KIAkJaWYg
KCFyZXR2YWwpIHsNCkBAIC0xMDU4LDcgKzEwNjgsNyBAQCBpbnQgeGhjaV9yZXN1bWUoc3RydWN0
IHhoY2lfaGNkICp4aGNpLCBib29sIGhpYmVybmF0ZWQpDQogCSAqIHRvIHN1ZmZlciB0aGUgQ29t
cGxpYW5jZSBNb2RlIGlzc3VlIGFnYWluLiBJdCBkb2Vzbid0IG1hdHRlciBpZg0KIAkgKiBwb3J0
cyBoYXZlIGVudGVyZWQgcHJldmlvdXNseSB0byBVMCBiZWZvcmUgc3lzdGVtJ3Mgc3VzcGVuc2lv
bi4NCiAJICovDQotCWlmICh4aGNpLT5xdWlya3MgJiBYSENJX0NPTVBfTU9ERV9RVUlSSykNCisJ
aWYgKCh4aGNpLT5xdWlya3MgJiBYSENJX0NPTVBfTU9ERV9RVUlSSykgJiYgIWNvbXBfdGltZXJf
cnVubmluZykNCiAJCWNvbXBsaWFuY2VfbW9kZV9yZWNvdmVyeV90aW1lcl9pbml0KHhoY2kpOw0K
IA0KIAkvKiBSZS1lbmFibGUgcG9ydCBwb2xsaW5nLiAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dXNiL3NlcmlhbC9hcmszMTE2LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvYXJrMzExNi5jDQppbmRl
eCAzY2E2YzBkLi4xYTcxNWY2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2FyazMx
MTYuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2FyazMxMTYuYw0KQEAgLTQ5LDcgKzQ5LDcg
QEAgc3RhdGljIGludCBkZWJ1ZzsNCiAjZGVmaW5lIERSSVZFUl9OQU1FICJhcmszMTE2Ig0KIA0K
IC8qIHVzYiB0aW1lb3V0IG9mIDEgc2Vjb25kICovDQotI2RlZmluZSBBUktfVElNRU9VVCAoMSpI
WikNCisjZGVmaW5lIEFSS19USU1FT1VUIDEwMDANCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHVz
Yl9kZXZpY2VfaWQgaWRfdGFibGVbXSA9IHsNCiAJeyBVU0JfREVWSUNFKDB4NjU0NywgMHgwMjMy
KSB9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9jeXByZXNzX204LmMgYi9kcml2
ZXJzL3VzYi9zZXJpYWwvY3lwcmVzc19tOC5jDQppbmRleCAwMWE0NGQzLi4xMGMzMGFkIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2N5cHJlc3NfbTguYw0KKysrIGIvZHJpdmVycy91
c2Ivc2VyaWFsL2N5cHJlc3NfbTguYw0KQEAgLTk2LDYgKzk2LDcgQEAgc3RhdGljIGNvbnN0IHN0
cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlX2VhcnRobWF0ZVtdID0gew0KIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBpZF90YWJsZV9jeXBoaWRjb21yczIzMltdID0gew0KIAl7
IFVTQl9ERVZJQ0UoVkVORE9SX0lEX0NZUFJFU1MsIFBST0RVQ1RfSURfQ1lQSElEQ09NKSB9LA0K
IAl7IFVTQl9ERVZJQ0UoVkVORE9SX0lEX1BPV0VSQ09NLCBQUk9EVUNUX0lEX1VQUykgfSwNCisJ
eyBVU0JfREVWSUNFKFZFTkRPUl9JRF9GUldELCBQUk9EVUNUX0lEX0NZUEhJRENPTV9GUldEKSB9
LA0KIAl7IH0JCQkJCQkvKiBUZXJtaW5hdGluZyBlbnRyeSAqLw0KIH07DQogDQpAQCAtMTA5LDYg
KzExMCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBpZF90YWJsZV9jb21i
aW5lZFtdID0gew0KIAl7IFVTQl9ERVZJQ0UoVkVORE9SX0lEX0RFTE9STUUsIFBST0RVQ1RfSURf
RUFSVEhNQVRFVVNCX0xUMjApIH0sDQogCXsgVVNCX0RFVklDRShWRU5ET1JfSURfQ1lQUkVTUywg
UFJPRFVDVF9JRF9DWVBISURDT00pIH0sDQogCXsgVVNCX0RFVklDRShWRU5ET1JfSURfUE9XRVJD
T00sIFBST0RVQ1RfSURfVVBTKSB9LA0KKwl7IFVTQl9ERVZJQ0UoVkVORE9SX0lEX0ZSV0QsIFBS
T0RVQ1RfSURfQ1lQSElEQ09NX0ZSV0QpIH0sDQogCXsgVVNCX0RFVklDRShWRU5ET1JfSURfREFa
WkxFLCBQUk9EVUNUX0lEX0NBNDIpIH0sDQogCXsgfQkJCQkJCS8qIFRlcm1pbmF0aW5nIGVudHJ5
ICovDQogfTsNCkBAIC0yNjcsNiArMjY5LDEyIEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX3NlcmlhbF9k
cml2ZXIgY3lwcmVzc19jYTQydjJfZGV2aWNlID0gew0KICAqIEN5cHJlc3Mgc2VyaWFsIGhlbHBl
ciBmdW5jdGlvbnMNCiAgKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovDQogDQorLyogRlJXRCBEb25nbGUg
aGlkY29tIG5lZWRzIHRvIHNraXAgcmVzZXQgYW5kIHNwZWVkIGNoZWNrcyAqLw0KK3N0YXRpYyBp
bmxpbmUgYm9vbCBpc19mcndkKHN0cnVjdCB1c2JfZGV2aWNlICpkZXYpDQorew0KKwlyZXR1cm4g
KChsZTE2X3RvX2NwdShkZXYtPmRlc2NyaXB0b3IuaWRWZW5kb3IpID09IFZFTkRPUl9JRF9GUldE
KSAmJg0KKwkJKGxlMTZfdG9fY3B1KGRldi0+ZGVzY3JpcHRvci5pZFByb2R1Y3QpID09IFBST0RV
Q1RfSURfQ1lQSElEQ09NX0ZSV0QpKTsNCit9DQogDQogc3RhdGljIGludCBhbmFseXplX2JhdWRf
cmF0ZShzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0LCBzcGVlZF90IG5ld19yYXRlKQ0KIHsN
CkBAIC0yNzYsNiArMjg0LDEwIEBAIHN0YXRpYyBpbnQgYW5hbHl6ZV9iYXVkX3JhdGUoc3RydWN0
IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwgc3BlZWRfdCBuZXdfcmF0ZSkNCiAJaWYgKHVuc3RhYmxl
X2JhdWRzKQ0KIAkJcmV0dXJuIG5ld19yYXRlOw0KIA0KKwkvKiBGUldEIERvbmdsZSB1c2VzIDEx
NTIwMCBicHMgKi8NCisJaWYgKGlzX2Zyd2QocG9ydC0+c2VyaWFsLT5kZXYpKQ0KKwkJcmV0dXJu
IG5ld19yYXRlOw0KKw0KIAkvKg0KIAkgKiBUaGUgZ2VuZXJhbCBwdXJwb3NlIGZpcm13YXJlIGZv
ciB0aGUgQ3lwcmVzcyBNOCBhbGxvd3MgZm9yDQogCSAqIGEgbWF4aW11bSBzcGVlZCBvZiA1NzYw
MGJwcyAoSSBoYXZlIG5vIGlkZWEgd2hldGhlciBEZUxvcm1lDQpAQCAtNDg4LDcgKzUwMCwxMSBA
QCBzdGF0aWMgaW50IGdlbmVyaWNfc3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsKQ0K
IAkJcmV0dXJuIC1FTk9NRU07DQogCX0NCiANCi0JdXNiX3Jlc2V0X2NvbmZpZ3VyYXRpb24oc2Vy
aWFsLT5kZXYpOw0KKwkvKiBTa2lwIHJlc2V0IGZvciBGUldEIGRldmljZS4gSXQgaXMgYSB3b3Jr
YW91bmQ6DQorCSAgIGRldmljZSBoYW5ncyBpZiBpdCByZWNlaXZlcyBTRVRfQ09ORklHVVJFIGlu
IENvbmZpZ3VyZWQNCisJICAgc3RhdGUuICovDQorCWlmICghaXNfZnJ3ZChzZXJpYWwtPmRldikp
DQorCQl1c2JfcmVzZXRfY29uZmlndXJhdGlvbihzZXJpYWwtPmRldik7DQogDQogCXByaXYtPmNt
ZF9jdHJsID0gMDsNCiAJcHJpdi0+bGluZV9jb250cm9sID0gMDsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9zZXJpYWwvY3lwcmVzc19tOC5oIGIvZHJpdmVycy91c2Ivc2VyaWFsL2N5cHJlc3Nf
bTguaA0KaW5kZXggNjdjZjYwOC4uYjQ2MTMxMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3Nl
cmlhbC9jeXByZXNzX204LmgNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9jeXByZXNzX204LmgN
CkBAIC0yNCw2ICsyNCwxMCBAQA0KICNkZWZpbmUgVkVORE9SX0lEX0NZUFJFU1MJCTB4MDRiNA0K
ICNkZWZpbmUgUFJPRFVDVF9JRF9DWVBISURDT00JCTB4NTUwMA0KIA0KKy8qIEZSV0QgRG9uZ2xl
IC0gYSBHUFMgc3BvcnRzIHdhdGNoICovDQorI2RlZmluZSBWRU5ET1JfSURfRlJXRAkJCTB4Njcz
Nw0KKyNkZWZpbmUgUFJPRFVDVF9JRF9DWVBISURDT01fRlJXRAkweDAwMDENCisNCiAvKiBQb3dl
cmNvbSBVUFMsIGNoaXAgQ1k3QzYzNzIzICovDQogI2RlZmluZSBWRU5ET1JfSURfUE9XRVJDT00J
CTB4MGQ5Zg0KICNkZWZpbmUgUFJPRFVDVF9JRF9VUFMJCQkweDAwMDINCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Np
by5jDQppbmRleCA5MThlYzk4Li5jZTlmODdmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2Vy
aWFsL2Z0ZGlfc2lvLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jDQpAQCAt
MjE2OSw2ICsyMTY5LDkgQEAgc3RhdGljIHZvaWQgZnRkaV9zZXRfdGVybWlvcyhzdHJ1Y3QgdHR5
X3N0cnVjdCAqdHR5LA0KIA0KIAljZmxhZyA9IHRlcm1pb3MtPmNfY2ZsYWc7DQogDQorCWlmICgh
b2xkX3Rlcm1pb3MpDQorCQlnb3RvIG5vX3NraXA7DQorDQogCWlmIChvbGRfdGVybWlvcy0+Y19j
ZmxhZyA9PSB0ZXJtaW9zLT5jX2NmbGFnDQogCSAgICAmJiBvbGRfdGVybWlvcy0+Y19pc3BlZWQg
PT0gdGVybWlvcy0+Y19pc3BlZWQNCiAJICAgICYmIG9sZF90ZXJtaW9zLT5jX29zcGVlZCA9PSB0
ZXJtaW9zLT5jX29zcGVlZCkNCkBAIC0yMTgyLDYgKzIxODUsNyBAQCBzdGF0aWMgdm9pZCBmdGRp
X3NldF90ZXJtaW9zKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksDQogCSAgICAodGVybWlvcy0+Y19j
ZmxhZyAmIChDU0laRXxQQVJPRER8UEFSRU5CfENNU1BBUnxDU1RPUEIpKSkNCiAJCWdvdG8gbm9f
ZGF0YV9wYXJpdHlfc3RvcF9jaGFuZ2VzOw0KIA0KK25vX3NraXA6DQogCS8qIFNldCBudW1iZXIg
b2YgZGF0YSBiaXRzLCBwYXJpdHksIHN0b3AgYml0cyAqLw0KIA0KIAl1cmJfdmFsdWUgPSAwOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9pdXVfcGhvZW5peC5jIGIvZHJpdmVycy91
c2Ivc2VyaWFsL2l1dV9waG9lbml4LmMNCmluZGV4IDZhY2E2MzEuLmNmMjY2OGUgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvaXV1X3Bob2VuaXguYw0KKysrIGIvZHJpdmVycy91c2Iv
c2VyaWFsL2l1dV9waG9lbml4LmMNCkBAIC0zMjcsNyArMzI3LDcgQEAgc3RhdGljIGludCBidWxr
X2ltbWVkaWF0ZShzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0LCB1OCAqYnVmLCB1OCBjb3Vu
dCkNCiAJICAgIHVzYl9idWxrX21zZyhzZXJpYWwtPmRldiwNCiAJCQkgdXNiX3NuZGJ1bGtwaXBl
KHNlcmlhbC0+ZGV2LA0KIAkJCQkJIHBvcnQtPmJ1bGtfb3V0X2VuZHBvaW50QWRkcmVzcyksIGJ1
ZiwNCi0JCQkgY291bnQsICZhY3R1YWwsIEhaICogMSk7DQorCQkJIGNvdW50LCAmYWN0dWFsLCAx
MDAwKTsNCiANCiAJaWYgKHN0YXR1cyAhPSBJVVVfT1BFUkFUSU9OX09LKQ0KIAkJZGJnKCIlcyAt
IGVycm9yID0gJTJ4IiwgX19mdW5jX18sIHN0YXR1cyk7DQpAQCAtMzUwLDcgKzM1MCw3IEBAIHN0
YXRpYyBpbnQgcmVhZF9pbW1lZGlhdGUoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCwgdTgg
KmJ1ZiwgdTggY291bnQpDQogCSAgICB1c2JfYnVsa19tc2coc2VyaWFsLT5kZXYsDQogCQkJIHVz
Yl9yY3ZidWxrcGlwZShzZXJpYWwtPmRldiwNCiAJCQkJCSBwb3J0LT5idWxrX2luX2VuZHBvaW50
QWRkcmVzcyksIGJ1ZiwNCi0JCQkgY291bnQsICZhY3R1YWwsIEhaICogMSk7DQorCQkJIGNvdW50
LCAmYWN0dWFsLCAxMDAwKTsNCiANCiAJaWYgKHN0YXR1cyAhPSBJVVVfT1BFUkFUSU9OX09LKQ0K
IAkJZGJnKCIlcyAtIGVycm9yID0gJTJ4IiwgX19mdW5jX18sIHN0YXR1cyk7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy91c2Ivc2VyaWFsL2tleXNwYW4uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9rZXlz
cGFuLmMNCmluZGV4IGE0NDIzNTIuLjRmNDE1ZTI4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Iv
c2VyaWFsL2tleXNwYW4uYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2tleXNwYW4uYw0KQEAg
LTE4MzMsNyArMTgzMyw3IEBAIHN0YXRpYyBpbnQga2V5c3Bhbl91c2EyNl9zZW5kX3NldHVwKHN0
cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwsDQogCWRfZGV0YWlscyA9IHNfcHJpdi0+ZGV2aWNlX2Rl
dGFpbHM7DQogCWRldmljZV9wb3J0ID0gcG9ydC0+bnVtYmVyIC0gcG9ydC0+c2VyaWFsLT5taW5v
cjsNCiANCi0Jb3V0Y29udF91cmIgPSBkX2RldGFpbHMtPm91dGNvbnRfZW5kcG9pbnRzW3BvcnQt
Pm51bWJlcl07DQorCW91dGNvbnRfdXJiID0gZF9kZXRhaWxzLT5vdXRjb250X2VuZHBvaW50c1tk
ZXZpY2VfcG9ydF07DQogCXRoaXNfdXJiID0gcF9wcml2LT5vdXRjb250X3VyYjsNCiANCiAJZGJn
KCIlcyAtIGVuZHBvaW50ICVkIiwgX19mdW5jX18sIHVzYl9waXBlZW5kcG9pbnQodGhpc191cmIt
PnBpcGUpKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvbW9zNzcyMC5jIGIvZHJp
dmVycy91c2Ivc2VyaWFsL21vczc3MjAuYw0KaW5kZXggMzUyNGExMC4uOTU4MDY3OSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9tb3M3NzIwLmMNCisrKyBiL2RyaXZlcnMvdXNiL3Nl
cmlhbC9tb3M3NzIwLmMNCkBAIC00NCw3ICs0NCw3IEBADQogI2RlZmluZSBEUklWRVJfREVTQyAi
TW9zY2hpcCBVU0IgU2VyaWFsIERyaXZlciINCiANCiAvKiBkZWZhdWx0IHVyYiB0aW1lb3V0ICov
DQotI2RlZmluZSBNT1NfV0RSX1RJTUVPVVQJKEhaICogNSkNCisjZGVmaW5lIE1PU19XRFJfVElN
RU9VVAk1MDAwDQogDQogI2RlZmluZSBNT1NfTUFYX1BPUlQJMHgwMg0KICNkZWZpbmUgTU9TX1dS
SVRFCTB4MEUNCkBAIC0yMzQsMTEgKzIzNCwyMiBAQCBzdGF0aWMgaW50IHJlYWRfbW9zX3JlZyhz
dHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsLCB1bnNpZ25lZCBpbnQgc2VyaWFsX3BvcnRudW0sDQog
CV9fdTggcmVxdWVzdHR5cGUgPSAoX191OCkweGMwOw0KIAlfX3UxNiBpbmRleCA9IGdldF9yZWdf
aW5kZXgocmVnKTsNCiAJX191MTYgdmFsdWUgPSBnZXRfcmVnX3ZhbHVlKHJlZywgc2VyaWFsX3Bv
cnRudW0pOw0KLQlpbnQgc3RhdHVzID0gdXNiX2NvbnRyb2xfbXNnKHVzYmRldiwgcGlwZSwgcmVx
dWVzdCwgcmVxdWVzdHR5cGUsIHZhbHVlLA0KLQkJCQkgICAgIGluZGV4LCBkYXRhLCAxLCBNT1Nf
V0RSX1RJTUVPVVQpOw0KLQlpZiAoc3RhdHVzIDwgMCkNCisJdTggKmJ1ZjsNCisJaW50IHN0YXR1
czsNCisNCisJYnVmID0ga21hbGxvYygxLCBHRlBfS0VSTkVMKTsNCisJaWYgKCFidWYpDQorCQly
ZXR1cm4gLUVOT01FTTsNCisNCisJc3RhdHVzID0gdXNiX2NvbnRyb2xfbXNnKHVzYmRldiwgcGlw
ZSwgcmVxdWVzdCwgcmVxdWVzdHR5cGUsIHZhbHVlLA0KKwkJCQkgICAgIGluZGV4LCBidWYsIDEs
IE1PU19XRFJfVElNRU9VVCk7DQorCWlmIChzdGF0dXMgPT0gMSkNCisJCSpkYXRhID0gKmJ1ZjsN
CisJZWxzZSBpZiAoc3RhdHVzIDwgMCkNCiAJCWRldl9lcnIoJnVzYmRldi0+ZGV2LA0KIAkJCSJt
b3M3NzIwOiB1c2JfY29udHJvbF9tc2coKSBmYWlsZWQ6ICVkIiwgc3RhdHVzKTsNCisJa2ZyZWUo
YnVmKTsNCisNCiAJcmV0dXJuIHN0YXR1czsNCiB9DQogDQpAQCAtMTcwMCw3ICsxNzExLDcgQEAg
c3RhdGljIHZvaWQgY2hhbmdlX3BvcnRfc2V0dGluZ3Moc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwN
CiAJCW1vczc3MjBfcG9ydC0+c2hhZG93TUNSIHw9IChVQVJUX01DUl9YT05BTlkpOw0KIAkJLyog
VG8gc2V0IGhhcmR3YXJlIGZsb3cgY29udHJvbCB0byB0aGUgc3BlY2lmaWVkICoNCiAJCSAqIHNl
cmlhbCBwb3J0LCBpbiBTUDEvMl9DT05UUk9MX1JFRyAgICAgICAgICAgICAqLw0KLQkJaWYgKHBv
cnQtPm51bWJlcikNCisJCWlmIChwb3J0X251bWJlcikNCiAJCQl3cml0ZV9tb3NfcmVnKHNlcmlh
bCwgZHVtbXksIFNQX0NPTlRST0xfUkVHLCAweDAxKTsNCiAJCWVsc2UNCiAJCQl3cml0ZV9tb3Nf
cmVnKHNlcmlhbCwgZHVtbXksIFNQX0NPTlRST0xfUkVHLCAweDAyKTsNCkBAIC0yMTEyLDcgKzIx
MjMsNyBAQCBzdGF0aWMgaW50IG1vczc3MjBfc3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2Vy
aWFsKQ0KIA0KIAkvKiBzZXR0aW5nIGNvbmZpZ3VyYXRpb24gZmVhdHVyZSB0byBvbmUgKi8NCiAJ
dXNiX2NvbnRyb2xfbXNnKHNlcmlhbC0+ZGV2LCB1c2Jfc25kY3RybHBpcGUoc2VyaWFsLT5kZXYs
IDApLA0KLQkJCShfX3U4KTB4MDMsIDB4MDAsIDB4MDEsIDB4MDAsIE5VTEwsIDB4MDAsIDUqSFop
Ow0KKwkJCShfX3U4KTB4MDMsIDB4MDAsIDB4MDEsIDB4MDAsIE5VTEwsIDB4MDAsIDUwMDApOw0K
IA0KIAkvKiBzdGFydCB0aGUgaW50ZXJydXB0IHVyYiAqLw0KIAlyZXRfdmFsID0gdXNiX3N1Ym1p
dF91cmIoc2VyaWFsLT5wb3J0WzBdLT5pbnRlcnJ1cHRfaW5fdXJiLCBHRlBfS0VSTkVMKTsNCkBA
IC0yMTU3LDcgKzIxNjgsNyBAQCBzdGF0aWMgdm9pZCBtb3M3NzIwX3JlbGVhc2Uoc3RydWN0IHVz
Yl9zZXJpYWwgKnNlcmlhbCkNCiAJCS8qIHdhaXQgZm9yIHN5bmNocm9ub3VzIHVzYiBjYWxscyB0
byByZXR1cm4gKi8NCiAJCWlmIChtb3NfcGFycG9ydC0+bXNnX3BlbmRpbmcpDQogCQkJd2FpdF9m
b3JfY29tcGxldGlvbl90aW1lb3V0KCZtb3NfcGFycG9ydC0+c3luY21zZ19jb21wbCwNCi0JCQkJ
CQkgICAgTU9TX1dEUl9USU1FT1VUKTsNCisJCQkJCSAgICBtc2Vjc190b19qaWZmaWVzKE1PU19X
RFJfVElNRU9VVCkpOw0KIA0KIAkJcGFycG9ydF9yZW1vdmVfcG9ydChtb3NfcGFycG9ydC0+cHAp
Ow0KIAkJdXNiX3NldF9zZXJpYWxfZGF0YShzZXJpYWwsIE5VTEwpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYw0K
aW5kZXggNTljNDk5Ny4uOGVhMzdiYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9v
cHRpb24uYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQpAQCAtNTkzLDYgKzU5
Myw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10gPSB7
DQogCQkuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpICZodWF3ZWlfY2RjMTJfYmxhY2ts
aXN0IH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9J
RCwgSFVBV0VJX1BST0RVQ1RfSzM3NjUsIDB4ZmYsIDB4ZmYsIDB4ZmYpLA0KIAkJLmRyaXZlcl9p
bmZvID0gKGtlcm5lbF91bG9uZ190KSAmaHVhd2VpX2NkYzEyX2JsYWNrbGlzdCB9LA0KKwl7IFVT
Ql9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4MTRhYywgMHhm
ZiwgMHhmZiwgMHhmZiksCS8qIEh1YXdlaSBFMTgyMCAqLw0KKwkJLmRyaXZlcl9pbmZvID0gKGtl
cm5lbF91bG9uZ190KSAmbmV0X2ludGYxX2JsYWNrbGlzdCB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5E
X0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIEhVQVdFSV9QUk9EVUNUX0s0NjA1LCAw
eGZmLCAweGZmLCAweGZmKSwNCiAJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkgJmh1
YXdlaV9jZGMxMl9ibGFja2xpc3QgfSwNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5G
TyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweGZmLCAweGZmKSB9LA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL3NlcmlhbC9wbDIzMDMuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9wbDIzMDMuYw0K
aW5kZXggZmQ4NmUwZS4uMzE3ZTUwMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9w
bDIzMDMuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL3BsMjMwMy5jDQpAQCAtMjcwLDcgKzI3
MCw3IEBAIHN0YXRpYyB2b2lkIHBsMjMwM19zZXRfdGVybWlvcyhzdHJ1Y3QgdHR5X3N0cnVjdCAq
dHR5LA0KIAkgICBzZXJpYWwgc2V0dGluZ3MgZXZlbiB0byB0aGUgc2FtZSB2YWx1ZXMgYXMgYmVm
b3JlLiBUaHVzDQogCSAgIHdlIGFjdHVhbGx5IG5lZWQgdG8gZmlsdGVyIGluIHRoaXMgc3BlY2lm
aWMgY2FzZSAqLw0KIA0KLQlpZiAoIXR0eV90ZXJtaW9zX2h3X2NoYW5nZSh0dHktPnRlcm1pb3Ms
IG9sZF90ZXJtaW9zKSkNCisJaWYgKG9sZF90ZXJtaW9zICYmICF0dHlfdGVybWlvc19od19jaGFu
Z2UodHR5LT50ZXJtaW9zLCBvbGRfdGVybWlvcykpDQogCQlyZXR1cm47DQogDQogCWNmbGFnID0g
dHR5LT50ZXJtaW9zLT5jX2NmbGFnOw0KQEAgLTI3OSw3ICsyNzksOCBAQCBzdGF0aWMgdm9pZCBw
bDIzMDNfc2V0X3Rlcm1pb3Moc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJaWYgKCFidWYpIHsN
CiAJCWRldl9lcnIoJnBvcnQtPmRldiwgIiVzIC0gb3V0IG9mIG1lbW9yeS5cbiIsIF9fZnVuY19f
KTsNCiAJCS8qIFJlcG9ydCBiYWNrIG5vIGNoYW5nZSBvY2N1cnJlZCAqLw0KLQkJKnR0eS0+dGVy
bWlvcyA9ICpvbGRfdGVybWlvczsNCisJCWlmIChvbGRfdGVybWlvcykNCisJCQkqdHR5LT50ZXJt
aW9zID0gKm9sZF90ZXJtaW9zOw0KIAkJcmV0dXJuOw0KIAl9DQogDQpAQCAtNDE5LDcgKzQyMCw3
IEBAIHN0YXRpYyB2b2lkIHBsMjMwM19zZXRfdGVybWlvcyhzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5
LA0KIAljb250cm9sID0gcHJpdi0+bGluZV9jb250cm9sOw0KIAlpZiAoKGNmbGFnICYgQ0JBVUQp
ID09IEIwKQ0KIAkJcHJpdi0+bGluZV9jb250cm9sICY9IH4oQ09OVFJPTF9EVFIgfCBDT05UUk9M
X1JUUyk7DQotCWVsc2UgaWYgKChvbGRfdGVybWlvcy0+Y19jZmxhZyAmIENCQVVEKSA9PSBCMCkN
CisJZWxzZSBpZiAob2xkX3Rlcm1pb3MgJiYgKG9sZF90ZXJtaW9zLT5jX2NmbGFnICYgQ0JBVUQp
ID09IEIwKQ0KIAkJcHJpdi0+bGluZV9jb250cm9sIHw9IChDT05UUk9MX0RUUiB8IENPTlRST0xf
UlRTKTsNCiAJaWYgKGNvbnRyb2wgIT0gcHJpdi0+bGluZV9jb250cm9sKSB7DQogCQljb250cm9s
ID0gcHJpdi0+bGluZV9jb250cm9sOw0KQEAgLTQ4MCw3ICs0ODEsNiBAQCBzdGF0aWMgdm9pZCBw
bDIzMDNfY2xvc2Uoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCkNCiANCiBzdGF0aWMgaW50
IHBsMjMwM19vcGVuKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVjdCB1c2Jfc2VyaWFsX3Bv
cnQgKnBvcnQpDQogew0KLQlzdHJ1Y3Qga3Rlcm1pb3MgdG1wX3Rlcm1pb3M7DQogCXN0cnVjdCB1
c2Jfc2VyaWFsICpzZXJpYWwgPSBwb3J0LT5zZXJpYWw7DQogCXN0cnVjdCBwbDIzMDNfcHJpdmF0
ZSAqcHJpdiA9IHVzYl9nZXRfc2VyaWFsX3BvcnRfZGF0YShwb3J0KTsNCiAJaW50IHJlc3VsdDsN
CkBAIC00OTgsNyArNDk4LDcgQEAgc3RhdGljIGludCBwbDIzMDNfb3BlbihzdHJ1Y3QgdHR5X3N0
cnVjdCAqdHR5LCBzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIA0KIAkvKiBTZXR1cCB0
ZXJtaW9zICovDQogCWlmICh0dHkpDQotCQlwbDIzMDNfc2V0X3Rlcm1pb3ModHR5LCBwb3J0LCAm
dG1wX3Rlcm1pb3MpOw0KKwkJcGwyMzAzX3NldF90ZXJtaW9zKHR0eSwgcG9ydCwgTlVMTCk7DQog
DQogCWRiZygiJXMgLSBzdWJtaXR0aW5nIHJlYWQgdXJiIiwgX19mdW5jX18pOw0KIAlyZXN1bHQg
PSB1c2Jfc2VyaWFsX2dlbmVyaWNfc3VibWl0X3JlYWRfdXJiKHBvcnQsIEdGUF9LRVJORUwpOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9xY3NlcmlhbC5jIGIvZHJpdmVycy91c2Iv
c2VyaWFsL3Fjc2VyaWFsLmMNCmluZGV4IDE0YzRhODIuLjU1MzVjM2EgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3VzYi9zZXJpYWwvcWNzZXJpYWwuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL3Fj
c2VyaWFsLmMNCkBAIC0xMTUsNiArMTE1LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2
aWNlX2lkIGlkX3RhYmxlW10gPSB7DQogCXtVU0JfREVWSUNFKDB4MTE5OSwgMHg5MDE5KX0sCS8q
IFNpZXJyYSBXaXJlbGVzcyBHb2JpIDMwMDAgTW9kZW0gZGV2aWNlICovDQogCXtVU0JfREVWSUNF
KDB4MTJEMSwgMHgxNEYwKX0sCS8qIFNvbnkgR29iaSAzMDAwIFFETCAqLw0KIAl7VVNCX0RFVklD
RSgweDEyRDEsIDB4MTRGMSl9LAkvKiBTb255IEdvYmkgMzAwMCBDb21wb3NpdGUgKi8NCisJe1VT
Ql9ERVZJQ0UoMHgwQUYwLCAweDgxMjApfSwJLyogT3B0aW9uIEdUTTY4MVcgKi8NCiAJeyB9CQkJ
CS8qIFRlcm1pbmF0aW5nIGVudHJ5ICovDQogfTsNCiBNT0RVTEVfREVWSUNFX1RBQkxFKHVzYiwg
aWRfdGFibGUpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9zcGNwOHg1LmMgYi9k
cml2ZXJzL3VzYi9zZXJpYWwvc3BjcDh4NS5jDQppbmRleCBiYTZiNDM4Li5mMzE3OWIwIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL3NwY3A4eDUuYw0KKysrIGIvZHJpdmVycy91c2Iv
c2VyaWFsL3NwY3A4eDUuYw0KQEAgLTMzOCw3ICszMzgsNiBAQCBzdGF0aWMgdm9pZCBzcGNwOHg1
X3NldF90ZXJtaW9zKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksDQogCXN0cnVjdCBzcGNwOHg1X3By
aXZhdGUgKnByaXYgPSB1c2JfZ2V0X3NlcmlhbF9wb3J0X2RhdGEocG9ydCk7DQogCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7DQogCXVuc2lnbmVkIGludCBjZmxhZyA9IHR0eS0+dGVybWlvcy0+Y19jZmxh
ZzsNCi0JdW5zaWduZWQgaW50IG9sZF9jZmxhZyA9IG9sZF90ZXJtaW9zLT5jX2NmbGFnOw0KIAl1
bnNpZ25lZCBzaG9ydCB1YXJ0ZGF0YTsNCiAJdW5zaWduZWQgY2hhciBidWZbMl0gPSB7MCwgMH07
DQogCWludCBiYXVkOw0KQEAgLTM0NywxNSArMzQ2LDE1IEBAIHN0YXRpYyB2b2lkIHNwY3A4eDVf
c2V0X3Rlcm1pb3Moc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiANCiANCiAJLyogY2hlY2sgdGhh
dCB0aGV5IHJlYWxseSB3YW50IHVzIHRvIGNoYW5nZSBzb21ldGhpbmcgKi8NCi0JaWYgKCF0dHlf
dGVybWlvc19od19jaGFuZ2UodHR5LT50ZXJtaW9zLCBvbGRfdGVybWlvcykpDQorCWlmIChvbGRf
dGVybWlvcyAmJiAhdHR5X3Rlcm1pb3NfaHdfY2hhbmdlKHR0eS0+dGVybWlvcywgb2xkX3Rlcm1p
b3MpKQ0KIAkJcmV0dXJuOw0KIA0KIAkvKiBzZXQgRFRSL1JUUyBhY3RpdmUgKi8NCiAJc3Bpbl9s
b2NrX2lycXNhdmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiAJY29udHJvbCA9IHByaXYtPmxpbmVf
Y29udHJvbDsNCi0JaWYgKChvbGRfY2ZsYWcgJiBDQkFVRCkgPT0gQjApIHsNCisJaWYgKG9sZF90
ZXJtaW9zICYmIChvbGRfdGVybWlvcy0+Y19jZmxhZyAmIENCQVVEKSA9PSBCMCkgew0KIAkJcHJp
di0+bGluZV9jb250cm9sIHw9IE1DUl9EVFI7DQotCQlpZiAoIShvbGRfY2ZsYWcgJiBDUlRTQ1RT
KSkNCisJCWlmICghKG9sZF90ZXJtaW9zLT5jX2NmbGFnICYgQ1JUU0NUUykpDQogCQkJcHJpdi0+
bGluZV9jb250cm9sIHw9IE1DUl9SVFM7DQogCX0NCiAJaWYgKGNvbnRyb2wgIT0gcHJpdi0+bGlu
ZV9jb250cm9sKSB7DQpAQCAtNDQ1LDcgKzQ0NCw2IEBAIHN0YXRpYyB2b2lkIHNwY3A4eDVfc2V0
X3Rlcm1pb3Moc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAgKiBzdGF0dXMgb2YgdGhlIGRldmlj
ZS4gKi8NCiBzdGF0aWMgaW50IHNwY3A4eDVfb3BlbihzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LCBz
dHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIHsNCi0Jc3RydWN0IGt0ZXJtaW9zIHRtcF90
ZXJtaW9zOw0KIAlzdHJ1Y3QgdXNiX3NlcmlhbCAqc2VyaWFsID0gcG9ydC0+c2VyaWFsOw0KIAlz
dHJ1Y3Qgc3BjcDh4NV9wcml2YXRlICpwcml2ID0gdXNiX2dldF9zZXJpYWxfcG9ydF9kYXRhKHBv
cnQpOw0KIAlpbnQgcmV0Ow0KQEAgLTQ2OCw3ICs0NjYsNyBAQCBzdGF0aWMgaW50IHNwY3A4eDVf
b3BlbihzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LCBzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0
KQ0KIA0KIAkvKiBTZXR1cCB0ZXJtaW9zICovDQogCWlmICh0dHkpDQotCQlzcGNwOHg1X3NldF90
ZXJtaW9zKHR0eSwgcG9ydCwgJnRtcF90ZXJtaW9zKTsNCisJCXNwY3A4eDVfc2V0X3Rlcm1pb3Mo
dHR5LCBwb3J0LCBOVUxMKTsNCiANCiAJc3BjcDh4NV9nZXRfbXNyKHNlcmlhbC0+ZGV2LCAmc3Rh
dHVzLCBwcml2LT50eXBlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvdmlz
b3IuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC92aXNvci5jDQppbmRleCAxYzExOTU5Li44MGE2ZmY2
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL3Zpc29yLmMNCisrKyBiL2RyaXZlcnMv
dXNiL3NlcmlhbC92aXNvci5jDQpAQCAtNTk5LDcgKzU5OSw5IEBAIHN0YXRpYyBpbnQgdHJlb19h
dHRhY2goc3RydWN0IHVzYl9zZXJpYWwgKnNlcmlhbCkNCiAJCWRlc3QtPnJlYWRfdXJiID0gc3Jj
LT5yZWFkX3VyYjsJCQkJXA0KIAkJZGVzdC0+YnVsa19pbl9lbmRwb2ludEFkZHJlc3MgPSBzcmMt
PmJ1bGtfaW5fZW5kcG9pbnRBZGRyZXNzO1wNCiAJCWRlc3QtPmJ1bGtfaW5fYnVmZmVyID0gc3Jj
LT5idWxrX2luX2J1ZmZlcjsJCVwNCisJCWRlc3QtPmJ1bGtfaW5fc2l6ZSA9IHNyYy0+YnVsa19p
bl9zaXplOwkJCVwNCiAJCWRlc3QtPmludGVycnVwdF9pbl91cmIgPSBzcmMtPmludGVycnVwdF9p
bl91cmI7CQlcDQorCQlkZXN0LT5pbnRlcnJ1cHRfaW5fdXJiLT5jb250ZXh0ID0gZGVzdDsJCQlc
DQogCQlkZXN0LT5pbnRlcnJ1cHRfaW5fZW5kcG9pbnRBZGRyZXNzID0gXA0KIAkJCQkJc3JjLT5p
bnRlcnJ1cHRfaW5fZW5kcG9pbnRBZGRyZXNzO1wNCiAJCWRlc3QtPmludGVycnVwdF9pbl9idWZm
ZXIgPSBzcmMtPmludGVycnVwdF9pbl9idWZmZXI7CVwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9zZXJpYWwvd2hpdGVoZWF0LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvd2hpdGVoZWF0LmMNCmlu
ZGV4IDU5ZDY0NmQuLjBlYzYwY2QgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvd2hp
dGVoZWF0LmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC93aGl0ZWhlYXQuYw0KQEAgLTEyMDks
NyArMTIwOSw3IEBAIHN0YXRpYyB2b2lkIGZpcm1fc2V0dXBfcG9ydChzdHJ1Y3QgdHR5X3N0cnVj
dCAqdHR5KQ0KIAlzdHJ1Y3Qgd2hpdGVoZWF0X3BvcnRfc2V0dGluZ3MgcG9ydF9zZXR0aW5nczsN
CiAJdW5zaWduZWQgaW50IGNmbGFnID0gdHR5LT50ZXJtaW9zLT5jX2NmbGFnOw0KIA0KLQlwb3J0
X3NldHRpbmdzLnBvcnQgPSBwb3J0LT5udW1iZXIgKyAxOw0KKwlwb3J0X3NldHRpbmdzLnBvcnQg
PSBwb3J0LT5udW1iZXIgLSBwb3J0LT5zZXJpYWwtPm1pbm9yICsgMTsNCiANCiAJLyogZ2V0IHRo
ZSBieXRlIHNpemUgKi8NCiAJc3dpdGNoIChjZmxhZyAmIENTSVpFKSB7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy94ZW4vZXZlbnRzLmMgYi9kcml2ZXJzL3hlbi9ldmVudHMuYw0KaW5kZXggZmVjMTIw
NC4uMTFkN2I2NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMveGVuL2V2ZW50cy5jDQorKysgYi9kcml2
ZXJzL3hlbi9ldmVudHMuYw0KQEAgLTExNzYsNyArMTE3Niw3IEBAIHN0YXRpYyB2b2lkIF9feGVu
X2V2dGNobl9kb191cGNhbGwodm9pZCkNCiB7DQogCWludCBzdGFydF93b3JkX2lkeCwgc3RhcnRf
Yml0X2lkeDsNCiAJaW50IHdvcmRfaWR4LCBiaXRfaWR4Ow0KLQlpbnQgaTsNCisJaW50IGksIGly
cTsNCiAJaW50IGNwdSA9IGdldF9jcHUoKTsNCiAJc3RydWN0IHNoYXJlZF9pbmZvICpzID0gSFlQ
RVJWSVNPUl9zaGFyZWRfaW5mbzsNCiAJc3RydWN0IHZjcHVfaW5mbyAqdmNwdV9pbmZvID0gX190
aGlzX2NwdV9yZWFkKHhlbl92Y3B1KTsNCkBAIC0xMTg0LDYgKzExODQsOCBAQCBzdGF0aWMgdm9p
ZCBfX3hlbl9ldnRjaG5fZG9fdXBjYWxsKHZvaWQpDQogDQogCWRvIHsNCiAJCXVuc2lnbmVkIGxv
bmcgcGVuZGluZ193b3JkczsNCisJCXVuc2lnbmVkIGxvbmcgcGVuZGluZ19iaXRzOw0KKwkJc3Ry
dWN0IGlycV9kZXNjICpkZXNjOw0KIA0KIAkJdmNwdV9pbmZvLT5ldnRjaG5fdXBjYWxsX3BlbmRp
bmcgPSAwOw0KIA0KQEAgLTExOTQsNiArMTE5NiwxNyBAQCBzdGF0aWMgdm9pZCBfX3hlbl9ldnRj
aG5fZG9fdXBjYWxsKHZvaWQpDQogCQkvKiBDbGVhciBtYXN0ZXIgZmxhZyAvYmVmb3JlLyBjbGVh
cmluZyBzZWxlY3RvciBmbGFnLiAqLw0KIAkJd21iKCk7DQogI2VuZGlmDQorCQlpZiAoKGlycSA9
IHBlcl9jcHUodmlycV90b19pcnEsIGNwdSlbVklSUV9USU1FUl0pICE9IC0xKSB7DQorCQkJaW50
IGV2dGNobiA9IGV2dGNobl9mcm9tX2lycShpcnEpOw0KKwkJCXdvcmRfaWR4ID0gZXZ0Y2huIC8g
QklUU19QRVJfTE9ORzsNCisJCQlwZW5kaW5nX2JpdHMgPSBldnRjaG4gJSBCSVRTX1BFUl9MT05H
Ow0KKwkJCWlmIChhY3RpdmVfZXZ0Y2hucyhjcHUsIHMsIHdvcmRfaWR4KSAmICgxVUxMIDw8IHBl
bmRpbmdfYml0cykpIHsNCisJCQkJZGVzYyA9IGlycV90b19kZXNjKGlycSk7DQorCQkJCWlmIChk
ZXNjKQ0KKwkJCQkJZ2VuZXJpY19oYW5kbGVfaXJxX2Rlc2MoaXJxLCBkZXNjKTsNCisJCQl9DQor
CQl9DQorDQogCQlwZW5kaW5nX3dvcmRzID0geGNoZygmdmNwdV9pbmZvLT5ldnRjaG5fcGVuZGlu
Z19zZWwsIDApOw0KIA0KIAkJc3RhcnRfd29yZF9pZHggPSBfX3RoaXNfY3B1X3JlYWQoY3VycmVu
dF93b3JkX2lkeCk7DQpAQCAtMTIwMiw3ICsxMjE1LDYgQEAgc3RhdGljIHZvaWQgX194ZW5fZXZ0
Y2huX2RvX3VwY2FsbCh2b2lkKQ0KIAkJd29yZF9pZHggPSBzdGFydF93b3JkX2lkeDsNCiANCiAJ
CWZvciAoaSA9IDA7IHBlbmRpbmdfd29yZHMgIT0gMDsgaSsrKSB7DQotCQkJdW5zaWduZWQgbG9u
ZyBwZW5kaW5nX2JpdHM7DQogCQkJdW5zaWduZWQgbG9uZyB3b3JkczsNCiANCiAJCQl3b3JkcyA9
IE1BU0tfTFNCUyhwZW5kaW5nX3dvcmRzLCB3b3JkX2lkeCk7DQpAQCAtMTIzMSw4ICsxMjQzLDcg
QEAgc3RhdGljIHZvaWQgX194ZW5fZXZ0Y2huX2RvX3VwY2FsbCh2b2lkKQ0KIA0KIAkJCWRvIHsN
CiAJCQkJdW5zaWduZWQgbG9uZyBiaXRzOw0KLQkJCQlpbnQgcG9ydCwgaXJxOw0KLQkJCQlzdHJ1
Y3QgaXJxX2Rlc2MgKmRlc2M7DQorCQkJCWludCBwb3J0Ow0KIA0KIAkJCQliaXRzID0gTUFTS19M
U0JTKHBlbmRpbmdfYml0cywgYml0X2lkeCk7DQogDQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZz
X2Rmc19yZWYuYyBiL2ZzL2NpZnMvY2lmc19kZnNfcmVmLmMNCmluZGV4IDIyNjMxNDQuLmQwZTVm
YzUgMTAwNjQ0DQotLS0gYS9mcy9jaWZzL2NpZnNfZGZzX3JlZi5jDQorKysgYi9mcy9jaWZzL2Np
ZnNfZGZzX3JlZi5jDQpAQCAtMTgsNiArMTgsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+
DQogI2luY2x1ZGUgPGxpbnV4L3Zmcy5oPg0KICNpbmNsdWRlIDxsaW51eC9mcy5oPg0KKyNpbmNs
dWRlIDxsaW51eC9pbmV0Lmg+DQogI2luY2x1ZGUgImNpZnNnbG9iLmgiDQogI2luY2x1ZGUgImNp
ZnNwcm90by5oIg0KICNpbmNsdWRlICJjaWZzZnMuaCINCkBAIC0xNTAsNyArMTUxLDggQEAgY2hh
ciAqY2lmc19jb21wb3NlX21vdW50X29wdGlvbnMoY29uc3QgY2hhciAqc2JfbW91bnRkYXRhLA0K
IAkgKiBhc3N1bWluZyB0aGF0IHdlIGhhdmUgJ3VuYz0nIGFuZCAnaXA9JyBpbg0KIAkgKiB0aGUg
b3JpZ2luYWwgc2JfbW91bnRkYXRhDQogCSAqLw0KLQltZF9sZW4gPSBzdHJsZW4oc2JfbW91bnRk
YXRhKSArIHJjICsgc3RybGVuKHJlZi0+bm9kZV9uYW1lKSArIDEyOw0KKwltZF9sZW4gPSBzdHJs
ZW4oc2JfbW91bnRkYXRhKSArIHJjICsgc3RybGVuKHJlZi0+bm9kZV9uYW1lKSArIDEyICsNCisJ
CQlJTkVUNl9BRERSU1RSTEVOOw0KIAltb3VudGRhdGEgPSBremFsbG9jKG1kX2xlbisxLCBHRlBf
S0VSTkVMKTsNCiAJaWYgKG1vdW50ZGF0YSA9PSBOVUxMKSB7DQogCQlyYyA9IC1FTk9NRU07DQpk
aWZmIC0tZ2l0IGEvZnMvZXh0NC9zdXBlci5jIGIvZnMvZXh0NC9zdXBlci5jDQppbmRleCBjYzM4
NmIyLi4yNTllOTUwIDEwMDY0NA0KLS0tIGEvZnMvZXh0NC9zdXBlci5jDQorKysgYi9mcy9leHQ0
L3N1cGVyLmMNCkBAIC0yMjYwLDcgKzIyNjAsOSBAQCBzdGF0aWMgdm9pZCBleHQ0X29ycGhhbl9j
bGVhbnVwKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsDQogCQkJCV9fZnVuY19fLCBpbm9kZS0+aV9p
bm8sIGlub2RlLT5pX3NpemUpOw0KIAkJCWpiZF9kZWJ1ZygyLCAidHJ1bmNhdGluZyBpbm9kZSAl
bHUgdG8gJWxsZCBieXRlc1xuIiwNCiAJCQkJICBpbm9kZS0+aV9pbm8sIGlub2RlLT5pX3NpemUp
Ow0KKwkJCW11dGV4X2xvY2soJmlub2RlLT5pX211dGV4KTsNCiAJCQlleHQ0X3RydW5jYXRlKGlu
b2RlKTsNCisJCQltdXRleF91bmxvY2soJmlub2RlLT5pX211dGV4KTsNCiAJCQlucl90cnVuY2F0
ZXMrKzsNCiAJCX0gZWxzZSB7DQogCQkJZXh0NF9tc2coc2IsIEtFUk5fREVCVUcsDQpkaWZmIC0t
Z2l0IGEvZnMvamZzL2lub2RlLmMgYi9mcy9qZnMvaW5vZGUuYw0KaW5kZXggNzdiNjliMi4uMTNm
Yzg4NSAxMDA2NDQNCi0tLSBhL2ZzL2pmcy9pbm9kZS5jDQorKysgYi9mcy9qZnMvaW5vZGUuYw0K
QEAgLTEyNSw3ICsxMjUsNyBAQCBpbnQgamZzX3dyaXRlX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIHN0cnVjdCB3cml0ZWJhY2tfY29udHJvbCAqd2JjKQ0KIHsNCiAJaW50IHdhaXQgPSB3YmMt
PnN5bmNfbW9kZSA9PSBXQl9TWU5DX0FMTDsNCiANCi0JaWYgKHRlc3RfY2ZsYWcoQ09NTUlUX05v
bGluaywgaW5vZGUpKQ0KKwlpZiAoaW5vZGUtPmlfbmxpbmsgPT0gMCkNCiAJCXJldHVybiAwOw0K
IAkvKg0KIAkgKiBJZiBDT01NSVRfRElSVFkgaXMgbm90IHNldCwgdGhlIGlub2RlIGlzbid0IHJl
YWxseSBkaXJ0eS4NCmRpZmYgLS1naXQgYS9mcy9qZnMvamZzX2xvZ21nci5jIGIvZnMvamZzL2pm
c19sb2dtZ3IuYw0KaW5kZXggY2M1ZjgxMS4uYmZiMmE5MSAxMDA2NDQNCi0tLSBhL2ZzL2pmcy9q
ZnNfbG9nbWdyLmMNCisrKyBiL2ZzL2pmcy9qZnNfbG9nbWdyLmMNCkBAIC0xMDU4LDcgKzEwNTgs
OCBAQCBzdGF0aWMgaW50IGxtTG9nU3luYyhzdHJ1Y3QgamZzX2xvZyAqIGxvZywgaW50IGhhcmRf
c3luYykNCiAgKi8NCiB2b2lkIGpmc19zeW5jcHQoc3RydWN0IGpmc19sb2cgKmxvZywgaW50IGhh
cmRfc3luYykNCiB7CUxPR19MT0NLKGxvZyk7DQotCWxtTG9nU3luYyhsb2csIGhhcmRfc3luYyk7
DQorCWlmICghdGVzdF9iaXQobG9nX1FVSUVTQ0UsICZsb2ctPmZsYWcpKQ0KKwkJbG1Mb2dTeW5j
KGxvZywgaGFyZF9zeW5jKTsNCiAJTE9HX1VOTE9DSyhsb2cpOw0KIH0NCiANCmRpZmYgLS1naXQg
YS9mcy94ZnMveGZzX2lvcHMuYyBiL2ZzL3hmcy94ZnNfaW9wcy5jDQppbmRleCAyM2NlOTI3Li5i
ZDJmYjQzIDEwMDY0NA0KLS0tIGEvZnMveGZzL3hmc19pb3BzLmMNCisrKyBiL2ZzL3hmcy94ZnNf
aW9wcy5jDQpAQCAtNTA3LDYgKzUwNywyOCBAQCB4ZnNfdm5fZ2V0YXR0cigNCiAJcmV0dXJuIDA7
DQogfQ0KIA0KK3N0YXRpYyB2b2lkDQoreGZzX3NldGF0dHJfbW9kZSgNCisJc3RydWN0IHhmc190
cmFucwkqdHAsDQorCXN0cnVjdCB4ZnNfaW5vZGUJKmlwLA0KKwlzdHJ1Y3QgaWF0dHIJCSppYXR0
cikNCit7DQorCXN0cnVjdCBpbm9kZQkqaW5vZGUgPSBWRlNfSShpcCk7DQorCXVtb2RlX3QJCW1v
ZGUgPSBpYXR0ci0+aWFfbW9kZTsNCisNCisJQVNTRVJUKHRwKTsNCisJQVNTRVJUKHhmc19pc2ls
b2NrZWQoaXAsIFhGU19JTE9DS19FWENMKSk7DQorDQorCWlmICghaW5fZ3JvdXBfcChpbm9kZS0+
aV9naWQpICYmICFjYXBhYmxlKENBUF9GU0VUSUQpKQ0KKwkJbW9kZSAmPSB+U19JU0dJRDsNCisN
CisJaXAtPmlfZC5kaV9tb2RlICY9IFNfSUZNVDsNCisJaXAtPmlfZC5kaV9tb2RlIHw9IG1vZGUg
JiB+U19JRk1UOw0KKw0KKwlpbm9kZS0+aV9tb2RlICY9IFNfSUZNVDsNCisJaW5vZGUtPmlfbW9k
ZSB8PSBtb2RlICYgflNfSUZNVDsNCit9DQorDQogaW50DQogeGZzX3NldGF0dHJfbm9uc2l6ZSgN
CiAJc3RydWN0IHhmc19pbm9kZQkqaXAsDQpAQCAtNjU4LDE4ICs2ODAsOCBAQCB4ZnNfc2V0YXR0
cl9ub25zaXplKA0KIAkvKg0KIAkgKiBDaGFuZ2UgZmlsZSBhY2Nlc3MgbW9kZXMuDQogCSAqLw0K
LQlpZiAobWFzayAmIEFUVFJfTU9ERSkgew0KLQkJdW1vZGVfdCBtb2RlID0gaWF0dHItPmlhX21v
ZGU7DQotDQotCQlpZiAoIWluX2dyb3VwX3AoaW5vZGUtPmlfZ2lkKSAmJiAhY2FwYWJsZShDQVBf
RlNFVElEKSkNCi0JCQltb2RlICY9IH5TX0lTR0lEOw0KLQ0KLQkJaXAtPmlfZC5kaV9tb2RlICY9
IFNfSUZNVDsNCi0JCWlwLT5pX2QuZGlfbW9kZSB8PSBtb2RlICYgflNfSUZNVDsNCi0NCi0JCWlu
b2RlLT5pX21vZGUgJj0gU19JRk1UOw0KLQkJaW5vZGUtPmlfbW9kZSB8PSBtb2RlICYgflNfSUZN
VDsNCi0JfQ0KKwlpZiAobWFzayAmIEFUVFJfTU9ERSkNCisJCXhmc19zZXRhdHRyX21vZGUodHAs
IGlwLCBpYXR0cik7DQogDQogCS8qDQogCSAqIENoYW5nZSBmaWxlIGFjY2VzcyBvciBtb2RpZmll
ZCB0aW1lcy4NCkBAIC03NjgsOSArNzgwLDggQEAgeGZzX3NldGF0dHJfc2l6ZSgNCiAJCXJldHVy
biBYRlNfRVJST1IoZXJyb3IpOw0KIA0KIAlBU1NFUlQoU19JU1JFRyhpcC0+aV9kLmRpX21vZGUp
KTsNCi0JQVNTRVJUKChtYXNrICYgKEFUVFJfTU9ERXxBVFRSX1VJRHxBVFRSX0dJRHxBVFRSX0FU
SU1FfEFUVFJfQVRJTUVfU0VUfA0KLQkJCUFUVFJfTVRJTUVfU0VUfEFUVFJfS0lMTF9TVUlEfEFU
VFJfS0lMTF9TR0lEfA0KLQkJCUFUVFJfS0lMTF9QUklWfEFUVFJfVElNRVNfU0VUKSkgPT0gMCk7
DQorCUFTU0VSVCgobWFzayAmIChBVFRSX1VJRHxBVFRSX0dJRHxBVFRSX0FUSU1FfEFUVFJfQVRJ
TUVfU0VUfA0KKwkJCUFUVFJfTVRJTUVfU0VUfEFUVFJfS0lMTF9QUklWfEFUVFJfVElNRVNfU0VU
KSkgPT0gMCk7DQogDQogCWxvY2tfZmxhZ3MgPSBYRlNfSUxPQ0tfRVhDTDsNCiAJaWYgKCEoZmxh
Z3MgJiBYRlNfQVRUUl9OT0xPQ0spKQ0KQEAgLTkwMiw2ICs5MTMsMTIgQEAgeGZzX3NldGF0dHJf
c2l6ZSgNCiAJCXhmc19pZmxhZ3Nfc2V0KGlwLCBYRlNfSVRSVU5DQVRFRCk7DQogCX0NCiANCisJ
LyoNCisJICogQ2hhbmdlIGZpbGUgYWNjZXNzIG1vZGVzLg0KKwkgKi8NCisJaWYgKG1hc2sgJiBB
VFRSX01PREUpDQorCQl4ZnNfc2V0YXR0cl9tb2RlKHRwLCBpcCwgaWF0dHIpOw0KKw0KIAlpZiAo
bWFzayAmIEFUVFJfQ1RJTUUpIHsNCiAJCWlub2RlLT5pX2N0aW1lID0gaWF0dHItPmlhX2N0aW1l
Ow0KIAkJaXAtPmlfZC5kaV9jdGltZS50X3NlYyA9IGlhdHRyLT5pYV9jdGltZS50dl9zZWM7DQpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jcHUuaCBiL2luY2x1ZGUvbGludXgvY3B1LmgNCmlu
ZGV4IGM2OTJhY2MuLjljM2UwNzEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2NwdS5oDQor
KysgYi9pbmNsdWRlL2xpbnV4L2NwdS5oDQpAQCAtMTY4LDYgKzE2OCw4IEBAIGV4dGVybiBzdHJ1
Y3Qgc3lzZGV2X2NsYXNzIGNwdV9zeXNkZXZfY2xhc3M7DQogDQogZXh0ZXJuIHZvaWQgZ2V0X29u
bGluZV9jcHVzKHZvaWQpOw0KIGV4dGVybiB2b2lkIHB1dF9vbmxpbmVfY3B1cyh2b2lkKTsNCitl
eHRlcm4gdm9pZCBjcHVfaG90cGx1Z19kaXNhYmxlKHZvaWQpOw0KK2V4dGVybiB2b2lkIGNwdV9o
b3RwbHVnX2VuYWJsZSh2b2lkKTsNCiAjZGVmaW5lIGhvdGNwdV9ub3RpZmllcihmbiwgcHJpKQlj
cHVfbm90aWZpZXIoZm4sIHByaSkNCiAjZGVmaW5lIHJlZ2lzdGVyX2hvdGNwdV9ub3RpZmllcihu
YikJcmVnaXN0ZXJfY3B1X25vdGlmaWVyKG5iKQ0KICNkZWZpbmUgdW5yZWdpc3Rlcl9ob3RjcHVf
bm90aWZpZXIobmIpCXVucmVnaXN0ZXJfY3B1X25vdGlmaWVyKG5iKQ0KQEAgLTE5MCw2ICsxOTIs
OCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgY3B1X2hvdHBsdWdfZHJpdmVyX3VubG9jayh2b2lkKQ0K
IA0KICNkZWZpbmUgZ2V0X29ubGluZV9jcHVzKCkJZG8geyB9IHdoaWxlICgwKQ0KICNkZWZpbmUg
cHV0X29ubGluZV9jcHVzKCkJZG8geyB9IHdoaWxlICgwKQ0KKyNkZWZpbmUgY3B1X2hvdHBsdWdf
ZGlzYWJsZSgpCWRvIHsgfSB3aGlsZSAoMCkNCisjZGVmaW5lIGNwdV9ob3RwbHVnX2VuYWJsZSgp
CWRvIHsgfSB3aGlsZSAoMCkNCiAjZGVmaW5lIGhvdGNwdV9ub3RpZmllcihmbiwgcHJpKQlkbyB7
ICh2b2lkKShmbik7IH0gd2hpbGUgKDApDQogLyogVGhlc2UgYXJlbid0IGlubGluZSBmdW5jdGlv
bnMgZHVlIHRvIGEgR0NDIGJ1Zy4gKi8NCiAjZGVmaW5lIHJlZ2lzdGVyX2hvdGNwdV9ub3RpZmll
cihuYikJKHsgKHZvaWQpKG5iKTsgMDsgfSkNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25l
dC5oIGIvaW5jbHVkZS9saW51eC9uZXQuaA0KaW5kZXggYjI5OTIzMC4uYjdjYTA4ZSAxMDA2NDQN
Ci0tLSBhL2luY2x1ZGUvbGludXgvbmV0LmgNCisrKyBiL2luY2x1ZGUvbGludXgvbmV0LmgNCkBA
IC0yNDksNiArMjQ5LDI5IEBAIGV4dGVybiBzdHJ1Y3Qgc29ja2V0ICpzb2NrZmRfbG9va3VwKGlu
dCBmZCwgaW50ICplcnIpOw0KICNkZWZpbmUJCSAgICAgc29ja2ZkX3B1dChzb2NrKSBmcHV0KHNv
Y2stPmZpbGUpDQogZXh0ZXJuIGludAkgICAgIG5ldF9yYXRlbGltaXQodm9pZCk7DQogDQorI2Rl
ZmluZSBuZXRfcmF0ZWxpbWl0ZWRfZnVuY3Rpb24oZnVuY3Rpb24sIC4uLikJCQlcDQorZG8gewkJ
CQkJCQkJXA0KKwlpZiAobmV0X3JhdGVsaW1pdCgpKQkJCQkJXA0KKwkJZnVuY3Rpb24oX19WQV9B
UkdTX18pOwkJCQlcDQorfSB3aGlsZSAoMCkNCisNCisjZGVmaW5lIG5ldF9lbWVyZ19yYXRlbGlt
aXRlZChmbXQsIC4uLikJCQkJXA0KKwluZXRfcmF0ZWxpbWl0ZWRfZnVuY3Rpb24ocHJfZW1lcmcs
IGZtdCwgIyNfX1ZBX0FSR1NfXykNCisjZGVmaW5lIG5ldF9hbGVydF9yYXRlbGltaXRlZChmbXQs
IC4uLikJCQkJXA0KKwluZXRfcmF0ZWxpbWl0ZWRfZnVuY3Rpb24ocHJfYWxlcnQsIGZtdCwgIyNf
X1ZBX0FSR1NfXykNCisjZGVmaW5lIG5ldF9jcml0X3JhdGVsaW1pdGVkKGZtdCwgLi4uKQkJCQlc
DQorCW5ldF9yYXRlbGltaXRlZF9mdW5jdGlvbihwcl9jcml0LCBmbXQsICMjX19WQV9BUkdTX18p
DQorI2RlZmluZSBuZXRfZXJyX3JhdGVsaW1pdGVkKGZtdCwgLi4uKQkJCQlcDQorCW5ldF9yYXRl
bGltaXRlZF9mdW5jdGlvbihwcl9lcnIsIGZtdCwgIyNfX1ZBX0FSR1NfXykNCisjZGVmaW5lIG5l
dF9ub3RpY2VfcmF0ZWxpbWl0ZWQoZm10LCAuLi4pCQkJXA0KKwluZXRfcmF0ZWxpbWl0ZWRfZnVu
Y3Rpb24ocHJfbm90aWNlLCBmbXQsICMjX19WQV9BUkdTX18pDQorI2RlZmluZSBuZXRfd2Fybl9y
YXRlbGltaXRlZChmbXQsIC4uLikJCQkJXA0KKwluZXRfcmF0ZWxpbWl0ZWRfZnVuY3Rpb24ocHJf
d2FybiwgZm10LCAjI19fVkFfQVJHU19fKQ0KKyNkZWZpbmUgbmV0X2luZm9fcmF0ZWxpbWl0ZWQo
Zm10LCAuLi4pCQkJCVwNCisJbmV0X3JhdGVsaW1pdGVkX2Z1bmN0aW9uKHByX2luZm8sIGZtdCwg
IyNfX1ZBX0FSR1NfXykNCisjZGVmaW5lIG5ldF9kYmdfcmF0ZWxpbWl0ZWQoZm10LCAuLi4pCQkJ
CVwNCisJbmV0X3JhdGVsaW1pdGVkX2Z1bmN0aW9uKHByX2RlYnVnLCBmbXQsICMjX19WQV9BUkdT
X18pDQorDQogI2RlZmluZSBuZXRfcmFuZG9tKCkJCXJhbmRvbTMyKCkNCiAjZGVmaW5lIG5ldF9z
cmFuZG9tKHNlZWQpCXNyYW5kb20zMigoX19mb3JjZSB1MzIpc2VlZCkNCiANCmRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L3N3YXBvcHMuaCBiL2luY2x1ZGUvbGludXgvc3dhcG9wcy5oDQppbmRl
eCBkNjk1NTYwNy4uN2Y2MmZhZiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvc3dhcG9wcy5o
DQorKysgYi9pbmNsdWRlL2xpbnV4L3N3YXBvcHMuaA0KQEAgLTEzNiw2ICsxMzYsNyBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgbWFrZV9taWdyYXRpb25fZW50cnlfcmVhZChzd3BfZW50cnlfdCAqZW50
cnkpDQogDQogZXh0ZXJuIHZvaWQgbWlncmF0aW9uX2VudHJ5X3dhaXQoc3RydWN0IG1tX3N0cnVj
dCAqbW0sIHBtZF90ICpwbWQsDQogCQkJCQl1bnNpZ25lZCBsb25nIGFkZHJlc3MpOw0KK2V4dGVy
biB2b2lkIG1pZ3JhdGlvbl9lbnRyeV93YWl0X2h1Z2Uoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHB0
ZV90ICpwdGUpOw0KICNlbHNlDQogDQogI2RlZmluZSBtYWtlX21pZ3JhdGlvbl9lbnRyeShwYWdl
LCB3cml0ZSkgc3dwX2VudHJ5KDAsIDApDQpAQCAtMTQ3LDYgKzE0OCw4IEBAIHN0YXRpYyBpbmxp
bmUgaW50IGlzX21pZ3JhdGlvbl9lbnRyeShzd3BfZW50cnlfdCBzd3ApDQogc3RhdGljIGlubGlu
ZSB2b2lkIG1ha2VfbWlncmF0aW9uX2VudHJ5X3JlYWQoc3dwX2VudHJ5X3QgKmVudHJ5cCkgeyB9
DQogc3RhdGljIGlubGluZSB2b2lkIG1pZ3JhdGlvbl9lbnRyeV93YWl0KHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tLCBwbWRfdCAqcG1kLA0KIAkJCQkJIHVuc2lnbmVkIGxvbmcgYWRkcmVzcykgeyB9DQor
c3RhdGljIGlubGluZSB2b2lkIG1pZ3JhdGlvbl9lbnRyeV93YWl0X2h1Z2Uoc3RydWN0IG1tX3N0
cnVjdCAqbW0sDQorCQkJCQlwdGVfdCAqcHRlKSB7IH0NCiBzdGF0aWMgaW5saW5lIGludCBpc193
cml0ZV9taWdyYXRpb25fZW50cnkoc3dwX2VudHJ5X3QgZW50cnkpDQogew0KIAlyZXR1cm4gMDsN
CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvaW8vbmV0aWYuaCBiL2luY2x1ZGUv
eGVuL2ludGVyZmFjZS9pby9uZXRpZi5oDQppbmRleCBjYjk0NjY4Li5kNDYzNWNkIDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL2lvL25ldGlmLmgNCisrKyBiL2luY2x1ZGUveGVu
L2ludGVyZmFjZS9pby9uZXRpZi5oDQpAQCAtMTMsNiArMTMsMjQgQEANCiAjaW5jbHVkZSAiLi4v
Z3JhbnRfdGFibGUuaCINCiANCiAvKg0KKyAqIE9sZGVyIGltcGxlbWVudGF0aW9uIG9mIFhlbiBu
ZXR3b3JrIGZyb250ZW5kIC8gYmFja2VuZCBoYXMgYW4NCisgKiBpbXBsaWNpdCBkZXBlbmRlbmN5
IG9uIHRoZSBNQVhfU0tCX0ZSQUdTIGFzIHRoZSBtYXhpbXVtIG51bWJlciBvZg0KKyAqIHJpbmcg
c2xvdHMgYSBza2IgY2FuIHVzZS4gTmV0ZnJvbnQgLyBuZXRiYWNrIG1heSBub3Qgd29yayBhcw0K
KyAqIGV4cGVjdGVkIHdoZW4gZnJvbnRlbmQgYW5kIGJhY2tlbmQgaGF2ZSBkaWZmZXJlbnQgTUFY
X1NLQl9GUkFHUy4NCisgKg0KKyAqIEEgYmV0dGVyIGFwcHJvYWNoIGlzIHRvIGFkZCBtZWNoYW5p
c20gZm9yIG5ldGZyb250IC8gbmV0YmFjayB0bw0KKyAqIG5lZ290aWF0ZSB0aGlzIHZhbHVlLiBI
b3dldmVyIHdlIGNhbm5vdCBmaXggYWxsIHBvc3NpYmxlDQorICogZnJvbnRlbmRzLCBzbyB3ZSBu
ZWVkIHRvIGRlZmluZSBhIHZhbHVlIHdoaWNoIHN0YXRlcyB0aGUgbWluaW11bQ0KKyAqIHNsb3Rz
IGJhY2tlbmQgbXVzdCBzdXBwb3J0Lg0KKyAqDQorICogVGhlIG1pbmltdW0gdmFsdWUgZGVyaXZl
cyBmcm9tIG9sZGVyIExpbnV4IGtlcm5lbCdzIE1BWF9TS0JfRlJBR1MNCisgKiAoMTgpLCB3aGlj
aCBpcyBwcm92ZWQgdG8gd29yayB3aXRoIG1vc3QgZnJvbnRlbmRzLiBBbnkgbmV3IGJhY2tlbmQN
CisgKiB3aGljaCBkb2Vzbid0IG5lZ290aWF0ZSB3aXRoIGZyb250ZW5kIHNob3VsZCBleHBlY3Qg
ZnJvbnRlbmQgdG8NCisgKiBzZW5kIGEgdmFsaWQgcGFja2V0IHVzaW5nIHNsb3RzIHVwIHRvIHRo
aXMgdmFsdWUuDQorICovDQorI2RlZmluZSBYRU5fTkVUSUZfTlJfU0xPVFNfTUlOIDE4DQorDQor
LyoNCiAgKiBOb3RpZmljYXRpb25zIGFmdGVyIGVucXVldWluZyBhbnkgdHlwZSBvZiBtZXNzYWdl
IHNob3VsZCBiZSBjb25kaXRpb25hbCBvbg0KICAqIHRoZSBhcHByb3ByaWF0ZSByZXFfZXZlbnQg
b3IgcnNwX2V2ZW50IGZpZWxkIGluIHRoZSBzaGFyZWQgcmluZy4NCiAgKiBJZiB0aGUgY2xpZW50
IHNlbmRzIG5vdGlmaWNhdGlvbiBmb3IgcnggcmVxdWVzdHMgdGhlbiBpdCBzaG91bGQgc3BlY2lm
eQ0KQEAgLTQ3LDYgKzY1LDcgQEANCiAjZGVmaW5lIF9YRU5fTkVUVFhGX2V4dHJhX2luZm8JCSgz
KQ0KICNkZWZpbmUgIFhFTl9ORVRUWEZfZXh0cmFfaW5mbwkJKDFVPDxfWEVOX05FVFRYRl9leHRy
YV9pbmZvKQ0KIA0KKyNkZWZpbmUgWEVOX05FVElGX01BWF9UWF9TSVpFIDB4RkZGRg0KIHN0cnVj
dCB4ZW5fbmV0aWZfdHhfcmVxdWVzdCB7DQogICAgIGdyYW50X3JlZl90IGdyZWY7ICAgICAgLyog
UmVmZXJlbmNlIHRvIGJ1ZmZlciBwYWdlICovDQogICAgIHVpbnQxNl90IG9mZnNldDsgICAgICAg
LyogT2Zmc2V0IHdpdGhpbiBidWZmZXIgcGFnZSAqLw0KZGlmZiAtLWdpdCBhL2tlcm5lbC9hdWRp
dC5jIGIva2VybmVsL2F1ZGl0LmMNCmluZGV4IDA5ZmFlMjYuLmQ0YmM1OTQgMTAwNjQ0DQotLS0g
YS9rZXJuZWwvYXVkaXQuYw0KKysrIGIva2VybmVsL2F1ZGl0LmMNCkBAIC0xMTY3LDcgKzExNjcs
NyBAQCBzdHJ1Y3QgYXVkaXRfYnVmZmVyICphdWRpdF9sb2dfc3RhcnQoc3RydWN0IGF1ZGl0X2Nv
bnRleHQgKmN0eCwgZ2ZwX3QgZ2ZwX21hc2ssDQogDQogCQkJLyogV2FpdCBmb3IgYXVkaXRkIHRv
IGRyYWluIHRoZSBxdWV1ZSBhIGxpdHRsZSAqLw0KIAkJCURFQ0xBUkVfV0FJVFFVRVVFKHdhaXQs
IGN1cnJlbnQpOw0KLQkJCXNldF9jdXJyZW50X3N0YXRlKFRBU0tfSU5URVJSVVBUSUJMRSk7DQor
CQkJc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19VTklOVEVSUlVQVElCTEUpOw0KIAkJCWFkZF93YWl0
X3F1ZXVlKCZhdWRpdF9iYWNrbG9nX3dhaXQsICZ3YWl0KTsNCiANCiAJCQlpZiAoYXVkaXRfYmFj
a2xvZ19saW1pdCAmJg0KZGlmZiAtLWdpdCBhL2tlcm5lbC9jcHUuYyBiL2tlcm5lbC9jcHUuYw0K
aW5kZXggNTYzZjEzNi4uODJjOTFmMSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9jcHUuYw0KKysrIGIv
a2VybmVsL2NwdS5jDQpAQCAtMTI0LDYgKzEyNCwyNyBAQCBzdGF0aWMgdm9pZCBjcHVfaG90cGx1
Z19kb25lKHZvaWQpDQogCW11dGV4X3VubG9jaygmY3B1X2hvdHBsdWcubG9jayk7DQogfQ0KIA0K
Ky8qDQorICogV2FpdCBmb3IgY3VycmVudGx5IHJ1bm5pbmcgQ1BVIGhvdHBsdWcgb3BlcmF0aW9u
cyB0byBjb21wbGV0ZSAoaWYgYW55KSBhbmQNCisgKiBkaXNhYmxlIGZ1dHVyZSBDUFUgaG90cGx1
ZyAoZnJvbSBzeXNmcykuIFRoZSAnY3B1X2FkZF9yZW1vdmVfbG9jaycgcHJvdGVjdHMNCisgKiB0
aGUgJ2NwdV9ob3RwbHVnX2Rpc2FibGVkJyBmbGFnLiBUaGUgc2FtZSBsb2NrIGlzIGFsc28gYWNx
dWlyZWQgYnkgdGhlDQorICogaG90cGx1ZyBwYXRoIGJlZm9yZSBwZXJmb3JtaW5nIGhvdHBsdWcg
b3BlcmF0aW9ucy4gU28gYWNxdWlyaW5nIHRoYXQgbG9jaw0KKyAqIGd1YXJhbnRlZXMgbXV0dWFs
IGV4Y2x1c2lvbiBmcm9tIGFueSBjdXJyZW50bHkgcnVubmluZyBob3RwbHVnIG9wZXJhdGlvbnMu
DQorICovDQordm9pZCBjcHVfaG90cGx1Z19kaXNhYmxlKHZvaWQpDQorew0KKwljcHVfbWFwc191
cGRhdGVfYmVnaW4oKTsNCisJY3B1X2hvdHBsdWdfZGlzYWJsZWQgPSAxOw0KKwljcHVfbWFwc191
cGRhdGVfZG9uZSgpOw0KK30NCisNCit2b2lkIGNwdV9ob3RwbHVnX2VuYWJsZSh2b2lkKQ0KK3sN
CisJY3B1X21hcHNfdXBkYXRlX2JlZ2luKCk7DQorCWNwdV9ob3RwbHVnX2Rpc2FibGVkID0gMDsN
CisJY3B1X21hcHNfdXBkYXRlX2RvbmUoKTsNCit9DQorDQogI2Vsc2UgLyogI2lmIENPTkZJR19I
T1RQTFVHX0NQVSAqLw0KIHN0YXRpYyB2b2lkIGNwdV9ob3RwbHVnX2JlZ2luKHZvaWQpIHt9DQog
c3RhdGljIHZvaWQgY3B1X2hvdHBsdWdfZG9uZSh2b2lkKSB7fQ0KQEAgLTQ3OSwzNiArNTAwLDYg
QEAgc3RhdGljIGludCBhbGxvY19mcm96ZW5fY3B1cyh2b2lkKQ0KIGNvcmVfaW5pdGNhbGwoYWxs
b2NfZnJvemVuX2NwdXMpOw0KIA0KIC8qDQotICogUHJldmVudCByZWd1bGFyIENQVSBob3RwbHVn
IGZyb20gcmFjaW5nIHdpdGggdGhlIGZyZWV6ZXIsIGJ5IGRpc2FibGluZyBDUFUNCi0gKiBob3Rw
bHVnIHdoZW4gdGFza3MgYXJlIGFib3V0IHRvIGJlIGZyb3plbi4gQWxzbywgZG9uJ3QgYWxsb3cg
dGhlIGZyZWV6ZXINCi0gKiB0byBjb250aW51ZSB1bnRpbCBhbnkgY3VycmVudGx5IHJ1bm5pbmcg
Q1BVIGhvdHBsdWcgb3BlcmF0aW9uIGdldHMNCi0gKiBjb21wbGV0ZWQuDQotICogVG8gbW9kaWZ5
IHRoZSAnY3B1X2hvdHBsdWdfZGlzYWJsZWQnIGZsYWcsIHdlIG5lZWQgdG8gYWNxdWlyZSB0aGUN
Ci0gKiAnY3B1X2FkZF9yZW1vdmVfbG9jaycuIEFuZCB0aGlzIHNhbWUgbG9jayBpcyBhbHNvIHRh
a2VuIGJ5IHRoZSByZWd1bGFyDQotICogQ1BVIGhvdHBsdWcgcGF0aCBhbmQgcmVsZWFzZWQgb25s
eSBhZnRlciBpdCBpcyBjb21wbGV0ZS4gVGh1cywgd2UNCi0gKiAoYW5kIGhlbmNlIHRoZSBmcmVl
emVyKSB3aWxsIGJsb2NrIGhlcmUgdW50aWwgYW55IGN1cnJlbnRseSBydW5uaW5nIENQVQ0KLSAq
IGhvdHBsdWcgb3BlcmF0aW9uIGdldHMgY29tcGxldGVkLg0KLSAqLw0KLXZvaWQgY3B1X2hvdHBs
dWdfZGlzYWJsZV9iZWZvcmVfZnJlZXplKHZvaWQpDQotew0KLQljcHVfbWFwc191cGRhdGVfYmVn
aW4oKTsNCi0JY3B1X2hvdHBsdWdfZGlzYWJsZWQgPSAxOw0KLQljcHVfbWFwc191cGRhdGVfZG9u
ZSgpOw0KLX0NCi0NCi0NCi0vKg0KLSAqIFdoZW4gdGFza3MgaGF2ZSBiZWVuIHRoYXdlZCwgcmUt
ZW5hYmxlIHJlZ3VsYXIgQ1BVIGhvdHBsdWcgKHdoaWNoIGhhZCBiZWVuDQotICogZGlzYWJsZWQg
d2hpbGUgYmVnaW5uaW5nIHRvIGZyZWV6ZSB0YXNrcykuDQotICovDQotdm9pZCBjcHVfaG90cGx1
Z19lbmFibGVfYWZ0ZXJfdGhhdyh2b2lkKQ0KLXsNCi0JY3B1X21hcHNfdXBkYXRlX2JlZ2luKCk7
DQotCWNwdV9ob3RwbHVnX2Rpc2FibGVkID0gMDsNCi0JY3B1X21hcHNfdXBkYXRlX2RvbmUoKTsN
Ci19DQotDQotLyoNCiAgKiBXaGVuIGNhbGxiYWNrcyBmb3IgQ1BVIGhvdHBsdWcgbm90aWZpY2F0
aW9ucyBhcmUgYmVpbmcgZXhlY3V0ZWQsIHdlIG11c3QNCiAgKiBlbnN1cmUgdGhhdCB0aGUgc3Rh
dGUgb2YgdGhlIHN5c3RlbSB3aXRoIHJlc3BlY3QgdG8gdGhlIHRhc2tzIGJlaW5nIGZyb3plbg0K
ICAqIG9yIG5vdCwgYXMgcmVwb3J0ZWQgYnkgdGhlIG5vdGlmaWNhdGlvbiwgcmVtYWlucyB1bmNo
YW5nZWQgKnRocm91Z2hvdXQgdGhlDQpAQCAtNTI3LDEyICs1MTgsMTIgQEAgY3B1X2hvdHBsdWdf
cG1fY2FsbGJhY2soc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwNCiANCiAJY2FzZSBQTV9TVVNQ
RU5EX1BSRVBBUkU6DQogCWNhc2UgUE1fSElCRVJOQVRJT05fUFJFUEFSRToNCi0JCWNwdV9ob3Rw
bHVnX2Rpc2FibGVfYmVmb3JlX2ZyZWV6ZSgpOw0KKwkJY3B1X2hvdHBsdWdfZGlzYWJsZSgpOw0K
IAkJYnJlYWs7DQogDQogCWNhc2UgUE1fUE9TVF9TVVNQRU5EOg0KIAljYXNlIFBNX1BPU1RfSElC
RVJOQVRJT046DQotCQljcHVfaG90cGx1Z19lbmFibGVfYWZ0ZXJfdGhhdygpOw0KKwkJY3B1X2hv
dHBsdWdfZW5hYmxlKCk7DQogCQlicmVhazsNCiANCiAJZGVmYXVsdDoNCmRpZmYgLS1naXQgYS9r
ZXJuZWwvc3lzLmMgYi9rZXJuZWwvc3lzLmMNCmluZGV4IGJlNWZhOGIuLjlkNTU3ZGYgMTAwNjQ0
DQotLS0gYS9rZXJuZWwvc3lzLmMNCisrKyBiL2tlcm5lbC9zeXMuYw0KQEAgLTM1Myw2ICszNTMs
MjkgQEAgaW50IHVucmVnaXN0ZXJfcmVib290X25vdGlmaWVyKHN0cnVjdCBub3RpZmllcl9ibG9j
ayAqbmIpDQogfQ0KIEVYUE9SVF9TWU1CT0wodW5yZWdpc3Rlcl9yZWJvb3Rfbm90aWZpZXIpOw0K
IA0KKy8qIEFkZCBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBmb3Igc3RhYmxlIHRyZWVzLiAqLw0K
KyNpZm5kZWYgUEZfTk9fU0VUQUZGSU5JVFkNCisjZGVmaW5lIFBGX05PX1NFVEFGRklOSVRZCQlQ
Rl9USFJFQURfQk9VTkQNCisjZW5kaWYNCisNCitzdGF0aWMgdm9pZCBtaWdyYXRlX3RvX3JlYm9v
dF9jcHUodm9pZCkNCit7DQorCS8qIFRoZSBib290IGNwdSBpcyBhbHdheXMgbG9naWNhbCBjcHUg
MCAqLw0KKwlpbnQgY3B1ID0gMDsNCisNCisJY3B1X2hvdHBsdWdfZGlzYWJsZSgpOw0KKw0KKwkv
KiBNYWtlIGNlcnRhaW4gdGhlIGNwdSBJJ20gYWJvdXQgdG8gcmVib290IG9uIGlzIG9ubGluZSAq
Lw0KKwlpZiAoIWNwdV9vbmxpbmUoY3B1KSkNCisJCWNwdSA9IGNwdW1hc2tfZmlyc3QoY3B1X29u
bGluZV9tYXNrKTsNCisNCisJLyogUHJldmVudCByYWNlcyB3aXRoIG90aGVyIHRhc2tzIG1pZ3Jh
dGluZyB0aGlzIHRhc2sgKi8NCisJY3VycmVudC0+ZmxhZ3MgfD0gUEZfTk9fU0VUQUZGSU5JVFk7
DQorDQorCS8qIE1ha2UgY2VydGFpbiBJIG9ubHkgcnVuIG9uIHRoZSBhcHByb3ByaWF0ZSBwcm9j
ZXNzb3IgKi8NCisJc2V0X2NwdXNfYWxsb3dlZF9wdHIoY3VycmVudCwgY3B1bWFza19vZihjcHUp
KTsNCit9DQorDQogLyoqDQogICoJa2VybmVsX3Jlc3RhcnQgLSByZWJvb3QgdGhlIHN5c3RlbQ0K
ICAqCUBjbWQ6IHBvaW50ZXIgdG8gYnVmZmVyIGNvbnRhaW5pbmcgY29tbWFuZCB0byBleGVjdXRl
IGZvciByZXN0YXJ0DQpAQCAtMzY0LDcgKzM4Nyw3IEBAIEVYUE9SVF9TWU1CT0wodW5yZWdpc3Rl
cl9yZWJvb3Rfbm90aWZpZXIpOw0KIHZvaWQga2VybmVsX3Jlc3RhcnQoY2hhciAqY21kKQ0KIHsN
CiAJa2VybmVsX3Jlc3RhcnRfcHJlcGFyZShjbWQpOw0KLQlkaXNhYmxlX25vbmJvb3RfY3B1cygp
Ow0KKwltaWdyYXRlX3RvX3JlYm9vdF9jcHUoKTsNCiAJc3lzY29yZV9zaHV0ZG93bigpOw0KIAlp
ZiAoIWNtZCkNCiAJCXByaW50ayhLRVJOX0VNRVJHICJSZXN0YXJ0aW5nIHN5c3RlbS5cbiIpOw0K
QEAgLTM5MSw3ICs0MTQsNyBAQCBzdGF0aWMgdm9pZCBrZXJuZWxfc2h1dGRvd25fcHJlcGFyZShl
bnVtIHN5c3RlbV9zdGF0ZXMgc3RhdGUpDQogdm9pZCBrZXJuZWxfaGFsdCh2b2lkKQ0KIHsNCiAJ
a2VybmVsX3NodXRkb3duX3ByZXBhcmUoU1lTVEVNX0hBTFQpOw0KLQlkaXNhYmxlX25vbmJvb3Rf
Y3B1cygpOw0KKwltaWdyYXRlX3RvX3JlYm9vdF9jcHUoKTsNCiAJc3lzY29yZV9zaHV0ZG93bigp
Ow0KIAlwcmludGsoS0VSTl9FTUVSRyAiU3lzdGVtIGhhbHRlZC5cbiIpOw0KIAlrbXNnX2R1bXAo
S01TR19EVU1QX0hBTFQpOw0KQEAgLTQxMCw3ICs0MzMsNyBAQCB2b2lkIGtlcm5lbF9wb3dlcl9v
ZmYodm9pZCkNCiAJa2VybmVsX3NodXRkb3duX3ByZXBhcmUoU1lTVEVNX1BPV0VSX09GRik7DQog
CWlmIChwbV9wb3dlcl9vZmZfcHJlcGFyZSkNCiAJCXBtX3Bvd2VyX29mZl9wcmVwYXJlKCk7DQot
CWRpc2FibGVfbm9uYm9vdF9jcHVzKCk7DQorCW1pZ3JhdGVfdG9fcmVib290X2NwdSgpOw0KIAlz
eXNjb3JlX3NodXRkb3duKCk7DQogCXByaW50ayhLRVJOX0VNRVJHICJQb3dlciBkb3duLlxuIik7
DQogCWttc2dfZHVtcChLTVNHX0RVTVBfUE9XRVJPRkYpOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC90
cmFjZS9mdHJhY2UuYyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KaW5kZXggMjRiMzc1OS4uMjI2
Nzc2YiAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KKysrIGIva2VybmVsL3Ry
YWNlL2Z0cmFjZS5jDQpAQCAtOTI5LDYgKzkyOSwxOSBAQCBzdGF0aWMgX19pbml0IHZvaWQgZnRy
YWNlX3Byb2ZpbGVfZGVidWdmcyhzdHJ1Y3QgZGVudHJ5ICpkX3RyYWNlcikNCiANCiBzdGF0aWMg
c3RydWN0IHBpZCAqIGNvbnN0IGZ0cmFjZV9zd2FwcGVyX3BpZCA9ICZpbml0X3N0cnVjdF9waWQ7
DQogDQorc3RhdGljIGxvZmZfdA0KK2Z0cmFjZV9maWx0ZXJfbHNlZWsoc3RydWN0IGZpbGUgKmZp
bGUsIGxvZmZfdCBvZmZzZXQsIGludCB3aGVuY2UpDQorew0KKwlsb2ZmX3QgcmV0Ow0KKw0KKwlp
ZiAoZmlsZS0+Zl9tb2RlICYgRk1PREVfUkVBRCkNCisJCXJldCA9IHNlcV9sc2VlayhmaWxlLCBv
ZmZzZXQsIHdoZW5jZSk7DQorCWVsc2UNCisJCWZpbGUtPmZfcG9zID0gcmV0ID0gMTsNCisNCisJ
cmV0dXJuIHJldDsNCit9DQorDQogI2lmZGVmIENPTkZJR19EWU5BTUlDX0ZUUkFDRQ0KIA0KICNp
Zm5kZWYgQ09ORklHX0ZUUkFDRV9NQ09VTlRfUkVDT1JEDQpAQCAtMjMxNSwxOSArMjMyOCw2IEBA
IGZ0cmFjZV9ub3RyYWNlX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZp
bGUpDQogCQkJCSBpbm9kZSwgZmlsZSk7DQogfQ0KIA0KLXN0YXRpYyBsb2ZmX3QNCi1mdHJhY2Vf
ZmlsdGVyX2xzZWVrKHN0cnVjdCBmaWxlICpmaWxlLCBsb2ZmX3Qgb2Zmc2V0LCBpbnQgb3JpZ2lu
KQ0KLXsNCi0JbG9mZl90IHJldDsNCi0NCi0JaWYgKGZpbGUtPmZfbW9kZSAmIEZNT0RFX1JFQUQp
DQotCQlyZXQgPSBzZXFfbHNlZWsoZmlsZSwgb2Zmc2V0LCBvcmlnaW4pOw0KLQllbHNlDQotCQlm
aWxlLT5mX3BvcyA9IHJldCA9IDE7DQotDQotCXJldHVybiByZXQ7DQotfQ0KLQ0KIHN0YXRpYyBp
bnQgZnRyYWNlX21hdGNoKGNoYXIgKnN0ciwgY2hhciAqcmVnZXgsIGludCBsZW4sIGludCB0eXBl
KQ0KIHsNCiAJaW50IG1hdGNoZWQgPSAwOw0KZGlmZiAtLWdpdCBhL21tL2h1Z2V0bGIuYyBiL21t
L2h1Z2V0bGIuYw0KaW5kZXggNzBiNDczMy4uMmRjZDcxNiAxMDA2NDQNCi0tLSBhL21tL2h1Z2V0
bGIuYw0KKysrIGIvbW0vaHVnZXRsYi5jDQpAQCAtMjc1MSw3ICsyNzUxLDcgQEAgaW50IGh1Z2V0
bGJfZmF1bHQoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1h
LA0KIAlpZiAocHRlcCkgew0KIAkJZW50cnkgPSBodWdlX3B0ZXBfZ2V0KHB0ZXApOw0KIAkJaWYg
KHVubGlrZWx5KGlzX2h1Z2V0bGJfZW50cnlfbWlncmF0aW9uKGVudHJ5KSkpIHsNCi0JCQltaWdy
YXRpb25fZW50cnlfd2FpdChtbSwgKHBtZF90ICopcHRlcCwgYWRkcmVzcyk7DQorCQkJbWlncmF0
aW9uX2VudHJ5X3dhaXRfaHVnZShtbSwgcHRlcCk7DQogCQkJcmV0dXJuIDA7DQogCQl9IGVsc2Ug
aWYgKHVubGlrZWx5KGlzX2h1Z2V0bGJfZW50cnlfaHdwb2lzb25lZChlbnRyeSkpKQ0KIAkJCXJl
dHVybiBWTV9GQVVMVF9IV1BPSVNPTl9MQVJHRSB8DQpkaWZmIC0tZ2l0IGEvbW0vbWlncmF0ZS5j
IGIvbW0vbWlncmF0ZS5jDQppbmRleCBlMTA1MmQxLi4wOWQ2YTlkIDEwMDY0NA0KLS0tIGEvbW0v
bWlncmF0ZS5jDQorKysgYi9tbS9taWdyYXRlLmMNCkBAIC0xODQsMTUgKzE4NCwxNCBAQCBzdGF0
aWMgdm9pZCByZW1vdmVfbWlncmF0aW9uX3B0ZXMoc3RydWN0IHBhZ2UgKm9sZCwgc3RydWN0IHBh
Z2UgKm5ldykNCiAgKg0KICAqIFRoaXMgZnVuY3Rpb24gaXMgY2FsbGVkIGZyb20gZG9fc3dhcF9w
YWdlKCkuDQogICovDQotdm9pZCBtaWdyYXRpb25fZW50cnlfd2FpdChzdHJ1Y3QgbW1fc3RydWN0
ICptbSwgcG1kX3QgKnBtZCwNCi0JCQkJdW5zaWduZWQgbG9uZyBhZGRyZXNzKQ0KK3N0YXRpYyB2
b2lkIF9fbWlncmF0aW9uX2VudHJ5X3dhaXQoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHB0ZV90ICpw
dGVwLA0KKwkJCQlzcGlubG9ja190ICpwdGwpDQogew0KLQlwdGVfdCAqcHRlcCwgcHRlOw0KLQlz
cGlubG9ja190ICpwdGw7DQorCXB0ZV90IHB0ZTsNCiAJc3dwX2VudHJ5X3QgZW50cnk7DQogCXN0
cnVjdCBwYWdlICpwYWdlOw0KIA0KLQlwdGVwID0gcHRlX29mZnNldF9tYXBfbG9jayhtbSwgcG1k
LCBhZGRyZXNzLCAmcHRsKTsNCisJc3Bpbl9sb2NrKHB0bCk7DQogCXB0ZSA9ICpwdGVwOw0KIAlp
ZiAoIWlzX3N3YXBfcHRlKHB0ZSkpDQogCQlnb3RvIG91dDsNCkBAIC0yMjAsNiArMjE5LDIwIEBA
IG91dDoNCiAJcHRlX3VubWFwX3VubG9jayhwdGVwLCBwdGwpOw0KIH0NCiANCit2b2lkIG1pZ3Jh
dGlvbl9lbnRyeV93YWl0KHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBwbWRfdCAqcG1kLA0KKwkJCQl1
bnNpZ25lZCBsb25nIGFkZHJlc3MpDQorew0KKwlzcGlubG9ja190ICpwdGwgPSBwdGVfbG9ja3B0
cihtbSwgcG1kKTsNCisJcHRlX3QgKnB0ZXAgPSBwdGVfb2Zmc2V0X21hcChwbWQsIGFkZHJlc3Mp
Ow0KKwlfX21pZ3JhdGlvbl9lbnRyeV93YWl0KG1tLCBwdGVwLCBwdGwpOw0KK30NCisNCit2b2lk
IG1pZ3JhdGlvbl9lbnRyeV93YWl0X2h1Z2Uoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHB0ZV90ICpw
dGUpDQorew0KKwlzcGlubG9ja190ICpwdGwgPSAmKG1tKS0+cGFnZV90YWJsZV9sb2NrOw0KKwlf
X21pZ3JhdGlvbl9lbnRyeV93YWl0KG1tLCBwdGUsIHB0bCk7DQorfQ0KKw0KICNpZmRlZiBDT05G
SUdfQkxPQ0sNCiAvKiBSZXR1cm5zIHRydWUgaWYgYWxsIGJ1ZmZlcnMgYXJlIHN1Y2Nlc3NmdWxs
eSBsb2NrZWQgKi8NCiBzdGF0aWMgYm9vbCBidWZmZXJfbWlncmF0ZV9sb2NrX2J1ZmZlcnMoc3Ry
dWN0IGJ1ZmZlcl9oZWFkICpoZWFkLA0KZGlmZiAtLWdpdCBhL21tL3N3YXBfc3RhdGUuYyBiL21t
L3N3YXBfc3RhdGUuYw0KaW5kZXggNzcwNGQ5Yy4uN2IzZGFkZCAxMDA2NDQNCi0tLSBhL21tL3N3
YXBfc3RhdGUuYw0KKysrIGIvbW0vc3dhcF9zdGF0ZS5jDQpAQCAtMzE0LDggKzMxNCwyNCBAQCBz
dHJ1Y3QgcGFnZSAqcmVhZF9zd2FwX2NhY2hlX2FzeW5jKHN3cF9lbnRyeV90IGVudHJ5LCBnZnBf
dCBnZnBfbWFzaywNCiAJCSAqIFN3YXAgZW50cnkgbWF5IGhhdmUgYmVlbiBmcmVlZCBzaW5jZSBv
dXIgY2FsbGVyIG9ic2VydmVkIGl0Lg0KIAkJICovDQogCQllcnIgPSBzd2FwY2FjaGVfcHJlcGFy
ZShlbnRyeSk7DQotCQlpZiAoZXJyID09IC1FRVhJU1QpIHsJLyogc2VlbXMgcmFjeSAqLw0KKwkJ
aWYgKGVyciA9PSAtRUVYSVNUKSB7DQogCQkJcmFkaXhfdHJlZV9wcmVsb2FkX2VuZCgpOw0KKwkJ
CS8qDQorCQkJICogV2UgbWlnaHQgcmFjZSBhZ2FpbnN0IGdldF9zd2FwX3BhZ2UoKSBhbmQgc3R1
bWJsZQ0KKwkJCSAqIGFjcm9zcyBhIFNXQVBfSEFTX0NBQ0hFIHN3YXBfbWFwIGVudHJ5IHdob3Nl
IHBhZ2UNCisJCQkgKiBoYXMgbm90IGJlZW4gYnJvdWdodCBpbnRvIHRoZSBzd2FwY2FjaGUgeWV0
LCB3aGlsZQ0KKwkJCSAqIHRoZSBvdGhlciBlbmQgaXMgc2NoZWR1bGVkIGF3YXkgd2FpdGluZyBv
biBkaXNjYXJkDQorCQkJICogSS9PIGNvbXBsZXRpb24gYXQgc2Nhbl9zd2FwX21hcCgpLg0KKwkJ
CSAqDQorCQkJICogSW4gb3JkZXIgdG8gYXZvaWQgdHVybmluZyB0aGlzIHRyYW5zaXRvcnkgc3Rh
dGUNCisJCQkgKiBpbnRvIGEgcGVybWFuZW50IGxvb3AgYXJvdW5kIHRoaXMgLUVFWElTVCBjYXNl
DQorCQkJICogaWYgIUNPTkZJR19QUkVFTVBUIGFuZCB0aGUgSS9PIGNvbXBsZXRpb24gaGFwcGVu
cw0KKwkJCSAqIHRvIGJlIHdhaXRpbmcgb24gdGhlIENQVSB3YWl0cXVldWUgd2hlcmUgd2UgYXJl
IG5vdw0KKwkJCSAqIGJ1c3kgbG9vcGluZywgd2UganVzdCBjb25kaXRpb25hbGx5IGludm9rZSB0
aGUNCisJCQkgKiBzY2hlZHVsZXIgaGVyZSwgaWYgdGhlcmUgYXJlIHNvbWUgbW9yZSBpbXBvcnRh
bnQNCisJCQkgKiB0YXNrcyB0byBydW4uDQorCQkJICovDQorCQkJY29uZF9yZXNjaGVkKCk7DQog
CQkJY29udGludWU7DQogCQl9DQogCQlpZiAoZXJyKSB7CQkvKiBzd3AgZW50cnkgaXMgb2Jzb2xl
dGUgPyAqLw0KZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jIGIvbmV0L2Js
dWV0b290aC9sMmNhcF9jb3JlLmMNCmluZGV4IDA0MTc1ZDkuLmEwYjZjNTAgMTAwNjQ0DQotLS0g
YS9uZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYw0KKysrIGIvbmV0L2JsdWV0b290aC9sMmNhcF9j
b3JlLmMNCkBAIC0yMjk3LDEwICsyMjk3LDE1IEBAIGRvbmU6DQogCX0NCiB9DQogDQotc3RhdGlj
IGlubGluZSBpbnQgbDJjYXBfY29tbWFuZF9yZWooc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sIHN0
cnVjdCBsMmNhcF9jbWRfaGRyICpjbWQsIHU4ICpkYXRhKQ0KK3N0YXRpYyBpbmxpbmUgaW50IGwy
Y2FwX2NvbW1hbmRfcmVqKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLA0KKwkJCQkgICAgc3RydWN0
IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTE2IGNtZF9sZW4sDQorCQkJCSAgICB1OCAqZGF0YSkNCiB7
DQogCXN0cnVjdCBsMmNhcF9jbWRfcmVqX3VuayAqcmVqID0gKHN0cnVjdCBsMmNhcF9jbWRfcmVq
X3VuayAqKSBkYXRhOw0KIA0KKwlpZiAoY21kX2xlbiA8IHNpemVvZigqcmVqKSkNCisJCXJldHVy
biAtRVBST1RPOw0KKw0KIAlpZiAocmVqLT5yZWFzb24gIT0gTDJDQVBfUkVKX05PVF9VTkRFUlNU
T09EKQ0KIAkJcmV0dXJuIDA7DQogDQpAQCAtMjMxNyw3ICsyMzIyLDggQEAgc3RhdGljIGlubGlu
ZSBpbnQgbDJjYXBfY29tbWFuZF9yZWooc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sIHN0cnVjdCBs
MmNhcF9jbWRfaGQNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgaW50IGwyY2Fw
X2Nvbm5lY3RfcmVxKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLCBzdHJ1Y3QgbDJjYXBfY21kX2hk
ciAqY21kLCB1OCAqZGF0YSkNCitzdGF0aWMgaW50IGwyY2FwX2Nvbm5lY3RfcmVxKHN0cnVjdCBs
MmNhcF9jb25uICpjb25uLA0KKwkJCSAgICAgc3RydWN0IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTE2
IGNtZF9sZW4sIHU4ICpkYXRhKQ0KIHsNCiAJc3RydWN0IGwyY2FwX2Nvbm5fcmVxICpyZXEgPSAo
c3RydWN0IGwyY2FwX2Nvbm5fcmVxICopIGRhdGE7DQogCXN0cnVjdCBsMmNhcF9jb25uX3JzcCBy
c3A7DQpAQCAtMjMyNSw4ICsyMzMxLDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX2Nvbm5l
Y3RfcmVxKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLCBzdHJ1Y3QgbDJjYXBfY21kX2hkDQogCXN0
cnVjdCBzb2NrICpwYXJlbnQsICpzayA9IE5VTEw7DQogCWludCByZXN1bHQsIHN0YXR1cyA9IEwy
Q0FQX0NTX05PX0lORk87DQogDQotCXUxNiBkY2lkID0gMCwgc2NpZCA9IF9fbGUxNl90b19jcHUo
cmVxLT5zY2lkKTsNCi0JX19sZTE2IHBzbSA9IHJlcS0+cHNtOw0KKwl1MTYgZGNpZCA9IDAsIHNj
aWQ7DQorCV9fbGUxNiBwc207DQorDQorCWlmIChjbWRfbGVuIDwgc2l6ZW9mKHN0cnVjdCBsMmNh
cF9jb25uX3JlcSkpDQorCQlyZXR1cm4gLUVQUk9UTzsNCisNCisJc2NpZCA9IF9fbGUxNl90b19j
cHUocmVxLT5zY2lkKTsNCisJcHNtID0gcmVxLT5wc207DQogDQogCUJUX0RCRygicHNtIDB4JTIu
Mnggc2NpZCAweCU0LjR4IiwgcHNtLCBzY2lkKTsNCiANCkBAIC0yNDUxLDcgKzI0NjMsOSBAQCBz
ZW5kcmVzcDoNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX2Nv
bm5lY3RfcnNwKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLCBzdHJ1Y3QgbDJjYXBfY21kX2hkciAq
Y21kLCB1OCAqZGF0YSkNCitzdGF0aWMgaW50IGwyY2FwX2Nvbm5lY3RfcnNwKHN0cnVjdCBsMmNh
cF9jb25uICpjb25uLA0KKwkJCSAgICAgIHN0cnVjdCBsMmNhcF9jbWRfaGRyICpjbWQsIHUxNiBj
bWRfbGVuLA0KKwkJCSAgICAgIHU4ICpkYXRhKQ0KIHsNCiAJc3RydWN0IGwyY2FwX2Nvbm5fcnNw
ICpyc3AgPSAoc3RydWN0IGwyY2FwX2Nvbm5fcnNwICopIGRhdGE7DQogCXUxNiBzY2lkLCBkY2lk
LCByZXN1bHQsIHN0YXR1czsNCkBAIC0yNDU5LDYgKzI0NzMsOSBAQCBzdGF0aWMgaW5saW5lIGlu
dCBsMmNhcF9jb25uZWN0X3JzcChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwgc3RydWN0IGwyY2Fw
X2NtZF9oZA0KIAlzdHJ1Y3Qgc29jayAqc2s7DQogCXU4IHJlcVsxMjhdOw0KIA0KKwlpZiAoY21k
X2xlbiA8IHNpemVvZigqcnNwKSkNCisJCXJldHVybiAtRVBST1RPOw0KKw0KIAlzY2lkICAgPSBf
X2xlMTZfdG9fY3B1KHJzcC0+c2NpZCk7DQogCWRjaWQgICA9IF9fbGUxNl90b19jcHUocnNwLT5k
Y2lkKTsNCiAJcmVzdWx0ID0gX19sZTE2X3RvX2NwdShyc3AtPnJlc3VsdCk7DQpAQCAtMjUzNCw2
ICsyNTUxLDkgQEAgc3RhdGljIGlubGluZSBpbnQgbDJjYXBfY29uZmlnX3JlcShzdHJ1Y3QgbDJj
YXBfY29ubiAqY29ubiwgc3RydWN0IGwyY2FwX2NtZF9oZHINCiAJc3RydWN0IHNvY2sgKnNrOw0K
IAlpbnQgbGVuOw0KIA0KKwlpZiAoY21kX2xlbiA8IHNpemVvZigqcmVxKSkNCisJCXJldHVybiAt
RVBST1RPOw0KKw0KIAlkY2lkICA9IF9fbGUxNl90b19jcHUocmVxLT5kY2lkKTsNCiAJZmxhZ3Mg
PSBfX2xlMTZfdG9fY3B1KHJlcS0+ZmxhZ3MpOw0KIA0KQEAgLTI1NTksNyArMjU3OSw3IEBAIHN0
YXRpYyBpbmxpbmUgaW50IGwyY2FwX2NvbmZpZ19yZXEoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4s
IHN0cnVjdCBsMmNhcF9jbWRfaGRyDQogDQogCS8qIFJlamVjdCBpZiBjb25maWcgYnVmZmVyIGlz
IHRvbyBzbWFsbC4gKi8NCiAJbGVuID0gY21kX2xlbiAtIHNpemVvZigqcmVxKTsNCi0JaWYgKGxl
biA8IDAgfHwgY2hhbi0+Y29uZl9sZW4gKyBsZW4gPiBzaXplb2YoY2hhbi0+Y29uZl9yZXEpKSB7
DQorCWlmIChjaGFuLT5jb25mX2xlbiArIGxlbiA+IHNpemVvZihjaGFuLT5jb25mX3JlcSkpIHsN
CiAJCWwyY2FwX3NlbmRfY21kKGNvbm4sIGNtZC0+aWRlbnQsIEwyQ0FQX0NPTkZfUlNQLA0KIAkJ
CQlsMmNhcF9idWlsZF9jb25mX3JzcChjaGFuLCByc3AsDQogCQkJCQlMMkNBUF9DT05GX1JFSkVD
VCwgZmxhZ3MpLCByc3ApOw0KQEAgLTI2MjEsMTMgKzI2NDEsMTggQEAgdW5sb2NrOg0KIAlyZXR1
cm4gMDsNCiB9DQogDQotc3RhdGljIGlubGluZSBpbnQgbDJjYXBfY29uZmlnX3JzcChzdHJ1Y3Qg
bDJjYXBfY29ubiAqY29ubiwgc3RydWN0IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTggKmRhdGEpDQor
c3RhdGljIGlubGluZSBpbnQgbDJjYXBfY29uZmlnX3JzcChzdHJ1Y3QgbDJjYXBfY29ubiAqY29u
biwNCisJCQkJICAgc3RydWN0IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTE2IGNtZF9sZW4sDQorCQkJ
CSAgIHU4ICpkYXRhKQ0KIHsNCiAJc3RydWN0IGwyY2FwX2NvbmZfcnNwICpyc3AgPSAoc3RydWN0
IGwyY2FwX2NvbmZfcnNwICopZGF0YTsNCiAJdTE2IHNjaWQsIGZsYWdzLCByZXN1bHQ7DQogCXN0
cnVjdCBsMmNhcF9jaGFuICpjaGFuOw0KIAlzdHJ1Y3Qgc29jayAqc2s7DQotCWludCBsZW4gPSBj
bWQtPmxlbiAtIHNpemVvZigqcnNwKTsNCisJaW50IGxlbiA9IGNtZF9sZW4gLSBzaXplb2YoKnJz
cCk7DQorDQorCWlmIChjbWRfbGVuIDwgc2l6ZW9mKCpyc3ApKQ0KKwkJcmV0dXJuIC1FUFJPVE87
DQogDQogCXNjaWQgICA9IF9fbGUxNl90b19jcHUocnNwLT5zY2lkKTsNCiAJZmxhZ3MgID0gX19s
ZTE2X3RvX2NwdShyc3AtPmZsYWdzKTsNCkBAIC0yNzAzLDcgKzI3MjgsOSBAQCBkb25lOg0KIAly
ZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIGlubGluZSBpbnQgbDJjYXBfZGlzY29ubmVjdF9yZXEo
c3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sIHN0cnVjdCBsMmNhcF9jbWRfaGRyICpjbWQsIHU4ICpk
YXRhKQ0KK3N0YXRpYyBpbmxpbmUgaW50IGwyY2FwX2Rpc2Nvbm5lY3RfcmVxKHN0cnVjdCBsMmNh
cF9jb25uICpjb25uLA0KKwkJCQkgICAgICAgc3RydWN0IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTE2
IGNtZF9sZW4sDQorCQkJCSAgICAgICB1OCAqZGF0YSkNCiB7DQogCXN0cnVjdCBsMmNhcF9kaXNj
b25uX3JlcSAqcmVxID0gKHN0cnVjdCBsMmNhcF9kaXNjb25uX3JlcSAqKSBkYXRhOw0KIAlzdHJ1
Y3QgbDJjYXBfZGlzY29ubl9yc3AgcnNwOw0KQEAgLTI3MTEsNiArMjczOCw5IEBAIHN0YXRpYyBp
bmxpbmUgaW50IGwyY2FwX2Rpc2Nvbm5lY3RfcmVxKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLCBz
dHJ1Y3QgbDJjYXBfY21kDQogCXN0cnVjdCBsMmNhcF9jaGFuICpjaGFuOw0KIAlzdHJ1Y3Qgc29j
ayAqc2s7DQogDQorCWlmIChjbWRfbGVuICE9IHNpemVvZigqcmVxKSkNCisJCXJldHVybiAtRVBS
T1RPOw0KKw0KIAlzY2lkID0gX19sZTE2X3RvX2NwdShyZXEtPnNjaWQpOw0KIAlkY2lkID0gX19s
ZTE2X3RvX2NwdShyZXEtPmRjaWQpOw0KIA0KQEAgLTI3NDQsMTMgKzI3NzQsMTggQEAgc3RhdGlj
IGlubGluZSBpbnQgbDJjYXBfZGlzY29ubmVjdF9yZXEoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4s
IHN0cnVjdCBsMmNhcF9jbWQNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgaW50
IGwyY2FwX2Rpc2Nvbm5lY3RfcnNwKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLCBzdHJ1Y3QgbDJj
YXBfY21kX2hkciAqY21kLCB1OCAqZGF0YSkNCitzdGF0aWMgaW5saW5lIGludCBsMmNhcF9kaXNj
b25uZWN0X3JzcChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwNCisJCQkJICAgICAgIHN0cnVjdCBs
MmNhcF9jbWRfaGRyICpjbWQsIHUxNiBjbWRfbGVuLA0KKwkJCQkgICAgICAgdTggKmRhdGEpDQog
ew0KIAlzdHJ1Y3QgbDJjYXBfZGlzY29ubl9yc3AgKnJzcCA9IChzdHJ1Y3QgbDJjYXBfZGlzY29u
bl9yc3AgKikgZGF0YTsNCiAJdTE2IGRjaWQsIHNjaWQ7DQogCXN0cnVjdCBsMmNhcF9jaGFuICpj
aGFuOw0KIAlzdHJ1Y3Qgc29jayAqc2s7DQogDQorCWlmIChjbWRfbGVuICE9IHNpemVvZigqcnNw
KSkNCisJCXJldHVybiAtRVBST1RPOw0KKw0KIAlzY2lkID0gX19sZTE2X3RvX2NwdShyc3AtPnNj
aWQpOw0KIAlkY2lkID0gX19sZTE2X3RvX2NwdShyc3AtPmRjaWQpOw0KIA0KQEAgLTI3NzgsMTEg
KzI4MTMsMTYgQEAgc3RhdGljIGlubGluZSBpbnQgbDJjYXBfZGlzY29ubmVjdF9yc3Aoc3RydWN0
IGwyY2FwX2Nvbm4gKmNvbm4sIHN0cnVjdCBsMmNhcF9jbWQNCiAJcmV0dXJuIDA7DQogfQ0KIA0K
LXN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX2luZm9ybWF0aW9uX3JlcShzdHJ1Y3QgbDJjYXBfY29u
biAqY29ubiwgc3RydWN0IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTggKmRhdGEpDQorc3RhdGljIGlu
bGluZSBpbnQgbDJjYXBfaW5mb3JtYXRpb25fcmVxKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLA0K
KwkJCQkJc3RydWN0IGwyY2FwX2NtZF9oZHIgKmNtZCwgdTE2IGNtZF9sZW4sDQorCQkJCQl1OCAq
ZGF0YSkNCiB7DQogCXN0cnVjdCBsMmNhcF9pbmZvX3JlcSAqcmVxID0gKHN0cnVjdCBsMmNhcF9p
bmZvX3JlcSAqKSBkYXRhOw0KIAl1MTYgdHlwZTsNCiANCisJaWYgKGNtZF9sZW4gIT0gc2l6ZW9m
KCpyZXEpKQ0KKwkJcmV0dXJuIC1FUFJPVE87DQorDQogCXR5cGUgPSBfX2xlMTZfdG9fY3B1KHJl
cS0+dHlwZSk7DQogDQogCUJUX0RCRygidHlwZSAweCU0LjR4IiwgdHlwZSk7DQpAQCAtMjgxOCwx
MSArMjg1OCwxNiBAQCBzdGF0aWMgaW5saW5lIGludCBsMmNhcF9pbmZvcm1hdGlvbl9yZXEoc3Ry
dWN0IGwyY2FwX2Nvbm4gKmNvbm4sIHN0cnVjdCBsMmNhcF9jbQ0KIAlyZXR1cm4gMDsNCiB9DQog
DQotc3RhdGljIGlubGluZSBpbnQgbDJjYXBfaW5mb3JtYXRpb25fcnNwKHN0cnVjdCBsMmNhcF9j
b25uICpjb25uLCBzdHJ1Y3QgbDJjYXBfY21kX2hkciAqY21kLCB1OCAqZGF0YSkNCitzdGF0aWMg
aW5saW5lIGludCBsMmNhcF9pbmZvcm1hdGlvbl9yc3Aoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4s
DQorCQkJCQlzdHJ1Y3QgbDJjYXBfY21kX2hkciAqY21kLCB1MTYgY21kX2xlbiwNCisJCQkJCXU4
ICpkYXRhKQ0KIHsNCiAJc3RydWN0IGwyY2FwX2luZm9fcnNwICpyc3AgPSAoc3RydWN0IGwyY2Fw
X2luZm9fcnNwICopIGRhdGE7DQogCXUxNiB0eXBlLCByZXN1bHQ7DQogDQorCWlmIChjbWRfbGVu
ICE9IHNpemVvZigqcnNwKSkNCisJCXJldHVybiAtRVBST1RPOw0KKw0KIAl0eXBlICAgPSBfX2xl
MTZfdG9fY3B1KHJzcC0+dHlwZSk7DQogCXJlc3VsdCA9IF9fbGUxNl90b19jcHUocnNwLT5yZXN1
bHQpOw0KIA0KQEAgLTI5NDEsMTUgKzI5ODYsMTUgQEAgc3RhdGljIGlubGluZSBpbnQgbDJjYXBf
YnJlZHJfc2lnX2NtZChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwNCiANCiAJc3dpdGNoIChjbWQt
PmNvZGUpIHsNCiAJY2FzZSBMMkNBUF9DT01NQU5EX1JFSjoNCi0JCWwyY2FwX2NvbW1hbmRfcmVq
KGNvbm4sIGNtZCwgZGF0YSk7DQorCQlsMmNhcF9jb21tYW5kX3Jlaihjb25uLCBjbWQsIGNtZF9s
ZW4sIGRhdGEpOw0KIAkJYnJlYWs7DQogDQogCWNhc2UgTDJDQVBfQ09OTl9SRVE6DQotCQllcnIg
PSBsMmNhcF9jb25uZWN0X3JlcShjb25uLCBjbWQsIGRhdGEpOw0KKwkJZXJyID0gbDJjYXBfY29u
bmVjdF9yZXEoY29ubiwgY21kLCBjbWRfbGVuLCBkYXRhKTsNCiAJCWJyZWFrOw0KIA0KIAljYXNl
IEwyQ0FQX0NPTk5fUlNQOg0KLQkJZXJyID0gbDJjYXBfY29ubmVjdF9yc3AoY29ubiwgY21kLCBk
YXRhKTsNCisJCWVyciA9IGwyY2FwX2Nvbm5lY3RfcnNwKGNvbm4sIGNtZCwgY21kX2xlbiwgZGF0
YSk7DQogCQlicmVhazsNCiANCiAJY2FzZSBMMkNBUF9DT05GX1JFUToNCkBAIC0yOTU3LDE1ICsz
MDAyLDE1IEBAIHN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX2JyZWRyX3NpZ19jbWQoc3RydWN0IGwy
Y2FwX2Nvbm4gKmNvbm4sDQogCQlicmVhazsNCiANCiAJY2FzZSBMMkNBUF9DT05GX1JTUDoNCi0J
CWVyciA9IGwyY2FwX2NvbmZpZ19yc3AoY29ubiwgY21kLCBkYXRhKTsNCisJCWVyciA9IGwyY2Fw
X2NvbmZpZ19yc3AoY29ubiwgY21kLCBjbWRfbGVuLCBkYXRhKTsNCiAJCWJyZWFrOw0KIA0KIAlj
YXNlIEwyQ0FQX0RJU0NPTk5fUkVROg0KLQkJZXJyID0gbDJjYXBfZGlzY29ubmVjdF9yZXEoY29u
biwgY21kLCBkYXRhKTsNCisJCWVyciA9IGwyY2FwX2Rpc2Nvbm5lY3RfcmVxKGNvbm4sIGNtZCwg
Y21kX2xlbiwgZGF0YSk7DQogCQlicmVhazsNCiANCiAJY2FzZSBMMkNBUF9ESVNDT05OX1JTUDoN
Ci0JCWVyciA9IGwyY2FwX2Rpc2Nvbm5lY3RfcnNwKGNvbm4sIGNtZCwgZGF0YSk7DQorCQllcnIg
PSBsMmNhcF9kaXNjb25uZWN0X3JzcChjb25uLCBjbWQsIGNtZF9sZW4sIGRhdGEpOw0KIAkJYnJl
YWs7DQogDQogCWNhc2UgTDJDQVBfRUNIT19SRVE6DQpAQCAtMjk3NiwxMSArMzAyMSwxMSBAQCBz
dGF0aWMgaW5saW5lIGludCBsMmNhcF9icmVkcl9zaWdfY21kKHN0cnVjdCBsMmNhcF9jb25uICpj
b25uLA0KIAkJYnJlYWs7DQogDQogCWNhc2UgTDJDQVBfSU5GT19SRVE6DQotCQllcnIgPSBsMmNh
cF9pbmZvcm1hdGlvbl9yZXEoY29ubiwgY21kLCBkYXRhKTsNCisJCWVyciA9IGwyY2FwX2luZm9y
bWF0aW9uX3JlcShjb25uLCBjbWQsIGNtZF9sZW4sIGRhdGEpOw0KIAkJYnJlYWs7DQogDQogCWNh
c2UgTDJDQVBfSU5GT19SU1A6DQotCQllcnIgPSBsMmNhcF9pbmZvcm1hdGlvbl9yc3AoY29ubiwg
Y21kLCBkYXRhKTsNCisJCWVyciA9IGwyY2FwX2luZm9ybWF0aW9uX3JzcChjb25uLCBjbWQsIGNt
ZF9sZW4sIGRhdGEpOw0KIAkJYnJlYWs7DQogDQogCWRlZmF1bHQ6DQpkaWZmIC0tZ2l0IGEvbmV0
L21hYzgwMjExL2lmYWNlLmMgYi9uZXQvbWFjODAyMTEvaWZhY2UuYw0KaW5kZXggZjRkZGYzNC4u
ODI2MGNkNSAxMDA2NDQNCi0tLSBhL25ldC9tYWM4MDIxMS9pZmFjZS5jDQorKysgYi9uZXQvbWFj
ODAyMTEvaWZhY2UuYw0KQEAgLTEyNDIsNiArMTI0MiwxNSBAQCB2b2lkIGllZWU4MDIxMV9yZW1v
dmVfaW50ZXJmYWNlcyhzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCkNCiANCiAJQVNTRVJU
X1JUTkwoKTsNCiANCisJLyoNCisJICogQ2xvc2UgYWxsIEFQX1ZMQU4gaW50ZXJmYWNlcyBmaXJz
dCwgYXMgb3RoZXJ3aXNlIHRoZXkNCisJICogbWlnaHQgYmUgY2xvc2VkIHdoaWxlIHRoZSBBUCBp
bnRlcmZhY2UgdGhleSBiZWxvbmcgdG8NCisJICogaXMgY2xvc2VkLCBjYXVzaW5nIHVucmVnaXN0
ZXJfbmV0ZGV2aWNlX21hbnkoKSB0byBjcmFzaC4NCisJICovDQorCWxpc3RfZm9yX2VhY2hfZW50
cnkoc2RhdGEsICZsb2NhbC0+aW50ZXJmYWNlcywgbGlzdCkNCisJCWlmIChzZGF0YS0+dmlmLnR5
cGUgPT0gTkw4MDIxMV9JRlRZUEVfQVBfVkxBTikNCisJCQlkZXZfY2xvc2Uoc2RhdGEtPmRldik7
DQorDQogCW11dGV4X2xvY2soJmxvY2FsLT5pZmxpc3RfbXR4KTsNCiAJbGlzdF9mb3JfZWFjaF9l
bnRyeV9zYWZlKHNkYXRhLCB0bXAsICZsb2NhbC0+aW50ZXJmYWNlcywgbGlzdCkgew0KIAkJbGlz
dF9kZWwoJnNkYXRhLT5saXN0KTsNCmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3Mvc21lLmMgYi9u
ZXQvd2lyZWxlc3Mvc21lLmMNCmluZGV4IDBhY2ZkYzkuLmMxYzZlNmQgMTAwNjQ0DQotLS0gYS9u
ZXQvd2lyZWxlc3Mvc21lLmMNCisrKyBiL25ldC93aXJlbGVzcy9zbWUuYw0KQEAgLTIyMCw2ICsy
MjAsOSBAQCB2b2lkIGNmZzgwMjExX2Nvbm5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
DQogCW11dGV4X2xvY2soJnJkZXYtPmRldmxpc3RfbXR4KTsNCiANCiAJbGlzdF9mb3JfZWFjaF9l
bnRyeSh3ZGV2LCAmcmRldi0+bmV0ZGV2X2xpc3QsIGxpc3QpIHsNCisJCWlmICghd2Rldi0+bmV0
ZGV2KQ0KKwkJCWNvbnRpbnVlOw0KKw0KIAkJd2Rldl9sb2NrKHdkZXYpOw0KIAkJaWYgKCFuZXRp
Zl9ydW5uaW5nKHdkZXYtPm5ldGRldikpIHsNCiAJCQl3ZGV2X3VubG9jayh3ZGV2KTsNCmRpZmYg
LS1naXQgYS9zb3VuZC91c2IvY2FyZC5oIGIvc291bmQvdXNiL2NhcmQuaA0KaW5kZXggMmI3NTU5
Yy4uMGE3Y2E2YyAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi9jYXJkLmgNCisrKyBiL3NvdW5kL3Vz
Yi9jYXJkLmgNCkBAIC0xLDYgKzEsNyBAQA0KICNpZm5kZWYgX19VU0JBVURJT19DQVJEX0gNCiAj
ZGVmaW5lIF9fVVNCQVVESU9fQ0FSRF9IDQogDQorI2RlZmluZSBNQVhfTlJfUkFURVMJMTAyNA0K
ICNkZWZpbmUgTUFYX1BBQ0tTCTIwDQogI2RlZmluZSBNQVhfUEFDS1NfSFMJKE1BWF9QQUNLUyAq
IDgpCS8qIGluIGhpZ2ggc3BlZWQgbW9kZSAqLw0KICNkZWZpbmUgTUFYX1VSQlMJOA0KZGlmZiAt
LWdpdCBhL3NvdW5kL3VzYi9mb3JtYXQuYyBiL3NvdW5kL3VzYi9mb3JtYXQuYw0KaW5kZXggODk0
MjFkMS4uZGRmZWY1NyAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi9mb3JtYXQuYw0KKysrIGIvc291
bmQvdXNiL2Zvcm1hdC5jDQpAQCAtMjI2LDcgKzIyNiw3IEBAIHN0YXRpYyBpbnQgcGFyc2VfdWFj
Ml9zYW1wbGVfcmF0ZV9yYW5nZShzdHJ1Y3QgYXVkaW9mb3JtYXQgKmZwLCBpbnQgbnJfdHJpcGxl
dHMsDQogCQlpbnQgbWluID0gY29tYmluZV9xdWFkKCZkYXRhWzIgKyAxMiAqIGldKTsNCiAJCWlu
dCBtYXggPSBjb21iaW5lX3F1YWQoJmRhdGFbNiArIDEyICogaV0pOw0KIAkJaW50IHJlcyA9IGNv
bWJpbmVfcXVhZCgmZGF0YVsxMCArIDEyICogaV0pOw0KLQkJaW50IHJhdGU7DQorCQl1bnNpZ25l
ZCBpbnQgcmF0ZTsNCiANCiAJCWlmICgobWF4IDwgMCkgfHwgKG1pbiA8IDApIHx8IChyZXMgPCAw
KSB8fCAobWF4IDwgbWluKSkNCiAJCQljb250aW51ZTsNCkBAIC0yNTMsNiArMjUzLDEwIEBAIHN0
YXRpYyBpbnQgcGFyc2VfdWFjMl9zYW1wbGVfcmF0ZV9yYW5nZShzdHJ1Y3QgYXVkaW9mb3JtYXQg
KmZwLCBpbnQgbnJfdHJpcGxldHMsDQogCQkJZnAtPnJhdGVzIHw9IHNuZF9wY21fcmF0ZV90b19y
YXRlX2JpdChyYXRlKTsNCiANCiAJCQlucl9yYXRlcysrOw0KKwkJCWlmIChucl9yYXRlcyA+PSBN
QVhfTlJfUkFURVMpIHsNCisJCQkJc25kX3ByaW50ayhLRVJOX0VSUiAiaW52YWxpZCB1YWMyIHJh
dGVzXG4iKTsNCisJCQkJYnJlYWs7DQorCQkJfQ0KIA0KIAkJCS8qIGF2b2lkIGVuZGxlc3MgbG9v
cCAqLw0KIAkJCWlmIChyZXMgPT0gMCkNCmRpZmYgLS1naXQgYS9zb3VuZC91c2IvbWl4ZXIuYyBi
L3NvdW5kL3VzYi9taXhlci5jDQppbmRleCBmNDU0MGJmLi45N2VjMTU1IDEwMDY0NA0KLS0tIGEv
c291bmQvdXNiL21peGVyLmMNCisrKyBiL3NvdW5kL3VzYi9taXhlci5jDQpAQCAtODIyLDYgKzgy
Miw3IEBAIHN0YXRpYyB2b2lkIHZvbHVtZV9jb250cm9sX3F1aXJrcyhzdHJ1Y3QgdXNiX21peGVy
X2VsZW1faW5mbyAqY3ZhbCwNCiAJY2FzZSBVU0JfSUQoMHgwNDZkLCAweDA4MDgpOg0KIAljYXNl
IFVTQl9JRCgweDA0NmQsIDB4MDgwOSk6DQogCWNhc2UgVVNCX0lEKDB4MDQ2ZCwgMHgwODFkKTog
LyogSEQgV2ViY2FtIGM1MTAgKi8NCisJY2FzZSBVU0JfSUQoMHgwNDZkLCAweDA4MjUpOiAvKiBI
RCBXZWJjYW0gYzI3MCAqLw0KIAljYXNlIFVTQl9JRCgweDA0NmQsIDB4MDk5MSk6DQogCS8qIE1v
c3QgYXVkaW8gdXNiIGRldmljZXMgbGllIGFib3V0IHZvbHVtZSByZXNvbHV0aW9uLg0KIAkgKiBN
b3N0IExvZ2l0ZWNoIHdlYmNhbXMgaGF2ZSByZXMgPSAzODQuDQpkaWZmIC0tZ2l0IGEvc291bmQv
dXNiL3F1aXJrcy10YWJsZS5oIGIvc291bmQvdXNiL3F1aXJrcy10YWJsZS5oDQppbmRleCA0ZTI1
MTQ4Li5lNDY3YTU4IDEwMDY0NA0KLS0tIGEvc291bmQvdXNiL3F1aXJrcy10YWJsZS5oDQorKysg
Yi9zb3VuZC91c2IvcXVpcmtzLXRhYmxlLmgNCkBAIC0xNTcsNyArMTU3LDEzIEBADQogCS5iSW50
ZXJmYWNlU3ViQ2xhc3MgPSBVU0JfU1VCQ0xBU1NfQVVESU9DT05UUk9MDQogfSwNCiB7DQotCVVT
Ql9ERVZJQ0UoMHgwNDZkLCAweDA5OTApLA0KKwkubWF0Y2hfZmxhZ3MgPSBVU0JfREVWSUNFX0lE
X01BVENIX0RFVklDRSB8DQorCQkgICAgICAgVVNCX0RFVklDRV9JRF9NQVRDSF9JTlRfQ0xBU1Mg
fA0KKwkJICAgICAgIFVTQl9ERVZJQ0VfSURfTUFUQ0hfSU5UX1NVQkNMQVNTLA0KKwkuaWRWZW5k
b3IgPSAweDA0NmQsDQorCS5pZFByb2R1Y3QgPSAweDA5OTAsDQorCS5iSW50ZXJmYWNlQ2xhc3Mg
PSBVU0JfQ0xBU1NfQVVESU8sDQorCS5iSW50ZXJmYWNlU3ViQ2xhc3MgPSBVU0JfU1VCQ0xBU1Nf
QVVESU9DT05UUk9MLA0KIAkuZHJpdmVyX2luZm8gPSAodW5zaWduZWQgbG9uZykgJiAoY29uc3Qg
c3RydWN0IHNuZF91c2JfYXVkaW9fcXVpcmspIHsNCiAJCS52ZW5kb3JfbmFtZSA9ICJMb2dpdGVj
aCwgSW5jLiIsDQogCQkucHJvZHVjdF9uYW1lID0gIlF1aWNrQ2FtIFBybyA5MDAwIiwNCmRpZmYg
LS1naXQgYS9zb3VuZC91c2IvcXVpcmtzLmMgYi9zb3VuZC91c2IvcXVpcmtzLmMNCmluZGV4IDQy
ZWVlZTguLjljODJmOGIgMTAwNjQ0DQotLS0gYS9zb3VuZC91c2IvcXVpcmtzLmMNCisrKyBiL3Nv
dW5kL3VzYi9xdWlya3MuYw0KQEAgLTEzMiwxMCArMTMyLDE0IEBAIHN0YXRpYyBpbnQgY3JlYXRl
X2ZpeGVkX3N0cmVhbV9xdWlyayhzdHJ1Y3Qgc25kX3VzYl9hdWRpbyAqY2hpcCwNCiAJdW5zaWdu
ZWQgKnJhdGVfdGFibGUgPSBOVUxMOw0KIA0KIAlmcCA9IGttZW1kdXAocXVpcmstPmRhdGEsIHNp
emVvZigqZnApLCBHRlBfS0VSTkVMKTsNCi0JaWYgKCEgZnApIHsNCisJaWYgKCFmcCkgew0KIAkJ
c25kX3ByaW50ayhLRVJOX0VSUiAiY2Fubm90IG1lbWR1cFxuIik7DQogCQlyZXR1cm4gLUVOT01F
TTsNCiAJfQ0KKwlpZiAoZnAtPm5yX3JhdGVzID4gTUFYX05SX1JBVEVTKSB7DQorCQlrZnJlZShm
cCk7DQorCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KIAlpZiAoZnAtPm5yX3JhdGVzID4gMCkgew0K
IAkJcmF0ZV90YWJsZSA9IGttZW1kdXAoZnAtPnJhdGVfdGFibGUsDQogCQkJCSAgICAgc2l6ZW9m
KGludCkgKiBmcC0+bnJfcmF0ZXMsIEdGUF9LRVJORUwpOw0K


--=-C+iZ7s23r6Ie63Brk+ei--

--=-PdLgs3HuNq9nZclyTwTk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUcEXS+e/yOyVhhEJAQolyQ/+IHUMLtCljAm7GDnX5FSfbrW4zwI11m05
eyBUQUGCLcu42TVLIc2qLjHziUc/VJV8OpkVoNjT50Vh/546vFie6lo03Fj/Ket4
1gyX/mrqBSnpL60ufjlF8hcSkUM5poY4NVlxJXNI4eDAgHX5E7vt3ynOCEZvnsvt
Q4K+L2OKXusDF+IU6eNcDZMDhDHFoDhOgx7uYcf2GeuA5B+NEAqp+ySfojdJ/aKf
/PLlhGAMHmGnb3cgaTPQHqJS5CjvK31Y+eB2L4Q4ljxpFpDgGcG0NYSUj3THyQLB
F5jZGw+nhXGLB1oxlpZDNbS49rYQyJ3S6Pd6RRhjo3+M5WwGEDjw/ZnzuLLPueyF
SFq0LLUxuk6un8sibhUR+SUjjZtvVK6dbz88+ePRPBpCKISsptlVP2ncv83lP8Yv
cfsrS+zlKliR4mV2pijgtRw6KhxIyM2Z8tWd5nE/xlwu8Rl2PtMX0bT+6txL6tQy
K9A/mONOsp7qBjrZ1zG6woB42Hx1HNlLbHnrEVH86L2Zs76sDZwZoIXc4CNyZstf
Wq49LhVdKnTvYA312ZbUdwTdZfaYcGxU86ZyuZo5ELa3kCnB8QLNO85vPitVKftH
FuJz/44NDwdV+QDWhqQhljQFc9pPlagqSk/nGb4Jj2XecVmYbMjhYiI84VeRSuXg
uwHt0vzYDq4=
=T4CB
-----END PGP SIGNATURE-----

--=-PdLgs3HuNq9nZclyTwTk--
