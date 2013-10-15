Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab3JOKTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:19:38 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:59444 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3JOKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:19:37 -0400
Date: Tue, 15 Oct 2013 12:17:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/pwm: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20131015101722.GM7856@ulmo.nvidia.com>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-4-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XlS4q8O07AKt4+K1"
Content-Disposition: inline
In-Reply-To: <1381681071-6021-4-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XlS4q8O07AKt4+K1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2013 at 06:17:49PM +0200, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device c=
ore),
> we can rely on device core for setting the default pins. Compile tested o=
nly.
>=20
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/pwm/pwm-tiecap.c   | 6 ------
>  drivers/pwm/pwm-tiehrpwm.c | 6 ------
>  2 files changed, 12 deletions(-)

Applied, thanks.

Thierry

--XlS4q8O07AKt4+K1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXRYyAAoJEN0jrNd/PrOhoYIP/1xbqi1YmzEavue0psA1oOFl
EZxbSLyrsPs4b+s7q60NXPyg6/NNEyXEU4zeIBTCjDWLAN9PS2cLtSES91mKeDLb
eMoIjNPn3FaPFlbRu2ak8EhHrmFoHsueiLbDIxrGkngRJ6J83aakCJ1fkqkEwCqP
OcXAP1UsbvBQ1xN+srE6WnfeL3Q62y+Z/PtgWJtC6T8TmpVaFsAB9p4Uv0DCW3tT
rKLe3euM5i2Az+q9CflT/wQJ5zD9SN1IoDD0+eRWU46C3f/hoIbT/QjHXOnzYKiw
zjC9jZasYLhdvhQbHlzQukTP+/pmTCIZQuDyC4KHYTmqIyoehi1PxUf/iuOwRfjg
HJzNiNQvDUElzrRirObmcCzD7NOxjZzYjf3uWaBBNSyV9Uuc3fKz9KDFGiCxyfAh
OMnuNTPU8ZmmhtGu9nXlhDuFXqfysoqEyMbpcx6Xgr9egYZVDV6uI8i5+t8JK8sh
qyRmc0cVapR3v/c+2t0cc8P+79SBsq9xmdKGTWZwlQtj3srEAgbeQ1UFk8gsI6nG
OgNq8YAMBes+pP/9zs34UDZJLTG2ydaX4Lr66gYARAAW1zuaYN78i+q7TyAS8qK5
SDxOBkMnpCXrVhcjWFEMFE4AiCJN/xI9Ecv2onhKqJpUoadQS1vkhbwpfIO/DKan
dhN1ltYcHzI+94VrvJfG
=BB5g
-----END PGP SIGNATURE-----

--XlS4q8O07AKt4+K1--
