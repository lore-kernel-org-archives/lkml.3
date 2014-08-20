Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaHTP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:57:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59448 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaHTP5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:57:48 -0400
Date: Wed, 20 Aug 2014 10:57:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2] usb: phy: msm: Make phy_reset clk and reset line
 optional.
Message-ID: <20140820155740.GF24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 09:16:40PM +0100, Srinivas Kandagatla wrote:
> This patch makes the phy reset clk and reset line optional as this clk
> is not available on boards like IFC6410 with APQ8064.
>=20
> phy-reset clk is only used as argument to the mach level callbacks, so
> this patch adds condition before clk_get calls so that the driver
> wouldn't fail on SOCs which do not have this support.
>=20
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Hi Felipe,
>=20
> With this new patch now the error message is only printed if the SOC actu=
ally supports
> the phy reset clk, for SOCs like APQ8064 where there is no phy reset cloc=
k or
> the callback which takes it there is no point in doing a clk_get call in =
the first place.

doesn't apply. Please rebase on top of v3.17-rc1

--=20
balbi

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9MV0AAoJEIaOsuA1yqREtzEP/0LnUcPgjBEt003OoBH/Re2h
eq6LwjI3r9hNFBMjCu3CPs3STbLzQfmYi61AqqhcUoM1QQ8ZAoaLnNnpec1/VfNl
eLj+ac4pNHH5Oucmt+YGaRNORZd6GvrJyrayefjI22glnNf3IGV7Na+flxP4ts58
xXysNwCaGUuqJK8y8voIArcXt0Puj0X+B/dZTPMmcCaZnOWY36ApFiydmA1MELWg
3+iwcWkUdpUMLQVqlCGpKmfToTorrO8bvFWp0RlW3+yOv9NLUhPGgicDufQvcsUU
NWI3eRZwPdVyF8ANREN/bBHfwhej24DSKgVsRJ7fkPIS/ZFZtC32Zd1pUSnF08Mc
l31pncm+VV0mYcBl6cnO85tiySEok/Y3LL2xKKm2H75FSQ/GFperARGHq+w84rey
p3FwydbDpclHOfwlwVDJvFhmG/FqEkj2uf2wDHg+3LbfeQ0wSahoTCo6u1y5S1On
r53HugqtKq0cWZJwzPB1KYTpVqqmWI6XmHKxR8NI27l65kjrDanZ9GF5MNV+5Vbc
fzmMTqfBwpWKPl/8kVMtNRyFvjIv+wvGg4ev4yy0W7bzvy8HQn88TatbIVA7RddO
pD9pTOGfnWKDJiuwmX70mVEgWznL0TvjHFJVQzim5lapm/uIVviJWuWA+z2mt/Qk
ufsXRKsaNbTexHjTtmv4
=XFJB
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
