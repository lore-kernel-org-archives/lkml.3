Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3DWKlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:41:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514Ab3DWKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:41:38 -0400
Date: Tue, 23 Apr 2013 11:41:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH] regulator: tps65910: Convert to use
 regulator_map_voltage_ascend
Message-ID: <20130423104136.GH5019@opensource.wolfsonmicro.com>
References: <1366425017.8200.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
Content-Disposition: inline
In-Reply-To: <1366425017.8200.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 20, 2013 at 10:30:17AM +0800, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Some regulators have more than 200 supported voltages.
> e.g.

Applied, thanks.

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdmVQAAoJELSic+t+oim9Ek4P/jTFEcQHYAvIz0e6NH8PSNGU
m1GERuhExfVQaj0cKughUmGFdWW9+mXoddDTA6rodfMIXaDfT9uRMYgWwcUn11xD
QrR8873enn9zTnGtm8QeUUWE4NlmQoklHfttyx5bc+e41Tlde4DtKyaLoscROyrM
FZWbvUC7XcbhXj4uQM+Z7s1SCErYDfdF2PeSxJh6ju9Zoyco4Va23NNvfl/3lIp2
jfBXgv43KRv9rHhb88TnERD6Fj4Kg83E3r/Z/zV71c8bUd7oMI9rCuapP4C6kRVF
Bm82g714miSiHrnugjJesOLM6AaVMxalPiK7Pix60+EuU/GED2CA63kJcuJxWQ1q
IWmQyacoZxrMwFUgE38K2VCjtrwE870zThlbo8q773gFr+LZWd5vlYllgIO7Eif/
sMzqbeV3p4d99u9FAH3l42PPNKghJBpHH88TThJ2426G+ZQn1K4g9xRH5Emnyx7P
mlQOuG0uL2ByC9kxJGwC1mVJXBQ6GgfaN5qTULpr0lFyorfBoDdS8QSSxNV/IZ0g
/X4sV3GHlMqMmWR+/VMJA+tZRsgt6cPIvgmHpIXGKP5ycYuKMkCE83D05LT+PqgG
rnKD1/Zz2b6r6ZxNuscZ3uuHtGZt47HDE3jVun1GCUCwvfuoaJxZIeygb8OtSjy9
sC+vOiq5/ohTMahPIx5G
=iBLM
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
