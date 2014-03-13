Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaCMJaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:30:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39744 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753410AbaCMJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:30:07 -0400
Date: Thu, 13 Mar 2014 10:29:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/4] irqchip: sun4i: Fix irq 0 not working
Message-ID: <20140313092917.GE2815@lukather>
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com>
 <1394644627-12315-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3199z2xwsLUuj0Hj"
Content-Disposition: inline
In-Reply-To: <1394644627-12315-3-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3199z2xwsLUuj0Hj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 06:17:05PM +0100, Hans de Goede wrote:
> SUN4I_IRQ_VECTOR_REG containing 0 can mean one of 3 things:
> 1) no more irqs pending
> 2) irq 0 pending
> 3) spurious irq
>=20
> So if we immediately get a reading of 0, check the irq-pending reg
> to differentiate between 2 and 3. We only do this once to avoid
> the extra check in the common case of 1) hapening after having
> read the vector-reg once.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3199z2xwsLUuj0Hj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTIXptAAoJEBx+YmzsjxAgDJUP/2ofr5IXee0nNVXFOEVHWUfh
e9/l9br7wFpzc7D1qBKYpyWZiCTNYXqzq2BBDzuJhQ7KH1auv91A6MUGbxNVXJpy
XrjLyqrYoT+7RkFC23QPfvGwpduhUrULELZu1AX3KZCOEIo74xKU1SQaT7Odlc1Q
Q6v2NYur/9S26CuxNBNnHbS8J8icok7vY54beX3GKQj7nGWyJdHlKY3lHk9sonG4
W2lmsbsYqhHOF+BaeC/zo9Kbcz8E6KNFbMkDOzEFC3CGBFV2auq2yM6jwC8HqYWt
jAZFsueqeHXCf8RRKyhHZu/3q58zmSka54UXF1PkY+Xcs89RKMMZ3svieOIUZftI
GprLuCWwsCWO2hmZSc3mmOgyqKub2sd7NojUjC5CrydQzNBN5+/Hx/FBVR8GZBSO
I5Y1LINPADc9D+i64nTMGo44BIHF8ldI3hpVfU4k3Jy2Za8rddlgrQIzNlIOfCq7
c7d03Jhs0XdFRg4xLigq/Q/ZhkfSXV2Gqbxx9NVT+3AznIPz/gofDoZ/UrmlavUr
VPpKfOmHZv6wF73cmNUJ8ojVyugK5ddJquavtpt01/GQezxume8tqrh1gzizqliG
8qIrAG6ogAHeTXKQQyPH2Q1MkoGSFKBQrAO9AJ2NirjDxRcmP7PAS5PaDHdpNmKN
5RZotXzjfKgVNbWaQCXe
=tzIA
-----END PGP SIGNATURE-----

--3199z2xwsLUuj0Hj--
