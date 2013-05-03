Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851Ab3ECJnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:43:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56777 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3ECJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:43:01 -0400
Date: Fri, 3 May 2013 10:42:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130503094243.GO4945@sirena.org.uk>
References: <20130502075421.GA23346@balto.lan>
 <1367488371-18346-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XVTPT6MZt3zd/C+/"
Content-Disposition: inline
In-Reply-To: <1367488371-18346-1-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/3] ASoC: ux500: drop clock gating widgets from
 machine driver
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XVTPT6MZt3zd/C+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 02, 2013 at 11:52:51AM +0200, Fabio Baltieri wrote:
> Drop ab8500 clock gating widgets from mop500_ab8500_ctrls, as these bits
> are already controlled by ab8500 codec driver and should not be exposed
> to the user.

Applied, thanks.

--XVTPT6MZt3zd/C+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg4aQAAoJELSic+t+oim9So4P/j2E76Wemmw41nhZgf16pZ80
QV/1+FcZgXtC8b5lUZ0t4OaRyvwp+Fiw69azlHuHL+EtJi/BwrN5mGGOsY5A39+g
ByUmcBYT9PE6QLHlsLNTPfgvmpcixqT9DetF5dWJu4lL+utKs1rdLDjZU0eEsUCT
zkhRjvvEHrLpYR3lglaaMd+t/3UVgnZq2L2wuHBpZdzf18svTdpT0xuRefkKAfEA
XHFVuajLbCdBsB/LtDk1Wo4DDnEMwpJ8p8/jDSZfwDgSlIh9fv656ivKkywXSHq2
OvdTfSFF/cqxqrjkdpbPetsd9+Dv4ccsLIWG0RDhLaBMXMRYNLSDSDj9zVRkhI55
P/w8B2XXkXs+OhwUbPTI3tCgU4WlqYipiZni9duQerFiLSvkFF4lQYxDHVTSiKUN
1cuClnNp6Ucme2tlKIJKDs6mJgxKm5AifxajPwzAHWypt6hCB/N0sU0QmBeT44Tj
m8/f27ngP3MrZTNG+RrSEzUXCjL6Dw76PM9OskN5w3dGNvma0o3m4R2EB9REdqAL
vrDzEHyw6QSIOK8jMQp+PIguIr4NY6ZgwtwU6N5mld8a4ahsmoUhpiiUEPJ22fUN
ijvETG4CG5LsBMaYIBEb9Yh0j4Vlf/qVZVcAuHWg2lJE+8MrEbLMK2iqnCPBC8Qz
nqRPg5e4Zu8Zqv53w7hE
=tbib
-----END PGP SIGNATURE-----

--XVTPT6MZt3zd/C+/--
