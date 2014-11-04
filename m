Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKDLfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:35:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37078 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKDLfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:35:34 -0500
Date: Tue, 4 Nov 2014 11:34:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141104113417.GG3815@sirena.org.uk>
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <20141030165133.GB18557@sirena.org.uk>
 <54573860.4060708@topic.nl>
 <20141103120919.GE3815@sirena.org.uk>
 <545795D8.1040600@topic.nl>
 <20141103151058.GP3815@sirena.org.uk>
 <5457BD85.2070901@topic.nl>
 <54589472.8030305@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fTrra2YUagINO7SV"
Content-Disposition: inline
In-Reply-To: <54589472.8030305@topic.nl>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fTrra2YUagINO7SV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 09:55:14AM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 11/03/2014 06:38 PM, Mike Looijmans wrote:

> >>You need to develop against current versions of the kernel, this is
> >>something that was merged into Linus' tree during the merge window.

> >Is this an absolute show-stopper for you?

> >With some effort I could move from our current 3.15 to 3.17, but even th=
at
> >wouldn't be recent enough then. I can justify spending a few days on get=
ting
> >the driver integrated into mainline, even if the initial version cost le=
ss
> >than that; but moving everything to mainline is going to take weeks and =
the
> >boss is definitely going to say "no" to that.

It should be easy to backport the support into your current kernel, it's
just a few commits and there hasn't been much development in this area
of the code.  Can you take a look at doing that please?

> More important than that: Since this chip powers the IO banks, we need it
> for our own products, and hence it has to work (also) on the current 3.15
> kernel. Using APIs from 3.18 wouold render the driver useless to ourselve=
s.

This is just not at all important upstream, sorry.  The kernel moves on
and internal APIs within the kernel move on so it is expected that code
used in production won't be the latest and greatest upstream code.

--fTrra2YUagINO7SV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWLm4AAoJECTWi3JdVIfQO+MH/AjuAhfVXy49MivhREFxmHFJ
zJTrA0v2xDb3K//kAvUvzozdX+eiQyfu7R7761kvqzOjZgCkMvzx6gkoysBRrME/
4boGyu4hBW2+CB2GXssM+PMHYu7/Q90Yfz4AtqHsSQsbyXBWjX49nfhzp+rekPsd
yqQhYYURF0F6EhyZ+fLQorbOdP1N8NfVNEKKrAA619ONwd4I/fTZsuy68Hk+DU4L
mzZXkwbyk0tVH+PUo0i1kns48SfY9GY0FbwHGGXPCkXJ7l26cgZelnjH9qNMs5ZA
4RDuG0KAhnjaH4FsKELmpxAaIDfhVL3kS3c87Y+W1l4VTQJ1jyLOOilsAX46V60=
=c8hb
-----END PGP SIGNATURE-----

--fTrra2YUagINO7SV--
