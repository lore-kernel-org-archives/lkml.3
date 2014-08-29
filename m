Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaH2MAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:00:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39470 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaH2MAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:00:52 -0400
Date: Fri, 29 Aug 2014 13:00:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jean-Francois Moine <moinejf@free.fr>, Jyri Sarha <jsarha@ti.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>
Message-ID: <20140829120035.GW29327@sirena.org.uk>
References: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cxfMsoqvp1jUizWj"
Content-Disposition: inline
In-Reply-To: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cxfMsoqvp1jUizWj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2014 at 02:46:37PM +0800, Xiubo Li wrote:
> This patch merge single DAI link and muti-DAI links code together,
> and simply the simple-card driver code.

This will need to be rebased on Morimoto-san's changes I believe.

--cxfMsoqvp1jUizWj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAGtgAAoJELSic+t+oim9EFEQAI91fXdtxJbdSr3mBIG1vnOq
ouZ+3lP2ITAzXFdQGdnuPUnW40FAV4xcrPRZq5wTMI0xYI3m45ZvwxGBN5OtSOCv
hdHo8/LRGgqnLUIhwTQvJe6vzX/YnHlM9bi9IKU+PxtOVWlB4LhnpbKMQNivBJ6r
jECRo2n2EAnWUdiPlJYfgE+21PWAPX0oZSGdU2NFR/8+2US79su4asvJHBIfnAUI
iSvwQ0RR7+y0pfiuw4raQ5NhPcAm5DyEEXFWklhtECdP8WeAaQ1s422zyU8UkmMM
rjYFccvtc2gHIF+bsd3k2u52N+ZTbie8W+ov0kwqcnzLG2oi7EZy/efWxdv3cWQg
O8OqqzCOMckfACQcmG+t+LUa4/r16NbslV7XCOln/SzqGad/38WqE8idPcuIeCGz
bhok28KnQqXZQfj8G/a4CofpGzFIfq4dwt6YL7h786k5DQJFm3ahzCTDKHq4HTW0
hO2DAL+QMt6u8Jwx+M9jyL95uqrMD7z52GjQrwwnXtpwbe9zMKCcGjtxTbKlTsoi
J1avdoIdqidT02iToimsyIgxC4gqNe0RdIic2tXNpYJpcqpPtM2PC2utg0KPmhsV
wCJNO2FxY2yhKdGeKL16s0KkmoWdxmAHhkG4ruMluClNXglXyc0dwYOBfBk1Io+z
GwG8YGZyhMWTJxPl2OIs
=ESqC
-----END PGP SIGNATURE-----

--cxfMsoqvp1jUizWj--
