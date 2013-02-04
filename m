Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3BDKUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:20:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43643 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab3BDKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:20:29 -0500
Date: Mon, 4 Feb 2013 10:20:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regmap: Include <linux/sched.h> header
Message-ID: <20130204102026.GD4720@opensource.wolfsonmicro.com>
References: <1359935343-30558-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <1359935343-30558-1-git-send-email-festevam@gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2013 at 09:49:03PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> commit 0e8c0234b2 (regmap: Add asynchronous I/O support) introduced the=
=20
> following build error:

Already fixed.

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD4tgAAoJELSic+t+oim9560P/2jScbJktT3qVdLN3Si03553
QsBHgFPqmspfUwTR8I6uPg0Fq4iAWIkQptiCiaCwzZ7/Zfwg+bv6p0rFeVJriynj
FVa1teHIDHlLabAYhw/tRTqxy/dtzaSEz4TcWINd4Jvwl7xnm/ls7VITvMlwe3uT
dQYKkw/c6WZMQhtMQyDr5gRHP0RdB5wUmTPmdirWsY79pQkztkcyDIiHGTnZeMMz
1wDCmbMBfGyNeftogydfWFYDtVaUy33Yt+mK8rWC3HhktnrrUY5APbgAxI3FSRFj
d6kELwwrQskgotbVZt2gpU/DwfsZPqJnUGN6iDtFxoX9wqnVDooScxqR6aQnLLFd
5G7agagQDDcJKwz9PHEKV0Knizk9RgeUdIflf3Oue7vIMC1HCx08jqCp9+EKAtmL
RXCrdRC8idBywWsXI6c04heNlpao/rLHFKHwXJEH/Gw8nyxi+odl9lDutNEv7W2d
NVu9KrxhBHEkAp4Xvjsq/ONUwLSrhNEeldEMlbzk7myTxHaJuAWopG7JDi4IsJw+
2N6HhIXv8T4cCJaMKB9YhgtChNmgucdWmqhmSsyDQPDgxChyyX6aOWLe1m5h65Fa
X2zOrJ33ilGV5+qLMtZQbvhDFVGupHylYPq2hwT1ieb589pb9YqkGTvgovu5On3r
vWHhQXCo2YRr7P1rQ6pl
=EiGZ
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
