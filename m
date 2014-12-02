Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbaLBTSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:18:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41860 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaLBTSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:18:38 -0500
Date: Tue, 2 Dec 2014 13:18:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: randconfig build error with next-20141201, in
 drivers/usb/musb/tusb6010.c
Message-ID: <20141202191836.GN26934@saruman>
Reply-To: <balbi@ti.com>
References: <CA+r1Zhh_NDBucW1Nz1Ta=z9SDUqB-bzgMZoQ73Tp3uK2uaP0XQ@mail.gmail.com>
 <20141202181316.GE11700@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8WA4ILJSyYAmUzbY"
Content-Disposition: inline
In-Reply-To: <20141202181316.GE11700@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8WA4ILJSyYAmUzbY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 02, 2014 at 10:13:16AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Dec 01, 2014 at 10:00:35AM -0700, Jim Davis wrote:
> > Building with the attached random configuration file,
> >=20
> > drivers/built-in.o: In function `tusb_remove':
> > tusb6010.c:(.text+0x16a817): undefined reference to `usb_phy_generic_un=
register'
> > drivers/built-in.o: In function `tusb_probe':
> > tusb6010.c:(.text+0x16b24e): undefined reference to `usb_phy_generic_re=
gister'
> > make: *** [vmlinux] Error 1
>=20
> This looks like a phy issue, Kishon and Heikki?

Tony Lindgren sent a patch adding a few dependencies to MUSB's Kconfig.
This bug has been there forever though, so I'll merge Tony's fix during
3.19-rc1.

No clue how come I never got this as I always run 300 randconfigs on my
pull requests before sending them to you.

--=20
balbi

--8WA4ILJSyYAmUzbY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfhCMAAoJEIaOsuA1yqRE72IP/iZIU/Ybpv/4UbTcfdZT2R0a
mgto4tQvZ5NGoqIE4NV7cz/MLNiMOwlVe0f6iu8RoVDAfTC/3GFmhWXnqg1kjMOO
1SkjkAMPC9iiAIDpCVUlO7Q28y92G+SgWriGRsOJXeeRO67R/gODGWzRv1SmmJxZ
lFRyI2c30go7FgfSHvF7OzLc8HYkmfftgsZICreZ9+ZPTsurV1snBrjes0aOaasF
rb4jgDrrZBvw2Yi9CO/iMIxvJpytkqrsfa8gNiRupoo4zbWHRF1JlEavn0Z76SWZ
PwTtVGZIjIC90/OuAbxCTErRWrWFkKWd5w9JteHuHXCH/uJ5e/DrAFkmmQZ90HDJ
GZ3PbDF2Jw8nLpNsfZRMbogJQ3a8Roj60RPFEdMNWuDXZkt807kXkMijLICSmqrx
zGKY4zE9LZzAF4H3QavXDgBA9FvpfNmWvUQTTMkkO8sPCB3yAscV2bFlopoOWd5u
sQM93XRiIrCVia8kHlYlpt9xUTVaf3oL1e/W8IIgnELOqHrlpYUwxccMW7r52f0w
x03hmKm8f1WH09Zga0YJBl/MA2BxoDwUJvDwC/yzLjlwzDaMCar0AuqBZSwwiKaO
F7N+UuEGo8j33Ao/X3zqUcZr0c6LH0VkTevtec6/s+9Bdmm6iwD4eVMJy9CgtkAp
WN9SC7WDfehMtplPK8iE
=Llyo
-----END PGP SIGNATURE-----

--8WA4ILJSyYAmUzbY--
