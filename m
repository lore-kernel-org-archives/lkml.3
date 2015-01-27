Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbbA0RN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:13:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbbA0RNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:13:25 -0500
Date: Tue, 27 Jan 2015 09:13:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.30
Message-ID: <20150127171324.GA19193@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.30 kernel.

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

 Documentation/kernel-parameters.txt           |    1=20
 Makefile                                      |    2=20
 arch/arc/boot/dts/nsimosci.dts                |   18 -
 arch/arc/include/asm/linkage.h                |   14 -
 arch/arc/kernel/ctx_sw_asm.S                  |    2=20
 arch/arc/kernel/entry.S                       |   52 +--
 arch/arc/lib/memcmp.S                         |    6=20
 arch/arc/lib/memcpy-700.S                     |    6=20
 arch/arc/lib/memset.S                         |   10=20
 arch/arc/lib/strchr-700.S                     |    6=20
 arch/arc/lib/strcmp.S                         |    6=20
 arch/arc/lib/strcpy-700.S                     |    6=20
 arch/arc/lib/strlen.S                         |    6=20
 arch/arc/mm/tlbex.S                           |   10=20
 arch/arm/boot/dts/imx25.dtsi                  |    2=20
 arch/arm/mach-imx/clk-imx6q.c                 |    4=20
 arch/arm/mach-omap2/timer.c                   |    8=20
 arch/arm/mach-shmobile/setup-sh73a0.c         |    3=20
 arch/parisc/include/asm/ldcw.h                |   13=20
 arch/um/Kconfig.common                        |    1=20
 arch/x86/kernel/kprobes/core.c                |   20 +
 arch/x86/kvm/vmx.c                            |    4=20
 arch/x86/um/sys_call_table_32.c               |    2=20
 arch/x86/um/sys_call_table_64.c               |    2=20
 drivers/clk/clk.c                             |    5=20
 drivers/clk/samsung/clk-exynos-audss.c        |    4=20
 drivers/gpio/gpiolib-of.c                     |   10=20
 drivers/gpio/gpiolib.c                        |   11=20
 drivers/gpu/drm/i915/i915_gem_stolen.c        |    6=20
 drivers/gpu/drm/i915/i915_reg.h               |    1=20
 drivers/gpu/drm/i915/intel_ringbuffer.c       |    3=20
 drivers/gpu/drm/i915/intel_uncore.c           |    4=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c |    8=20
 drivers/gpu/drm/radeon/atombios_dp.c          |    4=20
 drivers/gpu/drm/radeon/ci_dpm.c               |    2=20
 drivers/gpu/drm/radeon/cik.c                  |    3=20
 drivers/gpu/drm/radeon/radeon_ttm.c           |    2=20
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |   26 +
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c      |   25 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c         |   17 -
 drivers/infiniband/ulp/isert/ib_isert.c       |  344 ++++++++++++++++++---=
-----
 drivers/infiniband/ulp/isert/ib_isert.h       |    7=20
 drivers/input/serio/i8042-x86ia64io.h         |   39 ++
 drivers/input/serio/i8042.c                   |   14 +
 drivers/md/bcache/btree.c                     |    2=20
 drivers/media/i2c/smiapp-pll.c                |    4=20
 drivers/media/i2c/smiapp/smiapp-core.c        |    2=20
 drivers/media/usb/au0828/au0828-cards.c       |    5=20
 drivers/media/usb/dvb-usb/af9005.c            |    3=20
 drivers/media/usb/uvc/uvc_driver.c            |    6=20
 drivers/net/can/usb/kvaser_usb.c              |   20 -
 drivers/net/ethernet/atheros/alx/main.c       |   24 -
 drivers/net/ethernet/broadcom/tg3.c           |   34 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |   12=20
 drivers/net/ethernet/ti/cpsw.c                |   30 +-
 drivers/net/ethernet/ti/cpsw_ale.c            |   10=20
 drivers/net/ethernet/ti/cpsw_ale.h            |    2=20
 drivers/net/team/team.c                       |   16 +
 drivers/platform/x86/hp_accel.c               |    1=20
 drivers/s390/char/con3215.c                   |   52 ++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c      |    5=20
 drivers/scsi/mpt3sas/mpt3sas_transport.c      |    5=20
 drivers/scsi/scsi_devinfo.c                   |    1=20
 drivers/scsi/storvsc_drv.c                    |    7=20
 drivers/target/iscsi/iscsi_target_login.c     |    3=20
 drivers/target/iscsi/iscsi_target_util.c      |   26 -
 drivers/target/loopback/tcm_loop.c            |   89 ++----
 drivers/target/loopback/tcm_loop.h            |    7=20
 drivers/thermal/intel_powerclamp.c            |    2=20
 drivers/usb/dwc3/gadget.c                     |    6=20
 drivers/usb/host/ehci-sched.c                 |    8=20
 drivers/usb/host/pci-quirks.c                 |   18 +
 drivers/usb/musb/musb_host.c                  |    1=20
 drivers/usb/serial/console.c                  |   16 -
 drivers/usb/serial/cp210x.c                   |    4=20
 drivers/usb/serial/keyspan.c                  |   20 +
 drivers/vfio/pci/vfio_pci.c                   |    4=20
 drivers/vhost/scsi.c                          |   24 +
 drivers/video/logo/logo.c                     |   17 +
 fs/lockd/svc.c                                |    8=20
 fs/nfs/nfs4client.c                           |   17 -
 fs/notify/inode_mark.c                        |   17 -
 fs/proc/stat.c                                |    2=20
 include/linux/kernel_stat.h                   |    1=20
 include/uapi/linux/in6.h                      |    3=20
 include/uapi/linux/libc-compat.h              |    3=20
 kernel/irq/internals.h                        |    8=20
 kernel/irq/irqdesc.c                          |   52 +++
 kernel/irq/proc.c                             |   22 +
 kernel/time/tick-sched.c                      |    2=20
 lib/decompress_bunzip2.c                      |    2=20
 net/batman-adv/fragmentation.c                |    4=20
 net/batman-adv/gateway_client.c               |    2=20
 net/core/dev.c                                |   89 +++++-
 net/core/skbuff.c                             |    1=20
 net/ipv4/ip_gre.c                             |    9=20
 net/ipv4/tcp_output.c                         |    4=20
 net/netfilter/ipset/ip_set_core.c             |    6=20
 net/netlink/af_netlink.c                      |   54 +---
 net/wireless/chan.c                           |    9=20
 net/wireless/reg.c                            |   12=20
 sound/usb/quirks-table.h                      |  166 ++----------
 102 files changed, 1041 insertions(+), 677 deletions(-)

Ahmed S. Darwish (3):
      can: kvaser_usb: Don't free packets when tight on URBs
      can: kvaser_usb: Reset all URB tx contexts upon channel close
      can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels

Alan Stern (1):
      USB: EHCI: fix initialization bug in iso_stream_schedule()

Alex Deucher (4):
      drm/radeon: fix typo in CI dpm disable
      drm/radeon: work around a hw bug in MGCG on CIK
      drm/radeon: check the right ring in radeon_evict_flags()
      drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw

Alexander Y. Fomichev (2):
      net: prevent of emerging cross-namespace symlinks
      net: fix creation adjacent device symlinks

Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Antonio Quartulli (1):
      batman-adv: avoid NULL dereferences and fix if check

Arik Nemtsov (1):
      cfg80211: avoid mem leak on driver hint set

Arseny Solokha (1):
      OHCI: add a quirk for ULi M5237 blocking on reset

Bandan Das (1):
      KVM: nVMX: Disable unrestricted mode if ept=3D0

Chris Wilson (3):
      drm/i915: Only warn the first time we attempt to mmio whilst suspended
      drm/i915: Invalidate media caches on gen7
      drm/i915: Force the CS stall for invalidate flushes

Dan Carpenter (2):
      decompress_bunzip2: off by one in get_next_block()
      netfilter: ipset: small potential read beyond the end of buffer

Daniel Borkmann (1):
      x86, um: actually mark system call tables readonly

Daniel Vetter (1):
      drm/i915: Don't complain about stolen conflicts on gen3

David Miller (1):
      netlink: Always copy on mmap TX.

David Peterson (1):
      USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

Dmitry Torokhov (1):
      Input: I8042 - add Acer Aspire 7738 to the nomux list

Dmitry Voytik (1):
      ARM: imx6q: drop unnecessary semicolon

Dominique Leuenberger (1):
      hp_accel: Add support for HP ZBook 15

Emmanuel Grumbach (1):
      cfg80211: don't WARN about two consecutive Country IE hint

Eric Dumazet (1):
      alx: fix alx_poll()

Fabio Estevam (1):
      ARM: dts: imx25: Fix the SPI1 clocks

Felipe Balbi (1):
      net: ethernet: cpsw: fix hangs with interrupts

Frank Schaefer (1):
      af9005: fix kernel panic on init if compiled without IR

Gary Bisson (1):
      ARM: clk-imx6q: fix video divider for rev T0 1.0

Geert Uytterhoeven (1):
      ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin inst=
ances

Govindarajulu Varadarajan (1):
      enic: fix rx skb checksum

Greg Kroah-Hartman (1):
      Linux 3.14.30

Hannes Reinecke (2):
      tcm_loop: Fixup tag handling
      tcm_loop: Fix wrong I_T nexus association

Hans Holmberg (1):
      gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Herbert Xu (1):
      tcp: Do not apply TSO segment limit to non-TSO packets

Ilia Mirkin (1):
      drm/nv4c/mc: disable msi

Jay Vosburgh (1):
      net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Jerry Hoemann (1):
      fsnotify: next_i is freed during fsnotify_unmount_inodes.

Jiri Pirko (1):
      team: avoid possible underflow of count_pending value for notify_peer=
s and mcast_rejoin

Johan Hovold (4):
      gpio: fix memory and reference leaks in gpiochip_add error path
      USB: keyspan: fix null-deref at probe
      USB: console: fix uninitialised ldisc semaphore
      USB: console: fix potential use after free

John David Anglin (1):
      parisc: fix out-of-register compiler error in ldcw inline assembler f=
unction

Jouni Malinen (1):
      cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Kent Overstreet (1):
      bcache: Make sure to pass GFP_WAIT to mempool_alloc()

Krzysztof Kozlowski (1):
      clk: samsung: Fix double add of syscore ops after driver rebind

Lennart Sorensen (1):
      ARM: omap5/dra7xx: Fix frequency typos

Long Li (1):
      storvsc: ring buffer failures may result in I/O freeze

Martin K. Petersen (1):
      scsi: blacklist RSOC for Microsoft iSCSI target devices

Martin Schwidefsky (2):
      s390/3215: fix hanging console issue
      s390/3215: fix tty output containing tabs

Mauro Carvalho Chehab (2):
      sound: simplify au0828 quirk table
      sound: Update au0828 quirks table

Mugunthan V N (1):
      drivers: net: cpsw: fix multicast flush in dual emac mode

Nicholas Bellinger (2):
      iscsi-target: Fail connection on short sendmsg writes
      vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion

Prashant Sreedharan (1):
      tg3: tg3_disable_ints using uninitialized mailbox value to disable in=
terrupts

Preston Fick (1):
      USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Richard Weinberger (1):
      um: Skip futex_atomic_cmpxchg_inatomic() test

Sagi Grimberg (6):
      iscsi,iser-target: Initiate termination only once
      iser-target: Fix flush + disconnect completion handling
      iser-target: Parallelize CM connection establishment
      iser-target: Fix connected_handler + teardown flow race
      iser-target: Handle ADDR_CHANGE event for listener cm_id
      iser-target: Fix implicit termination of connections

Sakari Ailus (2):
      smiapp-pll: Correct clock debug prints
      smiapp: Take mutex during PLL update in sensor initialisation

Sebastian Andrzej Siewior (1):
      usb: musb: stuff leak of struct usb_hcd

Sreekanth Reddy (2):
      Revert "[SCSI] mpt2sas: Remove phys on topology change."
      Revert "[SCSI] mpt3sas: Remove phys on topology change"

Srihari Vijayaraghavan (1):
      Input: i8042 - reset keyboard to fix Elantech touchpad detection

Steven Rostedt (Red Hat) (1):
      ftrace/jprobes/x86: Fix conflict between jprobes and function graph t=
racing

Sven Eckelmann (2):
      batman-adv: Calculate extra tail size based on queued fragments
      batman-adv: Unify fragment size calculation

Takashi Iwai (1):
      uvcvideo: Fix destruction order in uvc_delete()

Tetsuo Handa (1):
      drm/ttm: Avoid memory allocation from shrinker functions.

Thomas Gleixner (2):
      tick/powerclamp: Remove tick_nohz_idle abuse
      genirq: Prevent proc race against freeing of irq descriptors

Thomas Graf (2):
      netlink: Don't reorder loads/stores before marking mmap netlink frame=
 as available
      net: Reset secmark when scrubbing packet

Thomas Hellstrom (1):
      drm/vmwgfx: Fix fence event code

Timo Ter=E4s (1):
      gre: fix the inner mac header in nbma tunnel xmit path

Tomeu Vizoso (1):
      clk: Don't try to use a struct clk* after it could have been freed

Tomi Valkeinen (1):
      video/logo: prevent use of logos after they have been freed

Toshiaki Makita (1):
      net: Fix stacked vlan offload features computation

Trond Myklebust (2):
      NFSv4.1: Fix client id trunking on Linux
      LOCKD: Fix a race when initialising nlmsvc_timeout

Vineet Gupta (2):
      ARC: [nsimosci] move peripherals to match model to FPGA
      ARC: switch to generic ENTRY/END assembler annotations

Wei Yang (1):
      vfio-pci: Fix the check on pci device type in vfio_pci_probe()

stephen hemminger (1):
      in6: fix conflict with glibc


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUx8c0AAoJEDjbvchgkmk+fq8P/irZvRUxRbKYhTZN6QWwyoLz
x8YFImD0Q/dlOXt3adhAb3krZ0j3dobTF9poK9PgB0+oPmmQm5ZOOQSKovYWmoEt
C4smEJqE5c/RFPDD+Sw84j/y29JjooRQ/duvqXB5WhvGjfE13RWYBLlO1u2DA+9F
mo28ZozApp+GI8t+YE+E7AOE+SNeSL9QSA+ur+UEM280mGVJ70VhSZ4jINS3bgmz
rW/UnOr6NwTqUGw+ZSzUZJRNm/Tt9uZoLUTETUxm0ayzWGfoRoevatSDlHq2ih1l
MCDAQ3zyCQTjR8AoIP0QkEtXTFCV0zdGRcqg5Fq8yybOoy2peQojeIc+GNN9jGur
kVdOk8hE746faaSQ9n1TB07yguEuVZYFaQnebWmeSoPB8229fMPuxQab2sFFKndm
VtUH0/6bopeDjqQf5em1I4tLUlVizHdU/lvE3HCVb3rYxAls79sA7GFhB48YCupc
z7+pDHtEJ850BflGDpuz/gdm59kNV7gKOYXwCxRBXW59+1fzXgZYVedAtLef+gSs
CJOJqL/rMRPPNqGb39nJHCUDhDCsHu7dLcOc/3jmRg8ClVAyT4HFmJj1njHiXac9
xss0Kqzghq0dZAXk8XwTVRmUJvix/6NipkGnn9LsWfvHKZqmnehAPp07mVN32l25
xHICvIzlcdKsXPl2cIsx
=9bz3
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
