Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaJALpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:45:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56403 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaJALpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:45:38 -0400
Date: Wed, 1 Oct 2014 12:45:24 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [James Seong-Won Ban]" <James.Ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20141001114524.GU4273@sirena.org.uk>
References: <201409300310.s8U3AUfe031634@krsrvapps-01.diasemi.com>
 <20140930124522.GE4273@sirena.org.uk>
 <0ACAE736BB7A70499F1D8D5E6AC1854C01AC2AF92C@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XJ5wUQMT/jAb5xue"
Content-Disposition: inline
In-Reply-To: <0ACAE736BB7A70499F1D8D5E6AC1854C01AC2AF92C@SW-EX-MBX01.diasemi.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: DA9211 : Fix a bug in update of mask bit
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XJ5wUQMT/jAb5xue
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 01:02:27AM +0000, Opensource [James Seong-Won Ban] wrote:

> > Applied, but please try to make sure that your changelogs are more
> > descriptive - what is the bug?  Please also use subject lines matching
> > the style for the subsystem.

> The proper operation of mask bit should be set as '0' for enabling the interrupt.
> The result of mask operation at previous code was the same to new one.
> But the meaning in the previous code was to set mask bit as '1'.

Right, the point is that this information should've gone in the
changelog - please bear this in mind for future patches.

> What is subject line you said?
> If you give me an example, it would be very helpful to me.

git shortlog drivers/regulator.  The capitalisation and extra spaces are
both off.

--XJ5wUQMT/jAb5xue
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUK+lTAAoJECTWi3JdVIfQkvUH/0HJLy0PWFFFBzijr0Qf21RE
toHxOXa/I2tQ50xgmPccMGqQSK7Gl3ghs9xiwRGtlY36I2lt44SVEC4prpj8CpTt
Eqd3gP8pFsAfT4B6pv4btSMhr0sZs8Kt4ztP2kasbEiGbFdy4ZSOnHtH0nZOYah5
Z+n/22bTQL+gjxxphqp3Y4RtpMVLUc37jChFcEMZL1XXYmM5Sz8HE4MiSmyojDAf
E1JANB7uBdW+pEYGA5vMopc46yvIa4UAKitEh36VtbSoj5pqUUmuIK4gmcy/PJZE
ZBGh+OEofHlp5TzzGnLW17afUmOD//ISMToJVKcHXW+pmy0S01c/ceBC7/3BIIU=
=fhzi
-----END PGP SIGNATURE-----

--XJ5wUQMT/jAb5xue--
