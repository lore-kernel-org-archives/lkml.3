Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3CXPhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:37:33 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:36042 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab3CXPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:37:28 -0400
Message-ID: <514F1D9E.8020601@blueyonder.co.uk>
Date: Sun, 24 Mar 2013 15:37:02 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.9-rc4 Makefile EXTRAVERSION still -rc3
References: <514EFC08.1000509@blueyonder.co.uk> <CAMuHMdXyn+rCkBJg29CFW-kzCM+AbvhsEVfNueXXfyFs8FFqtg@mail.gmail.com>
In-Reply-To: <CAMuHMdXyn+rCkBJg29CFW-kzCM+AbvhsEVfNueXXfyFs8FFqtg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=8gK0viZu5AQA:10 a=KIrl3I8d7sUA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=a5Gf7U6LAAAA:8 a=Z4Rwk6OoAAAA:8 a=tBb2bbeoAAAA:8 a=NEAV23lmAAAA:8 a=1HGq2C2bsvBZu-GZ-XYA:9 a=wPNLvfGTeEIA:10 a=yHIqe9kG5mgA:10 a=jbrJJM5MRmoA:10 a=YuKU6ANggZ8A:10 a=ayzni6dBcwswsuFb:21 a=l4hO5Etv8UOAYAVD:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/13 13:49, Geert Uytterhoeven wrote:
> On Sun, Mar 24, 2013 at 2:13 PM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
>> Using git pull or git clone this field in the Makefile remains unchanged.
> Not for me:
>
> $ git show v3.9-rc4
> tag v3.9-rc4
> Tagger: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Mar 23 16:52:52 2013 -0700
>
> Linux 3.9-rc4
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.19 (GNU/Linux)
>
> iQEcBAABAgAGBQJRTkBaAAoJEHm+PkMAQRiGnK8H/iAtbU3o8th651xsVY/X1lTy
> uzFmZpfjwfM+OB5n69qcZL+V9I0b54ZKOa98OAtWlMPXifTWdznDNStqvQeRmodr
> Eet/W9MwgsaBDw+/vaJKuBf5ny3msayPSA1jkVAjb1VfpheH5zvLXNo1857FoSfi
> cl9jrD3tIrM6EmNwR+EWANjb1xYtJfnbtnF6xHpcEG64bcidEv8ZC7V48KNL16Dt
> Duy5+ZIsGoHsMj45y35KP032NtBpPvCmmXOjkO8fwwAwK+IvyivKJFfo3UlvmVdr
> seHQ5RgI/g0SCupLx6N4fBUNfYi/7yNn/ZAiNO06g0ErmOSs38KlRFDg63tLZ+g=
> =yJhy
> -----END PGP SIGNATURE-----
>
> commit 8bb9660418e05bb1845ac1a2428444d78e322cc7
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Mar 23 16:52:44 2013 -0700
>
>      Linux 3.9-rc4
>
> diff --git a/Makefile b/Makefile
> index 22113a7..54d2b2a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>   VERSION = 3
>   PATCHLEVEL = 9
>   SUBLEVEL = 0
> -EXTRAVERSION = -rc3
> +EXTRAVERSION = -rc4
>   NAME = Unicycling Gorilla
>
>   # *DOCUMENTATION*
> $
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>
This is from a fresh clone done today at 04:38.
tindog:/usr/src/XXX/linux # git branch
* master
tindog:/usr/src/XXX/linux # git pull
Already up-to-date.
tindog:/usr/src/XXX/linux # git show v3.9-rc4
fatal: ambiguous argument 'v3.9-rc4': unknown revision or path not in 
the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'

tag v3.9-rc3
Tagger: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Mar 17 15:59:39 2013 -0700

Linux 3.9-rc3
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRRkrbAAoJEHm+PkMAQRiGy3oH/jrbHinYs0auurANgx4TdtWT
/WNajstKBqLOJJ6cnTR7sOqwOVlptt65EbbTs+qGyZ2Z2W/Lg0BMenHvNHo4ER8C
e7UbMdBCSLKBjAMKh1XCoZscGv4Exm8WRH3Vc5yP0Hafj3EzSAVLY1dta9WKKoQi
bh7D1ErUlbU1zczA1w5YbPF0LqFKRvyZOwebMCCAKAxv5wWAxmbcPNxVR4sufkjg
k6TkQ2ysgWivZAfy3tJYOcxiEu7ahpZVEuYdlZEJQXHRQUfoNljQlOp4BqKsYUai
5A0kaf2VpKay/7pkhvTfBBcF/jFJ68pYP6gQ2ThNdr0b5kOiAfMWj030Xyngnhg=
=iO9t
-----END PGP SIGNATURE-----

commit a937536b868b8369b98967929045f1df54234323
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Mar 17 15:59:32 2013 -0700

     Linux 3.9-rc3

diff --git a/Makefile b/Makefile
index a05ea42..22113a7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
  VERSION = 3
  PATCHLEVEL = 9
  SUBLEVEL = 0
-EXTRAVERSION = -rc2
+EXTRAVERSION = -rc3
  NAME = Unicycling Gorilla

  # *DOCUMENTATION*

The previous tree which I used to build the running 3.9.0-rc3, when 
upgraded stays at 3.9.0-rc3.

This from box number 4 with a git pull. Exactly the same on 5 boxes, 2 
with Kubuntu 12.10 and 3 with openSUSE 13.1 Milestone 0, all running 
3.9.0-rc3.
root@sdrbox:/usr/src/XXX/linux# uname -r
3.9.0-rc3+
root@sdrbox:/usr/src/XXX/linux# git pull
remote: Counting objects: 3135, done.
remote: Compressing objects: 100% (476/476), done.
remote: Total 2111 (delta 1732), reused 2003 (delta 1631)
Receiving objects: 100% (2111/2111), 365.49 KiB | 235 KiB/s, done.
Resolving deltas: 100% (1732/1732), completed with 534 local objects.
 From https://github.com/torvalds/linux
    a937536..c8c1f16  master     -> origin/master
Updating a937536..c8c1f16
Fast-forward
  CREDITS                                             |    8 ++++++++
  Documentation/hwmon/lm75                            |    2 +-
  Documentation/i2c/busses/i2c-diolan-u2c             |    2 +-
  Documentation/sound/alsa/ALSA-Configuration.txt     |    2 +-
  Documentation/sound/alsa/seq_oss.html               |    2 +-
  MAINTAINERS                                         |   33 
+++++++++++++++++----------------
  arch/arm/Kconfig                                    |   11 ++++-------
  arch/arm/boot/dts/at91sam9x5.dtsi                   |   28 
++++++++++++++++++++++++++--
  arch/arm/boot/dts/exynos4.dtsi                      |    9 +++++++++
  arch/arm/boot/dts/exynos5440.dtsi                   |    6 ++++++
  arch/arm/kernel/smp.c                               |    2 +-
  arch/arm/lib/memset.S                               |   33 
+++++++++++++--------------------
  arch/arm/mach-at91/include/mach/gpio.h              |    8 ++++++++
  arch/arm/mach-at91/irq.c                            |   20 
++++++++------------
  arch/arm/mach-at91/pm.c                             |   10 ++++++++--
  arch/arm/mach-davinci/dma.c                         |    3 +++
  arch/arm/mach-footbridge/Kconfig                    |    1 +
  arch/arm/mach-imx/clk-imx35.c                       |    1 +
  arch/arm/mach-imx/imx25-dt.c                        |    5 +++++
  arch/arm/mach-mmp/gplugd.c                          |    1 +
  arch/arm/mach-s5pv210/clock.c                       |   36 
++++++++++++++++++------------------
  arch/arm/mach-s5pv210/mach-goni.c                   |    2 +-
  arch/arm/mach-shmobile/board-marzen.c               |    1 +
  arch/arm/net/bpf_jit_32.c                           |    2 +-
  arch/arm64/Kconfig                                  |    1 -
  arch/arm64/Kconfig.debug                            |   11 -----------
  arch/arm64/configs/defconfig                        |    1 -
  arch/arm64/include/asm/ucontext.h                   |    2 +-
  arch/arm64/kernel/arm64ksyms.c                      |    2 ++
  arch/arm64/kernel/signal32.c                        |    1 -
  arch/powerpc/Kconfig                                |    1 +
  arch/powerpc/include/asm/mmu-hash64.h               |  128 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------
  arch/powerpc/kernel/cputable.c                      |    2 +-
  arch/powerpc/kernel/exceptions-64s.S                |   34 
+++++++++++++++++++++++++---------
  arch/powerpc/kernel/prom_init.c                     |   14 +++++++-------
  arch/powerpc/kernel/ptrace.c                        |    1 +
  arch/powerpc/kvm/book3s_64_mmu_host.c               |    4 ++--
  arch/powerpc/mm/hash_utils_64.c                     |   22 
+++++++++++++++++-----
  arch/powerpc/mm/mmu_context_hash64.c                |   11 +----------
  arch/powerpc/mm/pgtable_64.c                        |    2 +-
  arch/powerpc/mm/slb_low.S                           |   50 
+++++++++++++++++++++++++-------------------------
  arch/powerpc/mm/tlb_hash64.c                        |    2 +-
  arch/powerpc/perf/power7-pmu.c                      |   13 +++++++++++++
  arch/powerpc/platforms/85xx/sgy_cts1000.c           |    6 +++---
  arch/powerpc/platforms/Kconfig.cputype              |    6 ++----
  arch/s390/include/asm/eadm.h                        |    6 +++++-
  arch/s390/include/asm/tlbflush.h                    |    2 --
  arch/s390/kernel/entry.S                            |    3 ++-
  arch/s390/kernel/entry64.S                          |    5 +++--
  arch/s390/kernel/setup.c                            |    2 ++
  arch/sparc/Kconfig                                  |    8 +-------
  arch/sparc/include/asm/spitfire.h                   |    1 +
  arch/sparc/kernel/cpu.c                             |    6 ++++++
  arch/sparc/kernel/head_64.S                         |   25 
+++++++++++++++++++++++--
  arch/sparc/kernel/leon_pci_grpci2.c                 |   41 
++++++++++++++++++++++++++---------------
  arch/x86/include/asm/kprobes.h                      |    1 +
  arch/x86/include/asm/kvm_host.h                     |    4 ++--
  arch/x86/kernel/cpu/perf_event_intel.c              |    4 ++++
  arch/x86/kernel/kprobes/core.c                      |    5 ++++-
  arch/x86/kvm/x86.c                                  |   64 
+++++++++++++++++++++++++++++++---------------------------------
  drivers/amba/tegra-ahb.c                            |    2 +-
  drivers/ata/Kconfig                                 |   13 +++++++------
  drivers/ata/ahci.c                                  |    2 ++
  drivers/ata/ata_piix.c                              |    4 ++++
  drivers/ata/libata-acpi.c                           |    2 +-
  drivers/ata/pata_samsung_cf.c                       |   13 +------------
  drivers/ata/sata_fsl.c                              |    3 +--
  drivers/block/nvme.c                                |   33 
++++++++++++++++++++++++---------
  drivers/bluetooth/ath3k.c                           |    4 ++++
  drivers/bluetooth/btusb.c                           |    2 ++
  drivers/clk/clk-vt8500.c                            |    2 +-
  drivers/edac/amd64_edac.c                           |   15 +++++++++------
  drivers/edac/edac_mc.c                              |    6 +++---
  drivers/edac/edac_mc_sysfs.c                        |   17 
+++++------------
  drivers/gpu/drm/drm_edid.c                          |    3 ++-
  drivers/gpu/drm/i915/i915_debugfs.c                 |    2 +-
  drivers/gpu/drm/i915/i915_gem_execbuffer.c          |   11 ++++++++---
  drivers/gpu/drm/i915/intel_dp.c                     |   14 ++++++++++++--
  drivers/gpu/drm/i915/intel_i2c.c                    |   11 ++++++++++-
  drivers/gpu/drm/mgag200/mgag200_mode.c              |   10 +++++-----
  drivers/gpu/drm/nouveau/core/core/object.c          |    3 +--
  drivers/gpu/drm/nouveau/core/include/subdev/therm.h |    2 +-
  drivers/gpu/drm/nouveau/core/subdev/therm/base.c    |   18 
++++++++++++------
  drivers/gpu/drm/nouveau/core/subdev/therm/ic.c      |    6 ++++--
  drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c    |   67 
++++++++++++++++++++++++++++++++++++++++++++++++-------------------
  drivers/gpu/drm/nouveau/core/subdev/therm/priv.h    |    3 ++-
  drivers/gpu/drm/nouveau/core/subdev/therm/temp.c    |   30 
++++++++++++++++--------------
  drivers/gpu/drm/nouveau/nouveau_pm.c                |   44 
+++++++++++++++++++++++++++++++-------------
  drivers/gpu/drm/nouveau/nv50_display.c              |    4 ++--
  drivers/gpu/drm/radeon/ni.c                         |   33 
+++++++++++++++++++++++++++------
  drivers/gpu/drm/radeon/radeon_benchmark.c           |   21 
++++++++++-----------
  drivers/gpu/drm/radeon/si.c                         |    1 +
  drivers/hwmon/lm75.h                                |    2 +-
  drivers/i2c/Kconfig                                 |    2 +-
  drivers/i2c/busses/Kconfig                          |    6 ++++--
  drivers/i2c/busses/i2c-ismt.c                       |    2 ++
  drivers/i2c/busses/i2c-tegra.c                      |   13 +++++++++++--
  drivers/i2c/muxes/i2c-mux-pca9541.c                 |    2 +-
  drivers/infiniband/hw/cxgb4/cm.c                    |   12 ++++++++++++
  drivers/input/joystick/analog.c                     |    8 ++------
  drivers/isdn/hisax/Kconfig                          |    6 ++++--
  drivers/md/dm-bufio.c                               |    2 ++
  drivers/md/dm-cache-metadata.c                      |   64 
+++++++++++++++++++++++++++++++++++++++++++++++++++-------------
  drivers/md/dm-cache-metadata.h                      |    2 +-
  drivers/md/dm-cache-policy-cleaner.c                |    7 +++++--
  drivers/md/dm-cache-policy-internal.h               |    2 ++
  drivers/md/dm-cache-policy-mq.c                     |    8 ++++++--
  drivers/md/dm-cache-policy.c                        |    8 ++++++++
  drivers/md/dm-cache-policy.h                        |    2 ++
  drivers/md/dm-cache-target.c                        |  169 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
  drivers/md/dm-thin.c                                |   11 ++++++++---
  drivers/md/dm-verity.c                              |   39 
++++++++++++++++++++++++++++++++++-----
  drivers/md/persistent-data/dm-btree-remove.c        |   46 
++++++++++++++++++++++++----------------------
  drivers/mtd/bcm47xxpart.c                           |   52 
+++++++++++++++++++++++++++++++++-------------------
  drivers/mtd/nand/nand_base.c                        |   16 
++++++++++++++++
  drivers/mtd/nand/nand_ids.c                         |   80 
++++++++++++++++++++++++++++++++++++++++---------------------------------------
  drivers/net/bonding/bond_main.c                     |    6 ++----
  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c     |    1 +
  drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h   |    3 ++-
  drivers/net/ethernet/broadcom/tg3.c                 |    8 ++++++++
  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c          |   12 +++++++++---
  drivers/net/ethernet/dec/tulip/Kconfig              |    1 +
  drivers/net/ethernet/freescale/fec.c                |   27 
++++++++++++++++-----------
  drivers/net/ethernet/freescale/fec.h                |    1 +
  drivers/net/ethernet/sfc/nic.c                      |    3 ++-
  drivers/net/ethernet/ti/cpsw.c                      |    2 +-
  drivers/net/ethernet/ti/davinci_emac.c              |    2 +-
  drivers/net/netconsole.c                            |   15 +++++++++------
  drivers/net/usb/Kconfig                             |    2 +-
  drivers/net/usb/cdc_mbim.c                          |   11 +----------
  drivers/net/usb/cdc_ncm.c                           |   49 
++++++++++++++++++++++++++++++++-----------------
  drivers/net/usb/qmi_wwan.c                          |   49 
++++++++++++++++---------------------------------
  drivers/net/wireless/mwifiex/join.c                 |    7 +++----
  drivers/net/wireless/rt2x00/Kconfig                 |    4 ++--
  drivers/net/wireless/rt2x00/rt2800pci.c             |   14 +++++++-------
  drivers/net/wireless/rtlwifi/rtl8192cu/hw.c         |   89 
+++++++++++++++++++++++++++++++++++-----------------------------------------------------
  drivers/pci/rom.c                                   |   55 
+++++++++++++++++++++++++++++++++++--------------------
  drivers/pinctrl/pinctrl-at91.c                      |   61 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
  drivers/rtc/rtc-at91rm9200.c                        |   50 
+++++++++++++++++++++++++++++++-------------------
  drivers/rtc/rtc-at91rm9200.h                        |    1 -
  drivers/rtc/rtc-da9052.c                            |    8 +++-----
  drivers/s390/block/scm_blk.c                        |   69 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
  drivers/s390/block/scm_blk.h                        |    2 ++
  drivers/s390/block/scm_drv.c                        |   23 
+++++++++++++++++------
  drivers/s390/char/sclp_cmd.c                        |    2 ++
  drivers/s390/cio/chsc.c                             |   17 
+++++++++++++++++
  drivers/s390/cio/chsc.h                             |    2 ++
  drivers/s390/cio/scm.c                              |   18 
+++++++++++++++++-
  drivers/s390/net/qeth_core.h                        |    1 +
  drivers/s390/net/qeth_core_main.c                   |   45 
++++++++++++++++++++++++++++++++++++++-------
  drivers/s390/net/qeth_l3_main.c                     |   23 
+++++++++++++++--------
  drivers/s390/net/qeth_l3_sys.c                      |    2 ++
  drivers/thermal/dove_thermal.c                      |   16 
++++++----------
  drivers/thermal/exynos_thermal.c                    |    2 +-
  drivers/thermal/kirkwood_thermal.c                  |    8 +++-----
  drivers/thermal/rcar_thermal.c                      |   29 
++++++++++++++---------------
  drivers/tty/serial/sunsu.c                          |   21 
+++++++++------------
  drivers/usb/class/cdc-acm.c                         |   22 
+++++++++++++++++++---
  drivers/usb/core/hcd-pci.c                          |   23 
++++++++++++++---------
  drivers/usb/gadget/f_rndis.c                        |    3 +--
  drivers/usb/gadget/g_ffs.c                          |    4 ++--
  drivers/usb/gadget/net2272.c                        |    9 ++++++++-
  drivers/usb/gadget/net2280.c                        |    8 +++++++-
  drivers/usb/gadget/u_serial.c                       |    2 +-
  drivers/usb/gadget/udc-core.c                       |    2 +-
  drivers/usb/host/ehci-hcd.c                         |    1 +
  drivers/usb/host/ehci-hub.c                         |    2 +-
  drivers/usb/host/ehci-q.c                           |   13 +++++++++++++
  drivers/usb/host/ehci-timer.c                       |    2 +-
  drivers/usb/host/xhci.c                             |    3 ++-
  drivers/usb/host/xhci.h                             |    4 ++--
  drivers/usb/musb/da8xx.c                            |    2 +-
  drivers/usb/musb/musb_gadget.c                      |    9 +++++++--
  drivers/usb/serial/ark3116.c                        |   10 ++++++----
  drivers/usb/serial/ch341.c                          |   11 ++++++-----
  drivers/usb/serial/cypress_m8.c                     |   14 ++++++++------
  drivers/usb/serial/f81232.c                         |    9 +++++----
  drivers/usb/serial/ftdi_sio.c                       |   19 
++++++++-----------
  drivers/usb/serial/garmin_gps.c                     |    7 +------
  drivers/usb/serial/io_edgeport.c                    |   12 +++++++-----
  drivers/usb/serial/io_ti.c                          |   13 +++++++------
  drivers/usb/serial/mct_u232.c                       |   13 +++++++------
  drivers/usb/serial/mos7840.c                        |   16 
++++++++++------
  drivers/usb/serial/oti6858.c                        |   10 ++++++----
  drivers/usb/serial/pl2303.c                         |   11 ++++++-----
  drivers/usb/serial/quatech2.c                       |   12 +++++++-----
  drivers/usb/serial/spcp8x5.c                        |    9 +++++----
  drivers/usb/serial/ssu100.c                         |   12 +++++++-----
  drivers/usb/serial/ti_usb_3410_5052.c               |   10 ++++++----
  drivers/usb/serial/usb-serial.c                     |    3 ++-
  drivers/usb/storage/unusual_devs.h                  |    7 +++++++
  drivers/vfio/pci/vfio_pci_config.c                  |    1 +
  drivers/vfio/pci/vfio_pci_intrs.c                   |    1 +
  drivers/vhost/net.c                                 |    3 ++-
  drivers/video/atmel_lcdfb.c                         |   22 
+++++++++++++++-------
  drivers/video/ep93xx-fb.c                           |    1 +
  drivers/watchdog/sp5100_tco.c                       |  126 
++++++-----------------------------------------------------------------------------------------------------------------------
  drivers/watchdog/sp5100_tco.h                       |    2 +-
  fs/cifs/asn1.c                                      |   53 
+++++------------------------------------------------
  fs/cifs/cifsfs.c                                    |   24 
++++++++++++++++++++++++
  fs/cifs/cifsfs.h                                    |    4 ++++
  fs/cifs/file.c                                      |    6 +++++-
  fs/cifs/inode.c                                     |   10 ++++------
  fs/cifs/netmisc.c                                   |    2 +-
  fs/ext4/ext4.h                                      |    8 ++++----
  fs/ext4/extents.c                                   |  105 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
  fs/ext4/extents_status.c                            |  212 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
  fs/ext4/extents_status.h                            |    9 +++++++++
  fs/ext4/ialloc.c                                    |    4 ++--
  fs/ext4/inode.c                                     |  182 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
  fs/ext4/mballoc.c                                   |   23 
++++++++---------------
  fs/ext4/move_extent.c                               |   43 
+++++++++++++++++++++++++++----------------
  fs/ext4/page-io.c                                   |   12 +++++++++++-
  fs/ext4/resize.c                                    |    4 ++--
  fs/ext4/super.c                                     |    4 ++--
  fs/jbd2/transaction.c                               |   15 ++++++++++-----
  fs/proc/inode.c                                     |    6 +++---
  fs/xfs/xfs_buf.c                                    |    6 ++++++
  fs/xfs/xfs_iomap.c                                  |    4 ++--
  include/drm/drm_pciids.h                            |   13 ++++++++++++-
  include/linux/edac.h                                |    7 ++-----
  include/linux/hash.h                                |    3 ++-
  include/linux/irq_work.h                            |    2 +-
  include/linux/kernel.h                              |    1 -
  include/linux/mmzone.h                              |    2 +-
  include/linux/mtd/nand.h                            |    7 +++++++
  include/linux/nvme.h                                |   28 
++++++++++++++++++++++++++++
  include/linux/printk.h                              |    6 ++++++
  include/linux/skbuff.h                              |   13 +++++++++----
  include/linux/usb/cdc_ncm.h                         |    1 +
  include/linux/usb/serial.h                          |    2 ++
  include/linux/usb/ulpi.h                            |    8 ++++++++
  include/net/dst.h                                   |    6 ++++--
  include/net/inet_frag.h                             |    9 +++++++++
  include/net/ip_fib.h                                |   12 +++++-------
  include/video/atmel_lcdc.h                          |    2 +-
  ipc/mqueue.c                                        |    3 ++-
  kernel/events/core.c                                |    8 ++++++--
  kernel/printk.c                                     |   80 
+++++++++++++++++++++++++++++++++++++++----------------------------------------
  kernel/sys.c                                        |   57 
++++++++++++++++++++++++++++++++-------------------------
  kernel/trace/ftrace.c                               |    4 ++--
  kernel/trace/trace.c                                |   59 
+++++++++++++++++++++++++++++++++++++++++++++++------------
  kernel/trace/trace.h                                |    6 ++++++
  kernel/trace/trace_irqsoff.c                        |   19 
++++++++++++++-----
  kernel/trace/trace_sched_wakeup.c                   |   18 
+++++++++++++-----
  kernel/workqueue.c                                  |   44 
+++++++++++++++++++++++++-------------------
  lib/bust_spinlocks.c                                |    3 +--
  lib/dma-debug.c                                     |   45 
+++++++++++++++++++++++++++++++--------------
  mm/hugetlb.c                                        |    8 ++++++--
  mm/memory_hotplug.c                                 |    6 +++++-
  net/batman-adv/bat_iv_ogm.c                         |    6 +++---
  net/bridge/br_netlink.c                             |    2 ++
  net/core/dev.c                                      |    2 +-
  net/core/rtnetlink.c                                |    2 +-
  net/ipv4/inet_fragment.c                            |   20 
+++++++++++++++++++-
  net/ipv4/ip_fragment.c                              |   11 ++++-------
  net/ipv4/ip_gre.c                                   |    5 +----
  net/ipv4/ip_options.c                               |    5 +----
  net/ipv4/tcp.c                                      |    2 +-
  net/ipv4/tcp_ipv4.c                                 |   14 +++++++-------
  net/ipv4/tcp_output.c                               |    1 -
  net/ipv6/netfilter/nf_conntrack_reasm.c             |   12 ++++++------
  net/ipv6/reassembly.c                               |    8 ++++++--
  net/ipv6/tcp_ipv6.c                                 |    7 +++++++
  net/nfc/llcp/llcp.c                                 |   62 
+++++++++++++++++++++++++++++++++++++++++++++++++++++---------
  net/nfc/llcp/sock.c                                 |    2 ++
  net/openvswitch/actions.c                           |    4 ++--
  net/openvswitch/datapath.c                          |    3 +++
  net/openvswitch/flow.c                              |    6 +++++-
  net/openvswitch/vport-netdev.c                      |    3 +--
  net/openvswitch/vport.c                             |    3 +--
  net/sctp/associola.c                                |    2 +-
  net/sctp/sm_statefuns.c                             |    2 +-
  security/selinux/xfrm.c                             |    2 +-
  sound/pci/hda/hda_codec.c                           |    2 +-
  sound/pci/hda/hda_generic.c                         |   46 
++++++++++++++++++++++++++++++++++++++++++++++
  sound/pci/hda/hda_intel.c                           |  132 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
  sound/pci/hda/patch_cirrus.c                        |    4 ++--
  sound/pci/hda/patch_conexant.c                      |   16 
+++++++++++-----
  sound/usb/mixer.c                                   |   21 
+++++++++++++--------
  tools/lib/traceevent/Makefile                       |    2 +-
  tools/perf/Makefile                                 |    8 +++++++-
  tools/perf/bench/bench.h                            |   24 
++++++++++++++++++++++++
  tools/perf/builtin-record.c                         |    6 ++++--
  tools/perf/util/hist.h                              |    5 +++--
  tools/perf/util/strlist.c                           |    2 +-
  virt/kvm/ioapic.c                                   |    7 +++++--
  287 files changed, 3045 insertions(+), 1539 deletions(-)
root@sdrbox:/usr/src/XXX/linux#

sabre:/usr/src/XXX/linux # uname -r
3.9.0-rc3-smp
sabre:/usr/src/XXX/linux # git pull
remote: Counting objects: 3135, done.
remote: Compressing objects: 100% (476/476), done.
remote: Total 2111 (delta 1732), reused 2003 (delta 1631)
Receiving objects: 100% (2111/2111), 365.49 KiB | 347 KiB/s, done.
Resolving deltas: 100% (1732/1732), completed with 534 local objects.
 From https://github.com/torvalds/linux
    a937536..c8c1f16  master     -> origin/master
Updating a937536..c8c1f16
Fast-forward
  CREDITS                                             |   8 ++++++++
  Documentation/hwmon/lm75                            |   2 +-
  Documentation/i2c/busses/i2c-diolan-u2c             |   2 +-
  Documentation/sound/alsa/ALSA-Configuration.txt     |   2 +-
  Documentation/sound/alsa/seq_oss.html               |   2 +-
  MAINTAINERS                                         |  33 
+++++++++++++++++----------------
  arch/arm/Kconfig                                    |  11 ++++-------

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

