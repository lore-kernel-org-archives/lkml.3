Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaB0CnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:43:10 -0500
Received: from ozlabs.org ([203.10.76.45]:39725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbaB0CnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:43:09 -0500
Date: Thu, 27 Feb 2014 13:43:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: select CONFIG_TTY for use of tty in unconditional
 keyboard driver
Message-Id: <20140227134302.99d5bbeb0918b745b0953ee6@canb.auug.org.au>
In-Reply-To: <20140227021305.GA23659@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
	<20140226100234.GA23064@thin>
	<20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
	<20140226231916.GB17589@jtriplet-mobl1>
	<20140227104211.b2a4a5a1066fcf8ac2640ce3@canb.auug.org.au>
	<20140227021305.GA23659@thin>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_13_43_02_+1100_9iAAkX6gxm5YGDMV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_13_43_02_+1100_9iAAkX6gxm5YGDMV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Wed, 26 Feb 2014 18:13:06 -0800 Josh Triplett <josh@joshtriplett.org> wr=
ote:
>
> The unconditionally built keyboard driver, drivers/s390/char/keyboard.c,
> requires CONFIG_TTY, so select it from CONFIG_S390 to prevent a build
> error.
>=20
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Will be added to linux-next today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Feb_2014_13_43_02_+1100_9iAAkX6gxm5YGDMV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDqY6AAoJEMDTa8Ir7ZwV9EsP/j00xuBfRY0Spi6UjpZlg/qW
/x6eRVEvIvWc9I+c2qLygIPG8mtJ+9h6jucSrJJ1TGR5uma7ks9vBlGF4975Nd9r
zJhZnYO50oXvjQ2QzaEBABmt7FfYIXpXxoEnOLSrgrRVrezM2n8Bus/06HWB9Llo
KloajWZXIYA5+/xJrnyuHt+PMn0WB/6+VIlx+2x1tp3s7ILqrnHtrJJsCPc+AGVN
ElP0qr/70sJcm3a+jwAndndFo8Bw7GiHIU5HD1nsC/WnMRf6rTNV0O9tMCOivPOz
sV9OqWDDxaDik/+BiOg6NP9nhHbtoiipQ2Jk6vc+m4HZOtgw2u/Q/kG2+CinpZgS
g2uzVIRsWcwlnPgItmQKBfCqoG9OWkysIP7fYNja6R8OQx6ik72/mKYOqsmSJOlt
dsiP1D6+VMQ9UnmSj8iuTti02j+rtC3FqMVk9Z1s10eqP2ILuGJoxdH1qRgAT+Jb
gZdn/CM/cjlg7Y2uReTWKytyAoftP9pJar5AfgOZ0XXRSyt/G+hUFjob3T1MOL9e
FF6UONSOSYP1P/2I48l9Cz6NKfnw8080RNRhlfgG+NN02Vv4T3jkwDcejxMt04U8
idBrQ5qcOVhAPGJzNfWKzDF+7Au1q2o1o5QL6L/Bf7io7h+WrNZtGnGJIvr8DqcH
GkcV8rVa85rtYRhVfnyu
=kTt9
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_13_43_02_+1100_9iAAkX6gxm5YGDMV--
