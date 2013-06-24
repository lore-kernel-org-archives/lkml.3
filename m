Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3FXKbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:31:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38478 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3FXKbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:31:09 -0400
Date: Mon, 24 Jun 2013 11:30:41 +0100
From: Mark Brown <broonie@kernel.org>
To: jonghwa3.lee@samsung.com
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>
Message-ID: <20130624103041.GH27646@sirena.org.uk>
References: <1371711806-18826-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130621151930.GB27646@sirena.org.uk>
 <51C7A6D2.8060709@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C4ZO9l7mQWyMv5+Y"
Content-Disposition: inline
In-Reply-To: <51C7A6D2.8060709@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77693: Add max77693 regualtor driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C4ZO9l7mQWyMv5+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 10:54:26AM +0900, jonghwa3.lee@samsung.com wrote:

> I'd like to add binding document to max77693 mfd's but it is still in progress
> (https://lkml.org/lkml/2013/4/9/221). I think I can updates it when the patch
> is merged. Do you think I have to wait for merging? Or just add document under
> regulator/ this time ,and then move it to mfd/ later? Which one do you think better?

It's fine to have it in one document, just post both so I can review the
regulator bits of the bindings at the same time as the driver.

--C4ZO9l7mQWyMv5+Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyB/OAAoJELSic+t+oim9X7YP/j2jgveGjEmfvst4VGSWIcg4
sciqrkeXA7sulq17rp0DKI8CZ1bSU05OJpoToWp3wcUqObw45CrRYawH5rMRFknz
/rSVQIYhOiXBKYNy3isuBWFuMeVNT7GA7Lb71pzmTjfq2xZfO/LnoC19d/x8a+D9
PZbk8kyfGZZ7ZxPvGeECDL9qamciAMDIRhgujk/MEmwr1KAwhLk6uk/BxUYcsABU
B7xi2KeylNp+d6L3+KCyTbjirT9mMCDBwZTE3m4fGnwl0sN5YinV76fpGGYg1AXt
lh5i+tsQ8Az0q9vh1bK9cxfgMZ6VmyIgllhGeQwdDerd7mqtnK4/NZG63RLQQEE6
jnQ9k8z9BZ85YqBtXMOe/wa3zqoqRq+YU2JfinzzHldsrncfXFcfmQmgo7DWdGFO
lRK9/QPz0bPDZYaEwuIKQqNKD63cDUk4DbKWpMTW/iNstlt0w41JtSGyWpYA0UW0
J/tnhQnbWh4bnueVDySAkRgaS0JSlpsmHc8DwCkiV0/99oV50PlDIPP5A4m6COmP
ldHanDGprSuC7mlFFMvO9cvyvsT62zOzZGGabu+bCVTdiNPw1k8FCCGlc5FC1jjN
a6LB1BSvhdTA+yZzBCS1M9Wfcozo5kFBNB07Hpoyu+ITJ9Q1OnaOu5lq7+HcDlYA
mqtBpBXgDWzV6RC/Kj/v
=Q9SG
-----END PGP SIGNATURE-----

--C4ZO9l7mQWyMv5+Y--
