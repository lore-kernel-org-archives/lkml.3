Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbbAMUaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:30:04 -0500
Received: from ozlabs.org ([103.22.144.67]:47415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbbAMUaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:30:02 -0500
Date: Wed, 14 Jan 2015 07:29:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Anson Huang <b20788@freescale.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: linux-next: manual merge of the imx-mxs tree with the arm-soc
 tree
Message-ID: <20150114072952.0e0546d1@canb.auug.org.au>
In-Reply-To: <3097971.rZTsHKr4DO@wuerfel>
References: <20150113111636.7bc5785c@canb.auug.org.au>
	<3097971.rZTsHKr4DO@wuerfel>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B4iRhzyvuGtSj2NnZWhqtWq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B4iRhzyvuGtSj2NnZWhqtWq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, 13 Jan 2015 14:18:32 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
>
> There is an extraneous '\' character behind imx6sx-sdb.dtb now, which cau=
sed
> build errors for me. We should soon be able to merge the other branches i=
nto
> arm-soc to avoid the entire set of merge conflicts, until then please
> change your recorded resolution to avoid the build error.

Oops, sorry about that. Fixed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/B4iRhzyvuGtSj2NnZWhqtWq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtYBGAAoJEMDTa8Ir7ZwV4x8P/iFqtHx/LH99gYWvXuF4VdfB
DNJGNwx4QugB2pOoOpVZ0zq3P1jPyj33NNkB1DsVAhrr3HyqSZzq/ErTm1qdsBhS
qCiLZuBUR/gY0NCZvRrqv0fkIvgSVYUl9cH/AKou/GkwkjLc9YpvHqqqIoPmEM5d
yR3stNOVO+SW55KvoEqU8lxzBCiBYJU8NjQftGkFhccION3apUAXClLUlbUcoJ/k
KzRXv0aaY4dPbKreZhzSwzoTlAMWU6gcNWa2y0xlVcX8egcYG786Zk/Yei8YK0U2
e7JWiaPbY1O++8dDilaRpHakxHv5/FQNVKmVaH5yKxcKQoxkDxmYHhrwGRGykXiF
SdISyWMOxDVYWFQ8sKdDE3Z9wUo6Vm2fUZO5pLN213ZRtm0pTCuC9H2iPqDJFwdf
wxPzogmQGfOCmPZVC1qTaMMw6QPZmdQuTQzmg7VmdxyZAKozPK0Dv9yNWSdVgj2E
6sTAgJk5vZEUXW1hIdfdqQXUSVWj+Hd5yokEvqDnv3Id1K7aUCaeoeoUPA0LxZht
z00n6tQLosTzFs/h4DQikJWxWcJ79xx2kx6YxcRJGdIagHqI3B+QEQ56syhfZiLW
u9sPvsHALIfMl7wuvDAQT50vdpdwb8Gx3YgDjjfV9IESJrDnviTR8IXSkNZF1gjS
LEUDM6l+cTCYkWve97tN
=qG8r
-----END PGP SIGNATURE-----

--Sig_/B4iRhzyvuGtSj2NnZWhqtWq--
