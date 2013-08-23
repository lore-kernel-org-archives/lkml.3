Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3HWIFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:05:14 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55361 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3HWIFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:05:06 -0400
Date: Fri, 23 Aug 2013 10:04:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Xiubo Li-B47053 <B47053@freescale.com>,
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
Message-ID: <20130823080439.GE3535@ulmo>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1473340.OXSHEp7d4P@flatron>
 <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
 <1522215.zHEjdiga8V@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Content-Disposition: inline
In-Reply-To: <1522215.zHEjdiga8V@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2013 at 10:25:30AM +0200, Tomasz Figa wrote:
> On Thursday 22 of August 2013 02:55:42 Xiubo Li-B47053 wrote:
> > Hi Tomasz,
> >=20
> > Thanks for your comments.
> >=20
> > > > +- #pwm-cells: Should be 3. Number of cells being used to specify
> > > > PWM
> > > > property.
> > > > +  First cell specifies the per-chip channel index of the PWM
> > > > to use, the
> > > > +  second cell is the period in nanoseconds and bit 0 in
> > > > the third cell is
> > > > +  used to encode the polarity of PWM output. Set bit
> > > > 0 of the third in PWM
> > > > +  specifier to 1 for inverse polarity & set to 0
> > > > for normal polarity.
> > >=20
> > > If the meaning of flags cell is the same as in generic, default PWM
> > > specifier format, then it should be noted here and generic PWM binding
> > > documentation mentioned.
> >=20
> > OK, How about the following ?
> > - #pwm-cells: Should be 3. See pwm.txt in this directory for a
> >   description of the cells format.
>=20
> I meant just the last cell, which stores flags, but actually this might b=
e=20
> a good idea, but with slightly extended description. Something among thos=
e=20
> lines:
>=20
>  - #pwm-cells: Should be 3. The default three cell format specified by=20
> generic PWM bindings are used. Refer to the documentation of generic PWM=
=20
> bindings for more information about the meaning of cells.

Actually I prefer the second proposal, that is:

> > - #pwm-cells: Should be 3. See pwm.txt in this directory for a
> >   description of the cells format.

We agreed on that wording in another thread and I'd prefer to be
consistent across bindings.

Thierry

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSFxeXAAoJEN0jrNd/PrOhaPQP/jLqLt0rZkjw53bgxa+4cp3X
QAH3ky5tRga2sK1GeAmZfzKqAgINmOqgWTG2GR1Xug5aZT6NYJaG2FR6bHoDblwg
2b9LqjMTNql45K6mbJePO3B8HsbPeZC9FBCLfbCwXDAydB4oQAyoum08zKhr5rNe
Si8wix2xbJzr/HafEBwaX2QpNb+C0qU2CsP7Yh6fdxb63AOhoaeLaE1j/f5at/1+
tscDQOftUZovLxPWQp0cdwlPfvJjOCTggL3Jl5jxX/3UcvQ4zDA3zJFNna5pXMf1
PH9BcjCfp+NIULW9UNF9qUFKeQH+Ow+F6l3rHASL6tYcCJN2+ImaYOGPicniADjB
oSYtqOP1ivrwhXVK7sZrCc5bZrxQHFcCD4cb6Rv3BdN4qajTkqhMxB3vQ35DeS1u
/ETvYhgKWeaj1OFxitlDTJFKqGNFF7VcIOqU9i/ftVz0vj9HgcEg3P5TsPx+XsLm
KWJONrZbRVPiBmfjArOKpdvaIyu6B1amTBqYTRHE/aIHlSh86yUVNO9UBTZUBPNT
9Xn2oNcz6HBL+eWMREETIxDlCK7o6K9vTDYHOwEsR2Z7XEyph0KQ6Q2IlAEZ4WLN
6UhMiENMl61HjN7uKltC1xNyfZZpMZbm5CeptQJXLY4RHeyjnUO39AfbpwkgmEgY
Zi4Qqp+ukLBR1uD74oKF
=RJLW
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
