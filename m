Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaEMMQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:16:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaEMMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:16:21 -0400
Date: Tue, 13 May 2014 14:16:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.4
Message-ID: <20140513121620.GA26515@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.4 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arc/kernel/entry.S                             |    8=20
 arch/arc/plat-arcfpga/Kconfig                       |    1=20
 arch/arm/kvm/mmu.c                                  |   15 -
 arch/mips/kvm/kvm_mips_emul.c                       |    7=20
 arch/mips/power/hibernate.S                         |    1=20
 arch/powerpc/include/asm/compat.h                   |    4=20
 arch/powerpc/include/asm/reg.h                      |    1=20
 arch/powerpc/kernel/process.c                       |   34 +-
 arch/powerpc/kernel/signal_32.c                     |    2=20
 arch/powerpc/kernel/signal_64.c                     |    2=20
 arch/powerpc/kernel/tm.S                            |    2=20
 arch/powerpc/kvm/book3s_hv.c                        |    4=20
 arch/powerpc/platforms/pseries/hotplug-cpu.c        |    5=20
 arch/s390/net/bpf_jit_comp.c                        |    1=20
 arch/x86/Makefile                                   |    1=20
 drivers/acpi/acpi_processor.c                       |    7=20
 drivers/ata/ahci.c                                  |   27 +
 drivers/ata/ahci.h                                  |    1=20
 drivers/ata/libata-core.c                           |   27 +
 drivers/block/floppy.c                              |   11=20
 drivers/cpufreq/at32ap-cpufreq.c                    |    2=20
 drivers/cpufreq/loongson2_cpufreq.c                 |    2=20
 drivers/cpufreq/unicore2-cpufreq.c                  |    2=20
 drivers/dma/edma.c                                  |    6=20
 drivers/gpio/gpio-mxs.c                             |    3=20
 drivers/gpu/drm/bochs/bochs.h                       |    1=20
 drivers/gpu/drm/bochs/bochs_drv.c                   |   44 +++
 drivers/gpu/drm/cirrus/cirrus_drv.c                 |   42 ++
 drivers/gpu/drm/cirrus/cirrus_mode.c                |    3=20
 drivers/gpu/drm/i915/intel_crt.c                    |    8=20
 drivers/input/mouse/synaptics.c                     |   50 +++
 drivers/md/dm-cache-metadata.c                      |   98 ++++--
 drivers/md/dm-cache-metadata.h                      |    9=20
 drivers/md/dm-cache-target.c                        |   65 ----
 drivers/md/dm-thin-metadata.c                       |   80 +++--
 drivers/md/dm-thin.c                                |    2=20
 drivers/md/persistent-data/dm-block-manager.c       |   15 -
 drivers/md/persistent-data/dm-block-manager.h       |    3=20
 drivers/md/persistent-data/dm-transaction-manager.c |    5=20
 drivers/md/persistent-data/dm-transaction-manager.h |   17 -
 drivers/mmc/host/sdhci-bcm-kona.c                   |    2=20
 drivers/mtd/nand/atmel_nand.c                       |    1=20
 drivers/mtd/nand/diskonchip.c                       |    2=20
 drivers/mtd/nand/nuc900_nand.c                      |    2=20
 drivers/mtd/sm_ftl.c                                |   11=20
 drivers/net/ethernet/marvell/mvneta.c               |   41 ++
 drivers/net/wireless/ath/ath9k/xmit.c               |    2=20
 drivers/net/wireless/b43/phy_n.c                    |   14=20
 drivers/net/wireless/iwlwifi/dvm/main.c             |    8=20
 drivers/net/wireless/iwlwifi/mvm/mac80211.c         |    2=20
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c         |   20 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c        |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c         |   15 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c         |   27 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c        |    6=20
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c         |   18 +
 drivers/pinctrl/pinctrl-as3722.c                    |   17 -
 drivers/platform/x86/thinkpad_acpi.c                |   12=20
 drivers/s390/cio/chsc.c                             |   22 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c                |    1=20
 drivers/scsi/virtio_scsi.c                          |    6=20
 drivers/tty/hvc/hvc_console.c                       |    2=20
 drivers/tty/n_tty.c                                 |    4=20
 drivers/tty/serial/8250/8250_core.c                 |    2=20
 drivers/tty/tty_buffer.c                            |   17 -
 drivers/video/aty/mach64_accel.c                    |    3=20
 drivers/video/aty/mach64_cursor.c                   |   22 +
 drivers/video/cfbcopyarea.c                         |  153 +++++-----
 drivers/video/matrox/matroxfb_accel.c               |   38 +-
 drivers/video/matrox/matroxfb_base.h                |    2=20
 drivers/video/tgafb.c                               |  282 ++++-----------=
-----
 drivers/virtio/virtio_balloon.c                     |    6=20
 fs/aio.c                                            |  120 ++++----
 fs/lockd/svc.c                                      |    1=20
 fs/locks.c                                          |    7=20
 include/linux/libata.h                              |    1=20
 lib/percpu_counter.c                                |    2=20
 net/ceph/crush/mapper.c                             |   46 +--
 net/mac80211/ieee80211_i.h                          |    1=20
 net/mac80211/main.c                                 |    2=20
 net/mac80211/mlme.c                                 |   28 +
 net/mac80211/offchannel.c                           |    1=20
 net/mac80211/pm.c                                   |   14=20
 net/mac80211/tx.c                                   |    2=20
 net/sunrpc/clnt.c                                   |   12=20
 sound/soc/soc-dapm.c                                |    1=20
 tools/virtio/virtio_test.c                          |    2=20
 virt/kvm/arm/vgic.c                                 |    1=20
 virt/kvm/async_pf.c                                 |    8=20
 virt/kvm/ioapic.c                                   |    2=20
 91 files changed, 937 insertions(+), 696 deletions(-)

Alexander Gordeev (2):
      ahci: Ensure "MSI Revert to Single Message" mode is not enforced
      ahci: Do not receive interrupts sent by dummy ports

Andrew Bresticker (1):
      pinctrl: as3722: fix handling of GPIO invert bit

Anton Blanchard (2):
      KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=3Dn
      powerpc/compat: 32-bit little endian machine name is ppcle, not ppc

Benjamin LaHaise (1):
      aio: v4 ensure access to ctx->ring_pages is correctly serialised for =
migration

Chen Gang (1):
      cpufreq: unicore32: fix typo issue for 'clk'

Colin Ian King (1):
      rtlwifi: rtl8188ee: initialize packet_beacon

Dan Carpenter (2):
      mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
      mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

David Milburn (1):
      ahci: do not request irq for dummy port

Emmanuel Grumbach (2):
      iwlwifi: dvm: take mutex when sending SYNC BT config command
      iwlwifi: mvm: disable uAPSD due to bugs in the firmware

Fam Zheng (1):
      virtio-scsi: Skip setting affinity on uninitialized vq

Felix Fietkau (2):
      mac80211: exclude AP_VLAN interfaces from tx power calculation
      ath9k: fix ready time of the multicast buffer queue

George Spelvin (1):
      x86-64, build: Fix stack protector Makefile breakage with 32-bit user=
land

Gerd Hoffmann (2):
      drm: cirrus: add power management support
      drm: bochs: add power management support

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Greg Kroah-Hartman (1):
      Linux 3.14.4

Haibin Wang (1):
      KVM: ARM: vgic: Fix sgi dispatch problem

Hans de Goede (2):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, =
S1 Yoga and X1
      Input: synaptics - add min/max quirk for ThinkPad Edge E431

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Ilya Dryomov (1):
      crush: fix off-by-one errors in total_tries refactor

James Hogan (1):
      MIPS: KVM: Pass reserved instruction exceptions to guest

Jarkko Nikula (1):
      ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol

Jeff Layton (2):
      locks: allow __break_lease to sleep even when break_time is 0
      lockd: ensure we tear down any live sockets when socket creation fail=
s during lockd_up

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend

Joe Thornber (3):
      dm transaction manager: fix corruption due to non-atomic transaction =
commit
      dm: take care to copy the space map roots before locking the superblo=
ck
      dm cache: fix a lock-inversion

Joel Stanley (1):
      tools/virtio: add a missing )

Johannes Berg (3):
      mac80211: fix potential use-after-free
      mac80211: fix suspend vs. authentication race
      mac80211: fix software remain-on-channel implementation

Lan Tianyu (1):
      ACPI / processor: Fix failure of loading acpi-cpufreq driver

Larry Finger (5):
      rtlwifi: rtl8723ae: Fix too long disable of IRQs
      rtlwifi: rtl8188ee: Fix too long disable of IRQs
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Li Zhong (1):
      powerpc: Fix Oops in rtas_stop_self()

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Mark Salter (1):
      arm: KVM: fix possible misalignment of PGDs and bounce page

Martin K. Petersen (1):
      libata: Update queued trim blacklist for M5x0 drives

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Michael Braun (1):
      mac80211: fix WPA with VLAN on AP side with ps-sta again

Michael Neuling (1):
      powerpc/tm: Disable IRQ in tm_recheckpoint

Michael Welling (1):
      tty: serial: 8250_core.c Bug fix for Exar chips.

Mike Snitzer (2):
      dm cache: prevent corruption caused by discard_block_size > cache_blo=
ck_size
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (6):
      framebuffer: fix cfb_copyarea
      matroxfb: restore the registers M_ACCESS and M_PITCH
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix mode setting with fbset
      tgafb: fix data copying

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm

Paolo Bonzini (1):
      KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-20=
14-0155)

Peter Hurley (2):
      tty: Fix lockless tty buffer race
      n_tty: Fix n_tty_write crash when echoing in raw mode

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_P=
HY_HDR

Richard Weinberger (1):
      ARC: Remove ARC_HAS_COH_RTSC

Russell King (1):
      mmc: sdhci-bcm-kona: fix build errors when built-in

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Sasha Levin (1):
      mtd: diskonchip: mem resource name is not optional

Sebastian Ott (1):
      s390/chsc: fix SEI usage on old FW levels

Sekhar Nori (1):
      dma: edma: fix incorrect SG list handling

Steve Dickson (1):
      SUNRPC: Ensure call_connect_status() deals correctly with SOFTCONN ta=
sks

Takashi Iwai (1):
      thinkpad_acpi: Fix inconsistent mute LED after resume

Thomas Petazzoni (1):
      Revert "net: mvneta: fix usage as a module on RGMII configurations"

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Trond Myklebust (1):
      SUNRPC: Ensure that call_connect times out correctly

Tyler Stachecki (1):
      mpt2sas: Don't disable device twice at suspend.

Vineet Gupta (1):
      ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe

Viresh Kumar (2):
      cpufreq: loongson2_cpufreq: don't declare local variable as static
      cpufreq: at32ap: don't declare local variable as static


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcg0UAAoJEDjbvchgkmk+s00QAL1yL/GR5+a4ajBfYGUcHwJo
cixa0AlC0lB+OxJZtQaMpnal7kADI83GB2BiY6hD4x+tSy0/4Pl1w0dF+PQSYS7X
Hwmnp/yWo7vXK1AydaK8/39/HNB4RglVgbaInWvPYsYcftE6toBZuSgRx7WdOZEj
56zWHL7o5Sblk/BNYKbGNcppDHY+zcPtS2JGpEvzGwGCwfM/W+pgXjQ0Utg48JBI
DQoGoIMGd+r5F15BaWYeCGlmDBi0MqHoHpP9LqCk2+SYdgB9U29/wudsgYSSewSW
w+n/y2bGBXbSXAoTqBH4WwHI7tclugUd7iGjbFmywZ6VJnwRtlmNGXraOlVw4BIn
SbG9Gwec85pDQO8qt9wm1s5QwYNPbHmt+vACVmiS4R7l/0dry6PMfztbx2X2zPJX
0jZTEFaeTtQOwok2uGJtlkKnqjGq1mZICVB5MpP6mISNQJpO0jdVrVmp9f9lOhUv
wbn7IIlVGvnKTGwO9VHyVvBPWA4G2IFhwtxpqcUiLZBjU/qxVhaz5T88xC3XW0jN
wP9YbHM969S4XSSXQXnvuFy+M/xUdn9bUO2vdRUCZ6bq5pE8YGqTsZKgWOmTbnyU
PEEJJK7Xfp3dEIfM34qYy5RC+X0T0LnQ2X4pfBoV7p7VXVaWVFeOdVqg10YqgBX8
RPUBgeyk/BBwzN97jcKO
=L05o
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
