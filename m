Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaAZMn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:43:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59615 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaAZMn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:43:27 -0500
Date: Sun, 26 Jan 2014 12:43:13 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140126124313.GF11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
 <20140123183829.GB11727@sirena.org.uk>
 <88ad355def5f440eb92ca921b17aabb9@DM2PR03MB509.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWTGJt96jR0TCFDW"
Content-Disposition: inline
In-Reply-To: <88ad355def5f440eb92ca921b17aabb9@DM2PR03MB509.namprd03.prod.outlook.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rWTGJt96jR0TCFDW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 05:15:05AM +0000, Li.Xiubo@freescale.com wrote:

> > ...for simple card since the whole idea is to support any CODEC with the
> > same driver we should probably just make sure that all the individual
> > drivers can be enabled in Kconfig, that way we don't have to have
> > specific Kconfig entries for boards and loose some of the benefit of the
> > generic card.  I sent a patch earlier exposing the OF supporting CODEC
> > drivers, one for at least some of the Freescale CPU drivers was sent to
> > the list recently too but there were some review comments.

> I hadn't found the patches, could you tell me the titles of them please?

My patch was "ASoC: codecs: Make OF supported CODECs visible in
Kconfig".  I can't remember offhand what the patch for i.MX was called.

--rWTGJt96jR0TCFDW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5QLeAAoJELSic+t+oim9GqIQAILupWCFy0t5/eLhkRmLMVdw
Uzey7l9nU/KlokB8lXJ76OlkBgC8n5nc2sZ541eR/fsaFeaBAK+dnnydFKIlj5hw
2zs0gQAOyKLyTSM2qJ8xtWekxxfRSX+lPJbtM2TkoChU6yhc85uE6ezKV8bAoDfk
sPblfTXu2yLQFa2go6jFej2my0NdaZ7Y7L67XpSV7tRVtwbh7xA8QgksmwLA1zZc
wtbTweaJ2/tsZZiKWoSik3J9g6WXEhY37RbEdMawd0XUreZ+zifvx6nac9jeO5aA
M+hyNKws6nmZPzwacBPX9Inzh7yniV+Wqbhz1RAgyp9cYOzrjQOaxMhn/MkR8+lO
ABpqkIuhuy38ymKotf8XBcxRqMfTf/U5tVuOMDBeS0wNQYOCdjURCorLyTQC0M3M
MR9Fv09wUJLLTExuCoWSIVu1YDN+tOn7wOtoMykj0SSm/eyhwbdm8N2I1kPCBiBB
49a/vNyyCf6c2BoQKx9INQtUzlhzd3eGCAsGxz+CM1v1+ljvElO8e52nbvYOR4TX
cuFPdYlYN+04UnQWnJuRrJwO+5jAdCUPDDUxYZAM++mYKwqBCyBeGC7yXklKHpGk
qsA4AukDgAt/6m0kErJ8rQYrlNodSrDpV8RCCYERzYBnRvqNG62nHIw9tb/Kaqvi
7v5+EIQGAzOQxwaJba1e
=2Jyv
-----END PGP SIGNATURE-----

--rWTGJt96jR0TCFDW--
