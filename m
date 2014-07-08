Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaGHOz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:55:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52954 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaGHOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:55:58 -0400
Date: Tue, 8 Jul 2014 16:53:56 +0200
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Axel Lin <axel.lin@ingics.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, linux-kernel@vger.kernel.org
Message-ID: <20140708145356.GY30458@sirena.org.uk>
References: <1404769247-12648-1-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JkgDhDyNm4zanevS"
Content-Disposition: inline
In-Reply-To: <1404769247-12648-1-git-send-email-b.galvani@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator:act8865: fix build when OF is not enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JkgDhDyNm4zanevS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 07, 2014 at 11:40:47PM +0200, Beniamino Galvani wrote:
> act8846_matches and act8865_matches are defined only when OF is
> enabled. Move references to them to the act8865_pdata_from_dt()
> function to avoid a build error when OF is disabled.

Applied, thanks.

--JkgDhDyNm4zanevS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvAYBAAoJELSic+t+oim9k/gQAJRmmZdhwRzJMuAxIjQXBMgd
F1ooSNT3WAB7PPgpgi/IGE9kpkrvx4i4R9HYg0AiG20vv9/4gtF691HoiJY+qdUn
SnYQKWXeWSPo4mn72g2i3QYLXVuoMhP2YJjFjCcCI8n02f3NkRtr6F56y2cpwfGx
Bj0+oj0P2iJ04pJFMntyJFTNYdNaU+GDruSUFtpcI/d6F+eiPkoPUPkaI4gGYnvr
4/vXwjJixqUIT6aAy0Z08XGU7XENjxKSwxESGBsxiE2HZi04x+vc1Q2Uo9SK/kbX
e9HN5ixlq5GM612jzXvyI1J0FmkGmy99EYnlwaEAvXv+YNhbkYcQqiLhczqvs4z/
AWplRfui4PDo2gHQ7hp1eYR9cZQTCParKzNZ6pBKxdtH179KTuM3RK3HRK3Wiuld
7PnmoqWHkN+K/U9x2asmDC27BzZxvVDFY4JyCJKYVJjt6wmgWIMws24e6fredXKA
VoA7d4j4iLBhnNqJe81ck2BCPMZ0kmvIfuI6oy2R7QCFF7pBbuN3EVsg6whDVfPR
CHsnQMqRlc238GcDGdXwIHG9S1E8IWZp2d9O58NAArrG386uo4hNsqzjE9gL4XT2
NTViq3xOPubejP9Su8zrjcjyxTezZtikPJF5OYWODYdLkmMPq6c2tbHB48ks+Tzi
BnXOjcfaUYYpixmP/0vY
=MXcN
-----END PGP SIGNATURE-----

--JkgDhDyNm4zanevS--
