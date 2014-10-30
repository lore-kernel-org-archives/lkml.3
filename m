Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442AbaJ3KQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:16:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56925 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbaJ3KQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:16:23 -0400
Date: Thu, 30 Oct 2014 10:15:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141030101555.GT18557@sirena.org.uk>
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
 <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <20141029123005.GH18557@sirena.org.uk>
 <5451DF10.7030605@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bR1MwnaCW0eJjEhW"
Content-Disposition: inline
In-Reply-To: <5451DF10.7030605@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bR1MwnaCW0eJjEhW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 07:47:44AM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 10/29/2014 01:30 PM, Mark Brown wrote:

> >A couple of problems here:

> >  - This contains DT code but no DT bindings documentation; the binding
> >    documentation is mandatory for any new bindings.

> Should I submit a new patch to add the DT bindings and CC to the dt maili=
ng
> list, or do you want it included in this patch? I was basically waiting f=
or
> feedback on the driver first.

I'm not going to review a driver with bindings without those bindings
being documented, it's a well documented requirement and apart from
anything else it's not really possible to review the code that manages
the bindings without seeing the bindings.

> The "default voltage" may not be device specific, but regulator.txt doesn=
't
> have a property that describes what we needed here, because we can't get
> away with specifying min=3Dmax as fixed-regulator does. We also cannot as=
sume
> that default=3Dmin or default=3Dmax, because that might harm hardware con=
nected
> to the other side of the IO bank.

No, if you need a generic property add it in the generic code rather
than just hacking a device specific property into your driver.

--bR1MwnaCW0eJjEhW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUg/aAAoJECTWi3JdVIfQSmAH/AqPohFDCM1Og/U0O/+mFGed
ZpK9JyXiTsNNhnZwh7f/qAK1FudiAd7E7c9yGRU90/68lcUyfnjO/KlTtF8lD+Yk
R/RAl5xEAvhdYU+sCZ/IkRXLaE6LnYkY8rOf3/ZcBOi1dLUy5aDhvx6hS2yFJuy6
51LHGzzcoKIg6VeO4ar3kLVCBNoVDfyp0UlhWYkBKSQ9L7a6hH6ITw5zmx+7aw00
CBq0MSMcnnKAmMtNhNsIRot643UcfB2DaFvoOdLhFEsjYd4T1BdMD+/mgCqwtbIi
h/ZGLHn6ClVuRe/zRrOS1SP/GFB4JVh4Gk9Y8UHrtQXbyBWgZ9GejX17I5w4Qqw=
=X+n4
-----END PGP SIGNATURE-----

--bR1MwnaCW0eJjEhW--
