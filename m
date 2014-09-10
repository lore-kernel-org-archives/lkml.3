Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaIJKzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:55:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60804 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaIJKzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:55:11 -0400
Date: Wed, 10 Sep 2014 11:54:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140910105458.GA7960@sirena.org.uk>
References: <20140908183350.5a4e357c@canb.auug.org.au>
 <20140909223952.GL2601@sirena.org.uk>
 <540FB86C.6010900@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <540FB86C.6010900@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the regulator tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 10:33:16AM +0800, Chris Zhong wrote:

> Yes, I have modified the rk808.h, so rk808-regulator.c lacks some structure
> now.
> Please help me review the patch "[PATCH v10 3/3] regulator: RK808: Remove
> pdata from the regulator"
> It contains the corresponding changes.

...which you sent to me overnight.  It's applied now so -next should be
fine tomorrow, thanks.

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEC4BAAoJECTWi3JdVIfQSIAH/0XpL8B5TWX1HbRMsvnM2sJb
GNnyVspL/SZsUio6/R3eChHlr3S34+J8Db3xSTQvYbjsODbq2rdi+kXGAvRz++QH
5l/wwxfx//ba0DEhDJTKLFjjAXlxya4xrqu+ZOqb6qUYNcp0p7x8u85iBvMEx/GY
z3AzCYvnbD3GlK7vCwXwsLRfimKZh3VP6vn51K/6CsmsyC3O+/Aw7f1QN5+RxxB2
MlH2rR1Pvr8AJ5+phhpNAczzLx08DtxqYcdAU0b50nYqI9R3swaQhSmGBx2MzuPU
cdX0avZG3bshVMFld0EgmnkjAwSXAYsxTAAS55qd5IKF6c1AO2aCNJkYJ32txOw=
=HwkY
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
