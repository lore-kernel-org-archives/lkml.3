Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaKCPeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:34:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35583 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaKCPeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:34:44 -0500
Date: Mon, 3 Nov 2014 15:33:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103153303.GQ3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qnK4RqISe3HuYx1/"
Content-Disposition: inline
In-Reply-To: <1415025649-8119-4-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 03/14] regulator: of: Add regulator desc param to
 of_get_regulator_init_data()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qnK4RqISe3HuYx1/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 03:40:38PM +0100, Javier Martinez Canillas wrote:

>  	for_each_child_of_node(nproot, np) {
>  		if (!of_node_cmp(np->name, info->desc.name)) {
>  			config->init_data =
> -				of_get_regulator_init_data(&pdev->dev, np);
> +				of_get_regulator_init_data(&pdev->dev, np,
> +							   NULL);

This looks buggy, we're not passing in a descriptor.

--qnK4RqISe3HuYx1/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6AuAAoJECTWi3JdVIfQCmwH/AgbbttynX5wQL+PwQy7+ikW
5eBVFddcX9UMx/+3NuqH314aI1nXfReiYr7kh2WXDDtNjs+JImV9FInSwmOdZUcL
IkDPt3PmEy4L671HAKaLm9V1kN1hIE04zny1NPfEz3r/i0f1jfRaDo2AXMwSRvE4
mPR39+td+dzytss0AhrlAAgMYRsH4FjavyqbyLYtO9lJnJIHQfhCRaXy6rhEXdc4
G6Dy5ecQ/HXDcimu8aL3bYFu6ptlkeiZS8b82P22K+U5gBduAMBwpTFTw0JzDVwd
G+a27pEXvNzu52L1erBsLRM6Ujm630yz6jyQlhKnBV9Xxaq6D+CP9X39PZkAkVk=
=yNTJ
-----END PGP SIGNATURE-----

--qnK4RqISe3HuYx1/--
