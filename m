Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaIQPea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:34:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42116 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbaIQPe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:34:28 -0400
Date: Wed, 17 Sep 2014 10:34:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the vfs tree
Message-ID: <20140917153400.GA8140@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140917161658.2e4eb3f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20140917161658.2e4eb3f1@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 04:16:58PM +1000, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/gadget/function/f_fs.c between commit 8322215aa91c ("f_fs:

I can't find this commit on linux-usb. In fact, googling for it the only
reference I find to that commit is this very thread. I would strong
suggest that it be removed from the tree as it, apparently, went in
without any review. Sure, it's a simple change, but it needs to be
reviewed and needs to be sent to proper maintainers.

Unless I'm missing something, of course, but I could not find any other
references to this commit.

Al, was this commit sent to any mailing list ?

cheers

--=20
balbi

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGannAAoJEIaOsuA1yqREYEcP/1Brn0hWk/ThZsjQ1KXH2q+3
uWZkbhf43dYwzUAppWb0mlWl+Y1HmDSB37CQ/ov3C4ptxf7IpoXD2NkWOC/fMOjw
CiOsiW6Te9K7QHiyUzYwGCCcuEuzTcICLpJKmJFktNq2JH2dTs5YPabFfAaxEVPN
VojuJBL2PZ/fLq5irVf0nV8O46PKJCgFKCzW/AAAWMPV9enWU+I2iIjSzFBE4Car
Naj8NlloVRJq8ixI2iwqUZEANRVvw7ZojJcVev/6mVti+x07SvChRps984hwza2h
n5KGTj2L+9099Oe9ZzPOceZ1No5r16gFbkdFNeDjEfu64S18TomcLq//q6nWBfX2
tWdpzJWYyp2NCBurWEwmKjuGCt1q76aRqWB+t7sCqlC94tapr20tmxmcH/RrZ4Ja
PVQfm08xD9Ho0/zG4WQnXlnBirO/h9U5Zqvr3OD/PlAklmH3DhBtjMMM75beSfk0
vLSp/nWOx+/PoAVcBPMS4J7R0TA2KXxVwu9RlikOSev4MXo1Aj+wGCa2YkTGKdZA
dQCHmT4YxtOHV1n27oDD8Gy/zgA9UtYPQMXi8BHQF5yWyAkV3K6qeK5fErRBD9Vn
R+KD1R4WLpBiJUa+0DiYbbr0C0PSpQtQltPnBTY6qygKVk37/kHhFCaB/6rKd8ZU
j1Rsg/x/kgzO9U8RKuc5
=NL5U
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
