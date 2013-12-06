Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3LFR62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:58:28 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33308 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LFR6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:58:24 -0500
MIME-Version: 1.0
Date: Fri, 6 Dec 2013 09:58:22 -0800
X-Google-Sender-Auth: gE5Q0Zr4Kdrs-2fOzpP1aY4fqoc
Message-ID: <CA+55aFwfqrU-c0MP_+TPL1wdVAC9EUTngTYAWW9ThWvhA8zgbg@mail.gmail.com>
Subject: Linux 3.13-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. I'm still on a Friday release schedule, although I hope that
changes soon - the reason I didn't drag this one out to Sunday is that
it's already big enough, and I'll wait until things start calming
down.

Which they really should, at this point. Hint hint. I'll start
shouting at people for sending me stuff that isn't appropriate as
we're starting to get later into the release candidates.

That said, it's not like rc3 is somehow unmanageably large or that
anything particularly scary has happened.  I'd have *liked* for it to
be smaller, but I always do.. And nothing particularly nasty stands
out here.

The bulk here is drivers (net, scsi, sound, crypto..) and ARM DT
stuff, but there's the usual randon stuff too, with arch updates
(pa-risc, more ARM, x86) and some filesystem and networking updates.

Go wild,

                  Linus

---

Aaro Koskinen (1):
      ARM: OMAPFB: panel-sony-acx565akm: fix bad unlock balance

Ajit Khaparde (3):
      be2net: Disabling and enabling interrupts in suspend and resume
      be2net: set coalesce-wm in CQ_CREATE_V2 cmd
      be2net: Avoid programming permenant MAC by BE3-R VFs

Akeem G Abodunrin (1):
      igb: Fixed Wake On LAN support

Alex Shi (1):
      sched: Remove unused variable in 'struct sched_domain'

Alexandre Courbot (4):
      gpiolib: add missing declarations
      gpiolib: fix lookup of platform-mapped GPIOs
      Documentation: gpiolib: add 00-INDEX file
      gpiolib: use platform GPIO mappings as fallback

Amit Pundir (1):
      epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled

Andi Shyti (1):
      u8500_defconfig: allow creation and mounting of devtmpfs

Andrew Morton (1):
      tick: Document tick_do_timer_cpu

Andy Adamson (2):
      NFSv4 wait on recovery for async session errors
      SUNRPC: do not fail gss proc NULL calls with EACCES

Andy Whitcroft (1):
      xen-netback: include definition of csum_ipv6_magic

Anna Schumaker (1):
      NFS: Enabling v4.2 should not recompile nfsd and lockd

Arnaldo Carvalho de Melo (1):
      tools lib traceevent: Fix conversion of pointer to integer of
different size

Arnaud Ebalard (2):
      ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable
      ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260

Arvid Brodin (3):
      MAINTAINERS: Added net/hsr/ maintainer
      net/hsr: Very small fix of comment style.
      net/hsr: Support iproute print_opt ('ip -details ...')

Axel Lin (1):
      pinctrl: abx500: Fix header file include guard

Baker Zhang (1):
      net: remove outdated comment for ipv4 and ipv6 protocol handler

Balaji T K (2):
      ARM: dts: omap4-panda-common: Fix pin muxing for wl12xx
      ARM: dts: omap4-sdp: Fix pin muxing for wl12xx

Bjørn Mork (1):
      cpufreq: fix garbage kobjects on errors during suspend/resume

Bo Shen (2):
      ASoC: atmel: sam9x5_wm8731: fix oops when unload module
      ASoC: wm8731: fix dsp mode configuration

Bockholdt Arne (1):
      intel_idle: Fixed C6 state on Avoton/Rangeley processors

Brent Taylor (1):
      ARM: at91: fixed unresolved symbol "at91_pm_set_standby" when
built without CONFIG_PM

Chang Xiangzhong (1):
      net: sctp: find the correct highest_new_tsn in sack

Chanwoo Choi (1):
      hwmon: ntc_thermistor: Fix typo (pullup-uV -> pullup-uv)

Charles Keepax (2):
      ASoC: wm5110: Remove output OSR and PGA volume controls
      ASoC: core: Use consistent byte ordering in snd_soc_bytes_get

Chen Gang (1):
      parisc: remove empty SERIAL_PORT_DFNS in serial.h

Chew, Chiau Ee (1):
      spi/pxa2xx: Restore private register bits.

Chris Mason (1):
      Btrfs: update the MAINTAINERS file

Christoph Paasch (1):
      ima: Do not free 'entry' before it is initialized

Dan Carpenter (6):
      pinctrl: rockchip: testing the wrong variable
      pinctrl: abx500: fix some more bitwise AND tests
      pinctrl: rockchip: missing unlock on error in rockchip_set_pull()
      ALSA: dice: fix array limits in dice_proc_read()
      net: clamp ->msg_namelen instead of returning an error
      video: vt8500: fix error handling in probe()

Dan Williams (1):
      [SCSI] libsas: fix usage of ata_tf_to_fis

Daniel Lezcano (1):
      ARM: ux500: u8500_defconfig: add missing cpuidle option

Dave Martin (1):
      ARM: 7897/1: kexec: Use the right ISA for relocate_new_kernel

David Chang (1):
      r8169: check ALDPS bit and disable it if enabled for the 8168g

David Henningsson (3):
      ALSA: hda - Add mono speaker quirk for Dell Inspiron 5439
      ALSA: hda - Fix headset mic input after muted internal mic (Dell/Realtek)
      ALSA: hda - Fix missing ELD info when using jackpoll_ms parameter

David S. Miller (2):
      Revert "be2net: call napi_disable() for all event queues"
      Revert "net: smc91: fix crash regression on the versatile"

Dinh Nguyen (2):
      arm: socfpga: Enable ARM_TWD for socfpga
      arm: dts: socfpga: Change some clocks of gate-clk type to perip-clk

Dmitry Torokhov (1):
      PNP: fix restoring devices after hibernation

Enric Balletbo i Serra (7):
      ARM: dts: omap3-igep: Fix bus-width for mmc1
      ARM: dts: omap3-igep: Add support for LBEE1USJYC WiFi connected to SDIO
      ARM: dts: omap3-igep: Update to use the TI AM/DM37x processor
      ARM: dts: AM33XX BASE0033: add pinmux and hdmi node to enable display
      ARM: dts: AM33XX BASE0033: add pinmux and user led support
      ARM: dts: AM33XX BASE0033: add 32KBit EEPROM support
      ARM: dts: AM33XX IGEP0033: add USB support

Eric Dumazet (2):
      sch_tbf: handle too small burst
      inet: fix possible seqlock deadlocks

Eugenia Emantayev (1):
      net/mlx4_en: Remove selftest TX queues empty condition

Fabio Estevam (3):
      ARM: 7907/1: lib: delay-loop: Add align directive to fix
BogoMIPS calculation
      ASoC: fsl: imx-pcm-fiq: Remove unused 'runtime' variable
      Documentation: net: fsl-fec.txt: Add phy-supply entry

Felipe Pena (1):
      block: xen-blkfront: Fix possible NULL ptr dereference

Fenghua Yu (1):
      x86/apic, doc: Justification for disabling IO APIC before Local APIC

Florian Vaussard (1):
      ARM: dts: Fix the name of supplies for smsc911x shared by OMAP

Frederic Weisbecker (1):
      perf tools: Tag thread comm as overriden

Gao feng (2):
      tcp_memcg: remove useless var old_lim
      sit: use kfree_skb to replace dev_kfree_skb

Geert Uytterhoeven (3):
      genirq: Correct fuzzy and fragile IRQ_RETVAL() definition
      fbdev: sh_mobile_meram: Fix defined but not used compiler warnings
      genetlink: Fix uninitialized variable in genl_validate_assign_mc_groups()

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Gerhard Sittig (1):
      dt: binding: reword PowerPC 8xxx GPIO documentation

Gregory CLEMENT (1):
      ARM: mvebu: use the virtual CPU registers to access coherency registers

Gu Zheng (1):
      aio: clean up aio ring in the fail path

Guenter Roeck (2):
      tg3: Convert to use hwmon_device_register_with_groups
      sfc: Convert to use hwmon_device_register_with_groups

H. Peter Anvin (2):
      x86-64, build: Always pass in -mno-sse
      x86, bitops: Correct the assembly constraints to testing bitops

Hannes Frederic Sowa (3):
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and
rxpmtu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Heikki Krogerus (1):
      gpiolib: change a warning to debug message when failing to get gpio

Helge Deller (7):
      parisc: fix mmap(MAP_FIXED|MAP_SHARED) to already mmapped address
      parisc: add some more machine names to hardware database
      parisc: use kernel_text_address() in unwind functions
      parisc: fix kernel memory layout in vmlinux.ld.S
      parisc: remove CONFIG_MLONGCALLS=y from defconfigs
      parisc: update 64bit defconfigs and use SIL680 instead of SIIMAGE driver
      nfs: fix do_div() warning by instead using sector_div()

Herbert Xu (2):
      gro: Only verify TCP checksums for candidates
      gro: Clean up tcpX_gro_receive checksum verification

Holger Bechtold (1):
      can: c_can: fix calculation of transmitted bytes on tx complete

Hong Zhiguo (1):
      Update of blkg_stat and blkg_rwstat may happen in bh context.
 While u64_stats_fetch_retry is only preempt_disable on 32bit     UP
system. This is not enough to avoid preemption by bh and     may read
strange 64 bit value.

Horia Geanta (5):
      crypto: talitos - corrrectly handle zero-length assoc data
      crypto: ccm - Fix handling of zero plaintext when computing mac
      crypto: caam - fix aead sglen for case 'dst != src'
      crypto: talitos - fix aead sglen for case 'dst != src'
      crypto: testmgr - fix sglen in test_aead for case 'dst != src'

Ivan Vecera (2):
      be2net: call napi_disable() for all event queues
      be2net: call napi_disable() for all event queues

James Bottomley (1):
      [SCSI] enclosure: fix WARN_ON in dual path device removing

Jarkko Nikula (2):
      ASoC: omap: n810: Convert to clk_prepare_enable/clk_disable_unprepare
      ARM: dts: omap3-beagle: Add omap-twl4030 audio support

Jason Wang (1):
      macvtap: fix tx_dropped counting error

Javier Martinez Canillas (4):
      ARM: OMAP2+: dss-common: change IGEP's DVI DDC i2c bus
      ARM: dts: omap3-igep0020: Add pinmux setup for i2c devices
      ARM: dts: omap3-igep0020: Add pinmuxing for DVI output
      ARM: dts: omap3-igep0020: name twl4030 VPLL2 regulator as vdds_dsi

Jean-Francois Moine (2):
      ASoC: kirkwood: Fix invalid S/PDIF format
      ASoC: kirkwood: Fix erroneous double output while playing

Jeff Moyer (1):
      blk-mq: fix dereference of rq->mq_ctx if allocation fails

Jiri Pirko (1):
      team: fix master carrier set when user linkup is enabled

Joe Perches (2):
      MAINTAINERS: Update file patterns in the lockdep and scheduler entries
      timer: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Joel Fernandes (1):
      ARM: OMAP2+: Disable POSTED mode for errata i103 and i767

Johan Hovold (1):
      atmel_lcdfb: fix module autoload

Johannes Berg (1):
      genetlink/pmcraid: use proper genetlink multicast API

John Fastabend (2):
      ixgbe: ixgbe_fwd_ring_down needs to be static
      ixgbe: turn NETIF_F_HW_L2FW_DOFFLOAD off by default

Josh Boyer (1):
      arm/xen: Export phys_to_mach to fix Xen module link errors

Kailang Yang (2):
      ALSA: hda/realtek - Independent of model for HP
      ALSA: hda/realtek - remove hp_automute_hook from alc283_fixup_chromebook

Kent Overstreet (1):
      block: submit_bio_wait() conversions

Konrad Rzeszutek Wilk (1):
      cpuidle: Check for dev before deregistering it.

Kumar Gala (1):
      MAINTAINERS: Add Kumar to Device Tree Binding maintainers group

Kuninori Morimoto (1):
      ASoC: rcar: select REGMAP

Lars-Peter Clausen (2):
      ASoC: pcm: Fix rate_max calculation
      ASoC: pcm: Always honor DAI min and max sample rate constraints

Laurent Pinchart (7):
      clocksource: sh_mtu2: Release clock when sh_mtu2_register() fails
      clocksource: sh_mtu2: Add clk_prepare/unprepare support
      clocksource: sh_tmu: Release clock when sh_tmu_register() fails
      clocksource: sh_tmu: Add clk_prepare/unprepare support
      clk: exynos: Fix typos in DT bindings documentation
      sh-pfc: r8a7740: Fix pin bias setup
      sh-pfc: sh7372: Fix pin bias setup

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Torvalds (3):
      vfs: fix subtle use-after-free of pipe_inode_info
      uio: we cannot mmap unaligned page contents
      Linux 3.13-rc3

Linus Walleij (4):
      Revert "ARM: ux500: Remove AUXDATA relating to SDI (MMC)
clock-name bindings"
      Revert "ARM: ux500: Stop passing MMC's platform data for Device
Tree boots"
      net: smc91: fix crash regression on the versatile
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Ludovic Desroches (1):
      ARM: at91: sama5d3: reduce TWI internal clock frequency

Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Marc Kleine-Budde (2):
      can: c_can: don't call pm_runtime_get_sync() from interrupt context
      can: flexcan: use correct clock as base for bit rate calculation

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Mark Rustad (1):
      ixgbe: Make ixgbe_identify_qsfp_module_generic static

Mark Rutland (1):
      irqchip: Gic: fix boot for chained gics

Martin K. Petersen (1):
      [SCSI] Disable WRITE SAME for RAID and virtual host adapter drivers

Martin Schwidefsky (1):
      time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Matt Fleming (1):
      x86/efi: Fix earlyprintk off-by-one bug

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Michael Neuling (1):
      crypto: caam - Add missing Job Ring include

Michael S. Tsirkin (2):
      virtio_net: fix error handling for mergeable buffers
      virtio_net: make all RX paths handle erors consistently

Mika Westerberg (1):
      spi/pxa2xx: add new ACPI IDs

Ming Lei (1):
      blk-mq: fix use-after-free of request

Namhyung Kim (2):
      perf header: Fix bogus group name
      perf header: Fix possible memory leaks in process_group_desc()

Nicolas Dichtel (2):
      sched/doc: Fix generation of device-drivers
      diag: warn about missing first netlink attribute

Nicolas Ferre (1):
      ARM: at91: add usart3 alias to dtsi

Nikith Ganigarakoppal (4):
      [SCSI] pm80xx: Module author addition
      [SCSI] pm80xx: Fix for direct attached device.
      [SCSI] pm80xx: Resetting the phy state.
      [SCSI] pm80xx: Tasklets synchronization fix.

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value

Olof Johansson (3):
      ARM: multi_v7_defconfig: enable network for BeagleBone Black
      ARM: sunxi_defconfig: enable NFS, TMPFS, PRINTK_TIME and nfsroot support
      ARM: multi_v7_defconfig: enable SDHCI_BCM_KONA and MMC_BLOCK_MINORS=16

Oskar Schirmer (1):
      ASoC: fsl: imx-pcm-fiq: remove bogus period delta calculation

Oussama Ghorbel (1):
      sit: generate icmpv6 error when receiving icmpv4 error

Peter Ujfalusi (1):
      leds: pwm: Fix for deferred probe in DT booted mode

Peter Zijlstra (3):
      ftrace, perf: Avoid infinite event generation loop
      perf: Remove fragile swevent hlist optimization
      sched: Avoid NULL dereference on sd_busy

Phillip Lougher (1):
      Squashfs: fix failure to unlock pages on decompress error

Rajendra Nayak (1):
      ARM: OMAP2+: Powerdomain: Fix unchecked dereference of arch_pwrdm

Richard Weinberger (2):
      um: Rename print_stack_trace to do_stack_trace
      um: Build always with -mcmodel=large on 64bit

Rob Herring (1):
      dt-bindings: add ARMv8 PMU binding

Roberto Sassu (2):
      ima: store address of template_fmt_copy in a pointer before calling strsep
      ima: properly free ima_template_entry structures

Roger Quadros (1):
      ARM: dts: omap3-beagle: Fix USB host on beagle boards (for 3.13)

Russell King (4):
      ARM: dma-mapping: check DMA mask against available memory
      ARM: fix booting low-vectors machines
      ARM: footbridge: fix VGA initialisation
      ARM: footbridge: fix EBSA285 LEDs

Sasha Levin (1):
      video: kyro: fix incorrect sizes when copying to userspace

Seiji Aguchi (1):
      efivars, efi-pstore: Hold off deletion of sysfs entry until the
scan is completed

Shaohui Xie (1):
      phy: Add Vitesse 8514 phy ID

Shawn Guo (1):
      ASoC: core: fix devres parameter in devm_snd_soc_register_card()

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Shigeru Yoshida (1):
      sched: Fix a trivial typo in comments

Sourav Poddar (2):
      spi/qspi: cleanup pm_runtime error check.
      spi/qspi: Fix qspi remove path.

Sricharan R (1):
      ARM: dts: doc: Document missing binding for omap5-mpu

Srikar Dronamraju (1):
      sched: Check sched_domain before computing group power

Srinivas Pandruvada (1):
      PowerCap: Fix mode for energy counter

Stefano Stabellini (2):
      swiotlb-xen: add missing xen_dma_map_page call
      xen/arm: p2m_init and p2m_lock should be static

Stephen Boyd (1):
      clocksource: arm_arch_timer: Hide eventstream Kconfig on non-ARM

Stephen M. Cameron (2):
      [SCSI] hpsa: do not discard scsi status on aborted commands
      [SCSI] hpsa: return 0 from driver probe function on success, not 1

Stephen Warren (4):
      spi: core: invert success test in devm_spi_register_master
      ASoC: dapm: Use SND_SOC_DAPM_INIT_REG_VAL in SND_SOC_DAPM_MUX
      MAINTAINERS: remove swarren from DT bindings
      ARM: tegra: delete nvidia,tegra20-spi.txt binding

Steven Rostedt (2):
      tools lib traceevent: Fix use of multiple options in processing field
      tracing: Only run synchronize_sched() at instance deletion time

Takashi Iwai (8):
      ALSA: hda - Fix silent output on ASUS W7J laptop
      ALSA: hda - Fix bad EAPD setup for HP machines with AD1984A
      ALSA: hda - Fix complete_all() timing in deferred probes
      ALSA: atmel: Fix possible array overflow
      ALSA: hda - Another fixup for ASUS laptop with ALC660 codec
      ALSA: hda/analog - Handle inverted EAPD properly in vmaster hook
      ALSA: hda - Use always amps for auto-mute on AD1986A codec
      ALSA: hda - Fix silent output on MacBook Air 2,1

Thierry Reding (1):
      of: Add vendor prefix for LG Corporation

Thomas Gleixner (3):
      NOHZ: Check for nohz active instead of nohz enabled
      sched: Expose preempt_schedule_irq()
      nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off

Thomas Huth (1):
      virtio_net: Fixed a trivial typo (fitler --> filter)

Thomas Petazzoni (1):
      ARM: mvebu: re-enable PCIe on Armada 370 DB

Tim Gardner (1):
      xen-blkfront: Silence pfn maybe-uninitialized warning

Tom Lendacky (2):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit

Tony Lindgren (5):
      ARM: OMAP2+: Fix more missing data for omap3.dtsi file
      ARM: OMAP2+: Add fixed regulator to omap2plus_defconfig
      ARM: OMAP2+: Fix eMMC on n900 with device tree
      mmc: omap: Fix DMA configuration to not rely on device id
      mmc: omap: Fix I2C dependency and make driver usable with device tree

Tony Lu (1):
      ftrace: default to tilegx if ARCH=tile is specified

Trond Myklebust (5):
      NFS: Fix a warning in nfs_setsecurity
      NFSv4: Update list of irrecoverable errors on DELEGRETURN
      NFSv4: close needs to handle NFS4ERR_ADMIN_REVOKED
      NFSv4.1: Prevent a 3-way deadlock between layoutreturn, open and
state recovery
      MAINTAINERS: Update contact information for Trond Myklebust

Uwe Kleine-König (1):
      ARM: at91: rm9200: switch back to clockevents_config_and_register

Veaceslav Falico (1):
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Victor Kamensky (1):
      ARM: 7895/1: signal: fix armv7-m build issue in sigreturn_codes.S

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Fix crash when symb name set for offline vport

Vince Weaver (1):
      perf/trace: Properly use u64 to hold event_id

Viresh Kumar (1):
      cpufreq: suspend governors on system suspend/hibernate

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Vladimir Davydov (2):
      e1000: fix lockdep warning in e1000_reset_task
      e1000: fix possible reset_task running after adapter down

Wei Ni (1):
      of: add vendor prefix for GMT

Wei Yongjun (8):
      spi: bcm2835: fix reference leak to master in bcm2835_spi_remove()
      spi: rspi: use platform drvdata correctly in rspi_remove()
      spi: mpc512x: fix reference leak to master in mpc512x_psc_spi_do_remove()
      spi: txx9: fix reference leak to master in txx9spi_remove()
      spi: bcm63xx: fix reference leak to master in bcm63xx_spi_remove()
      spi: spi-mxs: fix reference leak to master in mxs_spi_remove()
      spi/qspi: set correct platform drvdata in ti_qspi_probe()
      ASoC: fsl: set correct platform drvdata in pcm030_fabric_probe()

Xufeng Zhang (1):
      sctp: Restore 'resent' bit to avoid retransmitted chunks for RTT
measurements

Yang Yingliang (1):
      net: 8139cp: fix a BUG_ON triggered by wrong bytes_compl

dingtianhong (1):
      bonding: disable arp and enable mii monitoring when bond change
to no uses arp mode

fan.du (1):
      {pktgen, xfrm} Update IPv4 header total len and checksum after
tranformation

françois romieu (1):
      via-velocity: fix netif_receive_skb use in irq disabled section.

stephen hemminger (3):
      netem: missing break in ge loss generator
      netem: fix loss 4 state model
      netem: fix gemodel loss generator

yzhu1 (1):
      e1000: prevent oops when adapter is being closed and reset simultaneously
