Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJQLZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:25:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47377 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbaJQLZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:25:05 -0400
Date: Fri, 17 Oct 2014 13:23:56 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for
 the dma controller API
Message-ID: <20141017112356.GO19438@lukather>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
 <7725507.nuHj4C7OxF@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQyQLyduEnelPo/g"
Content-Disposition: inline
In-Reply-To: <7725507.nuHj4C7OxF@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQyQLyduEnelPo/g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

Just getting back on something...

On Mon, Oct 06, 2014 at 03:09:48PM +0300, Laurent Pinchart wrote:
> > +   * device_prep_dma_*
> > +     - These functions are matching the capabilities you registered
> > +       previously.
> > +     - These functions all take the buffer or the scatterlist relevant
> > +       for the transfer being prepared, and should create a hardware
> > +       descriptor or a list of descriptors from it
> > +     - These functions can be called from an interrupt context
> > +     - Any allocation you might do should be using the GFP_NOWAIT
> > +       flag, in order not to potentially sleep, but without depleting
> > +       the emergency pool either.
>=20
> You could add "Drivers should try to preallocate the data structures they=
=20
> require to prepare a transfer."

Isn't that obvious?

I mean, if we're in this function, we're already preparing a
transfer... And I would expect any programmer that followed CS101 to
be able to allocate the memory it needs :)

The rest of the issues have been fixed, thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--LQyQLyduEnelPo/g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQPxMAAoJEBx+YmzsjxAga6YP/ie7lFCw3PeiemPMo8VC8h9S
lEJ8T/Nm3X5zqh+l80KUJomY2badHndTmwEiKatPqu1Ldw9EAOhFeKhp7Re5tD1/
TWbYDWdptK+5/lplwjekCKbyZ8r9yi8DuHFuAdsk4DDKUMCfiqGOB8+aWi0XUg6f
z+UbgMTKFk9xo111s1ApXdyqVKTgNqbLI25w/3JTXc2Ec6qadpgJyLY32kU5q2AU
F031Z1URhofFMJ/I/6oat9D4Dk0Iq4c1vi9F0/jzuv/rZy741zS0HAKhyuuHlr2i
6ooh/+mMOQoKK9LiU3IFjjT53yS+TUsc0Au4YYnZHKP5ExCH6q031EtcrptCaNF4
12SyP1z5s9icPp9Pe/UQ09ifqkcoK4OyzJWGMRP5JHB5Bu0LJbZQbYF7ADEShos9
AvM2ZKKyCUYhsqYkNEwJa7yokaufiQjWL882EkByzhvmgcoswRYCw1GAZrlRzTqd
8+7G1IcMAj1YzIKbFbVTe531MlEofGtiYgGQ3xluNS+wYzxdeNuyHwl3bBC2NMi6
FneIQH78tBVsBGKtpPsZyU7YBfNjFeyunjj7WV3UlaqN/ci4wq/GTpIjP/5pjMTp
Ewxa/O9R6ZFDjjDW1uyxgjREq/IH0Dg3elP/gWR0axNKhl1XSvSbuI1/kq3H4gU6
pcS+BrDoyX9TbadVVl7f
=z4za
-----END PGP SIGNATURE-----

--LQyQLyduEnelPo/g--
