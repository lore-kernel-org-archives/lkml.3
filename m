Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaKSKLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:11:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52780 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaKSKLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:11:12 -0500
Date: Wed, 19 Nov 2014 10:10:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, huangtao@rock-chips.com
Message-ID: <20141119101033.GW22111@sirena.org.uk>
References: <1416366365-4632-2-git-send-email-jay.xu@rock-chips.com>
 <1416384447-29391-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cxfMsoqvp1jUizWj"
Content-Disposition: inline
In-Reply-To: <1416384447-29391-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: rockchip-i2s: dt: add an optional property
 "i2s_clk_out"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cxfMsoqvp1jUizWj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 19, 2014 at 04:07:27PM +0800, Jianqun Xu wrote:
> Add an property "i2s_clk_out", which enables to output clock to outside
> of rockchip SoCs. Let's make it optional since not each board needs it.

Don't send new patches as individual followups to patches in the series,
repost the series.  It becomes very difficult to follow what the current
series is (which is the latest version of everything, what ordering, is
everything still in the current version of the series).

--cxfMsoqvp1jUizWj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbGyYAAoJECTWi3JdVIfQSykH/1uSVGqRMROmMaERGIblI/+q
ku9API9K0Jy5rUkFH6VNhF6CLe5Elt7pEESv5TbluSdjG+iT3v9CM7MbAftepUzT
NQrYkMAW71NtKA3Ml4mT+QmcIGCxADnbykJ6ZTPj5MoOjxOH3AkpjKy1MAdVAG2s
cEY2fb6A6MmmQokurkm9wbiDQn54J+0piYCwMbFrSA8zzHR/mX6TCiaBbkR1VUxB
cUbQL2hbZslSvGPi5YHhXZVUm7vTEQ9EhPRbI5kPoOT9HydN9BoeLaJr9n5pRv/9
1gt/DNffIqeTpr7UwffrwJkjg/0VsVoL+/q/h5EZUmYg7twKtzB/6HX81y2ftmQ=
=KcGU
-----END PGP SIGNATURE-----

--cxfMsoqvp1jUizWj--
