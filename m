Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaB1FxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:53:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53484 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaB1FxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:53:08 -0500
Date: Fri, 28 Feb 2014 14:29:04 +0900
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Message-ID: <20140228052904.GP9383@sirena.org.uk>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
 <20140228035244.GJ9383@sirena.org.uk>
 <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bxyj5TNvuouCjAp1"
Content-Disposition: inline
In-Reply-To: <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bxyj5TNvuouCjAp1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 04:00:38AM +0000, Li.Xiubo@freescale.com wrote:

> I'll send another patches to applied to use this for another CODEC drivers.
> And there almost 80 files, Should I send them in one patch or split them into
> individual patch for each CODEC driver ?

I'd suggest doing one patch that covers the boring drivers where the
first thing they do is call set_cache_io() but split out the others into
one patch per driver since the need more examination.

--bxyj5TNvuouCjAp1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEB6dAAoJELSic+t+oim9nnUP/2H1O8VLJKW3obrtKkdv2Ezt
RsvDa12m5Opc8jS5hKGTzqFQP+/oTg6sq/SdJCGi+BiifLLynzO+D1z//3JNNRpN
ZUiPdcU7ttjEr9vyLrmZ9QUFk42oCRJlSI8BrraN15meLS281pXBg9LhSJG13ckz
wcvcEd8BXV3VnMyCSNnl1zHvNtcbFeFoQQ9GobDqPkz766BilGwsIE65SEhHvyMd
BelaNFxr6HpUl888PmyWa7zTmUHe0wfA2LyhWYNcNLUiceSImtPSK4NtbNanCSeb
m1/1wNfwb7vcjcHgDHaREbwAoKngcyltb+gY4x+7eJwhq0FTike4qEgmN2hkeT1h
36VqNQIvLWUgM+a9W/L1lxv4pYa/dGS4oEqn38MbOSd+5XmNKdJDfeABdc1Dk1wK
Jr8Irkc++/XFZmoubXaPsGFegnl/Is3rZJRlTvy75LGMIdjkpNqaUVuk+PSa+4EF
XXvGPSJVczbELm+dO3Xn0qVCrn3kyCWpKmObSvMVv9tyjRQ2gCEIhZ3BZ/sVd83N
vpUlJHaQOkAjcFY85SBc9GH8PGuIppelCEpbc1QR4r5mS7W/C81WHHQ6pOBMnKCJ
nhkfTpRoGx7hm1tk0ViIMFeWsUvGjP3X61nkaiIwDRfVF/8R6TJ0NG/D5DeQ523V
QkR9CypCblWCrdj9C7dl
=bCAy
-----END PGP SIGNATURE-----

--bxyj5TNvuouCjAp1--
