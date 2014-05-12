Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbaELVGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:06:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42754 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaELVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:06:12 -0400
Date: Mon, 12 May 2014 22:06:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>
Message-ID: <20140512210600.GT12304@sirena.org.uk>
References: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYzpe8yYzYY7Vx+e"
Content-Disposition: inline
In-Reply-To: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: Prevent DMA from transferring too many bytes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYzpe8yYzYY7Vx+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 05:30:31PM +0300, Mika Westerberg wrote:
> In case we are doing DMA transfer and the size of the buffer is not multiple
> of 4 bytes the driver truncates that to 4-byte boundary and tries to handle
> remaining bytes using PIO.

Applied, thanks.

--RYzpe8yYzYY7Vx+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcTe1AAoJELSic+t+oim9iXoQAIENOzS1zIzjUvmB6kvDpQNy
cp0cMfvyGm8kHwLFrXo4IV4P5GA0XplLekVpVh2qReuGAwlm+K9CyzA1ifiTKn06
6k3wMPW2udyeK0IcfGUd+WbdWhEmtNIb1ssJyafqlMCNt7Z6WFZR1Mts6G2voS/U
Vw2tjBFoEi321v/xiiFre6F8jiD/4hkuoY1WKVsN/nzcm1Z/H4wSmYl6Q6b+FjvS
Y4eJcFaYJR84GxMR23YTVdyiex9CT+1DxVRAupv6b/tENmM37JQy5N0xbIDPDOra
Y/KiwiUByhkKE7wHAzd3a6LfQcTbO192FtpjaFagJmS3BRQEsIyjudb1PRQZB5Kb
8FAqnDdtE08Uq5vdubcUyqT0ezeKGtihjD3Jxrq/De4GyuVs6Kbdq0p+PnJabyLd
BMHEs9IKM+TQ4gYb/V+QUVGdix34FpAy1gMt3dLftv/eUWZR7wbUgdr/tomgTZxe
OMXcnBo02Qhp+wRDe4loRwgo2PdlVa3wzTvxYlDZPpW5XZkPId/sL/dScMBmIqMp
WvzN4rSkCbN22jKG9u7/KuOme62k8LpAC123179XWcOfBdYHiydgYuoX36A11Fgn
+sV4V3oEmQ43PKWX7lv1fcrJdzrGMckAYDqu2QauraaflofnfM/4ShoAmwfKniWz
AN6ySUnZn+N9ljq0m2DS
=iO6/
-----END PGP SIGNATURE-----

--RYzpe8yYzYY7Vx+e--
