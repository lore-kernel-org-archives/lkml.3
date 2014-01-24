Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaAXNFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:05:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58938 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaAXNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:05:24 -0500
Date: Fri, 24 Jan 2014 13:05:09 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140124130509.GY11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-8-git-send-email-Li.Xiubo@freescale.com>
 <20140123193945.GH11727@sirena.org.uk>
 <638679dfd176409680c962cdeb3704ef@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j+D14l8Ki1YJdzYp"
Content-Disposition: inline
In-Reply-To: <638679dfd176409680c962cdeb3704ef@BY2PR03MB505.namprd03.prod.outlook.com>
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


--j+D14l8Ki1YJdzYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 02:46:33AM +0000, Li.Xiubo@freescale.com wrote:

> > > +static struct snd_soc_dapm_widget simple_widgets[] = {
> > > +	SND_SOC_DAPM_MIC("Mic", NULL),
> > > +	SND_SOC_DAPM_LINE("Line", NULL),
> > > +	SND_SOC_DAPM_HP("Hp", NULL),
> > > +	SND_SOC_DAPM_SPK("Spk", NULL),
> > > +};

> This is the templates for "Microphone XXX", "Line XXX", "Headphone XXX"
> and "Spk XXX" .

> > Does this mean we're restricted to a particular set of names?  That
> > seems sad and won't work if there's a desire for more than one of a
> > given widget - the main use case I can see is multiple microphones with
> > separate microphone biases.  How about having some templates that we
> > copy and then replace the name with the one the user supplied?

> This code has already supplied this I think.

OK, that's fine - this is one of the things that the lack of binding
documentation doesn't help with, it says what the code is supposed to
do.  When reviewing DT code without bindings I tend to just skim the
code.

--j+D14l8Ki1YJdzYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4mUCAAoJELSic+t+oim90oUQAImrSBAVAii4RuhJIIBgatwE
2sF2HKpCBBo0LXdvFoLOH2uLXlsRxc75o40CZggvo3DG7IHyh1w88O9mXyD6w3XA
t/N4hKljCzb5TFVXiNqChoyHMZYCMfKu+hS6E11Pjsp2pyt7D516p6HxrASDdPSy
8oYlxY0gngmGdK2X7x39wH9dmrp99dMDZYwmuHWO1q9mDvXTHnx/k2j/ZP7+bABL
naqZF2fCa2TiAZO5+P0sg1hIyMMHMbknEjpoeWC1h+TwjSUN4JKjuV9C63Tei17G
kp3obYR9OQcsJFWqeWNVIB1irxDGFoiSq7N3pjWKStxcC/CcX/Vqrz6grR28dM4c
CV3j/jQhjZ63U7VQo7rQMdwE12o7PKxS02xioRQL+pvKZ7pG2KvuP8sUIGbS7uBs
RqtjbNOj2LQjufVXCKBaQxFK6AFs/NP0pHyIglcCMO7DKRQrQSE3bCf1BQvQXH19
xYIP8wpA84jipxk6xdlAgr/JgByooGLk8f0qpSPUcW/kCZQpdI/ZIkWSdS9Pcm/L
440KpIoJJhJc/Jo+QTxtmIQXVKiBkeS5AH2+Tnmfxntu9Bf9PoZwJKxpeW7BiY1q
tzriy+R2KuBSCRkRbYvKQVHRArpVEepRq/USHIzqNFvNz6Al9cqKER2T0YAjvJlA
mwKgizTLDHVk1N26+7C/
=TQRN
-----END PGP SIGNATURE-----

--j+D14l8Ki1YJdzYp--
