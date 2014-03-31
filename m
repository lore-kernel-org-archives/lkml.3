Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaCaMIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:08:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49381 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaCaMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:08:12 -0400
Date: Mon, 31 Mar 2014 13:07:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arun Shamanna Lakshmi <aruns@nvidia.com>, Songhee Baek <sbaek@nvidia.com>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Message-ID: <20140331120748.GS2269@sirena.org.uk>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de>
 <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com>
 <5333ED3A.7040908@metafoo.de>
 <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com>
 <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com>
 <5336A619.5030007@metafoo.de>
 <781A12BB53C15A4BB37291FDE08C03F3A05CC6A11A@HQMAIL02.nvidia.com>
 <20140331112140.GO2269@sirena.org.uk>
 <533957C8.2030105@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UN41tlPsqEEbq75"
Content-Disposition: inline
In-Reply-To: <533957C8.2030105@metafoo.de>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5UN41tlPsqEEbq75
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 31, 2014 at 01:55:52PM +0200, Lars-Peter Clausen wrote:
> On 03/31/2014 01:21 PM, Mark Brown wrote:

> >The above is a bit confusing...  partly this is because of a lack of
> >context (what is MULTI_MUX_INPUT_OFFSET?) and partly because it isn't
> >entirely obvious that stopping as soon as we see any value set is the
> >right choice, especially given the addition to rather than setting of
> >val.

> I think the idea is that since we know that for one-hot encodings only
> powers of two are valid values the other bits are used to encode the
> register number. E.g 0x4 means bit 3 in register 0, 0x5 means bit 3 in
> register 1, 0x6 means bit 3 in register 2 and so on. I guess it is possible
> to make it work. But this seems to be quite hack-ish to me. You'd have to be
> careful that MULTI_MUX_INPUT_OFFSET(reg_idx) never evaluates to a power of
> two and there are probably some more pitfalls.

Ugh, right.  The fact that I couldn't tell that this was what the code
was trying to do from looking at it is not a good sign here.

--5UN41tlPsqEEbq75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOVqRAAoJELSic+t+oim9elUP/1ShTgGXfGf0zIOhjsSXh+qA
piIiERAxX51dZnNaLXg192209RzXYOWGh1NQVBaFJ+WdvNo1E+Ty7eHXMlYPQG7q
B5U9NtTD3jg7wR/Mq3EMda+Xz3WstpgVSPOLRa+r9tturwVMK2uNneVJFQ02I6Y2
ZEUnUEfqRe6YxC8UKCJCGOc1ygsjqn9GL3H3f+YFlBD1MYgA47c/rtfjDpQ+PLms
7kD8b+QgxFrxzhjtJ52+XLfDeM+F3TKrc7UKI3Lawmgxc9HW0yOIui1k2G81TXHp
qt3ZPtVXZwPOQMQ6gfkDhsr2Z/yCtyWWUwoHwkt1+UekhOZ0T8pkL/63ugIQXKDx
3jzoNrhPvasl/bc8YJjxKLO8KX35tI/qavQt/mAGy+AKZuczSAI/LR0XJjiJL5ff
cFwLs4PMrcQJTkyNvksVYc6wLLQjHfIM9HsBvQ2XUzmT8gKt1jigDC7EF6JFdgJB
UUYW0zYg2pGNy5v/3o9JftALBFK2bPgnSry/OUDy5n426kW9VPlMNtb955Vne0sC
xoS8JP1NI0vaNyQntxYOZy3l4nHK9NKFmF2PU7Nb12dMkqpimgYPksnDjytqrgnD
v5m6+wPcb1N/KsRSrTkqDi3FfO9bjmYmcT3Z4UsxiBMi6NuDgWebeMMBuDC1cjlK
1Qs5nVOGFOeCdNsViZ/O
=KPR7
-----END PGP SIGNATURE-----

--5UN41tlPsqEEbq75--
