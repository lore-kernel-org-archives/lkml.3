Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaCQQYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:24:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55378 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaCQQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:24:38 -0400
Date: Mon, 17 Mar 2014 16:24:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140317162429.GO11706@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
 <c74668c9277d538b105ab93affe7d33a64342ee9.1394883134.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmZU9S7l/XJx5q9b"
Content-Disposition: inline
In-Reply-To: <c74668c9277d538b105ab93affe7d33a64342ee9.1394883134.git.moinejf@free.fr>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/4] ASoC: simple-card: Simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmZU9S7l/XJx5q9b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 15, 2014 at 11:32:42AM +0100, Jean-Francois Moine wrote:
> The global DAI format is used only in the function
> asoc_simple_card_parse_of(). So, move it from the private data
> to the stack.

Applied, thanks.

--ZmZU9S7l/XJx5q9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJyG6AAoJELSic+t+oim91gQQAIKf40P8EO2BMSQ4se/bCcdK
LLzRJSybjhLFs6M8rcRFMf2of5TCpAzBoFWa3Wt3c12A1hRN/hGs6Zq4YS0EfjRw
oPKeoDyKsm45Vs3SEBi+mUsHa4D2hwr4L3NpKHtP5RIBXPnefHIxaG9ztUp5cwhz
29sSwf3Uv8GncMK8H2mZ64xyOulJHwji6YjjkK+2Qp1u1/2l4eIlLFznNcjnvPpy
bm10/AegD5adbEqeS6Q68Kracn2IS0OygZT1oReLT1ofBgHQflB4Gz6QnWaLc35Y
NMaUw2kS0zPzGDHgAdYg6n5hUbAY+cQnPmJsCABjj1qlPHVwdooVsX1LFYi6Eh5t
16bNrqHgxLZiAlS1xEdAhWr5Qtsevbykt7P+wB/iWL3jUBI7UEjHNEqQ6PLskzef
ltqfQobmBydtprN9sOqymIbPwjXQDG8fX9Tg0s+ni1YNIxgwO201NOfeuhVPaMpq
ay1Jh1QlPaQLQnbixaKxb6gpxUIu2iGAJXveXV7ai+kvAyjsxCbzk7vjsEayq/jU
6HNLSScwoBoLTpkKG5vDKz734JFpIR86lnbRmX/Qa9GwuTpzbXbmU+BXTwOausrk
bzFKbP46ZGw0Be22YGZpqPNjCfpwOTA+8QTwQ+pGkUSMkCi8BHgajBgqMZBGbeU3
KE65qNX/pzB1WVYwP7td
=1S8r
-----END PGP SIGNATURE-----

--ZmZU9S7l/XJx5q9b--
