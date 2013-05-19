Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3ESTml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 15:42:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3ESTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 15:42:40 -0400
Date: Sun, 19 May 2013 12:42:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.3
Message-ID: <20130519194257.GA31935@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.3 kernel.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm/include/asm/cmpxchg.h               |    8 -
 arch/arm/mach-exynos/include/mach/regs-pmu.h |    1=20
 arch/arm/mach-exynos/pmu.c                   |    5=20
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4=20
 arch/parisc/Makefile                         |   23 +--
 arch/parisc/kernel/entry.S                   |  172 ++++++++++++++--------=
-----
 arch/powerpc/include/asm/rtas.h              |    2=20
 arch/powerpc/kernel/machine_kexec_64.c       |    4=20
 arch/powerpc/kernel/rtas.c                   |  113 +++++++++++++++++
 arch/powerpc/platforms/pseries/suspend.c     |   22 +++
 arch/tile/Kconfig                            |   14 +-
 arch/tile/include/hv/hypervisor.h            |   27 +++-
 arch/tile/kernel/head_32.S                   |    2=20
 arch/tile/kernel/head_64.S                   |   12 +
 arch/x86/Kconfig                             |    1=20
 arch/x86/kernel/microcode_intel_early.c      |    5=20
 arch/x86/kvm/emulate.c                       |   42 ++++++
 arch/x86/kvm/vmx.c                           |    6=20
 arch/x86/xen/enlighten.c                     |   15 ++
 drivers/acpi/acpica/exfldio.c                |   14 ++
 drivers/acpi/ec.c                            |    4=20
 drivers/block/drbd/drbd_main.c               |    1=20
 drivers/block/drbd/drbd_receiver.c           |    5=20
 drivers/char/ipmi/ipmi_bt_sm.c               |    4=20
 drivers/char/ipmi/ipmi_devintf.c             |   14 ++
 drivers/cpufreq/intel_pstate.c               |   67 ++--------
 drivers/dma/of-dma.c                         |    8 -
 drivers/dma/pch_dma.c                        |    2=20
 drivers/gpu/drm/drm_crtc.c                   |    4=20
 drivers/gpu/drm/drm_mm.c                     |   34 ++---
 drivers/gpu/drm/i915/intel_fb.c              |   16 ++
 drivers/gpu/drm/mgag200/mgag200_mode.c       |   69 +++++++---
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2=20
 drivers/gpu/drm/radeon/radeon_drv.c          |   12 +
 drivers/hid/hid-core.c                       |    1=20
 drivers/md/dm-bufio.c                        |   24 +++
 drivers/md/dm-cache-target.c                 |    1=20
 drivers/md/dm-snap.c                         |    1=20
 drivers/md/dm-stripe.c                       |   11 -
 drivers/md/dm-table.c                        |    2=20
 drivers/net/ethernet/3com/3c509.c            |    2=20
 drivers/net/ethernet/3com/3c59x.c            |   27 ++--
 drivers/net/ethernet/sfc/mcdi.c              |    2=20
 drivers/net/ethernet/tile/tilegx.c           |    2=20
 drivers/net/macvlan.c                        |    7 -
 drivers/net/tun.c                            |    7 -
 drivers/net/usb/asix_common.c                |    3=20
 drivers/net/wireless/ath/ath9k/main.c        |    6=20
 drivers/net/wireless/b43/dma.c               |   19 ++
 drivers/net/wireless/b43/dma.h               |    4=20
 drivers/net/wireless/b43/main.c              |   43 ++----
 drivers/net/wireless/iwlegacy/4965-mac.c     |    3=20
 drivers/net/wireless/mwifiex/cfg80211.c      |    3=20
 drivers/net/wireless/mwifiex/cmdevt.c        |    1=20
 drivers/net/wireless/mwifiex/main.c          |    1=20
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 ---
 drivers/platform/x86/hp_accel.c              |    3=20
 drivers/rtc/Kconfig                          |    2=20
 drivers/rtc/rtc-pcf2123.c                    |    1=20
 drivers/scsi/sd.c                            |   20 +++
 drivers/scsi/sd.h                            |    1=20
 drivers/target/iscsi/iscsi_target_erl1.c     |    7 -
 drivers/target/target_core_file.c            |   10 -
 drivers/target/target_core_iblock.c          |    2=20
 drivers/target/target_core_transport.c       |   11 -
 drivers/watchdog/watchdog_dev.c              |    3=20
 fs/ext4/mballoc.c                            |    6=20
 fs/namei.c                                   |    2=20
 fs/nfsd/nfs4proc.c                           |   15 ++
 fs/nfsd/nfs4recover.c                        |   12 -
 include/linux/audit.h                        |    7 -
 include/linux/kref.h                         |   33 +++++
 include/linux/time.h                         |    4=20
 include/net/inet_frag.h                      |    5=20
 include/net/sock.h                           |   12 +
 include/net/tcp.h                            |    1=20
 include/uapi/linux/audit.h                   |    1=20
 include/uapi/linux/if_cablemodem.h           |   12 -
 include/uapi/linux/virtio_net.h              |    2=20
 ipc/shm.c                                    |    8 +
 kernel/auditfilter.c                         |   31 ++++
 kernel/auditsc.c                             |    5=20
 kernel/kmod.c                                |    5=20
 kernel/sched/cputime.c                       |   70 ++++++++--
 kernel/time/Kconfig                          |    5=20
 kernel/time/tick-sched.c                     |    2=20
 kernel/timer.c                               |    2=20
 kernel/trace/trace_events_filter.c           |    4=20
 mm/mmap.c                                    |    8 -
 net/8021q/vlan_dev.c                         |    2=20
 net/bridge/br_stp_timer.c                    |    2=20
 net/core/dev.c                               |    2=20
 net/core/ethtool.c                           |    2=20
 net/core/sock.c                              |   12 -
 net/ipv4/inet_fragment.c                     |    1=20
 net/ipv4/tcp_minisocks.c                     |    7 -
 net/ipv6/ip6_gre.c                           |    2=20
 net/ipv6/tcp_ipv6.c                          |   12 +
 net/ipv6/udp.c                               |   13 +-
 net/ipv6/udp_impl.h                          |    2=20
 net/ipv6/udplite.c                           |    2=20
 net/ipv6/xfrm6_policy.c                      |    4=20
 net/mac802154/mac802154.h                    |    2=20
 net/packet/af_packet.c                       |   53 +++-----
 net/sched/act_ipt.c                          |   33 ++++-
 net/vmw_vsock/af_vsock.c                     |    2=20
 sound/pci/hda/hda_codec.c                    |    7 -
 sound/pci/hda/patch_conexant.c               |   17 ++
 sound/soc/codecs/da7213.c                    |    8 -
 sound/soc/codecs/wm8994.c                    |    1=20
 111 files changed, 994 insertions(+), 431 deletions(-)

Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI dev=
ices

Amerigo Wang (1):
      ipv6,gre: do not leak info to user-space

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Andy Grover (1):
      target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio

Anton Blanchard (2):
      audit: Syscall rules are not applied to existing processes on non-x86
      powerpc/kexec: Fix kexec when using VMX optimised memcpy

Axel Lin (1):
      ASoC: da7213: Fix setting dmic_samplephase and dmic_clk_rate

Ben Hutchings (1):
      sfc: Fix naming of MTD partitions for FPGA bitfiles

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Bj=F8rn Mork (1):
      net: vlan,ethtool: netdev_features_t is more than 32 bit

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operati=
on

Chen Gang (2):
      net: mac802154: comparision issue of type cast, finding by EXTRA_CFLA=
GS=3D-W
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory ov=
erflow

Chris Metcalf (1):
      tile: support new Tilera hypervisor

Christopher Harvey (2):
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
      drm/mgag200: Fix framebuffer base address programming

Cong Wang (1):
      xfrm6: release dev before returning error

Dan Carpenter (1):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

Daniel Vetter (2):
      drm/mm: fix dump table BUG
      drm: don't check modeset locks in panic handler

Dave Airlie (1):
      drm/radeon: restore nomodeset operation (v2)

Dirk Brandewie (3):
      cpufreq / intel_pstate: remove idle time and duration from sample and=
 calculations
      cpufreq / intel_pstate: use lowest requested max performance
      cpufreq / intel_pstate: fix ffmpeg regression

Eric Dumazet (2):
      tcp: force a dst refcount when prequeue packet
      ipv6: do not clear pinet6 field

Eric W. Biederman (1):
      audit: Make testing for a valid loginuid explicit.

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Fernando Luis Vazquez Cao (1):
      HID: reintroduce fix-up for certain Sony RF receivers

Frederic Weisbecker (2):
      math64: New div64_u64_rem helper
      sched: Lower chances of cputime scaling overflow

Gao feng (1):
      net: tun: release the reference of tun device in tun_recvmsg

Geert Uytterhoeven (1):
      VSOCK: Drop bogus __init annotation from vsock_init_tables()

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Greg Kroah-Hartman (1):
      Linux 3.9.3

Guenter Roeck (1):
      watchdog: Fix race condition in registration code

Helge Deller (1):
      parisc: make default cross compiler search more robust (v3)

Inderpal Singh (1):
      ARM: EXYNOS5: Fix kernel dump in AFTR idle mode

J. Bruce Fields (1):
      nfsd4: don't allow owner override on 4.1 CLAIM_FH opens

Jaccon Bastiaansen (1):
      ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the=
 old/new value

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

James Bottomley (1):
      SCSI: sd: fix array cache flushing bug causing performance problems

Jani Nikula (1):
      drm/i915: clear the stolen fb before resuming

Jeff Layton (2):
      nfsd: fix oops when legacy_recdir_name_error is passed a -ENOENT error
      audit: vfs: fix audit_inode call in O_CREAT case of do_last

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path

Joern Engel (1):
      target: close target_put_sess_cmd() vs. core_tmr_abort_task() race

John David Anglin (3):
      parisc: only re-enable interrupts if we need to schedule or deliver s=
ignals when returning to userspace
      parisc: fix SMP races when updating PTE and TLB entries in entry.S
      parisc: use long branch in fork_like macro

John Stultz (1):
      time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

Konrad Rzeszutek Wilk (2):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.
      x86/microcode: Add local mutex to fix physical CPU hot-add deadlock

Konstantin Khlebnikov (1):
      net: frag, fix race conditions in LRU list maintenance

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set

Lars Ellenberg (1):
      drbd: fix memory leak

Li Zefan (1):
      shm: fix null pointer deref when userspace specifies invalid hugepage=
 size

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Mike Frysinger (1):
      parisc: fix NATIVE set up in build

Mike Snitzer (2):
      dm table: fix write same support
      dm stripe: fix regression in stripe_width calculation

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock

Nicholas Bellinger (1):
      target/iblock: Fix WCE=3D1 + DPOFUA=3D1 backend WRITE regression

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path !=3D NULL

Paolo Bonzini (3):
      KVM: emulator: emulate AAM
      KVM: emulator: emulate XLAT
      KVM: emulator: emulate SALC

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()

Philipp Reisner (2):
      drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set
      drbd: fix for deadlock when using automatic split-brain-recovery

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver unload
      3c59x: fix PCI resource management

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Stanislaw Gruszka (5):
      sched: Avoid cputime scaling overflow
      sched: Do not account bogus utime
      Revert "math64: New div64_u64_rem helper"
      sched: Avoid prev->stime underflow
      iwl4965: workaround connection regression on passive channel

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

Takashi Iwai (2):
      Revert "ALSA: hda - Don't set up active streams twice"
      ALSA: hda - Fix 3.9 regression of EAPD init on Conexant codecs

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Viresh Kumar (1):
      DMA: OF: Check properties value before running be32_to_cpup() on it

Wang YanQing (1):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer

Wei Yongjun (3):
      dm snapshot: fix error return code in snapshot_ctr
      dm cache: fix error return code in cache_create
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Yuchung Cheng (1):
      tcp: reset timer after any SYNACK retransmit

holger@eitzenberger.org (1):
      asix: fix BUG in receive path when lowering MTU

stephen hemminger (2):
      bridge: fix race with topology change timer
      virtio: don't expose u16 in userspace api


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRmStBAAoJEDjbvchgkmk+ob0P/AoKiVnGbYx/g5al48wa/jds
4e5VWEqWpZ+29Qud8flCM2AUtjQMCeglBdKNJcMdq+emV5ELsvlsUIv98i04p1tC
SM234VCIZB71u49FXwHB/vUQEGkzW0FvTNj0OGRjKxqiFRIkD98S3bB1JQ0dm1B1
70YmsmX762SbRX0qsy4Ny1Dx67+z1FeldX5YOZO8OnFhvin1s6FV+pNeM3p8Ey00
EPTHI5RoF+FOT0gtYIIDNz9MwYo1GLWLieiE0AvVURZXN0FtCrFX8PYIQ/GaUmKX
WFTbS3FDT1J1ybKDRMu/g9fmJMvwjXyefSFApk+WwsjCGbrsYOTmrX3hejnXUEsy
sLXz2Qvw9crc46RPQEVQch+WMWDbW7aW1ddDRqw1tk4hL7dtXgJCix/TnWOXtfpO
gd34ZphxjZ6bmPwviPzG3npS0oyApAlOWUEZQnhnT27dMQNbebmrl+dmxAsJDGbm
qmVeRMCWp0aaENw8qi6i8ua/9Pv/U6YBolDj5IFSf9oudq8vIV/3fGMYXNPXUvsx
f+mtF01uZJkvhyPnwElKx/8BkL8ARabORVp8OBPI5+1axlhjRdsDv3gvT17vCBpq
xoXhf3XeRL67pyJ/m5DapkoW9P2muvFA7HCzLPRGgF8MPvB3e2M442ZXe1Zv9YJs
7yqMFhCkhK8sJowA73G/
=Efqs
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
