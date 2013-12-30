Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3L3MHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:07:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50527 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3L3MHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:07:39 -0500
Date: Mon, 30 Dec 2013 12:07:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131230120714.GP31886@sirena.org.uk>
References: <1388040763-15653-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uc2nn8srCdMFAHlk"
Content-Disposition: inline
In-Reply-To: <1388040763-15653-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: act8865: fix incorrect devm_kzalloc for
 act8865
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uc2nn8srCdMFAHlk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 02:52:43PM +0800, Wenyou Yang wrote:
> Which cause to allocate more needless memory.

Applied, thanks.

--Uc2nn8srCdMFAHlk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWHvAAoJELSic+t+oim9v3EP/3Kp3RJsQfp/g1un0DQ6cQqv
D9jJVrlsy6nQVAiTi/eG9CaKXVl/svuGkOJcT36ukgv1CjMJOEonPdd/yHASGhXI
QAkiJRwjrjUgzxrTCI/sDnToDdGqPiPvgDV4As7oFuNUg7XgSjLAdorMzsYWVKEm
aAnn/IVoxFeDJ5tFMTYrRWJzdBlSTRNr6c76yFBWM0hq18j8jXgwl5fVelnilymw
xeFyxs2R7h7O4yyNkoz/5fEf98G5rieBRcLZ+rJqZlpbEzTFRvDgQ5Xqh28gWNp0
9yPitW6Nmh5f1hdBoHGOijyJDvxL0UltJjhOF0EA1+hcDiCHPC4Mzc+rAGpKpeke
LTTsQq4YFz9cT4v/mR7w0U9AbGHDxt19iLZFKr/AjtXZWmYpzOfxBkHhCmGYUBVR
U4N1h+ea03pflPoJEIYewg/51nyfOROGy0ekXQp87RiwhmHNLuSkTz/gs2tFLAb3
hU8azj3JMyhl4TRaYxLjqlUJtuMP9r+D9kTCA3fUGnsf+1ThHX/hyFVmCU1xpWdK
mzMgbwr0/iT1XWrsqXrp+IRXhNf7Ukjm5KuK4fPMezM3Ra/f2f64QeLQLNgoRYPj
2cHf9ETnAzDoUnr7cTv2ZaJJo8VnmyBj+Z4jduVsXCKQ9sWASqDFgILybD1LjzrX
akOteZF2bQoHKH2WwAsb
=rCcR
-----END PGP SIGNATURE-----

--Uc2nn8srCdMFAHlk--
