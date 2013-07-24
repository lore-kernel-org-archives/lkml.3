Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3GXOha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:37:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50410 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3GXOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:37:29 -0400
Date: Wed, 24 Jul 2013 15:37:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Message-ID: <20130724143703.GH9858@sirena.org.uk>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-26-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CHpW5YICyLt6224O"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-26-git-send-email-wsa@the-dreams.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 25/27] sound/soc/tegra: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CHpW5YICyLt6224O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 08:01:58PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

This doesn't seem to apply against my current branch, can you please
check and resend?

--CHpW5YICyLt6224O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+aMAAoJELSic+t+oim9uosP/2t1J9JW/4junv7CHj5eGwCa
i4NzP6WT6UHYGfMQWOdW92c34wFHrv/U7ioebl1Py0IT2zteMUsF4sQ7ogWiwRVr
ab74QbKC4hBrRoq5gtr/SLa0kDcaFWuxf1XUFrVXZbg/pxZGosWp9ihTJ8b1r3lG
yDiQIMRvtq/QIz/RLnaokVGq87rhHwG55+ute3lk4SEMAkOrJdEdTnYretB5xOhm
BAefrVdjgkZhqA+x2VjYlrbjbhnAdD7ZmhvXdRb+FBd8eLTbPnDsr4ML9UPF6NeD
vq9mckgl/hm1KKwQhrw99caCnooips6eSc+kK7PT8RiwmMB3y8BDfJobWp+svKnk
CxzAFc6iSn/1CU24FOt25YhwYDmCBh6J2pJyZBJPJkQ5Gph3hCn+cCSdpCsaq7/i
tGLimFSn6X4NYKyNPMsoE3XRX1cQJ4NDBilgqyP7hHymE9hCCMHvPRWF4VJzlE1M
JtOgpKOr7kLs/vJrl5cTHZlyO7ToDj3RN1/xNL7bY78AC28VZxaW25ry9MaTpS6h
K+9wOXdRj8H4irFixkpWjWYwGhQ80MbBrNMgD6Tfu4ajC/b31AWiHjcWklVaeY7n
4f7lfZhRtyqlXfAAyiIJT5K00JaxsUyo8vo9ZosYAG2TkXDQbVM7ACKYxFVg61C8
h7c+55FX4rE8YpX58PC8
=RTgd
-----END PGP SIGNATURE-----

--CHpW5YICyLt6224O--
