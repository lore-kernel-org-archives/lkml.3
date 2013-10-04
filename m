Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3JDK3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:29:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45429 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3JDK3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:29:06 -0400
Date: Fri, 4 Oct 2013 11:28:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Message-ID: <20131004102839.GJ27287@sirena.org.uk>
References: <20131004010230.GI27287@sirena.org.uk>
 <524E50DB.3060707@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TOmSpbqtysumMR8M"
Content-Disposition: inline
In-Reply-To: <524E50DB.3060707@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 3
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TOmSpbqtysumMR8M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 10:23:39PM -0700, Guenter Roeck wrote:
> On 10/03/2013 06:02 PM, Mark Brown wrote:

> >Due to the length of time taken to run all the allmodconfigs I skipped
> >the defconfig tests; I know Olof has the ARM stuff covered in his
> >autobuilder.  I'm going to use allyesconfig tomorrow since that should
> >run faster so hopefully I can cover the ARM, i386 and x86_64 configs
> >again.

> I could try to set up the buildbot farm I am using for -stable candidates
> to also test the -next tree. Would that help ?

Yes, that'd be great.  Like Olof said ARM is pretty well covered but
adding more platforms would be very helpful.

--TOmSpbqtysumMR8M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTphUAAoJELSic+t+oim9SBgP/iZJjEyCYWvdMVOAcC9+0qv9
u6+JuRE53zwzdFD83UGBr8v1UdjSx3K+Zrc/7+JFr7Gs29OJjUd1fWqackKDX/8g
CkvKyOCJRReKik7DG+8Ws2jmqdZnE9hiy/90FhVdpYxBBnHWoOcOYcQvUDc2rmJ2
MsHGtTdYg7CEPV940uO1T3U9f/Illp+dJk7ulGGjMRuQqsiAZuwDdQcdVTrUj7L7
aOLIWXAml9jderO8Y/IPNfooP9pYSd9RZxJevFUbvoieNCNVtMNeRZJQOMcWjy7e
UiCFKVHCFS4PT86oHgIfxJTRn3FPUFdKZBxiflPUMzbzGKoII6kfuurImwOTvmzI
7kVuqvuy67s642I9izYDjHkew2eRbR4ij9r5ykjZrMwEwNRHcecRpMcCPl0tMB02
Qc1TW/Xp/B8eLvw+R4x6tAja5UUv0c2wGhzTwpvBpzZRAiiWuuX3CdIJnBoG4RBc
aq+DDgwp2VF0TIqqPfsuQvsDpjdzO4YuvyHBxCcs1beuzbIyEVVNbu8EEdCbmlsZ
tIX7HXM0FU5bVkY12RxR5mEX9MwoKo+eext4uDSBi7tqKGDYV+rnSSsoJSYKJf5Q
iBqULCl59y2qCX3sdWYkjcCZBpET01qvOREcgB738ICKZ9ldwSUoHYDJh9QablFR
p3qQbXBZXLBqrzP5xbuV
=5t4Q
-----END PGP SIGNATURE-----

--TOmSpbqtysumMR8M--
