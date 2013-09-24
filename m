Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3IXWHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:07:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:23422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3IXWHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,974,1371106800"; 
   d="asc'?scan'208";a="408588788"
Message-ID: <1380060449.2189.6.camel@jtkirshe-mobl>
Subject: Re: [PATCH 02/10] intel: Remove extern from function prototypes
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 24 Sep 2013 15:07:29 -0700
In-Reply-To: <5ccc921af41a862fe969809228f029035f851502.1380056108.git.joe@perches.com>
References: <cover.1380056108.git.joe@perches.com>
	 <5ccc921af41a862fe969809228f029035f851502.1380056108.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-f7T30DymDb+35Lv0wJp7"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f7T30DymDb+35Lv0wJp7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-09-24 at 14:09 -0700, Joe Perches wrote:
> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
>=20
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.

So you are able to confirm that all compilers make this assumption
correctly?  The initial reason for using extern was because not all
compilers made the assumption or made it correctly.

--=-f7T30DymDb+35Lv0wJp7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCgAGBQJSQg0hAAoJEOVv75VaS+3Oz9sP/Rd3iytGfwfsAnfeEMxely30
UjfgNOTaCXr7vEzWmRqG6xIgFiSmQ0f3no7RiYI70Ob2GUZgSkZ0KUvYFoOK2XTk
l57aV2MXixEP6Cl+RpcpinCP98LIx9O/AM927WNY3ZoJEs3MSB01ly9/dhSKz2oo
HGDNw/fF9QXSVguATwnsBCPmmKMN0OTNgoN73dptKl1WNk4oK4d0byr9UzWjyh6j
JzIZ3g1B9VIa9gFMdZwW2VHRhyi+4FoxQu2Z53DTJ/RP/gF/VDZpUmRx8ZusQsF4
/2N4HQxNR8udy7gH8MaSDP8KnWrh3zQGmpqLs9XUiI5Jgr8pqA7UF9cxRg20Q2Sy
3JBNOzsABBBU6s7Omi0V9Iq1nH77v5m3wVLA0wdiiyaYEq7wnO5EWS2qCkFWPwPK
Ie7tz1EYuAUk4aqzdbdsaE5KlxtTsgmcf0vd6DT1Gg56+E2UKqibI+MdaHqssbdE
AQcuSiLPMGVmeJWJJAsqBoVi8GGlL0i/9aacF3LLtU0bFKIMlk1GFBp0u7kI4OeZ
8tgbpeIAMrXk6VF/wrSIWZU9eh/o13lrsO6sR45Mpfrqbr33gHmhFLKUtzHJmG6a
5FK1ePkIgm8A/eK+LbiWwoBsez8VZcGKu5rQtNyqz1Y9Ci5Iw8o4ZBREMkiGigZn
UGkfhpwuTXhzdOl782qb
=+Qk0
-----END PGP SIGNATURE-----

--=-f7T30DymDb+35Lv0wJp7--

