Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbaLDWmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:42:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48539 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbaLDWmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:42:02 -0500
Date: Thu, 4 Dec 2014 22:41:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-spi@vger.kernel.org
Message-ID: <20141204224140.GB11764@sirena.org.uk>
References: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
 <1417534844-25080-2-git-send-email-lee.jones@linaro.org>
 <547DE5FA.5000409@st.com>
 <20141203091707.GH22522@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20141203091707.GH22522@x1>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [STLinux Kernel] [PATCH v2 1/4] spi: Add new driver for
 STMicroelectronics' SPI Controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 09:17:07AM +0000, Lee Jones wrote:

>   Would you mind casting your eye over this submission prior to
> the v3 please?

This all seems fine (which also means that the DT updates are good to
go).

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgOMkAAoJECTWi3JdVIfQoPsH/3idF/c+bYZmPNTn1dciMUO9
kNekhodEpU3vtdeaytOkw+EgiJA1/sxmd83m/6RVh8+xExgL9JPNRtayiHn5UIDn
gomVtR7NM3sKJfuOiE9aXSSSJ3VL6R3ceqh/ySb703IHPV5IZwr/o8IWYFtFMDR/
JlpnRtzEE8trPviMYI2LCF/ENwQd2IxshK8jdMUU3s/DlS1LqMfR+j7ri2FRpgVj
EFoZgn/REWVb2w7pqtjPzyAZoaxxL3K7Wj+jx3taycNLkiFwoX+lUawZDLQHU47r
0SRTw0ADbSd22o0D86QPVt3rreLJrc6ijmdd4BFi+auXTEfmkHlAKmRuk0zlis0=
=vyX6
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
