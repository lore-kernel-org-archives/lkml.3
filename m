Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3JZRAC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 13:00:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56066 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3JZRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 13:00:00 -0400
Date: Sat, 26 Oct 2013 17:59:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131026165937.GA6362@sirena.org.uk>
References: <1382713426-2680-1-git-send-email-treding@nvidia.com>
 <526AF150.1030004@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <526AF150.1030004@infradead.org>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 25
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2013 at 03:31:44PM -0700, Randy Dunlap wrote:

> That's unfortunate.  The fixes should be part of the tree IMO.

What Stephen does (which does seem like a good policy) is to keep the
tree at the previous day's version instead of taking a new version if it
introduces breakages on the architectures he tests.  That seems to
strike a good balance between keeping things working for users and
providing pushback to get things fixed before they go to Linus.

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSa/TtAAoJELSic+t+oim9mtsQAJZILsl/D4UhysaTk7/YkqEq
svjvbsfauhxMSymWSoAs1uT7zEpYyBK9iZ6LO4ncGY9+p7nr0GjBrGK4ma9blGO7
xRKLuiGPMuy1FzqKshFajEAvtNYP2OSEZIf7cZXniZfOuJtfQe9i+XsByBEkDnip
UcY6ugQQWpvjNy0oH0m/zmYz99T2YkrW35IeL40ADA3zpRvELECd30iFveqUjRb8
MuYbjv7tP01V+3MP33ssjjLh8ITO88VUI5ga+eos+bXG0qvskWVa+MNB/I2+4i76
4MJ02H5HOZlo/INAubuXIPQWLj2iW/aY05ZieEacr4VXCu9GUnkrmblSkdd1MuVH
e05Ufhz+p+d94Q0AelQE/yB3eKSbdZAqqBmU/b/3iZnrl6NAH5NgC3aWY4ELkVb3
lgKUf2ygRmvjyUbLAcNGk4VNHgcYwm0sMQyE68r8TTk997mcZqCO8knBs2sGpNF+
SiOIkPkVaEPiHmGpqu91tk+/nd9i5ZCwrrpFU20JbJQMl/luiuX7WY8EQ2fvYYII
R+LRZ9IRLrLFFX7K6i3sGp7lBVMf+/S85GvZhfExvqHDubjuDyyPqs4uE+iLb7BQ
vzcaaIoATJBkOYSPTT6j4K3gUagAcxlF22Q5b6ohS/6x2WZ2oBqWklH+1sgulFVC
TMQ1LCRmBHcwaXhR84iD
=dSmN
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
