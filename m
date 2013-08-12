Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3HLCLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:11:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3HLCLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:11:37 -0400
Date: Sun, 11 Aug 2013 19:12:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.90
Message-ID: <20130812021259.GA15190@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.90 kernel.

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

 MAINTAINERS                                   |    4 +-
 Makefile                                      |    2 -
 arch/x86/kernel/i387.c                        |    2 -
 drivers/acpi/battery.c                        |    2 +
 drivers/net/arcnet/arcnet.c                   |    2 -
 drivers/net/usb/smsc75xx.c                    |   12 ++------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1=20
 drivers/net/wireless/mwifiex/sdio.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c     |   18 +++++++-----
 drivers/tty/serial/mxs-auart.c                |   38 +++++++++++++++------=
-----
 fs/notify/fanotify/fanotify_user.c            |    1=20
 kernel/events/core.c                          |   30 +++++++++++++++++---
 kernel/sched_fair.c                           |    2 -
 net/ipv4/sysctl_net_ipv4.c                    |    6 +++-
 net/ipv6/ip6mr.c                              |    5 +++
 net/key/af_key.c                              |    4 ++
 net/mac80211/rx.c                             |   10 +++++-
 net/sched/sch_atm.c                           |    1=20
 net/sched/sch_cbq.c                           |    1=20
 net/sctp/outqueue.c                           |    8 +----
 net/wireless/nl80211.c                        |    7 +++-
 21 files changed, 104 insertions(+), 56 deletions(-)

Dan Carpenter (4):
      fanotify: info leak in copy_event_to_user()
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

Eric Dumazet (1):
      usbnet: do not pretend to support SG/TSO

Greg Kroah-Hartman (2):
      MAINTAINERS: fix up stable_kernel_rules.txt location
      Linux 3.0.90

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Jiri Olsa (1):
      perf: Fix event group context move

Johannes Berg (1):
      mac80211: fix duplicate retransmission detection

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Neil Horman (1):
      sctp: fully initialize sctp_outq in sctp_outq_init

Oleksij Rempel (1):
      ath9k_htc: do some initial hardware configuration

Salman Qazi (1):
      perf: Use css_tryget() to avoid propping up css refcount

Stanislaw Gruszka (1):
      rt2x00: fix stop queue

Tomasz Mo=C5=84 (1):
      mwifiex: Add missing endian conversion.

Uwe Kleine-K=C3=B6nig (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

Zhu Yanhai (1):
      sched: Fix the broken sched_rr_get_interval()


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCESrAAoJEDjbvchgkmk+DesP/20NIilZOkWeeLOo9XVGIUp0
920P2vNiVSid6hNEmr8w6ZzHUcTDU/KUEKef1cZp5SIwYK7GAqLixBiFdNl+fuEZ
SZ3uoKQ9XdLn45a2OJuDsNBvhBwosxreX5r0SU1nZCF/ItrccX6onf8GZqGMc9Yi
TbnkRoqGXFenhqToF9ziHBFHKyQIbD0djkKMI+cvaezxHBn7OThg6Co2QFb1ffW+
P4YJOjn+rmgLgrhrsjmO6pG2lMzUJzSIxJ+5CoRY/6kPe+wlAKiR/tPnTVzq6BTt
trrJJBmdz4AjURL9dplVYlz5ZNLsGiertELxn9RWHyDlyakKa/mMVX59fMnivtn7
E+W1+1IbHBWxYIVRc2kZ2U1lZ+XY9A+1dEyLE+lZDz+jED+CNolZjG9T8JKeqKmO
8+I5C5es9d/pXEMGsD1N0NbfncbLlLFhMAr2zCOQAvLoXYuHqAy6/N3ilbIuuKv3
EbSsUQDzqfe9rnRAvu88Z44ZvhJwxLoc5r6HcktmtKjp/Jtz8RXbN13HuQoErNcP
yEin7M4XWdpK7oVkEVYYUB+LhFPNNsxoG6Fu9lJreGrykZ3M95U1MrWhpTMij4wB
KTdoX/WGHs6PTAHzA6dXqTdJb3bTCWh8D1yCyvCMDE030fbd3zthd0ESBJfoW+qT
FBm8jC6QWNE4DdCddoUL
=QCmC
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
