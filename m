Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaDBS2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:28:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbaDBS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:28:04 -0400
Date: Wed, 2 Apr 2014 19:27:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Message-ID: <20140402182747.GC14763@sirena.org.uk>
References: <1396405217-12658-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <1396405217-12658-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH resend] regmap: mmio: Fix the bug of 'offset' value
 parsing.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 10:20:17AM +0800, Xiubo Li wrote:
> 'offset = *(u32 *)reg;'
> This will be okey for 32/64-bits register device, but for 8/16-bits
> register ones, the 'offset' value will overflow, for example:

Applied, thanks.

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPFagAAoJELSic+t+oim9SNoP/0DF6q86Kn1+mC83UPzHT53N
A2M4FV1KfqA5XIIliRId8yCW2NPMfximWxu9VTpgGdeWvknuhPQ/iGGzC1BPWpRE
bgWo1ZNrO1w9YeP3A6vi7sLMKdVG9Q8vrypt4azP7MP2jctRJorKlJH/GXAwIEuo
k7vOJL8L9L+itRFlRpf8v6Ileo2JLdlzvVBFTVIsM7UXtJQK0UB7RqzgcRlk8bgR
qb+wSGvsPJUrqX/bG25ZvZ8zQyoPizknskO8eCruXqLvf+julTKlyF+VeGrOmre6
dqvukkD0Cspt17xDTp28sHtJseFtK2lRzOOTmhejf5nmW6A356sf6uIK3WIuH6+t
AoGZ3F7HUILY1chuzgcXXKiolx7lBpNqC7xU51pfJyZl9hB1xqYYQcBhQBf9sbOV
oFVbaMUjKiPFRRRLAb5ZLlW9HmsUJVyw9cJEPYH4nPVfR4tS9lesDO2pX4k1iaXE
ivk5KHmk+6ycuKrSCgPydCJQuVOgdKq9YGpoDueEPt/I2G+EPx1jOn8ZDxO5OSyo
Oypx257yRKdIYi18gTRgja9eupVppI8C++MjCVRfql6YHLCqpDSAb1GCRdJ9jA3F
/cbizLWmV93nTzv/ZPUD8ABpQTZA0ZrnTOn/mLTikGs7OEZg7HbFANUqBTIjhe58
lSl49ZBeFHnF2TXK8ySB
=cr9H
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
