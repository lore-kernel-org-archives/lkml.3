Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaHGJjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:39:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51090 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaHGJjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:39:11 -0400
Date: Thu, 7 Aug 2014 10:38:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140807093851.GB17528@sirena.org.uk>
References: <1407230421-20953-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t+aXE7hLC8APFkG0"
Content-Disposition: inline
In-Reply-To: <1407230421-20953-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Initialize with software reset
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t+aXE7hLC8APFkG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 05:20:21PM +0800, Nicolin Chen wrote:
> This patch adds software reset code in dai_probe() so as to make a true init
> by clearing SAI's internal logic, including the bit clock generation, status
> flags, and FIFO pointers.

Applied, thanks.

--t+aXE7hLC8APFkG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT40koAAoJELSic+t+oim9KpYQAJlYBddSHjSnX4yqwAZKyQcd
9EWSfckY5xV9Ci+qiSCbJ7GIcOsHunIqyReBvlF3KwshyKjNo0OmTVWh8fZ6L+gI
pc13E/Yu/iW7h8QJN3klEI38ZxXD6RgMec1pLCU0IvYs/zUFTUzCHNKGCFceRaHN
vV4nE/JC8Wz8Pbie1+rBmZOxgP1jQ1VcSMDLNGZhZOTJyhaf0O+idoJeVKcN6buE
reZOq4Ede8tt++G+u6Xwna1BFwT/xOnsCtrEn7Ev8Ou35237tB9mTwtQycP4YUGz
5SLc+QJfasR7Lou5bnUFl4T3fvO6JjyWvMCjskLLzn7fWM3DBO1HCiYFJMV6ZCUG
/KgXxTuSA5V9BcvaZx6XmsZ5rnq88zas8eJkxyD6noICor9OCdp8+sRV2Pmx9Z8N
aDjVe58mhU3B5g0MHi51BLWKkrT5J9S63NSqvi2TLMLzdHEPPTdA4aP4zrlriL3x
9fnTBZB9rdC7I+j0vjsILn1bZFGiz9Mly1TCXOHS7crWie2P6nGGTt8/AdULWoo8
PP12ucY2wQaOY2MnSb88VV7wtQafMhrilDmkJm0mQH0li/IVeiJII9niVrXQjcQb
dayUqWYvMtKWV/xwj6ZpHYWtNEoU1k/A39W7t4PwDTwjCTcwMQUvVYNC9dS8Q9VV
KogLUWEJ9UfV393gQBHd
=pV9C
-----END PGP SIGNATURE-----

--t+aXE7hLC8APFkG0--
