Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3IUOQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 10:16:51 -0400
Received: from ring0.de ([91.143.88.219]:60137 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3IUOQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 10:16:48 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Sat, 21 Sep 2013 16:16:16 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Luciano Coelho <coelho@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, nsekhar@ti.com,
        mturquette@linaro.org, mark.rutland@arm.com,
        Felipe Balbi <balbi@ti.com>, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/9] wilink: add device tree support
Message-ID: <20130921141614.GA21383@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Luciano Coelho <coelho@ti.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>, nsekhar@ti.com,
	mturquette@linaro.org, mark.rutland@arm.com,
	Felipe Balbi <balbi@ti.com>, grant.likely@linaro.org,
	rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <CANOLnOPBHesTiV61zpQ_QS9c7E91K50EnbMnGhvgaViuA_3=Bw@mail.gmail.com>
 <1372859132.21065.111.camel@cumari.coelho.fi>
 <20130921122718.GA4431@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20130921122718.GA4431@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 21, 2013 at 02:27:18PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > > > This is a follow-up on a previous patch set that had a smaller
> > > > audience.  This time, I added the lists and people who were involved
> > > > in the review of the bindings documentation, since most of my chang=
es
> > > > in v2 are coming from discussions there.
> > > >
> > > > This patch series adds device tree support to the wlcore_sdio drive=
r,
> > > > which is used by WiLink6, WiLink7 and WiLink8.
> > >=20
> > > Could you perhaps consider doing device tree conversion for wl1251
> > > too? With the knowledge you have from working on this series, it would
> > > be much easier for you to do it than for someone else, and I don't
> > > have much hope someone will do it at all. It's WiLink series chip
> > > after all. Without this pandora and N900 are going to lose wifi
> > > support after the switch to dt-only kernel.
> >=20
> > Unfortunately I don't have much time to work on wl1251.  I think it
> > wouldn't be too difficult to do though, so patches are welcome. ;)
> >=20
> > Maybe you could try to make this change and I could support you if
> > needed?
> >=20
> >=20
> > > I can offer you my help testing things on pandora and I'm sure someone
> > > here could try it on N900.
> >=20
> > I could try it on the N900, if it is still bootable easily with the
> > mainline. ;)
>=20
> 3.11 should be bootable on mainline, including device tree and
> video. (But excluding some other stuff, like MMC.)

I got external MMC (=3D> =B5SD) working with some small modifications of
the omap3-n900.dts file. I have not yet tried internal MMC, since
its not important for me at the moment, but I guess its also just a
small change in the dts file.

-- Sebastian

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSPaouAAoJENju1/PIO/qa6tMP/1MAZ94J9QoJEOmvx3/92OHt
XYigYI/aoUk9JtWuO7NSBTNKl2H+XRGB63SsitRx864ogy1MKEIKNfd+aQdOMWmy
+CuVhKGaIRUSOt9HpyJOu/hKH4QgGSbzDZZh5tZ1+X/ZUj5DlnXCkepeuJ3VXQWv
D/fjjnWOnSLYWP/tGRAdBhsOFm1sVcEVHMnWZ8CpBRamjKp5HhHUjUXZctBsedB6
MtM9BMSA//4iZeIWCQzHHBVWOiUV/Cn6foIeyQuI0vsUobHbOJRYAyDhjnVyNRMB
PpU9bK5Ultfav30NejyNPKfueZKlUo/Q//HoTwJYdEMKYnEwjomDzXPDwJixsVSF
mEeOQstZyGAcaz0q/fAsf4naPmiZJ9lj2i26R4fg8YnGQKrBf84oQmGViHnb0yff
wW+4d4Xl97Z4aybVn8HxTqMrNC9kHaqZFu/sncNJK66wK1wkI2LKYSouhIpJ9Ywm
+szbhVhNSpqTagD1DNf6G09GTbMB2Ruw4Rf3fbGdU3QJgak8l3+2YeI3NbKLf4TF
ldXTdawgpOebByQJw4kQ61CmT/v8n+uOoeV5acQLEFyqYVLC6OmqtrbBhJUebRX8
Uc5z9mn2Gimx1A3JwSNYTuSym6pJoUCXctLPUIXO55TvkjRmpozvaz3YkDQpv6dd
pSR7gEkUpohisVZMz7HA
=RJDB
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
