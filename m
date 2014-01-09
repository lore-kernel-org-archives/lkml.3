Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaAIRYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:24:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50255 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaAIRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:24:08 -0500
Date: Thu, 9 Jan 2014 17:23:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Trent Piepho <tpiepho@gmail.com>
Cc: Daniel Matuschek <daniel@matuschek.net>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Dimitris.Papastamos@wolfsonmicro.com, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        patches@opensource.wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20140109172350.GD12858@sirena.org.uk>
References: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
 <20140109142745.GB6110@opensource.wolfsonmicro.com>
 <9DF5D0F7-F5A7-4705-8ACB-286B49D668C1@matuschek.net>
 <CA+7tXijibZKUoeqeqpvOhgJg17OgpYR2Kv5S17TFdAKvaCjt3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
In-Reply-To: <CA+7tXijibZKUoeqeqpvOhgJg17OgpYR2Kv5S17TFdAKvaCjt3g@mail.gmail.com>
X-Cookie: Gravity brings me down.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8804: Allow fine-grained control of
 the PLL generation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 09:14:07AM -0800, Trent Piepho wrote:
> On Thu, Jan 9, 2014 at 7:29 AM, Daniel Matuschek <daniel@matuschek.net> w=
rote:

Daniel, please take more care with the CC lists when posting things -
there's nothing to do with device tree in this patch but you've CCed the
DT list and some DT people  wich means more noise in their mailbox.

> Why does it need to be an option?  If 256x is better, then why not
> always use it?  Maybe the code to select the divisor should be better?

It's typically a power/performance tradeoff, though for this part I
can't see anyone caring about power.

> Since it stops at the first divisor that works, won't it always use
> mclkdiv=3D1?  If mclkdiv=3D0 is better, why not just list those first/only
> in the table so they get used?

This seems like the best idea.  I suspect the table just got typed in
=66rom the datasheet.

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSztsjAAoJELSic+t+oim9gE0P/0l6+oXalf9431TiGjgeDE8D
MT22FXJ7cupFaIdEUY4WO0X+MKsz+d7VJnn2ff6lAQkj/C9Sm3v0cD0ar1Tjh+pl
noKNhtUYbgdaLuIrUtT9TkI3aOJCasrUdVcD+InrWmaHZdRh/KYWpYdQIrE/K5hW
6npdEr24umuMwIce6G2/bvTapup7JTv8advdmS/ozUEB1VKxYEwFU9tjHrZZLJxc
tNb4XF8Oy1zO3qb0E56XxCgQup2vhWDRTAEsq7Jkpm45Iz7EDUlFZAvQLY9LzJn2
jt6LRRf3QldUlsoEyhxpHPEoG1y03IEQp5vVLEJ7R55JZfNjzCTNyyTx+5v5rk8X
dL9whioWLAVb+N6IGxaVrZmWXdF45H4l5LwjY3KwTJ36AeaboYeGSW0ZhScKgJRp
eHX514sV9eTfJn/pG3YMAZRlH6YQ4JGAaQMKwsdrUCsY4nAXuHFcmIqAY7/m1ScW
k2XOM5SnR3E6SA1B4+zgVDJ9vG3yKC9sM6lmzl8Au8YfDiHu8mSSYwywggPmixCy
dXMcsNckXLRHEvAYEgi4fjQGDShAw2y97LkOrgdCxLf6WaMIZlBSggnFR83wpnKf
gLX9/E0UNOPSrQMYx163QbvY2IzDztROXzaFIlUTH0zI14Sld0zzAPRl+x7smf/p
RlCw+zVjcUv7Y4C8qzll
=fskv
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
