Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3C0CfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:35:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab3C0CfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:35:14 -0400
Message-ID: <1364351701.3520.18.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 084/104] USB: serial: add modem-status-change wait queue
From: Ben Hutchings <ben@decadent.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 27 Mar 2013 02:35:01 +0000
In-Reply-To: <CAMgPeKXMgdQ1CUBtXCgmFse7uQaeEM0aNB5n09ubASVfobQ_BA@mail.gmail.com>
References: <20130325010524.240972766@decadent.org.uk>
	 <20130325010532.611847650@decadent.org.uk>
	 <CAMgPeKXMgdQ1CUBtXCgmFse7uQaeEM0aNB5n09ubASVfobQ_BA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0ovYAbFgk+B+zPyQzkik"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e40a:77e1:ece1:499b
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0ovYAbFgk+B+zPyQzkik
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-26 at 16:36 +0100, Johan Hovold wrote:
> On Mon, Mar 25, 2013 at 2:06 AM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> This patch is incorrect as the wait-queue initialisation is missing. A
> fix has been posted to linux-usb:
>=20
>         http://marc.info/?l=3Dlinux-usb&m=3D136428758202815&w=3D2
>=20
> and should show up in 3.9-rc5. This patch and the following
> use-after-free patches should not be applied without that fix.
[...]

OK, I've dropped these for now.

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-0ovYAbFgk+B+zPyQzkik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVJa1ee/yOyVhhEJAQrCMQ/+LzY4UTCoVFI1nHZVLhVoF+KG/NFaEhco
BGG0C4Ufn5dFNf2WXBgLqpyYvW+m3+rKrIpZPbPz8qpHrgNBx2Qdub278QnXFiZh
ToZMwHeOjKWiUj+DF6IY8eCntgQtur1PiUeyX7zKtl9Q0N+9MMs/mDkyGV4GDyHk
EMtrS0vM170bAD1nG82JKLzVsYAABfutQB6s6GYfw1X5xVvpEH2z1k1wwC4uMvny
plG7geThs8BIOX8IW34KruEpFNCtVl51Vpac/0S2KyjLmlgWnivdZ+SPO4icBN8N
BmzGLHkQD8UFyQ/AfAbP5bGpF/+kru0sW3TXouXTvnJL4VR9xYKv4wGL5G2mMXpg
IgVBlNQk/dTZDd0+2TrMqU1AsEINjcd1STT+SSTs8QpF41BnnfpHtm51XAVL5Lsg
M8Ay7mjcn1PO5AvSIU8YwRMyi4668u/eQYxeiu+eAFTBzyKLD/VYy5iQVOzAuhAk
vgnzr/i5GAkO4O1wA9tk7LzAOywnaQHWkODWnOAn9uVsxPiB3x1TlHhJMPZjK6AJ
7kCFBDx+zqJuqvfGSdISCIleSxCFjfsKwOIjH94OFzpyobjC5cU79GXI7lHcm3Pb
j/ZRIS+Cp/u4zqEfjGYpy6I255LsPkT/nMAXAJYfcmajyMF8H1Da0bTMQcjrwaaN
deOUM/Ae4+g=
=b94b
-----END PGP SIGNATURE-----

--=-0ovYAbFgk+B+zPyQzkik--
