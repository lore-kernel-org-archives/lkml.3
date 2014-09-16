Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaIPKUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:20:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45154 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752803AbaIPKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:20:15 -0400
Date: Tue, 16 Sep 2014 12:16:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: a case for a common efuse API?
Message-ID: <20140916101647.GC9948@lukather>
References: <53BC4DD7.20906@codeaurora.org>
 <20140709083509.GQ13423@lukather>
 <53BDD0F3.7040906@codeaurora.org>
 <20140710142616.GD27469@lukather>
 <54121B2C.5090702@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <54121B2C.5090702@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, Sep 11, 2014 at 02:59:08PM -0700, Stephen Boyd wrote:
> On 07/10/14 07:26, Maxime Ripard wrote:
> >
> > I guess that the kind of things we could discuss after posting these
> > patches, but yep, it looks reasonnable.
> >
> > I'll try to get things a bit cleaner, and post them in the next days.
> >
>=20
> I never saw anything. Did you do any cleaning/posting? I'm going to try
> it out today/tomorrow to see if it can make some things cleaner.

Sorry, I never got any time to put things in shape besides rebasing.

Feel free to pick up the work.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGA4PAAoJEBx+YmzsjxAg378P/240u56bFmIO0lVNiom8uTSI
pIYuHkQuoG/bSoSfkPgIQhADAsFO8XPuu5/R4oX2AgU1YTro51K/wqAAyrJZxBfk
OEhrN0HTiSde2Z6HewnK4wVlq/7Tia4zvST1ea40iUxHpT2VdjyVAO5AyDQAIpCs
t2Cv9A+atbrGzll4V4tIUNmi3spKdVQ2uAOYne3xMRs8zwEeS+N2KDbu6N/03wH8
JKllkq0ECWOW0Op7GatAHzOOVJXDMvR2FBvjLcfE8Atx9XRXNXak+gso2TPptkFc
wawXBGh2s0NzP1X6NUyxwTw8yyvIuewjsqUBvc8jzJO5zpn+Eim0aEz8wwMrVDQw
FXIGZzOV/x5qhESVd8/bknT/dP4xQ+ulZOMe+jOK/G3NtLviplJy2nBp+z6hwD0i
fdeOTs/mGp3GH2sNoWxxFq+SnOgknrsi8EyL2HP3ZQj2lAtSMJotaMXyHT/1dWyd
ehB0uGVue5FRPyALPmPpQS4j1+6QZufYyYTSUosAsU7JidcWVb/7ihdiZxCfueI7
JGKZJREO6m6fFG3aBkXZtNLW8ADciIOOpqSiaq+n1sC+lO/a9hOQ7pf7T5DZ7Pge
VL6regEdSe1hyAf1DEEGXgGWs5KkBpLI8zYgrIgk81QKW5uYLgFA4VSFxUvCK1BK
ULWzrifChHxoIn0syLPv
=ZqAQ
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
