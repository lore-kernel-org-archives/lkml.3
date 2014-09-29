Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaI2OHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:07:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaI2OHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:07:16 -0400
Date: Mon, 29 Sep 2014 09:06:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB changes for v3.18 merge window
Message-ID: <20140929140653.GG32403@saruman>
Reply-To: <balbi@ti.com>
References: <1410976602-1536-1-git-send-email-balbi@ti.com>
 <CAMuHMdX9mSv0H-fS23KKONO+=aiCtZ5fxZBvbBnhCev3DffkCQ@mail.gmail.com>
 <4470421.xsts97VC3x@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8S1fMsFYqgBC+BN/"
Content-Disposition: inline
In-Reply-To: <4470421.xsts97VC3x@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8S1fMsFYqgBC+BN/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 03:35:22PM +0300, Laurent Pinchart wrote:
> Hi Geert,
>=20
> On Monday 29 September 2014 11:31:30 Geert Uytterhoeven wrote:
> > On Wed, Sep 17, 2014 at 7:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > Andrzej Pietrasiewicz (23):
> > >       usb: gadget: uvc: rename functions to avoid conflicts with host=
 uvc
> >=20
> > It seems not everything got renamed:
> >=20
> > drivers/usb/gadget/function/uvc_v4l2.c:363:23: error:
> > 'uvcg_v4l2_get_unmapped_area' undeclared here (not in a function)
> > make[5]: *** [drivers/usb/gadget/function/uvc_v4l2.o] Error 1
> >=20
> > http://kisskb.ellerman.id.au/kisskb/buildresult/12028115/
>=20
> Indeed :-/ I should have caught that, my bad.
>=20
> Arnd has sent a patch to fix the problem, I've asked Felipe to apply it.

another one that my randconfig tests didn't catch :-s

--=20
balbi

--8S1fMsFYqgBC+BN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKWd9AAoJEIaOsuA1yqREYB4P/2hcLu4/Tjqw1FZVxJpwJ+Je
KofqqlC12SGCIjs9jexH2EokeuykSh6uxnWSEWbu3wOmW7XkrycHWLtW/QVYLBIt
TjJI45SVajHiW6xGH9L0TQz8RVl2dMn5hdXkUQ10Aea5BdFSd8nYttpsb/AdD1Xd
/RGtTUjfAxU28NT2gjhbg8DGsD8TgjiJgOiyNQxlgnsQNlj+/t2pguOuzd8/R4UC
ui+rOw+uK6CzEVNJG37EKZwioPs31sMUqOwgfoWemMPmgXICp/2cah6hJLp6vviS
X8SyeK6KpiX3PabVO/8RSz4oYQo1uQgH8VfimnGl/WMXcmy1PwJ+ZXScz7SoobQn
FK0ijyVpS+szbkSyTZ9x0n7OLllIshig9NEJzKlxCCMJ5uEKVguD+5+vNcpRvGpS
Fg+6YQiEvofWulpk0s+OAinQYm5jXW8H3o0nvt+yRS5YzjwTBJJUaG/Y2Z1UyjHn
R7nQ4JBRVJw0QG9DbVJuKnWBUazTaoNlKEuMiBoQySvGtJHabgHJGH00PFsvT2XS
U9KznnVzi59tQRyvWDG+1c8c5iOfJZ+DCCLHZUWA4kQHwQ8rpUoNTsHt5CH50KlZ
asqhdi7OFfe1EdkE1DgverYRlsJkQf0d78j5pcsv+nibBB5YFoRY6+7KuPxg5uNX
7KsXO/X0zYyfSYWOEb84
=Z704
-----END PGP SIGNATURE-----

--8S1fMsFYqgBC+BN/--
