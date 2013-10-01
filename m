Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3JAUC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:02:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JAUCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:02:25 -0400
Date: Tue, 1 Oct 2013 13:02:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.64
Message-ID: <20131001200235.GA27824@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.64 kernel.

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

 Makefile                                   |    2 -
 drivers/gpu/drm/radeon/atombios_dp.c       |    6 +--
 drivers/gpu/drm/radeon/atombios_encoders.c |    8 +++-
 drivers/gpu/drm/radeon/atombios_i2c.c      |    4 +-
 drivers/gpu/drm/radeon/evergreen.c         |   25 ++++++++++--
 drivers/gpu/drm/radeon/evergreend.h        |    4 ++
 drivers/gpu/drm/radeon/radeon_atombios.c   |   13 ++++--
 drivers/gpu/drm/radeon/rs400.c             |    9 +++-
 drivers/gpu/drm/radeon/si.c                |   23 +++++++++--
 drivers/gpu/drm/radeon/sid.h               |    4 ++
 drivers/gpu/drm/ttm/ttm_tt.c               |    2 -
 drivers/hid/hid-core.c                     |   58 ++++++++++++++++++++++++=
+++++
 drivers/hid/hid-logitech-dj.c              |   10 ++++-
 drivers/hid/hid-zpff.c                     |   18 ++-------
 drivers/net/ethernet/sfc/rx.c              |    3 +
 drivers/net/usb/cdc_ether.c                |    5 ++
 drivers/net/wireless/rt2x00/rt2800lib.c    |    7 +++
 fs/notify/fanotify/fanotify.c              |    6 +++
 include/linux/hid.h                        |    4 ++
 include/linux/perf_event.h                 |    2 -
 kernel/cgroup.c                            |   11 +++++
 kernel/events/core.c                       |   21 ++++++----
 kernel/sched/fair.c                        |   14 ++++---
 net/sctp/sm_sideeffect.c                   |    3 -
 scripts/kernel-doc                         |    3 +
 tools/perf/util/map.c                      |    1=20
 26 files changed, 210 insertions(+), 56 deletions(-)

Alex Deucher (7):
      drm/radeon: fix LCD record parsing
      drm/radeon: fix endian bugs in hw i2c atom routines
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: update line buffer allocation for dce6
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (=
v2)

Andi Kleen (1):
      perf tools: Handle JITed code in shared memory

Ben Hutchings (1):
      sfc: Fix efx_rx_buf_offset() for recycled pages

Ben Skeggs (1):
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point =
to invalid ones

Daniel Santos (1):
      kernel-doc: bugfix - multi-line macros

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Greg Kroah-Hartman (2):
      Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpret=
er()"
      Linux 3.4.64

Kees Cook (3):
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: logitech-dj: validate output report details

Li Zefan (1):
      cgroup: fail if monitored file and event_control are in different cgr=
oup

Lino Sanfilippo (1):
      fanotify: dont merge permission events

Peter Zijlstra (2):
      perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::=
unique_pmu
      perf: Fix perf_cgroup_switch for sw-events

Stanislaw Gruszka (1):
      rt2800: fix wrong TX power compensation


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSypbAAoJEDjbvchgkmk+R5QQAIGwYf105SV9IREf5JzHsIQK
6qyGOVZYUayLdrR1oqbNufhzudeDy21rkPqDDw4XN07mW6HKSJrwVQmYvXWE1n7a
/pSkKIR6cRI2tlo1fA8nqaF5Zco2Nc0wgAmFP9xhgyb4zHD34cLpLItR0m0Q57eU
rfWZYrN9HEbrJuC7CNusBg3z6MAvAeQlEgWBUOx6cliXcG7UoxDB7ptqNvdhOYtC
Zdn1uYFlkl5iJhAGeL1ffuQ8CP1fLicGmGSSjheiQgeSIUzSrMCoR5dwIHSPIloe
CX2jDb8HpOnFhM2TJ2GJJ75Si8P/HROU/ou3Hj7lzkZIEi5B4ayBY+EwptIL8RNj
iFmlGNimSTOgMAbQmbgQSO6jCKH1y/pFd5GzH01afeVBaQIv3/tWMxJwqDHqLikZ
c9h4TlDEMwTcN+WvJe4k0+kAdueYXhaC7EH6vyI8mhFXTQpmprd3oUceKAob7LuD
+BH7gOP869CDduoe7BgFm5+mm/YekAcD11tz67jZmSH+8UoguL0Xhb+GV7nxADTY
h2iWow51okbtduTKzKctK1nRdbuavxgMllyx1DcD1AOb2zL4GuyOf5cz5nTPqWJD
z7fArj4r6Z9DOuGOeAGkks0Dbosli2WBxyvU4V1DELsDV5PJjRSGVUtuQsjwtNea
NDEcJgu4sXorXSwQNGEj
=9+l0
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
