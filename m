Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3FJKEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:04:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39756 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3FJKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:03:59 -0400
Date: Mon, 10 Jun 2013 11:03:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130610100330.GO31367@sirena.org.uk>
References: <20130530113247.GI5180@sirena.org.uk>
 <51A74D70.5060303@nvidia.com>
 <20130601184511.GC16790@sirena.org.uk>
 <51AA456E.3030307@nvidia.com>
 <20130601210511.GT16790@sirena.org.uk>
 <51ADAE78.4050900@ti.com>
 <20130604093816.GY31367@sirena.org.uk>
 <51ADB6BF.6020205@ti.com>
 <20130604100511.GA31367@sirena.org.uk>
 <51B5A14E.6000500@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gVsHH/lB7crtgjPA"
Content-Disposition: inline
In-Reply-To: <51B5A14E.6000500@ti.com>
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


--gVsHH/lB7crtgjPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 03:20:06PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 04 June 2013 03:35 PM, Mark Brown wrote:
> >On Tue, Jun 04, 2013 at 03:13:27PM +0530, Kishon Vijay Abraham I wrote:
> >>On Tuesday 04 June 2013 03:08 PM, Mark Brown wrote:

> >>>No.  A boost regulator is still a voltage regulator, it just happens to
> >>>raise rather than lower the voltage but it's otherwise a normal
> >>>regulator.  I'm not sure what you mean by "SWITCH" - from the name it'd
> >>>just be a bypass?

> SMPS10 has two outputs OUT2 and OUT1. In order to connect OUT2 to
> OUT1 we have to set "SWITCH_EN" bit in SMPS10_CTRL register.

Is that not just a normal enable?

--gVsHH/lB7crtgjPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtaRuAAoJELSic+t+oim9bSgP/j2GVNwhsmmGoYl7eJuuuXsO
gqYYiY1zbH9xzN2SnwYQ7D7bdVX3DgK/mUXCamtqRiTnkdnDDH2UlEYxb88+Bbgf
82Xg+BOCHKNYLxTqJN0qWgt9tx/xGpNiPdxPF6FqUdsFNhAXd1eV0MVSs581V5xK
gt5a5DSuDSfL45YTCuoVraQkK4Tjn8HJrNLNpyrhbefiXZJExUDCLXnlryg5ysB6
giMpmmuu/w8rK7tWXm5XfXRHikPaM2zklFprQ8fVfWHjwLKWXySeC8JcbNrrIe2J
PK81yJt5RLbDjmHz1WjQIMPkwD+hm7ptTYP+GAweZEYG6qAp795SuimFIAV/HEfM
iOgWdnK0YPGjbPvrYw0JIhHKJac8blOF3WvBP5ptqMmU3g3u3xX+ik+dfber9W8T
EggtnUvaIQeDZrGGsIqQTnRCCOP2Lkx/onAENAdtn+rZxfPlalQGinZ7LRjrTtRd
bVPg8NQGZtew8P+2jHOPoGf7gZzbPdtz84CE5eeuPtB17MWVQiRdwc6Q5oXQRcFJ
cdlh6HREZ4RSa/qdzkPKNHoT2qS15sXAWUH5s5Au6A82i35Q8NmtvgrBQwZW0vim
V/cuMbT6bWfkjnyDScs93hc7DI0X2FZb4bnCWTk6dI4sWuv4NGtxkQ8BIecxeUo0
HAtj8uzCngDXY4emf2G4
=nG6V
-----END PGP SIGNATURE-----

--gVsHH/lB7crtgjPA--
