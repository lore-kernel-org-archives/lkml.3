Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaA3L0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 06:26:08 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32892 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaA3L0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 06:26:06 -0500
Date: Thu, 30 Jan 2014 11:25:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140130112558.GJ22609@sirena.org.uk>
References: <1390900898-31579-1-git-send-email-geert@linux-m68k.org>
 <20140129180009.GF22609@sirena.org.uk>
 <CAMuHMdX+EUUHxOgc8RF=C=qdYiOc8h+su4r-=HAhWXUqEivSvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+RZeZVNR8VILNfK"
Content-Disposition: inline
In-Reply-To: <CAMuHMdX+EUUHxOgc8RF=C=qdYiOc8h+su4r-=HAhWXUqEivSvw@mail.gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] spi: rspi: Add DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 08:10:34PM +0100, Geert Uytterhoeven wrote:
> On Wed, Jan 29, 2014 at 7:00 PM, Mark Brown <broonie@kernel.org> wrote:

> > well?

> As there were no code changes in v5 of "spi: rspi: Add DT support",
> Patch "[14/14] spi: rspi: Add support for Quad and Dual SPI Transfers on QSPI"
> should still apply fine.

> Do you want me to resubmit?

I see you did actually resend before I saw this but yes, in general it's
better to resend stuff.  If you start applying version X of one patch
with version Y of another it's more work and there's a lot of things
that can go wrong between user error and unexpected dependencies.

--x+RZeZVNR8VILNfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6jbDAAoJELSic+t+oim9rAAP/ilbsPSWzOwHbOccXYNkFtmv
i29xa74m/5BXZQo5k8tG/kqzhRs+6/s90ZML3f0HlFMWXDdUmN1KVBtHxZAuU4C4
r9I+AyEdbqw1hyiqZ9D9goJxYHzu3Tg1sQv5WUCK81aUVHiC6cc2t3dyNau+HHO0
zAtUAC6E/AtZ5rXtKhNgkkJ1SOTNg7/O4IVq88Q2Ft4/Kd9I0/QvkOjGRU5Y+UDY
GwyFnbu3henK57WAa7VQc02SQVKr+4MWa9PzRMfoYTpaXzy6iMyXkOe+PGpRfbQh
c2IFTCwOk5LAqFyAvdB8KU38ZytxE09ex9ZRACTRG2hxsExCNMGdtwgJJDAp1aS1
5qTNrzFhbfZIE9MpQddHEl8QHjQGh8UtjysAyZQz46ghyF110aKjIsyzQxCcTqLr
mnHSZCSHNHUejfuhK8htvwoqg4Ii6UWwGta3hhNVSKICHuQZx+IiOzqr7IEDk39F
y6hhzuGm+q3uDCnr2CdLUuQ0Dty9rcvXfezkhtTbh3eKPK6S01g4b8L7VNQNj0//
orIiTbn3p23BmmH2jub6LE91eReUAcy8R+Csq6jq0un0UfyhGaFYussTgtGX2P24
zk3+z3+wkVe0uap3rZbyhKO7cR92Y5sevPcvJgZw2kQgkKau+hQMbxz2rbvQBwDD
GdUCNteEXwVyjhSzagak
=9TkV
-----END PGP SIGNATURE-----

--x+RZeZVNR8VILNfK--
