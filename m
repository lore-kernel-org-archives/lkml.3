Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaJ1JPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:15:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:59170 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbaJ1JPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:15:05 -0400
Date: Tue, 28 Oct 2014 10:11:24 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/8] ARM: at91: Remove mach/ includes from the reset
 driver
Message-ID: <20141028091124.GC31979@lukather>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20141028085053.41c6ce46@bbrezillon>
 <20141028085202.GC722@piout.net>
 <20141028085908.GB31979@lukather>
 <20141028090454.GD722@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <20141028090454.GD722@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 10:04:55AM +0100, Alexandre Belloni wrote:
> > > > I'd rather keep the reset driver as is and move SDRAM related macros
> > > > into a specific header (include/linux/memory/atmel-sdram.h or
> > > > include/soc/atmel/memory.h as you proposed) so that the reset driver
> > > > can reference them without including mach headers.
> > > >=20
> > >=20
> > > My personal opinion is that it is better to hide the registers/bits f=
rom
> > > the reset driver right now as we have two different IPs and the sdram
> > > driver already knows how to make the difference between them.
> >=20
> > The reset driver doesn't do anything anymore with these patches. Why
> > not just remove it altogether?
> >=20
>=20
> It does, the reset driver knows about the reset registers.

So the only thing it does it to define a few register and that's it?
It looks like it's a case for a header, not a driver.

> The plan is to move the actual reset back to that driver when the
> kernel will be able to easily execute code from sram.

Why not go directly for the plan then?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT128AAoJEBx+YmzsjxAggvQQALXGYY5+ILSWaRXq0b8mqC6Y
e1vM4HP76ryJ/+pjcu4cFy5Sc2JZcXriEAV1EDaSGZulfys2beWjHock8V5E6tZl
zwVRGmxF+TLKVB3R6Em2pTiwlq52z+tL24zfvORap/rm1NMjAYGvytzwy982hV+X
aaRTI82Eekwl5UyAOxpMfrFe3JJr5k/IuEPtPKjX9SgR4q4BJ8xgSiBF/Q8s7KqP
J9Hv1mjpUI4JUTfh1g55rqwt6dkc2dXGWtgICSBN23bOLrEVMotHWttIVkTvNzZQ
g0aOQgLbdG5yl0t4f7TqFHVB0XWuYfagbsydlvOkdW1jKF69ZwZJ/cAZZkWi5Zip
doyLcEGafHjARaF0goYoy6jtnq7h//qCgnMj71jsMHGv8ZIHsKrXwsXhAfpeHq2w
G7JJBwMRUmVQxi9b2j9rCTrfRnf5/iu4IEQ7c7Koh2dwhX+YctyZkEayPDPEfYcu
WUvM7EQHQ0oUetta9d4bYY/+/Vxe0iDLwFogx4RetMFdQhETIIFtgHDo10SUC1E6
s9JpEYAl6mpAxQHM1yiUSJl/FZJgUy3hWa0lcUksAg6q6H6dKmS5yb4mndweFYDo
/E2mlyrxGBterJTxhNjN+IK/cOtwfRIflpDG1aAcF00xUFZtH3fw7I+3wPT/5R4w
5UCyGzS0vTF1QRLE3B7H
=u12G
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
