Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaFKKzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:55:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36806 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaFKKza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:55:30 -0400
Date: Wed, 11 Jun 2014 11:55:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Dooks <ben@simtec.co.uk>, Brian W Hart <hartb@linux.vnet.ibm.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Christian Engelmayer <cengelma@gmx.at>,
        Christopher Brannon <chris@the-brannons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Lindar Liu <lindar_liu@usish.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Simon Wood <simon@mungewell.org>, Vincent Sanders <vince@simtec.co.uk>
Message-ID: <20140611105503.GG5099@sirena.org.uk>
References: <877g4oau2s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lO0Bl7Vyth644rr"
Content-Disposition: inline
In-Reply-To: <877g4oau2s.fsf@rustcorp.com.au>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PULL] modules-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lO0Bl7Vyth644rr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 11, 2014 at 03:03:47PM +0930, Rusty Russell wrote:

>       drivers/regulator/virtual: avoid world-writable sysfs files.

Acked-by: Mark Brown <broonie@linaro.org>

if you need to respin - please do send patches to maintainers.

--3lO0Bl7Vyth644rr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmDWDAAoJELSic+t+oim9/fAQAIRbHUfFokL6673lQ9NRa84L
9SahW3oNKISwvwKLfk2Q+hAaij1AjC/r3FNeFzpmSKciuL+MAWDVqOC0PoBnbTlX
amHnORR+lnfeQGW+a1/v4uabe0x0B5yEj7mcJ/Wf/Xbbg6ULpMsh7z7X073w/DoS
2E3UTYLapr787fmwT83fHE9livI0qxc2i2Qu5NitEuVDwwsqQaZckbgiXr08touC
382YLiUcJLMr616fBtV0rjUmuTIPN5KVkCVchuYw2+BY8nmIqz3kbHm4bHu2s671
kcrRB79RteUMcZ7oSu+EKaPz5pDSUlR8sLWQi/p7MjYh/uh829RHUtMm8xFUWmLY
JQ/16PEufhFZN2v46hUMhrfQSHoVBNGbHkTAasATtl4pVkHTolQjtC5ZKDchRpWg
OIW+ynRS48NrrkcLFyV7tj00Z5TdbASiBC/KlLFREjvPQk8nTXEoGNCr0M18gxpb
+dj3rloY3nGZ2I38HL7ry4MaaTd37eoFtBS4IY10qKJzENeEm7ZAfTWG2s151ca2
hyX2nloLkUM1VKZiS0MDHzFFbnly7xly98omN136MYSFkGzeSV+xq5xOwTFdqlSc
5wl1izFnUxrb5fZR4Fko0IQNdZ6WNu6/TbtgZ4ASDDaVlTbE/6KeDmIEYVaMMT7B
ywOz+6LEsmiqXHQU7B7m
=dy+A
-----END PGP SIGNATURE-----

--3lO0Bl7Vyth644rr--
