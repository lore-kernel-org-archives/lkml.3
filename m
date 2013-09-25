Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3IYMz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:55:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45079 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab3IYMzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:55:25 -0400
Date: Wed, 25 Sep 2013 07:54:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Luca Coelho <luca@coelho.fi>
CC: Felipe Balbi <balbi@ti.com>, <ben@decadent.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH] ti-connectivity: add wl1251 firmware and license
Message-ID: <20130925125458.GD10746@radagast>
Reply-To: <balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
 <1380107096.4503.8.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
In-Reply-To: <1380107096.4503.8.camel@porter.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 25, 2013 at 02:04:56PM +0300, Luca Coelho wrote:
> Hi dude,
>=20
> Great, this is cool! Finally! :)
>=20
> A few comments...
>=20
>=20
> On Tue, 2013-09-24 at 09:44 -0500, Felipe Balbi wrote:
> > It's way overdue that we send these firmware
> > blobs upstream. Thanks for everybody involved
> > in getting this sorted out.
> >=20
> > Cc: Luciano Coelho <luca@coelho.fi>
> > Cc: Pavel Machek <pavel@denx.de>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
>=20
> The commit message could be a bit more descriptive rather than
> narrative?

sure, why not.

> >  ti-connectivity/license-wl1251.txt |  59 +++++++++++++++++++++++++++++=
++++++++
>=20
> The license file should be in the root, together with the other licenses
> and called LICENCE.wl1251 (note the en-GB spelling).  Also, this license
> is *very* similar to the one for WiLink6/7/8 (LICENCE.ti-connectivity),
> except for some very minor things and the formatting.  Couldn't the same
> one be used, for the sake of simplicity and consistency?

let me check.

> >  ti-connectivity/wl1251-fw.bin      | Bin 0 -> 194180 bytes
> >  ti-connectivity/wl1251-nvs.bin     | Bin 0 -> 752 bytes
> >  3 files changed, 59 insertions(+)
> >  create mode 100644 ti-connectivity/license-wl1251.txt
> >  create mode 100644 ti-connectivity/wl1251-fw.bin
> >  create mode 100644 ti-connectivity/wl1251-nvs.bin
>=20
> When sending big binary blobs, it's generally better to send pull
> requests instead of patches.  If you add the -p option when calling git
> pull-request, the text will include all the readable parts but will omit
> the binary stuff.

will do

> Thank you very much for following up on this!

np.

--=20
balbi

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQt0iAAoJEIaOsuA1yqRE4SYP/24L3foBvPueJtoXVOPKV0yG
DQVyf7Zi/jUNs89sCfrHb/fi3WHOYSU4UJ1nNfnBRm+CN6deedfkgUym1IRw27bo
AtvyYYmYDzYFoH8T/VrMrazlunpkov1ICr+nav2OOhEZ9byYWoTsUt0hdlOROQAK
f/sBxkEB+NDJbSnS/xOgHjie1MKYkpt4w36Z1n6dsQnZoA2ZWSi2fAq6+CTtz1fD
LQc+dHeiHeYVcxFmlr+bqurCDCS6XWHAkUrJBpMwEmz5z4rzVL9oBANwuANUoiT+
QxF0626Hp/Xo6O9nU9rgD3ES61iKvoA+QW+WGxXAw+mvuDq4L/AR0hiA/nnbsxOa
Qdrh9WhANehklrO+FH2E2SmuJnRSOUm/xZvvAQlJeWF9hHTy4DAYh9Itge9TFPto
oVXxQhPsSGmqE65qDz482YMp9j3Dhws40T2jXcUu7RmFVqduZ6mdvPxo5UybtvrF
/VXL2aZiYgSYW1h9TOm653bnUgEtO0Dgdbw9vsGVTIJ58N5gIR/E05Wg2JJulub/
qZ2Qz1LXpbUwrvxNss9MvTiJiqChLJhfm7dQdzKDQHkWUdi2Zk4etKl+8eHtB3cN
WMLWOXMrDJTLkEHkxDFCgNz911OodCYe0ff3O/tXMHKsxfJS8A0Gu/JcqTYTjGbw
ur/sIeqS3a7+08ORStFj
=ezvl
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
