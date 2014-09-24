Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaIXTj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:39:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38910 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaIXTjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:39:53 -0400
Date: Wed, 24 Sep 2014 14:39:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <Peter.Chen@freescale.com>, <stern@rowland.harvard.edu>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <yoshihiro.shimoda.uh@renesas.com>,
        <linux-kernel@vger.kernel.org>, <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v6 1/2] usb: rename phy to usb_phy in HCD
Message-ID: <20140924193942.GR17997@saruman>
Reply-To: <balbi@ti.com>
References: <37148636.BU5lT4M4eC@wasted.cogentembedded.com>
 <2300651.HNvMzB0aUB@wasted.cogentembedded.com>
 <20140924192806.GO17997@saruman>
 <54231BFF.5070901@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffBYM5qgR8HH9Mta"
Content-Disposition: inline
In-Reply-To: <54231BFF.5070901@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ffBYM5qgR8HH9Mta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 11:31:11PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 09/24/2014 11:28 PM, Felipe Balbi wrote:
>=20
> >>From: Antoine Tenart <antoine.tenart@free-electrons.com>
>=20
> >>The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> >>modifications are done in all drivers accessing it.
> >>This is in preparation to adding the generic PHY support.
>=20
> >>Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> >>[Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved reje=
cts,
> >>updated changelog.]
> >>Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >>Acked-by: Alan Stern <stern@rowland.harvard.edu>
>=20
> >Acked-by: Felipe Balbi <balbi@ti.com>
>=20
>    Sorry, forgot to collect your ACK from the previous posting. :-/

don't worry ;-)

--=20
balbi

--ffBYM5qgR8HH9Mta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIx3+AAoJEIaOsuA1yqREKlQP/ilSdXJbAq8hq/pE2JDK3q+P
A8zFNo5Kjpz0wuUFg4KaP9s/rPx+aLPdhSTuPTXobe+J1ayYAO5g0JgrDOOQ/BI5
WF9a64pZuHJjSK5lp8LgjZ5GXCsJyy75SOCAjrsdZD1Zqhoo4g151YlxTcC3ZUCj
NXtrMzH1uYDEz9p7t6laFus8s+UyVTahEeQyYLiICW72uRIygtiWDZulhwoiSlSi
IcYfuJmumvgmPnC6J3ym+Muh65TjVzyods3KDT/qbNGpYJkk6yWICb+OS5xGt3mm
8e5pyRnlCTMH2M1Do5kUwMFNlH29m41iMIypqZZqY0Vi/QfIKZFo2iNPNPHNBNmg
rSBA6RqDzIeqGcLa6FWPGeFPiTRl/XL4+x4tWaWkGFnedsTY11eX0kC04wPtShQS
e795+RRL8TOInyStcpN2srnnDzSIhdAcKjM/kdcMAaHv+h6FZTFolm6pQRV9PNbZ
kl4iO1apq9mUhFURsN6I3xL6S447jTpjN+G0zSZm5kpClc0zuFTjmBQH0bKydrWM
H1cI1/PjTo2qNrrfKMswur5SwSUZI/PY0lk4jifZqLD314PR3W+fwQYiomzX6veh
M5D+D5tDy+SPNM9CZ5ms7Uaj1cd8m7TGyjyZ0UqSrc/CBBgJMeDTnfuIIB5Mtc+B
NuUPT9yX6NpVl45S/NPc
=aVIp
-----END PGP SIGNATURE-----

--ffBYM5qgR8HH9Mta--
