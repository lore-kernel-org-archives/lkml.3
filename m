Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaDRJuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:50:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60509 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753338AbaDRJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:50:04 -0400
Date: Fri, 18 Apr 2014 11:45:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/6] sound: lx_core: Remove unused defines
Message-ID: <20140418094515.GF4132@lukather>
References: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
 <s5hd2gfukvh.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w/VI3ydZO+RcZ3Ux"
Content-Disposition: inline
In-Reply-To: <s5hd2gfukvh.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w/VI3ydZO+RcZ3Ux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 18, 2014 at 10:01:22AM +0200, Takashi Iwai wrote:
> At Thu, 17 Apr 2014 11:51:16 +0200,
> Maxime Ripard wrote:
> >=20
> > Commit f9367f3fbe3c ("ALSA: lx6464es: Remove unused
> > function in pci/lx6464es/lx_core.c") removed the
> > lx_dsp_es_check_pipeline function that was the only user
> > of these defines.
> >=20
> > Since they're useless now, simply remove them.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Thanks, applied all patches now.
> But, at the next time, please put my correct address to Cc.

Hmmm, yes, look like it was a typo on my side.. Sorry.

> Also, for ALSA stuff (except for ASoC), we usually use "ALSA:"
> prefix.

Ok, I will.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--w/VI3ydZO+RcZ3Ux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTUPQrAAoJEBx+YmzsjxAgX9YP/jZ7xhUk9GaBuGSe/nBylDTS
oDIUnoV+o0SIRwrC1KCgIZ97naaN4+ODnyd4/sfcbHJnKLJsQUnW69IINetwyPxY
EMLfzPMTWdE7RcNyWcUG0kVcIvblWnKF3EYKiDZFmDct1kH2i6hWltRUfKt5ft6R
2AO6u1PLICBXlpi9F13f1ZCZgTEJU/eIjBF4rv0YSvJhM0IW9WJekHHglYtQ8Mn/
pPp0ge6y3rB9EIC8S71It1eBk3irlU+yPbmlU9A1szDaJnmipWlBxqgHgfzEJETJ
ne22GTXUOW9ihltA68TekmGz9OU9x9FRW+7GxKU9KXwBZxM5YsIp1DZKS2ccKPWL
anqIjZOA+SKgFnf2T1n6XSNgsyUW4PLMREjQWUZQJng6hWTESfErKkcxFG20QRD4
+qk67M+Zt0nNa339mfrb04eDoba9GVJdtzbWTgMayadlqzjVMRXgvH0AKl79H55b
3gR7A61zEQHpHjv2AXnP3H1TC2m7lEIA9CY0Cfh7Li+swXl4b0GJ4PwvQL+LqeGf
xW4gf2JQFJ6grAdscleiS8hSLuXWM4ekjnpt2EHDYpKKNeEAQ8pf6G4sNeg89DDM
LhbmVj7OnwIE3ZJ27cJ6CPpdpwHkWcoB4wXGi9H6jE3BRRLRcOEZw+qheQ2PZKpj
nhxVyMO4LNbj5W2XMbYY
=Nlyv
-----END PGP SIGNATURE-----

--w/VI3ydZO+RcZ3Ux--
