Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaGCQVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:21:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45153 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbaGCQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:21:33 -0400
Date: Thu, 3 Jul 2014 17:21:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, dan.j.williams@intel.com,
        lars@metafoo.de, tiwai@suse.de, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org
Message-ID: <20140703162110.GK410@sirena.org.uk>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
 <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
 <20140703120153.GZ410@sirena.org.uk>
 <20140703120256.GO2296@intel.com>
 <20140703134210.GC410@sirena.org.uk>
 <20140703161708.GR2296@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oqiVxqbeHx5cy56u"
Content-Disposition: inline
In-Reply-To: <20140703161708.GR2296@intel.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] ASoC: generic-dmaengine-pcm: Prepare formats mask
 for valid physical sample sizes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oqiVxqbeHx5cy56u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 09:47:08PM +0530, Vinod Koul wrote:
> On Thu, Jul 03, 2014 at 02:42:10PM +0100, Mark Brown wrote:

> > Well, I was expecting either ASoC or core ALSA.

> Ah okay, wasnt thinking ALSA, either ways am fine.
> Usually its asoc/dmaengine :)

Yeah, I don't mind - I just figured if I ack then I won't be blocking if
it's not ASoC.

--oqiVxqbeHx5cy56u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtYLyAAoJELSic+t+oim91CkP/2QNb8/0aLn5Q+lgEE5q8hUV
DxuGNyUg+QL3WDEKJHatF0cgnzauEvuBFu7dwY0MeKTF5ctOtVxMqyAFODpt/vaU
2CPIB5DmW0navuMmya07nyjoWWm6lOhUq2eZhMQc41OgXuMrRNL0fGjK2jqzCdFe
Tb/WEohuDFRrW3uc7ywTXA4pnJ/qQMuMTOVJKEw567cL5qCqZ39zGV00PPzsU4mh
dBvbEGycss3S8qBCqaBwByFkjmqKMtDrfy81zmH4jofsW19sLX3LLtOkwqX0Rol4
l3qPD64x80i/5tDB1ZZ7OD9lTXXZNYnKr3V5R0XGMm1mmunlki5GLp5diMtWovHC
tA8mzn8SW2XNxJthK9+eJh0wUjzwCptDt+mg2j9qw68sk6dSyqENiG+gNglAROFz
tCk0w89TuzvIBYgBh0qjisA89KaUHBBu3/ot9D12NVciNi5+37WYup/WQ1jkVEaj
s2mk5sVfx5n+kap9x2F/4P9BYYGpZGxq0RUHBcwxAZ1lrnsO9dA3N+KvA9jbPWmo
+Xez42qJMSln+DdVC6Lz23nQPwaIe6XFg7OYsntGz5dkZed49WuIYcoQrqoAtMJ8
QkZLMMM9kMuGiWYM34PI8+zO8f8JQf/ATb969jHLQRIoIlEBJUjllrQh9Z7lx5PL
xxhr0rnt3AMNJK7ijwQ0
=LYEL
-----END PGP SIGNATURE-----

--oqiVxqbeHx5cy56u--
