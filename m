Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaEASqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:46:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54298 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEASqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:46:16 -0400
Date: Thu, 1 May 2014 11:04:28 -0700
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20140501180428.GO3245@sirena.org.uk>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
 <1398789430-23897-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JH9OCe1BwbSt0K9U"
Content-Disposition: inline
In-Reply-To: <1398789430-23897-2-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: ltc3589: Add DT binding documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JH9OCe1BwbSt0K9U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2014 at 06:37:09PM +0200, Philipp Zabel wrote:
> This patch adds the device tree binding documentation for Linear
> Technology LTC3589, LTC3589-1, and LTC3589-2 8-port regulators.

This is all good apart from the vendor prefix change thing.

--JH9OCe1BwbSt0K9U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYoypAAoJELSic+t+oim9gv4P/22q0yzFD/zUAx9XDTWaaj4m
1e0sc22kxo/aeVqYvAXU/NZwdimfhJikZJZfLcTajxk2FuvlkOcu+JlBA5psLOdU
7D6ReTiIK1682i61x2aywP33XQd1jXM/1D3QEJaZRjtM5NTdtA373VcCf8Ju1vr0
0enLSsg/GKzEbaXGrgt2z4Y5eN5fQ5+cX7SGEzAtrdli6n+WEDdZhNemKRmejHlL
NzT32RfKHmGNVjtuaqgSROnblO7ZJejqSRgcqC4bfknTPa6DrJArOKYWZldMuCnD
SYV9EC+adHRCUCoRsbndo70UZfiXUGJ6yw9scm4J9aUvSCBl5sCU/8g26JQlo7fN
h4Zz3RqmoI/P3MlFmLJgtJcIEs0/bBdZWlZLCe3ky2/VmwjA/8quVX5rFQsfxFDl
Mv3EHqqzdmUW4AzmHEGB0iuUlkWKzZdlYI0ZWoCCqljXc10DgQYHq2AaaqBr7ZHf
XsVGbAaZaq4I7V8NTy9DC0k2LorYU28PNYyQoVtzbgsWcaJgB64CN0OdsAo8zsvF
kpT34wWxtbCA75JMdiuxTnX5qweSM0pfI8JxWpwVpwTLqJhQZ93c8yFvmDGbrnfz
0RJ/xNtSnoMiH8TuM4iFcEMMCXF0qWwM6moJdrUHtdVEOhnvf79vzuEQd6BZ/+aP
89o4+TJdH/IYrQT024lk
=PZLT
-----END PGP SIGNATURE-----

--JH9OCe1BwbSt0K9U--
