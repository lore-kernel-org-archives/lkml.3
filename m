Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab3CSCt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:49:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41449 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab3CSCtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:49:25 -0400
Message-ID: <1363661353.3937.357.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 38/88] asus-laptop: Do not call HWRS on init
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Tue, 19 Mar 2013 02:49:13 +0000
In-Reply-To: <1363257381-15900-39-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
	 <1363257381-15900-39-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1uzz9gv5enQWpVwfHOAg"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1uzz9gv5enQWpVwfHOAg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-14 at 10:35 +0000, Luis Henriques wrote:
> 3.5.7.8 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Ben Hutchings <ben@decadent.org.uk>
>=20
> commit cb7da022450cdaaebd33078b6b32fb7dd2aaf6db upstream.
>=20
> Since commit 8871e99f89b7 ('asus-laptop: HRWS/HWRS typo'), module
> initialisation is very slow on the Asus UL30A.  The HWRS method takes
> about 12 seconds to run, and subsequent initialisation also seems to
> be delayed.  Since we don't really need the result, don't bother
> calling it on init.  Those who are curious can still get the result
> through the 'infos' device attribute.
>=20
> Update the comment about HWRS in show_infos().
>=20
> Reported-by: ryan <draziw+deb@gmail.com>
> References: http://bugs.debian.org/692436
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[...]

Ironically I forgot to cc:stable on this one.  Please add it to 3.0.y
and 3.4.y, which also got backports of commit 8871e99f89b7.

Ben.

--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-1uzz9gv5enQWpVwfHOAg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUfSKee/yOyVhhEJAQoXpw//eZKZDQ1JIN6L+5CrwET9JEdPpPZWsjvZ
S2yMLbMZ6GnY8Q0Cb41ZUmvVOsd5Q0kvMknTldx4ixUCmZ6lN5P11O1NbCIdWSzH
YFbcNQ+ohfgs+B8Zx58ZVdgMHo5jVrpFnjT211FSWhJAVlcDH1sk1VEHLXuwFOam
BCCtX/IaiL5F9z2kKGowpuR2zyAAZ9xpEsp2o04c+lWat98a7aaIuRW5VWxK8R/v
8IJHVuI/NOHIlxKoAOMXg4kX8kDmU4sCX4Wjc/4w9JyC71abEGcWirEQeAMjwJk+
dv8zkCro8ZgLBU4rC/LBdB/MbaNkUqa4c2frlpJlRBPdEIj1Z6TgbxnaNznaEXuJ
jbxLYoQp6h6+wlT9UVyF1Gh/MAPsP5OEbEIePMFURkhqOEXQ2frOAn+KxiiycrlW
vgToEvw0s42LpxzGoclnYmf4YQeb3MK1CxtA5Sk6xWH7liZHPy8MDM7TxgF3zwHX
MugiUX5BCNR6Zt5OJgLuDtjG7aYBL/L/6R3eXi1Tn3w+wY0mXut7JD5s0BJnm6aM
BuR1uk21ogOumOq53zx6qbN5PlKHwb2td5+N+kzpwkhmknUpbR3By4bxFwFag3w+
iHJ10HQYIJBGbD3S4JsMz9odsCs+lA4+Q/+r1CawRUjTnqkW/dREdBoJ/ObEpeXX
JTwoEQETvnI=
=64mo
-----END PGP SIGNATURE-----

--=-1uzz9gv5enQWpVwfHOAg--
