Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaCEQee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:34:34 -0500
Received: from sauhun.de ([89.238.76.85]:51322 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaCEQec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:34:32 -0500
Date: Wed, 5 Mar 2014 17:34:30 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v3 2/5] i2c: mv64xxx: Add support for the Allwinner A31
 I2C driver
Message-ID: <20140305163430.GC9228@katana>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393950521-4173-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <1393950521-4173-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 05:28:38PM +0100, Maxime Ripard wrote:
> The Allwinner A31 I2C controller is almost identical to the one used in t=
he
> other Allwinner SoCs, except for the fact that it needs to clear the inte=
rrupt
> by setting the INT_FLAGS bit in the control register, instead of clearing=
 it.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Applied to for-next, thanks!

Still...

> +	if (of_device_is_compatible(np, "allwinner,sun6i-a31-i2c"))
> +		drv_data->irq_clear_inverted =3D true;

=2E.. next time an errata is needed, I think it makes sense to refactor all
these checks into one struct which can be used as match->data directly.


--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTF1IWAAoJEBQN5MwUoCm2BE0P/ROppN1iC50iHQsjp8knwcjv
7Ht6YAb3joEDy79k/H84wMcAWubWnmZnGwYA19RQqfar0sqPOh0XxYQhxtZaCakJ
udn04WMHwrLMH0aKQZEdvdYw7Ags+hgphZkD1wlaEjVogxPduWN0speqzDTrjyQ2
8Zt24uXOgmrMql/Tq48qyjWn2Uo8eLw63Q1aBYm571thJ+KR1YBJCofYRyyvrRed
Xctgo6UNWZIaM6hsV5o+HRunCKcFZL0WBEskQsucSkNVRiPmSaskx1tk4ay0WjZN
O+Mtg6mFS+4QZg51xgsX+SNEqcF7yzYxqL8p7RIOR24DbJDtymd2i/p3JwtXZEqe
b97ZrcwA8z3TenE22trmnMj//8uCYVdNyo+34S6Z74qnFVwcl+6cyl2aEwjDsneH
41cJSsv90wh8XNvLBFBTrzlAFIoM4UE1Uoxa6n/eeSt9/VQ3oNLMMMptZtXFmEZ5
ksNEdvkMG5y3W6LzvcrRRe7hEmvoH46ZHHLnv8eCdor+C18UWwY3TjnRFRWd1ryS
/3c6wNsFiskwDZIIAuMTWpIv494LNp840NFAepGluWdpxbh4QrpMaVRKJGnyjMvh
CQj4QiNycG8PzZ9aPCpUFYv228/4ryiIYcqjVVz0E9j7oQtx4ktDDXAux67N0rGV
HpQHzcm+etPx+c8QDcwX
=Xk19
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
