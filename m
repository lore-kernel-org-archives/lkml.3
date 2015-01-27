Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbbA0ROF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:14:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbbA0RN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:13:58 -0500
Date: Tue, 27 Jan 2015 09:13:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.18.4
Message-ID: <20150127171357.GA19270@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.18.4 kernel.

All users of the 3.18 kernel series must upgrade.

The updated 3.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.18.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt              |    1=20
 Makefile                                         |    2=20
 arch/arc/boot/dts/nsimosci.dts                   |   18=20
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts       |    2=20
 arch/arm/boot/dts/berlin2q.dtsi                  |   63 +-
 arch/arm/boot/dts/dra7-evm.dts                   |   10=20
 arch/arm/boot/dts/imx25.dtsi                     |    2=20
 arch/arm/boot/dts/imx51-babbage.dts              |   22=20
 arch/arm/configs/omap2plus_defconfig             |    2=20
 arch/arm/mach-imx/clk-imx6q.c                    |    4=20
 arch/arm/mach-imx/clk-imx6sx.c                   |    3=20
 arch/arm/mach-omap2/common.h                     |    1=20
 arch/arm/mach-omap2/omap-headsmp.S               |   21=20
 arch/arm/mach-omap2/omap-smp.c                   |   13=20
 arch/arm/mach-omap2/timer.c                      |    8=20
 arch/arm/mach-shmobile/setup-sh73a0.c            |    3=20
 arch/arm64/mm/init.c                             |    8=20
 arch/parisc/include/asm/ldcw.h                   |   13=20
 arch/powerpc/platforms/powernv/opal-wrappers.S   |    1=20
 arch/um/Kconfig.common                           |    1=20
 arch/x86/boot/Makefile                           |    1=20
 arch/x86/kernel/cpu/Makefile                     |    1=20
 arch/x86/kernel/kprobes/core.c                   |   20=20
 arch/x86/kvm/vmx.c                               |    4=20
 arch/x86/um/sys_call_table_32.c                  |    2=20
 arch/x86/um/sys_call_table_64.c                  |    2=20
 drivers/bus/omap_l3_noc.c                        |   63 ++
 drivers/clk/at91/clk-slow.c                      |   27=20
 drivers/clk/berlin/bg2q.c                        |    1=20
 drivers/clk/clk-ppc-corenet.c                    |    2=20
 drivers/clk/clk.c                                |   10=20
 drivers/clk/rockchip/clk-rk3188.c                |   15=20
 drivers/clk/rockchip/clk-rk3288.c                |   28 -
 drivers/clk/samsung/clk-exynos-audss.c           |    4=20
 drivers/gpio/gpio-crystalcove.c                  |    2=20
 drivers/gpio/gpiolib-of.c                        |   10=20
 drivers/gpio/gpiolib-sysfs.c                     |   47 -
 drivers/gpio/gpiolib.c                           |   18=20
 drivers/gpu/drm/drm_dp_helper.c                  |    7=20
 drivers/gpu/drm/drm_dp_mst_topology.c            |    5=20
 drivers/gpu/drm/drm_fb_helper.c                  |   13=20
 drivers/gpu/drm/drm_irq.c                        |    3=20
 drivers/gpu/drm/i915/i915_drv.c                  |    3=20
 drivers/gpu/drm/i915/i915_drv.h                  |    3=20
 drivers/gpu/drm/i915/i915_gem.c                  |    5=20
 drivers/gpu/drm/i915/i915_gem_context.c          |   48 +
 drivers/gpu/drm/i915/i915_gem_stolen.c           |    6=20
 drivers/gpu/drm/i915/i915_irq.c                  |    6=20
 drivers/gpu/drm/i915/i915_reg.h                  |    4=20
 drivers/gpu/drm/i915/i915_suspend.c              |    8=20
 drivers/gpu/drm/i915/intel_display.c             |    8=20
 drivers/gpu/drm/i915/intel_pm.c                  |   27=20
 drivers/gpu/drm/i915/intel_ringbuffer.c          |    3=20
 drivers/gpu/drm/i915/intel_uncore.c              |    4=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c    |    8=20
 drivers/gpu/drm/radeon/atombios_crtc.c           |    8=20
 drivers/gpu/drm/radeon/atombios_dp.c             |    4=20
 drivers/gpu/drm/radeon/ci_dpm.c                  |    2=20
 drivers/gpu/drm/radeon/cik.c                     |    3=20
 drivers/gpu/drm/radeon/dce3_1_afmt.c             |    2=20
 drivers/gpu/drm/radeon/kv_dpm.c                  |   10=20
 drivers/gpu/drm/radeon/radeon_ttm.c              |    2=20
 drivers/gpu/drm/ttm/ttm_page_alloc.c             |   26=20
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c         |   25=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c              |    8=20
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c            |   39 -
 drivers/iio/adc/ad799x.c                         |   15=20
 drivers/infiniband/ulp/iser/iscsi_iser.h         |    2=20
 drivers/infiniband/ulp/iser/iser_initiator.c     |    6=20
 drivers/infiniband/ulp/isert/ib_isert.c          |  640 ++++++++++++++----=
-----
 drivers/infiniband/ulp/isert/ib_isert.h          |   15=20
 drivers/input/mouse/elantech.c                   |    2=20
 drivers/input/serio/i8042-x86ia64io.h            |   39 +
 drivers/input/serio/i8042.c                      |   14=20
 drivers/leds/leds-netxbig.c                      |   12=20
 drivers/md/dm.c                                  |    2=20
 drivers/media/i2c/smiapp-pll.c                   |    4=20
 drivers/media/i2c/smiapp/smiapp-core.c           |    2=20
 drivers/media/platform/vivid/vivid-vid-out.c     |    2=20
 drivers/media/rc/img-ir/img-ir-hw.c              |   28 -
 drivers/media/rc/img-ir/img-ir-hw.h              |    3=20
 drivers/media/usb/au0828/au0828-cards.c          |    5=20
 drivers/media/usb/dvb-usb/af9005.c               |    3=20
 drivers/media/usb/uvc/uvc_driver.c               |    6=20
 drivers/misc/cxl/context.c                       |   26=20
 drivers/misc/cxl/cxl.h                           |    9=20
 drivers/misc/cxl/file.c                          |    6=20
 drivers/misc/cxl/native.c                        |   12=20
 drivers/misc/cxl/pci.c                           |    2=20
 drivers/misc/cxl/sysfs.c                         |   10=20
 drivers/misc/mei/hw-me.c                         |   12=20
 drivers/mmc/host/sdhci.c                         |    6=20
 drivers/net/can/usb/kvaser_usb.c                 |   20=20
 drivers/net/ethernet/atheros/alx/main.c          |   24=20
 drivers/net/ethernet/broadcom/tg3.c              |   34 -
 drivers/net/ethernet/cisco/enic/enic_main.c      |   12=20
 drivers/net/ethernet/emulex/benet/be_main.c      |    8=20
 drivers/net/ethernet/intel/Kconfig               |   11=20
 drivers/net/ethernet/intel/i40e/Makefile         |    2=20
 drivers/net/ethernet/intel/i40e/i40e_osdep.h     |    4=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |   21=20
 drivers/net/ethernet/mellanox/mlx4/en_tx.c       |   12=20
 drivers/net/ethernet/mellanox/mlx4/fw.c          |    4=20
 drivers/net/ethernet/mellanox/mlx4/mr.c          |    9=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    8=20
 drivers/net/ethernet/ti/cpsw.c                   |   30 -
 drivers/net/ethernet/ti/cpsw_ale.c               |   10=20
 drivers/net/ethernet/ti/cpsw_ale.h               |    2=20
 drivers/net/team/team.c                          |   16=20
 drivers/net/wireless/iwlwifi/mvm/utils.c         |    2=20
 drivers/net/wireless/rtlwifi/pci.c               |   32 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c      |    2=20
 drivers/net/xen-netback/common.h                 |    4=20
 drivers/net/xen-netback/interface.c              |    4=20
 drivers/net/xen-netback/netback.c                |   27=20
 drivers/net/xen-netback/xenbus.c                 |   13=20
 drivers/pinctrl/pinctrl-xway.c                   |    2=20
 drivers/platform/x86/asus-nb-wmi.c               |    9=20
 drivers/platform/x86/hp_accel.c                  |    1=20
 drivers/reset/reset-sunxi.c                      |    4=20
 drivers/scsi/mpt2sas/mpt2sas_transport.c         |    5=20
 drivers/scsi/mpt3sas/mpt3sas_transport.c         |    5=20
 drivers/scsi/scsi_devinfo.c                      |    1=20
 drivers/scsi/scsi_error.c                        |    4=20
 drivers/scsi/scsi_lib.c                          |    4=20
 drivers/scsi/storvsc_drv.c                       |    7=20
 drivers/target/iscsi/iscsi_target_login.c        |   10=20
 drivers/target/iscsi/iscsi_target_util.c         |   26=20
 drivers/target/loopback/tcm_loop.c               |   66 --
 drivers/target/loopback/tcm_loop.h               |    7=20
 drivers/target/target_core_device.c              |    8=20
 drivers/target/target_core_file.c                |   11=20
 drivers/target/target_core_iblock.c              |    2=20
 drivers/target/target_core_sbc.c                 |   15=20
 drivers/target/target_core_spc.c                 |    5=20
 drivers/thermal/intel_powerclamp.c               |    2=20
 drivers/tty/serial/serial_core.c                 |    4=20
 drivers/usb/dwc3/gadget.c                        |    6=20
 drivers/usb/gadget/legacy/inode.c                |    1=20
 drivers/usb/gadget/udc/atmel_usba_udc.c          |   19=20
 drivers/usb/host/ehci-sched.c                    |    8=20
 drivers/usb/host/pci-quirks.c                    |   18=20
 drivers/usb/host/xhci-pci.c                      |    2=20
 drivers/usb/host/xhci.c                          |    9=20
 drivers/usb/musb/musb_host.c                     |    1=20
 drivers/usb/serial/console.c                     |   16=20
 drivers/usb/serial/cp210x.c                      |    4=20
 drivers/usb/serial/keyspan.c                     |   20=20
 drivers/usb/serial/option.c                      |   11=20
 drivers/usb/serial/qcserial.c                    |    1=20
 drivers/usb/storage/unusual_uas.h                |   28 +
 drivers/vfio/pci/vfio_pci.c                      |    4=20
 drivers/vhost/scsi.c                             |   24=20
 drivers/video/fbdev/core/fb_defio.c              |    5=20
 drivers/video/logo/logo.c                        |   17=20
 fs/lockd/svc.c                                   |    8=20
 fs/locks.c                                       |    2=20
 fs/nfs/nfs4client.c                              |   17=20
 fs/proc/stat.c                                   |    2=20
 include/linux/kernel_stat.h                      |    1=20
 include/linux/netdevice.h                        |   20=20
 include/net/vxlan.h                              |   28 -
 include/uapi/linux/in6.h                         |    3=20
 include/uapi/linux/libc-compat.h                 |    3=20
 include/uapi/linux/target_core_user.h            |    4=20
 kernel/irq/internals.h                           |    4=20
 kernel/irq/irqdesc.c                             |   52 +
 kernel/irq/proc.c                                |   22=20
 kernel/time/tick-sched.c                         |    2=20
 kernel/trace/ftrace.c                            |   53 +
 lib/decompress_bunzip2.c                         |    2=20
 net/batman-adv/fragmentation.c                   |    4=20
 net/batman-adv/gateway_client.c                  |    2=20
 net/core/dev.c                                   |   37 -
 net/core/skbuff.c                                |    1=20
 net/ipv4/geneve.c                                |   30 -
 net/ipv4/ip_gre.c                                |    9=20
 net/ipv4/tcp_output.c                            |    4=20
 net/ipv6/tcp_ipv6.c                              |   45 +
 net/netlink/af_netlink.c                         |   54 -
 net/wireless/chan.c                              |    9=20
 net/wireless/nl80211.c                           |    2=20
 net/wireless/reg.c                               |   12=20
 scripts/Makefile.clean                           |   16=20
 scripts/coccinelle/misc/bugon.cocci              |    2=20
 sound/usb/quirks-table.h                         |  166 +----
 186 files changed, 1853 insertions(+), 1094 deletions(-)

Aaron Lu (1):
      gpio: crystalcove: use handle_nested_irq

Ahmed S. Darwish (3):
      can: kvaser_usb: Don't free packets when tight on URBs
      can: kvaser_usb: Reset all URB tx contexts upon channel close
      can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels

Alan Stern (2):
      SCSI: fix regression in scsi_send_eh_cmnd()
      USB: EHCI: fix initialization bug in iso_stream_schedule()

Alex Deucher (7):
      drm/radeon: fix typo in CI dpm disable
      drm/radeon: work around a hw bug in MGCG on CIK
      drm/radeon: check the right ring in radeon_evict_flags()
      drm/radeon: KV has three PPLLs (v2)
      drm/radeon: fix sad_count check for dce3
      drm/radeon: adjust default bapm settings for KV
      drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw

Alexander Usyskin (1):
      mei: clean reset bit before reset

Amir Vadai (1):
      net/mlx4_en: Doorbell is byteswapped in Little Endian archs

Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Anton Blanchard (1):
      powernv: Fix OPAL tracepoint code

Antonio Quartulli (1):
      batman-adv: avoid NULL dereferences and fix if check

Arik Nemtsov (1):
      cfg80211: avoid mem leak on driver hint set

Arseny Solokha (1):
      OHCI: add a quirk for ULi M5237 blocking on reset

Bandan Das (1):
      KVM: nVMX: Disable unrestricted mode if ept=3D0

Bj=F8rn Mork (1):
      x86/build: Clean auto-generated processor feature files

Bo Shen (2):
      usb: gadget: udc: atmel: change setting for DMA
      usb: gadget: udc: atmel: fix possible IN hang issue

Boris Brezillon (1):
      clk: at91: keep slow clk enabled to prevent system hang

Catalin Marinas (1):
      arm64: partially revert "ARM: 8167/1: extend the reserved memory for =
initrd to be page aligned"

Chris Wilson (4):
      drm/i915: Only warn the first time we attempt to mmio whilst suspended
      drm/i915: Invalidate media caches on gen7
      drm/i915: Force the CS stall for invalidate flushes
      drm/i915: Disable PSMI sleep messages on all rings around context swi=
tches

Dan Carpenter (1):
      decompress_bunzip2: off by one in get_next_block()

Daniel Borkmann (1):
      x86, um: actually mark system call tables readonly

Daniel Vetter (3):
      drm/dp-mst: Remove branches before dropping the reference
      drm/i915: Don't complain about stolen conflicts on gen3
      drm/i915: Disallow pin ioctl completely for kms drivers

Dave Airlie (3):
      drm/fb_helper: move deferred fb checking into restore mode (v2)
      drm/dp: retry AUX transactions 32 times (v1.1)
      drm/i915: resume MST after reading back hw state

David Miller (1):
      netlink: Always copy on mmap TX.

David Peterson (1):
      USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

David Vrabel (1):
      xen-netback: support frontends without feature-rx-notify again

Dmitry Torokhov (1):
      Input: I8042 - add Acer Aspire 7738 to the nomux list

Dmitry Voytik (1):
      ARM: imx6q: drop unnecessary semicolon

Dominique Leuenberger (1):
      hp_accel: Add support for HP ZBook 15

Dylan Rajaratnam (1):
      img-ir/hw: Always read data to clear buffer

Emmanuel Grumbach (1):
      cfg80211: don't WARN about two consecutive Country IE hint

Eric Dumazet (1):
      alx: fix alx_poll()

Eyal Shapira (1):
      iwlwifi: mvm: fix Rx with both chains

Fabio Estevam (3):
      ARM: imx6sx: Set PLL2 as parent of QSPI clocks
      ARM: dts: imx25: Fix the SPI1 clocks
      ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling

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
      Linux 3.18.4

Hannes Reinecke (1):
      tcm_loop: Fix wrong I_T nexus association

Hans Holmberg (1):
      gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Hans Verkuil (1):
      vivid: fix CROP_BOUNDS typo for video output

Hans de Goede (5):
      xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controll=
ers
      asus-nb-wmi: Add another wapf=3D4 quirk
      uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS566 with usb-id 0bc2:=
a013
      uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures

Heiko Stuebner (2):
      clk: rockchip: fix rk3288 cpuclk core dividers
      clk: rockchip: fix rk3066 pll lock bit location

Herbert Xu (1):
      tcp: Do not apply TSO segment limit to non-TSO packets

Ian Munsie (3):
      cxl: Change contexts_lock to a mutex to fix sleep while atomic bug
      cxl: Add timeout to process element commands
      cxl: Unmap MMIO regions when detaching a context

Ido Shamay (1):
      net/mlx4: Cache line CQE/EQE stride fixes

Ilia Mirkin (1):
      drm/nv4c/mc: disable msi

James Bottomley (1):
      serial: fix parisc boot hang

James Hogan (1):
      img-ir/hw: Fix potential deadlock stopping timer

Jason Wang (1):
      net: drop the packet when fails to do software segmentation or header=
 check

Jay Vosburgh (1):
      net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Jesse Barnes (1):
      drm/i915: save/restore GMBUS freq across suspend/resume on gen4

Jesse Gross (3):
      geneve: Remove socket and offload handlers at destruction.
      geneve: Fix races between socket add and release.
      net: Generalize ndo_gso_check to ndo_features_check

Jiri Pirko (1):
      team: avoid possible underflow of count_pending value for notify_peer=
s and mcast_rejoin

Jisheng Zhang (4):
      clk: berlin: bg2q: remove non-exist "smemc" gate clock
      ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2=
 host
      ARM: dts: berlin: correct BG2Q's SM GPIO location.
      ARM: dts: berlin: add broken-cd and set bus width for eMMC in Marvell=
 DMP DT

Johan Hovold (9):
      pinctrl: lantiq: remove bogus of_gpio_chip_add
      gpio: fix memory and reference leaks in gpiochip_add error path
      gpio: fix memory leak and sleep-while-atomic
      gpio: fix sleep-while-atomic in gpiochip_remove
      gpio: sysfs: fix gpio-chip device-attribute leak
      gpio: sysfs: fix gpio device-attribute leak
      USB: keyspan: fix null-deref at probe
      USB: console: fix uninitialised ldisc semaphore
      USB: console: fix potential use after free

John David Anglin (1):
      parisc: fix out-of-register compiler error in ldcw inline assembler f=
unction

Jouni Malinen (1):
      cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Keerthy (2):
      bus: omap_l3_noc: Add resume hook to restore context
      bus: omap_l3_noc: Correct returning IRQ_HANDLED unconditionally in th=
e irq handler

Kevin Hao (1):
      Revert "clk: ppc-corenet: Fix Section mismatch warning"

Krzysztof Kozlowski (1):
      clk: samsung: Fix double add of syscore ops after driver rebind

Kyle McMartin (1):
      uapi/linux/target_core_user.h: fix headers_install.sh badness

Larry Finger (2):
      rtlwifi: rtl8192ce: Set fw_ready flag
      rtlwifi: Fix error when accessing unmapped memory in skb

Lars-Peter Clausen (1):
      iio: ad799x: Fix ad7991/ad7995/ad7999 config setup

Lennart Sorensen (2):
      ARM: omap5/dra7xx: Fix frequency typos
      ARM: omap5/dra7xx: Enable booting secondary CPU in HYP mode

Long Li (1):
      storvsc: ring buffer failures may result in I/O freeze

Luciano Coelho (1):
      nl80211: check matches array length before acessing it

Maor Gottlieb (1):
      net/mlx4_core: Correcly update the mtt's offset in the MR re-reg flow

Mario Schuknecht (1):
      usb: gadget: gadgetfs: Free memory allocated by memdup_user()

Martin K. Petersen (1):
      scsi: blacklist RSOC for Microsoft iSCSI target devices

Mathias Nyman (1):
      xhci: Check if slot is already in default state before moving it there

Mauro Carvalho Chehab (3):
      bugon.cocci: fix Options at the macro
      sound: simplify au0828 quirk table
      sound: Update au0828 quirks table

Max Gurtovoy (1):
      IB/iser: Fix possible SQ overflow

Michal Marek (1):
      kbuild: Fix removal of the debian/ directory

Mugunthan V N (2):
      drivers: net: cpsw: fix multicast flush in dual emac mode
      ARM: dts: dra7-evm: fix qspi device tree partition size

NeilBrown (1):
      locks: fix NULL-deref in generic_delete_lease

Nicholas Bellinger (3):
      iscsi-target: Fail connection on short sendmsg writes
      target: Drop arbitrary maximum I/O size limit
      vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion

Nicolas Dichtel (1):
      tcp6: don't move IP6CB before xfrm6_policy_check()

Nishanth Menon (1):
      ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT

Palik, Imre (1):
      xen-netback: fixing the propagation of the transmit shaper timeout

Prashant Sreedharan (1):
      tg3: tg3_disable_ints using uninitialized mailbox value to disable in=
terrupts

Preston Fick (1):
      USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Reinhard Speyerer (1):
      USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx

Richard Weinberger (1):
      um: Skip futex_atomic_cmpxchg_inatomic() test

Rob Clark (1):
      drm/irq: BUG_ON() -> WARN_ON()

Sagi Grimberg (9):
      iscsi,iser-target: Initiate termination only once
      iser-target: Fix flush + disconnect completion handling
      iser-target: Parallelize CM connection establishment
      iser-target: Fix connected_handler + teardown flow race
      iser-target: Handle ADDR_CHANGE event for listener cm_id
      iser-target: Fix implicit termination of connections
      iser-target: Allocate PI contexts dynamically
      iser-target: Fix NULL dereference in SW mode DIF
      iscsi,iser-target: Expose supported protection ops according to t10_pi

Sakari Ailus (2):
      smiapp-pll: Correct clock debug prints
      smiapp: Take mutex during PLL update in sensor initialisation

Sam hung (1):
      Input: elantech - support new ICs types for version 4

Sebastian Andrzej Siewior (1):
      usb: musb: stuff leak of struct usb_hcd

Simon Guinot (1):
      leds: netxbig: fix oops at probe time

Songjun Wu (1):
      usb: gadget: udc: atmel: fix possible oops when unloading module

Sreekanth Reddy (2):
      Revert "[SCSI] mpt2sas: Remove phys on topology change."
      Revert "[SCSI] mpt3sas: Remove phys on topology change"

Srihari Vijayaraghavan (1):
      Input: i8042 - reset keyboard to fix Elantech touchpad detection

Stephen Boyd (1):
      clk: Really fix deadlock with mmap_sem

Steven Rostedt (Red Hat) (3):
      ftrace/jprobes/x86: Fix conflict between jprobes and function graph t=
racing
      ftrace: Fix updating of filters for shared global_ops filters
      ftrace: Check both notrace and filter for old hash

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

Thomas Hellstrom (3):
      drm/vmwgfx: Don't use memory accounting for kernel-side fence objects
      drm/vmwgfx: Fix error printout on signals pending
      drm/vmwgfx: Fix fence event code

Tim Kryger (1):
      mmc: sdhci: Set SDHCI_POWER_ON with external vmmc

Timo Ter=E4s (1):
      gre: fix the inner mac header in nbma tunnel xmit path

Tomeu Vizoso (1):
      clk: Don't try to use a struct clk* after it could have been freed

Tomi Valkeinen (2):
      video/logo: prevent use of logos after they have been freed
      video/fbdev: fix defio's fsync

Tony Battersby (1):
      scsi: fix random memory corruption with scsi-mq + T10 PI

Toshiaki Makita (1):
      net: Fix stacked vlan offload features computation

Trond Myklebust (2):
      NFSv4.1: Fix client id trunking on Linux
      LOCKD: Fix a race when initialising nlmsvc_timeout

Tyler Baker (1):
      reset: sunxi: fix spinlock initialization

Vasu Dev (1):
      i40e: adds FCoE configure option

Ville Syrj=E4l=E4 (3):
      drm/i915: Don't call intel_prepare_page_flip() multiple times on gen2=
-4
      Revert "drm/i915: Preserve VGACNTR bits from the BIOS"
      drm/i915: Kill check_power_well() calls

Vineet Gupta (1):
      ARC: [nsimosci] move peripherals to match model to FPGA

Wei Yang (1):
      vfio-pci: Fix the check on pci device type in vfio_pci_probe()

stephen hemminger (1):
      in6: fix conflict with glibc

zhendong chen (1):
      dm: fix missed error code if .end_io isn't implemented by target_type


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUx8dVAAoJEDjbvchgkmk+zLwQALKM+h1KoumdAjl5BVAoU4OY
Z8eNrzQ8DYXZRtl3NcGeITRZpZwSzKdp3jzAQe+FbbHNF3MFSZ6LjNF0e+alDZ8K
wU/rdB4dSAH0vdKhsOVBkuW6j4urOgovph6SKXKncjOLC3AwN5js18k4r86gS1EF
O2wWkyAPBolwh2//IgCSJFlhmWcOOmOy1E8MNKlmjPJMf03UDPMUQr/snZzheT4n
9i4oVLKKutgrUAuEojQEC9vhoEUVSKs/rqYBuW8sgUisCvNW8dLH0eYcejzEQkrk
KYcubZti+CXrigDAIobn8ZvqmoPBAdAULpIm3hRs9NBDkdRcwsxi2gUyOHP3UAZo
dJ/oI99NYboNueLNuHacDksEnT9H1BkEFRydm9Ni84HEsuCl/npusGaPswfe0Ips
fBPcY6wcalcngUC4y8gyZLFPfooiRkX8gPm0bTyULVNCn92vqgggnoboVcKUTTWr
B+YY8Bvq+7hA20OazYoQMJBYCxI46xlSIphstmA6kvUvRPum1SqIeqkFU048qzp2
jElBqwScSY0n5T9tdsi2RnOofpRvdBYgrDiNVjlL2jX7KWH4wAHx6wMxTtYtrkwC
/KIMoSR45Ay+4H87uoWT6QaonlIWYYroCYTWEIR89lqXpRuvTEwpCiI+gOWnd3T3
9XSX/NeZmxP7oR+wCivt
=rpVX
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
