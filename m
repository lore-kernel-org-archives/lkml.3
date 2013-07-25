Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3GYEQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:16:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47978 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab3GYEQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:16:09 -0400
Message-ID: <1374725767.18653.50.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [40/85] net/tg3: Avoid delay during MMIO access
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: luis.henriques@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        shangw@linux.vnet.ibm.com
Date: Thu, 25 Jul 2013 05:16:07 +0100
In-Reply-To: <20130724.140907.326515349808465987.davem@davemloft.net>
References: <lsq.1374674565.832521875@decadent.org.uk>
	 <87zjtbzz8j.fsf@canonical.com>
	 <20130724.124504.1663757440011643606.davem@davemloft.net>
	 <20130724.140907.326515349808465987.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vNdjP+N6E0/FNt7eOMS4"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vNdjP+N6E0/FNt7eOMS4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-07-24 at 14:09 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 24 Jul 2013 12:45:04 -0700 (PDT)
>=20
> > From: Luis Henriques <luis.henriques@canonical.com>
> > Date: Wed, 24 Jul 2013 17:42:04 +0100
> >=20
> >> I believe you didn't want to have these two invocations to the
> >> pci_channel_offline() function.  i guess you wanted to have one of
> >> these moved to the other branch of the 'if' statement.
> >>=20
> >> [ btw, I've just replied to an email by David S. Miller about his
> >>   backport to 3.4 (and 3.2) of this commit. ]
> >=20
> > Yes, indeed, both of these backports were done incorrectly.
>=20
> Greg/Ben, please drop the tg3 patch of my networking bits from your
> queues, I'll send a fixed up version soon.

It's not in the queue yet, but I'll remember not to add it.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-vNdjP+N6E0/FNt7eOMS4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfCmh+e/yOyVhhEJAQqfeg/+I47GLn7KKA8gBCnJScG3jMAikhMmP6f4
U9lX7iFZ0yfYAdzoR8ycJLo5rhuXY27xzgje/ikOc9ccutyxW5oBTzLlsGeV11Qh
MfjqH2D31uoqhqt1n6f15C0DEuY3zL7lAnIkAXR0C19lWU+WmdudrGk+Gduwqrrs
0PFLhjzmmgLNvrL1hQqWTLVthwTnJ9FCe9hW5yT5sFbFqhfH2/X7Nk/uDgnkinjY
+Tyzgw29XPQA6isMXOLASkbrPqrLPbQ+rpMmXNRhofTBh0CGlHw7W6Y5mn9mTRZZ
08aVpHOlu8HeZdVSL4T47pnNJMDvPn4MsHntWIaEj/piZ17HwZTGIWICFQlKO29c
SRuV2iyQb8q2a95k6hQ3EW4rObd9M/5t/hom1hB4I7q8t6SnlcrYo64qRHwcW55T
e2P5uBPfEGP6JSFGRO5nmZxejustYZqKTHlApWCgqlFFMnGkAY6q0gE2hps3ixQE
izr3IcDx7E+qJRrqOvFq8VK8tqAMU6k6TXNfagE03Jw/xc88wyURy/c+VGeLDrwd
hv2ZnzS/OnTZtKTEv4Pd7D8Wd4xFW47vF3Sx3Ajp9wB7DUsn/e2Xfk6AGms9SwFn
nlifZLssZK49Rt5igP4279w9pEda0Zk6HYGobf8xLjutXzskOyzBjE/jM5LTcrkk
0954pZW9DtM=
=nZlD
-----END PGP SIGNATURE-----

--=-vNdjP+N6E0/FNt7eOMS4--
