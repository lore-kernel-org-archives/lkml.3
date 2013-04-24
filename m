Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3DXKAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:00:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35796 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab3DXKAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:00:34 -0400
Date: Wed, 24 Apr 2013 11:00:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net,
        spi-devel-general@lists.sourceforge.ne, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/8] spi/spi-atmel: add dmaengine support
Message-ID: <20130424100032.GC5019@opensource.wolfsonmicro.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968759-24036-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MHoG8na4IvP3G3ze"
Content-Disposition: inline
In-Reply-To: <1364968759-24036-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MHoG8na4IvP3G3ze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 01:59:19PM +0800, Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Add dmaengine support.
>=20
> Using "has_dma_support" member of struct is used to select
> the transfer mode: dmaengine or pdc.

Applied, thanks.

--MHoG8na4IvP3G3ze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRd604AAoJELSic+t+oim953AP/j6CzZGxZkATpXh1XNBgQw6T
YMjhju42yN9wcsb2TA5r/NMtu2TU5U5hepiKnlhO3H77upyLiuGn1++P5vEDZT5w
u6RpAFo088uYDqnYfDBTjO0VYAcGuvegci0ub17eWVT/Xalt8a/s9zfdwvCIupUf
ckBAfyOY1ExKtCvX/QxxNhHw8YPUIOzX6oXiBop8zLVOjfbbKPfhAxWhm9pCV1rV
LYL+V02BbFj/Eet5P/xAOZ5tEOweXIfWom00uoEsk1wgOP+q0ShV8NWzoXqcNZPv
UDKP4UpqPWZKHaAuitfXJ/wPtlJkVMBcL9sakyA/3QnUMSe0e3WXwgMLCZaYqhQh
MNGwHknPLkRAaKFQCz7FUZnSFVp+yEXP+a4sbGF4KAaWfgbk1SdadxVL669P/HxV
2bDVpZ0GcA4MR8DCGfTT8JgE0eqyfHsX7rG5SKWxpcbwcAaKq7Qg8GdYsWmzUCKI
iEczkeFrnN6Wjw6UFGoIrb38UhaD8sWe7LEA6E43CwUEmt8sR4yZGklfnIA5Q6Dh
2ypDzWc86AUb3KINZtqHTnCXjNtfrF+I3zKvznj+SjB0CAEUN2m4O7bHHXAJKGAH
MD4MX+T9Gtts8a4pSH4g9SHWaQr0/iIP0FhXLEncLL8K18tYwlxPNGFPjq9AF5g1
vvewOzzsvKIOQh6n6Qhf
=ZiwJ
-----END PGP SIGNATURE-----

--MHoG8na4IvP3G3ze--
