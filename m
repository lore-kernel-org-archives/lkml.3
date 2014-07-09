Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaGIJp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:45:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54750 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaGIJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:45:55 -0400
Date: Wed, 9 Jul 2014 11:44:17 +0200
From: Mark Brown <broonie@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Message-ID: <20140709094417.GR30458@sirena.org.uk>
References: <20140707154214.GA9212@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0WzQiIesntPPsVaS"
Content-Disposition: inline
In-Reply-To: <20140707154214.GA9212@himangi-Dell>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: lp8755: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0WzQiIesntPPsVaS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 07, 2014 at 09:12:14PM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using regulator_register to
> devm_regulator_register and does away with the calls to
> regulator_unregister. Also some labels are removed and a new labelerr is
> introduced which is less specific to context.

Applied, thanks.

--0WzQiIesntPPsVaS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvQ7uAAoJELSic+t+oim91CcQAJUJwsbxVD1Vk1si4rSr9nRd
h+oAZ5AvDAVptVe0PL3Vw9DYepYlm5dEyHSTKE8SKkS8TJvj+uHeIXvuZGKi8Uap
07+05GWEraVO5nm9+b78OArwSb4wBvRzaIYPzbkqOTs+E+x0y1KZ544CS2LXph9r
r1CMm4yMgtjRHpmIGrHL//VwydmgCWX5JwXYR3nMRUaXV+D4a2yfvoYLDz3HMp3T
671RwErHezQ9dEsgBnLnECOARTlu0iID6Eii6oRzPkvtyRMXypIhjDhGOzafDLtu
L4FWlHQtUtZvH2XIGGfuIknD1AaRfwuz4telxR5l6wOfLExDEbnf8CpTYzNhd31k
fFnncTNmvXHA2ei61AnjqBI1PkdhGXDCgAskCa3HWRpL4bMzgd3egPdtEn3Dtvd4
mVYKZVCJ/cg5N6/gN2et7bx0MFbbiRMLtRraqod6grGrOmckPRBoQGOoOw8MrSp/
jOha6wT4uhXrGV46oRDVY/5iDGL5gYbe+z8xMV53WJj8ty9iECG5KYH58xbpRBno
r6e1w3f6BKYtUZJ/XQYXFGq2SY+4pAqHJ9lc7hf93TzYlfqv4sNt804t5QrIguNI
9fw2TLg9I3Wf+qB4vm1KvmKH8sDqyjr/pRncry293iFz3gvhaqB01wOJiW8k8xmU
+tRuiMfczsrOZ1jXo96/
=VBzo
-----END PGP SIGNATURE-----

--0WzQiIesntPPsVaS--
