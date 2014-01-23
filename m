Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaAWMaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:30:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58545 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAWMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:30:10 -0500
Date: Thu, 23 Jan 2014 12:29:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140123122959.GJ17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140121185553.GW17314@sirena.org.uk>
 <52DED341.3030503@ti.com>
 <20140121215624.GC17314@sirena.org.uk>
 <52DEF56C.1000209@ti.com>
 <20140122201932.GD17314@sirena.org.uk>
 <52E02E85.3030509@ti.com>
 <20140122222523.GA4999@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6A1TVAKxAUhQ4PCu"
Content-Disposition: inline
In-Reply-To: <20140122222523.GA4999@kahuna>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6A1TVAKxAUhQ4PCu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2014 at 04:25:23PM -0600, Nishanth Menon wrote:

> How about something like the following? If this is acceptable, I can do
> a complete round of retest and ensure everything is functional on all
> platforms and post it as a formal patch:

Looks OK from a quick scan.  It seems nothing in mainline is using the
-v2 binding so it's probably OK to delete it but if it's not too much
bother it might be better to keep it since I expect some downstream
trees might've picked that up already.

--6A1TVAKxAUhQ4PCu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4QtEAAoJELSic+t+oim9i4UP/j/141Y4ZJbFdLqvLhqX7LVQ
jjYEOwyGFqgUX4o/unC4qqi1OW2tkrsLuziteAwbfezv7cZjUA5hO7aW/NLjSL9D
yMEKVudJuOHi9KJBy4SdKuRMJfXt7DrYVkmXxSDvxRNrOJmwdXVUrUk2tYkllSii
p+dGvMk74Yavp9LEPvEbdLwyA/xd1KT+IU7yhcOZDJGpChlg0AhBGCvgFrT0eyDk
jLx9IN0gslwGxVpsusm7YLe57Trozz3ApruuMx+pOA7YHMCWGX3rMxgxNShXggMH
wnBzXlzh3PN12te3Z0uo+IKYATB6dpZfaY8QwQNmqP78MbMPLE5Z3QVDO4FLkKnk
ekQ3juyzGZD6E+j16ZU+Wb6owQIlMXndKygAIymszWHc2zlkETOubyKI46qxeceB
TugGuyE4GoLubgVjyapcuwrwXLpgAdsuiYH7ur8Xi2znyNIl8pWVQlkrj32Jxfc3
qt2ItDYzeQWsY8YLiPnFmBPnDgqrkZYZjY2zRylQ/gfKUV7U47g8Rfx4zY0fDw8P
Ofuw43QU75uKG6gJ1MEGEAGVUQUr7cIReaysj2M158QPrDTAKnEyUVTCz2mDWNTf
gn4e2yPBP8MvrOcqV9ViaSNMaFjRPwif5Oz0WyC6Cdogfnc13MxZ7sjUQMh3gf3J
e3FJDKzi5hlePBRBc1mz
=fKAO
-----END PGP SIGNATURE-----

--6A1TVAKxAUhQ4PCu--
