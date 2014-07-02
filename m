Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaGBToU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:44:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44032 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaGBToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:44:18 -0400
Date: Wed, 2 Jul 2014 20:44:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20140702194402.GO410@sirena.org.uk>
References: <CAB78YHy2tW4u5rrsz9yKqpD7uigtkp=B4Z950323-v0vGk5R8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5wfsVCgeKAcINk2"
Content-Disposition: inline
In-Reply-To: <CAB78YHy2tW4u5rrsz9yKqpD7uigtkp=B4Z950323-v0vGk5R8g@mail.gmail.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: question about drivers/spi/spi-au1550.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5wfsVCgeKAcINk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 12:31:45AM +0530, Himangi Saraogi wrote:

> I find in the probe function that hw->ioarea is allocated using
> request_mem_region but a release_resource and kfree is called on it instead
> of  a release_mem_region. Is there any special concern behind this. I was
> planning to use devm_ioremap_resource here.

I'd expect this is just a bug you've spotted.  If you could send two
patches, one fixing the bug and the other doing the devm_ conversion,
that'd be ideal but a single patch is also fine.

--Y5wfsVCgeKAcINk2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtGD/AAoJELSic+t+oim95boQAIObeO7TILt1eUAl/HnuwKlt
6KClFZ41AZSSj1FlW61qRbjTBHIzbkgY6pn5O9/o+6MXjV7Q2PMsJljqn0QmgNo6
HJklfCYVbnC0GHuGT/sfroqqOkdP3FfiFHaJBgwoRuTLIOrWzMuG3xl49sWhkUn2
qmeIiP66O4j5DjwkaIdVJj4gjT1FX0eOSiv4L3YKKSC7E1G0l1JOh31BEF3rD36w
tzisL3vE1V2RP5uXPMOll5E3wKH17Uq1OK6T/KtqwdkeR9ssiIm6cy8ntWoefGgH
GOE1qL/DVei1u/WEhSB22gNFTw4KT+Fb10+em75QgzfXseVytYSiVenxh6V+HNV0
pW9lvERKdVSwoXhES6BFoZfctr9XGkcbcAnLyzWuzoyMqd2Es9Hw7BOUjhNitOaO
JAEzYC4jX8teRP1hG55RcFoE22kA+eZWhkIT3d2+tuUXhCxc/GSmJtnN8zzdHxsu
DFgoYRLZA/oELxo7cKU6KBoFvUoInC29gg+i8z8QOCrVPkb+fw/5Mq+33F4ARzox
KB1su+gAxlzs4P3J9iSyXVN6XyeXH/Bifi/Ij6Jc7XbV6dXzICWZUh1viWKT0xtm
XQy/wkmIPfmGAi0c48M5sMmdlUnOVWZh0m73wXSkuaECAi7M4+ymE1Qlzd3oVOTg
ItikoGLyq7+x8M0L4zwa
=L+XM
-----END PGP SIGNATURE-----

--Y5wfsVCgeKAcINk2--
