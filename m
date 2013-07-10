Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3GJKB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:01:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58732 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJKB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:01:57 -0400
Date: Wed, 10 Jul 2013 11:01:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130710100150.GB24508@sirena.org.uk>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-4-git-send-email-richard.genoud@gmail.com>
 <20130709150543.GE27646@sirena.org.uk>
 <CACQ1gAhK2yN2uhewq8XGOidLCDfOhgRvzE1o0b1krK1DjYj-dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <CACQ1gAhK2yN2uhewq8XGOidLCDfOhgRvzE1o0b1krK1DjYj-dA@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/7] Documentation: DT: update atmel SSC with DMA
 binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2013 at 11:48:27AM +0200, Richard Genoud wrote:
> 2013/7/9 Mark Brown <broonie@kernel.org>:

> > ...this first example is now invalid and should probably just be being
> > extended with the new required properties.

> Well, I have to rewrite that to make it clearer.
> The thing is:
> with "atmel,at91rm9200-ssc" the SSC doesn't work with DMA.
> with "atmel,at91sam9g45-ssc", the SSC work ONLY with DMA.

> So the dmas/dma-names properties are only required for g45-ssc, and
> useless for rm9200-ssc

> Maybe the best will be to write a paragraph for g45-ssc and another
> for rm9200-ssc, even if there's some identical lines between them.

OK, or just write a section "Required for devices with compatible X".

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3TEKAAoJELSic+t+oim9odEP/RMKCGZDVW7sSGCCgAb5HFUp
MC+r2kRUQAC5SeYJNT+Q9Zb0DBF/grwJoUnZ4tvue6/EugMGlSAWA1kpCecAWdtT
IXfGH5eiJUzn8Cu9pgJ0JiWh9rmyxoWfh6KkvvfQxLiMwL9M25Qp1SIePom2tOtY
ZuhZRUVR5erUjagzTWz/vNwqs2oCGWWcImCJQX8r49dU9qweW05KCrEQoHVWpoS6
3clP1gx9Bt+0RlIvS6jjn9y2ekKftjxnFBRcdKn0YXnLjbPBLHsuCg1GKKd7kN9Y
/XjFM+EkOjOIKapEc6wmptaxU4o8Ibl2Z6Kuqby/myZqd7HocwiWzoFP2xWjZ8Br
8mQJ/1PpQqo7V713Mx5KY6gdiEwCUIkStRim6a9UidFuciKv1bGY0Vfl5sKR91KA
ohpoAytj995LlV6UR6z9n7H9pwyHlap+1TUbrS1j/UVwMDi2CjIq0EmE3W9A1UQ0
Q+aNYWN7fwBjT1+rwz/6jfPfevlpfHFgYn/AmtwbhO47ePp3m2LSNNu9ElJsaBma
AAR63xwQo/Zc8113K+aXu+QZ+HN3s671v35uoosyONXTIASSOxJ9y6z88kcB/bbv
t7nvQ+tO6Ydv2rEICk0uexCNI4te1WY0h3wOcHsUi2Y1npREhRxydSZvEpcDo55C
8CE/kT8ctsN6gwRMR4YL
=Jb6i
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
