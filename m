Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaCSTPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:15:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51901 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCSTPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:15:10 -0400
Date: Wed, 19 Mar 2014 19:14:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Jyri Sarha <jsarha@ti.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140319191459.GV11706@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
 <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
 <20140317164339.GR11706@sirena.org.uk>
 <20140318091728.1d2240ca@armhf>
 <53296CB7.1000909@ti.com>
 <20140319134625.GN11706@sirena.org.uk>
 <5329E2A6.2040605@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54Got1pG2ocoWGyS"
Content-Disposition: inline
In-Reply-To: <5329E2A6.2040605@ti.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/4] ASoC: simple-card: Add DT documentation for
 multi-DAI links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--54Got1pG2ocoWGyS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2014 at 08:32:06PM +0200, Jyri Sarha wrote:
> On 03/19/2014 03:46 PM, Mark Brown wrote:

> >It seems it'd be a bit more idiomatic to do that with a phandle rather
> >than with a string in order to allow extensions for things like TDM (the
> >I2S to mono speaker driver use case for example).

> You mean a like this:

> sound {

>         bitclock-master = <&codec 0>
>         frame-master = <&codec 0>;
>         bitclock-inversion = <1>;
>         simple-audio-card,cpu {

Possibly referring to the subnodes rather than the device but yeah.

--54Got1pG2ocoWGyS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKeywAAoJELSic+t+oim9vU8QAJ5fb26dxr/Hq5PtcpeSMBw8
2+q5W9c5G/mRWp3r0REU0PyQ/pFQ88Jay0OIPEWf1HmNFK1NZyIpn2qdgaYHSeNB
nRDIAJ0egcHio0wfpH2fbgrxjAYdcMf4NLtL4HSLd6goG1JkAZ+VTHERYMljyGF3
Puhw/9Z317k4F/IF/enas1pbCY/HeUGTNpLxKQhFdcOfel1EPeMHuBH4NnNEiY49
2I4emKep9ON2vHMnPDIH9pKZQnbpcUUgmzs4TTI5Iy390SYUXfAGLdykWeHqD8DM
AZ4FYDBrfIgcBK4M/v6wNaR9yPXQefOhLgef7hF8EW+qyMh8L0/PqDntpvFQZdOR
aoCFkVNy0E7cXCpoq4pA+W9dLG954GZPTDnmOTvpB3z2JOFSxqXJw2jrT+iGPUHv
QzgBKarCg2v9F2RvT2+wu4DBzIPrEMwe6irqK4Ja/eiFqnJUHF/jx2mWC/INowwe
WSZWLGgFWpK9bm7dM+n9alGbG8Cf/6QjL3Dzi6Lmxsv47vkL6W7BS/tH8nSd7Pqd
qT3+HHPDrJj4lzfKAvsQeEYSnM/fbNDU6kqmAiaQKRZP+m4DRvHYdGEtWuEMgfh2
Es/Qtmd7xEbaU7ohzmwetecP8m2rNzfNIQhIjAGVDL4BauOIvq01gc5R/iBQBK2P
6z75yGYpbGfJarBtMUqh
=A9ow
-----END PGP SIGNATURE-----

--54Got1pG2ocoWGyS--
