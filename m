Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3JMSDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:03:49 -0400
Received: from sauhun.de ([89.238.76.85]:45044 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab3JMSDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:03:47 -0400
Date: Sun, 13 Oct 2013 20:03:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-core: fix paranthesis coding style issue in
 i2c-core.c
Message-ID: <20131013180343.GA5713@katana>
References: <525ADEC0.7020908@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <525ADEC0.7020908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2013 at 11:26:16PM +0530, RAGHAVENDRA GANIGA wrote:
> From 46aed97f5e5a434e8ec24c14e085a138958ba559 Mon Sep 17 00:00:00 2001
> From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
> Date: Sun, 13 Oct 2013 19:13:46 +0530
> Subject: [PATCH] i2c: i2c-core: fix paranthesis coding style issue in
>  i2c-core.c
>=20
> This is a patch to the i2c-core.c file that fixes the paranthesis
> warning found by the checkpatch.pl tool
>=20
> Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>

You fixed the warning but not the error?

If you fix the split strings, too, I will apply the patch. I am not
applying one single checkpatch cleanup when there are enough others
left.


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSWuB/AAoJEBQN5MwUoCm2J1cQALNibc+HYk/VqjWq2vtjs6u5
i4rSUIUCSBevv7tXBOF0bcDi8Bi3lismw0Z3XgHc8tCmLdFp2iWVA2fqvCw7AnfU
SwaUViscjFiQR6R5+uHiOzstYjEKzmGs2CpqpQ3NdFGtrEByzeuzu+XRZhm1ofh1
WpQAutYrYCM4fobAkIp7H/THO52v3OM135BOl/FS/3RaRnTU7ed4DthnjfCogxwk
3ywTGIg9jOB+ujM61PRSRcu1vfEt68sqPyx2baoTwivIRcKArIJVTul7tV7Lp3Js
wxb3wWNbJLBQf9V6UoyotloermBfdvtEqpOjNxW2gLRFd0Xkg1+nMwbrenj9VfPp
p1Bs4NYkVQCjVvNGyKbKYi3NoodmqmOBorv03Fuwz2sprvGz2XFxL5DtZxsgW2vA
S5hgc32WOig3Jq0rANdYFSK5G64lZ/PEdFPBd6wuGypVVPI/h5KHTHdLDUGZldGB
aSbWPxO+EZ/N0uMjaOBcmLpfteAgSvNxeCobGxGmwCRoj22gaKXPxWQWbakp3pix
2WAiLz+8bg43bBYpoSJkRg5rm3S8FnbB+9yVKKsyZB5dru5Oc9GEIgrf2+UB94bt
Udn+blDa/bm7guAsewtvZuGCgCZ2K9/2CIOkUMVRHoBtF5AUbCAEv0vU0aEXK+mt
udYlkXNhYBhyNvIqa44r
=Vj/J
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
