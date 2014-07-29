Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaG2KWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:22:22 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41860 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaG2KWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:22:19 -0400
Date: Tue, 29 Jul 2014 12:22:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: caesar <caesar.wang@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
Message-ID: <20140729102212.GB21182@ulmo.nvidia.com>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
 <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
 <20140721085001.GG8843@ulmo>
 <53CD0E82.6030901@rock-chips.com>
 <20140721132723.GH15238@ulmo>
 <53D23192.4000908@rock-chips.com>
 <CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>
 <53D50601.1020106@rock-chips.com>
 <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>
 <53D631B6.1050603@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <53D631B6.1050603@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 07:19:18PM +0800, caesar wrote:
> Doug,
> =E5=9C=A8 2014=E5=B9=B407=E6=9C=8828=E6=97=A5 12:01, Doug Anderson =E5=86=
=99=E9=81=93:
> >Caesar,
> >
> >On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com> wro=
te:
> >>/*I think will be show the faill log:->
> >>
> >>* rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
> >>0xff9301a0-0xff93019f]
> >>*/
> >>
> >>pc->base =3D devm_ioremap_resource(dev, regs);
> >Did you actually code this up and try it and get this error?
> Yeah.

This should work if you properly set up the PWM subregion as a child of
the LCDC region, which is what MFD will do for you.

Thierry

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT13XUAAoJEN0jrNd/PrOhen4P/RA8Rs/MTTvBLu4bG06BJJmU
K7QO2sTyELSCK9cABO66JOWqBBfka6bc/LE28amcfYnIMuZgxYBrreX64GqEML3L
0MnLR+Ot/z4uI6QCELzaCFJi5H3t+GkadDwPU2BtlcZLXslnQrsz9oPCXy1uBmru
X6tyBbv4ByLUMIgOTDK1T7qmiKggpy3ozjKUTxEh6DbGwUlw6T2K5K3zCkVlQAJB
M9o1hz1vf5HjpEqeS4thIkxUXtiLtZ3emx0XlHbdubEdW5C/jezTi7CVIfIvb3Es
QIrmJzHwTmomN2s7FjSQNCgRBdX8idmvZsd9Cmj+U8P4X0PGyQjEW0MnvPGrO63D
yEJwHFNrR3HhTk3UiWRQIXNlBl6LUpMDlOhwzzXb4VxwnjfI6XAq667sHl4YL+Fj
HfwREmpjeio+yJpnY8hKs7/872+VzvrWi9oGHAU4GQC6lRTSet8S/QIh4CZxEHPQ
jnuftU6hWHpNCzvF09kKEIX4hjtGQkob0FJz/Ez9QFUcytOpGde/Mo1bzw4o0vHI
i+Q8/hRTfjzhwkP5M7x4DT1f+Lc0vsXzIx+h2FFRinzkMJgD9dF3s4HgxTvvaLrR
1ZdyUGG2CpPVP8Ziv2cH6Y1rlJA+FxRh8VdMRgHq3RJMLZhl8SvuqrDoaGq175w1
srzTsj3Ts1C3gVPNBFRP
=yCDK
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
