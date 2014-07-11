Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaGKNDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:03:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59905 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaGKNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:03:48 -0400
Date: Fri, 11 Jul 2014 13:57:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Message-ID: <20140711125727.GO30458@sirena.org.uk>
References: <1404998973-19425-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8YDLdOu/DaKXZo9W"
Content-Disposition: inline
In-Reply-To: <1404998973-19425-1-git-send-email-geert@linux-m68k.org>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: core: Fix check for dma_map_sg() failures
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8YDLdOu/DaKXZo9W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 03:29:32PM +0200, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
>=20
> According to Documentation/DMA-API.txt, dma_map_sg() returns 0 on failure.
> As spi_map_buf() returns an error code, convert zero into -ENOMEM.
> Keep the existing check for negative numbers just in case.

Applied both, thanks.

--8YDLdOu/DaKXZo9W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTv980AAoJELSic+t+oim9sYwQAJDgKENYtsvRI454BTuk3XEV
pX/GLnxBrRuoFA9prhYrkVRvu7maaCb7WrvEVBLVi+Utvgaes9r7LERIVtDpvbzk
3mYMbcArcRuE5iJLIErEM4zV6YNhSTKjUDVH46hoYC/8O6VVkEl/7Mv+0iU86hLw
C7t1FhUOJs+negEOqhNy/89icy6uBt+MiMh2/GbvzUNcYJhKmFFDunYB2MuCOyAM
abXE4JIpvsmLrmvehllqUqj8sesaYX3o36Pwr2/6vaQBowjB9gLA7CkMNzBnaeCT
GxFKU9pjzIwS52uRf2dPbkv62ywDg57as4HQGcLiM9h1vWO0el2uDru3amm6bGXL
IoQ2giD9+kq1mPuPT+A/v/DRFfznuVB9lVGHt38Nyv3nuTSo18GF2AjQwVFd0uuf
Dxchf/y0VKZNyEeg+lQbG/APjWTtVLA809G2q6/cz3k9Qlas2OTqV3/CFZUKhlAM
yFgV3U0taP5VUWMN7wYwn967mp/Q5FXzblOUdoAJnwjmcoK5IRfqhNP2a7tmvO2j
14K5PLLXuoNKXYRVKPTk+q+d56pzk7hRcMHYC/7cJ0YYbeGUoqt0cE2MPrytuBPL
VjOjuneDITMZlXpwwpEgNHOACgCQ9idmi4JNYXiJ9DKeZRH7R3XTOQJesSFae3Or
ATWefCuGYb/+7TOYnLgP
=XEK9
-----END PGP SIGNATURE-----

--8YDLdOu/DaKXZo9W--
