Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaE0LHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:07:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44122 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaE0LHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:07:11 -0400
Date: Tue, 27 May 2014 12:06:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140527110655.GQ12304@sirena.org.uk>
References: <1401170709.11231.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="youxEexQfVd+RqBi"
Content-Disposition: inline
In-Reply-To: <1401170709.11231.3.camel@phoenix>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ltc3589: Remove ltc3589_list_voltage_fixed
 function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--youxEexQfVd+RqBi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 02:05:09PM +0800, Axel Lin wrote:
> When fixed_uV is set and n_voltage is 1, regulator core will return
> rdev->desc->fixed_uV in regulator_get_voltage() and regulator_list_voltage().

Applied, thanks.

--youxEexQfVd+RqBi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThHHMAAoJELSic+t+oim9UWAP/3v7XhzjNGNeXYDLNA5V7z3l
W68dXPH1DWXzbKjnjj/1VKVPFfRViOywiQAcUc33LIM64GQNTlPeLR/XcVFFz0OL
dqDtfUL6frH7P9aGFNj+L0z9wTTR166m4eq3ckL+UYqBULpHnIHgVHlMX2G+V0Ec
R5govAWh/biKH+6mwIuzN1xPj3hn22QYMToQMEu0hhMAXsb0bxxitdtGiqdHQXx1
4IJXbLqSNFIMmE/3L6Lf5Z0N98D7ZRP/BYXPEcBKWM4UqivBN9HiIlQh0gkVuDqu
NsZVc3G8KxV3Jbkr38XrC1ESrHlMqYxHq8pUhV1WVSQTTrqBzIKITM98nmds93jl
t1hCrcAJuRWyKSiXxQNiXrCo3syxQNG0YgYuPPYc5i5EBqPgADQKK6aV2fjeUGtb
0pACcGvB/WkckOC9Ca3MxitRLlkzbaBVvOI/oCkZslqsaZelcDxi5bUPShJN0oX5
YuIxLpnUDSZ9Uu7DmThPiVvJ5DfpRgaGhPY7BJr+AGOB7ivPUPgqghZWq973nS3V
yyo7wi4AZgFQTBn4FkVc2AONfp2s35KqcJfeNNa9N/Ea2Ypi2ogx9vbleeXZOMzi
h/hD+JVrZpn+JDbkdB2ZzsI1edu9/f5KNHjfCSYrbxgJ/coy+Ka8NyfOClHfFNgH
t7OEXwVnV/ebos8SyGzq
=8nRy
-----END PGP SIGNATURE-----

--youxEexQfVd+RqBi--
