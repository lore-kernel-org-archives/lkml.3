Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3IPXqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:46:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49338 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3IPXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:46:49 -0400
Date: Tue, 17 Sep 2013 00:46:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Wang Shilong <wangshilong1991@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Message-ID: <20130916234614.GG21013@sirena.org.uk>
References: <1379098875-9959-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Content-Disposition: inline
In-Reply-To: <1379098875-9959-1-git-send-email-linus.walleij@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4 v2] regulator: add STw481x VMMC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 13, 2013 at 09:01:15PM +0200, Linus Walleij wrote:
> The ST Microelectronics STw481x PMIC used for the Nomadik
> has one single software-controlled regulator for VMMC.
> This driver registers directly to the compatible string
> as there is just one regulator.

Applied, thanks.

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSN5hDAAoJELSic+t+oim9btgP/1MXNSp3BplAeEsBod0wDWuo
hXqDDnlbDVm6SFsLHETnDHcZMJFSNhtY3nN68LgknCmGLPCyhxkW56YX42d4YvvL
3UdTHX12SAwKC4Lj4QzIJp9BOKBgQnphLy8IdxDDLAC9bXU+lS2Dd499riSAurJi
4D+tqhEQsRyRklYmlN8qRbRGdf+FRmlroLGOi6lkB0eeKa7JmA9hkIwYmWBwBavl
az/JWNv/4UG38qFDuebVu+ekqjl8fEkFeA/NPx4ojaNHZoji+fbRVHs1WZyf45Dd
U90ONT0f/VGWRendNb0HkMSMChVoxSe80KF4SCJxZD4r1X8VgPBdOxnNx36SMJv5
Zl9x7vD4SoOeeh+Wg3mFgB5ZOVPVTcPVBOpcksapOU4D+lKtAWXuKF680ei2Gq1d
zWCajF3epNDpvS3EvXNcsyJd5ssE/iYhEMgFL44e5/hLNuxj2Pe/sFCBzRfuE9Tl
KLMvt87NLZ6rIhNBzBBI+6o+hApFTRkZnOboXeoSsHyZLG8s8AbYER68ne4QzWyr
vFrXVJklG1VJ9kdUKRD2hWClQ6XWgtqVsBQMxXcsjivG2ChadUhEQIHHlgXDod72
nlIQkhwNeC3urexOTEuq1Qe8W4C10z7UHf2F9RDWa1l61uIb08u0AZuAOGJn3+Hi
3EevxeBJLZ8xJOBJIvP+
=6BOe
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
