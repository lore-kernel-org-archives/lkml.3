Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaKQIOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:14:48 -0500
Received: from ozlabs.org ([103.22.144.67]:43402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaKQIOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:14:47 -0500
Date: Mon, 17 Nov 2014 19:14:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jk@ozlabs.org>
Subject: linux-next: build failure after merge of the ipmi tree
Message-ID: <20141117191440.621b3d3e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/P/3LEmAa_dNub62_+vxWUvD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/P/3LEmAa_dNub62_+vxWUvD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Corey,

After merging the ipmi tree, today's linux-next build (powerpc
allyesconfig) failed like this:

make[3]: *** No rule to make target `drivers/char/ipmi/ipmi_powernv.o', nee=
ded by `drivers/char/ipmi/built-in.o'.

Caused by commit e6d873424d62 ("drivers/char/ipmi: Add powernv IPMI
driver").  Presumable a forgotten "git add" for the new file ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/P/3LEmAa_dNub62_+vxWUvD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaa50AAoJEMDTa8Ir7ZwVwgMP/RxY9wYnDtWsRJV7orBls/Yq
hbJaamaE+bH2nN5ZD3xGC4DB0mO5KKMABI00N23xzjMpVYcw6r2PyltlVlLNBuAz
NZuC5TdRaqIljoAf443/8hdyuntkoLtsfXHDNfYvYouAPX0v4PE3rRcCTBG+mJYp
724fAZOpEUG2QEcJj1T6zJJK1hZ3zB4MSjDLtwyqpWr40M+S/UPSDKlBwJQcfvem
RsU5/gG1JgwqBR50/2wyRQh9Hzdn/gmilpCcuiO0lL2MAhpYZY1ZkiuDjMmxkWAl
jzx+Wqs8KZEkVJzI3YhbLfi8QeupsWQYxpNuOLujbtulY2VIi4HssYLIQK6RfS7g
Sw7wgG/C+tIGNhcig8acfr0DM5fIPnahAifELI+T3bSVtf+s49aVPsx/u+zyDXn8
+fAzM7/tPAajzNj5R58zezqJimMJ/dLMpgEr43t8kEb1MTOJsp06MdThZUaKN5/H
aUfZw5Ci8I2hcHQfk8H236FT10ebjdMzROoYVhAIBY+W4RQPbLonc7G2WYlw+qo9
uTfW1tzVfApm4cOCGd2Z9qekn88EUppGQXQxIFHxoaul0bi6n9HqBQsA8Bt9UcHA
x1C+f6OgKoKxkZrDOlfyWPXutcN0b0iIBAj8C6MP9hjYxghd1yfDHc1CxK8klcPb
SclIDo0ZRY+hTDIcTn8t
=Wc3n
-----END PGP SIGNATURE-----

--Sig_/P/3LEmAa_dNub62_+vxWUvD--
