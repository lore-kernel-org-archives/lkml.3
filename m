Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3FDJi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:38:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35381 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3FDJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:38:24 -0400
Date: Tue, 4 Jun 2013 10:38:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130604093816.GY31367@sirena.org.uk>
References: <1369911393-25747-1-git-send-email-kishon@ti.com>
 <20130530113247.GI5180@sirena.org.uk>
 <51A74D70.5060303@nvidia.com>
 <20130601184511.GC16790@sirena.org.uk>
 <51AA456E.3030307@nvidia.com>
 <20130601210511.GT16790@sirena.org.uk>
 <51ADAE78.4050900@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zu8lIfFVzXMVnfzp"
Content-Disposition: inline
In-Reply-To: <51ADAE78.4050900@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zu8lIfFVzXMVnfzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 02:38:08PM +0530, Kishon Vijay Abraham I wrote:
> On Sunday 02 June 2013 02:35 AM, Mark Brown wrote:

> >This is still not making any sense.  The quality of regulation and
> >output voltage are essentially orthogonal, and obviously there's a
> >specific API for bypass which is something different again to both
> >mode and output voltage selection.

> Do you recommend adding API's (similar to bypass) for BOOST and SWITCH?

No.  A boost regulator is still a voltage regulator, it just happens to
raise rather than lower the voltage but it's otherwise a normal
regulator.  I'm not sure what you mean by "SWITCH" - from the name it'd
just be a bypass?

--zu8lIfFVzXMVnfzp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrbWFAAoJELSic+t+oim9cZ8P/0AzGNT7oVorG2uZiHTLZ+s5
0E4u2QT8vYNIfALQvt7RhK7uB+SKU1TYLnaxMr0BlMXNo8HsuGfWW5NNwHpX+itl
5NuiveVyFWQJpbzq13PzPtebkMJLbN/RPOeyWZ1FMGzovxuHuwMEdqO21xtafwc4
hpFeyik+gTT9VWtK1s45OJqh77+MhgN1detr9K3F/JqwIzfwBPmdyp3RXlSuTqw5
0+Co6++WHl24To+b3aJmkkTZnPUU3JwhHVKlvdjlwZf/dljokS9HM/dsCr0TSaCP
+uu7iy/KKR9jZOJGHwgI2c3OE66KOBx55aAZsxBfCvkaxouH3Fd4WncEoF9JpSWn
a7NzglDLKNrDMz9MtDKiEbzobnc0wBTEsIObGyFkTJqyJqhU0Xkbn6WRfVtGdiim
DQ8pbNhcYZ2AcpHqnryxukJvrwUoS12WnbNPXLOZ8RpFZl62WeoPC6FcjnWUIunv
ir1vlldbOyz5yETtxC4rsjtWAcTubGQy780dJbLIIPvt435oE9JyswCHlVer5neE
PurX1C98tnRCQAUNNOnM/pnQwVtZUGL2ovIQTiZWmRskqMGT8k6Lq7lPTfLL/pIW
/WQeOzcPJI/PpyJWVC6OiqZEUkDl64p59qAwGiOFrcBw+u+aZfMuxlVe5Y6yPSvF
olGlckv3zUdlo8Yyv85L
=Red+
-----END PGP SIGNATURE-----

--zu8lIfFVzXMVnfzp--
