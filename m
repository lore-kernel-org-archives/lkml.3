Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbaLBBwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:52:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52118 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbaLBBwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:52:10 -0500
Date: Mon, 1 Dec 2014 19:51:18 -0600
From: Felipe Balbi <balbi@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>,
        Felipe Balbi <balbi@ti.com>, <uwe@kleine-koenig.org>
Subject: Re: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Message-ID: <20141202015118.GA1891@saruman>
Reply-To: <balbi@ti.com>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
 <20141129094823.GA10840@linutronix.de>
 <20141129173418.GY2817@atomide.com>
 <20141201140914.728aaa46@lxorguk.ukuu.org.uk>
 <20141201231338.GA14524@fuloong-minipc.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20141201231338.GA14524@fuloong-minipc.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 01:13:38AM +0200, Aaro Koskinen wrote:
> Hi,
>=20
> On Mon, Dec 01, 2014 at 02:09:14PM +0000, One Thousand Gnomes wrote:
> > > Well the nightmare userspace switch from ttyS to ttyO few years ago is
> > > something we want to avoid.. I think the best solution would be to ma=
ke
> > > serial-omap.c transparently provide support for ttyO using the new 82=
50
> > > code so both ttyS and ttyO devices would just work. Otherwise it will
> > > be years of "my serial port stopped working" questions again.
> >=20
> > Thata a udev problem not a kernel one surely.
>=20
> People also use serial console to observe the early kernel boot before
> the userspace is started.

right, we need a way to tell the kernel that ttyO%d and ttyS%d are the
exact same device so that console=3DttyO0 and console=3DttyS0 mean the same
thing. That maintains backwards compatibility and lets people move on

--=20
balbi

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfRsWAAoJEIaOsuA1yqRErUsQAJA0mMvj/k5W7dCe5rAQ6FjD
wcFKbU52iQvQVwT5M798eW1egOzt9IKPQ2ykIE5Da6ozkAKCH/CHfU8jwC2DkLvP
SkzfhyOk/U+lQNimBZBLnoW6GggMx45OzumABuiJR+Ak3kfixAHQNedPvTHl10mg
yN318m4QPf9Bt50Hp236H7uT7sd1Y6z4mtMS34Nu6LPJqKsJVvIvobl46PDCLRua
kzxa1dyv4SL1YI/6WnN6SDigf01WKLaTabkPQGd8Q2Cmdxv3kshDQQ2maXPndl4b
NSegaR6S7YAPa39VTB9Nwa1Z/MXyrZoVsifzWR8dM5+QG3skIr12l7gominRcn8e
uGdrKTpIEXYBULeodjIma5MtqTbdQCgPrx2/lK2ecAeiXLantaB5A08an2cwt4Xv
BkVJYWFzFQiwvw/RrhgofmOZNy0F9E7ee20efUwYhfWADs6dS9HTabkdz7+wHBRZ
pWaOk2zMPpvBWeTYTsDJW9uXZQ6L98gs6H7C0tACZZ7Ri9syG8HFVwH94T70jyvF
zVRF85ZOp340W8JhrtYW0huHT4h/5+SwAo/ONODBAKnNAI0hAuMrfjLRJg4xnhGy
ZqPrnVlcRYgBfuW+a78Q+4jV6UtMrJ5FuDxppC+Kq52gIzD9K/mu4KJp1WbEWI8s
1ohZeS2I4WqpFz8yr6In
=VBGz
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
