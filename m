Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaD1XPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:15:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54024 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752002AbaD1XPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:15:06 -0400
Date: Mon, 28 Apr 2014 16:11:08 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/5] power: reset: Add Allwinner A31 reset code
Message-ID: <20140428231108.GO3134@lukather>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
 <1398265476-29373-3-git-send-email-maxime.ripard@free-electrons.com>
 <535BD18B.2070902@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xn9xNsWbHJd/50IB"
Content-Disposition: inline
In-Reply-To: <535BD18B.2070902@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xn9xNsWbHJd/50IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Apr 26, 2014 at 08:32:27AM -0700, Guenter Roeck wrote:
> On 04/23/2014 08:04 AM, Maxime Ripard wrote:
> >That code used to be in the machine code, but it's more fit here with ot=
her
> >restart hooks.
> >
> >That will allow to cleanup the machine directory, while waiting for a pr=
oper
> >watchdog driver for the A31.
> >
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> I am a bit lost here. Why is this a separate driver, accessing watchdog r=
egisters,
> while the other reset functions are being moved into the watchdog code ?
>=20
> Any chance to handle all platforms the same ? Seems to me that would be l=
ess messy.

The A31 watchdog is actually a different watchdog from the one in the
other Allwinner SoCs, that probably needs a driver of its own, or at
least, a significant refactoring.

No one did this yet, but eventually this will probably happen.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xn9xNsWbHJd/50IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXuAMAAoJEBx+YmzsjxAgkNkP/1LQT1hZOfuT8L/W6IjZrgfN
RL1PMivnmDRt2UU0MvBXRV4gRnkafIuwHG0fZK2rruRMF9OsjuKIacA/Xf2l7m/k
B8CwETTkuufe53KanN56BTB6wJ41+VvufvKn/T/S/gurywjM7Uas1D4lL0TFQ1aF
9v7tE04P2cjvkJo63UkeMSP0Pl1uM64+RwmifFDsV3MGAQJZbYCCFgTxfhhlD/qV
QmkWVxql8+OH3GnnVm/ghXfSe82PU7nCtIBaTzKLQMoUpNtaiCGrzXC5SWy9S7Q0
GsVfUldqAFmWqlM3uOGWC/4Zg7PMRKBIywul2wp8molrebFwknqygl2nu1mjQ9ss
lObFTuxL/olMUe9O4BnZiZaBOXZolFHIpwiH9AtNpLH04UDw79P1D7h+gIjn6A15
gSAqV0UfpAYmuqdjz1Lpr4wE52sBqcHkf9JuZB3TiQbaxrRu6+ycadVB1ggk6AaU
4sVilzzAeaspzssWFeZIu8EfCV/iZNSgm3J9wjHkKZcdrJ5TAN201Fry487SYWV4
E1YnhVHPNC2YdmucLWQBugmLzqznfxrj/mKPaa/ouEFbC4yLhVPgHKWvXkeHemTB
nuUFNxDE6a/laijcG/rUD0oZvMxurUtlxWpqdSyCLa5BBDKh43dGNrruVf46erc4
vh5DWLukgIt3l8AQ4r9t
=qxiM
-----END PGP SIGNATURE-----

--xn9xNsWbHJd/50IB--
