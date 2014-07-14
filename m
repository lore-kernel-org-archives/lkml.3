Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaGNI30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:29:26 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45132 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaGNI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:29:09 -0400
Date: Mon, 14 Jul 2014 10:29:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v3 1/4] drm/dsi: Flag for non-continuous clock behavior
Message-ID: <20140714082903.GL2081@ulmo>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
 <1404822734-8603-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline
In-Reply-To: <1404822734-8603-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 09:32:11PM +0900, Alexandre Courbot wrote:
> As per section 5.6.1 of the DSI specification, all DSI transmitters must
> support continuous clock behavior on the clock lane, while non-continuous
> mode support is only optional. Add a flag that allows devices to indicate
> that they support non-continuous clock mode so host drivers can adapt
> their behavior accordingly.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  include/drm/drm_mipi_dsi.h | 2 ++
>  1 file changed, 2 insertions(+)

Applied, thanks.

Thierry

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw5TPAAoJEN0jrNd/PrOhlUoQAKbtjd+7jG3NQlrpEH5M+uIE
04sBQC/+fBRjfzbSFOvKxrsuVNnhxzWnjh+9C0xHvvZCgF+Nk0lwRr66YHhghIY1
3S+DEzBYK335pwNGND7g7+no4aGc7tfmzV1ufB+wvylynxJncmPFB7FdiIzFXNhW
fMmY+kmDJOndcHHLDQGbiX5mz88Lqs8NRin60COKgsPx9mVybZ7G+Ls/N8RliHlU
WxnvqhPfrp4anZZM6+lSvkCgp1H1gH5wN4RV1t98lzfITDuZHhfEjv8R5joxoWQp
1Z6GTzoAakuM6KmTJ8tOKLG62PeVCWTXibVyMuseRqyMgo8/wTVPGeksMufddnmZ
Cw3hI98ya8xPN6AZfO3w0JrgTlo9syXlTknMcaUXQNSPDHZJJ66ncg7lE01cYKgm
g7RazkfsSe0gMzRmz52IYyJJJ+WFvLeioikPAoOxgfxIwQKLAlnhG2ynFck2dglU
7hwEle3XPv348XjKL0+qleMhrjIckyCZem12h0zMrgOzjmywN60adU/6VlMNEG0h
UWXu5bD8FtEF0w1miCHx2r7J8zDyGR51I/hSsHmZkZJ3gmuooFiTgIu3T6nax/wR
ha21JzP2e6d6PoEdjHJg7xIpey7Yp6sr0ufenFN1tfAw9Q3H6Ab/Ix/DFgYz7WZp
2GFFIQ7gwANTR7c4A8Tu
=JYoN
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
