Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaI0LWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 07:22:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45270 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaI0LWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 07:22:03 -0400
Date: Sat, 27 Sep 2014 12:21:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Li.Xiubo@freescale.com, naushad@samsung.com
Message-ID: <20140927112144.GK27755@sirena.org.uk>
References: <1411791475-27031-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hm39DdI+xc+0zcX9"
Content-Disposition: inline
In-Reply-To: <1411791475-27031-1-git-send-email-pankaj.dubey@samsung.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: fix NULL pointer dereference in
 _regmap_write/read
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hm39DdI+xc+0zcX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 09:47:55AM +0530, Pankaj Dubey wrote:
> If LOG_DEVICE is defined and map->dev is NULL it will lead to NULL
> pointer dereference. This patch fixes this issue by adding check for
> dev->NULL in all such places in regmap.c

Oops, sorry - actually it hadn't, git generated a confusing warning
which caused me to try to apply twice.

--hm39DdI+xc+0zcX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJp3HAAoJECTWi3JdVIfQqjoH/2bDf6qN9alqdYwWHhqp6GNu
rtO/DlCc9Az5gcaFqAEB5WZIZSvPtQOcu1ufesxfpMaUhPN9x+akfpsg2Jz5sFpk
4mXwUhbRDEtx+pQ22v4oYweYx+zwY7QRpt88kt9ez5XUQYZqNqcR92MuoNSUyERN
6acQtPzvAHblu1wVOsdYYW25pdd0Wc6pA2qxHfhnCbLxKxvXjSGn3/9kRuIRmb7G
RV0P9ZEnzJy8QpYChaxOK8JveFybCL+VuJZprFpBTiNgtn+wAdrjBHdnHfX1hIsv
zzM4sC/ce6QEokG06PoN/Tr+Bs8gcE+AEpCohJfsOqi9m7aRrk5pxpYPvGwZHUY=
=um/r
-----END PGP SIGNATURE-----

--hm39DdI+xc+0zcX9--
