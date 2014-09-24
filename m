Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaIXFxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:53:46 -0400
Received: from ozlabs.org ([103.22.144.67]:55593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaIXFxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:53:44 -0400
Date: Wed, 24 Sep 2014 15:53:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>
Subject: Re: linux-next: build failure after merge of the samsung tree
Message-ID: <20140924155336.6e64b952@canb.auug.org.au>
In-Reply-To: <00fb01cfd7a4$45eb4a50$d1c1def0$@kernel.org>
References: <20140924110836.209bc8e2@canb.auug.org.au>
	<00fb01cfd7a4$45eb4a50$d1c1def0$@kernel.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HiwnqnrhXI5ikFTbgHHSuFo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HiwnqnrhXI5ikFTbgHHSuFo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

On Wed, 24 Sep 2014 12:04:36 +0900 Kukjin Kim <kgene@kernel.org> wrote:
>
> > After merging the samsung tree, today's linux-next build (arm multi_v7_=
defconfig)
> > failed like this:
> >=20
> > arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/c=
lock/maxim,max77686.h: No such
> > file or directory
> >  #include <dt-bindings/clock/maxim,max77686.h>
> >                                               ^
> >=20
> + Mike
>=20
> Hmm... I think, inclusion of the header file should be included in Mike's=
 clk
> tree...What's wrong?

Mike's clk tree is included in linux-next well after your tree ... and
does Mike's tree get included in the arm-soc tree like your does?  So,
clearly you can't build this tree on its own?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HiwnqnrhXI5ikFTbgHHSuFo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIlxkAAoJEMDTa8Ir7ZwVn8cP/AxGEMRRDJT9LqQAN4DQNQjb
1po5b8YQuzm3UMDF8eGWPh+WSKHfrKYfafvC0uHV9dhf804EmSsWWbFQpIWfBYmq
Xy12BR3RzuG91o9DL+zvGYdr2f1PRbbEtl+JhCELcIfcrjSMpJZnWbshWRgWEwPm
yQ+ejuNG4n3xqvW/BFad0mYP20SNwYyKUuFOj5TOMtKWSjgwAQhel0Sy2TAGNlFf
UZWNlZnA8uNdlP4v2kNInM9CVFv0ozJl2U4pUnZkvjyKoHPJwPvbzUtu3153Bkoc
aUXIISeS7cJME+/hUY0a+qn5dCLSohIAF77e5Qj/Evx6/9rDW0w5sEZruv9kiFZf
PXFxazLlIE+FiAm9RvI57CFZqn1ucKQzAJdJQ6oE+CJao8SvcYoXYp5EXoW0blDl
+z31EhmaiG5TnGB4xMLy1wcxLTAethpuesvD1fn7XT0b4ycPPpmo9QhHwOzG1bZe
jhmEDKXARam+rXwXS/ljCg6EojvO/U12wxagPDO9L8T3qt9Rr8q4blcClJdHtv2w
Dy+H7g9KHXEpA0gM49ZA4C4lHPbAObKzyXdfFsGjRYg+YbVCes5+r+GPxXH+vXkC
1OkctAgz9i9nRIXh3iPv7d3N9wjIMaiEhspZf36id6mBcgzaKAvGmS83hNhmG0AN
R0jpZpYWk29IrEQ28f5G
=1lQp
-----END PGP SIGNATURE-----

--Sig_/HiwnqnrhXI5ikFTbgHHSuFo--
