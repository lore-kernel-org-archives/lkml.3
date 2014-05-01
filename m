Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaEAD2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:28:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53482 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEAD2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:28:30 -0400
Date: Wed, 30 Apr 2014 20:27:56 -0700
From: Mark Brown <broonie@kernel.org>
To: "Austin, Brian" <Brian.Austin@cirrus.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Sangbeom Kim <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <timur@tabi.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben-linux@fluff.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Xia Kaixu <kaixu.xia@linaro.org>
Message-ID: <20140501032756.GM3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
 <alpine.DEB.2.02.1404292124270.31465@heelrod>
 <20140501013103.GK3245@sirena.org.uk>
 <13D36045-EE68-418B-983B-2704C52391E3@cirrus.com>
 <08914164-8CE6-4170-BC21-9E2840FFA05E@cirrus.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline
In-Reply-To: <08914164-8CE6-4170-BC21-9E2840FFA05E@cirrus.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs
 depend on INPUT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2014 at 02:16:27AM +0000, Austin, Brian wrote:

> Apparently not.
> I would like to come up with a better solution than making INPUT a requir=
ement. I just need some time.
> In the meantime I suppose it=E2=80=99s OK to apply it?=20

Yeah.  Realistically it's probably not going to ever be a practical
problem - the number of systems with audio but no input is likely to be
very close to zero.

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYb8yAAoJELSic+t+oim9f6MP/0lgFQcPPeuzNIDEPL1BV1wH
yI7YE0wzwqx/X+uCgqopEwByqSHyXpeLH0T88IgGO1bNQEjacGuBmV8jZTokLoHx
rFPrKtePOpLHB1dMvcUJw4AasTi7USBns56E63vAaRZhH60XCHkuTOMcOSmhK2Z6
C3uFqZqCher8bNyDMex+ugWaYQHtGQrTfTxkB6fyHhzdPv4d/jhjFWnXgiteeHR7
v0F1X9plvowRnabfjoLIKy48L5kShkNiLWCE7F1lD8OEGibhBWMjjBVpjimpXZxX
Sdg5pPIhABW+DF+Bo3t0hEOUifHnyUY8ZKnwAU99JPL3+5jrC6d/KI02cncjGMnb
CiOrQY0b8KbfsZLUlpwsVMwaGDGYWdWhXhr3DLq3bCHXjIjG6rTadJAWIJFUW9SM
Ew6wgUasMhNo7U88oh4HwN3CQYsoY6lR/YfjLwgYZiCcFEbxZq8k4D9r0n7QviHD
vH8s79eJrr6gtJDQpPmDxicAxjhDTaollEUawm4n0RWA1TSTQ+aQBdD8QPPXv0kJ
apn4opVPV/vsw4mPNEJhCFlNvHH5pCB+NOL4IyEj2qG4IHdbWP2vmSj4oDVJLJ+c
zJ3WSlJBWZ50NWx/PuJc1x/R3lSXWoWcdkT+JubJHBBbAhDR241WQSkxiDVgYkhv
NO7BHqugh08U6VyEknKn
=pzrv
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
