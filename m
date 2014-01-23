Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaAWTkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:40:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58722 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaAWTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:40:00 -0500
Date: Thu, 23 Jan 2014 19:39:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123193945.GH11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-8-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IbVRjBtIbJdbeK1C"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-8-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH Resend 7/8] ASoC: add
 snd_soc_of_parse_audio_simple_widgets for DeviceTree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IbVRjBtIbJdbeK1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:49PM +0800, Xiubo Li wrote:

> +static struct snd_soc_dapm_widget simple_widgets[] = {
> +	SND_SOC_DAPM_MIC("Mic", NULL),
> +	SND_SOC_DAPM_LINE("Line", NULL),
> +	SND_SOC_DAPM_HP("Hp", NULL),
> +	SND_SOC_DAPM_SPK("Spk", NULL),
> +};

Does this mean we're restricted to a particular set of names?  That
seems sad and won't work if there's a desire for more than one of a
given widget - the main use case I can see is multiple microphones with
separate microphone biases.  How about having some templates that we
copy and then replace the name with the one the user supplied?

> +	if (cnt <= 0) {
> +		dev_err(card->dev,
> +			"ASoC: Property '%s' does not exist or "
> +			"length is zero\n", propname);

Don't split error messages over lines, this makes it harder to grep for
them.

--IbVRjBtIbJdbeK1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4W/9AAoJELSic+t+oim9brIP/RH2ta9ulYxSXYZ0harq5kUE
GDDW4NFPBVx/WzW2it1KGSoZ1EFqkPIjOQccfbD8NORSnge/dihWwaGiFqAe7Tsu
6Y3T3TYzL38ZbMRk13NJJFZktKZiZiTBqVxL9NQUe5ADflXT3M5iYlYIYJigLKl2
0PVtTQ3AfiD7rjYy4EMvTwEN+eH6Zm2efXXhPS5+8bj6SZfG8HOAhBCnCnnalSPK
Og9xmf7i4FbhSp3cyHu27r2TvW8bMQVSosQmJZ76YNFrDXC7YovxwkZvEwcVjBnN
SL7NXCExRuHfgUZUgU3cA1NsJXHg2DvK9HLKVBkSmS3VZA9ncZEqnk3DBfa685Md
RQcAaoGHOZtWz4/VHT5zyBq060Ryn6Htpui20JpATX/0FG/hkumiqNuJMgojJEES
iXvjjKKVqUOlOZDS/WHyCamVTRkUk1GcRN8begeJLaPrAnffUmKCYNPuRCvc/Bmc
hh0F8pzbVyTck+8UAAbGp9+w25TOoyU/xn3gPn5GrT5bP5s0on1ow9puDxROw8jo
iROHdWW0XNFJcwBDTt3EeoTvoUT1+BkjY/eCl0Y38fJSoynwyGnJLhvb//kjzc9x
UoGbiU88hXPLjXIVXoxWGEHcO7Nw+dTmbCOU0o59nORu6DcL/+Ba0OwLMiWrXe68
MaDfhy4JkvEdhooNYzRp
=Aeza
-----END PGP SIGNATURE-----

--IbVRjBtIbJdbeK1C--
