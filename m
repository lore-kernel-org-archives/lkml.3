Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3H2KlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:41:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54062 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3H2KlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:41:12 -0400
Date: Thu, 29 Aug 2013 11:41:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Message-ID: <20130829104102.GS10783@sirena.org.uk>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
 <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
 <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
 <20130828083630.GF19256@mwanda>
 <20130829011848.GA16891@teo>
 <20130829020714.GA26347@kroah.com>
 <20130829030715.GA20317@teo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7lT8fFUc+KaZWT5W"
Content-Disposition: inline
In-Reply-To: <20130829030715.GA20317@teo>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7lT8fFUc+KaZWT5W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 28, 2013 at 08:07:15PM -0700, Anton Vorontsov wrote:

> These changes not so much burden for me personally (it was actually easier
> for me to just apply the patch without all the arguing), but for those who
> actually do real bugfixes/features in the drivers: their local development
> trees will produce conflicts. Solving the trivial conflicts not a problem
> either, but irritating (especially realizing that you waste time resolving
> conflicts because of the "just cosmetic" crap).

> These days I don't code that much, but I was in that boat resolving
> "cosmetic" conflicts, and I did not like it. So I'm trying to solve the
> issue for drivers/power/ developers.

This sort of patche can be helpful when doing work over multiple drivers
- making the code more consistent means that it's much easier to pattern
match when looking over many different drivers.

--7lT8fFUc+KaZWT5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHyU6AAoJELSic+t+oim9n2wQAIOqADqABMmvk3JM6as4zu6t
tdntf/Ub8hs3iTlvdE5wJuROiHy+k2FLEu9Dbh8a3VKaodRHA7V1N0K1SpHFgC0O
qW4OLVs2wMAFKgt9RpndqybkF9FgVJYolfLeF76bSMEBeFo10hm40Zr7LJ4UtPj8
i7pQJcUoYYKo03EWywhoE/i2az+n7Qdew+iWQoj7uFeeh6OKzN6E3XrfdQtbZVWL
KOKH/nYh3Mdz8AM6VM+rjkYyJFdpK7YGXefI7iS3qsM4awaVzcQeV0+wx5NsxeB6
BGstRGyJkAMfFvJnWvvXpGBWbt3HQf9oj2DKAIkM4S7MpcZsjgBHwfXkbDO1ZI0x
VtKjP3MR1RGY76THvDaGcfJiU40lGhsZZ6/rAbOEyxWlAktVqbHAHKhWcHD0fdj3
zYTLY7NmY5FF7p2/LFngMKW3PeuPQrIKS5PVd8n25d7mz5ir58TQx1lXrsPDuTxR
plLG6979etcfW1OF+d3b/XH2gKsRl6R6EdsGIAD9dmyF0/lUh/9IW2gVwE7V7mxD
HLNWm4I6qW6VpWDlSwFGFtURSq1CNYymzAtvoZA3YHCEMiNM3AEIZtMegh6W2OCN
3kROzsFmFUAcS2a01qNHVRoG3R48nIfpIUHJ2raauCXjBV5p/8g8AZSgV1q88G2f
/EQAFSY42kEiW2kCF2FO
=eqfr
-----END PGP SIGNATURE-----

--7lT8fFUc+KaZWT5W--
