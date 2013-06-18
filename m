Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3FRIgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:36:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53561 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3FRIg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:36:28 -0400
Date: Tue, 18 Jun 2013 11:34:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jiri Slaby <jslaby@suse.cz>
CC: <balbi@ti.com>, Michal Marek <mmarek@suse.cz>,
        Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <jirislaby@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        <linux-usb@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-geode@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>, <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] build some drivers only when compile-testing
Message-ID: <20130618083425.GI5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369214326-6558-1-git-send-email-jslaby@suse.cz>
 <20130523022327.GB6159@kroah.com>
 <519D8876.9050405@suse.com>
 <51BF6BFF.7050705@suse.cz>
 <51BFE754.5080301@suse.cz>
 <20130618081858.GD5461@arwen.pp.htv.fi>
 <51C01948.9060708@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svExV93C05KqedWb"
Content-Disposition: inline
In-Reply-To: <51C01948.9060708@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--svExV93C05KqedWb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 10:24:40AM +0200, Jiri Slaby wrote:
> >>> Sam Ravnborg (the kconfig ex-maintainer) once wrote that he
> >>> doesn't want to extend the kconfig language for this purpose
> >>> (which I support). That a config option is fine and sufficient
> >>> in this case [1]. Except he called the config option
> >>> "SHOW_ALL_DRIVERS". Adding the current maintainer to CCs ;).
> >>=20
> >> I agree with Sam. 'depends on XY || COMPILE_TEST' is quite=20
> >> self-explanatory. And even if it's not, you can look up the help
> >> text for COMPILE_TEST. With "archdepends on" or "available on",
> >> you need to know what to look for to override the dependency.
> >=20
> > you will still end up with:
> >=20
> > depends on (ARCH_OMAP || ARCH_EXYNOS || ARCH_DAVINCI || ARCH_PPC ||
> > ...)
> >=20
> > And every now and again that particular line will be updated to
> > add another arch dependency.
>=20
> But that is perfectly fine *when* the driver is supported on those
> archs only.
>=20
> And come on, how much often will this "every now and again" happen? We
> don't have that much cases where a driver is augmented to work on
> another arch or platform. It either works on all of them =3D> doesn't
> need COMPILE_TEST, or work on one or two arches at most.

MUSB alone has 8 different arch choices. Before, it used to be that core
driver was dependendent on all of them, so whenever someone wanted to
build MUSB for another arch, they had to introdude their glue code and
modify the dependency of the core driver.

Also EHCI, it works on pretty much everything, so does DWC3.

DWC3 already has three possibilities but I know of at least 3 others
which could show up soonish.

--=20
balbi

--svExV93C05KqedWb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwBuRAAoJEIaOsuA1yqRE8NgP/0SPxsOBuTHMy2orol3LighN
pJRgtLCaxN0/ODQnK+riD/mpw7NuneUsqAC4ULib79QEXkL8nNSjL5s2aaihO4gg
vbW+8UYXrWw8rVX58b4dr0MNqwm0n6qXIs3hXJCx9Dv0wi/DfoKN+XKaZALFvP/U
lzUAbzVTlehZXrp1b4Nc/jYaX1UP85o7JPbyy6S7+G5bYkfNDWCy24xZYO8gAzF0
F0yCJaFxTvgmTTjeSJDzpYLbt9NFl6IOKl5RMuBUszJ/T4hADWcjveol9y1wfzov
EauHIcrgnTgn8nqzYNbdSVoMf+w62GsaJcF8M7fG84FMNnNiuoSB5YGLj/sRJjG6
CgY5SMYFTk3EAsWKiN8uW5mpQixGa0g4bUJuiPiON/zMPfJukDr2jMcqyquK5U8q
eurgbZYomNAz4HPUP7BD0u8BTrcVZp9EYiyiEsK6+O/9lf/bkc+Z5Zr3PdDKjXH6
eXz/MC1XwBdJdqUscHBtyQ02QY5ZDUEH/BPYoFXm2BYxV2wYO8aZox/V2NYCbLWV
mjOlTyw0qSQALN4i5FAy9gsJ6FgTyOh/IoXdftd6+EEg9/RmyodQb+qBYgczJnO+
Ske0XR05jrBz2AYDn15dHm6vi3W15CYGAHLJpS//w6H+IKDG8FTfUk6HKKaeNnUS
xcMNkoxmPjO0wiKsjIvl
=MDJ7
-----END PGP SIGNATURE-----

--svExV93C05KqedWb--
