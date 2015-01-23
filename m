Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbbAWQJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:09:37 -0500
Received: from sauhun.de ([89.238.76.85]:45459 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbbAWQJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:30 -0500
Date: Fri, 23 Jan 2015 17:09:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: designware: use {readl|writel}_relaxed instead of
 readl/writel
Message-ID: <20150123160926.GE9592@katana>
References: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2014 at 02:26:41PM +0800, Jisheng Zhang wrote:
> readl/writel is too expensive especially on Cortex A9 w/ outer L2 cache.
> This introduces i2c read/write errors on Marvell BG2/BG2Q SoCs when there
> are heavy L2 cache maintenance operations at the same time.
>=20
> The driver does not perform DMA, so it's safe to use the relaxed version.
> From another side, the relaxed io accessor macros are available on all
> architectures now, so we can use the relaxed versions instead.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Applied to for-next, thanks! Just replaced "errors" with "delays" in the
description.


--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwnI2AAoJEBQN5MwUoCm2ux4P/RHPgCPf09ZnaKXE75M4hvk6
+IoD8wx7DymjmEpn8PVeDBnN+QMU0tKkew29Be8hnJNOElUfSXB2FdOeowa/k10U
HTPT/eZB4xBB1vLWg9naqOyHFX8jxZqQS+HysOoyXYDlklo+P8VSh4laNZApHPJf
ILhO1VB5iAO5SCk2onm9M57aZ8tjPyTJorZr9DTL59pp6sp0B+1o5vxkk3rysW+0
P7WYpxhJ0Nl5UxuZS8r6Yi45VLigfmMlZ1VYZgSuCcJKZjsaz7qRjqnBPFDlEYOf
OZE6AcwomepKoEuUMgZ6nDx+YeRM+859RCdcz5DEyM8F2neXuCJfyTUS1pKM5iY4
lkbKzP/DAINR0xGl/duhUKMF/Emqkpy4iLHrQ7EMDQw20GEuR2eeYbWdzmQa9YpT
BUJoBce4Oz/gXdqnTbs+2nKcPPyCKYXTkycSI8XaexnJVUIKAHETRoqxCZ+jJOgg
Cexyit878q79AFPQkmvmu857R3VpDp1rJf7dwfvRVOSEWm4PP566UxByM5graYLz
0GlBQmklTwJLNSw37yroQwo0mnkjy4NLP0Mqdo3/cT2PCLU0UfaVGrrifFzXcmh2
l9419dLqKPwPucpO7NUDxlHOQhduSBvFgDNKTJWXxi/6+6CWlalNEbCvu2XS/jAk
7KZ1O1+eNpgBR2jygbUV
=yTgN
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
