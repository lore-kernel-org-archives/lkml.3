Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaKRUqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:46:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60525 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaKRUqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:46:50 -0500
Date: Tue, 18 Nov 2014 14:47:08 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141118204708.GR6179@saruman>
Reply-To: <balbi@ti.com>
References: <546A829A.8030106@linaro.org>
 <20141118003028.GA11280@saruman>
 <546B5578.8040809@linaro.org>
 <20141118151753.GB8223@saruman>
 <546B874B.8060700@linaro.org>
 <20141118180039.GJ6179@saruman>
 <546BAF07.1050605@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdnGiXwuH6t1Tqzo"
Content-Disposition: inline
In-Reply-To: <546BAF07.1050605@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VdnGiXwuH6t1Tqzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 18, 2014 at 03:41:43PM -0500, Jorge Ramirez-Ortiz wrote:
> >>> you have no clue what these mean, do you ? How about reading the USB
> >>> specification of even http://www.beyondlogic.org/usbnutshell/usb1.sht=
ml
> >>
> >> Unfortunately I do.
> >> It was easier to temporarily hack the driver code for a test - while I
> >> was at it - rather than modifying the host code.
> >> Since you asked for them, I though you would read the logs and wonder
> >> where the funny ids where coming from.
> > why do you even need to hack the host driver for these ? The driver
> > shows a Printer Class interface and the linux host side driver should
> > bind to it without any issues.
>=20
> the hack was on the gadget side.
>=20
> the usbhost test code in charge of sending the file to the device had the=
 wrong ids.
> to save time -since I was modifying the gadget driver code and only for t=
he
> tests (it is not part of the final patch) - I hacked those ids on the pri=
nter.c
> file.
> but anyway. lets move on. I removed those, recompiled the usb host code a=
nd sent
> the new traces.

then the host side needs a fix because it shouldn't really care about
the device ID, rather it should care about the class being printer.

> >> That hack above would have given you an answer: so I kind of know what
> >> the ids are for. honestly.  anyway, will send the new logs - it took
> >> me a while to find and modify the host test code.
> > Which host test code ? Why don't you just use lpr or even cat file >
> > /dev/lp0 or something like that ?
>=20
> it is some proprietary code that links libusb -part of a different projec=
t: it
> was useful as it generated some metrics I was interested in.

I would be surprised if lpr doesn't work for the same purpose.

> >>> do you want to debug that and find the culprit since you're already at
> >>> it ?
> >> probably: I still need to get used to this process, thanks for bearing
> >> with me on this.
> > no problem.
> >
> >> I spoke to Ricardo Ribalda three months ago while I was doing this
> >> stuff.  but yes, I might work on this -after I finish with this
> >> patch!- since I have access to the hardware locally.
> > cool, that'll help.
>=20
> notice that the original PLX driver was still far from the theoretical 5G=
bps
> target (I was expecting to measure at least 3Gbps and could only get 1Gbp=
s).
> So 1Gbps should be the target to meet on the kernel.org net2280 - do you =
agree?

this depends on a whole bunch of things. Mainline is a lot different
=66rom PLX's kernel tree, I'm sure.

It also depends on how many PCIe lanes you're using. Just because USB3
guarantees 5Gbps bandwidth, if you use a 1x PCIe connector, you'll never
get that ;-)

--=20
balbi

--VdnGiXwuH6t1Tqzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa7BMAAoJEIaOsuA1yqREppIP/1BMmTm/Z/2Lzarfuy5hCxLZ
IJFN9yClhZ5KB6Jv/SAFihUFNc4LfG4xmiGptrwvV9vQ3W8oP5mbaA0QJf+VtvGi
eQiJNWYjwe0Fg8bCclLOD3z0gR2dQ7YZoLL4slkd293Y7Ptwvqa5qzgckazvK9rS
IWvEk1KuNXQhZdw5cv1Y/b0KmXut4SRkHSIhb5SWL4zfnyPa2vq4h6tOAW1c/h5c
b07TJQr0+OaTP2oeLE11UUfs5tJ2zMAaLGzRmr/u4IYt4Ypoou9Fzmaf1XXg/W5w
ul4pW1JluAR7LIwKnFe34oGQKhLjV2H9+u+tdppX1VoABM3+L9RN73fMqBhKcW+G
vM/UMELp3GVpVruCzaKg0/8xY5lgGXfWIinNWIp3rjF63T0sdKsdnzzALOH0lWrD
uzlUlF6z2jzofdqdBXpVV7VMtVqX6efoUhcRoPtbC+mj5JFFe4SRaEjkL9mXMdS8
eS4TLtDKX08/podbAxN0KWTli5+PlA8EqohGANTnpCW/wtHaUew+TISnEryhPiwx
/JvYvQJs62g7Q1iZjiC++psrFegNp7fbSOlVRKID9W22hVe8Qwr1PwdZjy64x4Tn
6xU9ffSk3ubZn1125QxV1py/nL6oGWEAWP709jE8RIAxL1adciTt7oi0ZViABN05
xlKntc3u7HHmRtY2Re2g
=i3GN
-----END PGP SIGNATURE-----

--VdnGiXwuH6t1Tqzo--
