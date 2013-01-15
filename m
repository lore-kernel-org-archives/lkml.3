Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3AOMdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:33:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43903 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3AOMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:33:03 -0500
Date: Tue, 15 Jan 2013 13:32:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130115123248.GB2625@pengutronix.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <20130114161644.GC14721@kroah.com>
 <20130114221551.GA30020@avionic-0098.adnet.avionic-design.de>
 <201301142224.11243.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <201301142224.11243.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2013 at 10:24:11PM +0000, Arnd Bergmann wrote:
> On Monday 14 January 2013, Thierry Reding wrote:
> > It certainly sounds like a less complicated way to do it. But it also
> > involves adding a function with a made up name and drop a function with
> > a perfectly good name instead. I wouldn't even know what name to choose
> > for the new API.
> >=20
>=20
> How about devm_ioremap_resource()? Sounds equally fitting, and is shorter.

2 cents, I wrote back then:

* the new function is not named 'devm_ioremap_resource' because it does mor=
e than
  just ioremap, namely request_mem_region. I didn't want to create implicit
  knowledge here.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD1THAACgkQD27XaX1/VRsbUQCeO3T9fGRUTenwPGNdf2Wfow+S
2yQAnjkdp45Tk8czgujiurdGGiEEMDvr
=LQve
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
