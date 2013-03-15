Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3COMFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:05:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47496 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab3COMFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:05:45 -0400
Date: Fri, 15 Mar 2013 14:05:33 +0200
From: Felipe Balbi <balbi@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
CC: <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>
Subject: Re: [PATCH v2 2/4] usb: otg: twl4030: use devres API for regulator
 get and request irq
Message-ID: <20130315120533.GC21445@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
 <1363242239-1061-3-git-send-email-kishon@ti.com>
 <20130314154811.GA3001@arwen.pp.htv.fi>
 <CANOLnOMxej7dSbQeVKZEjEN+WAFR5qLz5hO0q8NiPvQguNKcgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <CANOLnOMxej7dSbQeVKZEjEN+WAFR5qLz5hO0q8NiPvQguNKcgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2013 at 02:00:33PM +0200, Grazvydas Ignotas wrote:
> On Thu, Mar 14, 2013 at 5:48 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Mar 14, 2013 at 11:53:57AM +0530, Kishon Vijay Abraham I wrote:
> >> Used devres APIs devm_request_threaded_irq and devm_regulator_get for
> >> requesting irq and for getting regulator respectively.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >
> > please refresh this on top of my testing branch, you should be patching
> > drivers/usb/phy/phy-twl4030-usb.c
>=20
> Does that mean I need to rebase my series on your testing branch too?

Oh yeah, sorry. Forgot to mention.

--=20
balbi

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQw6NAAoJEIaOsuA1yqRESh8P/0BxsL2+QVthi98K68/TCQp7
/u/9iM/S4XIvzBG1yGMt1iIRbWOrZl1pSRevsFSzpsmUiA/TZ2k1Hds8Vb3M82xo
Drg/Tu7uNoCoLKaKRw39g0DH/sBkgqA+uA0hY4B5az6ScgHrRUQGc0fCqsyttOHG
dTbVYqXgqgciTVajAXjuIKAqVaG32tRo6Pi/4s9i3QiAoZo9f/dHRqKbHzyP9qmh
2WUkdKU6O/2LGmGCTwf+6VZl2d+SKLD5ZT1CKQ8RXeGA4bRi0ZZn7vJZr8iZOpo4
HPdmU19HheaqKIGYoiNg/Zn7I3IueQqJuzc7GwY7GdXDDGTYYymXrmHHuEVZgMak
Jm8VWV4v9hRAKsCy08aXCCmsLNs6yxjBQBkl+yW1DLeoSLVwPDLEAlXKvxZjD0+D
TN6wb9w8UnkzBuXZA0VY1g5jMZaLf8y8ZCnaMjLpPyAtO50u6qTX4YrkJSb3fWKq
ZdSvnAt3T7xgW0i3hadHN9FNPTo6dRXnC1/ktwPSObpCNlkp6u4bmM1xF9vD1DP/
HhJ5LRSThYXjEVK/VED++nbGbGmSGk1fixxg5F1aqgjM9duQ4ffhS2vvEWkWcknZ
Sqc1FrIRFdVsE1uaVXJk30LnhWf4dbsgpM/w6Heg0cEv9Vii+qTHNIQ6swMkBGq2
Ec9zliUZb/XJRqK/VD7Y
=dQtc
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
