Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaLERUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:20:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49468 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaLERUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:20:15 -0500
Date: Fri, 5 Dec 2014 17:19:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141205171941.GL11764@sirena.org.uk>
References: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
 <1417534844-25080-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
Content-Disposition: inline
In-Reply-To: <1417534844-25080-2-git-send-email-lee.jones@linaro.org>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] spi: Add new driver for STMicroelectronics' SPI
 Controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IuJpT0rwbUevm2bB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 03:40:41PM +0000, Lee Jones wrote:
> This patch adds support for the SPI portion of ST's SSC device.

Applied, thanks.

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgeksAAoJECTWi3JdVIfQu+oH/Rh6x1WcU8GA9JwIjizQiILE
Pa768QsSk4iyf8juVa+l/Ty74MjNWBvOBRc4dbHzLMczIbGSzD/L0LC6gl5m5dD0
LT9Q8oAl+5bpxLADqK0EZ5wW4ttZjm7HIyTOzrdv2CLHiRQO8bAu6T/ofvx3FEgb
6pMAzcBZzVAQ8cJKJMUYn3WYqvwvzmf+SvC4bVs1eIkgiCbzaC7+WUp6u1H0VbjM
mYugZ0iI27wvEHJwiNAikJBMJTKXLjzIqQTy3iVWy5NfkaHDk5yoqogNQij45izR
Bt+ujkmDbjiOqIrbXI8QuTjL2Y/Bd7leaFqAddkUurz5vTEebjUuRkdcElLNVa8=
=kss8
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
