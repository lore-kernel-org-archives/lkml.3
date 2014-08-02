Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaHBTKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 15:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48203 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754735AbaHBTKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 15:10:05 -0400
Date: Sat, 2 Aug 2014 21:06:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140802190615.GO3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731115628.GQ8181@intel.com>
 <20140731162330.GE3952@lukather>
 <20140801171306.GF8181@intel.com>
 <20140802144925.GJ3952@lukather>
 <20140802151714.GB30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G23JYFG0d77Z6i/3"
Content-Disposition: inline
In-Reply-To: <20140802151714.GB30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G23JYFG0d77Z6i/3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 02, 2014 at 04:17:14PM +0100, Russell King - ARM Linux wrote:
> On Sat, Aug 02, 2014 at 04:49:25PM +0200, Maxime Ripard wrote:
> > In the case of the call to device_control, especially in the
> > DMA_SLAVE_CONFIG case, but that also applies to pause/resume, are the
> > changes supposed to be immediates or can they happen later?
>=20
> pause/resume are expected to operate synchronously on the channel.
> When asking for the channel to pause, the channel must be stopped
> before the call returns.
>=20
> In the case of channel configuration, that should have no effect on
> any previously queued transfer - in other words, changing the channel
> configuration only has an effect when subsequent transactions are
> prepared.

Ok, thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--G23JYFG0d77Z6i/3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3TamAAoJEBx+YmzsjxAgKYIQAME4LGaJlHQGbAhYtUyWvBZ5
+dp22+1QjHe7h/alLN2pbfLyim/hoFRAS6WYCBIddjzEywG5XyzObrs7RfNUR6+I
vaG94wRbpcD+Isk+PVpOj0Nvq2H8K1krdTLKciMM/1ZRynwDyoPE9nZrmFBfQrdN
cdGp6dEPYpt6UTrDOCDzkKH/YQm703u6jMOsm4KJ0aXEQVNAP4reIl3Qg8bh9rvk
rw/5g/LrWuTKBt/6wK+DBMAR2SGThtbk1t0O2DqiSjr3v4P06NTKXNYNumozyK6D
WQ5ORqyEWBSvn2ofcBpI9MbU9S62QYmgHFBECFCYzqbNviF0qUouNdMEGa1J2hPY
m0m2HvMnA//KGM/hBxttT96+EcOX93e33S5Psx/3BR/OjLdtvSiacFJqQbrB2arV
wYeCc2Yu8v6w66vJNmPtO3nxaoawxNv1cKi2DV5FPxZyDnSq/ucvucX4awRH8ugL
22TJgmM5nvslGHY+oQPL9N28OiXbPy20Zh/8wR6MqMqUlhGNeqtodzElD09oKdO7
I+dMIh/fU83gi9TvLU1PogIk1m4P8a7UeUCccSeM1E+vnTQhadFV7Gd//p7ZEQQQ
W55yS46MiqOft2so8AoxCey5cSoux/6OGsqk3EU+LcxWvr+kkUpDsw7KXQAEXQac
Jrd2BoOMWlR+sWUgwg8K
=MS9t
-----END PGP SIGNATURE-----

--G23JYFG0d77Z6i/3--
