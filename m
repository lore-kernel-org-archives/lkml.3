Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaGVWWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:22:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50195 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaGVWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:50 -0400
Date: Tue, 22 Jul 2014 23:22:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140722222232.GY17528@sirena.org.uk>
References: <20140716121029.GA22222@opensource.wolfsonmicro.com>
 <20140722104206.GA19663@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j5abB2DrWbqmv6QP"
Content-Disposition: inline
In-Reply-To: <20140722104206.GA19663@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: arizona: Disable AIF TX/RX before configuring it
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j5abB2DrWbqmv6QP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2014 at 11:42:06AM +0100, Richard Fitzgerald wrote:
> Changes to the AIF configuration registers only take
> effect when the AIF is disabled. If the configuration
> is being changed from the previous setup, temporarily
> disable the AIF.

Applied, thanks.

--j5abB2DrWbqmv6QP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzuQlAAoJELSic+t+oim9BboQAIveeqw4GRQCvQFnyR9MBvf6
htIWqvpbBWU48Z3fLLX5afA9TdSmwvD0wBToyTLS19t+tBk4YpGEUHcS6tuaU/8D
hR8w0iir/CTsm21LRCvkJGYNHiQ6TX5RgKSqXQBcz9tfYSbsuwsUwlOGU2KGEfqK
GSYltt4TIcYxTnVDcFAPzBK1xssZmgMi9QYgIxqRYXnV6HnAOPFv6M2HNAM9Gm5S
LJyN4dd94/LHpiwOMiabNr87daIINIiTa2xpSc3V9742xpwLh27fNnKR+ZQ6IhE7
qEAbvpvtGxpuuIFsZbdR/qeeRg46Y3mgyRupbV3yoSTqAv6uJc0BzkdPU8miKvfx
ropAw10Dt3C3fiNnwgzbbfQjL2zbZt+U+mDzzUCnI3gXazHRxfQ+NRfFHw8lWDMm
rHSTUaai229+XTkZfSoiEAwcB18/5h+BqyE3Sz+noWN1NvH+AiE37f76eaUb9qXi
431Vwn0o+pNsXU76PD4V5auQuu0ulfnamYqZaMG1ZqCfcRes7p6s5JLwFLXciR76
AaNvS9sAlaYR8W/fs44ROhiZiydExHZ4vTGyCkqr16gfsD2H86SS0ieFDWhfnyXJ
FGKWDq4hJmn2NLRXwIQJI8OWTY8xR727ZKbU6PTKw5TEwxMEP743o6356x8eBotm
busjhyV0dr7s+EZcVhP1
=USZ6
-----END PGP SIGNATURE-----

--j5abB2DrWbqmv6QP--
