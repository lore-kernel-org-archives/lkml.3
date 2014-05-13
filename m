Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbaEMMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaEMMQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:16:54 -0400
Date: Tue, 13 May 2014 14:16:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.40
Message-ID: <20140513121653.GA26582@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.40 kernel.

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

 Makefile                                            |    2=20
 arch/arc/include/asm/irqflags.h                     |    7=20
 arch/arc/kernel/entry.S                             |   20 -
 arch/arm/mm/mmap.c                                  |    6=20
 arch/mips/kvm/kvm_mips_emul.c                       |    7=20
 arch/mips/power/hibernate.S                         |    1=20
 arch/powerpc/include/asm/compat.h                   |    4=20
 arch/powerpc/include/asm/reg.h                      |    1=20
 arch/powerpc/kernel/process.c                       |   34 ++
 arch/powerpc/kernel/signal_32.c                     |    2=20
 arch/powerpc/kernel/signal_64.c                     |    2=20
 arch/powerpc/kernel/tm.S                            |    2=20
 arch/s390/net/bpf_jit_comp.c                        |    1=20
 drivers/ata/libata-core.c                           |   21 -
 drivers/block/floppy.c                              |   11=20
 drivers/gpio/gpio-mxs.c                             |    3=20
 drivers/gpu/drm/cirrus/cirrus_drv.c                 |   42 +++
 drivers/gpu/drm/cirrus/cirrus_mode.c                |    3=20
 drivers/gpu/drm/i915/intel_crt.c                    |    8=20
 drivers/infiniband/ulp/isert/ib_isert.c             |   29 +-
 drivers/input/mouse/synaptics.c                     |   50 +++
 drivers/md/dm-cache-metadata.c                      |    3=20
 drivers/md/dm-thin.c                                |    2=20
 drivers/md/persistent-data/dm-block-manager.c       |   15 -
 drivers/md/persistent-data/dm-block-manager.h       |    3=20
 drivers/md/persistent-data/dm-transaction-manager.c |    5=20
 drivers/md/persistent-data/dm-transaction-manager.h |   17 -
 drivers/mtd/nand/atmel_nand.c                       |    1=20
 drivers/mtd/nand/nuc900_nand.c                      |    2=20
 drivers/mtd/sm_ftl.c                                |   11=20
 drivers/net/wireless/b43/phy_n.c                    |   14 -
 drivers/net/wireless/iwlwifi/dvm/main.c             |    8=20
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c         |   20 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c        |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c         |   15 +
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c         |   27 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c        |    6=20
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c         |   18 +
 drivers/s390/cio/chsc.c                             |   22 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c                |    1=20
 drivers/scsi/virtio_scsi.c                          |    6=20
 drivers/tty/hvc/hvc_console.c                       |    2=20
 drivers/tty/n_tty.c                                 |    4=20
 drivers/tty/serial/8250/8250_core.c                 |    2=20
 drivers/video/aty/mach64_accel.c                    |    3=20
 drivers/video/aty/mach64_cursor.c                   |   22 +
 drivers/video/cfbcopyarea.c                         |  153 +++++------
 drivers/video/matrox/matroxfb_accel.c               |   38 ++
 drivers/video/matrox/matroxfb_base.h                |    2=20
 drivers/video/tgafb.c                               |  264 +++------------=
-----
 drivers/virtio/virtio_balloon.c                     |    6=20
 fs/lockd/svc.c                                      |    1=20
 fs/locks.c                                          |    7=20
 include/linux/libata.h                              |    1=20
 net/mac80211/main.c                                 |    2=20
 net/mac80211/offchannel.c                           |    1=20
 net/mac80211/tx.c                                   |    2=20
 virt/kvm/ioapic.c                                   |    2=20
 58 files changed, 531 insertions(+), 435 deletions(-)

Anton Blanchard (1):
      powerpc/compat: 32-bit little endian machine name is ppcle, not ppc

Colin Ian King (1):
      rtlwifi: rtl8188ee: initialize packet_beacon

Dan Carpenter (2):
      mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
      mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command

Fam Zheng (1):
      virtio-scsi: Skip setting affinity on uninitialized vq

Felix Fietkau (1):
      mac80211: exclude AP_VLAN interfaces from tx power calculation

Gerd Hoffmann (1):
      drm: cirrus: add power management support

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Greg Kroah-Hartman (1):
      Linux 3.10.40

Hans de Goede (2):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, =
S1 Yoga and X1
      Input: synaptics - add min/max quirk for ThinkPad Edge E431

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

James Hogan (1):
      MIPS: KVM: Pass reserved instruction exceptions to guest

Jeff Layton (2):
      locks: allow __break_lease to sleep even when break_time is 0
      lockd: ensure we tear down any live sockets when socket creation fail=
s during lockd_up

Joe Thornber (1):
      dm transaction manager: fix corruption due to non-atomic transaction =
commit

Johannes Berg (1):
      mac80211: fix software remain-on-channel implementation

Larry Finger (5):
      rtlwifi: rtl8723ae: Fix too long disable of IRQs
      rtlwifi: rtl8188ee: Fix too long disable of IRQs
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

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

Mike Snitzer (1):
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (5):
      framebuffer: fix cfb_copyarea
      matroxfb: restore the registers M_ACCESS and M_PITCH
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix data copying

Nicholas Bellinger (1):
      iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err

Paolo Bonzini (1):
      KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-20=
14-0155)

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_P=
HY_HDR

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Sebastian Ott (1):
      s390/chsc: fix SEI usage on old FW levels

Sergey Dyasly (1):
      ARM: 7840/1: LPAE: don't reject mapping /dev/mem above 4GB

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Tyler Stachecki (1):
      mpt2sas: Don't disable device twice at suspend.

Vineet Gupta (3):
      ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption
      ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE
      ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcg01AAoJEDjbvchgkmk+ovIP+gMeTwMxacDy8o+jGdTr9cKn
2SeRaH5SyaABP8rUeVF7RleX2ZpCovMOlmPGUrss3O44QRSjGjQ2zRVMvkRFUfkE
Yh/N55aT6rxxvQYxGhQwbZ7saXxoxPO19lbvTPqNeSzZgARdczPzvcQExuxxtDTs
HimkmPtATy2fTLonskcfybNlKqlYsGRe+u3NliuukIH+KVEjgGTqnYtUa4MiqsbO
VpSoOHvUThT8R/d1gx9N9qp298De6RkJ3CMsO6wPN2FzlByWjEJnOHmjZ2f1QIZ0
6H6kV1XeFqVoEziiHZ+ky7OMRI6PFGsTKDtILjEyntnH06dWeoUc+97cMhlEWjtz
JAhwzsmELqP9ndjmTBHO22Qki+Ue8OZmonNFLqYJxCQxyWlCkgUPOYmDT/J9kEU3
t1IvC5PkjXldJRVek2s6PtVVicmmLYLuauwMreiGMJzTuNEhkDiS9qgNJgg1pzLW
GuXgKpmzdWSIYN5Y33Ptr2T8Xso5YMmCpidNV5Z9GRdk1kAEztgMeeE50ExMQCNL
PJWk+wmuRuThqiUocz5ZK3ysNpUiioVm74UDZYQxL35mmqUrTwcPyT+KHrFrcdjW
hXe9GaRg5sQ6WNmPDBbIWOiBNkvFGJWCu8t7zhqyzyiQMeynhBckzuhLyBjLO+eX
YjWSJ5t1bU6yBfdyg6PV
=/O3B
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
