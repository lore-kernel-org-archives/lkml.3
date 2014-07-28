Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaG1LnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:43:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaG1LnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:43:13 -0400
Message-ID: <53D63746.3000905@suse.de>
Date: Mon, 28 Jul 2014 13:43:02 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-10-git-send-email-afaerber@suse.de> <53D20A61.1050506@metafoo.de> <53D21066.8000905@monstr.eu> <20140725101815.GO17528@sirena.org.uk> <53D2324B.4070602@suse.de> <20140725103905.GP17528@sirena.org.uk>
In-Reply-To: <20140725103905.GP17528@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lXpipEJAHPj3Osqm7UqSajc2j4sEL3FuC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lXpipEJAHPj3Osqm7UqSajc2j4sEL3FuC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Mark,

Am 25.07.2014 12:39, schrieb Mark Brown:
> On Fri, Jul 25, 2014 at 12:32:43PM +0200, Andreas F=E4rber wrote:
>=20
>> I used scripts/get_maintainer.pl --nogit-fallback. If you were not
>> CC'ed and need to be, please submit a MAINTAINERS patch. :)
>=20
> You need to think about what you're doing when you use get_maintainer,
> it gives both false positives and false negatives.
>=20
>> Maybe this works for you?
>> https://patchwork.kernel.org/patch/4620191/
>=20
>> Otherwise I can resend with Ab/Rb.
>=20
> Documentation/SubmittingPatches.

Not helpful here, nor is
Documentation/devicetree/bindings/submitting-patches.txt. It's separate
from code changes, sent via git-send-email, has a Sob, went to LKML and
LAKML and DTML. I could add a Fixes: header and CC trivial for this
one-line fix IIUC.
Doesn't tell me which patches I should CC you on in the future though.
Therefore my request to fix the false negative in MAINTAINERS so that me
and other kernel newbies don't run into it again.

I'll simply interpret your reply as "yes, please resend with
broonie@kernel.org CC'ed" then.

Regards,
Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 16746 AG N=FCrnbe=
rg


--lXpipEJAHPj3Osqm7UqSajc2j4sEL3FuC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT1jdMAAoJEPou0S0+fgE/08AP/3WgEGNL6KIH0QPeI89i8vFj
yWeouN29Q/wibvlAI/876TBCtWCsZv7or+/BFsAXmUuNIqgx83ri5Uaf0q9VcGSN
p4FF5/UQQtPfArGXd6wfCt7KZEecM/OmZ8hcnrZ9xrOAvtn6kkrbuvjTMfiV6UYh
xEhuUN3J6kbvxwgaTD+TwbL6DUwaiL4eLhsGGLM8SdXgZ50SD4OakPgiDeujBhMx
5WFVMoBnLaHEKBrixQA5Huv59CN4sEBN6AoXpDHr0Cb26BpFNN+DCpabcMrcgssO
k4wupoqox8Wmj3ahF/LQhuvntxoLIlcLyAmrFVtJmttm9cW1sg0QXWRZyPri/cDv
9/UhPcPJaQJ79SFvMbOyyNzYSFV0XbFNPUxmzgS6cTzyYedGEgWLElwcVa/Fh3X6
Ygos1Xk5iP6bm7rh5SXBqLLaaoFxqW6pdo+x3qTnwKq2NFH+UkJ49vYovHSjoWPp
m3eJkM7M6rtrZ+5K+9CclD6z5sIWk6Sx1oGxJ0CN3ykXgpirOX1P1UM0sOfZrcG6
LFcWzqTI65q5uVZGucXwbWKpvjppSWj/LxBPTr0VgcEF5QjT5Gowx3iyYUDPN4gA
P9HUxOGov2+RGpTIbMTrETCpOAnFs0m0NNPrpmjGgIBxrC0Y2qgMVid+YQh+YDm+
v1c+jumAfThKU4IJGrpg
=smt/
-----END PGP SIGNATURE-----

--lXpipEJAHPj3Osqm7UqSajc2j4sEL3FuC--
