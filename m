Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3GPP6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:58:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43121 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3GPP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:58:11 -0400
Date: Tue, 16 Jul 2013 16:57:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de
Message-ID: <20130716155740.GO22506@sirena.org.uk>
References: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
 <1373978485-17496-1-git-send-email-jonas.jensen@gmail.com>
 <20130716131332.GL22506@sirena.org.uk>
 <CACmBeS3jU2csACZCqXfRvCYAEHaK7S3AcJ++Yd=L-mgfeqg68A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="djJN5oi3zFpblwUd"
Content-Disposition: inline
In-Reply-To: <CACmBeS3jU2csACZCqXfRvCYAEHaK7S3AcJ++Yd=L-mgfeqg68A@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] rtc: Add MOXA ART RTC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--djJN5oi3zFpblwUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 04:04:07PM +0200, Jonas Jensen wrote:
> On 16 July 2013 15:13, Mark Brown <broonie@kernel.org> wrote:
> > Since you're now using OF you should also be including a binding
> > document.

> The binding document already exist in set of patches adding MOXA ART
> SoC support ( I intend to mail out v4 once I know how to proceed ):

If that's the case then you need to point people at the binding document
when posting the driver but...

> Or should it be moved here to a new v4 patch?

...it's more normal to push the binding along with the driver.

--djJN5oi3zFpblwUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5W1xAAoJELSic+t+oim9pvkQAJm621nhvm5iIrKowo4FPlg3
FFznrvcrC0MIgwPJxk93aCWgofon90LnUopQ63Es/4idW8LYDUK1NiarxSVdFB1z
gDM9p95uxibpAkcWqjQKjqKbPpNgFU20MAxovH6ro0LY3jdQnajPVyHTyIZZ5tUs
HTfLiUrZzTqrx/qUeYL0T+9afJ6Ogz5pCqhYEQvDJIv9ODMyEDEVqtTh/IlVfZJJ
SA3Ugyw2/LNxqRNnCv4fsLu503WFy6KceZXqd6HOUH8bnzbTrUGhcFBNA5nLLx6a
KkNmaEvAtqDTKWXuUNAnmB4IPnIeGzpbsicP+xX3MpyiLCC1bs242L6eEAcGm6G/
f+qZgCF6ENO+AQ5sOwnjhVrs83OZ3RCiuvFFSn92WGUWRg4YDiAHjQRKXOIzTdPB
gNWgbVZ59UttGZtMAu4grnmMQes9FyTfag77FBj0arSQKgEC3XRvOyhCPvsUqFAT
CASg0L04nTaXa4pYhFHjWf1+2ChydnvUI2Bx0xlgIghdrZGsLTE0jEG4vslMLHJR
m/NBqteMVHTgu8gn4fDzcf+fSd0fWAiBGOVBE+6yVhSF16H5J5NQGG1R7pjU4D4W
+31Ao73XTm/gBUwLozOLWnOuGlFdeRrGgzNyR8FC8mXj+w+KTHWmEackzZwH2aiS
8u7BghvQiLZmWIyhuS4O
=4s5g
-----END PGP SIGNATURE-----

--djJN5oi3zFpblwUd--
