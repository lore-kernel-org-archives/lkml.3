Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3IJSTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:19:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36061 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3IJSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:19:38 -0400
Date: Tue, 10 Sep 2013 19:19:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com,
        mark.rutland@arm.com, rob@landley.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com
Message-ID: <20130910181930.GE29403@sirena.org.uk>
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
 <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
 <522F3691.3090805@wwwdotorg.org>
 <20130910165153.GQ29403@sirena.org.uk>
 <522F5815.4070109@wwwdotorg.org>
 <20130910173830.GA4708@sirena.org.uk>
 <522F5AC5.90101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PJ1SAQMcJwP6CXso"
Content-Disposition: inline
In-Reply-To: <522F5AC5.90101@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: add support for configuring turn-on
 time through constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PJ1SAQMcJwP6CXso
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 11:45:41AM -0600, Stephen Warren wrote:

> Sounds reasonable. It's a little long but regulator-enable-ramp-delay
> might be better since all the common regulator properties to date are
> named regulator-xxx.

Yes, I just didn't bother typing the whole thing out.

--PJ1SAQMcJwP6CXso
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL2KvAAoJELSic+t+oim9Nv0P/3uWChLKzPEpGS2Xhm+3YuQ/
qIsowpKpBEYh7F2pbI7q2Gszre6UJXz1PjCOtZ6nBZ32wPnotoxMHoYzT8SSd/fc
IpFhr0OS3FQbCZp7asdpj1YRoakwOuywdtCky/q1EQS2AK6Fol+q/MonwYqFSHwO
FU2EehTHOMEIfDjTxHVKSXyqO+j9ppii4agdM2CUo+6QUclSLj3Ii/ZhVHOezj77
s/5rlloHEXUrrcNLIuXElyocKf8as0wi1+DoCkGSEviuuOtAJqRqc+/kKBd5sqoC
HaEYlOv8B/H3L6SQSeBsBC5Kq6+HzgLn8w+biPxZ/AZxvQOYM5qT7rzAqpQKbOYl
HkY1hpIyudiLyQHFP0sXbB8uMidf40fh8umjOooi+GVu3UtNchiZRRUZLPumXvrg
f8d2mWuE58IBa3FayAKsVrL7VheDFpkJ3nRZKXDXah6uYyGtsZPQtYkOSOkX2j0i
nOHoEE1jOG73dZnTl+h9rN1xyeCQ0sch8+7/wYGFkG9k5uX4IXz4nesuzt2S+2f5
B9kDJuhCaE0mPm6gdq735RW+krzCmOfG0raTtSiI9Hk3dER/xAU34VHlls9oWR13
3f/OB7HfZ7Jz3RHtsga5HtC+UBqqPWUmwZ0m9YcVBvU50cglzlhkXsBkKq+TNBBc
y+dX84fafh2kgyNvGVDI
=lDbN
-----END PGP SIGNATURE-----

--PJ1SAQMcJwP6CXso--
