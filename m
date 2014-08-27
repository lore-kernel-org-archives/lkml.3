Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaH0HZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:25:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35449 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaH0HZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:25:42 -0400
Date: Wed, 27 Aug 2014 08:25:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>
Message-ID: <20140827072525.GR17528@sirena.org.uk>
References: <1409091237-16722-1-git-send-email-b.galvani@gmail.com>
 <1409091237-16722-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u1od66ChgEppm9WP"
Content-Disposition: inline
In-Reply-To: <1409091237-16722-3-git-send-email-b.galvani@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] regulator: add driver for Ricoh RN5T618 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u1od66ChgEppm9WP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 12:13:55AM +0200, Beniamino Galvani wrote:
> This driver supports the 3 DCDC and 7 LDO regulators available on
> Ricoh RN5T618 PMIC.

>  drivers/regulator/rn5t618-regulator.c |  143 +++++++++++++++++++++++++++++++++
>  include/linux/mfd/rn5t618.h           |   14 ++++

This is fine but I can't apply it since you're patching the MFD header
which you added in the first patch.  It'd be better to include those
changes in the first patch, making the second patch independant.

--u1od66ChgEppm9WP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/YfhAAoJELSic+t+oim9VUMQAJ5PilvsShTs6PycuR9zTE8V
cD/MTuo0RGBCyn00HMiE61CfZiwPZaQtzzKOS/52eU65uc/gfZDXLkqVF4niUUOm
zARbBwdBlHnIx48rHs2g/gwg6A7zQG6Wud+m+0OsDnSPwy2z5mjwRckx/P/pZAin
VJaU2BlRBjIyvzyTJd21CsENAC3Z2mVWP5Xd0sCcoGlGZzSqNGvhxBp2jsMeJ+hQ
YoEIbrMwKt6d0Wl7H7KslY5YWRDZ+aGIgMaYAa5fNrWA8dBg/fGjPUkrVUNVyMVx
5GPknhnBqngl1GR7mnRwAuZZ9Ndu3EDBVcVNMDawtmLHA0l42xJqyAMqlbgn+u5n
xbmN/aSv4MLgTixAX44T+LvX3vvptBgaFFhFUoAeeULOvym0xozXO8R/C+cj/8we
Cf3Rj8bnQV03T3WH41++D7po6C8tMSyQl5C8z2oES3abZzy80HVYnW5BzXab1PnR
hfLSp7W/KDLyObFXf33aOh/W4rmywPJc58I3M0T2P84rzCYtWFWh8eTuv4zuS1KH
hzVDq2/pSTUJu4IA5yJPKz5E6Q6hshDeJCVYb6mAXk59zqgAF4dnXue5HyngjvcV
z3xvZr+T65DwTDHY38jPXVIuIo8lOl7QZN1XYtu+ku5iTiHb3glMRT0MnOh2OwXK
zY33P6OWWM0MNhrRCylE
=pe5C
-----END PGP SIGNATURE-----

--u1od66ChgEppm9WP--
