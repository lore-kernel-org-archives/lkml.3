Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaI0LUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 07:20:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45263 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI0LUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 07:20:39 -0400
Date: Sat, 27 Sep 2014 12:20:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Li.Xiubo@freescale.com, naushad@samsung.com
Message-ID: <20140927112019.GJ27755@sirena.org.uk>
References: <1411791475-27031-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ry3qE+viRNtbc3l7"
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


--Ry3qE+viRNtbc3l7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 09:47:55AM +0530, Pankaj Dubey wrote:
> If LOG_DEVICE is defined and map->dev is NULL it will lead to NULL
> pointer dereference. This patch fixes this issue by adding check for
> dev->NULL in all such places in regmap.c

This doesn't apply against current code since the same fix has already
been made.

--Ry3qE+viRNtbc3l7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJp1yAAoJECTWi3JdVIfQ/CgH/2a2RsXRTim5MLKQv/SnljIe
yb3PgeDzrU7Gwc0BJYM9hzpVSUn4ihtBm7J/C1ER9jkfUJKxnVZ+wHvMT//4qc22
9PRN3HxHRhdSg8mlqcS1txm7JjJ1ZooreoqEuj5ie/5iSiCGmNyIkkIDnlJgtp7+
V2smMCNDXhep43xM7K1LCcR/NnWoP5Q2p5pd9Hmt9W4NLGy2d9XFwvp+aEuGP9ZO
5rYS7OAUQ5YIjOv8zIv2S+fZsC8ahxe8MXqx4zXcFXcVIvOwn2bgfcvIsH4y+7WQ
tRAmsn9sBlxqBSkYlsHjxGMZ5ubqJI1RcYat3xF2K0pg/syUB1itU0Xjc84JaTw=
=rPTR
-----END PGP SIGNATURE-----

--Ry3qE+viRNtbc3l7--
