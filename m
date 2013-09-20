Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3ITLdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:33:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58973 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3ITLdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:33:10 -0400
Date: Fri, 20 Sep 2013 13:31:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Thierry Reding <treding@nvidia.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: core: Fix default return value for _get()
Message-ID: <20130920113151.GA30942@ulmo>
References: <1379676289-18882-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <1379676289-18882-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2013 at 12:24:49PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
>=20
> Now that we are defaulting to providing dummy regulators fix the logic
> for substituting a dummy by making the default return code -EPROBE_DEFER.
>=20
> Reported-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>=20
> Not tested at all.
>=20
>  drivers/regulator/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Thierry Reding <treding@nvidia.com>

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPDInAAoJEN0jrNd/PrOhqGsP/AkT4fZ4P+1dvnEMELo7Iccu
g3hr6a7nEJgO/ZfwBaCBI6TkM79RJwAjIg3/DPGGktT8G3hE7R9saMN3hlk9mond
/8fGk9hgsRxeD/aGPmSBRSFXhPhp1UPm9bYGtZen4mXAoAo5gh15nR8IBWVW0/29
SRTtFWYS7ankJEUB+Y7ezlXaijQt7s9gmEUvCpAI25IQNjEvy2X/ofBk9fBQBO7G
vTgv6BldFIvnlPlhXQGybRNbCMOGG25LJ1QDqo848A19NckWG1XVFlbNFAx7oYhy
ZtsAYpJjQXtG4TyXySzyVSI6DKIfpeMmFWoyjuMspqEssFIYaTArGsx/QFpuU3H2
jHDhK3BPLacmnrTsIFF/HMx6JUlR2DJOZdg+jonMX2qjgYggMRpEzAJ/D2hFDXWa
C5DI2x54PZBqEeKzI2akK69/RLGuml5lmbCHuCQHuC1YSwB7YgSEMUd2VRrNZit8
SLM4Di9GNMqioU8rcRAm/CoQOjln1Yy34kwkA4EAEtGQnvvE+e1cXQx1AigPu1KS
BI4Puec3/LiVPMR95m1aQaQzKe9WSecKQcnp3KUPmn9luGm5BKqqB5scfySAlkUm
nrTw1SRxzXrvQctBxjiX2KBbjA2ypmnlIS1z7hwFzHGDmjxn4XH+kyCK/8Q/M0zH
3gHqZa/7dkwNoJLnpMuO
=LHuB
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
