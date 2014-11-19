Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaKSDME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:12:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57698 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbaKSDMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:12:03 -0500
Date: Tue, 18 Nov 2014 21:12:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Bin Liu <binmlist@gmail.com>
CC: <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
Message-ID: <20141119031211.GC24874@saruman>
Reply-To: <balbi@ti.com>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
 <20141118211734.GA19146@saruman>
 <CADYTM3b9zSpP2yO2Lp5WOxBxB0yX=bG_20mFKQNGnyXV0XLOHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
In-Reply-To: <CADYTM3b9zSpP2yO2Lp5WOxBxB0yX=bG_20mFKQNGnyXV0XLOHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 06:44:39PM -0600, Bin Liu wrote:
> Felipe,
>=20
> On Tue, Nov 18, 2014 at 3:17 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Nov 14, 2014 at 01:54:46PM +0530, George Cherian wrote:
> >> Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
> >> condition. There are chances that we could get multiple interrupts
> >> till the time the babble recover work gets scheduled. Sometimes
> >> this could even end up in an endless loop making MUSB itself unusable.
> >>
> >> Reported-by: Felipe Balbi <balbi@ti.com>
> >> Signed-off-by: George Cherian <george.cherian@ti.com>
> >
> > while this helps the situation it doesn't solve the problem I'm having
> > with testusb on BBB when host port is connected to peripheral port on
> > the same BBB.
>=20
> Try to find a BB white (which has rev 1.0 SoC) to see if babble still
> happens, this could be PHY hw issue.

it only happens with my BBB when peripheral port is connected straight
to host port. If I use another board as g_zero, then tests work just
fine.

If someone else can confirm this is the case with their board, I'd be
happy.

--=20
balbi

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbAqLAAoJEIaOsuA1yqREewwP/3ZqTxjviwZvuqd0dO4LmT4d
TMsG1U12nEI1hfQiVXKX1YR48i/Phy9atXV8wUBu2+mIECJmyRFOOnSTdQR32sQV
6GOXMNDFY/Rh00KHOlcQRmVFTTKe/wDJLrkqTkD33awZGSe8wQ+AohYAPTFdJzgL
R8R9SIF94qCFY8Fww6xOk4daH4NWnGkxmYaQRSBQnSUuap8j5yxRu5+LzOJOq60W
aCz5c+IwIjyimu+wUwI5bIPEBU7lvYtOtT2rJkHysw37SitFTuqWYLNCCSmmq9Bo
DyAf6k2R+T2OKPgwiNC9vUxqFYG3QKH56i7NXMW/ojvzhsmWSf/c5L3l3Fx80YT/
GV+iWw0oZxPLDObHvAVx5t7dtBFPFXQ/4I5PL9gquH+aK7Rzrx8eo3tOJqOMCJQV
qWsaczAse9e/A7tYMJcldaqcdWHh8RQbJFG/D6L7SaQYnVqNHeIc8en/CE3RhR4F
adrxfiExcHLi8ot3ki5wFU6GzRkoM4+YlSMIHowvs7bxS8gWxHcMtDBq9/AIzxV0
+Vr8I2OhWvIJ/9oF9/wQ8R29wPFqc6JTVUh3EoA0T5lAFyI/YSSMYtxg0VY5hBG3
5oM3rB1vNNzPKhrtFbVHFLu6v5srsdsFrapF8WBXbpajE7YBkSr8B6A+Jh7nCeBm
jYlZwFOwvr0u+qsiRjYL
=IwOH
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
