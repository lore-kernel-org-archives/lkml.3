Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3EMOAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:00:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40303 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3EMOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:00:52 -0400
Date: Mon, 13 May 2013 18:00:48 +0400
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20130513140048.GJ6836@sirena.org.uk>
References: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com>
 <20130512145906.GC4046@sirena.org.uk>
 <51908DED.7090701@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzdA25v054BPvyZa"
Content-Disposition: inline
In-Reply-To: <51908DED.7090701@st.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: debugfs: Fix start_reg calculation (v2)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MzdA25v054BPvyZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2013 at 07:53:33AM +0100, Srinivas KANDAGATLA wrote:

> I did try 3.10-rc1, and I can not reproduce the issue.
> very similar patch "regmap: debugfs: Simplify calculation of
> `c->max_reg'" addressed the issue.

OK, that's what I thought.

> However It looks like one of the return from the
> regmap_debugfs_get_dump_start() still returns wrong register offset.

Please send a patch for that.

--MzdA25v054BPvyZa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkPIMAAoJELSic+t+oim9lbsP/0Zkq6uhs5pBGTuOmNgy0XWN
Gsrrx+DwZN6F9PrJtsFuBaynpSYCG6KCITX9ykdkJf3GUnth1eyyaogMaD/MTj11
tNRXEPnv6oKyCrfDnmy9gIkzE2fwCHvVITFqpy1fKVW0CE6ReCIoH7og9GusDHDL
WWD60c6xovd+T1NUisD4fvG7fHPdkYqT2VypoMVisxvvcFrYYWm/T1QmIbgrRhFr
2Z3ynMst5QWwsXATyoUpZ0uA6IXSBsqChlp8a9CDCMFkdBpi2x5se6BOCZ5KQ483
ymNbWdG+egu5iJ9+o9RUnK653AmilNQWvMvf6ciCTVXcEzG4tbyXY7tPyAggwXbo
s3M4empiqHn4Tj82xlOkmDdiBsxQBvYRfxLfGrwKdyPzV7/EpsydY8yLvJijHX3I
BJ4l/26VcRfM4wGGjiLmVFgbG1fnhsqTcDVfSBQjdv1IAY3/4uU9k9W9NqB/LjKP
BHwMp+TnjioH3d9pwRKKavVG/zESHvu7f5a8dJQIe9Afp3ehtsFGIIpFu6LAny4i
W2W/kLrG0eveknP3sAIbbOKRjExx9HLgS+grmAUrda1NLPEWwnDL3/GyJdsL+8ZL
V3IdwmfzEhaR21kcDJsEmitbb4wGhaGqQXktRZOaDSMh/VG2gyoMklEvHn2Y5JGX
EhbFuarMxVkniYaH8Z3n
=cPmY
-----END PGP SIGNATURE-----

--MzdA25v054BPvyZa--
