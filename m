Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaAFMXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:23:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47743 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaAFMXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:23:16 -0500
Date: Mon, 6 Jan 2014 12:13:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140106121318.GO31886@sirena.org.uk>
References: <1388994173.11037.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PgOvWPktv68p0YNH"
Content-Disposition: inline
In-Reply-To: <1388994173.11037.0.camel@phoenix>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: act8865: Fix build error when !OF
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PgOvWPktv68p0YNH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2014 at 03:42:53PM +0800, Axel Lin wrote:
> Fix below build error when !OF:
>   CC [M]  drivers/regulator/act8865-regulator.o
> drivers/regulator/act8865-regulator.c: In function 'act8865_pmic_probe':

Applied, thanks.

--PgOvWPktv68p0YNH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyp3aAAoJELSic+t+oim981EP/02YVU531Oe3p4NHuvkhmEWi
MyEU/skLd+wjzorRWUivnE2yfU5nxsg1yWAhrEvB5LopgIxl+KT/ZyQgiawisN1+
PjroTtDWIcbJmgbC1jCrsF4KImK/Pd/qtE0DCn9bc8Tzaxh4hlUltA0zYBo49ZhC
QfuR0AN10a/h1rvsEZtFlKAqWNTf8PIRkBD4PAKBkioTdV61qBc8MVGUTVpwQZgB
n8D0mbtr4KjiawRTymFF5Tf1wwZsKw5m05tG3JaDBz1pJ+bseyiBDNFrdem2cwXy
1om21c6/OYI7mwizA/FaCqQOedaDxYVPhLUAq6nrwwGdJl2lRdc6UjIaewxzcjxP
fC+Jk4oPvBPygAOHbowUQjNw0H6s4w5hY9ILg2IcpcxDM74bVJNHR5qA6uxyFGmx
u5FabjB1rcTFvhFXN1PXCaoaoGRTgzpLOU5fVTMSZDtaDorIPTPp4yCalRia444h
vjhcXsQ4cMHtr1Aok7NDgIJ/+8lE//LEQHH2dqD3JsGVuT1TTtQ0LCGfpJYwQQzg
AKe8jYWvnrFto5D4OePvXdYJyI+oHdIDRxAzryZ63CTSnEk9wfaCcnm95Njn2mym
UaP4v3Qc77/BST68po/qcIuwAxIdlh2Z3+Ubz+gt19wqrwnTt8RP4rmKBCkKW2Sm
rU4VSxmLQP+3du0/vuI7
=Tepf
-----END PGP SIGNATURE-----

--PgOvWPktv68p0YNH--
