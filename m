Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3DLL0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:26:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57700 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753650Ab3DLL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:26:21 -0400
Date: Fri, 12 Apr 2013 12:26:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 18/30] ASoC: samsung: move plat/ headers to
 local directory
Message-ID: <20130412112618.GW9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-19-git-send-email-arnd@arndb.de>
 <20130411164751.GK9243@opensource.wolfsonmicro.com>
 <201304111908.42532.arnd@arndb.de>
 <20130411171938.GS9243@opensource.wolfsonmicro.com>
 <5167EA36.5080505@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ftt3SnK74BQwCaZF"
Content-Disposition: inline
In-Reply-To: <5167EA36.5080505@metafoo.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ftt3SnK74BQwCaZF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2013 at 01:04:22PM +0200, Lars-Peter Clausen wrote:
> On 04/11/2013 07:19 PM, Mark Brown wrote:

> > Hrm, someone killed GTA02 support?  That's sad...  if that's really the
> > case we could kill the machine driver but not tonight as I'm running
> > late...

> I think the file was moved, we should pull over the audio relevant GPIO
> definitions into the ASoC board driver.

Yeah, so I see - Heiko sent a patch fixing this.

--Ftt3SnK74BQwCaZF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZ+9TAAoJELSic+t+oim9uP8P/i1HOXQ5B8MtbPthMbo6BVVe
UDbTO4LTWolXJPTtdWpTU55OfGFS+gpQyG81d0n+MXZU036gw3N70aPZJbRLuLn4
TyTh7zdlTekhN/sRMyOYhM2JdJt/UBmu4i1lRVfh2te1Xlgitqg4N3ZQQLAkvX1n
F2zGsJt2iF3hT5wvIaAmxDsOpD0s0qupy/SABfcrze/XL0jzDBCuuU+8bCyC74ol
xZjmDiPMoZSWU64AU9eE84V2lcGEExFYWvbiHb61saHQ8RYrMc8Wew7M7T/3hHJm
mC83zpvnqCysT0/1+aAbHk8fonBW7czR9JF0j+ebo+Ac3gnADlgVo3YKy/oKrnN1
i6hwVrg9/KbIK8sq7HMEI16GHwXSqsF1+9GlNCmAxKqrpT3IawXfF4qnFnmk/uwc
6QOgOpiMc7EhTKtOFvmIkT5tyj0jOiEh02PGetm6ieEqMzbdXuSO/xXiW+2c3TV5
sEZ3bf7AyqTgaMY30Ql/71N8hYpUGyfSeKvLmjbyCTQA5cFaxmPRYnTDAb044x+d
DBep/Exd5qDGQ7ooK6nlCeDF4cxGH6T7iWEAPKFsh+IoNZzr57NEifxprjxbpkoZ
gigfJR5tGpDujl7fs010lmbSKUTJfZWDbXvdGptd5ypYKLsVzJmnxMcyPMVJw7l7
0h4Dw09bMhf6JZkfGZe8
=Dh60
-----END PGP SIGNATURE-----

--Ftt3SnK74BQwCaZF--
