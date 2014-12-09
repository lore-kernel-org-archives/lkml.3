Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaLIVrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:47:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53617 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaLIVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:47:50 -0500
Date: Tue, 9 Dec 2014 21:47:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20141209214737.GO11764@sirena.org.uk>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
 <CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
 <20141209212708.GL11764@sirena.org.uk>
 <CAOMZO5DYuUmc9m65Pssmy+Ak+A__WTLmXY2=+3jQ1ZKQcE5Pew@mail.gmail.com>
 <20141209213728.GN11764@sirena.org.uk>
 <CAOMZO5C+gwVocek-6mvReyTbf4ZKAs2xDRmsT+pLqAQf1vVSCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cU9XODsizZBnwgll"
Content-Disposition: inline
In-Reply-To: <CAOMZO5C+gwVocek-6mvReyTbf4ZKAs2xDRmsT+pLqAQf1vVSCg@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: da9052-regulator fails to probe in linux-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cU9XODsizZBnwgll
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 09, 2014 at 07:40:40PM -0200, Fabio Estevam wrote:
> On Tue, Dec 9, 2014 at 7:37 PM, Mark Brown <broonie@kernel.org> wrote:

> > Still not seeing any references to either pfuze100 or vdd (other than
> > the external audio CODEC)...

> Exactly, that's the bug :-)

My point is that I'm not seeing anything complaining about those devices
or the supplies they offer so nothing there indicates to me that there's
any kind of problem.

> If we compare it against next-20141031:
> http://arm-soc.lixom.net/bootlogs/next/next-20141031/wandboard-arm-imx_v6_v7_defconfig.html

> [    0.052239] CPU identified as i.MX6Q, silicon rev 1.2
> [    0.072014] vdd1p1: 800 <--> 1375 mV at 1100 mV
> [    0.073027] vdd3p0: 2800 <--> 3150 mV at 3000 mV
> [    0.073933] vdd2p5: 2000 <--> 2750 mV at 2400 mV
> [    0.074888] vddarm: 725 <--> 1450 mV at 1150 mV
> [    0.075935] vddpu: 725 <--> 1450 mV at 1150 mV
> [    0.076897] vddsoc: 725 <--> 1450 mV at 1200 mV

Remember that these messages are now at debug level.

--cU9XODsizZBnwgll
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh234AAoJECTWi3JdVIfQGDIH/AnWsA9PGyM7t+z4a5rxXQe8
b9EU5j6ZnAQm/pU/K2puMcnahbkV4RySgiosfE5utEDh1IJsss5a27aIM+OKpjuO
JCmdi3iefvC4x9ikF3oq7U8D1/TvW39KmzAkY9ImVepgXnVjHvXmDAgbgNqugo3m
ud3bFLp4FLXWy3sIEk1UUpKri6wuDzdLc4+panPMTduPFs8/QpHMyYTIfHHaOmUL
cEIh0PAqwZc8o8pOK64QcnRNVlq7gh20l9kFykgZzfXNr67sHZkSqcziNyH+jLOb
nWCNfet6NYT1W3gpyURuGi/oTSVBObuAYcolCfn3RdTW2L5Yep9NSUJjxIPNyIU=
=LIsd
-----END PGP SIGNATURE-----

--cU9XODsizZBnwgll--
