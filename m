Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3CDO0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:26:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37409 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab3CDO0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:26:01 -0500
Message-ID: <1362407156.3768.336.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 73/77] [hid] usb hid quirks for Masterkit MA901 usb radio
From: Ben Hutchings <ben@decadent.org.uk>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Jiri Kosina <jkosina@suse.cz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 04 Mar 2013 14:25:56 +0000
In-Reply-To: <CALW4P+LD1Ah8cgTYBeAT5zR4mwq-K+_LP7rMq=ytBWW2Gp0P3w@mail.gmail.com>
References: <20130301194351.913471337@linuxfoundation.org>
	 <20130301194359.700037464@linuxfoundation.org>
	 <CALW4P+LD1Ah8cgTYBeAT5zR4mwq-K+_LP7rMq=ytBWW2Gp0P3w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SK3OX/K2gicSFtWh78i6"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SK3OX/K2gicSFtWh78i6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 14:05 +0300, Alexey Klimov wrote:
> Hi Greg,
>=20
> On Fri, Mar 1, 2013 at 11:44 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Alexey Klimov <klimov.linux@gmail.com>
> >
> > commit 0322bd3980b3ebf7dde8474e22614cb443d6479a upstream.
> >
> > Don't let Masterkit MA901 USB radio be handled by usb hid drivers.
> > This device will be handled by radio-ma901.c driver.
[...]
> These usb hid quirks are related to new usb radio driver
> media/radio/radio-ma901.c  (commit
> 4834f4d1ff1dc574024e1a6de920ea99571090ff in upstream) that was merged
> during 3.9 merge window. So i am not sure if they have any sense
> without driver itself. Also, they shouldn't make any damage as far as
> i can imagine.

I think that if the HID driver doesn't do anything useful with this
device then this is still worth including in stable - it makes it
possible to use an out-of-tree build of radio-ma901 with older kernel
versions.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-SK3OX/K2gicSFtWh78i6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTSu9Oe/yOyVhhEJAQpClA//dz20BcqLWFRRr6/bjeu9bLICzdHM+UM1
SjknRFhjDbUl3kKHXDJm76n4mnM3k9Gz8LM2TBVuOl0aQ3cSE/k+KTR63lv5eptZ
RMssOjHjY9soNwFtjOhkaih72fxpUYEFXjYDKFGKB4+9VbjKdVcdjI+gesQkuD3L
0KZlHI5H4uyphKUxU7PdFJmRisvMH734ib/gHByfM/+LZXK5nuioycI8XhFUCpKM
TksXYRIQhJWNpkGCy0IZCRukobgBihRu/5Pnt0Zp/mujGut6jS6/QNOmMFWZZ9hZ
vDOJ27r3/DetIskteFIzWwgqEVwY4aPyC14Z3r2EC/OQ7PMk4w6HBlUkviOlt5lF
LLde+j6dgoXFEPq6fczgSH5Pb168VhlATlL7pyW6d9v7QYUgvly0p1Jw/cK6Pv/k
lKuXGvdG73pTCQ1/vX3pFH6QVnwk1ZtQLnI8fa2JKRFGNySxmRk8qz1eA0ggVu+y
Gg6noSmM5t0+7L1/zM8uCQyX+AwafR9UxvEdtzXCM3WCLWimhOyPoAj0wWEQrZ15
IUr82SDxGNMgQXxHDL3wMPaP0nZ2bYhyPq7cX7c9AnMr3gA9hF6McjOg4Og8UFLC
mkBG/nOeWycx2uOCXrg6y6z4OEe57lHIEL+wLvXa+9D0fgvnQhlPG+qy9IS+BlGr
SHc+NEJOQ58=
=+FbG
-----END PGP SIGNATURE-----

--=-SK3OX/K2gicSFtWh78i6--
