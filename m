Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaCaSmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:42:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaCaSmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:42:00 -0400
Date: Mon, 31 Mar 2014 11:44:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.8
Message-ID: <20140331184419.GA3465@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.13.8 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 arch/arm/mm/init.c                        |    3=20
 arch/mips/include/asm/syscall.h           |    2=20
 arch/powerpc/include/asm/eeh.h            |   10 +
 arch/powerpc/kernel/eeh_driver.c          |  150 ++++++++-------
 arch/powerpc/platforms/powernv/eeh-ioda.c |  283 +++++++------------------=
-----
 arch/powerpc/platforms/powernv/pci.c      |  226 +++++++++++++++++------
 arch/powerpc/platforms/powernv/pci.h      |    3=20
 arch/x86/kvm/mmu.c                        |   12 +
 arch/x86/kvm/paging_tmpl.h                |    8=20
 arch/x86/kvm/vmx.c                        |    2=20
 arch/x86/net/bpf_jit.S                    |    2=20
 drivers/clocksource/vf_pit_timer.c        |    2=20
 drivers/gpu/drm/i915/i915_gem_stolen.c    |    7=20
 drivers/gpu/drm/i915/i915_irq.c           |   18 -
 drivers/gpu/drm/i915/intel_dp.c           |    2=20
 drivers/hid/hidraw.c                      |    4=20
 drivers/input/mouse/elantech.c            |   45 ++++
 drivers/input/tablet/wacom_sys.c          |   23 ++
 drivers/input/tablet/wacom_wac.c          |   89 +++++++--
 drivers/input/tablet/wacom_wac.h          |    7=20
 drivers/media/pci/cx18/cx18-driver.c      |    5=20
 drivers/media/usb/dvb-usb/cxusb.c         |   21 +-
 drivers/media/usb/dvb-usb/dw2102.c        |   52 +++--
 drivers/mmc/card/queue.c                  |    2=20
 drivers/net/ethernet/intel/e100.c         |    2=20
 drivers/net/ethernet/sfc/efx.h            |    3=20
 drivers/net/ethernet/sfc/ethtool.c        |    4=20
 drivers/net/ethernet/ti/davinci_emac.c    |   25 ++
 drivers/net/wireless/p54/txrx.c           |    2=20
 drivers/regulator/core.c                  |   34 +--
 drivers/scsi/scsi_lib.c                   |    2=20
 drivers/usb/host/xhci-pci.c               |    5=20
 fs/nfs/internal.h                         |    3=20
 fs/nfs/nfs4client.c                       |    7=20
 fs/nfs/nfs4namespace.c                    |   12 -
 fs/proc/proc_devtree.c                    |    1=20
 include/linux/ceph/messenger.h            |    2=20
 include/linux/ceph/osd_client.h           |    1=20
 include/linux/ftrace_event.h              |    4=20
 include/trace/ftrace.h                    |    7=20
 kernel/printk/printk.c                    |    2=20
 kernel/stop_machine.c                     |    2=20
 kernel/trace/trace_events.c               |    6=20
 kernel/trace/trace_export.c               |    7=20
 lib/fonts/Kconfig                         |    6=20
 net/ceph/messenger.c                      |    7=20
 net/ceph/mon_client.c                     |    8=20
 net/ceph/osd_client.c                     |   66 +++++-
 net/sunrpc/auth_gss/auth_gss.c            |    4=20
 scripts/package/builddeb                  |   13 -
 sound/core/compress_offload.c             |    2=20
 sound/soc/codecs/max98090.c               |    1=20
 tools/perf/perf.h                         |    4=20
 54 files changed, 712 insertions(+), 510 deletions(-)

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Ben Hutchings (3):
      sfc: Use the correct maximum TX DMA ring size for SFC9100
      deb-pkg: Fix building for MIPS big-endian or ARM OABI
      deb-pkg: Fix cross-building linux-headers package

Ben Peddell (1):
      ARM: 7941/2: Fix incorrect FDT initrd parameter override

Ben Widawsky (1):
      drm/i915: Fix PSR programming

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Chris Wilson (1):
      drm/i915: Disable stolen memory when DMAR is active

Christian Riesch (1):
      net: davinci_emac: Replace devm_request_irq with request_irq

Dan Carpenter (4):
      media: cxusb: unlock on error in cxusb_i2c_xfer()
      media: dw2102: some missing unlocks on error
      media: cx18: check for allocation failure in cx18_read_eeprom()
      p54: clamp properly instead of just truncating

Daniel Vetter (1):
      drm/i915: Don't enable display error interrupts from the start

Dave Jones (1):
      fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfi=
rmware exists.

Fernando Luis Vazquez Cao (1):
      HID: hidraw: fix warning destroying hidraw device files after parent

Gavin Shan (4):
      powerpc/powernv: Move PHB-diag dump functions around
      powerpc/eeh: Handle multiple EEH errors
      powerpc/powernv: Dump PHB diag-data immediately
      powerpc/powernv: Refactor PHB diag-data dump

Greg Kroah-Hartman (1):
      Linux 3.13.8

Guenter Roeck (1):
      MIPS: Fix build error seen in some configurations

Hans de Goede (1):
      Input: elantech - improve clickpad detection

Helge Deller (1):
      partly revert commit 8a10bc9: parisc/sti_console: prefer Linux fonts =
over built-in ROM fonts

Ilya Dryomov (3):
      libceph: rename ceph_msg::front_max to front_alloc_len
      libceph: rename front to front_len in get_reply()
      libceph: fix preallocation check in get_reply()

Josh Durgin (2):
      libceph: block I/O when PAUSE or FULL osd map flags are set
      libceph: resend all writes after the osdmap loses the full flag

Linus Torvalds (1):
      printk: fix syslog() overflowing user buffer

Marcelo Tosatti (3):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: x86: handle invalid root_hpa everywhere
      KVM: VMX: fix use after free of vmx->loaded_vmcs

Markus Pargmann (1):
      regulator: core: Replace direct ops->disable usage

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Peter Zijlstra (2):
      stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()
      perf tools: Fix AAAAARGH64 memory barriers

Ping Cheng (3):
      Input: wacom - make sure touch_max is set for touch devices
      Input: wacom - add support for three new Intuos devices
      Input: wacom - add reporting of SW_MUTE_DEVICE events

Russell King (1):
      Fix uses of dma_max_pfn() when converting to a limiting address

Sarah Sharp (1):
      xhci: Fix resume issues on Renesas chips in Samsung laptops

Stefan Agner (1):
      clocksource: vf_pit_timer: use complement for sched_clock reading

Stephen Warren (1):
      ASoC: max98090: make REVISION_ID readable

Trond Myklebust (2):
      NFSv4: Use the correct net namespace in nfs4_update_server
      SUNRPC: Fix a pipe_version reference leak

Vaibhav Nagarnaik (1):
      tracing: Fix array size mismatch in format string


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTObeDAAoJEDjbvchgkmk+3IQP/0pSyb3nN9Uauop8br8iBZ7b
NL6UFhZyPnHca88tqxbP49GQEys1AZ9DF6qSnVfKLrCRVrZk4lfHHuUuJh/1E9AY
CT5QP5F4FqL1aKxKFYNmiPkHIc0sgteCOSCPWKl7Rz28h1BzH6eRk7ADiXTYohjN
6NL98JxxsaRLvhkGX3ST2o79uj4tUzdLIbwGPdyPJM6sBi2jXUCdmJ9WqIiGTKfr
EeDvcNe1OLk7HqLYWeJ3Tsi2OOmCOwkT2GxWBNYTlF8zjXMCww8O1HEMWg5cWqXy
B+HILCfLmxq1QMDagMw3eQs04nQKwaYgQkDkK0O1kRHmEictW0g7sHVewYjMbC1W
XzeAoPFeuNJT1JGsfLmMd2Vqf1mRLTL93N90OCm269COzkInsCK7bNiedkUTbT4m
1TupffhImSdgbGzjE5agY7P4+PYmHFXJWWcocHjhYxYNSIZVQIUbg7GxKeYEQx+y
RmpDH+DpTOMRXBP8poaXJz43q9HGh9pCNfHEWMfoUTvMTzlI4Qu1Ih0EfDB5omfQ
kHA47QEyeNaTgGTCeIS12WM0E2p5WDct9NwwLLmklxI7UTySrJRbjk4dKQYH9+cx
mHwWQ35wEAtDjsG5nEo7Rzs6C/zvLck+6bVf7s+1/y9OfXt41I9oxDH8EbLQIPdn
sf8MwSLPCtl7ok79KEjq
=YZwm
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
