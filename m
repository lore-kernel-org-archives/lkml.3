Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936380Ab3DRR1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:27:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40496 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935970Ab3DRR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:27:07 -0400
Date: Thu, 18 Apr 2013 18:27:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: ab8500: Remove unused voltage_shift field
 from struct expand_register
Message-ID: <20130418172704.GP13687@opensource.wolfsonmicro.com>
References: <1366210440.15800.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ht+/lPZLak6eP81R"
Content-Disposition: inline
In-Reply-To: <1366210440.15800.0.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ht+/lPZLak6eP81R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 10:54:00PM +0800, Axel Lin wrote:
> The voltage_shift field of struct expand_register is not used now, remove it.

Applied both, thanks.

--Ht+/lPZLak6eP81R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRcCziAAoJELSic+t+oim9a94P/ArXF6Ckv4EHdT11319afoWa
3ujDDPap/tqWi00OPtYvccTOM0JIzsfsBxMpE3zXYJWOiFyEc4IP4508VoXnn431
u6zXt4+jlWYou252wYdZC1xa4oW1+sIWMlDcGXklRXLZLVcIFGTrLK3QdLx8WEba
JtMiWh3OyZMcgcGGtSB6i6h8MVSMFKTyUmTeiega7xgvC2Gy/ll1kRWiJuD8wWEv
NTQLlx2Kdx4pzVQ0Vj2uGh8Y1lxzCOW68I32s3QrT0UMQWmGm626ftNstKht26eT
q37yRrzz+gy5lR/QYlO0SDCai+p4EB7MGwG4ra00di9pgYLuCTpNioh0EfKkCRY0
k0US20gEDpjeBZLaIoQS+lqiwknG8nMv/ePf/TyA12/HQbASv1oqFWtRxJLhmHYN
yKLk0RZ9+wSdbqTaFDAdJR5w8bkFCStKk1jIByEPFuiLmwPf3RstMRNfSck9nSvB
cqRlb6tT0gO/6kHP3PyZjQdwJ9OWU1ZGJ+6MlQtIPKADsQZvN9J76AWRNKwPUyNm
n4f7eDcmgu7NXzu5kF/cxjH+fF1ZLa8VqvXJUggCoPJfgKJhMz/mrlteyCpDm3pg
EVI0om4cEx9dj6ups0db60L61t3Lhvcc51DI1Ua1o3RFx6wH+yA0/VbjVFcKI0Lq
0s6B3sCZfxjsNEChc2K/
=G//V
-----END PGP SIGNATURE-----

--Ht+/lPZLak6eP81R--
