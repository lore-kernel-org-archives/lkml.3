Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbaIILZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:25:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58788 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaIILZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:25:39 -0400
Date: Tue, 9 Sep 2014 12:25:16 +0100
From: Mark Brown <broonie@debian.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Message-ID: <20140909112516.GR2601@sirena.org.uk>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410215046-31751-4-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l2C7pJE7HE4aLL3l"
Content-Disposition: inline
In-Reply-To: <1410215046-31751-4-git-send-email-jacob.jun.pan@linux.intel.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.152.174.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] regulator/axp20x: use axp2xx consolidated header
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l2C7pJE7HE4aLL3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 03:24:05PM -0700, Jacob Pan wrote:
> AXP20x driver has been extended to support axp288 variant. Header file
> and common data structures has also been renamed to suit the new
> scope of devices supported.
>=20
> This patch makes use of the renamed header and structure.

> -#include <linux/mfd/axp20x.h>
> +#include <linux/mfd/axp2xx.h>

Acked-by: Mark Brown <broonie@kernel.org>

but is it really worth the effort of renaming everything?  That's going
to cause problems for things like the stable workflow.

--l2C7pJE7HE4aLL3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDuObAAoJECTWi3JdVIfQ+p8H/iGfPM7c+ObHEgBC5s9ogh3t
bkogCkWlDwMlDjGYF8k7272clZenUvvvMZdiYpkYO9PvqipyjPKMBzb9vWgfQ4+s
lWao77aeZUzAleAAMJi0wiC6qmbqNkFozbpbugdzy7DPzPY7ip3L0lAStg/yvcQr
itdCReJPCQMYv+iHqsFRkmW43QoWk6zsX8fdaZQYyLt2mHYNlx2hWDPZubtyU3r0
pDZhc6zh3K1tcWX0ynLHXYWwUnpEBt71ecyGigTAy/lTyH8fZmMqyADMFCz8rLEB
0Vw/vSd3UMPRrkOaGWEx1v7Lq+4PzY3qymr19QWGvGvA8SLBW+CG34le1Ohzmmo=
=Q61h
-----END PGP SIGNATURE-----

--l2C7pJE7HE4aLL3l--
