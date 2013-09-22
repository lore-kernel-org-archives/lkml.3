Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IVOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:25:26 -0400
Received: from ring0.de ([91.143.88.219]:35073 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab3IVOZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:25:23 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Sun, 22 Sep 2013 16:24:56 +0200
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
Message-ID: <20130922142455.GA31967@earth.universe>
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
 <20130921141614.GA21383@earth.universe>
 <20130922133632.GB8643@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20130922133632.GB8643@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2013 at 03:36:32PM +0200, Pavel Machek wrote:
> > > > Unfortunately I don't have much time to work on wl1251.  I think it
> > > > wouldn't be too difficult to do though, so patches are welcome. ;)
> > > >=20
> > > > Maybe you could try to make this change and I could support you if
> > > > needed?
> > > >=20
> > > >=20
> > > > > I can offer you my help testing things on pandora and I'm sure so=
meone
> > > > > here could try it on N900.
> > > >=20
> > > > I could try it on the N900, if it is still bootable easily with the
> > > > mainline. ;)
> > >=20
> > > 3.11 should be bootable on mainline, including device tree and
> > > video. (But excluding some other stuff, like MMC.)
> >=20
> > I got external MMC (=3D> =B5SD) working with some small modifications of
> > the omap3-n900.dts file. I have not yet tried internal MMC, since
> > its not important for me at the moment, but I guess its also just a
> > small change in the dts file.
>=20
> Can we get the diff? :-).

I will sent a patchset for the omap3-n900.dts file in the next days.

-- Sebastian

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSPv23AAoJENju1/PIO/qaCicP+wdhXI0ya2fzalM6KTu4A9GH
aVXTSDi9+PSzTd3XvxpwbdBQCvje99j/PDLWkoiv8s3MQAkPNBwDpkE3ukK0/2ER
RdMOpX6JIVtX0VcZm8BLFeM1Fi4WWDkwqDmKU4VON5aqg4OMayCd1vEcGP1Yepua
MGo1+p3hPgy7ZYUGzXsUKifdJiN9NpJmn2hcOEP0Hd/o44mYBT0bPxHeQ/HyD2RX
NQ2i8YzcmtAnEeIbwiYkNJzzc2Z3wiTLkP9tYpv22kEX/5h7PzAmxnecRFYtz/m7
8MW03zNV6S4Et/vOSNQNHZhPsXS32+LsFBZcYTwVgCqXz53qIIRKzPsMokNp6UHv
RwOCevUUXX4WFk7S3c0zyNIaXopYeJSy8xWhIGQxAEXYZSLtxCn60u53pWcDEZAV
oKTNm6tBb4/npOdkmSFnj5Ls9g3aUWVJNARsOeTyTxfGgFe9ET2LD2/57WJYQHyu
v1V1sa0cSf921Jp7drZbAj2vdHHLw+IivJF9ydfsu3uJfuD7hy6OtuDs6TCQNakx
GSRImkKxQxOhSdNw0RPGZoy2EKGr8ybN+3CzsjHPXvCE32kJkhVdUw+tyJBxZ36o
xNgxBWDouoWO8dA0Qd/UrknA/XMAMfD4japCCiFtJEQ9/Jf5LDMvp4LJT8chbuSN
bcg2s8xa3QlWiB/K3XUU
=g66U
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
