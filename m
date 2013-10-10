Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3JJOT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:19:56 -0400
Received: from ring0.de ([91.143.88.219]:36441 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab3JJOTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:19:53 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Thu, 10 Oct 2013 16:19:22 +0200
From: Sebastian Reichel <sre@debian.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        "'Pali =?iso-8859-1?Q?Roh=E1r'?=" <pali.rohar@gmail.com>,
        =?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [RFCv3 1/7] ARM: OMAP2+: hwmod-data: Add SSI information
Message-ID: <20131010141921.GE28657@earth.universe>
Mail-Followup-To: Paul Walmsley <paul@pwsan.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org,
	'Pali =?iso-8859-1?Q?Roh=E1r'?= <pali.rohar@gmail.com>,
	=?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
 <1381091235-18293-2-git-send-email-sre@debian.org>
 <alpine.DEB.2.02.1310090542270.30199@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310090542270.30199@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 05:43:13AM +0000, Paul Walmsley wrote:
> On Sun, 6 Oct 2013, Sebastian Reichel wrote:
>=20
> > This patch adds Synchronous Serial Interface (SSI) hwmod support for
> > OMAP34xx SoCs.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
>=20
> Thanks, queued this one for v3.13.  You can drop it from any future=20
> reposts of this series.

Thanks.

-- Sebastian

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSVrdpAAoJENju1/PIO/qaXjMQAJyWFTugpaPfCNs57stTRki1
3QB2FKlVafmwF3fen1fNcVnYOxOD+bx2ihkoizWZNdt/sh8W0C4vqJBkbHW1PiN0
CmKQkilvgmEQ+q4QAC0jndT/PFVo3qlX1GrQrECU5LOGQ6v+jH5Q0u2TNcRU2KFI
AT5VCenUhkpJ4l9sZzGLUGXB6Ysxjh98UPFdFE63y6NRyIRhLK2Vn3uwa/xR3/0G
0QT1XKvHlBb2bRZ3dZU8nLIoMEJsr4zJot7fq/EkyRh2uV/+nFf+UbvGiODeoZZu
RBhmiRYDRT4AgxyGklt6+uNO/fUGEDqCggTPJZeriKnhxAQKnELl+P56w8vL6aW9
rWGQCMxSxEtpXsuE5LleyCNvZq721nBTiHFUMonHaWSde88eYUiRoFNx8m64Ah8g
NZy2/bdKdHxUbv6PpKyTqA8XHuSi6dUus0rYXD43sp4okrjsOiNcQwbHl82D26Qr
XhbnwFmr3FX93Ss/y7Ka0hoEgYPVOg1jKzIgpaV26Xp4V8YyFEa0/So3NfNoTh7U
rUKW/7K5b/BvayFnaDvi+1/4jzloNqH7B+vg6QurQH9FSTAzGEgQbhXgm7RS9zPj
S9ztGLstjtjFGjEL0Z90AI8F9vTqfuv42cAfSoB0vbNKtDodgqs0doSRUUEM/aMF
C/1jq7zWeYs6KQlWL1C/
=VL0e
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--
