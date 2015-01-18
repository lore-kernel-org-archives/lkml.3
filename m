Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbbART3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:29:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50141 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbART3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:29:11 -0500
Date: Sun, 18 Jan 2015 19:28:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Message-ID: <20150118192834.GE2809@sirena.org.uk>
References: <54B8D97B.3090908@free-electrons.com>
 <54B8E38A.6020709@redhat.com>
 <20150116123705.GM3043@sirena.org.uk>
 <54B9629C.9090800@redhat.com>
 <20150116202516.GL3856@sirena.org.uk>
 <54BA21F9.5050408@redhat.com>
 <20150117131404.GA6414@sirena.org.uk>
 <54BA7197.40301@redhat.com>
 <20150118123531.GA2809@sirena.org.uk>
 <54BBD13E.6030901@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
In-Reply-To: <54BBD13E.6030901@redhat.com>
X-Cookie: MERYL STREEP is my obstetrician!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 18, 2015 at 04:29:02PM +0100, Hans de Goede wrote:
> On 18-01-15 13:35, Mark Brown wrote:

> >Right, but that's not what regulator-boot-on actually means (and I'm not
> >sure why you would think it would TBH)

> Well, the meaning of regulator-boot-on is not clearly defined really, to
> begin we need with fixing that, currently all the bindings file says is:

> - regulator-boot-on: bootloader/firmware enabled regulator

If that meant anything about what to do with the regulator at runtime it
would say so - it means exactly what it says.

> One could easily argue that the bootloader likely has a good reason to turn
> the regulator on, and that unless there is a specific driver which claims
> the regulator and thus knows what to do with it it is best left alone ...

That's an excessively big stretch; it doesn't reflect the reality that
the bootloader is often just leaving the settings it found on initial
power up alone nor the general quality of implementation concerns one
often sees with bootloaders.  A big use case for this feature is that
there is a fairly large class of systems where the bootloader can't be
relied on.

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUvAlhAAoJECTWi3JdVIfQFugH/2MtQS8neODkPiv2p92VJqpA
yyGQvGqIheznrWmlk6q6VztpOWTirZdB8dXmwJ5iAlojBYVZ37RUt6gBpmUoAOTH
vk3rKGwKANixryQ6p/INxeN/eI/ezGtpKyse5DP1jdHrx8nXlokm5gQPm/wzQeDu
WMk9+pgYUlzRBbibYa10E38oAzStNsYmZMxZuHCjPmOZ5g0zLp/tGySZYZw5Y5jS
eTEvtcsDrJ0QjQPBlrb696PdQuc5cHdZ218fPbZf/brvfVB7ATtQG2oIq7WL6bQs
17TdfnUJrnGJHcNTQ/mXKBIW2y/pl6wz2UszfTWfhtW95yFx9LlOrbZYzH7zydI=
=m6+K
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
