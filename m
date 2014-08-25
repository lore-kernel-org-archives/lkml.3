Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaHYQz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:55:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38148 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755473AbaHYQzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:21 -0400
Date: Mon, 25 Aug 2014 18:10:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: mv64xxx: continue probe when clock-frequency is
 missing
Message-ID: <20140825161033.GF15297@lukather>
References: <1408981819-3477-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JCYGd/UpHK4EX+A4"
Content-Disposition: inline
In-Reply-To: <1408981819-3477-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JCYGd/UpHK4EX+A4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 11:50:19PM +0800, Chen-Yu Tsai wrote:
> The "clock-frequency" DT property is listed as optional, However,
> the current code stores the return value of of_property_read_u32 in
> the return code of mv64xxx_of_config, but then forgets to clear it
> after setting the default value of "clock-frequency". It is then
> passed out to the main probe function, resulting in a probe failure
> when "clock-frequency" is missing.
>=20
> This patch checks and then throws away the result of
> of_property_read_u32, instead of storing it and having to clear it
> afterwards.
>=20
> This issue was discovered after the property was removed from all
> sunxi DTs.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Cc: stable@vger.kernel.org

Good catch!

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JCYGd/UpHK4EX+A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT+1/5AAoJEBx+YmzsjxAgXk4QAIrsDsvevACWgULkDCKbX6GG
Om+1BX0PnSWgG/36X9316UshKp04C1n36TzZjqWtWsviyZS7wuwo7i+yfwzdmia4
xGisS+0wq/hyKzBv6NwpOoZaV+Pqsri21LNLGG/I/4h/yN8F77zPtx2DaQig6M/+
PaNl8Ut3oeXYSQoo9oby38rsu1hccifJUORRidAic5L7sRCp2Cg0UXDtvZpphA5J
Korn74Fss335PLNR+IQWX0JNLj0iY3Xhshdh9M9Ox0Bdq9C0PPiNf/ySpGeiZVYZ
v94zuZdgbadTcnIXa9uzD/MYlVVgucFpPjTGWlG2XWk3N12Sb+obfLFBJIJ6ZWLS
2G1Qno/wNcVIBPV8/FpEJ38rjVdZkObDBCqDCP86zWB/P2UONiSbcRE5uXR5VNIu
DjlFqtfY5ASAtF6hxVaI6jqg+VKW1PXpTIagn8BsixI+KZwLK3Q21kSkuNU9pUGJ
lPBj1r4Z9j802jYGCzUxv6Fx1Z6EhyEeVwInqNB/gqIFrlVB4RzgMDqiT6aLH6/Y
KsRSlbDmXwqLXAEhWAqTcEuexewFljxhHijI1cxGIPtL42LuheG+s3RB4/iG7heH
DA9M3s56Rh405V+wv+ZjxDy1YRKtLcZre44leOZ/d4h1+Dl6AJHP4HKtU2NAFb1+
XEh1gbtU1x1juOsiLukX
=jzml
-----END PGP SIGNATURE-----

--JCYGd/UpHK4EX+A4--
