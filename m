Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3AQGAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 01:00:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45988 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3AQF77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:59:59 -0500
Date: Thu, 17 Jan 2013 16:59:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stephen Warren'" <swarren@nvidia.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, cpgs@samsung.com
Subject: Re: linux-next: manual merge of the samsung tree with the arm-soc
 tree
Message-Id: <20130117165951.2d02532eef149e33847cb9d8@canb.auug.org.au>
In-Reply-To: <0c9401cdf471$53f7c140$fbe743c0$@samsung.com>
References: <20130111153206.e075edb9b1e4a38d90f23ab6@canb.auug.org.au>
	<20130117145324.3f1f27fb5902b5a03135bf06@canb.auug.org.au>
	<0c9401cdf471$53f7c140$fbe743c0$@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Jan_2013_16_59_51_+1100_kAk4HHX0P.quaBsd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jan_2013_16_59_51_+1100_kAk4HHX0P.quaBsd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

On Wed, 16 Jan 2013 21:13:00 -0800 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> One more, following is my preferred resolution when merge conflict happens
> between Samsung tree and arm-soc tree:

Thanks, I will use this resolution tomorrow.  You will still get
notification emails just to double check.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Jan_2013_16_59_51_+1100_kAk4HHX0P.quaBsd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ95NXAAoJEECxmPOUX5FE2tgP/RB9lEoUfu93veMWA1nNe8UI
mK2cfcmpML7rykVB3Vb4emPFva1PpSTQbDroObIdAPyYbOMPIcHyBr1GdH2ccODu
FXR0W9yHGlub21N2PlUkOcQsChFfU1I893ctmXSgqLzSkwjMqdkY/2Em3VJoHUxh
MPQrPJ3aGadgwQl10HpdUc1OIzNRCafslB23j4Rh3B/BqoqbFaumDfLXgzvqTvGg
iWoH7WVSIGZ4ie3B3DjG7zgRmF0FYXrFDbHZSG8bZCnCJVUVAikUht8Crc6ob7rv
nBZZnIBHbvOwWv/AYyGiNOqTQBTW+uRykoMkwy/ZHzC9y9gcGj3pnkovraOA/ccS
2vtOInRlTxfD2Ld2Kl4d13Mv7FVFvdpPtezH4tNJv9nbTsHPRF9rploYi7n9/poZ
fmVWVfg3ZTNZAbHmXNcBx3yNyoEZq3tbhUYs8mXn8FYc9BdvB19W0ecb7zVMKmaL
yoL2G7Ck+wxsYxy6+x6qzdLPqFo5MyctcFQcHYdFVmEkJeYRYjRqtd88FQoHgfFH
aVzBsRBgxhb3UjAbfLnuIn7z2pIU/gLRJsf1rDfC+v0Qs6+sVooV84wFXTU97d7C
LGU5oLJ58X8fapsZEqjubmew7GnIxprhn6SgVr5VjOcDO4w2G2mjPs3SKRu2E4/l
iEhJBQ+h34kz2AdBAsOq
=oHJ3
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jan_2013_16_59_51_+1100_kAk4HHX0P.quaBsd--
