Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3FJKqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:46:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45766 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3FJKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:46:53 -0400
Date: Mon, 10 Jun 2013 11:46:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130610104629.GS31367@sirena.org.uk>
References: <20130610100615.GP31367@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0myWGHcy9pFzWWmx"
Content-Disposition: inline
In-Reply-To: <20130610100615.GP31367@sirena.org.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regmap updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0myWGHcy9pFzWWmx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 11:06:15AM +0100, Mark Brown wrote:

> feature.  Otherwise we've got a couple of fairly small cleanups which
> would have been sent sooner were it not for letting Lars-Peter's patch
> soak for a while.

Having just seen the -rc5 announcment I should probably say that the
cleanups are really relatively minor fixes rather than just cleanups.  I
can respin if they're too minor for your taste though the rbtree one is
a definite bug.

--0myWGHcy9pFzWWmx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRta6CAAoJELSic+t+oim9SvoQAJYsqXQhQz22YUlN9uxms7nc
VWiOvs0h9gOzuNW9vSzBXGcTHLb3k8AlZFirDz8Ec7CcoSq8F36YoVzSHG2d8B0a
PK02oUZnV4cvVHjec1ZvJr1FuUUVrFSbeC30UNU//orn+hprz7IJK/vowiM7sVCS
l9bh5zrgSTGaEIVSs414R/3nPsPiojULwu/YzaJ4ETLWjjWVyBm9bR3bv1JwB9hn
T5D5YTh8xcQLo0omRMX6xYSfvHpH0A1QlNkNbC02vt58+fyvRccZ6w00IscZsNwU
jYxVTpxSFvCnmmODzMPg17eJK3yxBEw3PFVWUnvQfROzEjlwRAl4EUhaCyUeT6+8
/YQhbj9yeiQT8ynCluyi/BMY8rQFC/E8vAUqVdkrRaSguoGeWcqNmp31iHyN8qcU
wzPW6Fn7P1glhaph9DZSnpEP6OM1ZADWs6bvSGSJBVT1S/wofJ3HddC/ss8Bwoyn
DaSvXa+HsaLCyp3Gp/t+yTOqwfZnoW531oEMaQGv5TloCxVnMKdUbgaCT+oJzund
jLfH0SxrMbl3gdRjUmM7sUtCRkuadCpktrMjokvFVRFf/DtYe55ByRA95A9S7bim
37w8w9jVEhisvr7G60xCM7jzJaHfmNvNHoHa1Dg76BJoDMBHmwqWClLTxeqgvMbP
8B2E3u3L5zpvCo9in9pi
=YR9v
-----END PGP SIGNATURE-----

--0myWGHcy9pFzWWmx--
