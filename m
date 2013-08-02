Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3HBIGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:06:40 -0400
Received: from sauhun.de ([89.238.76.85]:51742 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3HBIG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:06:28 -0400
Date: Fri, 2 Aug 2013 10:06:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-stmp3xxx: provide timeout for potentially
 endless loop polling a HW bit
Message-ID: <20130802080607.GA2992@katana>
References: <1375280941-22657-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1375280941-22657-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2013 at 04:29:01PM +0200, Lothar Wa=DFmann wrote:
> It's always a bad idea to poll on HW bits without a timeout.
>=20
> The i.MX28 RTC can be easily brought into a state in which the RTC is
> not running (until after a power-on-reset) and thus the status bits
> which are polled in the driver won't ever change.
>=20
> This patch prevents the kernel from getting stuck in this case.
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+2hvAAoJEBQN5MwUoCm2adoP/A/r+7cJHDfcl9SwUEp3Z6cO
nDW0waRNf2FA/6wJLF6LeAIuDY3VCGIGgcA9P4s0AWnTX64qN60J2bTR56Vgw59e
XdQU2/QZ7ulVjBZ1wA312kVjft1K/QsUZEVUC2d0HKyqzR7SAI4a0IwcBxXgQnC7
rmQkf/+eVBmoeysP0HyId1m/ZxcdDj75R7HUXzClz7aJCap1By8NQf0ihlMgi5nH
qTHvKmMpH79muUttrt2D4Glc7Sfh5hsHwyJ5yFBf2kojkRrPZbWiNtA51NLFCvtc
5f2AtDsMdEJnC8E+OLC0v+Ocd93vbQtgRUbxXiwxRQHS0bE+xLqy0AJiHY/Hn+9f
q5/Oabp2pofXolSlPJGSCGwCww1BVmVqXdZXb83qIjmQisPDFaKeMFYrlONzb5rq
nuMVJd+RH9rZO8ESlyKxVUMj7EiwTrO6nsTKppPAeGOMCJpb+6XkcweR5AfuGmEp
M36ysavXj8ShNptJ1dBDb0ShumLtBQCeGDxSX235P7ynZ4Xggd/nDZ+7oK5Lpr3O
BEoV17epMSkqiWn7h7JGnMIi97k8UDJw0gZGHUpYfyScwdqePDENFYB5Rla2wLYR
Z7wqf+buXu5WQbIYeNnhgpAHXiLZNhyMcPEDX4oBxc1Fd0KvwrX7FEqA7buz0uTN
5W5+FHOcbJezy5WrqetN
=dDAp
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
