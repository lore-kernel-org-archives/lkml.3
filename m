Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaIRR4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:56:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50871 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:56:00 -0400
Date: Thu, 18 Sep 2014 10:55:33 -0700
From: Mark Brown <broonie@kernel.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        naushad@samsung.com
Message-ID: <20140918175533.GB7960@sirena.org.uk>
References: <1411033340-5524-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UrcmHL2XoDAE6/CM"
Content-Disposition: inline
In-Reply-To: <1411033340-5524-1-git-send-email-pankaj.dubey@samsung.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: fix NULL pointer dereference in
 regmap_get_val_endian
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UrcmHL2XoDAE6/CM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 18, 2014 at 03:12:20PM +0530, Pankaj Dubey wrote:
> Recents commits for getting reg endianness causing NULL pointer
> dereference if dev is passed NULL in regmap_init_mmio. This patch
> fixes this issue, and allows to parse reg endianness only if dev
> and dev->of_node exist.

Applied, thanks.

--UrcmHL2XoDAE6/CM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGxyUAAoJECTWi3JdVIfQjXMH/AqEGqEpBr2FvMPgMhUuuBIV
T4qIHtS0rIC9cB3fpibOtSwwuGRKDCKV7qKknEPir4UBryzshWtwCjGvUSJucmnq
egtAuplIal7D+DuvPjWWoK8ztn+CUHyrfm/V2fDxi2zKYQEJ5P4yVMqZq4XK70fd
I73AHj9mOjraLqMi77hZDHhE5Yphwskie+e81A8X8r7bANkbsHKxn1uLwc3a/uex
vOurJzZjuj/g/L42E3DB41YZ/wV42Uvv/gDIumW468BdlSLLqcJd08a3cxXvMoPl
I+8FBdq8paONFMXaEobg5hWqa58EYxyKXd7dm+FOsYRSJ6wAQG5xNC9iTh/w18A=
=GrsV
-----END PGP SIGNATURE-----

--UrcmHL2XoDAE6/CM--
