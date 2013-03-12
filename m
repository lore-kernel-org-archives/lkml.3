Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab3CLTlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:41:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56430 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932361Ab3CLTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:39:43 -0400
Date: Tue, 12 Mar 2013 19:39:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        device-drivers-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next v2] ASoC: adau1373: adau1373_hw_params:
 Silence overflow warning
Message-ID: <20130312193940.GF19942@opensource.wolfsonmicro.com>
References: <513E2895.6040904@metafoo.de>
 <1363029503-23880-1-git-send-email-tim.gardner@canonical.com>
 <20130312184741.GP19942@opensource.wolfsonmicro.com>
 <513F7F46.3050200@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mjcb6KWfk+dITC8b"
Content-Disposition: inline
In-Reply-To: <513F7F46.3050200@canonical.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mjcb6KWfk+dITC8b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 01:17:26PM -0600, Tim Gardner wrote:

> > threads (I nearly deleted this unread) and avoid including

> > enormous CC lists like this in the body of the mail.

> I'm just going by the default output of scripts/get_maintainer.pl. Are
> there better options to filter the roles ? In this case I received a
> review from a supporter (Lars), and the patch is being committed by
> yet another supporter (yourself). Would you have noticed this patch
> had I restricted the Cc list to just maintainers and lists ?

I specifically mean don't include the lists in the body of the mail - it
means they either litter the git log or need to be manually deleted.  If
you're just using unfiltered get_maintainer output then I'd suggest that
you generate the CCs in your scripts when sending rather than putting
them in the changelog.

--Mjcb6KWfk+dITC8b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP4R2AAoJELSic+t+oim9P3AQAIPWUyxRmtIcvzCU0Yed7hil
nAB3vybN+CHd3/rF+wjKTfXuoZFgDyixcHjgjhV8u1APMl1PNdyixznsT5k2gBxy
VJEvO3y97vFBvbgF5DTYdKkDzxjx79TqFgqlqwkPPhD98Z0btN+1RbV5c75/yJen
r45kuZbEbtYgi4L3ghOH3x8vg1mKZaZhRDZYBNx+mvC7f+pfzjABn9MA/xz/CTWo
R433fKvi08fD1WuxWDEkvHP0lIFUZt8w930bjzzxFsHwUFYyyXZjBcU5FFuTR2O0
KzWZU0C0SAWZqyxfdmdrhUtZJPwfj70p4lVi9fsFOJaPdyGd+d0ReCbuu5dPfRfz
EH/OEY0CRGyBw3A3R8c9Zp2XzZ+Sh1w3zC/USeJcce0V4TXXdz/xvlRx3Vx5ByOF
mWmDhuq1qWPJ/xzJnO9Ig47nMVfjKD7v0Zvotawczge6YjFdOSdxpmBNczCIbAbr
Aik4ZYWGOuNVYyOWzN8Agm29IDpbKDNBr7yrDBsS4LAL5+gE12CJtKih49YAKFAL
Io4H4tUrwqkUJKA1NUiXamUl6cfLtGpKK7K5MoenuOCZpOjccfaq3pDMJTWr/rhc
d1L8mlt61zze7us5mSWuuCDT6QkfI68MQxEq1LtfBiIr9Bj5eX7+qKh5bttWCD6+
rFwkAie9O4uFGFIEZczh
=FY2y
-----END PGP SIGNATURE-----

--Mjcb6KWfk+dITC8b--
