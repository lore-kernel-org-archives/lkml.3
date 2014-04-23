Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaDWQ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:28:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54328 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaDWQ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:28:39 -0400
Date: Wed, 23 Apr 2014 11:26:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Balaji T K <balajitk@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Message-ID: <20140423162610.GN9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
 <20140421173203.GH22794@saruman.home>
 <53568B04.4050703@ti.com>
 <20140422154858.GN5524@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8CNmCRe8Sh4keFKJ"
Content-Disposition: inline
In-Reply-To: <20140422154858.GN5524@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8CNmCRe8Sh4keFKJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 10:48:58AM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Apr 22, 2014 at 09:00:12PM +0530, Balaji T K wrote:
> > On Monday 21 April 2014 11:02 PM, Felipe Balbi wrote:
> > >Hi,
> > >
> > >On Wed, Mar 26, 2014 at 07:04:45PM -0500, Felipe Balbi wrote:
> > >>this series lets us access the newer registers introduced
> > >>back in OMAP4 which give us some valid information about
> > >>the OMAP HSMMC IP like max block size, support for ADMA,
> > >>support for Retention.
> > >>
> > >>Right now, only setting max_blk_size correctly as supporting
> > >>ADMA and Retention will take a lot of work.
> > >>
> > >>Tested on OMAP5 uEVM.
> > >>
> > >>Felipe Balbi (5):
> > >>   mmc: host: omap_hsmmc: pass host as an argument
> > >>   mmc: host: omap_hsmmc: add reg_offset field
> > >>   mmc: host: omap_hsmmc: introduce new accessor functions
> > >>   mmc: host: omap_hsmmc: switch over to new accessors
> > >>   mmc: host: omap_hsmmc: set max_blk_size correctly
> >=20
> > Got mislead by your reply to this series, about the alternative way of
> > reading memory size from CAPA register
>=20
> sure, we can do that if you prefer, I just felt I wouldn't touch
> platforms I can't really test :-s

any comments ? do you prefer to change max_blk_size to read CAPA for the
other platforms ?

--=20
balbi

--8CNmCRe8Sh4keFKJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV+miAAoJEIaOsuA1yqRET+wP/AmQYScW/zn0HinZ7uF86++Z
KpC/pwSzyEibPwqx0g9hsfxhUpymgOJmcyDUewsgmn787OUBzjYrpkDpTsuI6OUt
lbD63c05tXe36peffjLaUPiZeNr0eiXtCLKgVTrywvNNWh1SQ9nuBN1dV5JifZAR
+ORRJWPRvU7qRHhHcsaKxHqFUuqaDfDIAr5cjV7rSzJXfsI07pha7l5HrAxKqVYx
kg+F4K2uNL1bPYzcC1YwfQ0czFPJKH7/fBaJNiHsE4U9zn4jJUh1o5d6ekHYwDkl
gKUv0wgBNO703I9Rec/TPL3VQ3c47yaX82hFkZVMIQgL2fkRqxmYWmUaQbrSVQeW
ONQy4O8MNs7YDlH7Tr0i4Vz/PdHK+SOquOv/WmWmlA4ebENYhJeJv3zDP51lptoc
ySsdqz54BZ8cGGo5EN5cFjVKVng1tBd8QLGuziZka9PwWKqihDM+KxNpvIJVg/f7
rWup0K0ImUG517UNRc9KEvoD8Zqz063dd8D4iXSVtZjwM2XlrU6xB9uf+8uFmReU
VNmAy/cKjaX+1wl8n4q1LUQBv+IPgBKqjBJgbivLVXDQogILLuGlxRKrjXc26SpI
2rajmx5Xo2cVm3C3CnIUXJt0L8Sno7p/d80ykphLI70M03k5nfUAQd7+04zmajNw
l1zEo10Bb0M4q42gPS6Y
=GxRN
-----END PGP SIGNATURE-----

--8CNmCRe8Sh4keFKJ--
