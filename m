Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaFLHZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:25:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49918 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaFLHZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:25:24 -0400
Date: Thu, 12 Jun 2014 09:22:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] pinctrl: Add NVIDIA Tegra XUSB pad controller
 support
Message-ID: <20140612072220.GC17027@ulmo>
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
 <1402398708-10722-2-git-send-email-thierry.reding@gmail.com>
 <CAL1qeaGKUGjSzriDGptR+h23+bS3ZWuStz6koPURCstkFbEjNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <CAL1qeaGKUGjSzriDGptR+h23+bS3ZWuStz6koPURCstkFbEjNA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 01:23:59PM -0700, Andrew Bresticker wrote:
> On Tue, Jun 10, 2014 at 4:11 AM, Thierry Reding <thierry.reding@gmail.com=
> wrote:
[...]
> > +static int tegra_xusb_padctl_pinconf_group_set(struct pinctrl_dev *pin=
ctrl,
> > +                                              unsigned int group,
> > +                                              unsigned long *configs,
> > +                                              unsigned int num_configs)
> > +{
> > +       struct tegra_xusb_padctl *padctl =3D pinctrl_dev_get_drvdata(pi=
nctrl);
> > +       const struct tegra_xusb_padctl_lane *lane;
> > +       enum tegra_xusb_padctl_param param;
> > +       unsigned int i;
> > +       u32 value;
> > +
> > +       lane =3D &padctl->soc->lanes[group];
> > +
> > +       for (i =3D 0; i < num_configs; i++) {
> > +               param =3D TEGRA_XUSB_PADCTL_UNPACK_PARAM(configs[i]);
> > +               value =3D TEGRA_XUSB_PADCTL_UNPACK_VALUE(configs[i]);
> > +
> > +               switch (param) {
> > +               case TEGRA_XUSB_PADCTL_IDDQ:
> > +                       value =3D padctl_readl(padctl, lane->offset);
>=20
> This overwrites the configuration value - probably want to use a
> separate variable for the register value.

Good catch, thanks.

Thierry

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTmVUsAAoJEN0jrNd/PrOh+6EP/RUAe4FJ6STniIkgYa/Snsz8
rtxsLjiXJ2Fk8T8kNgJ6fmZo9txwDHJLD9Z0LmxvVWa22BFQoLTBWr08Z04t+T+J
dq4pT3H7nUCRr/oQaefUy2tnA6giAJwjBZPqA4R4UAK9WlZh7pMqHnnEt780UUwN
4Tvd1b4E9ufRLLDPWt634AmVjcAjardhKg4qqvMl7+dGwHND0E3m9AGogn287y+U
I9u7lUne+eddyl/akrkMr2KPA41smAKhjZ/Bfti6zdRNdPUrxVb1aMkdS6TtnCYF
7dTR9BoSD6hjz/OAG2uzrJTndqpSrz/kl2NqxI++M9ZgQzzO0+oboB/EXSwdFQh+
nR1eLk/pGTiHd4zNeV3JL3WQXaEPuiXYoJm+fsNMmOGuGowW2ZEU3NRCDgfrGqVb
9OYU0m+A5FIC5sD5Rc4DRx0Pgme78SU3ewkszyuR2eq66zhWe3pFbqBr7pac6UtU
EUaXmZylfJRrlGLHXQ9gRa9E8IFKHVgDYuMvbGol2y4K9IjDSniJBW5I/ljAMpbN
JfdMJ1r7oPOtNZRJ5lIXetnBVWFsDsSxF7luWw71TTOHzFOrfFmDSG8Dl4q/dDd3
s60htEBBlSQrg3JtWSkaRm7ngyw4urWix9ImDE/IPwpRNdLE/tuUqD9K7BWhwOG2
Y7Zjqk86Mc9PGTmViTOh
=Elqb
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
