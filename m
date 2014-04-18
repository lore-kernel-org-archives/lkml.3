Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaDROse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:48:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37895 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaDROsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:48:16 -0400
Date: Fri, 18 Apr 2014 15:47:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, AnilKumar Ch <anilkumar@ti.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Message-ID: <20140418144754.GS12304@sirena.org.uk>
References: <1397562458.24265.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eJIOSMPwREKhP25"
Content-Disposition: inline
In-Reply-To: <1397562458.24265.3.camel@phoenix>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65217: Remove *rdev[] from struct tps65217
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eJIOSMPwREKhP25
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 07:47:38PM +0800, Axel Lin wrote:
> Now this driver uses devm_regulator_register() so we don't need to save rdev
> pointer to tps->rdev[i] for cleanup.

Applied, thanks.

--0eJIOSMPwREKhP25
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUTsXAAoJELSic+t+oim9a8QP/RJkvAwNlQJuJT6Xr7VC+65f
eE0KmocDT66ekSlAOkSyBEFSUv8d8QQn4zYy8wUsFNV0OgmipbME7F6E1jKaHNYr
Y7B1Xy28Vq9Al853jyzgvnZGvsNrMCCikXP/v2gDCplzaMQZHSj9McJdhI7K3CmV
X/vB4MQFx75orCKb/NmY9lQHYcnRxV/uFdTKkLB+9zcSSRWd5EYr40UWVT3cEpkz
1rZesk9ug9QiXCo0QEOXqH/NaEG2+B/EHXbF3ocg53Wjiw28ub+uRryven8biojd
QqtFOxG83iTFmkT3NUX0YuqdrKxw34Thcmzq5/NO0WUFJLlz70EcMKbbeOlMpS1T
JUXY7YnLNbsOraBQ9chCIgiynUZOemyfGmpe6dVfBxalbxo3wFToWorEaC7qlRED
ShxwoG/YDdnrQeIchpMcGez80GJX67R+RY7ntuUVEX4EgRD2R/+250OgOaqa9hGC
rnLb19C0Q0RNrZLw8cpCL9rDY3pkTKkQKbPo8Dkr9OKHY/N4u9tC57Qa1SxZQd+C
UagvWlncDWDtQUZ3ROb39SpWG5qdkT+MtybapMVCrmQ0j1gX9oFrJuDVueNL4b3K
Z6J8OSDsxcRgHMcUBaYJy/Mec4Re5JUz87fE6dN3dZvufOedooe2v/DmaIzIQPpH
cq8lmpHgIFdoYge/d5Gf
=jeDi
-----END PGP SIGNATURE-----

--0eJIOSMPwREKhP25--
