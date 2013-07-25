Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3GYSCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:02:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38709 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3GYSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:02:51 -0400
Date: Thu, 25 Jul 2013 19:02:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Joseph Lo <josephl@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Message-ID: <20130725180246.GM9858@sirena.org.uk>
References: <1374771899-5037-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8+VFUngaQGc2C8Pg"
Content-Disposition: inline
In-Reply-To: <1374771899-5037-1-git-send-email-rklein@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [v2 PATCH] regulator: palmas: Store pdata pointer in palmas
 struct
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8+VFUngaQGc2C8Pg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 01:04:59PM -0400, Rhyland Klein wrote:
> Store a pointer to the pdata so that if it needs to be used after
> probe it can be. In the case of booting from DeviceTree, the
> dev.platform_data may be null, so we need to store this pointer
> explicitly.

This doesn't seem to adjust any places where pdata is used to refer to
the new pointer so does it actually have any effect?

--8+VFUngaQGc2C8Pg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8WhCAAoJELSic+t+oim9qrkP/3crBBItEJF3qzz1stqF9yB4
bfdWCB+MXSFdvtxNZT7DtNEd5TQXb2iIy3GA185TaHb52KpJzv6N5KlvamQdECKE
mDLZmcp8VKuRGZ61d8QGyILnWOZ2pznobxgKQ3OLUMs8ak94EC5UD5Y4x4OkMfqI
JLEQ/P26b25oRMXoVtVN9k1wH6CaodZRqzhPNCTi+cRDZjAdPvVjvgu1ivS1FJRu
LXYQZ+H0YbvPkzKW2riMBDf8gZuS6rebJg41tBZZyP6WA0sHAjThhuY4l7sEuYgo
8R3LrxCMswUrctf4tJZpy3SM1k8ypT/uHdZlBpJvn1ZCwvpH2XeS0IcD+RXHVRb0
7P9hSo/HvziCu8e4TepZlKekVvlgs0cCb15wodASGX1HNkG1jhI1XuMifEWUcl4D
eDa5/QKqxJFcUdRj00E095isFGDPpY5EJWNl2eW/Vc23T+EW6tTealphlirzdwZQ
Cizwnp5xNQyCodAQ3pfbqkSJ+ItqC2PMBOqsubhgAApHZO3AwTOMa7upBihhKvqZ
XI5yNqivNu9r6kCIcwUTp4GIbwTvd5KKaP6/zwi8fjwJTYE0O+ejieToiOb+nopv
mepnDQ1W8UdPsrMgUU5qFcKqBBcMIi+7nN8jREiPv2n148Kf0DHYjnSg9yhVaMNW
XcBwZshnlwhkXqZ/IVHM
=F+My
-----END PGP SIGNATURE-----

--8+VFUngaQGc2C8Pg--
