Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967971AbaLLN1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:27:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56768 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967664AbaLLN1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:27:43 -0500
Date: Fri, 12 Dec 2014 13:27:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20141212132732.GK11764@sirena.org.uk>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
 <1418271327-14710-2-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PlDVpzlhHY5RV9ko"
Content-Disposition: inline
In-Reply-To: <1418271327-14710-2-git-send-email-benzh@chromium.org>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: rt5677: add a platform config option for
 MICBIAS voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PlDVpzlhHY5RV9ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 08:15:26PM -0800, Ben Zhang wrote:

> The MICBIAS voltage for IN1 can be set to 1.476V/2.970V/1.242V/2.475V

The changelog says "platform config" but this is adding DT binding.

> +- realtek,micbias1
> +  Select 0/1/2/3 to set MICBIAS1 voltage to 1.476V/2.970V/1.242V/2.475V
> +

Why is this being specified as some magic number rather than using the
voltage (or at least providing defines for the voltage) - this is going
to do little to make the DT legible and...

> +enum rt5677_micbias {
> +	RT5677_MICBIAS_1_476V = 0,
> +	RT5677_MICBIAS_2_970V = 1,
> +	RT5677_MICBIAS_1_242V = 2,
> +	RT5677_MICBIAS_2_475V = 3,
> +};

...I see there are defined for platform data.

--PlDVpzlhHY5RV9ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiu1DAAoJECTWi3JdVIfQpdUH/1oAN3Z8QmiSAMUziZoVU2KX
/EXvCC46RKgbZJN2bfPUN3cPdo7Fshhu3Yp8sMdaRB1zokuLo0cEwhUOl8XzCHz/
VdSYnP5EI0hxEgj20YBjeKzwiahBfMCjYVMk92vEQYt+tEIazH0AogSyoNpsCGNn
lqp5DnRxfUXRx/2JNMNp+mVsfJtJzneBfoDFu/Q9aL1FpwF0Lf0fPZDZ1ElAoc+1
itAjPUaTndL2oZ7nZqg5aI/m6qJu0ekrtNVE6fjeyBY+N0NFMiNFiYWftPSglOq3
81XMdNukEhDuCqp4bI4armXTtp2lcfAn+3N77UCFZlXOr+ymikREKHeahKhnmEI=
=6cds
-----END PGP SIGNATURE-----

--PlDVpzlhHY5RV9ko--
