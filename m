Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749Ab3HIJUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:20:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36244 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965452Ab3HIJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:20:03 -0400
Date: Fri, 9 Aug 2013 10:19:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130809091953.GO6427@sirena.org.uk>
References: <20130808132201.2610aef3@armhf>
 <5204A716.6070507@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8EQYc9s3Q1iGemBq"
Content-Disposition: inline
In-Reply-To: <5204A716.6070507@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu audio
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8EQYc9s3Q1iGemBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 10:23:50AM +0200, Sebastian Hesselbarth wrote:
> On 08/08/2013 01:22 PM, Jean-Francois Moine wrote:

> >+i2s1: audio-controller@b4000 {
> >+	compatible = "mrvl,mvebu-audio";
> >+	reg = <0xb4000 0x2210>;
> >+	interrupts = <21>, <22>;
> >+	clocks = <&gate_clk 13>;
> >+	clock-names = "internal";
> >+};

> Also we will need some phandle reference to the audio codec here. As
> this property is ongoing work in ASoC core, I suggest we wait for it
> and propose a binding afterwards.

No, as discussed this should be in the binding for the audio subsystem
not in the binding for an individual component in that subsystem.

--8EQYc9s3Q1iGemBq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBLQ2AAoJELSic+t+oim9LhAP/jttBFTOP8e5FYXk21c6cFjU
98zvR2dIUyag1WNph451NVk8P7gb6ew72h8GoCTghH0TCqbsX3/ZsXxSskP5aMTd
6KYgXRrC7vPmRK6eBI6bT01PeOPMl8x9UHLhyMR7J/u8iFW/5WZU/+hxIZ7aVbWa
ivsCqVJo1fBtMxV+RDQIktfGLiiSt/Dw/g0Ci/+Q9Q2+FMsl0oHEBLDjtNxmGIhC
9fETb755dKMxZ7SLU+TdU7UA5vJRJLOgRwjJUm6pogS7K5fFMdjZRpj5pMpR2Okl
/J2dcypMt57Ug3TYtkUaZHeLDkSy5OTIpqsub86V3AaR6dogjgo/BdZgyzEzP2Ss
voCYhf+Wr051EgFJllasn4N8xdf9cQUN5VchtkO6lTbkeIyV1dChWI0ZNQ2m7Mne
nppPqx4Gn0Pj0SO7prkCD1ZDqJAedPDPEEUZ4ihc84wy8AKQ2X0rbRZCObQJahvv
bZfBTKM7JgKGzpoN5Fcy0xcLBkHhMTS1Xv6oJINTX3+kokoShCA/12hQ4U58nlPo
ztMYbOqJCkepWg/HRW64dSRpnq6qTDpg+tEpWxISGGP1RSXX8HtNTPQrE2wL0isc
Ilp484d5H4IiI9NfjJHn6lTIqZO3uipAhr15jyU+eGAS4YE9vLKkHngSwyOggapA
ycgNdtH3NA5PW1v2PNmB
=tO8Z
-----END PGP SIGNATURE-----

--8EQYc9s3Q1iGemBq--
