Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaKQNie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:38:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43084 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaKQNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:38:30 -0500
Date: Mon, 17 Nov 2014 13:37:59 +0000
From: Mark Brown <broonie@kernel.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141117133759.GZ2722@sirena.org.uk>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c6YcJYqqMhegfX14"
Content-Disposition: inline
In-Reply-To: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 176.12.107.140
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v7 0/9] Add Skyworks SKY81452 device drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c6YcJYqqMhegfX14
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 05:33:01PM +0900, gyungoh@gmail.com wrote:
> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
>=20
> This patch set includes regulator and backlight driver for SKY81452.
> Also it includes documents for device tree and module.
> The initial version of sky81452-regulator was applied. Fo this, increment=
al
> patches are included.

Don't include things like RESUBMIT which just point out the obvious in
your subject lines since it obscures useful content.  What I'm seeing in
my inbox is things like:

    307 N T 11/17 gyungoh@gmail.c (3.1K) =E2=94=9C=E2=94=80>[RESUBMIT PATCH=
 v7 7/9] regulator: s

which don't give any indication if there's something important to be
looked at.

--c6YcJYqqMhegfX14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUafoxAAoJECTWi3JdVIfQijQH/icx4oNG++b4I/NloFBNsUqD
/Q3Vy/x5ySzigE7ACwtgAZN6x0AIp/9KjqyPD74I+ZAuJpXdBod8cHLy6z6iD3Bu
5QyLdKAB9NiJ+XoBzLRCN1qkrsKJprMut95X+zCybw9i7JBBkcBrmtOzOq2NP24w
XzGLBiM63/PLB1OjSLypDnzc2VJSOubCsxcSpTERD+kYL07FTkdkRHw3VzSzAW45
tczlsM/2kZmcJqR1eBHpjXr82BfMNuFen5d80RkPu8z1IszPwGD5P3s1zjJBeIGR
akfRmKHrrhUQdCGugeDT9KcwKvucc2p1Im4iHZxEPcp1sfzLMBN33ST/9HdRMpI=
=J/mR
-----END PGP SIGNATURE-----

--c6YcJYqqMhegfX14--
