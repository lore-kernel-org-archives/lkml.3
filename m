Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaD1TMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:12:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34241 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaD1TMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:12:32 -0400
Date: Mon, 28 Apr 2014 12:52:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Apelete Seketeli <apelete@seketeli.net>
CC: Felipe Balbi <balbi@ti.com>, Randy Dunlap <rdunlap@infradead.org>,
        Michal Marek <mmarek@suse.cz>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        David Fries <David@Fries.net>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Ben Hutchings <ben@decadent.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] documentation: docbook: document process of
 writing an musb glue layer
Message-ID: <20140428175204.GS30292@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140414201028.GZ22445@amegan>
 <20140414201256.GA22445@amegan>
 <20140428173026.GV22445@amegan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCKkSrrNUaKEhaIQ"
Content-Disposition: inline
In-Reply-To: <20140428173026.GV22445@amegan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lCKkSrrNUaKEhaIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 07:30:26PM +0200, Apelete Seketeli wrote:
> Hi Felipe,
>=20
> On Mon, Apr-14-2014 at 10:12:56 PM +0200, Apelete Seketeli wrote:
> > Document the process of writing an musb glue layer by taking the
> > Ingenic JZ4740 glue layer as an example, as it seems more simple than
> > most glue layers due to the basic feature set of the JZ4740 USB device
> > controller.
> >=20
> > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
>=20
> This one wasn't part of the pull request for 3.15-rc3, so I was
> wondering if you are planning to pull it in the next round of fixes
> (if it qualifies as such) or just waiting for the 3.16 merge window ?

yeah, probably. I'll get to this by the end of the week.

--=20
balbi

--lCKkSrrNUaKEhaIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXpVEAAoJEIaOsuA1yqREznsQAISpswpzGw+IdOQhS/S96gnQ
5vqEXXR/MMi+pFcNUP2FJPkAwbcIVHRlDZWUp7NB2W+Tb3OgnzCl2+jTKZUxCofN
CdSJmNVfBHygbAuM2sKqFHjZOA038c2hAmBuwuZmFVfslPSveOK2ZFlBAdXqIXQf
ncNgG2f5sC3RO38vVIzQYJIi/DpNI2DEBikBq1MWwH2CtFPaxGcSNUrk7tih8GL+
HI/C0Cviys9AIr0w3/qbjjuJAy5jEOYTFyfNTiOLCP49ujSGO4yHe2gMWQeHPGHN
+LeuPhC+rYaq8o+c0VpiIYbGNCs2yoCewSjC1GshcqvaNfkui4tfBnKf2rfWp3YL
T7TA7DTqgv68tpycT2DmFgSuvcWnjD/219Xt+OznIFeMKOKAE9vvycT216IY0BaG
ak7BjgnFGQqIXj2WessC054hLU6z9om7iqrGyd4iGLC/XZIllgxoLit2IzXPnSeO
3jVs7nbLVIumv4u5W6E4kk+vzw+PX+crD/mNxtSaIOyu/Db9HalH9RFWYyghT6SW
KU/3tKes4vFT+/oC6YzjJdw+jSrL/fCi6Rt9FM3Qe0SMV/9Q9Im8sNTmaFCi/TRh
NgHqimWYofqKslIceMigXBVxa2DoYbYNvU2xeuM/WTyBJLiAm9Qeax0RAKzfw0TV
LuxqJh0bXM4tzUNm7rL0
=HKWz
-----END PGP SIGNATURE-----

--lCKkSrrNUaKEhaIQ--
