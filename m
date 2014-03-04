Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbaCDL32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:29:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55424 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbaCDL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:29:26 -0500
Date: Tue, 4 Mar 2014 18:50:51 +0800
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140304105051.GL13126@sirena.org.uk>
References: <1393928414.9669.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TnYVF1hk1c8rpHiF"
Content-Disposition: inline
In-Reply-To: <1393928414.9669.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 182.93.4.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100: Add terminate entry for
 [i2c|of]_device_id tables
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TnYVF1hk1c8rpHiF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2014 at 06:20:14PM +0800, Axel Lin wrote:
> Also remove PFUZE_NUM to avoid below build warnings:

Applied, thanks.

--TnYVF1hk1c8rpHiF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFbAFAAoJELSic+t+oim9ssYP/2AsU8aphSZCLNprZELBvjVC
4NCa9Ocgyr6qcUuM5aF+tsBmg1oc6EeJbClmIAhJ42igq9uXtGiNJhmIt0JYploC
NykQVYLoVwaZBaAxpmCGp4hoymVAttS/cJb/+EiZbjfkNIQsHFO/5MQH5MDGJdl3
c0TzNBN36T95pjmtongmqMN3FrIuPePvl6t5grLJawTPq7UkBJWoe20aaITP3dK2
knGIzgqwZxxcKpU7Vo/ljvFispDpETAyxHAiiarxi3/gX5oEKBKQAH/ix56RK2Dq
AgP+WfNA6jkrRzh3MlwZcK8ZBEi3o00PN6y07GSZ04X7FxM0O3d7DjMnltoSOGg4
KdWLBIaA8ND7DFbyzevJXon8k8LrZwCNZzoVeqgnvLvNqnb2tFaSwJFr+zKBupC/
hyAiybNkM+/aKgNVfT3XJ30iATE7fQ5WTtwpIej6o145DoFm0HGSi3FyQuO02Z1r
Uziu3Tm9ziokcALZO4Yt6BbEgC3QpUHIYIvox55hYnLNdPncOqTzYjU7c5UV5YK9
Ba+bDrCkI3OyDgW0AHmm6Cv6OeavWZjySwmivMQxREfjzo8TScuT4IkcgTTlHT4P
kw0zD6IKUJcYov0pmvUhI0mndv1u4RUjOyH5HYt3hckwMN5URa40Q7g6nIhFPJ96
zDUyspqs0OIc5i9x7pzq
=qNQn
-----END PGP SIGNATURE-----

--TnYVF1hk1c8rpHiF--
