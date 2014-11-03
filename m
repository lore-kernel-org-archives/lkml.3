Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaKCPMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:12:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35555 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaKCPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:12:15 -0500
Date: Mon, 3 Nov 2014 15:10:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141103151058.GP3815@sirena.org.uk>
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <20141030165133.GB18557@sirena.org.uk>
 <54573860.4060708@topic.nl>
 <20141103120919.GE3815@sirena.org.uk>
 <545795D8.1040600@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PdAWLd+WEPmMbsbx"
Content-Disposition: inline
In-Reply-To: <545795D8.1040600@topic.nl>
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


--PdAWLd+WEPmMbsbx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 03:48:56PM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 11/03/2014 01:09 PM, Mark Brown wrote:

> >No function calls, just use regulators_node.  What is unclear about the
> >functionality?

> I don't understand what you mean by "regulators_node".

> "grep -R regulators_node *" in the kernel source tree returns no results,
> nor does http://lxr.free-electrons.com/ident?i=3Dregulators_node

You need to develop against current versions of the kernel, this is
something that was merged into Linus' tree during the merge window.

--PdAWLd+WEPmMbsbx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV5sBAAoJECTWi3JdVIfQPzIH/0usQVn+BHgE+b+3DH4n4PjB
vLiWH2Y4vI247FtPdU2fyMr+WDTWt1koy0CrbOXEi3theGEVqfPXo76FOb04JJ0D
l+G46sTln5PP9MckQIf367jg/0kM/InYJ5YgNCB/OKIS/oNRAE0mDtRK5dQsYGnU
oDMfIw6Gn3son14QvWOpp6P1MHh9GTbWkhp56zwDACzRAMvcHnzBMi2GRp7a7V4J
ArCXy5c5AuD+7i4RqknPJj3YEiGm7cOXAuhOfBVHf0DHX2aOP/Mx+bp5+v1W88bv
9nWbpdp5gGL15NKMc2ntucY+9nfuWxI95WWnAvn7q4J2Pn0WJdO4Fb2Pv6HCQUU=
=9ytj
-----END PGP SIGNATURE-----

--PdAWLd+WEPmMbsbx--
