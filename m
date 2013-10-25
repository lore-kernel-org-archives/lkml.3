Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3JYNY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:24:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48704 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3JYNY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:24:28 -0400
Date: Fri, 25 Oct 2013 14:24:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131025132422.GC12932@sirena.org.uk>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
 <20131025083525.GF19622@ulmo.nvidia.com>
 <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.181.129
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 24
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2013 at 06:16:02AM -0700, Olof Johansson wrote:
> On Fri, Oct 25, 2013 at 1:35 AM, Thierry Reding

> > Yeah, I saw the devm_gpio_request_one() errors too. They happened for 3
> > boards on ARM I think. Must have forgotten to update the summary email.
> > I'll see if I can come up with a patch to fix the GPIO related build
> > failures, or at least report it to LinusW or Alexandre.

> Hmm.

> Please don't apply fixes like these directly to your tree, keep the
> broken parts (or drop the tree that introduced it). It makes the
> process of getting the fixes in where they really have to go much more
> error prone, since there's no way to track whether they have landed in
> the right place yet or not.

The rule I was applying (which I think is the same as Stephen applies)
is that I'd fix anything that was definitely the result of a merge issue
(like the build failure in misc due to a sysfs API change in the sysfs
tree) but not anything that was just plain broken in the tree in
isolation.

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSanEDAAoJELSic+t+oim95O0P/i8fNoNQ3dN64VER+ZzZB90Y
SrCy+Q/F2FsQy4MwM+Hw1QIt0d8gFegkyevdxSCH3fvjc3JJ4z+iCfCL08/k0PG1
eiXuZahQLFmm2cN8vuyRG3k/tyO9FMm8WpN67lNNDVJpQGBDp05hgCiq/b5fOnoR
NJjjxq58UyCt4tYIJG2bSXMLWp/wVSeLdhWPsP4oUZoiX18mdkqWjytEnibzJVt5
hubsS0C2DNeh2phJQ18Tyv77DMLtutyULRmT4aIxCSXvjB9Hd2RPh5g4dCQk6D8y
OIcvzc8r1Mf53Zf/GumdY93bDG4IlYa8hREKD6bwGO8imgJw7rc3S1no/0mZMAZ4
cdFBzFhm9LxTAI77y9FGKBQ6TnmBDNkZIQzBebzodLaDKUmbwkfsJtiwSKo0iQVQ
4ZWH8oSWXATcVYAcxgCRdrpabVCMYJOzbM86aTFuWk9SHcZTcsHxqBGccnge81L5
wvqiyUwUh03hVTACQG+Epv0g46fPRBXkJvZerY+k4fV6lOO7OMEyCwSmCu6anXG6
+IiVPOmBGZydgpJJsDSoCT0d7wwi7BhBn1kTVmmmUqjcVYOrPHENwCu5gmRmCuZo
9NYpI3u4E6V4PVqSPDURSl/HyjUcfN40f2siija2J8EH6q6/UgVIATlh0+SpHVe+
loVlS8Mm8URE1aBrIR7h
=Dxcs
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
