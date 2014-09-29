Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaI2Ox2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:53:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52945 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaI2Ox0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:53:26 -0400
Date: Mon, 29 Sep 2014 15:53:00 +0100
From: Mark Brown <broonie@kernel.org>
To: zhang.lyra@gmail.com
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        artagnon@gmail.com, rrichter@cavium.com, robh+dt@kernel.org,
        will.deacon@arm.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140929145300.GQ16977@sirena.org.uk>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
 <1411992293-7729-6-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7a4X6VOqfbl9xMrG"
Content-Disposition: inline
In-Reply-To: <1411992293-7729-6-git-send-email-zhang.lyra@gmail.com>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/6] tty/serial: Add Spreadtrum's serial earlycon
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7a4X6VOqfbl9xMrG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 08:04:52PM +0800, zhang.lyra@gmail.com wrote:

> +config SERIAL_EARLYCON_SPRD
> +	bool "Early console using SPRD serial"
> +	depends on ARM64

This code doesn't appear to be ARM64 specific so adding an ||
COMPILE_TEST will allow better build time coverage for people doing
generic work on the subsystem.

--7a4X6VOqfbl9xMrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKXJLAAoJECTWi3JdVIfQ4+EH/29kwPtZqDhjc8wQdHiqtQ7E
85VEKtfT+bFoRj5g9omJdlalO9biUiDHtIuZmll5RX5gc3I0/H66qXyImMnCODUe
VdhGFHvGLjfUnKrMA1ekD2pP3VhrOrQRewJah+Ymw1HWJv+HHMccNOPSL11LDSE9
nysGM1LQWv4vsTOIaKxN/pwLl4LscOhm8Txp7rOcW3GWTTfhpCg9S/+0jNx/vbTk
aWKwA5VHBscvigVmWBK/0aGVD9SENUP1oRJ6pC51dKmBHGOysD5JhHiz1cBDLjpN
G/BLDDOmZWSdON3gGqhJosWP1Wv3tJPz1zpCvyQvfyfcJSYj4gf2mYEv9x7Ekv8=
=MFRO
-----END PGP SIGNATURE-----

--7a4X6VOqfbl9xMrG--
