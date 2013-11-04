Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3KDRIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:08:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47049 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3KDRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:29 -0500
Date: Mon, 4 Nov 2013 09:06:17 -0800
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolin Chen <b42378@freescale.com>
Message-ID: <20131104170617.GN2493@sirena.org.uk>
References: <20131104175251.817bdd5b55652625b2b6e0ed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nc/lueCMLdgjBWoP"
Content-Disposition: inline
In-Reply-To: <20131104175251.817bdd5b55652625b2b6e0ed@canb.auug.org.au>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the final tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nc/lueCMLdgjBWoP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 04, 2013 at 05:52:51PM +1100, Stephen Rothwell wrote:

> Caused by commit fc1a38653793 ("ASoC: Add pinctrl PM to components of
> active DAIs") from the sound-asoc tree.

> I have reverted that commit for today.

Thanks, I'd already reverted it in my tree after a report from Fengguang
but that must've been after you fetched the trees for today.

--nc/lueCMLdgjBWoP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSd9QFAAoJELSic+t+oim9aTUP/0VmpzdrH7cP6+60PQQda7Ac
zwhpieTtEeFSWQMCLocYn7wn39irhazerLy9NWYguGadjkcNFA0vOhynFCU45CF8
FzcUUvWD35YWB/8SATba7icqh0VyqhjMVHP3Vib7XGo1Pre8pNidG3LfQAr75fjz
6J2Z0vsFrLyY+u555A/FlG1N0BTSxJUfnYTcJxZ8kfgNVmLRTHOqnRDZ7WYFdESE
AUJCz2WOFDXTInNKG0MvxgRmmNcuay1aINr9Kfe5SzsRvT8QG6SxwjMcImkFELam
yCVJuWRRud1SfS5sdBXtexZYXrxuAE38cSga2E+ZoX9GK0Mcn+L+5oZP2i5wjcPq
BGTUyukEd4SAmJORylaGMEYi4uLqgA0noQmrBe0phWC8w/fB6eVspJCnE+LnaemD
4+vf+/uwNwNXcAB+BwOBY5t8G+1wF94Jt2+aNZDOrg4JIFJpbYhESH5JB2rkmlVR
jvAdj56DCOxtgQYHRsfao54WIBSHBCCzRqDeAcVTYDpn4T30fWJwdwOWpXbuwXL1
+pPPPNfGBhNvACcILkYrEPK3w4alT/DmtQibccaJ+AuuEYTiR621ETG3m8d06YDZ
MeTfcb7X+MKViOabI83U6QdIHvrC2LcGRMy7RWTJwJVa01tgeFwalHsaVfSJGyv/
F1pFRJkaDbe9YB3/Kw9z
=zmjQ
-----END PGP SIGNATURE-----

--nc/lueCMLdgjBWoP--
