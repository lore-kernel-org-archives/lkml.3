Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBPB60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 20:58:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42120 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaBPB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 20:58:25 -0500
Date: Sun, 16 Feb 2014 09:58:07 +0800
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <monstr@monstr.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140216015807.GX4451@sirena.org.uk>
References: <cover.1392045742.git.michal.simek@xilinx.com>
 <5998a942a3dbfb2ef965d000168cbd7007315630.1392045742.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/9WPmgm2v60RN0g"
Content-Disposition: inline
In-Reply-To: <5998a942a3dbfb2ef965d000168cbd7007315630.1392045742.git.michal.simek@xilinx.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/3] regmap: Separate regmap dev initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9/9WPmgm2v60RN0g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 04:22:33PM +0100, Michal Simek wrote:
> Create special function regmap_attach_dev
> which can be called separately out of regmap_init.

Applied, thanks.  I've pushed a signed tag too so dependencies can pull
this in:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev

When sending things like this that add new functionality it's often
helpful to send the patches adding users to review along with the core
patch since this helps to review if the usage is actually sane and
sensible.  From a purely regmap point of view this seems OK but...

--9/9WPmgm2v60RN0g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTABssAAoJELSic+t+oim94oEP/3+E03QGq1vIpUsdBsZUkjJr
deibDwXk81tkfVOwjIGDycZPM0GU6oSSNTq3K3dUnnQRUhYprWB6GJIFW8fc8DQ+
t4QCY1aDjLXu5mwLyTcBd+uqDQYfrKA2nkOlhqvwfYkQ9t2vL2TDW67iVXGa59/X
oiMHtTfCdf9RiKFD0rilF5ozDUaCh1TkzwjlHvV4GfuUbRga07pyw+nK7tcrMLsD
223Te72T3sf0vhcsznxopEY0Ev83oKZIQ3jv9TenbHUmJGZsa6FL6mEZzUrO8mR+
S+WiVT9O9obDJsk6CmYV70SE8O1PIE44DaW7sy2M6mqyH8EUhrmrmAKqMa4Tj+si
Rh3B9REaGvtOlsKbd2EszP9K44k5lYWblidIVWtD6vJGTYEftYMdQK5L5ajZJsdA
F04KE9YHNqFmVRey9UPX7IzWP8hXi45L2+yyi/HKs2s1VHqWfWGM0NxYon4/FUSK
gswLDEubgG7Ksw4z2A1aXvZ/Drghyb125Fv94BG5ZLFvleYsPQObf0eUthGzANsQ
1h44sw+QxBm2gUkfP32vRyogCrEjW+tgGcDaAen7t3bQl/Q3bT7q7278cDEmWKBo
uzPJKltjzUOPRe5IdXdrOSiRk95UCSRrri7kQzdUt4cYTFfcF53x54zPOaeS/RAg
3y6sTE0Xop/S2nku9gKe
=Py/5
-----END PGP SIGNATURE-----

--9/9WPmgm2v60RN0g--
