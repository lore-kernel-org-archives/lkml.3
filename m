Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3EKVfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:35:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56435 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab3EKVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:35:53 -0400
Date: Sat, 11 May 2013 14:36:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.45
Message-ID: <20130511213603.GA19467@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.45 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/powerpc/include/asm/ppc-opcode.h      |    4 +
 arch/powerpc/kernel/traps.c                |   10 +++-
 arch/powerpc/mm/numa.c                     |    2=20
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   27 +++++++++--
 arch/x86/mm/init.c                         |    5 ++
 drivers/cpufreq/longhaul.c                 |   10 +++-
 drivers/gpu/drm/i915/intel_dvo.c           |   13 +++++
 drivers/gpu/drm/i915/intel_lvds.c          |    8 +++
 drivers/gpu/drm/radeon/atom.c              |    6 +-
 drivers/gpu/drm/radeon/evergreen.c         |   67 ++++++++++++++++++++++++=
+++--
 drivers/gpu/drm/radeon/evergreen_reg.h     |    2=20
 drivers/gpu/drm/radeon/ni.c                |    8 ++-
 drivers/gpu/drm/radeon/nid.h               |    4 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |   21 ++++++---
 drivers/gpu/drm/radeon/radeon_pm.c         |    6 ++
 drivers/gpu/drm/radeon/si.c                |    1=20
 drivers/gpu/drm/radeon/sid.h               |    2=20
 drivers/net/ethernet/ibm/ibmveth.c         |   23 ++++-----
 drivers/net/ethernet/realtek/r8169.c       |    9 +++
 drivers/usb/host/xhci-ring.c               |   23 ++++++---
 fs/autofs4/expire.c                        |    9 ---
 fs/ext4/resize.c                           |    4 +
 include/drm/drm_pciids.h                   |    5 ++
 kernel/audit_tree.c                        |    2=20
 kernel/trace/trace.c                       |   62 +++++++++++-------------=
--
 kernel/trace/trace_selftest.c              |    9 ++-
 net/netfilter/ipvs/ip_vs_pe_sip.c          |    6 --
 28 files changed, 247 insertions(+), 103 deletions(-)

Alex Deucher (10):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon/dce6: add missing display reg for tiling setup
      drm/radeon: properly lock disp in mc_stop/resume for evergreen+
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
      drm/radeon: add some new SI PCI ids
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: add new richland pci ids
      drm/radeon: fix handling of v6 power tables

Anton Blanchard (1):
      powerpc: Emulate non privileged DSCR read and write

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in aud=
it_trim_trees()

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

David Jeffery (1):
      autofs - remove autofs dentry mount check

David M=C3=BCller (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

Greg Kroah-Hartman (1):
      Linux 3.4.45

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment

Peter Zijlstra (2):
      perf/x86/intel/lbr: Fix LBR filter
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_K=
ERNEL

Rafa=C5=82 Bilski (1):
      cpufreq / Longhaul: Disable driver by default

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Steven Rostedt (Red Hat) (1):
      tracing: Fix ftrace_dump()

Theodore Ts'o (1):
      ext4: add check for inodes_count overflow in new resize ioctl

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjrnDAAoJEDjbvchgkmk+KqEP+wfLmXzb+nxLm8gxJlY/Tj8J
JQQP751acNBbb77MBr1yvQJhjZeRGrZGgxQm2syr/L11NVcRzV6s6U8VnNP0vtrK
AB0LOeo42uKjSUN/SC95Iy5KszlDRcAGPB9IzzpGa2RI0XBOhLvGNzg0XomqcYu2
WmfZg5fQi82h8UiYe+CtRnSoPyJJThHba1Iqi74gHwAcJUPAX2dg21G/ygVOoyYO
24beD+KX3RtlPf+iEolSXk1Zo5AdFCpIjx4A407zabvk17QkBWR6WiwrrhRDYqRL
GpkJs6YK2gIGaa/kjbIaCHq7JB0mMop4MBIx6tJQzjwqvzO9I/SZAAGGjXC98+8a
qqRgjSUntN4Se2BSIVmqmnMkJJlep/LT+B17sI2aCi0TUNZuf+xBjrQpXe4+iP6o
h0pOv7I5XGyG4EkMEcQ4VvrJWzz68+C6Uq0zswmUTSKJsdmPMpYRWmKc5Er3XXNH
tQ+jlKGW1M5TXILsN+6oVEzIvAlkMdWXMccTLtV2Z7iMDj5oek2eNOOTLgzFzQj3
brAcpoXal0nLcIxoj4YSsUYGBepCha1Up6gdZs2iHdKP4zbHpliBNdRyRG3V3sr2
M+hz9GW7zaRGPQE5BLGLz7avgWgTvjY5AxxRzXd0D1TK91ehwwQ+Ng+CgVO13JUD
CcLInRE7wjK/h4AJV9AI
=GZ58
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
