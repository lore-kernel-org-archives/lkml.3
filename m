Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab3FXPEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:04:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51521 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3FXPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:04:12 -0400
Date: Mon, 24 Jun 2013 16:04:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <20130624150408.GQ27646@sirena.org.uk>
References: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
 <1372077594-17052-4-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u2qWrZzts+9rBanj"
Content-Disposition: inline
In-Reply-To: <1372077594-17052-4-git-send-email-t.figa@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/3] mfd: max8998: Add support for Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u2qWrZzts+9rBanj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 02:39:54PM +0200, Tomasz Figa wrote:
> This patch adds Device Tree support to max8998 driver.

Acked-by: Mark Brown <broonie@linaro.org>

If applying please also apply the second patch, I'll drop it from the
regulator tree.

--u2qWrZzts+9rBanj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyF/kAAoJELSic+t+oim9WhQP/iYZaRpXlKs/vIr/esCcdRZS
ZAhcVxvzWZfNWJ5dVVLYZhcuT3hgBz0160ibHJ2/zAkJnJ1a4gkmBeiMgwEnHtgs
NK3rBDz5SKLBJ+VQZ2rm2r1adgt58+0HPxNjqQKNP+VsYYz/t3/HyW4lRIIz4Run
XVk1tWsn7N2Wws+QcnRTre/XtqU+lRVEBbi0MwUgKywnNE+twxkqUSrLRhx2BcGp
VQAjt45k+vGzV0hORH5gTQfHBcl1/J2ZEI+HvurfW5FsaUpQ/shUNVdSAJLE0DWg
YMzG15Kmm6gDiWY44a+vh69MPfL/9ASBEE12qyqi36u25n4xOCLj0AuNfdYxNkWE
aXcJL7TXsGdWI7IzFwqvf/23V0ZofXqSAQgtnUSJe8pAKQ/TyJ8FU2zy8nIZvFGV
MrOGq3MxLuiamKTMjOB5+NMswKxKm58q3pKlPCMZ8/zcY8j8Mf+uluQ8luXupFAk
GkCUgHiCdns4Ft6ejMQJtqYi+yKvjquInJ8tWfl2r0WrH9W5kWZt3RJY3ycvOZxc
UsEhCyrRue/qhvYRtru/4ukfZXvb0GDrryb5/y2KuvEg+gO6jvPJI2FVSCWEijtc
aDnFkY10kPttF60bliFrlvtFJxCghVBENsRIWwgFSWdobyaa2HB2JNswuPPyE0ct
DoDYNSMoRigpFl4XTEpI
=ikyx
-----END PGP SIGNATURE-----

--u2qWrZzts+9rBanj--
