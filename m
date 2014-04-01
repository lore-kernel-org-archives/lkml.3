Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaDAJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:06:44 -0400
Received: from [217.156.133.130] ([217.156.133.130]:30156 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751057AbaDAJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:06:06 -0400
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Tue, 01 Apr 2014 10:05:54 +0100
Message-ID: <533A8170.3080002@imgtec.com>
Date: Tue, 1 Apr 2014 10:05:52 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-metag <linux-metag@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Metag architecture changes for v3.15
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9AIu620w1v7dRAJhXHOQKqABJNbT0KBrn"
X-Originating-IP: [192.168.154.65]
X-ESG-ENCRYPT-TAG: b0d8b728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9AIu620w1v7dRAJhXHOQKqABJNbT0KBrn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the following changes since commit dcb99fd9b08cfe1afe426af4d8=
d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

which are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.15

for you to fetch changes up to 2aca46ce1b5c4b7d76566de72b16640ec674c008:

  sched: remove unused SCHED_INIT_NODE (2014-03-19 11:02:16 +0000)

Please note, this tag is signed with a different PGP key to usual. The
new key should be sufficiently signed so I'll be using this one in
future.

Thanks
James

----------------------------------------------------------------
Metag architecture changes for v3.15

- Remove unused NUMA definition (SD_NODE_INIT)
- Refactor signal code to use struct ksignal
- IRQ migration cleanup to use irq_set_affinity
- Clean up main Kconfig file a little

----------------------------------------------------------------
James Hogan (1):
      metag: Fix METAG Kconfig symbol select ordering

Richard Weinberger (1):
      metag: Use get_signal() signal_setup_done()

Thomas Gleixner (1):
      metag: Use irq_set_affinity instead of homebrewn code

Vincent Guittot (1):
      sched: remove unused SCHED_INIT_NODE

 arch/metag/Kconfig                |  2 +-
 arch/metag/include/asm/topology.h | 27 ----------------------
 arch/metag/kernel/irq.c           | 22 +++---------------
 arch/metag/kernel/signal.c        | 48 +++++++++++++++++----------------=
------
 4 files changed, 25 insertions(+), 74 deletions(-)


--9AIu620w1v7dRAJhXHOQKqABJNbT0KBrn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOoFwAAoJEGwLaZPeOHZ6ou0QAIDunMxCaoU4RJfVTG+AoYcn
4L/pe/b1I5Z5CuM1yOz2/CKU4Epv36MGryPX7MLxrSoDkPlX2ePZZpB3/YaDYmWk
249kn/TNQ2/XoUhEBzWEIG60JU1BrJQiHl+Ffi0WUaCqNzO+XASWHOQ/NCwYABN/
SYga30EZG3hW5HvhWrKMljYPT4fSLSRfRrmGIFfBHvm0FNQNGyWtuylKyhib4WI1
sKaYYnCKgEXD67FoDpvkKFr43TYmmWfTz1DOXsRitQB1VvyI09mU7qZp0hA67OrS
cgKbUG9mh1r+yhPRAEDF8GTOKeUUakiQLZ/kq9aPubEjlaTM4EjCAS/beRzXWE6D
bmD88DMi5xyjIByyKbwJEKxuUGhs+AOi2bDFQ/+a1E9+SJmE9grv6bmY6r/iFCoc
iMp1llokZNHbYolTONmz72wjo9fqUQfDMna3kXfD9R+3kSgEQ2JorUHAIsSegrk5
2id4ABOxaRixEwBM4RJWWDfiGZGdpivhXNIGMGfI2JXY2ZV1LgPwOFy/bC1ox2nz
VPnXDAtecWK34sIYECBh8fizxmdPuAzJx24Otk/p+tqGFXvbIoz9WoSBfUv+AemE
OZq0BpDU1iKLG6O1y/wPXgR9rsglezR2JVHcxpwuXFaqKqmmi3c9dSawgWIlat95
+diMfRYbBedah3HNL+xU
=SxXE
-----END PGP SIGNATURE-----

--9AIu620w1v7dRAJhXHOQKqABJNbT0KBrn--
