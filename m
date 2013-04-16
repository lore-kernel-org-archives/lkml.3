Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3DPLWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:22:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32822 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab3DPLWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:22:49 -0400
Date: Tue, 16 Apr 2013 12:22:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: rc5t583: Remove unused fields from struct
 rc5t583_regulator_info
Message-ID: <20130416112248.GE26958@opensource.wolfsonmicro.com>
References: <1365787538.8465.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Content-Disposition: inline
In-Reply-To: <1365787538.8465.1.camel@phoenix>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 13, 2013 at 01:25:38AM +0800, Axel Lin wrote:
> The *dev and *mfd of struct rc5t583_regulator_info are not used after convert
> to use regmap, remove them.

Applied, thanks.

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbTR/AAoJELSic+t+oim9HBQP/j4tJdWgs4p8XWHzvKWtBxK1
e2j3kbWaCtUHAjxUXhfMoqumF5yYhssvmBIJd2Ng3BBwL5hYJXTSMXdyFnYmJgoa
2raJQf45/KT0ApDaDOQjtSsG8DvhtNtKMtOHsImqboZXAzfUAiTwS9HrkTmWWjpA
rV8wIPUqk4BQfQrz683o1hk7Nk3VOTRzfy2VmmSRAw9mlvnv7AyvBmUYf4e+hY0V
9/A0UDc7Vk7Da9S3GYFZ3ABMZuz581s1DoKA7MxV2KvsGmpsNedfXPpHRleXmXeR
qDor9IADO++NpllZDSpeVoo+ey1TBzBhTlQaGeQ/FD5fH83fbE4REIKzxp3tc910
wpiOQ8K1vLPrEUjnGApWCSJH+9nseEWbKRDdAUwD4sSgviuwDuThX1ofm01Qjahy
ea0QQiZwDfnJ0q/aNKwbSY/97ymYK6J987Pa2raf4Ds3BaIuuqtaChsYiI6G5DRc
J84cUhd2tSYfa2xmq7rFCDC0dBZq2PsyPu5qic/Vfbxs3yAsTnvgkC6VwFH74iPz
6Zzvoo1B+pHOD7MHn2Zc7tpzR0WQ57k1NbX76OlkzywL6RDSMfGgPzOljk97Lx40
weKqWYz05pUH59+C7GzqRtv98kDjj20XUAX+X9jzEyWD4g2A2U6DUP6jnTt2+avC
2AXkoQBY47gMbDoTclHG
=lx7r
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
