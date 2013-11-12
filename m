Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3KLLbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:31:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56436 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3KLLbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:31:19 -0500
Date: Tue, 12 Nov 2013 11:31:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, wfp5p@virginia.edu,
        mpa@pengutronix.de, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131112113104.GN2674@sirena.org.uk>
References: <CAPgLHd8kfDJJg045WbRrrd06rKSsUZkYha2nFPuXkbkAKRvpTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/TUrtqMIkCP4YtJm"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8kfDJJg045WbRrrd06rKSsUZkYha2nFPuXkbkAKRvpTw@mail.gmail.com>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl: set correct platform drvdata in
 pcm030_fabric_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/TUrtqMIkCP4YtJm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 09, 2013 at 08:41:14AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> platform_set_drvdata(op, pdata) in pcm030_fabric_probe()
> will be overwrited when calling snd_soc_register_card(card),

Applied, thanks.

--/TUrtqMIkCP4YtJm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSghF1AAoJELSic+t+oim9mAwP/0Kcr3GXZOqB5AuNWtki2xcW
9o+gHY4cwKMX18MtYzcqIkIDMCwB6LidD9iDoQXvKpN5u8TTk7bgA87Vjt9SrWBd
/ZhOdt78GDNfDuEQIVvzW3thWHkkwbp5HnnUSNUeHbFoPaywpimhZBRrPQw1C3Dl
gpdMKm4s8G/Nhu1YRG8WOPnVqCLxfWXg7SINmvHA22mQsuOOgPfsUJTMaubA/Z+m
2LmzCpSZLyK6Nr066wiRRyCFntXRAknQTgvYzs/KvC2lsFy0YMTmnJBAcbzIafdC
0UbdL5NFVahED52HW/i37ZgltE5C1yaf07jP7jtcTqRSNKfqPQRDd1WSxLbEHOd8
G22ivGTU9Rcxbb4vtadsrKHq9HpKj9kZHjIBQyIUw1OVMQLwYeEdbYfFU/yM8WY0
DO/WvyNNXSIRClNJF+NSiFgqCTfCLbvmeH7tnf/2aQTp9cLRMWKlraxmdGCFIfHG
9tEcL4tx5oQIsUUKOF3LYX/Hcc2ygS4ThJQZLrg2vCjjLXbJv3Qbnoi06DfS01gf
jyk5vaz+MGxHe22FRMWx7sR8XWeiJbXb97u+cJrYqLwo05HMUTP1xrsX7oOKTPJh
tt93UaF/MIR974vAUZQQiJTsn5SvXmHD6FwD4Yb+LrZ0VaQAaFqUVgw0Osu53vXa
T+PWcXGGYq+tZ14rxmEQ
=nXDD
-----END PGP SIGNATURE-----

--/TUrtqMIkCP4YtJm--
