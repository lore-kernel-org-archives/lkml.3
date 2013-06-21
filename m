Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422681Ab3FUAQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:16:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35832 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161284Ab3FUAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:16:03 -0400
Date: Fri, 21 Jun 2013 10:16:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Bryan Wu <cooloney@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: build failure after merge of the leds tree
Message-Id: <20130621101600.e9cff446d5f6e21c3e8599c8@canb.auug.org.au>
In-Reply-To: <1371450391.658890225@f333.mail.ru>
References: <20130617152908.1b9c999c01f18262a387dc91@canb.auug.org.au>
	<1371450391.658890225@f333.mail.ru>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_10_16_00_+1000_1PsVv/KduT4oQb6="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_10_16_00_+1000_1PsVv/KduT4oQb6=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

On Mon, 17 Jun 2013 10:26:31 +0400 Alexander Shiyan <shc_work@mail.ru> wrot=
e:
>
> > After merging the leds tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/leds/leds-mc13783.c: In function 'mc13xxx_led_probe':
> > drivers/leds/leds-mc13783.c:280:4: error: implicit declaration of funct=
ion 'of_get_next_child' [-Werror=3Dimplicit-function-declaration]
> >     child =3D of_get_next_child(parent, child);
> >     ^
> >=20
> > Caused by commit 2ca3a455432f ("leds: leds-mc13783: Add devicetree supp=
ort").  of_get_next_child() is only defined if CONFIG_OF is set.
> >=20
> > I have used the version of the leds tree from next-20130607 for today.
>=20
> The patch has already been sent by me.
> http://www.spinics.net/lists/linux-leds/msg00994.html

I anything happening about this?  That patch would need to go into the
leds tree (with acks from devicetree people - Grant cc'd).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Jun_2013_10_16_00_+1000_1PsVv/KduT4oQb6=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw5tAAAoJEECxmPOUX5FEzrMQAKFsG8JugeLB3KatTJTVtfA9
rN2zRmGiaEWIVNgDYCMnG04QO+V88LvBBjHK1wl4s3Wgt+T7BmS/9G7ciTT/Qkvx
7rE/x9j8v+Om1NPccpAer5Z+V+LkFZt91Wg9K+heuRf1eU10bAtBl3aZE053JhQq
CC7dS85Gn9z6LPitbdwvzAwkNzBj7sGPCb0AOrmUWspibKEq+b/xpxEYnnNG3eN/
xsRHMpj+bMs7qSd78kmWf1uyBh4BdUi7hwlFPQbxuyFl9hCJraXk/fMphkmI2ILJ
wgJuV4LzUgVvNWqtrwzojRK5z6T2zw+vBhdYqQPJRh8nocH5uCaG69L6wbgCleuQ
yTEZXwvZYRRhHHE5cHylDfwu2ZyaxvJy3a99PJ9obyv1KmEXQzBErW9pQdtzFx0d
16lpZz/707RSwneARI7/EY82Cmw8iEbge5UCGV3AGhbZu41750fJpnYJDE5QuphF
mI458RNPrcYceugq7Y6DLau+rWcTrP+PjM6jrpBobC1dYjChpVuYYpyOu71jJqu5
3Dbbl/BpILCZhXX2WYoXkRJA416mY5AHD8Ner0NaraF201B8rmoSPdBW2cUvllaV
yrZL3WSi+/4PYmWZ6hJVvKF8FPbErftKPi3o6cb+sf0ZaKwF30DazaDSAtYLMsOT
MKQgjfhbjFpjod4qk6Hz
=t4hW
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_10_16_00_+1000_1PsVv/KduT4oQb6=--
