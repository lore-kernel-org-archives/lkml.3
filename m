Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaKEXqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:46:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:38805 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKEXqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:46:03 -0500
Date: Thu, 6 Nov 2014 00:45:56 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141105234555.GA7097@earth.universe>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20141105220359.GA32052@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 05, 2014 at 11:03:59PM +0100, Pavel Machek wrote:
> > Maybe you need to enable modem?
> >=20
> > This is n900 init sequence from script: nokia-n900-configs.sh
>=20
> From the dts, it looks like this should somehow work without this.

Right :) The n900-modem driver will take care of this if the "pm"
parameter is set to 1 (which should be the default).

> I can try but.. is it safe? I'm using DT-based config, and interrupt
> numbers definitely changed. If GPIO numbers changed, it will not be
> funny.

Can you provide the output from dmesg?

-- Sebastian

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUWrazAAoJENju1/PIO/qaIz8P/AjvTCrHDwrRhLWaQY7fPsVF
OYph4g8z5P2JEmB7AMCW1pG53di1AKAGGPGLzIgIitDH3n4t67LmHCrpyjwR/eGS
cU0JJUQfgVXy27pZ7inAbHLN9hXi+sIvaz/NeeWek+5jEF2WO66YHh7fJ+GzymLS
5vq/+e+MhJKD1OkGJt9NTGpBwU/peYQCKa4BxZdbyy4wXODMHtTWC5Q9DFoYlNaw
+e2B/eaNajCiIt9HiHmQbar7GyYGi8fd7OAmzIgOvhlqW/VhuI4M5zootXJpGIHe
87cJ/gxYgLOIHA753tsRCSjhTmnhjQEBSC7YzLygGTMXSOg0Aip48u6xVj81z+OC
CvucQo6feQLyqeFEsVCMX6mIeCfD7JQv2I/kdYPREfAjwhrMWD+gy7K2WofXKESH
nz8pSmfQEhPsx/6Wi6drN470j9xUzIdF+CHGEkgVpNcYY2NuZYu6T/rjgUqy1gio
ZVaYby8ZGo/E9LWvVqxwSHgLXuxD2DsOOgmW57Qz9nkp57aWF49bSWn+BUx6ZyaU
8U4OXLqljLvfHpRm6dUlzv3PdPL76JyckICe67RfwIZ1Fla8FzdeimlsijljUstJ
5KFvhWauzyvPrQPoc5BGipqbzciYz5lu3pNRkc2OGiXboetdYKlWhzAUCKkTxVE5
mu7ok3+DRzML4h3jFbf3
=bkA8
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
