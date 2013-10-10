Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3JJRWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:22:07 -0400
Received: from ring0.de ([91.143.88.219]:37474 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab3JJRWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:22:03 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ti.com]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Thu, 10 Oct 2013 19:21:30 +0200
From: Sebastian Reichel <sre@debian.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        "'Pali =?iso-8859-1?Q?Roh=E1r'?=" <pali.rohar@gmail.com>,
        =?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFCv3 0/7] OMAP SSI driver
Message-ID: <20131010172128.GF28657@earth.universe>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org,
	'Pali =?iso-8859-1?Q?Roh=E1r'?= <pali.rohar@gmail.com>,
	=?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>,
	Tony Lindgren <tony@atomide.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
 <20131008172815.GA8313@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Content-Disposition: inline
In-Reply-To: <20131008172815.GA8313@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 08, 2013 at 10:28:15AM -0700, Tony Lindgren wrote:
> * Sebastian Reichel <sre@debian.org> [131006 13:36]:
> > Here is the third round of the OMAP SSI driver patches.
>=20
> Thanks for updating these, they look good to me now:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Ok. I guess it's time to check how this gets included in the kernel.

The first patch has already been queued and the last patch could
probably go through Beno=EEt once the DT people have reviewed the
updated patches. The other ones would normally go through the
hsi tree, but that one was maintained by Carlos Chinea and is=20
now more or less orphaned.

My suggestion is:

1. I create another patch, which adds entries for hsi subsystem and
   ssi driver to MAINTAINERS.

   It would be nice to have some co-maintainers for the subsystem.
   Linus Walleij maybe? I think you created the launchpad blueprint [1]?
   Especially because I have no documentation/specification for HSI, which
   brings me to my next slightly off topic request.

   I would like to have access to SSI documentation and HSI specification.
   Can the guys from Texas Instruments please give me some pointers how I
   can get access to the NDA'd documentation? I couldn't find any hints
   on ti.com.

2. I create a patch adding Carlos Chinea to CREDITS

3. I create a git repository and put all of the patches in there, so
   that they can be pulled into linux-next.

4. I add a gpg/pgp signed tag with the key used to signed this mail.

Any issues with this or any other suggestions how to proceed? And if follow=
ing this
- should I request an account on kernel.org to host the repository there,
or should I just upload it at a random place?

[0] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/N=
ext/Trees
[1] https://blueprints.launchpad.net/linux-linaro/+spec/hsi-subsystem-maint

-- Sebastian

--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSVuIYAAoJENju1/PIO/qaGMsQAII5GaKv2IyZoPXL9nOiYPuf
wGNHxKQ7k4CUYNCMqFd6YU387yRNMxSkp9lYs8ws7CQzKQ5gpR+ONgBw28H40TSW
I5+YhjNrfs/oLL0H5FZDturWHJ1mCpyjC2m2ArxjD0X8jvE3D0TtXI0wbuPDb8gg
qPSmPUAPZRNYytU9p5N3yr/R6zq6Bh6u/DOgS9qNBZIIqOEtOsPRncI32ZZ1KaTz
0Yjnq+fHjHm6GmNBrkpwwo1IclsFIDit65L1+GsmfQ3ZMUr89Nv7qbvc7Xa59H3H
ml6G7fvLLtAoye9o0iWbfG/eTd4R+++Kl9q7iIUz6ROuhWe7MlOI3iuuKLmoMa3E
YNzd+zkoPJslXr0RSLnA1ij4tVclfZGvF3snbmWx3Y2yWpHkSOn+IDSE8L9cQvWC
1lBsN1ED6Gz6L8LReOwswwLXo6uCUFd7do8Mo7bD1YWqv1LSggK4Ppnt6WPp+ZWB
Y3+VFUtO/zowKWlSukeaZDTxrVodf6Kd31hC0gQ+swedeY3LfUedCia06ma1oVVU
ig6uUFu2AkElKjzS1NsbqeAygRk0pkvKp3JEr4SIiV5+DGNdPBu9RghN6zbq9/8W
HlilFR76UETexbkoTH7Rpg522clGWwrAvJAoEKyXNUGvV7ChJdPfCGu8DEaIEbph
Fo6RLI2sYwVi4Aoa4PzF
=kK4b
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
