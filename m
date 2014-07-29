Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaG2LiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:38:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40905 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaG2LiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:38:16 -0400
Date: Tue, 29 Jul 2014 13:38:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: caesar <caesar.wang@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
Message-ID: <20140729113808.GC21732@ulmo.nvidia.com>
References: <20140721085001.GG8843@ulmo>
 <53CD0E82.6030901@rock-chips.com>
 <20140721132723.GH15238@ulmo>
 <53D23192.4000908@rock-chips.com>
 <CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>
 <53D50601.1020106@rock-chips.com>
 <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>
 <53D631B6.1050603@rock-chips.com>
 <20140729102212.GB21182@ulmo.nvidia.com>
 <53D780D3.8070603@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <53D780D3.8070603@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 07:09:07PM +0800, caesar wrote:
> Thierry,
>=20
> =E5=9C=A8 2014=E5=B9=B407=E6=9C=8829=E6=97=A5 18:22, Thierry Reding =E5=
=86=99=E9=81=93:
> >On Mon, Jul 28, 2014 at 07:19:18PM +0800, caesar wrote:
> >>Doug,
> >>=E5=9C=A8 2014=E5=B9=B407=E6=9C=8828=E6=97=A5 12:01, Doug Anderson =E5=
=86=99=E9=81=93:
> >>>Caesar,
> >>>
> >>>On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com> w=
rote:
> >>>>/*I think will be show the faill log:->
> >>>>
> >>>>* rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
> >>>>0xff9301a0-0xff93019f]
> >>>>*/
> >>>>
> >>>>pc->base =3D devm_ioremap_resource(dev, regs);
> >>>Did you actually code this up and try it and get this error?
> >>Yeah.
> >This should work if you properly set up the PWM subregion as a child of
> >the LCDC region, which is what MFD will do for you.
> >
> >Thierry
> As you say,should this change be occured by lcdc driver and dts?
>=20
> The PWM driver don't need do any changes?

No, I don't think the PWM driver needs to be changed for the above to
work.

Thierry

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT14egAAoJEN0jrNd/PrOhUbkP/2PtK2L6KfBYh3rSEpyOXFpv
kJPbSXhoCbMGTWV99kahNC1vnb4g3X8mYBuPmpuN5sRitEbrtFsqoNvVmDWAOaCF
SdBvssJTNtv7KImJj1ouMYq9QUL212mtS/JkdePiieKtFNNQkgMJW3GRxXp7wcLL
PmilVAcTpLnikoJZHPaRLaFe7WkxpHrE+kLrkmTVuh9LUhnIOmc4fA++fWTkity/
T/IUC9LEP7qbL+ENOiPgHkw1tN/6ShXnDaoy449eiODjZ/dRfjIcsshBksNdf7I5
B5iIY4/Om0P6umYfKmMYgdoyQk7yXEwoY2MlAVhVSzw74IQGVSiGhkpxKmLPCc6e
y+USPATnSXda5Xp4v7j1b/OaMy8zeqDCjjwlhDgH+2HanW0njj3F+7cu2oUzK4oM
bdEwsdVyMMCSqgwM7cu1mnWx0pQ1Pq/QhdMhxULD/3cYSewJ2r6Zb4bbhiE09YOf
U4gv7WZElYCQsNiRIe3dUP2nn2prNVDE9dKAAqEagN2Bj53hwMFmXtScPLUnpLCL
mGqySnnNlDBOiMtqAg6zJRZY7QkbFxUwSy+QJNW43+ywMOtyQKKE40leBGbRjyQW
nT3VAiPouj95cnfAjEsOPjUiQIDCJNK8JN6v6SgLR3D3/G8tz91tpRerOhPbM8RE
ef29Ek7fUAwDMhlu3IEO
=y27a
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
