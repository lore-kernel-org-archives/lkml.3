Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3CLSrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:47:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36254 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355Ab3CLSrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:47:43 -0400
Date: Tue, 12 Mar 2013 18:47:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        device-drivers-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next v2] ASoC: adau1373: adau1373_hw_params:
 Silence overflow warning
Message-ID: <20130312184741.GP19942@opensource.wolfsonmicro.com>
References: <513E2895.6040904@metafoo.de>
 <1363029503-23880-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X78YbkCBd9ye7Cvs"
Content-Disposition: inline
In-Reply-To: <1363029503-23880-1-git-send-email-tim.gardner@canonical.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X78YbkCBd9ye7Cvs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 11, 2013 at 01:18:23PM -0600, Tim Gardner wrote:
> ADAU1373_BCLKDIV_SOURCE is defined as BIT(5) which uses UL constants. On
> amd64 the result of the ones complement operator is then truncated to

Applied, but please don't bury patches in the middle of e-mail threads
(I nearly deleted this unread) and avoid including

> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

enormous CC lists like this in the body of the mail.

--X78YbkCBd9ye7Cvs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3hDAAoJELSic+t+oim9H8kP/18ttTtwtABrcpaX7PlnMdtM
lCfAQCsMyUZsWzTler3FfLViVeu17B2ltNQbhqpQoPAbB9CgpDxLtpp7nrVkhojV
+i9wnSYCIHqDRcuj8mlMsyNU8lqRcCCigmZxjcHB89nqrLF92dmiEDCdZf2XAw57
NGkvz7N0RYErfEW1yyDp8VCbIHFoEbwNv72Iud3y/dhpREOkJagMlmzWtHzh38yu
XQxYI4QBd+QWvW7RSS0FxDIGXV4tFVFPwXq4uJTXbGWJuv6u2b7xWeavYyW71G+I
uW5ubWO/ENQ+iJR9RxX2ZNPa3M3/6U9QG34/6UZiqqS0H5RQ0hzzzPlVNqthfFXw
/vpafYXxIRUxxjwQkJtzhs2gTfEIiP4Lh4GI8IvAZEHFRfFSID8yuSLbQFa3S1+N
mUy1LJtJYtHnzvT+fF9Jcl0DRCMAliask2U24k6zG7DC5aHe9+NDW5xsh03a0F2/
yRgf7WJvxHUzYD5Ah5JBlk05vl6EO2IODW/lYJEDKEpjBVUYf4yI8e96WnhhQ6fe
X/6N/NNqu/GH3GhXVA4RhKcpEzcvPLv+XVS0WsWxgCLisOwZ11VXEcn5g+tZfAKG
Bf4DBTM8DEkIDrz4N1rDHLgpmqr5M6JkunhGoFKTtqlgDMmgtJD1egAWgWsXAslD
MvHoccKywIdYU7snaS2E
=fA33
-----END PGP SIGNATURE-----

--X78YbkCBd9ye7Cvs--
