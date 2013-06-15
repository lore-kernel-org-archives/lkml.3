Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab3FOPG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 11:06:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38177 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3FOPGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 11:06:54 -0400
Date: Sat, 15 Jun 2013 18:05:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Message-ID: <20130615150500.GA27629@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <79CD15C6BA57404B839C016229A409A83EC20C57@DBDE01.ent.ti.com>
 <20130307144656.GR6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20CCA@DBDE01.ent.ti.com>
 <20130307150408.GU6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20D27@DBDE01.ent.ti.com>
 <20130307160236.GV6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC213C8@DBDE01.ent.ti.com>
 <CAD=GYpb3+nvoz863+VKO7iJijRHnM5RzsVj-5VJfQ-OHoUy19Q@mail.gmail.com>
 <20130614222537.GA25428@arwen.pp.htv.fi>
 <CAD=GYpYfMAZeV1RUC=DqhYGZaKiiukpTZg7bhO582eKwimS9aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <CAD=GYpYfMAZeV1RUC=DqhYGZaKiiukpTZg7bhO582eKwimS9aA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 14, 2013 at 06:43:51PM -0500, Joel A Fernandes wrote:
> > > >> I just doublechecked MMC rootfs on bone and evmsk as it's the stan=
dard
> > > >> smoke test. My EVM is intermittent now so trying to coax it to pow=
er
> > up
> > > >> to reverify.
> > > >>
> > > >
> > > > Matt,
> > > >
> > > > Your branch is working for me, I tested it on EVM. Not sure what is
> > wrong with manual rebasing
> > > > I did yesterday. I will try to nail-down root-cause here.
> > > >
> > > > And you can submit the next version fixing the comments I have give=
n.
> > >
> > > The only comment I could find in the whole discussion was adding of
> > > the interrupts property. I tested I don't have any problem booting
> > > with Matt's patch, without having the interrupts property.
> >
> > might very well be, but we want to figure out why adding "intrrupts"
> > causes issues. Why does it have to come through hwmod ? You might have
> > uncovered a real problem which needs fixing. Besides, at the end of the
>=20
>=20
> No actually I think I wasn't very descriptive in my post. There is no
> problem here. Whether it comes from DT or not, it works in both cases . (I
> haven't tried adding interrupt node to dts but what I gathered from
> Vaibhav's post is that it works also when added to dts)
>=20
> But I can revisit Vaibhav's suggestion of adding it to dts for completene=
ss
> sake. My tree currently works and picks up the interrupt info from hwmod.=
 I
> just didn't see any activity on this thread for a while so I thought of
> enquiring it was ok to pull it in for the 3.11 merge window or if the
> consensus was that interrupt node be added to dts even though it works
> without it.

fair enough, then let's just add those interrupts to hwmod which will,
eventually, let us drop all of that data from hwmod.

cheers

--=20
balbi

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRvIKcAAoJEIaOsuA1yqREoT4P/33N3NwRRLlQBRTySoCkdXQ1
iGeud8gRTCDOaiRmJ6lLKjObERpLKh29cnzs4hcPOLavXeBfORRj9VMWyK0o2D0o
XQaDCbk1n2S2kZ79+bkLrCnvd2FhHJWpLlaTTpWz+WFgU0lQ+zS2lIK5iNHEPQGX
a+zsZ3DlCeL7Qjc5eR/9gjsBdLPGaCMb0PMjCsIUpNg1dZ3Iuq8WnHO5gs0Kf4hf
MVcIQNcLM77GRKpkgwAX5FiCTfH08aIqnkwGhixp/GkKM9Qq2VnxSzLWc6GivW7i
GZYCVXLII8i5IIcAbIaDScNdd8JzDfWP/AYc9MjothySomoR9Z05uJb18vTRbtPf
70TtJpeztXQflUdN8GFUkcoHnpysyHIbkGGFuSy+9fgnoq9kIoPF53JC544qQn3Y
KFAExhd9IDvTO/nzp28HSwOZUgYDCoLd1KedXMasAwRUa5a/s6RsxocvFDu0XiIw
dClRT1sizLd39E8ELdgj1Arzs7doCZ1/g2NTJeW4xHgs8YDr6iIhZZxKMbFXl1vh
I6PVLuQEkwO7268jY02qEyvVDFM+AIXrJqbL/O3Dn0w2VgycrDj0k9xvbshKBpYo
jisgYm5osz2NpAHztdH1tHPku1los4lixEFTVyfccCHqS3e2NbFy/2T09TEweyCs
bB2ZkwTWWyQfqBUOvquc
=qdGk
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
