Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3EKVq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:46:26 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:40214 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3EKVqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:46:22 -0400
Date: Sat, 11 May 2013 14:46:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.2
Message-ID: <20130511214633.GA19773@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.2 kernel.

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

 Makefile                                      |    2=20
 arch/arm/xen/enlighten.c                      |    2=20
 arch/arm64/mm/fault.c                         |    3=20
 arch/powerpc/include/asm/ppc-opcode.h         |    4=20
 arch/powerpc/kernel/traps.c                   |   10 +-
 arch/powerpc/mm/hash_utils_64.c               |    1=20
 arch/powerpc/mm/numa.c                        |    2=20
 arch/x86/kernel/cpu/perf_event_intel.c        |   13 ++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c    |   27 +++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   17 ++-
 block/blk-cgroup.c                            |    4=20
 drivers/edac/edac_mc_sysfs.c                  |   12 +-
 drivers/gpu/drm/ast/ast_drv.h                 |    2=20
 drivers/gpu/drm/ast/ast_fb.c                  |   43 +++++++++-
 drivers/gpu/drm/ast/ast_ttm.c                 |    2=20
 drivers/gpu/drm/cirrus/cirrus_drv.h           |    2=20
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |   38 ++++++++
 drivers/gpu/drm/cirrus/cirrus_ttm.c           |    2=20
 drivers/gpu/drm/drm_gem.c                     |    4=20
 drivers/gpu/drm/drm_prime.c                   |   84 +++++++++++--------
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c    |    4=20
 drivers/gpu/drm/gma500/psb_irq.c              |    2=20
 drivers/gpu/drm/i915/i915_drv.h               |    1=20
 drivers/gpu/drm/i915/i915_gem.c               |   28 +++++-
 drivers/gpu/drm/i915/i915_gem_context.c       |    7 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c        |    5 -
 drivers/gpu/drm/i915/i915_gem_gtt.c           |    3=20
 drivers/gpu/drm/i915/i915_reg.h               |    2=20
 drivers/gpu/drm/i915/intel_bios.c             |    6 -
 drivers/gpu/drm/i915/intel_bios.h             |    4=20
 drivers/gpu/drm/i915/intel_display.c          |   60 ++++++++++----
 drivers/gpu/drm/i915/intel_dp.c               |    5 -
 drivers/gpu/drm/i915/intel_dvo.c              |   13 ++-
 drivers/gpu/drm/i915/intel_lvds.c             |    9 +-
 drivers/gpu/drm/i915/intel_panel.c            |    7 +
 drivers/gpu/drm/i915/intel_pm.c               |    9 +-
 drivers/gpu/drm/i915/intel_sdvo.c             |    5 -
 drivers/gpu/drm/mgag200/mgag200_drv.h         |    2=20
 drivers/gpu/drm/mgag200/mgag200_fb.c          |   43 +++++++++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c         |    4=20
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c     |    1=20
 drivers/gpu/drm/radeon/atom.c                 |    6 -
 drivers/gpu/drm/radeon/atombios_crtc.c        |    3=20
 drivers/gpu/drm/radeon/evergreen.c            |  111 +++++++++++++++++++++=
++---
 drivers/gpu/drm/radeon/evergreen_reg.h        |    2=20
 drivers/gpu/drm/radeon/ni.c                   |    8 +
 drivers/gpu/drm/radeon/nid.h                  |    4=20
 drivers/gpu/drm/radeon/r100.c                 |   77 ++++++++++++------
 drivers/gpu/drm/radeon/r500_reg.h             |    2=20
 drivers/gpu/drm/radeon/r600_hdmi.c            |    4=20
 drivers/gpu/drm/radeon/radeon_atombios.c      |   21 +++-
 drivers/gpu/drm/radeon/radeon_kms.c           |    4=20
 drivers/gpu/drm/radeon/radeon_pm.c            |    6 +
 drivers/gpu/drm/radeon/radeon_ring.c          |    3=20
 drivers/gpu/drm/radeon/rs600.c                |   52 ++++++++++--
 drivers/gpu/drm/radeon/rv515.c                |   56 ++++++++++++-
 drivers/gpu/drm/radeon/si.c                   |    3=20
 drivers/gpu/drm/radeon/sid.h                  |    2=20
 drivers/gpu/drm/tilcdc/tilcdc_drv.c           |    2=20
 drivers/gpu/drm/udl/udl_gem.c                 |    4=20
 drivers/infiniband/hw/cxgb4/qp.c              |   25 +++--
 drivers/iommu/amd_iommu.c                     |    3=20
 drivers/net/ethernet/ibm/ibmveth.c            |   23 ++---
 drivers/net/ethernet/realtek/r8169.c          |    9 ++
 drivers/net/usb/cdc_ether.c                   |    7 +
 drivers/net/usb/qmi_wwan.c                    |    7 +
 drivers/pci/bus.c                             |    1=20
 drivers/pci/probe.c                           |    1=20
 drivers/pwm/pwm-spear.c                       |    6 -
 drivers/remoteproc/Kconfig                    |    1=20
 drivers/rpmsg/Kconfig                         |    1=20
 fs/autofs4/expire.c                           |    9 --
 fs/btrfs/delayed-ref.c                        |   24 +++--
 fs/btrfs/inode.c                              |   21 +++-
 fs/ext4/resize.c                              |    4=20
 fs/hugetlbfs/inode.c                          |   24 ++---
 fs/nfs/nfs4proc.c                             |    4=20
 include/drm/drmP.h                            |    5 -
 include/drm/drm_pciids.h                      |    5 +
 include/linux/blkdev.h                        |    2=20
 include/linux/hugetlb.h                       |   19 +++-
 ipc/shm.c                                     |    6 +
 kernel/Makefile                               |    2=20
 kernel/audit_tree.c                           |    2=20
 kernel/trace/trace.c                          |   62 ++++++--------
 kernel/trace/trace_selftest.c                 |    9 +-
 mm/mmap.c                                     |    7 +
 net/netfilter/ipvs/ip_vs_pe_sip.c             |    6 -
 scripts/kconfig/list.h                        |   13 +++
 scripts/kconfig/mconf.c                       |    3=20
 90 files changed, 858 insertions(+), 317 deletions(-)

Alex Deucher (20):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon: use frac fb div on RS780/RS880
      drm/radeon: fix typo in rv515_mc_resume()
      drm/radeon/dce6: add missing display reg for tiling setup
      drm/radeon: update wait_for_vblank for r5xx-r7xx
      drm/radeon: update wait_for_vblank for evergreen+
      drm/radeon: properly lock disp in mc_stop/resume for evergreen+
      drm/radeon: properly lock disp in mc_stop/resume for r5xx-r7xx
      drm/radeon: update wait_for_vblank for r1xx-r4xx
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
      drm/radeon: add some new SI PCI ids
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: fix typo in si_select_se_sh()
      drm/radeon: disable the crtcs in mc_stop (r5xx-r7xx) (v2)
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: add new richland pci ids
      drm/radeon: fix handling of v6 power tables

Anisse Astier (1):
      drm/gma500: fix backlight hotkeys behaviour on netbooks

Anton Blanchard (1):
      powerpc: Emulate non privileged DSCR read and write

Axel Lin (1):
      pwm: spear: Fix checking return value of clk_enable() and clk_prepare=
()

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address

Benjamin Poirier (1):
      menuconfig: Fix memory leak introduced by jump keys feature

Catalin Marinas (1):
      arm64: Ignore the 'write' ESR flag on cache maintenance faults

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in aud=
it_trim_trees()

Chris Wilson (2):
      drm/i915: Workaround incoherence between fences and LLC across multip=
le CPUs
      drm/i915: Use MLC (l3$) for context objects

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Dan Williams (1):
      qmi_wwan/cdc_ether: add device IDs for Dell 5804 (Novatel E371) WWAN =
card

Daniel Vetter (3):
      drm/i915: Fix sdvo connector get_hw_state function
      drm/i915: don't check inconsistent modeset state when force-restoring
      drm/i915: Fixup Oops in the pipe config computation

Dave Airlie (4):
      drm/cirrus: deal with bo reserve fail in dirty update path
      drm/mgag200: deal with bo reserve fail in dirty update path
      drm/prime: keep a reference from the handle to exported dma-buf (v6)
      drm/ast: deal with bo reserve fail in dirty update path

David Cohen (1):
      MODSIGN: do not send garbage to stderr when enabling modules signature

David Jeffery (1):
      autofs - remove autofs dentry mount check

David M=FCller (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

Egbert Eich (1):
      drm/i915: Fix SDVO connector and encoder get_hw_state functions

Greg Kroah-Hartman (1):
      Linux 3.9.2

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Imre Deak (1):
      drm: prime: fix refcounting on the dmabuf import error path

James Bottomley (1):
      block: fix max discard sectors limit

Jan-Simon M=F6ller (1):
      perf/x86/intel: Fix unintended variable name reuse

Jani Nikula (1):
      drm/i915: ensure single initialization and cleanup of backlight device

Jerome Glisse (1):
      drm/radeon: Always flush the VM

Joerg Roedel (1):
      iommu/amd: Properly initialize irq-table lock

Josef Bacik (2):
      Btrfs: compare relevant parts of delayed tree refs
      Btrfs: fix extent logging with O_DIRECT into prealloc

Jun'ichi Nomura (1):
      blkcg: fix "scheduling while atomic" in blk_queue_bypass_start

Michael Neuling (1):
      powerpc/tm: Fix null pointer deference in flush_hash_page

Naoya Horiguchi (1):
      hugetlbfs: fix mmap failure in unaligned size request

Paulo Zanoni (2):
      drm/i915: set CPT FDI RX polarity bits based on VBT
      drm/i915: don't intel_crt_init on any ULT machines

Peter Zijlstra (3):
      perf/x86: Blacklist all MEM_*_RETIRED events for Ivy Bridge
      perf/x86/intel/lbr: Fix LBR filter
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_K=
ERNEL

Sachin Kamat (1):
      drm/tilcdc: Fix an incorrect condition

Srivatsa S. Bhat (1):
      EDAC: Don't give write permission to read-only files

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Stefano Stabellini (1):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq

Steven Rostedt (Red Hat) (1):
      tracing: Fix ftrace_dump()

Suman Anna (2):
      rpmsg: fix kconfig dependencies for VIRTIO
      remoteproc: fix kconfig dependencies for VIRTIO

Thadeu Lima de Souza Cascardo (1):
      RDMA/cxgb4: Fix SQ allocation when on-chip SQ is disabled

Theodore Ts'o (1):
      ext4: add check for inodes_count overflow in new resize ioctl

Trond Myklebust (1):
      NFSv4.x: Fix handling of partially delegated locks

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree

Vince Weaver (1):
      perf/x86/intel: Add support for IvyBridge model 58 Uncore

Yinghai Lu (1):
      PCI: Delay final fixups until resources are assigned

Zhang, Xiong Y (1):
      drm/i915: correct the calculation of first_pd_entry_in_global_pt


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjrw4AAoJEDjbvchgkmk+oUoQALt7JeunFEdrr6/fb+50M1Nm
M8Sh4/XwZycYbjF2y8o9MIrToovxPFeC7AlF5b8sNTvqeZ/o4W7xeRCfHDSLLOea
YiF4749htTi8IO2LtPa+kU3VrOhNCunP+1X1fJhQr3J1qDtDWqqDplMty9xiIxp8
S+PeFT2TMisSx16/4Bmwo22QAg2KqhQaU0fgWz7FHyQ7rdDUWLXFUmmYavySzyzV
TL0mSwhWZWaLLwgkda5XlYxtj4wBL7m9sp8O941ZQdqew93sbxkn8NgZ/Fwt/+/W
DvFWZ38EAIp9HosBY++eS0+3twyekUvu5qKtih64eVn+mjGx4GzZPs2jk/vYYLcX
ZdVW6obH/8Fz3NI1ZSZpYYG5XRvnayePUM80EtwBxXmE8kEeEmLvKmuUJA/r5x+1
7OIMCgiu2n4vMrGc9u7/JD9s5GgcDJYCYLEiY+/G9ad6L2mKjXAUwE1JAj+YwlAb
S4TLh7fwkdLYFC8B2cxqcl9pT+nWhuSEQFPPIVjyhnscMLR3ZoEmYXzAs3tM1oOc
owK153XhbzUaPnFm9QueIhUMaXIJsPYY41FnHlQuKHQwqcC2GJVzZLfYeZSPL6JU
V8bevL2DtY7SfL/smwExl4RozOM6PaQDqsYAlE1yi28noqFwAphtirqOPmRNBxjk
kM5x3Psq2b8fvULxTc4E
=M+oH
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
