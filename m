Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835Ab3DCIx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:53:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56012 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762796Ab3DCIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:53:53 -0400
Date: Wed, 3 Apr 2013 11:53:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Subject: Re: [PATCH 04/12] usb: phy: ab8500-usb: fix eye diagram for ab8500
 v2.0
Message-ID: <20130403085336.GJ25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
 <1364978713-19612-5-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+RZeZVNR8VILNfK"
Content-Disposition: inline
In-Reply-To: <1364978713-19612-5-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 10:45:05AM +0200, Fabio Baltieri wrote:
> From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
>=20
> AB8500 v2.0 has eye diagram issues when drawing more than 100mA from
> VBUS.  Force charging current to 100mA in case of standard host.
>=20
> Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab850=
0-usb.c
> index 5b92a59..1fd0780 100644
> --- a/drivers/usb/phy/phy-ab8500-usb.c
> +++ b/drivers/usb/phy/phy-ab8500-usb.c
> @@ -485,6 +485,18 @@ static void ab8500_usb_phy_disable_work(struct work_=
struct *work)
>  		ab8500_usb_peri_phy_dis(ab);
>  }
> =20
> +static unsigned ab8500_eyediagram_workaroud(struct ab8500_usb *ab, unsig=
ned mA)
> +{
> +	/* AB8500 V2 has eye diagram issues when drawing more than 100mA from

wrong comment style. Please run *all* patches through checkpatch.pl
--strict and sparse. I can wait 2 more hours before closing my tree for
v3.10.

--=20
balbi

--x+RZeZVNR8VILNfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW+4QAAoJEIaOsuA1yqREBEsQAIZNpbdeE95nuhTv8mqNSXX3
t97rPNFbCRZlz5YX9Xl0erTvEX1VbmyGg3HNUlAMTPR0181Glw4RopoDgPMmI7ir
MjcEbx8r5V1Xd+UGbO3JxcicOGxMB/1YZe3hztgse83FXy32gYE7M+hgCJ4SSIoZ
j+2ErkK4LaDiucSYe8SZK7yRjjcTOSoX15zTJBmSsmwPfJUQACyS5hwOtDMhc3pf
tOVZkUKxs8NIuYZoVKXX4JjepiZldC7zmijelMC/lBrJUcOWNB4FnkVju5tjBJfB
U45Fx4Dm0NnMQdNT6/n+EM45mhX+ZwsF5DFJ9+5Go9hwQ5N/2hwN9q+3N1+DD4qp
zl+Pv94He+nlbLhhIWxz2XDlcpGhx1ln2w9UFDZnX4B7bwBG36GSP1uIv+FNXpo+
02gt2ujxPbMEMulHFZDxsabVF1ZLbgzQh9knI5JBnTeQEdIbv4KLxMWunbWLVaT9
8Z6Zt8m90tSVrpysHJK7M39BrBBVqqI4Q9rVyQTB8GdIw0uKavlVJG/f5+Zpjqwu
7G6Af4Y7m1JAUDclp7k6Zlpqfio9kQU1BYm5IyBkvsOiRLo3lVaFO5rTbTslXE9a
SFDBQ5OH4/DJfXHIh5784FEhecbY0W0YpKus01aptYI7GUWpjzfmdmDVqRZJpJxh
eWD+VnWpbA1qANEAffwc
=hGkH
-----END PGP SIGNATURE-----

--x+RZeZVNR8VILNfK--
