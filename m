Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764448AbbA2Dnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:43:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38400 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbbA2BZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:42 -0500
Date: Wed, 28 Jan 2015 11:36:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, tiwai@suse.de,
        perex@perex.cz
Message-ID: <20150128113622.GV21293@sirena.org.uk>
References: <1422416667-5087-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GJTQ6IHFmTX0wybY"
Content-Disposition: inline
In-Reply-To: <1422416667-5087-1-git-send-email-standby24x7@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoc: Fix warning with make xmldocs caused by
 soc-devres.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GJTQ6IHFmTX0wybY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 12:44:27PM +0900, Masanari Iida wrote:
> This patch fix warning while "make xmldocs".

Applied, thanks.  Please use subject lines matching the style for the
subsystem (ASoC: ).

--GJTQ6IHFmTX0wybY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyMm1AAoJECTWi3JdVIfQ1EkH/0aE5HpQ3ZfpQfcA+sN1pL/0
NcZvJzda+9ua5L1D8Q9X8xkInNYgQulrHaxJcUlmlX0LNTDE9wrDvtrDhSTs+ALv
kWrTBGlh7tdth3fKRjKqMa/qcHfpiXx7uh7S18kYcBqa2wnC+iIH1Cd/SaannzKC
fbFdO/XRBkhKni0KPLC/lVuWq2zJuG2BmN5yONHP2pr603yRV8EyTUx1vba/we1M
POTAlW5FHUQGcHu0xQ7uOrR3cwnmVyFbLRetLaLD/OkIU6roP7Qrx4orG4UE+3o4
6sPggyCkwWTdEFxWJOsaGzJ0YXnXqokIgczSd2ERPJdp+zbijyUiafpKcBV73JM=
=Y1B8
-----END PGP SIGNATURE-----

--GJTQ6IHFmTX0wybY--
