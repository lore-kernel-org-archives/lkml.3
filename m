Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbaIQQtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:49:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48192 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaIQQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:49:13 -0400
Date: Wed, 17 Sep 2014 09:49:06 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Message-ID: <20140917164906.GK7960@sirena.org.uk>
References: <2443447.AFyh6VXdN9@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kJESre7KIk3SwaPI"
Content-Disposition: inline
In-Reply-To: <2443447.AFyh6VXdN9@diego>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fan53555: fix wrong cast in probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kJESre7KIk3SwaPI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 01:21:48PM +0200, Heiko St=FCbner wrote:
> The vendor-id gathered from the dt match-data was cast to int but assigned
> to an unsigned long, producing warnings on at least sparc, like

Applied, thanks.

--kJESre7KIk3SwaPI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGbuBAAoJECTWi3JdVIfQ2kIH/0bep5+zjjZ42pd+oApwbdmk
bOTIyLQuxji0VFvs54rH7G0l1HbiWM1w0JklDS1XEh6jkDxGtaCP0j5fAvX1BRwe
9nLIvVPZaQ/2m4R8/eqI/8z3V92Zd03RKd68VTd73xB6vevh57t0UnCR23z95Gsi
4tT3RNcJNJQoekI6ikZ2JZGu+mO1Jo8EeJ3wZ/D4Xk3xED7seV1FHzaKR0LEPpF5
XHELFYEXkPRu4ley7ui5jKjcmGCXW0OAy/xKuJDWCeOB6/38odmHrA2+98BpmcEW
XLykieXRwNTbx3CKpjfbiWna3kcU6ZxXp5SFmRcllFYBwkY2Ckd6YTj6zz0VsGc=
=N4iG
-----END PGP SIGNATURE-----

--kJESre7KIk3SwaPI--
