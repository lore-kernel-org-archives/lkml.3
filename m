Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3JAUBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:01:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3JAUBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:01:40 -0400
Date: Tue, 1 Oct 2013 13:01:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.98
Message-ID: <20131001200147.GA27750@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.98 kernel.

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
 drivers/gpu/drm/radeon/evergreen.c       |   25 +++++++++++--
 drivers/gpu/drm/radeon/evergreend.h      |    4 ++
 drivers/gpu/drm/radeon/radeon_atombios.c |   13 ++++--
 drivers/gpu/drm/radeon/rs400.c           |    9 +++-
 drivers/hid/hid-core.c                   |   58 ++++++++++++++++++++++++++=
+++++
 drivers/hid/hid-zpff.c                   |   18 ++-------
 drivers/net/sfc/rx.c                     |    3 +
 drivers/net/usb/cdc_ether.c              |    5 ++
 drivers/net/wireless/rt2x00/rt2800lib.c  |    7 +++
 drivers/scsi/scsi_transport_iscsi.c      |    2 -
 fs/notify/fanotify/fanotify.c            |    6 +++
 include/linux/hid.h                      |    4 ++
 include/linux/perf_event.h               |    2 -
 kernel/cgroup.c                          |   11 +++++
 kernel/events/core.c                     |   21 ++++++-----
 net/sctp/sm_sideeffect.c                 |    3 -
 scripts/kernel-doc                       |    3 +
 tools/perf/util/map.c                    |    1=20
 19 files changed, 158 insertions(+), 39 deletions(-)

Alex Deucher (4):
      drm/radeon: fix LCD record parsing
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects

Andi Kleen (1):
      perf tools: Handle JITed code in shared memory

Ben Hutchings (1):
      sfc: Fix efx_rx_buf_offset() for recycled pages

Daniel Santos (1):
      kernel-doc: bugfix - multi-line macros

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Greg Kroah-Hartman (2):
      Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpret=
er()"
      Linux 3.0.98

Kees Cook (2):
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details

Li Zefan (1):
      cgroup: fail if monitored file and event_control are in different cgr=
oup

Lino Sanfilippo (1):
      fanotify: dont merge permission events

Peter Zijlstra (2):
      perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::=
unique_pmu
      perf: Fix perf_cgroup_switch for sw-events

Sasha Levin (1):
      SCSI: iscsi: don't hang in endless loop if no targets present

Stanislaw Gruszka (1):
      rt2800: fix wrong TX power compensation


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSyorAAoJEDjbvchgkmk+XvgQAKzsggwM7Ti7wFf6xde/h7Vm
fjROhU/hvYkdMqGZEYiV1JTtncFJd32YP+B13I0Hvys1uc4WO1Q2WbfAOtom4PVc
th5MBDUzisyPqfkPstFFd8prtw5qLQO0YtvpJkiUEpv6hxfO3KTXcnKg/T0PVIqv
HwKBosTF3yXq0nqttrc+7vzBKMl0RJpNF0CTatE6YuAvm6p5X0VvzSsYxAzUd+gg
hKZjqOq7ZBeKRN8ttxPmGT3LjI54IwJpXGwKW30GNUmvf5djmjpU4fAxt6aXYYKo
eEobtSWdw54i68T0NRd8S96Z5eR7pk9WAxjxRR8IsBrBFfMg6PuAiZuUIUch6Pc9
dCeF9w/hyEIGk9wyRmeL5HAh+LL9sUxUFBwmN1Rt1pLacdVlHvlIr9IA3bjfvjPa
o89Z6ojgxq/+kA0XFnn1x45596ZbNr+9tYDAvPQhCiIa8KfipqTvJ1dNCI2gtyUs
sJAEMpktPj1GXupCr5LJ9HisZ3xt4PWHRyvEdtf4uTSWHFYdynzD3Pbotm6OBm28
8RAqY5ZutkKPevxJ4hwjqtNqV0CE3eJGp2X9xxkqGOPl5pdEa1sYvyvE/nKc/OL8
OhtNoiQZBAfj17x7OozXyUx3CihP/ihbRfP3gMPiXz8aIgcMFNvh7i3M8ps9FShp
SGFf825YiIVJI+PVl0xM
=Y5gE
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
