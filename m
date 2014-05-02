Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaEBOXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:23:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35926 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbaEBOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:23:40 -0400
Date: Fri, 2 May 2014 09:23:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH v7 16/20] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
Message-ID: <20140502142332.GE4631@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
 <1398354495-20782-17-git-send-email-iivanov@mm-sol.com>
 <20140430162705.GL23679@saruman.home>
 <1399009745.5109.0.camel@violet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <1399009745.5109.0.camel@violet>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 08:49:05AM +0300, Ivan T. Ivanov wrote:
> On Wed, 2014-04-30 at 11:27 -0500, Felipe Balbi wrote:
> > On Thu, Apr 24, 2014 at 06:48:11PM +0300, Ivan T. Ivanov wrote:
> > > From: Tim Bird <tbird20d@gmail.com>
> > >=20
> > > Fix the value used for Parallel Transceiver Select (PTS) for the MSM =
USB
> > > controller.  This is a standard chipidea PORTSC definition, where
> > > a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
> > > Fix the definitions and use them correctly in the driver code.
> > >=20
> > > Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> >=20
> > since you're the one sending the patch, you must add your signed-off-by
> > too. If you reply with your SoB I'll add to proper patches.
> >=20
>=20
> Sure.=20
>=20
> Signed-of-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Thanks, I also need you to SoB the other patch from Tim.

--=20
balbi

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTY6pkAAoJEIaOsuA1yqRE08oQAIaIKO1KWpK+p6DeVWLSAaR+
Qq7Q3shxRvxvY+TqcMd2LaN3acrv4M+GJiR/BPX7yOSVN3GMF3jwi11mdBDqfoBb
ZM4Q4ke0wQSJSep8aRwdeTFYOuKbfG7gElr8P2rJmwSIOcb31lsIhEDIJ8Y5vktM
Nxwr7IZQY/W5TzPuTTE9Ob7nHyW5YW1Svu8iIoUZBhyCIV7mBA35JWmYOVg+slWF
f5++ke2ucguNupDWLO5mhKt9mGCqkEsnJRz78h5HCTsK8F9E/dKwTYl1TKyKYTvq
8UUN17sK/pxH+jfcrJzpiRqgk1+dsXck3PS1YZTrG4S9I1kqpN5duoWqBCvI2oXO
o95uksfhhQK7TCnWUteRyC2WRm1Iuddnj12qxurNooTY81IfAdQXx6Xh/ErbHQ+9
XRtH13uSiRp3hSZe9E2oBcRY73JOWqOfqUF6BTIKMRu/lijyZSLE5jPrLD2LIxuC
iSOss6noYGlwUNQ6mpyeB95dcJNCd+0TQH0gHzDzGQOEkdKcfntd2JRHi6hE2M3r
uAIlM7kYDu/YLgqwxFir0sYCXY4St6jn4cx3m4WaPvUUqNZU+IZgmw48V5G//Pfh
3pgPn2j9WIfffIi9ELQzrwgtp65sYq1Pi6WDzPxoRInDM4UVWfmnnHmjej/Bm3Hk
bbh54mim9zi//QIVyxr6
=HfcQ
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
