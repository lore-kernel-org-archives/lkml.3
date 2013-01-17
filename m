Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3AQNPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:15:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49352 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3AQNPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:15:22 -0500
Date: Thu, 17 Jan 2013 15:15:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20130117131510.GS18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
 <20130110133818.GA22710@balto.lan>
 <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
 <20130117105104.GN10814@arwen.pp.htv.fi>
 <20130117125702.GA5007@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHrxbAcqt/LxKPZN"
Content-Disposition: inline
In-Reply-To: <20130117125702.GA5007@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eHrxbAcqt/LxKPZN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 01:57:02PM +0100, Fabio Baltieri wrote:
> On Thu, Jan 17, 2013 at 12:51:04PM +0200, Felipe Balbi wrote:
> > > > Thanks for the ACK.  This bug was here unnoticed since 3.6 merge wi=
ndow,
> > >=20
> > > Then it should have Cc: stable@kernel.org..
> >=20
> > just added to my tree.
>=20
> Hi Felipe, thanks for adding the stable tag to the patch, but I actually
> made a bit of confusion with the versions, so I double checked and it
> turns out this is really needed on v3.7 stable, not v3.6.
>=20
> Will you be so kind to remove v3.6 from the stable tag from this
> patch?

rebasing a "stable" branch is the most annoying you can ask me to do, I
will do it this time and hope I don't break anyone tracking my branches.

Next time, please be more careful.

cheers

--=20
balbi

--eHrxbAcqt/LxKPZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9/leAAoJEIaOsuA1yqRErrAP/A1bQaKb00cO/KyVPY7kUJbv
OGE4dzdu5zm76KDQ4JwHX47KqxFWj5Hr/oKUfbMgT/c4fhAVGgdposkqeTy5y+EP
VhYKpUDkaosfJZ4fJoxko3DDZyUq76Rq+iLtQhyCgy4v6eycctg06wXj9z2Ynpco
A/IFzsRjZpKx4tm27zqF3cP+F+CptS2Rpzx4Wfz0uAdOZVXTvKkig5To58HK6FQS
2lEObP9TWKcijdXfW5PEC70QMznrquWICibShFYSJ8iZNWk4ak7aPieS96cXoXoB
RhewtczXv2RkbTFqnxWZV7HAYBgruqvgkYMK6dZi6a0XFgsGUF3UOMiuJki4zhO5
SpsD3IdAQJoQnpbAUpeXjWCTaiBsQaZ4rayzCzisHDqS6zF6u4GpCAaSX/O0wMwS
qygQVjhbKUUpnDzNh5imZxdnqVB8dPg0buUB/1NSYd4qEDFfmFiEgVE8I5R4TpIW
LIxApDTPcnyKbL9j43vHvRVNl/KUm+xP8EXaSnlOSGsGPPuUlkuW1bBrqF5+h8Tv
icLaJ0ctkJo3jqQHWKgVbzh3ns0tM5/D1XeIswjpg0p1vePU0KMrvlTygWKmVe1d
HdHXaKLG7fMEj5wYR7SMzRDIZF8IhYOuWr0HLTMx2dUlMzSDgrcQ5e7+DRhh2Nda
cnL9YUzYY6i5yxQRgn9U
=RAnj
-----END PGP SIGNATURE-----

--eHrxbAcqt/LxKPZN--
