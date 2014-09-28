Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaI1Kqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:46:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50201 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaI1Kq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:46:28 -0400
Date: Sun, 28 Sep 2014 11:45:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140928104557.GQ27755@sirena.org.uk>
References: <1411875325-19293-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOr5JpMIiGv/Oaxu"
Content-Disposition: inline
In-Reply-To: <1411875325-19293-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: debugfs: fix possbile NULL pointer dereference
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zOr5JpMIiGv/Oaxu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 28, 2014 at 11:35:25AM +0800, Xiubo Li wrote:
> If 'map->dev' is NULL and there will lead dev_name() to be NULL pointer
> dereference. So before dev_name(), we need to have check of the map->dev
> pionter.

Applied, thanks.

--zOr5JpMIiGv/Oaxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ+bkAAoJECTWi3JdVIfQOQMH/0aVPr6YJOZ9pbUwEM9ZTQCD
uv2FH6gQ4EiZoSj8cqVGLYgLYiR5gJtxWV1W9FPkJPAjsMA8YKKP1jHjXd3gKTf+
T4JxvklERNcJEl0nIAo6tN8KN+tmhFzt7wPHliQmoI8XAwthrr/HKYbvNUF2zfCj
lT/sNSeGTHk9uo/yZJa9G1NrULTQpGSZ4pAzPqWhNeuT6XewOtP7wlBQi5ZK4Hsm
fbBhxxAgwAJtv4us7kgksuS0dYVenzSkVb4/jv6Fz+ThRi5CQIIcIpuPu7vQODAW
52PTqVpWlwLRC5lIy2CRI03KSnGp7n9mCJztpK9h8OoDntScT85GkQo8gJcCHJM=
=o9Gk
-----END PGP SIGNATURE-----

--zOr5JpMIiGv/Oaxu--
