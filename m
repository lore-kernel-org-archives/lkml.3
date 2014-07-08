Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaGHIIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:08:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52287 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaGHIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:08:50 -0400
Date: Tue, 8 Jul 2014 10:02:32 +0200
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Fabio Estevam <festevam@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>
Message-ID: <20140708080232.GQ30458@sirena.org.uk>
References: <20140706070800.GA2927@himangi-Dell>
 <20140707144832.GL30458@sirena.org.uk>
 <alpine.DEB.2.10.1407071655171.4757@hadrien>
 <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com>
 <alpine.DEB.2.10.1407071721270.4757@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dUqh8vgUBVXHzm9w"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407071721270.4757@hadrien>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dUqh8vgUBVXHzm9w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 07, 2014 at 05:23:39PM +0200, Julia Lawall wrote:

> There is documentation about what kinds of devm functions exist, but it is
> too bad that there is no documentation about where they can be used.
> Often there are several levels of function pointers involved, so it can be
> hard to figure out whether they can be used just by looking at the code.
> I have only taken the strategy of using them in kinds of functions where
> someone else has alreadyy figured out that they can be used.

It should be fairly clear given what they do I'd have thought - the
devm_ functions tie the deallocation of a resource to the unbinding of
a driver from a device so they can only be used to replace things that
get cleaned up in a device model unbind path.  There's not usually a
great deal of indirection going on in those.

--dUqh8vgUBVXHzm9w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTu6WUAAoJELSic+t+oim95awP/jjOLSCVkX3YiKWWl7qzeCSV
cDIMQM8qaRoi6u8f2LVRYugp+kvCa3IZScM7L5nVywcS1mHgWxtVexuoQQbJ9UtY
X5TjJA/SNzA2kyIFFcSK66+PmOoldszq+Yjefs7OHui8ecA3o4k60AJeA1IL8Nk/
zit7PhMrJYeYgsTZ0pGX/MVV8ow0a3ayglXyvqGeGoK/2J44v1p6+MjPwcd2QQwl
I9RHyPbMTUreFsLPDelQfHhHD0BoAF5qb/EDvmdQVpiWZ6PyJIR0WloLZepOiIoP
DJ/FjhQozqa+s9qCA8GTXAAE1isRGvz9tHNJWL0s0tObHAHpwW2lqOXeKo1BRuxh
6vVPBTfUYfN4+/ZGZ0ExNwmI6YRecG9tpWe2KX7uZjjocAI0NCHvlBzibXgKtwUd
B8hXsIOjHXruESQmbZrfH4M8VPoc/BBqJ6xGGkq/Skg9EWvdIDgHofjU84ggBljD
vygIgzRslvd3QoKA/oEBna+k91lJvdJt2GbhUw1Y3uYnhNpfv2UNSLnYGlbCyszF
YEQj7yLXUM7kG82t+t8Eg/HBaA5coGFu9sNkZ9Muj4tUylgCLPZdpgbcjVVtLndd
F+rFzAa/o3gMpNaevo5ka239PEEweDyXL+ERr7CV/Sbdx67yi/AvvNXIeWsT0fU1
AIPRF/WSmpV9hoRwOZYL
=Ccns
-----END PGP SIGNATURE-----

--dUqh8vgUBVXHzm9w--
