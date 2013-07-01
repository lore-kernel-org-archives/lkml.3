Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3GAIre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:47:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34389 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3GAIrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:47:32 -0400
Date: Mon, 1 Jul 2013 09:46:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <cxie4@marvell.com>
Cc: Axel Lin <axel.lin@ingics.com>, Yi Zhang <yizhang@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130701084645.GV27646@sirena.org.uk>
References: <1372426354.28529.1.camel@phoenix>
 <20130628135022.GJ27646@sirena.org.uk>
 <AAD1C6EB06EE3649B35B7E026785068D2581736992@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5EvMn61FFmGeM4LH"
Content-Disposition: inline
In-Reply-To: <AAD1C6EB06EE3649B35B7E026785068D2581736992@SC-VEXCH2.marvell.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node
 setting for regulator register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5EvMn61FFmGeM4LH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 30, 2013 at 07:14:55PM -0700, Chao Xie wrote:

> I have seen that mfd: 88pm800: add regulator sub device is already
> merged into Linux-next. So you mean that I need wait for 3.11 to
> release, then resubmit the regulator patch?

Sorry, just realised you said v3.11 - waiting till the merge window is
over is enough.

--5EvMn61FFmGeM4LH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0UHxAAoJELSic+t+oim9O3MP/2J3Iat37+yzK4UID4w+sx3I
zeQ2v1/xSJ1JvsaMj5SQG/+FmUB9IAqDcJNDtCSHePlbQnkPQ4LKVxLqBsijwtNE
oMzqjJgw+TfqmsPPSQndPMzvYp327StWCYLRkPE9k5OAx58Nn9D6w3CQskZemxp+
lLZhv/mAQgC2IiSiVkEHuQSIXRGDzJHhHnBariMcrdJtVn3ngrceHeUg8iw6SHnm
N/w7CHpiZoyyTB6zlujz55K1YOM3H2jhwYeXsGhIITRQU04secC2pGCiyizQ3Ru9
aT3jX692zro8/S4S+tvqTv1ON5Owrecbga9jY+mqBgrDAHvD3fZz9+wumTfultLZ
GW2ic/Nzu+2u28O6/m06MszySnPm9uLcXrK3BdGh5LOXq13zSb11l6ritobT4Njg
iz1okcBV6N7muiE0/LoRXEa9JQaBEQazA1zHIjBqGObC9P83R8uPXWZsL4AqjQ7z
FKVNlElCu7nQ79sXrohGFo0JcpJVyIwJXFv19Do5Hdm4Jgsapub+2IzHA6KfC5z5
xw5IyIl/B9YhiRIDL0yqW1Vf0Uhpv5rP3dVd3P2zjFkblnGPrgUKp8cvSRGrbEE8
zSyn5XQpW8D7axR4ekq3LZV26xehHwVeBb8O2dn9r8bGIvxV+b+b5f9mIDzftOwB
hV2/Zr58TpNwCJU1AYE1
=zArM
-----END PGP SIGNATURE-----

--5EvMn61FFmGeM4LH--
