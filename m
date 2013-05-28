Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3E1KEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:04:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60974 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3E1KEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:04:53 -0400
Date: Tue, 28 May 2013 06:04:15 -0400
From: Mark Brown <broonie@kernel.org>
To: yi zhang <yizhang.mrvl@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, cxie4@marvell.com,
        jett.zhou@marvell.com, linux-kernel@vger.kernel.org,
        Yi Zhang <yizhang@marvell.com>
Message-ID: <20130528100415.GE3660@sirena.org.uk>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
 <20130522161422.GP1627@sirena.org.uk>
 <CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
 <20130525195601.GJ7660@sirena.org.uk>
 <CAK=oMXeCUgc5E1ZaXcbrbUB6XGD135a7zRD-CC5apEytx2j=fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Content-Disposition: inline
In-Reply-To: <CAK=oMXeCUgc5E1ZaXcbrbUB6XGD135a7zRD-CC5apEytx2j=fw@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.140.31
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2013 at 10:32:09AM +0800, yi zhang wrote:

> HI, Brown:

In western culture it's either "Hi Mark" or "Hi Mr Brown" (though the
latter is pretty formal so not used much for things like mailing lists).

>           Sorry I'm a little confused:
>           You mean I should use a function for example
> "create_buck_table()" to create the BUCK voltage table?
>            such as:
>            void create_buck_table()
>            {
>                    if (voltage < 1587500) {
>                              /* initialize the BUCK_table */
>                    } else
>                              /* initialize the BUCK_table */
>            }

No, I mean you shouldn't be using a table at all but have mapping and
list functions which just do the calculation required to generate the
tables directly.  This saves scanning through the table as direct
calcuation is possible.

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpIEbAAoJELSic+t+oim92xIQAJ3gknToLC/Gp3M6gpfLeOi8
HC/waSczJSJUTqHYTgamQuWpelNIrVRlIPznTiZq8lamt0dGVlTel5XWeTcrSW5P
/rvFb0IVny8t9ij9Sveh7ldnFlf4mJ9RlNg/rgSKsSeEfrI6h8uo5gkq0VWo5cWi
LZK1Glgpfuvzu4bFJ9H3fsev/A6r+UIUEu9p8gWkyuFQ/GzX9pogPxDd6ttqg4SA
8DeH/wsciGdIBKcsAWXkNV8yIDWb9nfjjqDh6Mafm2GuDAbkPdyf0i9aU5xqqp+d
uZaJUg2YNPiKsRnBawc09oFvzr/q+aBuWfeiPYkHEQj2r9VXNgBIXYWf0xwhxJQF
TWcWmFU7KemOnjgSm/o64Cel8OorT2bxnrq9/MHuHXpk4Kxau6xrxsqxDmpJvLTA
rLelhXxs1f7/xkq2dHvFpv7S8itS/IERe2R5QukFrMTAIoNmwDvsViPSKwo36Tf1
C805LaJqZ24bHQEKZSR2nnbIy8zVPn40R7XTuovrEyyUVZDjtEdsE0Z6/CoLi2Y5
8v/9TKQqIID4IdSyr58lFHDrQd5Mwq3hlUNamvlfaUJGYFT8t9+5zYB0msk4obfE
1JYX8glu9jGH63Lih3UbvPqZ29RyIc3YKCU3BTuX96Gq4lD2kcKt0Hap61IC0ll6
pdM+gbvo5ir9tAb3EpGB
=ckrX
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
