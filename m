Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3EKV1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:27:05 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:41384 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3EKV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:27:03 -0400
Date: Sat, 11 May 2013 14:27:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.78
Message-ID: <20130511212713.GA19261@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.78 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 arch/powerpc/mm/numa.c                   |    2 -
 arch/x86/kernel/cpu/amd.c                |   14 --------
 arch/x86/mm/init.c                       |    5 +++
 drivers/gpu/drm/i915/intel_dvo.c         |   13 +++++++
 drivers/gpu/drm/i915/intel_lvds.c        |    8 ++++
 drivers/gpu/drm/radeon/atom.c            |    6 +--
 drivers/gpu/drm/radeon/evergreen.c       |   10 ++++++
 drivers/gpu/drm/radeon/radeon_atombios.c |   10 +++++-
 drivers/gpu/drm/radeon/radeon_pm.c       |    6 +++
 fs/autofs4/expire.c                      |    9 -----
 kernel/audit_tree.c                      |    2 -
 kernel/trace/trace.c                     |   51 ++++++++++++--------------=
-----
 kernel/trace/trace_selftest.c            |    9 +++--
 net/netfilter/ipvs/ip_vs_pe_sip.c        |    6 ---
 15 files changed, 82 insertions(+), 71 deletions(-)

Alex Deucher (4):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables

Andre Przywara (1):
      Revert "x86, amd: Disable way access filter on Piledriver CPUs" it is=
 duplicated

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in aud=
it_trim_trees()

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

David Jeffery (1):
      autofs - remove autofs dentry mount check

David M=FCller (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

Greg Kroah-Hartman (1):
      Linux 3.0.78

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment

Steven Rostedt (Red Hat) (1):
      tracing: Fix ftrace_dump()

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjrexAAoJEDjbvchgkmk+iPkP/RSl3PLbKDEI22iJooukGoDQ
nZFmcOC9tsiJ9PC3WMa1jzMSW5o9JMVH4TAxISZ4A2VlJbBYza6X2myOls4ATXFC
52Cw3BLRrCeHAT841uUDZSeRQoNX00BKCAaT41/FMoPalsIFcamk6BoOegfNyRq4
35RLQM+8LPf34JijH4nwZ6QPnYnBNUjvCVmV3Fhjzs5CdM05lukNTA6j5eCsEtFE
9JLo4xo3CBiYGRqz4Aow0xgnjojb0NC9oDB2vYBMyX+yM8Q6eajYK6m/+ybCDB0H
d4KYPeVgtsUFyBNREylY7xLNRjLWj00wWeCF3hi5l7aAC5T6SAI+0Z10Z02av2rz
6b38FUBh9DAu+q77QxXXCBQp/bn9jbQ8yX0yOp2b2ADrBjqPzQfvtLkxDdm+cCKQ
PoGzNQFLEk/nYTXG+OIRETfwaR+FwDV1maKhJyS/M897m/zMFY/roQ5W2kNO1VXl
sfyRE6W7mEYL+jLr7GPrhkTzPM+9sxd3WwGLaWdqLFbh4GHgAhg3U6AaabVNftqQ
/SdVix1RFQTV2AnDke2sxxljAZ3itJAGHZk4sxiQqWmZVO4iDnX7w9UC8VftAGWm
wJUwwXtfx9Zc8pnfZSuHUvCJolsNMXWVLZRNbGOZaBD+4qZjSG8j/IO2vQ069RBG
jAlp/tmJWwNHLv0sC/Te
=o3SP
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
