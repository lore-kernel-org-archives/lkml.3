Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbaJaSOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:14:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59629 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaJaSOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:14:24 -0400
Date: Fri, 31 Oct 2014 18:13:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141031181353.GS18557@sirena.org.uk>
References: <1414771454-28260-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oCBi484hqkmKfthx"
Content-Disposition: inline
In-Reply-To: <1414771454-28260-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Staticize 'regulator_states' array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oCBi484hqkmKfthx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2014 at 05:04:14PM +0100, Krzysztof Kozlowski wrote:
> The 'regulator_states' array is used only in this unit and it is not
> exported. Make it static.

Applied, thanks.

--oCBi484hqkmKfthx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU9FgAAoJECTWi3JdVIfQysoH/2sUXTFfP1YwUxIr5mlpPTBA
16/X26z19InOI+LDlvceKksyLFtyWdHoQ/WsGR17usAG+/x9IjcYgPoA2QO2XYAR
03TBNFcrjD5QNxUsGABVzSeZ5JQZOVRvgBv2YnQIHiZdBCJTNio7D7SyImkmUChB
x1wKDMNxGN3EE31E5UNwenhaxFVlI2GOEUvIoi4p7vWhwC2dC5gnQSO8SzdhAtTi
/ZrPmiLenxwT9UKcO9KYCS1bxemiMiogc2QjcNLH5tnodMvg7doQweks5wb+Ed8J
zSb7CbWpPG6+Rgk9AZPERemuVtEmIJgTBU+lPmlONUx5PrtHL5WrS4qHT1Weiyc=
=guKX
-----END PGP SIGNATURE-----

--oCBi484hqkmKfthx--
