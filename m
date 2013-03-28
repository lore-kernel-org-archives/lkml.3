Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3C1AJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:09:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41792 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab3C1AJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:09:36 -0400
Date: Thu, 28 Mar 2013 00:09:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 13/46] ARM: ux500: Add supply for the L3G4200D Gyroscope
Message-ID: <20130328000934.GH18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-14-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uEk0Atr1LEsANNXI"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-14-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uEk0Atr1LEsANNXI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:59:10PM +0000, Lee Jones wrote:
> This patch lists the L3G4200D Gyroscope as a consumer of the
> AB8500 VAUX1 regulator.

Applied, thanks.

--uEk0Atr1LEsANNXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4o3AAoJELSic+t+oim9lUsP/2wQ/Eze1dpb9DXaiPQDLVgc
8Lu/1bQSi6O75utRNOBgeSxoFhkWqpEb91LQxZNc8Tl/46IBFOECPjAl27Zmr5da
1XA+fB/acVXwwByTp2chHgWKH+XvIbYxYn8mxSoPksi4jLewrtQF37oXEdrkFl6P
IcEYK812tVIytLE3BSR3k7Gf2sur4mJblDkpyK5+/BtEiXZiv1fXuKtj7Sm8Fd8j
cy86xIH8dgok/5uzUzAa31YEsMhhXLAjA/gcvyHyQvhDdMUGfbtIcQ15yifLfp+g
1Gv9oeKRIo7/xRMKAy0+zFulB0F9CHCXTM00AQQwo40iI8nDQGZub8f87I1i9G8Z
8wF605S2mpQhLNT3RDIFzscCkkev6/15cfnNPD+2OOfhQfsIr7FqicplK5HZVLPV
UccigPekkdrZVCKPsE0QV34oqWxCHj6gzyPuZfkHOimil3iBgB88szjkYU2IDXtZ
jEv60Ls0p5vqGDqq7c2mr5vZaqR9fti7gR9ZLciuSo8ZQjr/loIEx52UVO6D0uOy
K6XJrQV7fiT04JrY36oW/HINwRIJTh4w8+i6TctkiLhibTPtQo3+Jw7LRsw+sYiD
mhPYupC+I4GocZBzn3KfsCmEeMRSijruq2N2JlhR/4hMONaBGTBVHutKvWE3b8Ej
8GU1YA0cADWtXMDSTNzs
=K45+
-----END PGP SIGNATURE-----

--uEk0Atr1LEsANNXI--
