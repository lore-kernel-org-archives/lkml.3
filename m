Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaCXKt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:49:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56995 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaCXKt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:49:28 -0400
Date: Mon, 24 Mar 2014 10:49:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140324104921.GE2269@sirena.org.uk>
References: <1395444158.25974.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Content-Disposition: inline
In-Reply-To: <1395444158.25974.1.camel@phoenix>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: st-pwm: Convert to get_voltage_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 22, 2014 at 07:22:38AM +0800, Axel Lin wrote:
> Also remove test for selector in st_pwm_regulator_set_voltage_sel, the checking
> is already done in .list_voltage.

Applied, thanks.

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMA2uAAoJELSic+t+oim9d6MP/Rp3HDGSaBV80eoZ5zj7weSm
WfIK0oI9dj+NBaHdgHtsqfL22aH9ko+R2e8dJ7XVTVgGXFs7OqvtiRXdhi8EhisS
4Wgy52FPBD8J/JNQW6SzaA8mIiyk6xA8ZQXeeDhxTJKKg2yIZqMlFhtCjCMRh3NO
GQdAu3+N3SSlSxTSGOTrRJmm4hJvCYLjygBo9E60P5Jd5gBAbH4bcAirHSVM//L3
MHKn+u8tjuef1fmSsVAU5NgIvLOzd4p+kOWoTacvdkVrNtpYDQOzQrazO9ndqAEm
zHFbDhIl6IiHnWf72/5ku6nP93woWhpObAipDDLW7bwN9yWJnpp7r22m14jJrNf7
LACfZtAVeZRPupe2J4MSwFZtgyZwTAJvEwi4q5h9K0Jj+t/TTE1BK8GevFIJxK1H
BRjovIcm3jmX/u/H39luEW4NB2bmWl1MdILqbLyB/PYdbJzbfUvg1mP6w54lR7G5
VoCPm8Fn3Z87AHVjXvMrsHSQW6IqKJWdC0fa7zNFOUw0pGL1gSBHepL5Lzi8ILHs
LGOy3QxcCB6TyfsVaS/5yVhAsAI/PzTNRyXGQR7frSm0v74koHs1i6xVLlQV+eQ6
RKTuqtlzp9n5GmD9zk8MPLSLP16c728uM9d0HO/B0fSLUn6o3RVyAK3GHrA6oV4Y
kaftaxQ5atcSZldP2/wI
=zRe8
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
