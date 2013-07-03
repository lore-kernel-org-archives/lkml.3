Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965690Ab3GCTn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:43:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55156 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965446Ab3GCTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:43:27 -0400
Date: Wed, 3 Jul 2013 20:43:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Message-ID: <20130703194303.GG27646@sirena.org.uk>
References: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
 <20130617174451.GF28497@quad.lixom.net>
 <20130618102213.GA1564@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8+9vHbKxlFmeYtB"
Content-Disposition: inline
In-Reply-To: <20130618102213.GA1564@e102568-lin.cambridge.arm.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v4 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8+9vHbKxlFmeYtB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 11:22:13AM +0100, Lorenzo Pieralisi wrote:
> On Mon, Jun 17, 2013 at 06:44:51PM +0100, Olof Johansson wrote:

> > That'll trim down the driver to a point where I think you'll find it much
> > easier to get merged. :-)

> To start with I have to understand in which directory this code should
> live. Moving the frequency settings in clk/CPUfreq drivers should be
> feasible with extra DT complexity for their bindings.

You shoudn't really need to change the DT bindings at all - MFD is a
purely Linux construct, it doesn't affect how the hardware is
constructed.

--a8+9vHbKxlFmeYtB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1H7DAAoJELSic+t+oim9+0MP/RWyhHhsAnEIpTmdpqahO7vc
Gr3n04byK566EQNq2HjJwda2oT8EgFygPP1mQFx3kLwUh7DyfXCkL0rOYQmvxEnJ
ZmcLyBH30zyTky0JAPiEZp2/tcIbXkvcfJO8LD1foWaqTu1u+Bq3DwcJv6SaZl0N
Ymme2q/vL0fsI3OQHG7yJX22ANREMCkHDa1l4k7hWawAFxzETIrdZQUjWpUd/lho
w7EEJCujCEDZ9SvXWMjxpcGMWSJZk90EhDdGuae7oeCvJpDvrvN0re9PH834U4Su
NY7mwvPDgz/Iby14TfIwunbDu7IjC/cRNcTkKwW8IM99YQBTGsMDiKqSZWEgW9pg
pAs89y86doVEDTC+JpHMUQprR3vIMlqBoLd6Aurnq0UOL/6Gb/q9pzog9x8bGCy/
picj43+mcHhmirKcVGfxTn0EJMywbe1qXSP0KtQo9LzpOo3+fo72NGozjS1jLAgQ
5Iw/hDdzuYfI/vHWC49IskajaVK1jaO3ZjaECSVi51icC+5K8L5KyUXSooVJi+6T
nDGvgYEK+817KMizpKufI3ZMZ99G6gB94iO8OA5FtCRHoYGg2ayDWkFH37kHPIPI
Q4ENp324BBtWKwMssIvsDpWbJG3Gq6idKDVGz6xqbYKVTnzVyZv+1c+bMwbUhFR1
5eLsSVZXHjhFrFQMzbJr
=U152
-----END PGP SIGNATURE-----

--a8+9vHbKxlFmeYtB--
