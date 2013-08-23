Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3HWHgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:36:41 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:60871 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab3HWHgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:36:39 -0400
Date: Fri, 23 Aug 2013 09:36:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li-B47053 <B47053@freescale.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Message-ID: <20130823073612.GB3535@ulmo>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <1473340.OXSHEp7d4P@flatron>
 <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130822062610.GR31036@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20130822062610.GR31036@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2013 at 08:26:10AM +0200, Sascha Hauer wrote:
> On Thu, Aug 22, 2013 at 02:55:42AM +0000, Xiubo Li-B47053 wrote:
> > Hi Tomasz,
> >=20
> > Thanks for your comments.
> >=20
> >=20
> > > Could you explain meaning of this property more precisely? I'm intere=
sted
> > > especially how is this related to the PWM IP block and boards.
> > >=20
> >=20
> > Yes.
> > There are 8 channels most. While the pinctrls of 4th and 5th channels c=
ould be
> > used by uart's Rx and Tx, then these 2 channels won't be used for pwm o=
utput,
> > so there will be 6 channels available by the pwm.
> > Thus, the pwm chip will register only 6 pwms(6 channels) most("fsl,pwm-=
channel-orders
> > =3D {0 1 2 3 6 7}").And also the "fsl,pwm-channel-number" will be 6.
>=20
> If the chip has eight PWMs I would register all of them. If some of them
> are not routed out by the pinmux then just nothing happens if you use
> them. In a sane devicetree they won't be referenced anyway when they are
> not routed out of the SoC.

In that case, shouldn't this be hooked up to the pinctrl subsystem as
well? As I understand the above, the logical thing would be for each PWM
channel's .request() operation to configure the pinmuxing appropriately.
And if it can't be configured as necessary then .request() should return
an error (or propagate the error from the pinctrl subsystem).

Thierry

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSFxDsAAoJEN0jrNd/PrOh6OYQAJVaXDXzX3eYDTx0e+mmLAZn
GvfKvKNt8iCkyMhQIPkjs7IeORK/dIuWxsGzqOxpUW0XU/vEn3TBRMyN2IdC8yyK
xXvR2z1uE5vccIzxGuM26TIryDTkTm74OWFAcSGoX5pnKw5jiQ2g/DSYDh5p8tkM
cGHvUKN0/gvtyY3iwSx8vkpP+2DdeAW5dfBc0JvOuFOkMtvK8Ahy4rK+k/jjTHHl
aSk9YAwnMPe09x4RITdpHWjVnECEuy9ZlLYZxxtirE69tvmaTgzYA42i/rV98QbP
iKdfEbNsqm/tOq1xH54KgDBzz1JSu/mQ/1nmo66M1wGQYHPAd4KLuvr7qx8pBDsf
x6Tox83VPZYdlAcN3ij425fMpkCeGAO6XJnpSESlok3FHFUakEyzCGnYFZ839uU3
SQVoDqUClD/LC7C+JHdIqILWOEbPMYaLadkNnEoDUzKXv0JkSSsgDT6uiqCDNGby
yNy2b6Z1qYauAhYtBVi4GA8Dyjuw5gTilK8k3yrpseGQHTXxXaCWxoAkNEHvmj6N
ztobn3FRRYrP0erjREszrit96BD9ccfgO6JoE7rQfXjl+YMqPv0fEV2pb/2MScLU
GTuob67JFd8sDvafu2OxLzZnUpYUSJsgFAcZKIXIKdtzbOU5ByAxOQW1ngt6vsbI
kJ8XAxNb57QIJUHTxNZk
=vfzZ
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
