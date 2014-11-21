Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaKUSbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:31:18 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44039 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKUSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:31:16 -0500
Date: Fri, 21 Nov 2014 14:31:07 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kernel@stlinux.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] thermal: sti: Ignore suspend/resume functions when !PM
Message-ID: <20141121183105.GA10652@developer>
References: <1416412231-2752-1-git-send-email-lee.jones@linaro.org>
 <CAOMZO5CwFSRUoVb2j=X=fzaqVN1gUyRki70ewrGrwqLWSHMoAg@mail.gmail.com>
 <20141119164040.GG1875@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20141119164040.GG1875@x1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Lee,

On Wed, Nov 19, 2014 at 04:40:40PM +0000, Lee Jones wrote:
> On Wed, 19 Nov 2014, Fabio Estevam wrote:
>=20
> > On Wed, Nov 19, 2014 at 1:50 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > > Prevents build warning:
> > >
> > > st_thermal.c:278:12:
> > >     warning: =E2=80=98st_thermal_suspend=E2=80=99 defined but not use=
d [-Wunused-function]
> > > st_thermal.c:286:12:
> > >     warning: =E2=80=98st_thermal_resume=E2=80=99 defined but not used=
 [-Wunused-function]
> > >
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >
> > > v1 =3D> v2:
> > >  - CONFIG_PM =3D> CONFIG_PM_SLEEP suggested by David Paris.
> >=20
> > You should also update the Subject to 'when !PM_SLEEP'
>=20
> I guess we should, yes.
>=20
> Zhang, Eduardo,
>=20
> Are you happy to do that, or would you like me to re-spin again?
>=20

I can edit the patch for you this time.

Next time, when sending new versions, a couple of advices:
(1) add the Ack's/Reviewed's/Tested's -by  you get along the way.
(2) please, version you patches, it easies maintainter's life while
reviewing / applying your patches.

Thanks for sending the fix.

Eduardo Valentin

> --=20
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org =E2=94=82 Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb4TgAAoJEMLUO4d9pOJWDcwIAJZewN586xi4vRykZ4e9kREn
JXAECsD7UTQlHWjw2NCnAcHycfzwp6DOYxGhKrI7Zx77YX38FzHDS+082K16MUnu
LqURdzy37e9ycFE3s/750iTaWqf8EKTLCvkvttPDMc+GCOsGCCw0GX9EFeuBnDQE
b93qKuURcD/PDo3Ckula6CFKt453sacbFJNgbsvua/AQj/OwS0F2paf260WQyGVO
Fo6vuebsqZTXfZTJ8GHA0/2R2K/KD6T4LExNZxia69IYdqGefEupZGJrNmecn5Yw
/z2neO5wksOWZ2Oyl38LFn85EjF9Mpvs4xqz1ivp6nzcanqo1HZi6kQf5xOMB2c=
=S/iJ
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
