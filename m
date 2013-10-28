Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3J1QxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:53:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43470 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3J1QxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:53:19 -0400
Date: Mon, 28 Oct 2013 09:53:01 -0700
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20131028165301.GN13643@sirena.org.uk>
References: <1382713426-2680-1-git-send-email-treding@nvidia.com>
 <526AF150.1030004@infradead.org>
 <20131028080109.GE6629@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95CBLwa+io9O2zXc"
Content-Disposition: inline
In-Reply-To: <20131028080109.GE6629@ulmo.nvidia.com>
X-Cookie: You fill a much-needed gap.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 25
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--95CBLwa+io9O2zXc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2013 at 09:01:24AM +0100, Thierry Reding wrote:

> Perhaps something like the above scheme might be a good compromise. On
> one hand, many people are using linux-next for their daily work, myself
> included. That implies that if linux-next doesn't build, people either
> use a previous one that does build (so we don't get as much testing of
> new trees as we possibly could) or they fix the build errors themselves
> which in turn may cause potentially many people to have to fix the same
> issues. On the other hand, if patches to fix build issues are included
> then people might just assume that there are no problems.

This is one of the things that the per merge build tests really help
with - they filter out the vast majority of errors by just not letting
updates into -next (which applies some backpressure to get thing fixed
in the original tree too).

> With such a scheme next-YYYYMMDD could serve as a metric of how good or
> broken the various trees are, while next-YYYYMMDD-fixes would be a base
> that people could use for daily work, with a set of known build fixes.
> Perhaps it could even contain fixes for non-build issues, such as boot
> failures, if we can come up with those quickly enough to make sense in a
> linux-next context.

> Any thought?

This seems really tough to do given the rate of change of -next -
there's about 24 hours to get fixes in there before you have to rebase
forwards again.

--95CBLwa+io9O2zXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbpZqAAoJELSic+t+oim9hIMP/2yETnhq8MolJhqmeM2eAl2u
/bYN8Z2fHC5Ab3aggT/IKq7HddUv4aU+PGvNvIPaEKNqhOF9Oc8UrZv+rx5QEBAa
yAChNOcK9ATjhCP/SzM0/F/HwdLzFFGKdAwskPPtnRzKZysUqdq56uzr4A0q4VKN
M0ukcjB4cPoJ4/tyEXjMLa8dnFIA3RtaTl8efZmdMi0sZOUPy2Uogm8JBwL64rFS
8mxAWOHxpvcu8YVAbL6HrXEE8jz4Jq3CHFywin/tnmjJPmfStGp4t96IsLQ8/+xw
J2GAkcH+hBt5V7pe4P4e3Y/iUf70CnFQdKcyS+OJL33QlIiTnKJh2ipHKjDEj8Y7
sxNKGsQn9Wdeut7k8opRvjc/DHnai+9hV4B+bJC+Fkd6A+M1JSDkZ3m/CXgoNTY5
T2yhT+gnLZBEDzj5HHBcm3thu2BG7y7F7HcAOJboCn1X4VhQIKAw8UcjBSNYBFtE
WwvbHpF/DTKIBG24jPAhhc4lAWyiZuu9BbgwiwtvCVIJ0duZBxLBwVDf4Dp+VOQp
grHB4I9WG19k4lzIKofq0OqGiYpLcmZvN2J6qQw2aohUjGbgFCPhB/HpUS7gE5g6
AqHQahyK4h8R6UTLyhvGEqmwtXjvL+VqWg+SW2joaAW0w2sdHo0qmhl7WNIz9IWI
06B5U8RXChbwDWIQlwcl
=xLA5
-----END PGP SIGNATURE-----

--95CBLwa+io9O2zXc--
