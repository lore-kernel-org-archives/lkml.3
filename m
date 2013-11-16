Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3KPMXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 07:23:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41555 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3KPMXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 07:23:16 -0500
Date: Sat, 16 Nov 2013 12:22:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Florian Meier <florian.meier@koalo.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20131116122244.GV15393@sirena.org.uk>
References: <52864BBC.7000506@koalo.de>
 <1384537403.14845.131.camel@smile>
 <20131115175155.GQ16735@n2100.arm.linux.org.uk>
 <CAHp75Vf3CJNgSiSjoZ6dYjRRHWN4bTpMxRTLG37+wwtEsQbq4g@mail.gmail.com>
 <20131116112754.GT15393@sirena.org.uk>
 <20131116114134.GU16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XAEV7zm15O60d1Zf"
Content-Disposition: inline
In-Reply-To: <20131116114134.GU16735@n2100.arm.linux.org.uk>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.99.68.145
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XAEV7zm15O60d1Zf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 16, 2013 at 11:41:34AM +0000, Russell King - ARM Linux wrote:
> On Sat, Nov 16, 2013 at 11:27:54AM +0000, Mark Brown wrote:

> > We should in general be moving in that direction however it does need a
> > bit of care to make sure that there aren't any dependencies which do
> > things like discard error codes, fail to check errors or treat errors as
> > hard failures.

> I don't agree: on platforms which have done this, it's very difficult to
> tell from reading the kernel message log whether things came up correctly
> because there's soo much spew from deferred probing it's virtually
> impossible to tell whether component X initialised or whether that error
> about resource Y missing was ever resolved.

I do agree that deferred programming is far too chatty - there's a
usability issue there.  This bites me a lot on some of my systems too, I
tend to read my logs with grep a lot which isn't awesome.

> If we want kernel boot logs to be useful, we really need to shut up *all*
> the drivers and subsystems whinging about being deferred probing, and only
> have the driver model core reporting this status - maybe only allow
> output about why at debug level or similar.

Yes, some sort of standardisation of how this stuff gets reported would
give us much better control of these things.

--XAEV7zm15O60d1Zf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSh2ORAAoJELSic+t+oim93QMP/0Qjk6/RJpBDydqp3w3H8C97
7tfDVulAYjI8vhhhvIH0nuicpuYG+hJ/6ZN2t3C+m83HuUJaNJG4Q557zIURROQS
IJ2tM0jMt+z7NbceO/nsj0CU9YBNwoTAP9p9lYarBzJqX1KmZQ/lR1MLMKRfMzPq
19nyZGrjKUHT/oLyLa6SveQS+0I4huSBaQo4hN4nF+xQfq3z3gmXopG5zxvEGCA4
HxYlobn+xhjBf+VrYTp9FkuVL8NMo7KJ7oYma3d8/CD+r55iZIBmVyRNJQYASPhY
lLQ1UXjfFCf/HgBQJBCCwXisdG5QBtrg5aAHXfGm2+Lv7SU8rNXJqiRRLA8TiuSv
bNCySFk/xL/EXwOq5oSk6/pdn4E+/ZCrPPDu2AZ31jJI9IdR1KnxU1RKcpjXtDxZ
7+Y1bmDK64SJMY3xpQhK6vflEV2eAUMvIbA9WSjFC4n2AXXs/TQ4QWxnyJZCw9Qa
xYYwLelrnncXUH//clp+2f2cBy1hflbkLAe+zdVguVNFlOU1oX4UsnMN+NPtoIdn
Va4r+yiCE6XY6VEMXX8ICwFp6pG3qZqL/gDC/sM95874PM7iVFDd0aVKonFMjfN7
kGtQBK/9nxeMA4DqWKZZBqS+XYtDFRroO8/73d7QXT07TwTRPFP0yH+PJrSQ7ZsY
idZGXQ5X03IdPTlvhHxj
=NCeP
-----END PGP SIGNATURE-----

--XAEV7zm15O60d1Zf--
