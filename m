Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3KUKtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:49:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59930 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3KUKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:49:40 -0500
Date: Thu, 21 Nov 2013 10:49:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: ldewangan@nvidia.com, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-ID: <20131121104911.GM2674@sirena.org.uk>
References: <20131120175814.GC27423@saruman.home>
 <20131120203400.GL2674@sirena.org.uk>
 <20131120205143.GA9182@saruman.home>
 <20131121024840.GA22970@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+F2yqQIdYdj7GirX"
Content-Disposition: inline
In-Reply-To: <20131121024840.GA22970@saruman.home>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+F2yqQIdYdj7GirX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 08:48:41PM -0600, Felipe Balbi wrote:

> actually, I didn't miss you at all. your broonie@linaro.org was in Cc
> of original email thread. The same email which was used to sign-off on
> original commit.

It's not what's advertised in MAINTAINERS, you should be sending stuff
to that address.  My work account is completely separate and for various
reasons (including the fact that a lot of the mails for upstream sent
there are duplicates of mails sent here) non-automatic upstream stuff
has a good chance of getting dropped on the floor and at the very least
will be dealt with more slowly.

--+F2yqQIdYdj7GirX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjeUkAAoJELSic+t+oim9JAwP/it3glLaDwrYG0HpO3LKlmGy
Wx/wiqP+6BWXZQQcdivAAAOxyEYkJB6ttv+gPwuqv9ISEGh337M30USdOrV1BRFD
HfTEE2bjUZ9PYG8SlQ5fu0HJQBgRauZ4RIuGO/2dTBVVP39wqEbYINuEKdcDL78v
qFcW1xu6cl75VvcKT7aBYDDFZhBwWqHRBHoIxXvIGtcZdx2KTfeGQMBq+WKCKfP2
aBPWtUYYJeWgnfdxwaQvNNLq83fGc0qgdyn4iAywOk17mE3Z8oA5D/UsBBJrKXn+
r+dcPypYSOMjBOMKw5E1gN0fXcI1Xx6u/B+bPtCjswzzn6kXv3DLbQxnLdbTD7Y8
/NnIsKdszW17JKVeoyHkxwLaFxKycGdZK6h0nOpvdkDxwu/Fl7Lu3AWra/kFjOAt
ND6ZVxUyt38Evx2g27XzFM1z3F9MWkFlk+mFVkPrDZn0aEqPSdTkF7vYgoOP/Pcs
hXyz+W4bcCpBSKAX3prvOn9zn7E1eRtnhDWfxActf/+UF7hBM3K630UByhgyhC4L
j/hA+k+y4i6PUQ63bmM0pVNv0cnt2alftQOCy9dKnIgk+l3jyETTvKIpxApzyXxr
GwR60pxJJOVmm7qVhesHUuIlcuenLmcDdVN8jv+wXntkitMOHsnGZL7JjFr0QDxL
xvzBMMT5ATs8+/WUnIo3
=JWIh
-----END PGP SIGNATURE-----

--+F2yqQIdYdj7GirX--
