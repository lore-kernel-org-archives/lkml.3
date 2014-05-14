Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaENGuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:50:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43914 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbaENGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:50:04 -0400
Date: Wed, 14 May 2014 08:49:54 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        hdegoede@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 3/8] phy: sunxi: Rework phy initialization
Message-ID: <20140514064954.GF29258@lukather>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399995862-17788-4-git-send-email-maxime.ripard@free-electrons.com>
 <537303C3.8040503@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Content-Disposition: inline
In-Reply-To: <537303C3.8040503@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 11:18:51AM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Tuesday 13 May 2014 09:14 PM, Maxime Ripard wrote:
> > Move the phy initialization and variables declaration to the loop itsel=
f, since
> > it is where it really belongs. Also remove all the temporary variables,=
 we can
> > use the structure members directly.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>=20
> let me know if I have to queue this and the next patch in my PHY tree.

Yes, that would be great

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcxISAAoJEBx+YmzsjxAgoA0P/0l+yt44Toa6WI8ko+1ZNDBq
sSkuQMXW5vO9uCxtZvoMQmohJ0EdmvFMUFGuQza8STFVqRIrw3rMxrY6tNBS+ZJn
lYyh6YMBm1DsvRv3oIOqQlEpTUarjhICCRW0JSCQchoB0XX+RB34uEfTyGJoqNxk
z+kundTqqF8HlPY3hbS4HoPrA62tQ1Tn9MJAkhDZkWnBwmrwzuzOXgyAJvQOq5mI
/dmmutB4ncJN3BiqUpOA3rATUKJbdj9rps7bggxGKct7IUAi7Kj4ziJ2lBb1rSIi
tqOnYt6WI7y6tMWWfHatN0oI9csEUBt1/6b4PHXPzUXu3oZo8ZKXESzw+eVIPpED
wcnWsnMqlpMxlWhTRNVkdFsqUTV6GCpMSxk0Iy3JlbkKKuX3N/doeUjZ1dcVHta3
xXybj38JcKQofPAGlynvwwtVEIm+vO291AytJQaj4LQyCikIkT97xNdqTJN9EQcQ
/C01yYuTyNosg3JhgfPhc7lVlQu2/3zXBX3CrUMCTLBq39AOnu1WRaYBrscjUj0B
eyUZ/7hzl1rjIAOmSpNH/UAKLlJXjluD6Ln3QSJgSmN93pJUqJFo2dYEy+QbaT6F
uNlewz2xfkijKUkg6rH0yU0jG2Spw4LtAeR5MFSPnpVxcGt9igNaMdXNUWb/PgF3
bOEp9fbrU9Hr/zAdCNm4
=OX+i
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
