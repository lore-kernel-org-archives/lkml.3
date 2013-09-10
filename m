Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3IJMJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:09:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48934 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3IJMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:09:52 -0400
Date: Tue, 10 Sep 2013 13:09:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rob.herring@calxeda.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130910120922.GH29403@sirena.org.uk>
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
 <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+UaUX7feRqSnTdd"
Content-Disposition: inline
In-Reply-To: <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: add support for configuring turn-on
 time through constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+UaUX7feRqSnTdd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 04:48:08PM +0530, Laxman Dewangan wrote:

> +- regulator-enable-time: Turn ON time for regulator(in uS)

This is unclear - what is a "turn on time" and is this in addition to or
separate from the underlying enable time of the device?  It needs to be
clear that this is the time taken for the voltage to ramp to spec.  I'd
also expect it to be clear that this is not something that should need
to be provided normally.

Please ALSO avoid capitalising words FOR no reason.

--k+UaUX7feRqSnTdd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLwvvAAoJELSic+t+oim92isP/RAhwsBYnQzNmYWep3Rgf0Ss
NIOSnP+2NtngKXOcAtCFH4Y2hbJSvPty0IwlAGBvWNVfYR1A6ZFhbN3w63hG6agH
N/7Dp9U8DGkX57GhcuYCQX06tAJjtCsAA9nunhPojnU+yE8aLkPkTMLE//ahV0iU
1rAA7Do56fxe5ZfQ8e1HGxz4Z8ywQrD7mylTFyyr2vgXVd3Skl7X30SfONpUmFl5
vPQ1yA5et9WoNvpDb8GM01maDE/l0sug3p9G+T0bZ+kr1IDcza8QtQ2bCsUzL1bz
gn0UZQBmSVwk+HFZ3nVhkgWypg4sbK1+Eic9tD8+crHW6jIpOL+IKLHaE/Gp8PJe
VxFAP31W8v/hauO1WHTA5yV797yrtgT7pgClVTlldNXqnIFuOTe8350vW36GTU0f
xqJIQaroiz7W21DDcbHMtE7bsNp4noit+uHqutFB+VCmRkGE3uQYCMmQdcCP/Cu1
l1DLwpAMqK//LcR35zcXoLKk7Z4AXGcLoNxw0W6F9cjRSt8Te8YLhQBxhRyGgFsG
1GROLr0w2Tg6l2j9CmbS9MHwVuZe+NslFaziUkQk+FNZ2rbJueZ39dJlo/ili3YE
6iVVhfvX2ATNa2hhO2LgvQu4Dt/KCMgu5AkocdqGzyaRT0qvvY3XnEcpRVehMOnj
KSNov+aTGyTjRlIOAAO9
=17z8
-----END PGP SIGNATURE-----

--k+UaUX7feRqSnTdd--
