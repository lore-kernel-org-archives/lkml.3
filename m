Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3ISOBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:01:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60616 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3ISOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:01:48 -0400
Date: Thu, 19 Sep 2013 15:01:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130919140131.GB21013@sirena.org.uk>
References: <5237AB72.5020806@infradead.org>
 <20130917103238.GM21013@sirena.org.uk>
 <52388CC4.7040101@infradead.org>
 <20130917192355.GK21013@sirena.org.uk>
 <20130917233328.GC11390@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a3TIYp8vN9YM5Qs8"
Content-Disposition: inline
In-Reply-To: <20130917233328.GC11390@localhost>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fix fatal kernel-doc error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a3TIYp8vN9YM5Qs8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 18, 2013 at 07:33:28AM +0800, Fengguang Wu wrote:
> On Tue, Sep 17, 2013 at 08:23:55PM +0100, Mark Brown wrote:

> > Could these checks be added to Fengguang's tester?  If nobody's looking
> > at the output (I've never found the processed output useful myself) or
> > running the tool then it's a bit worrying...

> Yes, I'm running "make htmldocs" checks and send out all new warnings:

> Does that sound enough?

I'd expect it to be but then it seems like the issue that Randy found
wasn't picked up...  not sure if there's some other build that would
cover it or something.

--a3TIYp8vN9YM5Qs8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOwO4AAoJELSic+t+oim9xncP/0LzUY8/HSIHrHh0B8Ko5wyG
xz9ryt7rQJmri39CeOlG86XgX5T4gNAlhn5pgemQB2VChxOQ4JcRDGdGnbuF8nnj
3UVPAGRMW7c4POgbvlMLvjqPqTX4H5KJlXQUrV2J5FHommXNOHyZR9wGA1jomClk
SgLjZHP5i8sBUKSnU964xmQkgrwivgYNqI4IKHYAQstDPfzosu0KNAF03vtdZ8WW
Y6yk5qLFwHZi5Mgk7E4UKnwQFwKRbTQFk7U40vl3wXD2BCoa2c+JMBXJiHdyqzdj
kS/W+NIF7Rn+y/1uTTlW71sfVOnid62M4PobNU8ovIi/WxrA41xkSHdLgNliyZEN
sfmm+hLZVKVoZAGaZPIw7WxEDcUJCPjkjEMVblk2mvZrz/FJlaB381bdT2R3MGyr
gJ7f93PoN4thXYXA+ticbY3X7dfmT7dfsYY7xVojgob9ZRlCsAnRZN5ztAfr4GE6
So6odT4vSA4igcYn89XEbBhA5wYYlOaAZrk1WEuV8XO00QypJFwpxON30XJ90yIr
zEQ55PRpZrE8mRY7WSfRWRQTZHQEetlxh63bZ9KRmRGecCfQp/kgm7uCFEuS3x94
24HwiE0f6gSFypM8Js4jwV4Ck5Etlmyvfu3W4w73OuUi+twg3NmoVS08u5NKun6x
e6DkPYy2LkofbHfTwVAq
=SI1G
-----END PGP SIGNATURE-----

--a3TIYp8vN9YM5Qs8--
