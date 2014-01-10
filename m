Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaAJLJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:09:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51540 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaAJLJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:09:10 -0500
Date: Fri, 10 Jan 2014 11:09:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140110110900.GC29039@sirena.org.uk>
References: <1389319550-12238-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <1389319550-12238-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-sai: Add device tree nodes and its availiable
 check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 10, 2014 at 10:05:50AM +0800, Xiubo Li wrote:

> +	if (!np || !of_device_is_available(np))
> +		return -ENODEV;
> +

I would expect the of_device_is_available() check to be done by the
driver core rather than by individual drivers - every single driver
should have that check.  Is this not happening?  The check for np is OK
though.

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSz9TJAAoJELSic+t+oim9SCgP+wUU19bsBjDnH5cuKtmBgChR
Rp0b+I0Bk2wKJGLgFC+TJrV2auSSMROZh2jYGScFBXjSm2hjg2J9LHY4cudQWsRy
12inmCUAA+VL39JS0pqzGpbmCTdxyoTrP2CQ4pljmNbRPO625KVYVlaI3jLLKOUX
Rxflghkl8hZwSE+uwRNYCGsokAvP3m5BHCyYh5jxklW8GE55PDRenJxsH6JVk3k7
5tc4ZFImzN2duwPTwI58jwpTVoE/3s8d2Lkil6LOD4Gufq7XAqEbBzhENri4tKM3
twwJ+SBiNbhrHUQBIgIoe61ekn7A+iOYr0Dw9dsuPH3A2X+qD4E0qW4e5RZt7SHV
Yxtp0bSZNq618lbiubGo3/NKWkODtbyZFAVdNReD43TR/q8erDnyZJu32seS9Uu4
lMu05o5d8hz5z05kLqNbPODpKcMoEbTDOqjKzq9bp8nhmxAVlL83oH0P9PZFbPVg
c08UQN4Zn/CatxCfeHiIegZlZdJNnq3W1wAGI6CFcMO965gWmt8Ay+ZmW+rjJxk1
pmHK53JcQYWz/MUmCBDAlnboAlJIGcV1cwEacJzszqhzCnp5b9fw/71Dk1BnPBn3
mjkmwfTE3u4rV4UwI3iKd+LJ1tL10lXNNWSO+CJQ0CKq3kudDfM4JxV7Iz3qJIVp
yGRJbXMTXn1THt+AJBww
=Nre5
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
