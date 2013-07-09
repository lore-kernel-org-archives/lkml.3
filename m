Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3GIJd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:33:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33447 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3GIJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:33:25 -0400
Date: Tue, 9 Jul 2013 10:32:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130709093254.GP27646@sirena.org.uk>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-3-git-send-email-richard.genoud@gmail.com>
 <20130708150756.GL27646@sirena.org.uk>
 <CACQ1gAgnRBr6Eu7sgbzNF2kmm18-zn_dGKZN45RaxXGd1kwL-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EUDem5LXuWmN7o17"
Content-Disposition: inline
In-Reply-To: <CACQ1gAgnRBr6Eu7sgbzNF2kmm18-zn_dGKZN45RaxXGd1kwL-Q@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] ARM: AT91: DTS: sam9x5: add SSC DMA parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EUDem5LXuWmN7o17
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 10:27:53AM +0200, Richard Genoud wrote:

> The dma binding is documented here
> Documentation/devicetree/bindings/dma/atmel-dma.txt
> But you're right, I shoud update
> Documentation/devicetree/bindings/misc/atmel-ssc.txt.

No, you need to write a binding for this machine driver - the DMA and
SSC need to be documented as well but so too does the audio driver that
pulls them together with the CODEC.

--EUDem5LXuWmN7o17
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR29jDAAoJELSic+t+oim9cmIP/RAxGp3/rYPkR+5ylPr5QwHx
37a41xfKZopAh6+tcoWmlta8CpZHs3nvSiTm2PwJeRTDQI8WHpPyxWsNRhc1jkb6
S/irWhNlDmg6VD+awTfdcob2dhYgKiuPpt0kgq7oGeKJABO2WPwmZzb4lpLUf6du
S0wMgJMYZkI9376s3a9jshe6xkPKIR1RLmQltJhxjiSu/PtiPHuDTTKrTcwLlwDH
MZURxMSwTGwVM5dJx9NlVRsf/vQ9bVt+8PndTr81eIa8z8pTz7ZmdbiIwOJRlIoH
aZONwTGH+YjKQi2hvGjIFPGA/RPxdEnOcHZyJ//MubAyIK7U1Ua1Ly3/3+CDG0Ac
rXvCgjkfx9KrMNLSKHJ+oF/kT1O0iF9NkTVP9EeYTeWXFYfrONekjFOUTt9F34e/
+regD085Z3h/JJxMOIF+IwWwGGux0hT8pOZ8ulqBXrHcU7RZWSGeHRNJsIzUBKE7
BL0ejsj52gSzSq5D3++Kjl1yooH3W15aP50wXYmws6a92L6EkdVdsRzMFgnD/8Wv
3Ylyttd88Pq/p8K9kwYZzO8M/Umj8xs6C5dwUC9dKb1aMoUbWHT+tR5/vLIZgMLz
E99bMsqJtEoWDJV6nJbthXGpKV+rLNz8iVLODG9ihL6Dt5rU3n19wfSQKDLxXczW
Gp8X2ihFKNB/C9I6GvwW
=0Zv1
-----END PGP SIGNATURE-----

--EUDem5LXuWmN7o17--
