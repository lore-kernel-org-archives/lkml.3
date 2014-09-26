Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaIZI3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:29:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43001 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaIZI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:29:09 -0400
Date: Fri, 26 Sep 2014 09:28:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140926082846.GC27755@sirena.org.uk>
References: <1411551925.24415.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UvwuEPigQXXfOf7G"
Content-Disposition: inline
In-Reply-To: <1411551925.24415.0.camel@phoenix>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: qcom_rpm: Don't explicitly initialise the
 first field of config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UvwuEPigQXXfOf7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 05:45:25PM +0800, Axel Lin wrote:
> Doing so generates a warning as the first field is a pointer but we use
> 0 to initialize it.

Applied, thanks.

--UvwuEPigQXXfOf7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJSO9AAoJECTWi3JdVIfQbXIH/0kvfAtrsIk0tqY55shVfaMk
vBoJp2KPo2i5v4WnLc0yjcfmaeJJrKycifbQWCYpqOlEWLc2/Y57hF0JJdlictvU
g66mgs3BqE/RMxkJeCpAwt8OLDqa3Il1e+6BXRRJFmrT27lcOYz+9JUz3Bk4L+Y4
XpOqHe9fOSWyiz7E38UbgqNNogcZXZj4TIOq61hO2m5ZTYn4ISriqZMs+HX+uJay
WfJ0M1LgZ9fp3rY8Vljy94nM+7tV8HD97gZe/SyDLi4qbVVig2CbZX98SSG9HZeK
6BsZvmp95tGS89AitPed+YYeM7okTq7AUwBETt0oFiCoFB3O96rYjZa73KveObA=
=fXSJ
-----END PGP SIGNATURE-----

--UvwuEPigQXXfOf7G--
