Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3BRUEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:04:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35582 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab3BRUEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:04:54 -0500
Date: Mon, 18 Feb 2013 22:04:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Borislav Petkov <bp@alien8.de>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218200424.GA20137@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
 <20130218171334.GA31329@kroah.com>
 <20130218172700.GH2663@arwen.pp.htv.fi>
 <20130218174527.GB16628@pd.tnic>
 <20130218184735.GD10755@arwen.pp.htv.fi>
 <20130218194031.GD16622@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20130218194031.GD16622@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 08:40:32PM +0100, Borislav Petkov wrote:
> On Mon, Feb 18, 2013 at 08:47:35PM +0200, Felipe Balbi wrote:
> > On Mon, Feb 18, 2013 at 06:45:27PM +0100, Borislav Petkov wrote:
> > > On Mon, Feb 18, 2013 at 07:27:00PM +0200, Felipe Balbi wrote:
> > > > No such device - /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
> > >=20
> > > Looks like your edac module doesn't allow scrub rate setting. Which e=
dac
> > > driver is that? dmesg?
> >=20
> > $ lsmod | grep -i edac
> > i7core_edac            22414  0=20
> > edac_core              43453  2 i7core_edac
>=20
> Ok, that would be those i7s which reportedly do
> not support reading/setting the scrub rate, see
> 27100db0e0d381d24b6f3cb1a4f439996e7c00c8, for example.
>=20
> So this is as expected.
>=20
> Maybe it would be more correct if the core would return "N/A" or
> "unsupported" or something to that effect in such cases, to conform with
> the readable flag of the sysfs file.

yeah, that would be cool :-)

--=20
balbi

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIolIAAoJEIaOsuA1yqREj0kP/3hFR/URdWEw9WcOFDiNdWIN
/5YcbsTYhlIEOw7METYr+zgJ1yrOqbRkgn+yIzxq+notK0iqMoLCfMcN1VApEzH1
c929n2+utyDAHCarmVSAIR3fXA6u/63StLYSB5IOicFIZb4kNp3waL87Z9GzUCCA
MtPRAua7EDYxJiAmeMrcrmrKIgt1MuPWttkLn2ZqjO5+oBO5Nw/XAOkHskbFMrjF
law0Bwr7uwK8Bt5SPXlr3Ir0BOW15HJoU0suL5R8/Ble1tavYifGBVLGTqC1qR+v
yfZHuDko2As97bwjj/pkshZR0g/BLjJhD54dZaJ4RciqwYm9GEyzeUCSBtjwsI8E
Kc2a0pXLdtkV6dLHm6JVPJtRl5Gp6UDe80xmN6OfmGZINnUZZltcl07Acp3JQQK8
m6kyba21bfSEy30PYc4feilnx9fk0STE84ZbqmpFp7jYXotBS17yWqH3d7/2jm5j
EyWO6C58X1hMOiS7Udz7PsD6ChKcuz5ljsulU3K5nzLgTWH3L8RYpCqtj32yWKef
IijZE/7fL896a9NBERBqa6flSg/2rRvvVPFdCW2hLeKigaUSnxlEboaDpzMI098r
BgqOPSGBHH3sfTFIbJwWgwajTac8fNyksCwjEOStkjAYd6yjmknSn6GR85lpHuK3
tkTkFoAsZuJT0FkcTzUV
=oFXg
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
