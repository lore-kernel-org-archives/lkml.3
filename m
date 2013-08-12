Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3HLI1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:27:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52536 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753017Ab3HLI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:27:52 -0400
Date: Mon, 12 Aug 2013 10:27:49 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 5/9] pinctrl: sunxi: Fix inconsistent indentation
Message-ID: <20130812082749.GM2911@lukather>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375610330-18185-6-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N7hiGSZV0P2B4+ho"
Content-Disposition: inline
In-Reply-To: <1375610330-18185-6-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N7hiGSZV0P2B4+ho
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sun, Aug 04, 2013 at 11:58:46AM +0200, Maxime Ripard wrote:
> Some pin functions in the array were not indented like the other
> functions in this array. Fix this.

Could you please take this trivial patch for 3.12?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--N7hiGSZV0P2B4+ho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJyFAAoJEBx+YmzsjxAgxfUQAKIP0i2GmKwTVO70VDm73Z/z
unQOVSQTVJ/cDdmRUZK1LJ0nuOUx8GpuETUlLs/aAtNdrI6RXRcsb5QdO1d7p8YA
FlVZtbPEVSjiGX/VPysTYx5PsYc8amctSlqHq++l/rgpQrvMhQ29INxafK7tEdhb
C3E94TUAAnldNIQi9f22BTYD0cE1xsvdJlcyvOuvRZdXC2ntHaf7xwx8QAsggkmQ
j6UhQGQszCAmvbnCT1xz7NtGcGMwPssT0DQNfBEooyNXl1vCTwJVyWpod9G+OLLx
URUIRiRjmeReVWfd6LTCfHpF59LuJZdJZQ6Lm7anyVC/cvAD/Yv+6txwipgus3Og
lmahMsqXAr2H1cdwBlf2g26YGT1K2HXQYShzm43S0FC45C1sz5i5ytUqqJ4o6+fI
c4XUzR5FZFkiwg4Acna3dmzObyHcn9H6rhdwiG8UFIKupt/tUh/rGiY501GUSzx/
6e78stTAfWHrQySFUI98IBtddRsQj+y2+nMKV4tSPPEnVvNfENo0dcS1OPJzowWw
tsXTAr7FOTEX10wP9VCI9zP8RHNa5xYObAxTkHOM1o5fDcKrou+5CxRefWyd4lT9
ay3GH+ARhGZqOBwI/VFHCTa/VkbMIGSp7fczUHaINbXpNJka3wtKvkSt72MMwptm
BOoH4E+6q4ca+BmfvXXb
=edtQ
-----END PGP SIGNATURE-----

--N7hiGSZV0P2B4+ho--
