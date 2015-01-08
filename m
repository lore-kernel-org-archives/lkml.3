Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbbAHJfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:35:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58940 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbbAHJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:35:05 -0500
Date: Thu, 8 Jan 2015 10:32:03 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] fbdev: ssd1307fb: check return value while setting
 offset
Message-ID: <20150108093203.GN7853@lukather>
References: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
 <1420705079-3741-3-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liZWpUHqzTS6Vbk9"
Content-Disposition: inline
In-Reply-To: <1420705079-3741-3-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liZWpUHqzTS6Vbk9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 08:17:59AM +0000, Lad, Prabhakar wrote:
> this patch checks the return value of write command while
> setting the display offset.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--liZWpUHqzTS6Vbk9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrk6TAAoJEBx+YmzsjxAghRIQAJsMbLwR5XQwP8QwoylLUFWN
TVi1ZLcnf7ackF7MY6r3LjwZbvzz3NicKIBOpdIZZxJxTyXYdXgijrXHfD5JSGzt
7EtIPmqPFqGezBWX8xVyQvYsvocAhnf0MZasURDFKDjnw9FRMjQoMF1trEaVE+1T
1gW7YV9SKO4nQ2Yc3uRXMS9mUkRgOoWQ0WCOA4sGnFo/IO0doVBuVw9AQamtiyDU
WxY/2B+oH18vNj4oXHdexbMhY7ycYknS7F5XhaogmyRkjEzVewaFg8LwbaAQh5Df
olzI0oSeG2tUV6k/4Hsa23vDIfPwtS0cpDvsU929kkFWEGN8f0x2gcWANGgQFHU9
ULz+wCCO4A9NwTAhDfI4TekPHowmjcEhUSRGaYlTbr0hBfNFluPzVmW+NGaZMnXY
bcqu+0kLQs+zwIpz0u3Qn0Hy7HKepbXX/VV2nxFbnzLdQMnw/RnXWsrXyviWD6Ga
t3tDS79L5wFXcdF0J4zDswug4/dN/C1tq75REqLih/W2/aE3zOdizyLE6HicpXXQ
BWVzKkoZOU4Y5yKrwW6q9I3T8wxPeooAdkUA4YEoulIl/v+pzpXkhP/8hXDK2uL9
UEWD2D4kLE2ffl09G29vDys09iK7yuDe3hTICCmwTuHCvAnci8heS2vLnGU2sre+
QQyBQqmnyC9UhxfH2D/9
=QlF1
-----END PGP SIGNATURE-----

--liZWpUHqzTS6Vbk9--
