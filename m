Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaHSVPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:15:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49389 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaHSVOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:14:53 -0400
Date: Tue, 19 Aug 2014 16:14:09 -0500
From: Mark Brown <broonie@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140819211409.GR24407@sirena.org.uk>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-11-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nQUlLD2FJeKEtFpv"
Content-Disposition: inline
In-Reply-To: <1408469363-15901-11-git-send-email-andriy.shevchenko@linux.intel.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 10/12] spi/pxa2xx-pci: Add support for Intel Braswell
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nQUlLD2FJeKEtFpv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 08:29:21PM +0300, Andy Shevchenko wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>=20
> Instead of one port we have 3 ports and all of them can take advantage of
> the shared DMA controller.

Acked-by: Mark Brown <broonie@linaro.org>

--nQUlLD2FJeKEtFpv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT874eAAoJELSic+t+oim9NLsP/Ry/U7b57Vz7zpu0u9zsp+hb
YYmodwek3L+sckx9EVzGUVYn+GUveo80jnmONBaoWucxUMde3qR2xZNtCuVbcLG6
IqPyFbiGXNotEEfg96jgSo3k25ePpkMEM51dt1VBZ5ZsczaNptN2sjTUFY88mCtj
/SNIxC1HnEEoadKHpql3Em+o9lHJJlqyJX5iNoNMSPBbrWLa1zmdNKjZ+pVnkJb2
RWOZYMIRoKLG2otSnr6T0qxHaoHk8bkSApb6WXNoCpxDKdT8uNIbiMur3AEGBRPF
XR1b41F4p6z1tV3MTcEqEbdchqcxCbBsdT8RC2+/mLLgTUCVmzher2RvH8H9aAxl
m9a31c7HV5QxuYzXMj5uKFd2nFFjP7SaqTRcfapeyKxtIR20G77fcEi4cmPrbtK4
fQKKfXJ20soJ3kMHyQZlv4wasHQP+HadEbcEEvNysoNA+RC/6bMyu9ozNC/yZZYy
ep2/WikQGXqHCtSLnHo2bW78n6p63M2Prdm9VEyJpirRmaqJ5F6WL0/HZeNaDdQN
wg2awEcH0eykjMneNgErPmsUnL0VHaVlXsOZPrYQG0qgVYO7AIZZ9+mVGGauzQLd
drkSAWM+ClOa3JHcnmVKf0hWKB9fkz4pLKvVJa5dfX7BUFpJP32w9PKHMvWQ/GyR
LWm7plGjCZqvUDGjUtRf
=LNQa
-----END PGP SIGNATURE-----

--nQUlLD2FJeKEtFpv--
