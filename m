Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaEEWlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:41:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:55290 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775AbaEEWlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:41:49 -0400
Date: Tue, 6 May 2014 00:41:44 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 00/14] OMAP SSI driver / N900 modem support
Message-ID: <20140505224143.GB6261@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <20140505193129.GC25949@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20140505193129.GC25949@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 12:31:30PM -0700, Tony Lindgren wrote:
> * Sebastian Reichel <sre@kernel.org> [140328 17:36]:
> > Please send feedback (e.g. Tested-By or Reviewed-By :)), so that I can
> > send a pull request for 3.16. You can either apply this patchset or
> > use the n900-modem-support branch available on [1].
>=20
> Sebastian, can you please do a separate pull request for the .dts
> changes for me once the driver changes are pulled? Otherwise we
> will be creating pointless merge conflicts.

That was my intention from the beginning. I only added those patches
here to make reviewing the other patches easier.

I'm still missing a reviewed by for the most important patches (ssi
driver, modem protocol driver), though. Can somebody at least test
the patches and provide a Tested-By?

-- Sebastian

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTaBOnAAoJENju1/PIO/qaxgIQAJWby+pGWyAjQqTTTjQHwavW
3zN0ce5kBeKkxdfFurz/zPxxbZ7FNXd9TdbVEQJuTz/4CkPpxX6jyMYoSdATj/sh
ZIhqfUlzg2fUz4ozKpT0hGIaVHJ9SDJ0HD9Cm1P+5GfelpuqNZ2pjMVyVyywYLtw
kFAvd+BrwPHmou6Dx6p+6jYsjjPS6NXN6r14pkO3bXsD4HhI7oFuKUHiQGEtUJqw
jIt92AE/QfsMojfueKyCI130d1nCKyguJLGonpNXMUzrViW8Y68fPRrkjUjPFTjM
uUmQldOZyUolmVp8b3wpbfRoDlmpqD7z0XD0oLA+aG4l8bPPoOXLj4zPqrdxAjwT
3bUBUI8I2nAzfeGZR38HSCIxB3En7RHcCAVh3sIagUpQoWQ9I4vnJk8JjZeCV7EV
FSr5bCQ7JzC3Cq5PMlKCY1+1sigMyeWkunEq0BcqsQFLqh8px7iTQrJKfojK+uuu
48lwcyhFs10HFtfwP2e+EJjFcwSPuItqJLmwzBEtEy48kkP6Y9GHh7c09MKmBpZm
/R1oRUNBpknLIjRmfCXWmQWyQ5JqqNAX9eqJJ1yTk9dgGMrdvkBOkzeb1zErUiau
9R8EJIJo2LnZScIJzAn/D1AYNkVolb1iPQmuZI9c+xN0Pcw7N7S03zCkWAnkAAOV
f9RPaZdqBteQrrBRSsV9
=eAOQ
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
