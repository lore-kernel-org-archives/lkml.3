Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3LPV0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:26:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45416 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab3LPV0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:26:38 -0500
Date: Mon, 16 Dec 2013 15:25:51 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH v3] usb: gadget: Add UDC driver for Aeroflex Gaisler
 GRUSBDC
Message-ID: <20131216212551.GG12896@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386144838-16403-1-git-send-email-andreas@gaisler.com>
 <20131212180106.GF1939@saruman.home>
 <52AABBCE.8000709@gaisler.com>
 <20131213195234.GE5292@saruman.home>
 <52AE2C0C.80401@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUPx2O/K0ibUojHx"
Content-Disposition: inline
In-Reply-To: <52AE2C0C.80401@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GUPx2O/K0ibUojHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 15, 2013 at 11:24:12PM +0100, Andreas Larsson wrote:
> >>>Also, the way you're using thread IRQs is quite wrong. I can't let that
> >>>pass and get merged upstream, sorry.
> >>
> >>What is quite wrong? What is it that I need to fix?
> >
> >Ideally the hardirq handler should be usually to actually check if
> >$this_device generated the IRQ, that should involve reading a IRQSTATUS
> >register of some sort.
> >
> >Sure, check that IRQs are actually enabled, but you also need to read
> >STATUS register before waking the thread up.
>=20
> I agree that that would be preferable. Unfortunately, the hardware
> lacks status register bits that indicates whether interrupts has been
> generated or not. That is why the only check is if interrupts are
> disabled, because that is the only sure way to know that the softirq
> handler does not need to go through everything.

so it seems, fair enough then. Keep it the way it is.

cheers

--=20
balbi

--GUPx2O/K0ibUojHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr2/fAAoJEIaOsuA1yqRE6MQP/jbwTBuf7qbIRiIpWcC+lWas
JgTrfWYtTrJWOOzfmDc37BuMdbpfyIh0t68tZ6gHp9pPN9zEwyLmJPvr7op706T3
s9+Dn2qkiPT10YKXkdgyN0y4QZx3wbd+AAa8o7VCRPIA7m3tALmvbsw1gC72n958
nZfkYAS4JAxysog4rBYCz76RtNCVwNHGeX2PIBH5uphNIS9R88h/QuoRlPwxbTO1
b9RTIcTq95VSCUyDByQJwPA4JK14vMgF2CjnuKvkx2QK2/3s0VHWhSillzOZCaZ9
H2Pbz8oKMIsDYyFZm/WD2BkfSA1w7ZKICYSils/e2/dRLe9MJO5OS78SumNlpQSa
/XSR+bFitGkSjdUib0QKeI7RQZDF7+czysRsNzCkFI1PixmBqnBNi2DOKhjC8UZM
9mU3GH3LzQr+u72CyEjmJGve2jzrVGbEEeZH1d8VD+BfN8Q+9dcNwIMb8Xas2xZG
4PwHCbOBptZG26vFVTfCW8277FxMT2urDCtsWqiX3rIjWKcRjMe8BUOLYSacmOdG
BHqT+9ESEOHgSEisMi/qCvW2U0HIFfHPXP8i76xSOvZ9ang3f1EMfXE3zXcOixNW
wqJ/yiHYmrz7n8nUDUsIiCjQQ/Bg0JBextDDqKkOppJO/oBN8LtLHqHfTRaWa7hz
oS/MWiRnrWfmiqEcdHoe
=D5IY
-----END PGP SIGNATURE-----

--GUPx2O/K0ibUojHx--
