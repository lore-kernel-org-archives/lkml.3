Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbbAPTpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:45:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40445 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbAPTpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:45:01 -0500
Date: Fri, 16 Jan 2015 19:44:00 +0000
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
Message-ID: <20150116194400.GK3856@sirena.org.uk>
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
 <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
 <54B8C933.7020502@redhat.com>
 <54B8D97B.3090908@free-electrons.com>
 <54B8E38A.6020709@redhat.com>
 <20150116123705.GM3043@sirena.org.uk>
 <54B91FB4.5080707@free-electrons.com>
 <20150116153451.GA3856@sirena.org.uk>
 <54B962E0.9060504@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ee6FjwWxuMujAVRe"
Content-Disposition: inline
In-Reply-To: <54B962E0.9060504@redhat.com>
X-Cookie: I've Been Moved!
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


--ee6FjwWxuMujAVRe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 08:13:36PM +0100, Hans de Goede wrote:
> On 16-01-15 16:34, Mark Brown wrote:

> >>As pointed by Hans my concern here was be sure that during boot the disk
> >>are not power off. In this case which property would be accurate?

> >None, the core won't do anything with the regulator until the end of
> >init anyway.

> That us simply not true, see my other mail gpio enabled regulators will
> be turned off *at register time* unless they have regulator-boot-on set.

That's not the core, that's the specific driver (which I didn't know
this board happened to be using).

--ee6FjwWxuMujAVRe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuWoAAAoJECTWi3JdVIfQFFEH/izR/KnypACxdtv6a63svd6L
KPE+tH6FoKUos0h/U6kD6XU4HlNKrnP5HTteU0hJAnLsrJU7BYmtRzin8mXKwEyw
NQX9ab1S6xLcJv/kKfwgbX/SFGCvhD1S1GiL2acs6TqkolLBziB5/pWcqLDzi8cv
ykhD3Vd5j5TXnKP2JDKRXRaK+F0/Q/ob/2hhfX8b70+sWze4E677S0UhRn89NDAA
NY8viI2JhVFbhQrdGoT0sR3xKhNO/ZBihtDcU3eFSQx7BquOAkoWJc8JTspmqgMS
eYUy7FjZYnGgcSVygsF3lsrvHa9pyOiApFVjmln5eQO0GB6pKxYuoE/VgteJzo8=
=eodk
-----END PGP SIGNATURE-----

--ee6FjwWxuMujAVRe--
