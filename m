Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaFSNqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:46:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48645 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbaFSNqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:46:17 -0400
Date: Thu, 19 Jun 2014 08:45:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        kishon <kishon@ti.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Felipe Balbi <balbi@ti.com>, <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] usb: phy: add the Berlin USB PHY driver
Message-ID: <20140619134545.GB23782@saruman.home>
Reply-To: <balbi@ti.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401983326-19205-5-git-send-email-antoine.tenart@free-electrons.com>
 <CAFp+6iEKLD_rLg84h3J2oyzw7vizEV-Eqo0e_jqurx_v9ZX2JA@mail.gmail.com>
 <20140606071106.GA30156@kwain>
 <CAFp+6iH+J4T=7pJU_+ZZKrgDwJWwQfznv9NWuy5SkLgz_j75_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <CAFp+6iH+J4T=7pJU_+ZZKrgDwJWwQfznv9NWuy5SkLgz_j75_Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 04:32:03PM +0530, Vivek Gautam wrote:
> Hi,
>=20
> On Fri, Jun 6, 2014 at 12:41 PM, Antoine T=E9nart
> <antoine.tenart@free-electrons.com> wrote:
> > Hi,
> >
> > On Fri, Jun 06, 2014 at 12:09:06PM +0530, Vivek Gautam wrote:
> >> On Thu, Jun 5, 2014 at 9:18 PM, Antoine T=E9nart
> >> <antoine.tenart@free-electrons.com> wrote:
> >> > Add the driver driving the Marvell Berlin USB PHY. This allows to
> >> > initialize the PHY and to use it from the USB driver later.
> >>
> >> Just out of curiosity, going forward we would like to have phy drivers=
 based on
> >> generic phy framework (drivers/phy).
> >> Any particular reason that we are still adding phy drivers in usb-phy =
layer ?
> >>
> >> Looking at it, seems like it can very well be written based on phy fra=
mework.
> >
> > This USB controller are ChipIdea compatible, and the ChipIdea common
> > functions use the usb_phy framework. That's why this PHY driver is
> > there.
>=20
> Ok, i see that now. In that case shouldn't we be moving even the chipidea
> drivers to use the generic phy functions to get the phy and init/exit it.

yes, we should :-)

> I think Felipe and Kishon can comment on this better, and tell how
> things should be. :-)

yeah, this will just make it a little more difficult to deprecate
current usb phy layer.

--=20
balbi

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToumJAAoJEIaOsuA1yqRE3voP/1ZpPY0cPnThMMpVrcovqGsv
U90PnNMf8AZBDjh6kb3rJ1gTqF+E16T36udWdsTnjqdcA6pyEwqIFO8EUyeOlB2e
uBys80CpiJfRHBht0AXxyjUms0MQtwgAy8wZ+kAtGuZizWZf/b4MRGSwQ0X1ipN1
q4X0BsleU9+fVHVyLwtc18GG1taP+DdGASNC7vlHxKa+T1lYex/lWc+i9MhC5agK
+cKIBuOgIHrmIws7tO7UNTKK6RHJNMtv/2oNRr5MhGzaPcCf2IubcWAVYKw8DWz7
vg+hs40h3XxS8sS2qEzahNeakrJFvISbMSpFp1TfVjABDPULPDkkX5Z+sVSK8bta
dBwqqt/KjLMXSpu+LL4d7MYoj7QosAMgYgxyHL5CMoveRYvOK5sKZ6Vkxtd80mWS
e+AVoddqVPlIousVGRC8oLRW0Jf7Hfa+2yJulGwno6zu5Zq8TNXWmbdko2G4mf1o
TL8Jy8NnoRrC5ZEP0nMhzsBJ39vHDjj2DrpNozc1jx2PxyHzV9n7z9h0VrWdEHLk
o832vYoMgjUcIhB0apbyWrGBDvzsRtwQ8oiKf61eJ1Rzq50UJE+h5FVHH67X8Laq
7J6RYXfMGUyskaIGBjFe5diCZ8IitJavXYf40fu1+2d8UC+GaoPgHOCg5vTn8YFX
6ZuezRttNpaMjF/jRYFf
=dz48
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
