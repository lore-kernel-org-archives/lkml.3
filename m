Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3A0GSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:18:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45403 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab3A0GSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:18:02 -0500
Date: Sun, 27 Jan 2013 14:17:54 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dongjin Kim <tobetter@gmail.com>
Cc: yadi.brar01@gmail.com, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: dts: max77686: Add DTS file for max77686 PMIC
Message-ID: <20130127061751.GF8952@opensource.wolfsonmicro.com>
References: <1359053177-17725-1-git-send-email-tobetter@gmail.com>
 <20130126050618.GD10580@opensource.wolfsonmicro.com>
 <CADoNuNeF_fw1uuMt89=gZm-A2R6FHGpr-kCgFkOY0xXpA9+Jzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Content-Disposition: inline
In-Reply-To: <CADoNuNeF_fw1uuMt89=gZm-A2R6FHGpr-kCgFkOY0xXpA9+Jzw@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z0eOaCaDLjvTGF2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 26, 2013 at 03:06:53PM +0900, Dongjin Kim wrote:
> Hello Mark,
>=20
> Yes, this is not ARM-specific chip at all. Just wanted to be reviewed
> by you and others if the format is ok before integrating to my board
> file. I had sent similar one before,
> https://patchwork.kernel.org/patch/1287711, and you advised that was
> too board specific. And plan to integrate like OMAP boards have with
> twl6030.dtsi and twl6040.dtsi.

> If would be nice if somewhere you specify a directory for such device fil=
es.

I think we need to create one, not quite sure where though.  drivers/of
perhaps but that's a bit non-idiomatic, or possibly something top level.
firmware might do too.

--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBMaBAAoJELSic+t+oim9DEUP/1ptp71bShO+8fwl/h/LJ64r
PsOayjfioyUsddyrn7lfoZZF4IHDn1tZUAiHKmSLYpa5kXvelzWRvQEQK6AvK5zA
CJ6cu0fOPPfJcXWGWkfxTUO/aCmlQCF5reYz2CxmMaiw0m3SY4emAjBGUvf8YrfY
29QpTpbtEGXb5d9efYdIP6skr07D2+/pt95ioijlaNQuS00yx8c3CS1lJuGmKXfV
YElMRfZ6cm4Se3t7H0c2+1xTaMahXNDmmhxow2NgtxujgFXtBt07wC9wuOX4hqJK
+D1Ab7s1K5+yRrIRi8BhvuxpmmW2FKiK1a/qvYTlNfw/wFoMPfTkhKdOyqUbw6mE
gasDY7Lc6Q3RmNDSOpmq2rwxpwc4fpUGjWGdmdxgljGMP7LIb4uLoK8K7NVE9DUf
C3iwf3HM5foNeP8weRakEMttxm9zizKvK1Wgp944Vevap8rP0tJSww1gIdVrbZTo
PT+ff1A+L/MnVaU9avLmDOvPba60oZ6mGE+ZT77VUxxukbumnoaWNr1FbmbEvDd1
xFWUqLv9wg5E0CpopyVerFe6EDsm9kHZIfVMSPqgH4vCYnpdXJaW1fHNGaefjrRg
f0JVz+XUYiig+rzKWLx+Q264NImo5v3EN+19LL1nHss9Suio4ghToqpVOpBm57ih
mAREFp3rUVCYEUXfbRj+
=3viK
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
