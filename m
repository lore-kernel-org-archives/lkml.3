Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaIBLvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:51:14 -0400
Received: from sauhun.de ([89.238.76.85]:54147 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaIBLvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:51:12 -0400
Date: Tue, 2 Sep 2014 13:51:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Trickle charging for rtc-bq32k
Message-ID: <20140902115119.GG1266@katana>
References: <20140822131150.GA26724@amd>
 <20140822142852.GA1545@katana>
 <20140822143853.GA28820@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Content-Disposition: inline
In-Reply-To: <20140822143853.GA28820@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Do you have example how to acces of_ from i2c driver?
>=20
> Platform drivers do:
>=20
>         if (pdev->dev.of_node) {

As I said, this is basically the same. Just use the node from the
client's device. Nothing special here.


--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBa83AAoJEBQN5MwUoCm2mL4QALWt1oJmwN+i0IlvBLBtueza
ulnmP4+ErZc/gdXwDru9LM1DNAw3/kv/addoWLJEi7ffHOJ4EBzN/aZ/fWD2wmae
fcqeMm+8t5yfmUvwhDH4WMcfPMNqSuckkyrefISeoMxJYliHRuy6Za6PN7pidCf3
ZJSYnv7cSAZZ7m5NrrQ4qFBJjVPAcrFFvNGGIL9t7HoaCvRo3XRsLgmE6v7zSExt
EkFurjLspv4tsgj43Y4DxDNbFrk/ICBeBFQluJV4NlAT5aO9zjeNpY7bM7TF78GI
ulFHNoM7kxSGvt3FM2W6RL4QXxhYxybGOyKurUdVRaWpzK7vvUZ8XE+Dx5XFDZzt
9GAjN9hENn/RBG993QiQD/zQz1EYEAeIfTf9ZiW1jj+p8MX/2OEMz8ryyxODNKZi
9l9wNrn4DUhbRwWAmNBm7T1z+xRBSIMRJDAZ1s5ywgzbcNhLKc4Kkq6yKnodiFb5
ye6r1uoUVNPrVow/CMaJRzEZ1EUip4ig1POO+1JVYEIGeDAbM4PtjrPvUA+KmLW3
FL3GMZ9lhKaZvCSocoO40i00/lWjFaQfrhvT9Yk+uIsSLN/jnU/crTEBi/DMwqBd
27lfYYiM8rwaGaM3FsFnYpQa/LsF5L8iJFKt2tdiGHtpe4rixvrF/5JS2Pxtnn+g
R3y+ZdBQlCoa48sDhIdO
=1co6
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
