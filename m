Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3LDMO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:14:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44695 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3LDMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:14:58 -0500
Date: Wed, 4 Dec 2013 12:14:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131204121424.GN29268@sirena.org.uk>
References: <cover.1386108712.git.stefan@agner.ch>
 <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NJSRbAqOy4NeGDns"
Content-Disposition: inline
In-Reply-To: <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 2/3] regulator: tps6586x: add and use correct voltage
 table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NJSRbAqOy4NeGDns
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 11:18:47PM +0100, Stefan Agner wrote:
> Depending on the regulator version, the voltage table might be
> different. Use version specific regulator tables in order to select
> correct voltage table. For the following regulator versions different
> voltage tables are now used:

Acked-by: Mark Brown <broonie@linaro.org>

I won't apply since I think that patch 3 needs to go along with this,
unless people decide the regulator tree is the easiest way to merge.

--NJSRbAqOy4NeGDns
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnxycAAoJELSic+t+oim96Y0P/iwCvQWW+CdW94bDsOQ/cw66
bancl5w5GKURJkQNdqCf2H/8T1Vkok3ILXomdTgqn0oTCli2TbJ66SAZZfK5ITIa
Fk/FHriIlEpnSqfHm6k/mq7cMQLFcOgGHFlt7oLAr+tpVh04f1Wtuibnh726w/0g
KRIlUaj013+ytDVvRjw179fxXyCFGoE0iepiOK8+7OFhmxphb5QMB5xgmtRI+y1C
Z4gEdU9fzcd738JjTyY+SKGB44CMFTvfvAXIHEB+ms4de7oZtQfEmRBUBK0/+t3T
sbbWnwJZPU7BsvpXJ23u+LahbtvimY38VO5BrawwJr5MHNLAhT306Ct8WgpD4Lhv
UOlOJ5+Yv0cHg1fnRhZ5Wyvpb+pEotskOj29K8Ve8AZRFavoU5J2CHdsmPazK77I
zkzQK0CMeVOX6rMT3OooNcL6XLlxqPUaUXkhkUkp+6+FDPF5GHpIz/RBQDRUroVM
bnqqXdrZNTjgdRk5zzQUVQU/MB9dT+SnNpQ3UOFl34GxN3/cyXd7QsVoPV9IZOAp
OY9eIzX6+RImaY3+o3LohBJvcwmvC/i4G6nicAj9okoDbnJNY8mCq6Xx4Laxfsg1
CgM9OtbS+gXiwGGzEheWMj//XdHkq74RRXicLlwQ6e93HcJBXEtt9NNX8bIM5UhX
zlqJwS3oIU9Jh5hfDSRE
=Xss5
-----END PGP SIGNATURE-----

--NJSRbAqOy4NeGDns--
