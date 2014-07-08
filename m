Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaGHHze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:55:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbaGHHzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:55:33 -0400
Date: Tue, 8 Jul 2014 09:51:06 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] ARM: at91/dt: sama5d3: define mpddr clock and ramc
 clocks
Message-ID: <20140708075105.GI13423@lukather>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404746355-19988-4-git-send-email-alexandre.belloni@free-electrons.com>
 <20140707183236.GF9558@ns203013.ovh.net>
 <20140707195556.GI3113@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YhFoJY/gx7awiIuK"
Content-Disposition: inline
In-Reply-To: <20140707195556.GI3113@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YhFoJY/gx7awiIuK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 07, 2014 at 09:55:56PM +0200, Alexandre Belloni wrote:
> On 07/07/2014 at 20:32:36 +0200, Jean-Christophe PLAGNIOL-VILLARD wrote :
> > > -				compatible =3D "atmel,at91sam9g45-ddramc";
> > > +				compatible =3D "atmel,sama5d3-mpddramc", "atmel,at91sam9g45-ddra=
mc";
> > the sama5 ddr controler is not back compitble with 9g45 one the compati=
ble is
> > wrong
>=20
> Keeping atmel,at91sam9g45-ddramc allows to reuse the old code for the
> iomap needed for the PM code without adding a new compatible in the
> ramc_ids[] array.

That looks like a pretty bad argument :)

If the two devices are not alike, they should have a different
compatible, it's as simple as that, and Linux should just deal with
it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--YhFoJY/gx7awiIuK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu6LpAAoJEBx+YmzsjxAgnWQQAIPPLHL9ICn1GsIoiieANjPY
alw0a9GIwamf52RBe6jeHsoEECbRnh9DNJiSehjsj+ynAmjei43pcCcj7gI1RPtb
mgDJj6+h1W3d06kIY5A5IqcLMta+1aYDAloCN30AdPtZ6oYuJ0xyUMtub7DD6I5z
3RHFe9wytsr++vDFrDrgpgoBjSO/aaTt2zVxazPG6iPUQssXu1GOknd5GVQ8MZjt
061M5k4QZYHeojSCF7kxkAoeoXAdJT4DXdDe+NNoRWhFFYN0oGRRBT0AI5MJlU13
eAq0hDfNE42LIljXJ73GH9txnAA0IJY8T5abZnIjNI4m9UDKmucRGF9a1ABP2BkV
a/AER6/VtsIWtHTB0R6rLASCCQHqobf7rSPwYq4mWLeWuAMEoOGAT0qpG7Cp4OA7
3QBadh9M5pD+w8siLraI+EgTPKUrrO/srrz5kvP3UVN/r92lzKEQE3488jeecMv+
qZNUK2gj5Z6dE8UGxekxfrHiuZPenTqLCy+5sSQ1C6/BDcFThG7NDHmfZWcXrgOW
l2fSL1xKe2vjWvkcagWo9vTw8lRxHA7m4hONv2xTKxIteMpwiOg5xZlwnxRDMLXO
dSI+p2xKSYo9Pvehyh6SBQbcBWWV+Lq16gsqgXDphX8Aq2zOQXA750JeUbkzKjvh
F/gMCo/WKNQ2AKXPObEI
=djgG
-----END PGP SIGNATURE-----

--YhFoJY/gx7awiIuK--
