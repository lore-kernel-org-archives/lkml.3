Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHQIFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 04:05:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47538 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751092AbaHQIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 04:05:05 -0400
Date: Sun, 17 Aug 2014 10:03:33 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] ARM: sun8i: Enable pinctrl, i2c and mmc
Message-ID: <20140817080333.GZ15297@lukather>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5OPIRG5sBUHnKBkK"
Content-Disposition: inline
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5OPIRG5sBUHnKBkK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Aug 17, 2014 at 11:52:06AM +0800, Chen-Yu Tsai wrote:
> Hi Maxime,
>=20
> This series enables all the controllers on sun8i that we already have
> drivers for, excluding SPI as the tablet I have does not use it and
> I cannot test it. If there's a way to test it without external connections
> or devices please let me know.
>=20
> This series is based on 3.17-rc1, however it should cleanly apply over
> the sun8i-rtc patch you've queued.
>=20
> The commit logs pretty much explain themselves. Note that PLL6 is not
> implemented yet. I've some patches for the clocks that I will send later.

Merged patches 1-10.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5OPIRG5sBUHnKBkK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8GHVAAoJEBx+YmzsjxAgyZQQAIg8H6O2qjoNjx0FMFYXzCvs
9EG5MD+Uux40qO57gT2QdePo8N81T2Jx0maa6CSPb3ha7pWfwY/uv7oxSyCH60K9
mKFq5lLKjtVs9iDoaxfEM+jOfKdmDxg7+aBtWdeCo1mwPxf5zEfCooXOO1fSwiJS
TFAE2svim/NlL/wF3zggRVpvnbSgnHiTBG1uZdubAJ03nn171I/n1oHNolSnGvcI
GAC415pUJQ+WrVL2AuQW7Hij9Ih3mPWGDz22COtW6V3xbBs5BllSdCIoEYQahoew
5WnRdIZ1G/JjP3Y6QvyrzDwIBZv2ZS0qfXWX51m/qHnljgEt6hyS6462jxGf7gWr
5XLtZ72oZzqYH89a6ohbmlq3TEMziFnqyVmPOlvnxgrbL7vCulp+LpT1+4mjZo7p
uxps+vUt8gjyn3C1bXJZRtAexNpCjQpfpfWuzD7P57n3YpT1x0pfp3vlVMfTPBEK
xn8cWDNuFO3hECyd/o2lpovhh1ay1IoHpANctT2+nQIHAD8ppoE12zcmo5xCZViy
DimPPcOrkS3bL04yDfX3lHaY2Gg6I1+uXsErw9qrgMw0q5+VsiTNDiiuDaBRckQH
yLcHcsKEjjB0MXYFJvrxlahjpTW+SCjA6Q/w/8rQZfWN+nkkkmRiP2GgfzcqV8lm
uh/xpeJjhIN09OCtoY8n
=mpCZ
-----END PGP SIGNATURE-----

--5OPIRG5sBUHnKBkK--
