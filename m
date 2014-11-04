Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaKDUm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:42:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37924 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKDUm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:42:57 -0500
Date: Tue, 4 Nov 2014 20:41:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141104204137.GB3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415090986-30623-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PsEZZJjWpOB92CxQ"
Content-Disposition: inline
In-Reply-To: <1415090986-30623-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] regulator: max77686: Consistently index opmode array
 by rdev id
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PsEZZJjWpOB92CxQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 09:49:41AM +0100, Krzysztof Kozlowski wrote:
> Mixed indexes were used for array of opmodes in max77686_data structure:
> id of regulator and index of regulator_desc array.

Applied, thanks.

--PsEZZJjWpOB92CxQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWToAAAoJECTWi3JdVIfQljcH/isdmErXTFRWHzqKXFhdEHgq
OWjanfUn0OkjEf25Yh/qJDMouD36IBE3hG+9/3Hu+bVSnH2jSN3E8JJBmjetA/Ke
nIHvdzZEAa6qayz3g/zU7wUH9ItyYus2CTFtIdasPK/rEttnIF6g0Kjy7eOtszG9
tqpk+AfL/lt/jspqH4Qd+t+5728FgEo6KwzlrlsDXOOgJp5TtEkhgHw19hZycGuv
AMkKtwF4t824CSv1XM2MS4LrRzKEfeyQQUB+rsujj4/1hTvps+PbjdJCTK9h4RU1
w2gDD57PiWIQ9C/pKIPrPsada0TnwD9yoT3kSdZU6dzIw4ZQgEEV+1EF9VFKyMw=
=PXI0
-----END PGP SIGNATURE-----

--PsEZZJjWpOB92CxQ--
