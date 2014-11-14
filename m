Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161435AbaKNRIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:08:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38548 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161302AbaKNRIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:08:30 -0500
Date: Fri, 14 Nov 2014 17:06:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: gsantosh@codeaurora.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, grant.likely@linaro.org,
        alsa-devel-bounces@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Message-ID: <20141114170650.GG3815@sirena.org.uk>
References: <85499f52ebd29581bf58b9cafbae6864.squirrel@www.codeaurora.org>
 <5464CDE2.2070406@linux.intel.com>
 <fd33d16f31eb73cc6f0585c192601d9e.squirrel@www.codeaurora.org>
 <54662DC6.7070302@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6cotLj5rESeNB5ig"
Content-Disposition: inline
In-Reply-To: <54662DC6.7070302@linux.intel.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] Question on Compressed offload session
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6cotLj5rESeNB5ig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 14, 2014 at 10:28:54AM -0600, Pierre-Louis Bossart wrote:
> On 11/13/14, 10:08 PM, gsantosh@codeaurora.org wrote:

> >1) in Codec driver avoid adding hw_constraint during startup if compressed
> >session is routed, this recommend for codec driver to know that compress
> >session is routed to codec which I feel not the correct way to handle this

> >I was checking how to handle this situation in much better way.

> What exactly do you call a 'legacy codec'? If there is a DAI i am not sure I
> understand the problem.

I think what he's trying to say is that there's nothing automatic which
will ensure that constraints on the back end set by the CODEC driver
will be paid attention to.  This is true, it's pretty much entirely up
to the machine driver to make sure it gets the back end links right.

--6cotLj5rESeNB5ig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZjaqAAoJECTWi3JdVIfQuFAH/13RyikXZ58DwaCl7jN85TQ8
BV4EwR+3FqqXVcXw4fX8JLkRyNmUnkv4GSQyFTNEICL2qoHHKSlnd1fbow1tOWdn
NGuhgFL1yqraNjguNS8/bBKfbwFOZ2OwhQruKXWuZdeOyKJ6qZ+GffsR/ov/7LY4
Ggrfl4PqjPowCWMulNgwCkCfdy84/E1tzPOfInBj6YXDeORs+Ros6kgnOiyAyXHf
UVUnExmdreqnqHpnVeBS4TT68hM2Wnh8A7jmWISM6taB6bHe9BAiXpiqtEOx6DBq
6Kwqjn8w0jZ1jfVUuof+cJs6t/C+MYSabOLn+M6brV8ZY5Z1P7AZvW4W2PmBkC8=
=hWv8
-----END PGP SIGNATURE-----

--6cotLj5rESeNB5ig--
