Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaFXLB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:01:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55543 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFXLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:01:55 -0400
Date: Tue, 24 Jun 2014 12:01:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Alex Courbot <gnurou@gmail.com>,
        Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Message-ID: <20140624110136.GJ23300@sirena.org.uk>
References: <1403556805-22824-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z8yxTSU1mh2gsre7"
Content-Disposition: inline
In-Reply-To: <1403556805-22824-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: fix typo in enable_reg calculation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z8yxTSU1mh2gsre7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 02:53:25PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> When setting up .enable_reg for an SMPS regulator, presumably we should
> call PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, ...) rather than using
> LDO_BASE. This change makes the LCD panel and HDMI work again on the
> NVIDIA Dalmore board anyway.

Applied, thanks.

--Z8yxTSU1mh2gsre7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqVqNAAoJELSic+t+oim9WA4P/iiRFO2DcyLsf2kXeve75xXW
RA4TyjYs0oLnpYymayeEnfXT/w6Hm2moTJGGuk81MxQRauTHaFKc1DwSRaXK/JMg
WBfytAkTezbsOc8mvAiaRixlvRdGyg4jvbi2Y9gMWa6eJn9pMxtRCTwxsbLecnWJ
ws6zO9pDQkM4ien10rpkaE+KZlJYWMFa2tEn3KT7gJhfO5RWJ9A7fIl9VW4DneAD
0dNH8ujcC/LnuCLxnzLo6urrRCZkItjJe+oVsy9FKEMeGzTWRKtfDiviJBJirvxh
+jHiIkoVGknArfg0el904a6ZNnBx26kM3cFk6Ee8Wp67dzaoDYbRNrEuYk0SJMn0
6Pc+9rjyNB68QEacxstgwYXHJFPMmO1LHX6xKhA50MoEoah7dHONx9Kolmr5jwu5
hZ9qLE3TiWUal+N1sji26sX3aLrw6ZQYjSY8ij/kQ3jV4RuVke5p3/hfqHFgS0cF
mZu2oRfT4+vw3oVlAO3e24mpwGzx/AVsUoyG34HImlFrxpHmGtM3/MS8myRmL1vl
nnWcCR4GSjQ3AHJvP8zvXgr0HStcfdBKxKzeIdQqzm00GaAZLLUx8AHGsJQEoPNc
D6MUZj31aurA1ZuZQ5BIFD4ugBktXh/3l0y2ise/b8WTma4ZCRjJKVqz9HJ54fBD
SuRoXZqfJlIsNv1F7HeU
=Ef3O
-----END PGP SIGNATURE-----

--Z8yxTSU1mh2gsre7--
