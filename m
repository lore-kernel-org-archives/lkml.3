Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaGIIle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:41:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54461 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaGIIlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:41:32 -0400
Date: Wed, 9 Jul 2014 10:38:37 +0200
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140709083837.GL30458@sirena.org.uk>
References: <201407090828.s698SxPD017842@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D85EWoRcDXv1uhH1"
Content-Disposition: inline
In-Reply-To: <201407090828.s698SxPD017842@krsrvapps-01.diasemi.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D85EWoRcDXv1uhH1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 09, 2014 at 05:28:59PM +0900, James Ban wrote:

> How about below code for proper handle of interrupt?

That's fine, or you could have a return value which defaults to IRQ_NONE
and then set it to IRQ_HANDLED when you handle a particular bit - that
is more common since that way if multiple things happen to flag
simultaneously they can be handled in one call to the interrupt handler.

--D85EWoRcDXv1uhH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvP+KAAoJELSic+t+oim9yZMQAJRws4qjh29VbzIeT6faCq9D
izcwyMPHJ5QitldlzoEkIMIumsqPI8Y2HmeXNogQECPpDE+vkDi9cUTJHJ4JxGW5
ccgZzs3qaI/5pWWkZHzXZh/5jNSGqHlS1xOxjG3uistJ4CHPL/8q9VBJ0Y90E/bT
SKtauDHp9ircy9qE5pmlkzFOmfSq5tmzMa25Avr5nryrb8X6H+ygbjXbxJmHfo4P
sgzpC0GNawCttTL/WftK9sIqD0btcO/dPqYbl1DbqLZT6p9jtrk1bYtZZSBs0Nv7
4iIrt3qphtahk0p1Qr/RF1ffTHtB4kMGnVdT6rL9wU2eXRpm9KT6233oq+sNlnTO
+/UXlT6HaCuTF68DC7uFUJ+tdf0J5aQ3Xysity3v76NHzAmKlgrK3OD6Sled5U8E
0IuHxR2tk8vXjWwdzS1nUu9TnkvDZ86rvXe8za3McslrGoDFYrsPdLR1oNPmOpSE
fEuz1XhpmLiJ5VVYXS5Z6SkqqRbE1pib1Yd31GhOVfXMKWtmLwSGJpVcTFhfXtcw
BDduyMkLqiCCPMMulxOLcZEj2CmE4OoOHjumG/UIDVM7/aQlChFn+8wzMAIkQcDv
bxYdOkGvV9o+w19ZUsIoxM6OjzkvYihDP0reChSbTKMdxTBk3zba+Wq6MivlxxSB
3nZzcrqoUyCiBhHhVdkP
=Vbb3
-----END PGP SIGNATURE-----

--D85EWoRcDXv1uhH1--
