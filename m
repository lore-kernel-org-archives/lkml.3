Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3DVM1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:27:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab3DVM1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:27:06 -0400
Date: Mon, 22 Apr 2013 13:26:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: palmas: Add missing ctrl_addr setting for
 SMPS10
Message-ID: <20130422122659.GH30351@opensource.wolfsonmicro.com>
References: <1366374825.4345.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhjHhnbe5PrRcwjY"
Content-Disposition: inline
In-Reply-To: <1366374825.4345.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mhjHhnbe5PrRcwjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 19, 2013 at 08:33:45PM +0800, Axel Lin wrote:
> The ctrl_addr setting for SMPS10 is missed, thus palmas_smps_init() read/write
> wrong register for SMPS10 in current code. Fix it.

Applied, thanks.

--mhjHhnbe5PrRcwjY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdSyLAAoJELSic+t+oim9k5kQAI7dQif96R+zdppzbybWVUE/
u3kY9FOMW56uxslbue6eqU7CNPmIYiOGc4TwrrVulzKnMwV+EAMBarDEyH/utpei
Bo895JO4VQynLIGLys3+VJFuEVpRNYT9zxgRcD3Ug6XpQX93ClcX5xyez/On5H1L
FNTa7aNApB2PEbehKH+6zRGGw64ZhCgiSpZUteYatxSU57PCaqeBlUaOVlsUOIs7
VmdhhDBvqzSpbKkduOnhFgoalYmcSFGG50Kt0/cOMJT4RU9N+HpNSC0NMjHerKSv
8iv01lU350qD1EC+ISIXltxE1PSjvI5JZxeqZExqBbioRKHqjvGxFhSm+aITrgZe
WZrTp5IxGaBaSVqf6aungpE1cMTgbmSJwIqGRA8Dd8A4VQRHYTNQw85tP5NiJpEP
ag533uNrzc70lmBKl8Ohom/Gu9pIgDxiIQPoF2daikNKcHjQULlSf9XA5wSWMmyd
MEs+NGroBVMvcpFNnjSrfm7NgvhoMWeI5r91et/BjTYoPN5Kl/bak59m+WOv2F5K
XWtTLZ9FNLXPpDol83loSRlzOuBn7zyJ2+Fct9+cmxB5U28n9andy8f13cjmHK3J
4M9/qSgLaTnEAwLL7r1TrS+SK42oRby0M7bvSoHJJaVcdIioxlIZ5vqMArPCwQmU
5fVx0Z+sjL4pv9/SF19r
=t2Wf
-----END PGP SIGNATURE-----

--mhjHhnbe5PrRcwjY--
