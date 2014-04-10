Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbaDJRbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:31:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaDJRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:31:09 -0400
Date: Thu, 10 Apr 2014 18:30:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Message-ID: <20140410173036.GB6518@sirena.org.uk>
References: <1394250929.3892.1.camel@phoenix>
 <CAFRkauBA0XPQvoqsUkUwHksf4WbEGi=2Ekm-AY82SNmegHDsrg@mail.gmail.com>
 <CAFRkauDeThG0Jh_=bAuOkJx7=61xtrwFgutXywtBAfcqA8Z67g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+9kyDs7IugQ0lHaC"
Content-Disposition: inline
In-Reply-To: <CAFRkauDeThG0Jh_=bAuOkJx7=61xtrwFgutXywtBAfcqA8Z67g@mail.gmail.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] regulator: pbias: Fix is_enabled callback
 implementation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+9kyDs7IugQ0lHaC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2014 at 05:50:42PM +0800, Axel Lin wrote:

> I just found Chris sent a pull request for 3.15-rc1.
> So I'll resend this serial to Mark after 3.15-rc1 is out.

I still have it, I'll go through after -rc1.  I was also kind of hoping
for some review from people working on the driver but oh well.

--+9kyDs7IugQ0lHaC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRtU5AAoJELSic+t+oim9o68P/0TDJxOZHD88cx5LeFPzB5rF
13aHq7wFSILBn9QRX7N+LnSBu0aCtRWX0rdKUi06x08RYF3nDkaehmbebYS0RgR0
SPeL7IsCYDwQTNQq2JNs2tAi+3gTGs/LyJSBLGzjqA0e65ErpU01oc+bYLpCDYUQ
RAH9yMO+grIW3Qe9IjGQ3BLamVhTxmX8ZU9I9Mn5Eh2z1yKalCgCGleDCB0mob1T
BmuwyUv7ANlzWvs/VjC2RpsecMjPRJhjKhatHrSqv26zSIe2CbLw1GXyYAwWFcTk
1s/zqxPUddVLWbybyRYG1FjEmsMmkPaQNvmeneQ1OMaMCLadYPOUGmGD3dxbAmXz
An2cop3lkw/HihpfI9NmKSLtZR2EBY+k6LlvZK7FgTO0bIgGNC3/SNAX+BopV29t
j3qhrZuQx4V0BW6KTN5K8Dt7k1oQXbb1ucSE1IFSsut8xnW/i9WFoIRZ0Tdn7iP4
NPuf9J6pUB26XNxU4hlit69m6AawIkEK9Id1/vb4TidxgkJJvMl1oFjGvmuUF2mv
sGbZ7QEoufjTMOtR0Notw4nxQC+YPlZZv65wcnb78Xm1LZpEhuUGYZXnTDfrd59T
geaDF8Is+GxpCRx0NCY3OmNrHkebqWnfypT15+S4uXVeKQH+eLSBgLHVyleEwYZH
4R2P29l1VLFxS4ikfDsy
=cTwA
-----END PGP SIGNATURE-----

--+9kyDs7IugQ0lHaC--
