Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaFXPTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:19:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55760 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaFXPTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:19:42 -0400
Date: Tue, 24 Jun 2014 16:19:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        spk.linux@gmail.com
Message-ID: <20140624151928.GN23300@sirena.org.uk>
References: <1403599204-5975-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8CNmCRe8Sh4keFKJ"
Content-Disposition: inline
In-Reply-To: <1403599204-5975-1-git-send-email-sachin.kamat@samsung.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: s5m8767: Remove unused variable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8CNmCRe8Sh4keFKJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 02:10:04PM +0530, Sachin Kamat wrote:
> 'size' is not used in the function. Remove it.

Applied, thanks.

--8CNmCRe8Sh4keFKJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJTqZb9AAoJELSic+t+oim9DUYP924LXZVdpcTZInZA7YYX38A+
uXWb7VjJs3rif9Kya7czcms6V9WvgMO6KKN8e8p3pSe3mFWgPVCpO8PQziLsvrGO
a+X2ifIWwhgCbslesaJpVu2S8Ncd6MGIGwV1yNdk3oREUB9HLCEb80RoId9Isgmb
FZjiSOfgN0wClX8NuEDsy6TCigw7FfnEkHY1LtTEY+4QKxy/ZbZYItroUA3EmrYF
nH3+BXdg40IN4vBGipeWCWFwfjiDhMhAz8DseWEmOJYl+U5YZruV6FBczsBMsUKV
A1zyMQqkCot/ywU/fNvqE1u4Y2g3BxiYP1wVFCdQIPKRxM4OfnU5nkf6EX14gRCt
3MnC424MhLfEXw3KJYyBcALZ4qmaLQEynmx4WHpkjyV+HLqk0wPk/64eYzwD+F8R
sl4+4aXvSuW3dvOciMPimrf//2xmt/ftjiJ+CCQAbg9ZMu17uL6Qs+TNWsdQ2AfX
wwTsg5BYxtCpIPQ9sXBQWC0mwShRRBUknQHA413Tiq7ar3djL+4oIybiQ2qE+J+I
dUwTDaRlZLV5D5TlW4XKt1D3Ci2pxnlGq0Ix2Lckbt63laRPXwMlT3kXIMCtZURH
I2qXvzG6dmrTJ33frn/VYwbSmwrQ8enCVGiLtTmiJqivUEZRgdnCQ2CddmGgKEwS
P2asqlXIlcnCybk9D98=
=CdGd
-----END PGP SIGNATURE-----

--8CNmCRe8Sh4keFKJ--
