Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaGNITG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:19:06 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55897 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaGNISv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:18:51 -0400
Date: Mon, 14 Jul 2014 10:18:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
Message-ID: <20140714081843.GK2081@ulmo>
References: <53C27247.2010300@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <53C27247.2010300@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2014 at 07:49:27PM +0800, Chen Gang wrote:
> PWM_CLPS711X needs HAS_IOMEM, so let it depend on HAS_IOMEM.
>=20
> The related error (with allmodconfig under score):
>=20
>     MODPOST 1365 modules
>   ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/pwm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

NAK given the discussion in the other thread.

Thierry

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw5JjAAoJEN0jrNd/PrOhM20QAKbymSE1rQmcqRRZ2F7G1bRU
RKeFrCGPadaOYwyA7ek+xns+KwTxzSuFzSdJBuYc/iHBFtkyN9tXKSnNAX69AULB
ovYUF1470Mf6AhCDrrjMK3AGMjfEdessGpQIxtMyFHIZnln5soXX0o+Wcpm3hqRD
yMwDeeEOjHUSNKjAyXI7yxTotR2yPJpbx1JO25ukN+rvz48bnn/Nw7Alpe1aDvj9
ZkYXHfo/UyJ0R9gh3k6gSW2o2l/KiHW4nsT2HeerIvpUtKTKe9oSlaHmCupu8sRS
/82ESn2ZeHN6MBl5iAUOOZG05ne4g2WuiypR4V6TkSUP+gARwqxBWlMGKGd0iONm
9kr6I5+QQqX80K+YF9hvnJsj/jjY3gryii5uFgJo6nqadqSpafFjIDCVc96R/We2
TQ+nEy8+R2gVDxdHtoq2H/rlW7vTyA0487N54wM0inAVMD41HXV8h54lasX1AQ+i
w+xSLQvj3vsv47S4XXnYWGCpuO2Iq0aYSjrUZ00D3V4jxltuNxITFnQnSR07Zu1i
T5lxjpcE2RRl71P1xztXVfwFx1nbdr8SZzBQbHvz6wtVLIAYgX8wtnTCIOTwQ1NS
7cFmHttKwL19nmi6YAsPjOlGaGtAwHSBIrEBHVvAMoC6dDpAKAC0obCA66nHV/Ck
TpVuo27PP/0i3to2mbrO
=jhfS
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
