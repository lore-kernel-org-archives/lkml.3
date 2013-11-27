Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3K0Azp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:55:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33345 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3K0Azo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:55:44 -0500
Date: Wed, 27 Nov 2013 00:55:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        thierry.reding@gmail.com, Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20131127005520.GS14725@sirena.org.uk>
References: <1385416655-7859-1-git-send-email-festevam@gmail.com>
 <20131126004603.GU14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GIrCAcOpC7mETZ4T"
Content-Disposition: inline
In-Reply-To: <20131126004603.GU14725@sirena.org.uk>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Use
 postcore_initcall(regulator_init_complete)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GIrCAcOpC7mETZ4T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 26, 2013 at 12:46:03AM +0000, Mark Brown wrote:

> lot changing the callers is probably the cleanest.  I'll probably do
> that tomorrow if a patch doesn't turn up before then.

Sorry, that'll now be Wednesday - an unusually busy day started by
someone deciding to fell trees outside my window early this morning put
a bit of a spanner in the works.

--GIrCAcOpC7mETZ4T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlUL0AAoJELSic+t+oim9CoIP/3sAwS224tvGvMVW2x6BIOK2
B5u9kDFnjRSupN5P/PJDAn4aOye8Ktdj6QoFNL5bD+XMaJvHFtTs70bnVosZOQ37
briPPdIEilAx4TE41A7vuBKxSwL1ElJ9L2yzx68cmwUKLmS8q95TePeP+dB8va6Y
b1sTrzLGRQV1j6rKNhvZU2NM+ZEVcL3yarXMkNLt7ZvZZR7zE53sl4pB/jm7tb5Q
IxnYEOJkpFIlJKVAqEPu7cvSbojYu3TjpbcJm3YxsCWk0FIXRRAZbMMLYg0vYdEc
ZQMuNX88nVLeY9EJxTenGouZnPRF8g0bKAJHXJrs8EKtgp4FmghIT1zn62SBw0Rq
0tWVtkXRUpdtS1tsoJxtS8t5NZmZPVS7RI34spiF/SwwQW8LYUF8dG8MzKHIBH1J
MYgJnY5b37/ogUhuE30DUvcKO4khCdHl9/EJVcs5/UhNrxN7Iok087hUUjjR/lfK
KNrMAfTT5rtJuISRC870MmlDAttAUaA2U/pxI1SBLGsxPn2KEYcOtAHbZ/GqneTu
yAr0t5U58PhLArIfsK8IseZIUWW1mAYDd4WGmiVU5bWBkTuReN/oJfyiE8O8JdpP
erm1B7+J8WLiBHrSiuYgwORNE4HeX7au1vH50ogFn1EycxvPxljgSCHXML8d6+72
pslO0yl19mFBQ9E21i7d
=zMIx
-----END PGP SIGNATURE-----

--GIrCAcOpC7mETZ4T--
