Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3AVQQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:16:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3AVQQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:16:18 -0500
Date: Tue, 22 Jan 2013 17:15:59 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
Message-ID: <20130122161558.GA11898@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
 <20130122102558.GA10716@avionic-0098.adnet.avionic-design.de>
 <20130122160809.GE10396@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20130122160809.GE10396@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:FZ3PGgMYo3JZXlyihrU6WrxVhpLqlGEto+IgB5m+srQ
 O/sR2Y9RI0Ir9Q4WmSPEd+zbkJOvvSUaeOsRkajMQhbLXxqnp8
 1RQ8Pt1NV1PmLZSKsLh1Adc6G4pdo+PJQEoTvPpURZeLXFkb/1
 V2znzkBRd78jl2xiruelH6bDiIVPvJ9mN1jCTn2YfxRhnQflWY
 giV4mekXVf/3inZnFAPhkccAtozkyaPmpFSK67dJ7p9cIMs02/
 n64p8n5XNgQRw0ZLK7u54y+/t44Yxuid+Mpg67gczjo0cs4adY
 z0ZSBKlCkPC4Q24kDqfHEySg7REt0cbQsEn/u1gdSvq2EF3ib1
 yV7T8NbAkKQzHZK3PVYkXA9v9rfOd3rjzkxTQUzq674zqE1AlR
 AxkdOEcQVdxF82+wFwbJSbDObIPw6E8GTk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 08:08:09AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 22, 2013 at 11:25:59AM +0100, Thierry Reding wrote:
> > On Tue, Jan 22, 2013 at 11:15:11AM +0100, Linus Walleij wrote:
> > > On Mon, Jan 21, 2013 at 11:09 AM, Thierry Reding
> > > <thierry.reding@avionic-design.de> wrote:
> > >=20
> > > > Convert all uses of devm_request_and_ioremap() to the newly introdu=
ced
> > > > devm_ioremap_resource() which provides more consistent error handli=
ng.
> > > >
> > > > devm_ioremap_resource() provides its own error messages so all expl=
icit
> > > > error messages can be removed from the failure code paths.
> > > >
> > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > >=20
> > > Is the interface already in-kernel so I should apply this or is it
> > > added as part of this series so you're searching an ACK?
> >=20
> > It is part of this series, so your Acked-by would be great. Other
> > maintainers have done the same. Initially I had thought that it might be
> > easier if the patches went in through individual trees, but since the
> > first patch is a dependency, maybe it'd be better to take them all
> > through a single tree.
> >=20
> > Greg, any comments? Would you be willing to take the series through your
> > driver-core tree once all Acked-bys are there? Alternatively I guess we
> > could take the first patch into linux-next, at which point maintainers
> > could take this through the individual trees.
>=20
> Yes, I'll take the first patch through my driver-core tree, and add all
> of the patches that the subsystem maintainers have acked as well.
>=20
> As subsystem trees can't depend on linux-next, it makes it easier that
> way.

Most excellent. Thanks!

Thierry

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/rs+AAoJEN0jrNd/PrOhaN4P/2+GjNEoDOkdtWZML41xJuNI
dM0BbVtXQViczTAuPfkS+BpevI+Fx0t7lB7DLghMnhEno60x1aMHQpCXm7PEN6Mk
6cA3N3jxoCyi0hZ1iOxsnD5OyI8+YBD9L+Wa5GyQf/a4KQ03DCKw97Ai+lNNLxzV
6fZgDBeio8IF5uGXR3D4AnBhc1CG+Qd+o5sqcdQB+M0HTQlQ5G9x+kHBHa6W30cn
mJCL20AP/svTdPbVlz9IYOH1hXee0dfNnDcvenFbiSny71L7+91llsch6qXGz7D3
i+GcaSIg3ytydJV5AX2wBzCPRvaB+xhiIQuJv3hcdBKAXMXW2C7uoDJf1S8Mp9aR
l7fJkCBHcRWj5zz0y1hJnGBYWpsGyqFibCoM32URaGbUeR3Bw84uw+mk17IDrsXy
jISqknyodT8qNMpjKUMQg/kZAEcwfUKbJP/SSd/hy1oKt8VFy9rNIjtGAnkJh4ha
lcQ/XkX7NVJUqzT82NBZdb4VixgsGGWVODp3Z3/UKTjeEph0zwmDtZLXhydRRvSp
taDL1YK6LPH4hz7fEVfjuiPEbAJsw6O4ZgyHKQ8SZIRktUy9xi7bZlK4Y49nIql9
/+e6253b54BZ3Rq170E5TZCb5X2QsjwdskH7zmG1W/xODRN1UtlRJRhgX3iDfvpg
WtcRfIEvm6XVMeKdn0/v
=BRzF
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
