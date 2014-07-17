Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaGQJzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:55:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41862 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756505AbaGQJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:55:04 -0400
Date: Thu, 17 Jul 2014 11:50:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] AT91: PIT: Cleanups and move to
 drivers/clocksource
Message-ID: <20140717095020.GB20328@lukather>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140710075105.GA27469@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <20140710075105.GA27469@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 09:51:05AM +0200, Maxime Ripard wrote:
> Hi Daniel,
>=20
> On Tue, Jul 01, 2014 at 11:33:13AM +0200, Maxime Ripard wrote:
> > Hi everyone,
> >=20
> > This series cleans up the PIT driver in order for it to not depend on
> > anything in mach-at91 anymore, and in the end move it out of
> > mach-at91.
> >=20
> > Along the way, these patches also do a bit of cleanup.
> >=20
> > This has been tested on a G45-EK without DT and an Xplained with DT.
> >=20
>=20
> Even though most of this patches are not clocksource related, it would
> be great if we could at least get an acked-by on the last patch that
> moves the driver to drivers/clocksource, since it pretty much becomes
> your burden :)

Ping?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx5xcAAoJEBx+YmzsjxAgnzMP/jmj4C6+4CXLENUoCCvlqxHb
Uqr2auJrRZFFLKg2zhuO063xenql/PjT+sAS/G6JrcJo2H/71yklP0NKG+mrvx5I
88nD87XmrVrFCgQp11Gea4IIgHaky02LmjijyjuZ2cE9kBjEtpppSbSnhNPbK0aS
6xa/FBsXdOiNYXKZg/4DLmzlT3XVCXu10z0yUduN29l3kQYD3Ouj6d/31budxHvk
hMPL3ecoX/33NAx35wc69hdqWGHUdekL6a1HK+TbuZCgYVVQpCWI2jhpyQivG05h
tTcFRCovB8mixTaTsn0FJE/dYzHCZ+mJrrGMna3hvZj+1LnCoXYSCVoVWDhFH///
f3bOpHLisxhO8UUE9v3llDwAAt+uLzLKLcIqP9QYPBJTFlkp/BwQdhmzK9ByZ2b/
AVAmgOZpipdbQOKt/Z77tIj9uQzH5ZqIsFEa1Z79pYTEnkwVqB51XH0H9xbcTHOz
niuoqYNlpJ1wKrYTONdcgLgNYavOEof3RjhjcorRr9/8MZa73d90fCNxTUOvKaBs
bQPyoHUBuVzeFiFCFoolWbKZ0yhyFEJ0J3z5nNewxwX7SsxwK6bN5Wv2Pvk/JVmB
vshS0gS7prhcF+n8xIWuyRKodSFNM5poNverq1LvWdh0/xp2zcWgXzxuwvj448Id
Wb/Mqt+LF7MVn6CreJ6c
=uNPP
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
