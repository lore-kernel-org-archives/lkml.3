Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab3FZLj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:39:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53169 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3FZLjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:39:54 -0400
Message-ID: <51CAD305.30407@ti.com>
Date: Wed, 26 Jun 2013 14:39:49 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Etheridge, Darren" <detheridge@ti.com>
Subject: Re: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com> <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2OITXHCGRTWNDNETKSBJQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OITXHCGRTWNDNETKSBJQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 16/05/13 10:10, Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>=20
> Use devm_ioremap_resource instead of reques_mem_region()/ioremap() and
> devm_request_irq() instead of request_irq().
>=20
> This ensures more consistent error values and simplifies error paths.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/video/da8xx-fb.c |   39 +++++++-------------------------------=
-
>  1 files changed, 7 insertions(+), 32 deletions(-)

There's something similar in Darren's da8xx-fb series. Can you check if
there are differences?

 Tomi



------enig2OITXHCGRTWNDNETKSBJQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRytMFAAoJEPo9qoy8lh71bL0P/jSpDzpIWoy3BR9Qu4NXSpgn
vT0jQ7TlDqufQn0UOju4mSLA+mrhk/x8APoiPSe3fidWbCTECMU0vhxelpa99KiT
ft/EhaUplqm7+f3rukH6V0/q8hbx0VTHl548PcI6nV4MraHCkn8MKDy06nDwloqG
llXoO2gP0rSIRZSDIHpCip6rCcH4jAP57aIGu37Y9gONAMbWlXBp31OEpV7knsZU
x0lktlYSrizi4aqKynO7PWQYW8l604I8BB+FtKuHyLjE1RIGjYzl+62RWmPn2ogb
rmI++iAtOUnYT8B6NbtgLh37n/Sgl81M6OWLZJALXZSJNBR5X26pDqV8e/Xhasxx
Jw0Ylxxaiq7VmOJ3zkaUCxHfL8OP6tYWSRAHpS9U9LI/ikFTbJmBl3qF3IyJtFDx
JfvfYw0ZEjaQI0cYdUsg/mBjn/EUryYwlH92r+KG4HnSgS12FtTToe8duqApmmfD
CyZpTa5iWLAvBoa43jY+eV8mjeyeE1LKZTtiC3I0Iv1OUmPOIMcfLci6ZL6x4KlK
lH/zqiF1Lckv1gb2+vnSMjga33aayWRyPb1X9QwL79hlB0jQGINBmb6aDNsxwFjO
P0UfRY4gpTiaANZZO28ssXT6eoB3h7rv74z0nfESirue4YftPef/UugrliaZs2Vi
1D+SW2sK5xPf4rbtv2qM
=ikju
-----END PGP SIGNATURE-----

------enig2OITXHCGRTWNDNETKSBJQ--
