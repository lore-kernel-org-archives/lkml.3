Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3IWKTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:19:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49481 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3IWKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:19:43 -0400
Date: Mon, 23 Sep 2013 11:19:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20130923101940.GZ21013@sirena.org.uk>
References: <1379879509-3608-1-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R/QHK6DDZDf/Yghh"
Content-Disposition: inline
In-Reply-To: <1379879509-3608-1-git-send-email-zonque@gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/4] dac7512: some cleanups and DT bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R/QHK6DDZDf/Yghh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2013 at 09:51:45PM +0200, Daniel Mack wrote:
> Here are some trivial things for the ti_dac7512 driver.
>=20
> Mark, can you take them through your spi tree?

I can but it's normally Greg who looks after drivers/misc - probably
best to at least run these by him.

--R/QHK6DDZDf/Yghh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQBW5AAoJELSic+t+oim96rcQAJFxgJ97kbQ+tnW7eYEt+i3Z
gVkRZlHiug/JquaCjigEeaQy8LjOD9UZ3FFfraGbTY5oZl0Gg5usMxzwgDNbNKNw
Z4N1dbLb5u5RHyvQicXbXezpi5oHXQiaQlngu0T6os6zqPmDF4yuO/pj7qplroPH
DTSm6MVLSu7J1jayFB+YFDVLTvLEOqORyLNq4J9mVqMHFKygcm32os0fVK6JH+qh
A+AHF0xQz+SEQSjlvByzkDkTJKHVpUiNa0ODMu4t5aVJ1nKyHp4viUmFmVCGOBSc
NwGIhcHoAPEbEac3Y+rTWQZtR9MYyXrqfeM7vW7dXn+TUqWs+alOKjtf7yi79NSp
4tr+N0PzWPJZ66yDU/yezBuKs/n27Wt+8B9IkWmdrCsBdY1dUgQQVhp9mmSVnGmh
7w0SEuWMJ3NIOVOSyXsOLXjrM57uonhkf7XwzhRTQULV+wFXirHbdGii5B8OVf+R
O2xdq9KoedYYDmCe1zktTeraD9bWUGMweImejjxYkiR9O04bQyWh96Mun0TtO8xX
AUDdrwVMDP44KVDI2sORPDJeDh0aW0FfAlBopt5qEEklfARPumHcjHStLgFzZG1Z
L8WLLyQPqlFftYzNAfEQ79IsGPqjzCfKha4vqaBh2/cOxdwZ1FNn0c6HK/95pbX6
3Z28fj/xNE3fYpKMsN1F
=8Jq2
-----END PGP SIGNATURE-----

--R/QHK6DDZDf/Yghh--
