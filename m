Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaIFNxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 09:53:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53444 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIFNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 09:53:42 -0400
Date: Sat, 6 Sep 2014 14:53:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Anders Berg <anders.berg@avagotech.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140906135308.GC2601@sirena.org.uk>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
 <1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
 <CACRpkdby4H-fivNn_kG2uL0EjsCGAc+t6OyFi0+VcNGf2Z9NQA@mail.gmail.com>
 <20140904170630.GL29327@sirena.org.uk>
 <CACRpkdZEoBan=Lqr1T-iY41U9NfMA_MCLX3LA=juw7X4pmRvSQ@mail.gmail.com>
 <CAE0=X_3QO5p26M=FS7joKS3zD6LAM_moFutHNcyE1-CjauL3Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <CAE0=X_3QO5p26M=FS7joKS3zD6LAM_moFutHNcyE1-CjauL3Rw@mail.gmail.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.127
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2014 at 11:05:37AM +0200, Anders Berg wrote:

> Well, the problem with adding this to the spi-pl022 driver (as a
> vendor specific extension) is that this IP block unfortunately isn't
> distinguishable from the standard ARM PL022 implementation (same
> values in the PrimeCell identification registers). That's why I went
> down the GPIO path...

Would it not be more straightforward to just register it as a platform
device in this case, or use a separate OF ID in the DT?  We appear to
specify a compatible string when registering AMBA devices even if we are
capable of identifying using the ID registers.

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUCxHEAAoJECTWi3JdVIfQ0uUH/A2xoGk4MXCll2e7e6pUQIPH
SQ5bBfvdjxyCVunWYUjlqdFKgJ4BPOiC53cACl9tdjN3M0Tog12Xcf9RmsLjDy+x
NDcTUH/9WSiOf0SZ1VaNs8X6QlHsp/kLeSXmEr4M7XMO71hPAC9NNH1vxUksPA2p
kexibLyxh2hbtvQyhs+qD9IZnTLLKhi7385RBsjY+vjriVrqaZ5w0D3R/ms39AkS
Lkw8DyDbj2Lk2wIJvlKb2jHv1jmco+DhS1ns6vK2kbs1xPDMW4Li1Se5mZTTHaUz
6yAbYLNzFOtDuRz5wJvjezZCAhSITzbxVgC8pBjd6IDMibBVm4OGczF1CxburTE=
=sp84
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
