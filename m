Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaEJBU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:20:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49197 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757898AbaEJBUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:20:21 -0400
Date: Fri, 9 May 2014 20:17:47 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, kishon@ti.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 4/7] usb: ehci-platform: add optional reset controller
 retrieval
Message-ID: <20140510011747.GI7047@lukather>
References: <536B324C.1040806@redhat.com>
 <Pine.LNX.4.44L0.1405081002190.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1vEdgMWljt97yA53"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405081002190.1087-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1vEdgMWljt97yA53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 10:07:25AM -0400, Alan Stern wrote:
> On Thu, 8 May 2014, Hans de Goede wrote:
>=20
> > Hi,
> >=20
> > On 05/08/2014 12:00 AM, Maxime Ripard wrote:
> > > On Wed, May 07, 2014 at 10:25:55AM -0400, Alan Stern wrote:
> > >> On Tue, 6 May 2014, Maxime Ripard wrote:
> > >>
> > >>> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > >>>
> > >>> On the Allwinner's A31 SoC the reset line connected to the EHCI IP =
has to
> > >>> be deasserted for the EHCI block to be usable.
> > >>>
> > >>> Add support for an optional reset controller that will be deasserte=
d on
> > >>> power off and asserted on power on.
> > >>>
> > >>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > >>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > >>
> > >> Is this really a _reset_ line?  That is, when you assert the reset=
=20
> > >> line, does it actually reset the EHCI controller, or does it merely=
=20
> > >> leave the controller in a partially powered-down state?
> > >=20
> > > It actually resets the whole controller.
> > >=20
> > >> The difference is important.  During suspend, the controller is
> > >> supposed to remember the state of the port connections as well as ot=
her
> > >> settings.  If it doesn't, the controller and all attached USB devices
> > >> will have to be reinitialized every time the controller resumes, whi=
ch
> > >> will increase the latency.
> > >=20
> > > So you're saying that we should move this to the probe then?
> >=20
> > Yes.
>=20
> That's right.  The controller should not be reset during suspend, if
> you can possibly avoid it.
>=20
> There isn't any real benefit to asserting the reset signal during=20
> suspend, is there?  I mean, it won't use any less power, right?

I don't think it will. I'll update the patches and send a new version.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--1vEdgMWljt97yA53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbX47AAoJEBx+YmzsjxAgWF8QAJz6cZUOZWU1ZzGSk6UozGO5
uB7NGuV4qC9/haKxU43j71nMLVhulumnAxZLCx9UkY6h/QjWA1PvDdcavVazm0iX
m4Qm2LIFmMylUJdXvVdtEpFNs7Sw4SUHJS0rUGj5i0o6qmvILOJn0ltPbDpMZh+n
WyivNp7BOhMZR+sn2hqOgIX/Is/hTEQpdZKHFhLhQTFOhynit+mLi/KhUGb1vYyD
2NrIt1QcU/HmHsSC83cOfUeAO22ar8pLmOwXET+s5BVINIJpL1IOzUS9CejIqSs+
HLRqIEwumqPKGqBn9IbGyL/nDg3k+hk0HMABCH7NA58ShAZUxWmi8Z3WwCAXzb0B
128oU37K0r/9LzOBlQADjP9jJSqMqO78Waz3HvaMaOZQAb3E8GSIP9AjKt5KMY/R
RcLVqyq8Ojosf+ahYDuC5z9uUgqGcFoWE++8vCFT4plFUYXI9r6Hm5pzvZ0zBNt6
9voAYBI3BumvTsoybVY8ycTkwYIJAFIowd2kVlu49GR/CQcnhaoj+LWFnW6jLc48
dfjWGErLJfzJcECi7ZAWEXGMMueMhPHg5KaDh6l+AjQZ2ICqHXbCg9gXxLzsQIZn
rBQbKAptx58vJjtsgShTiRT3dcz/GD2PH8X0IOhs8WvZ5rB2UZ9Xdy6Q60iqbs+Q
OdV5soqvSobs9V/TuLwP
=fXzr
-----END PGP SIGNATURE-----

--1vEdgMWljt97yA53--
