Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab3D3G1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:27:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33884 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab3D3G1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:27:08 -0400
Date: Tue, 30 Apr 2013 09:26:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PATCH] USB patches for 3.10-rc1
Message-ID: <20130430062624.GB4776@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CA+55aFxi+PHvYwxLJfo=YG=93maOD0cQYVdjvG8kzEhpOZykpQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
 <CA+55aFzOf3tE=Mbrrwt_aOn6GdUv26VnJ=wsmY2sYC90-aUfLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <CA+55aFzOf3tE=Mbrrwt_aOn6GdUv26VnJ=wsmY2sYC90-aUfLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 29, 2013 at 02:31:59PM -0700, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 2:14 PM, Alan Stern <stern@rowland.harvard.edu> w=
rote:
> >
> > What other things seemed odd about Greg's pull request?
>=20
> The only other thing I noticed was the new CONFIG_USB_PHY quesiton,
> which is not something that I think is sensible to ask from a user,
> and the help text doesn't really help anything either.
>=20
> I think the question may make sense, but the wording does not.
>=20
> *EVERYBODY* wants a USB PHY. You can't have USB without a physical
> layer unless it's a purely virtual device. There's one in a EHCI
> controller too. It's like a network chip - without a PHY there's no
> point. Why ask about whether you want to support a phy or not? The
> question makes no sense.

right, the thing is that the standard host-only drivers (EHCI, OHCI,
UHCI and XHCI) still don't know about the PHY layer. They give no
SW visibility on the PHY at all so I felt that adding unused code to the
x86 binaries would worse than just asking the user if they want the PHY
layer enabled or not.

In any case, *HCI drivers need to learn about the PHY layer, at least on
their embedded forms (OMAP, Tegra, Marvel, SuperH, etc) since those will
need SW control of the PHY for e.g. PM, remote wakeup, and few other
cases.

> So I don't think the question should be "do you want a USB PHY". The
> question should be "Do you want a driver for some of the specialized
> external USB controllers" or something like that. Because as it is
> now, anybody who actually reads the question is likely to answer "y",
> I think, even if he just wants one of the *normal* USB chips that
> don't split out the PHY.

makes sense.

> Hmm? Or does PHY have some magic other meaning in USB circles? In

no, it means the same thing.

--=20
balbi

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRf2QQAAoJEIaOsuA1yqREtwgQAKt4/0JzGZ9SY5/ex3OzKcud
F1uaJ52AXrvVjJ8q4py2dhzuyDU6qV9Chaw3xiz9ZptRxwqc9bbHV/zJoK9Ebw8N
AaIo6Av3cl6YZNl9UnLrHicdjivz8PzDSkke3sbAdyVquG2cKwklK2iOKDk2ro/u
YZjO2sJM2TU9thFUiNXBdMeDGZci9IJYGRhG8xLP2Vnp9g6h7SIQ+qU5PBv9CaOb
nG6ZhCP+TBD+ulXD/eVcNtw/9JONzMcBFZ5W38EAsngzriDK0Y5Pa9uj54q3cQsU
JN2Hs+j+SAVaaUDrTa4s0/qnCXMtRCY4f/tYrErMzH28h+HiTC/JuMp+pLvc99h5
X3uKEPp9lZcsLB8HBUg0/ztVb53r4HwNQjn3HBvslHvnnCg1KGFT5DhPcuopxIGa
ofy80yqjYpvgydmEGaFYF7+0i5kvzTKQsn7wrNOKU7jO9y8rD0ZdsQgvOBPWKM0J
n9D1sqcymAxOfnBugdJjan9VgGgu3As1KOA5SJeT9wB6Yna/1a4JVIUc/D1lOhWT
21ZGMRCWF1ilyXDEgV+kGTDHDZ3f87COuv9yGggIqiTDvpMQylrjOSamzFrkWHBg
F3lzfyClxWVhM35cR/ClTvvMQw5PbqZBSWKJXn2YewgoghLHHztXxCNUqX0TA2bi
uzeGsiTuM8f7twn6Cici
=KKlE
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
