Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaI2KYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:24:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52640 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2KYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:24:32 -0400
Date: Mon, 29 Sep 2014 11:23:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20140929102352.GO16977@sirena.org.uk>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
 <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
 <20140928102202.GM27755@sirena.org.uk>
 <5428F592.3020809@i2se.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iEWWOZ/QYGWEaBRW"
Content-Disposition: inline
In-Reply-To: <5428F592.3020809@i2se.com>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iEWWOZ/QYGWEaBRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 08:00:50AM +0200, Stefan Wahren wrote:
> Am 28.09.2014 um 12:22 schrieb Mark Brown:

> > Use subject lines matching the style for the subsystem.

> sorry i'm not sure what's wrong with the subject lines.

> Did you expect "[PATCH 1/2] regulator: add binding for mxs regulator"?

Yes.

> > While this should be using compatibles to identify which regulator is
> > being supported note that the binding doesn't document the fact that the
> > code makes regulator-name mandatory or what values are required.

> Is the following better?

> - fsl,mxs-regulator-vddd
> - fsl,mxs-regulator-vdda
> - fsl,mxs-regulator-vddio

Yes.

--iEWWOZ/QYGWEaBRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKTMzAAoJECTWi3JdVIfQfx0H/iylZ4g8pS5Fu8LP8XqMt5sp
oNPHAui6VdJ/RWUvk0m8NuZSXUV+6g3+HG5Y1MODP+pdhJ7g405N+GlDXxi3SNbP
kzC2r55fGbqTtduMDZDv2Ffy7op/meJp1urjtLvq2VD/CtXJ0B4hNjotkPhzv+cS
thrZ6+5EtsiLodfn2/PKfSS9WfsoP46nT7oWHd7L0EYJF6G5M31nL5BkaU5gThwk
Wd1SLEv8xa0tCQQsuYfwe9tUzscK6cV8QM52pUsaUUaIu8hBXENdsoTpgpfq+Ymx
okXLdwvBcPsCQMFRbzwpX82M8oHg4ijLuBUF6ACcPBBCUOVnhFIs7EgeVXgwvp0=
=S+g5
-----END PGP SIGNATURE-----

--iEWWOZ/QYGWEaBRW--
