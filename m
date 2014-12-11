Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbaLKNNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:13:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55619 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLKNN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:13:29 -0500
Date: Thu, 11 Dec 2014 13:13:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20141211131305.GW11764@sirena.org.uk>
References: <1418301551-31678-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pJYAKWPIlN1lq59k"
Content-Disposition: inline
In-Reply-To: <1418301551-31678-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Fix dwmmc failure on Gear 2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pJYAKWPIlN1lq59k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 01:39:11PM +0100, Krzysztof Kozlowski wrote:
> Invalid buck4 configuration in S2MPS14 regulators caused boot failure on
> Gear 2 (dwmmc_exynos):

What is invalid about the configuration and how is this change intended
to fix it?

> [    3.569137] EXT4-fs (mmcblk0p15): mounted filesystem with ordered data mode. Opts: (null)
> [    3.571716] VFS: Mounted root (ext4 filesystem) readonly on device 179:15.
> [    3.580836] devtmpfs: mounted
> [    3.582033] Freeing unused kernel memory: 284K (c05b4000 - c05fb000)
> [    3.629842] mmcblk0: error -110 sending status command, retrying
> [    3.630244] mmcblk0: error -110 sending status command, retrying

Please don't include large log sections in commit messages, edit them
down to any relevant information.  They get very large and obscure the
relevant content in the messages.

--pJYAKWPIlN1lq59k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiZhhAAoJECTWi3JdVIfQ9rYH/35zclf/Xq86IAWoPvXqcdHC
66cJhrKeqYdxlmM8UgLnaDinKnbwj4dK4conyKyGIlfF89caJt+PaPrqBAa84KQQ
qG4C7hrN3vqQ8P1SSwoogYLSgzuGEuUSt1rVDX6JspryXEC6WoQ4vtIJccMM4qkp
q+LHKQksNKkQxo1SDG+b2NE6ZC7J3d1f9JRFwCuEREhISzDRZDbi7LbCmQS0qTka
34P06xB0VCKJcN1tXJrFZVpyakWrBOBAESRaERvlcLVxNizq55l0ChJvPSclsvC3
UwIxihBp6WfX1p6EzM4bCCU7r6i0LuWubGJ9OAHKSwrA8mVMT+dlZeLHN5ZRMao=
=Zyli
-----END PGP SIGNATURE-----

--pJYAKWPIlN1lq59k--
