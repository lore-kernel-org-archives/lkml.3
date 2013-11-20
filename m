Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3KTStj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:49:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3KTSth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:49:37 -0500
Date: Wed, 20 Nov 2013 10:49:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.70
Message-ID: <20131120184935.GA23584@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.70 kernel.

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

 Makefile                            |    2=20
 arch/arm/lib/memset.S               |  100 +++++++++++++++++--------------=
-----
 drivers/net/xen-netback/common.h    |    1=20
 drivers/net/xen-netback/interface.c |    3 -
 drivers/net/xen-netback/netback.c   |   10 +--
 drivers/pci/pci-driver.c            |    4 +
 drivers/pci/setup-res.c             |    3 -
 drivers/usb/core/hub.c              |    1=20
 drivers/usb/serial/option.c         |   17 ++++++
 kernel/trace/trace.c                |    5 +
 net/core/flow_dissector.c           |    2=20
 net/netfilter/nf_conntrack_sip.c    |    2=20
 sound/pci/hda/patch_hdmi.c          |   22 ++++++-
 13 files changed, 103 insertions(+), 69 deletions(-)

Greg Kroah-Hartman (1):
      Linux 3.4.70

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) =
optimizations

Jason Wang (1):
      net: flow_dissector: fail on evil iph->ihl

Krzysztof Mazur (1):
      usb: fix cleanup after failure in hub_configure()

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix

Nikhil P Rao (1):
      PCI: fix truncation of resource size to 32 bits

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outsid=
e the packet

Rafael J. Wysocki (1):
      PCI/PM: Clear state_saved during suspend

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Steven Rostedt (1):
      tracing: Fix potential out-of-bounds in trace_get_user()

Takashi Iwai (1):
      ALSA: hda - Move one-time init codes from generic_hdmi_init()

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSjQQ/AAoJEDjbvchgkmk+r9MQAKdIBYJa6XvS9VQuyTLYnO91
YNMttJ/fUR8p5ikoOdzhL6isSpeAdl4AHPEZdCkYemft6V2FCkmNYv+55N6/9/Mi
AQL84Pwg/uAZ6JQaLywMxhLiZX3W/080UP0j0lL7YGkZ4JBNAwz1NbsASQsW76kh
BuugQzP+R2AiRVFhZU3oNjdFGHatpgqH+gseMHGIaOqcBQQxNaXCYpiofBVqvwKh
jNUny2jLOxu8dwT8iBc/9uM3A/2jyfK3aP3bdvuNpe+r7m40fQtDDvFfLsrjDGcy
+Bi/ch39XGrbnig12GJIyr5aVhy8pjaytLvkCKvqJcvSof8OQoU5FN/voctDrd/8
M5Ede1nubY3YGn+pg4t7qAp3QVCE2Mv2R5+P1uwKS71MJmsSvEN8jscMPCF9btKu
CIKrN5y1U39EigJCdlN5NZ42iAszEYqzotJMFBd1soZQgfYwSYUIfsy2zO9Q5knE
pMqqwqoBeevHIooOiT+wJyGYBecxqDwWQVg+yoA1QUmumtspJ0lcyE/7gaXqPRSC
e7nonR2QpOwGzcqIdSPC0qfFLc26AhQPm2TgoMZZp7ueWsuoeCk+yvGr40L7mKvY
mDpIiNN++sDeQXMRj1iDZohzVhvgaMFX6E/7QJ/ky3Brxbrp1PsDLlYgXjkqWIul
gBtddsf3J84bGeeOf9ht
=Q11n
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
