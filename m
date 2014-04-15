Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaDOMVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:21:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33883 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaDOMVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:21:10 -0400
Date: Tue, 15 Apr 2014 13:20:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Message-ID: <20140415122044.GZ12304@sirena.org.uk>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
 <1396733753-9820-2-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8M+BMcg+0CmQ2H7L"
Content-Disposition: inline
In-Reply-To: <1396733753-9820-2-git-send-email-sre@kernel.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] ASoC: omap: rx51: Use devm_snd_soc_register_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8M+BMcg+0CmQ2H7L
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2014 at 11:35:49PM +0200, Sebastian Reichel wrote:
> From: Pali Roh=E1r <pali.rohar@gmail.com>
>=20
> This patch converts the rx51 ASoC module to use
> devm_snd_soc_register_card. It also adds module alias
> to support driver autoloading.

This doesn't apply against current code and since it does multiple
things it should be multiple patches.

> +static int rx51_soc_remove(struct platform_device *pdev)
>  {
> +	struct snd_soc_card *card =3D platform_get_drvdata(pdev);
> +
>  	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
>  				rx51_av_jack_gpios);
> =20
> -	platform_device_unregister(rx51_snd_device);
> +	card->dev =3D NULL;
> +

Why is this assignment being done?

--8M+BMcg+0CmQ2H7L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSQZAAoJELSic+t+oim9axwQAJ1bebnpbDkFMA4qfqZKGDA7
ljaUPSVyscdB5l7cOIiyNLM+DQmYZFVZs2HxqOj4mQNljQ44NQu5+0T2U202zQRl
hR2MaCatZvroDw8RsPadpNnazyetECHUeL0DMOGvAl7kmodRpx70EKf4CIlCqSfF
HHc4ZECRUQcpG6v6iZgCBIGJafJrSi4cboQRmlgDl69WMFyBaLtwB0i+T2T30wpM
Nas4Z5UTg8co9KG/UAW81+63BpJ5U7hXRSb/+37U4W0i602ZZmOM/eZyxQ2cdMm8
EVdIm4p/H0CQ++LLBlagIEvWSvnBrUea7X+Fbm50M8R9NEBPJrP66u9Aq3K7MuCM
0FQscvzNHRAU2KD0yyRQebXBE5yr/dZwx535qk49Ws4TaZVo+oCf6G50us0Obt9D
6iotTBbPFnCoIUAGwXbBpKIGY7W5qbgdg2GIpFkKgCiMY8PacipWwa32Oab2jDLB
J8Shb6E9H/3o6/FOq0NfuLw48b0Xpc7geFT2iaJ1pn989G/+tf2MgyR8ISC6oyqm
SVBcp93HshzvpvvjkHNpD6kY5zjvVpI4QifY6xEIx6s/WAlnaiF4tjNMO9ejYd0s
0jZnxp9ZZ6Y2BveDZirVLErEyS8/kHKLpGbmg2TPXUmE0rlfZ748JVV+IPc2XNah
+83a88+8UGp9v9BjANtx
=QCJN
-----END PGP SIGNATURE-----

--8M+BMcg+0CmQ2H7L--
