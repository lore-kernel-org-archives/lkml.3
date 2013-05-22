Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3EVP4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:56:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44034 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3EVP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:56:46 -0400
Date: Wed, 22 May 2013 10:56:28 -0500
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130522155628.GK1627@sirena.org.uk>
References: <1369228886-3527-1-git-send-email-wsa@the-dreams.de>
 <1369228886-3527-3-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e7MbhXUj+2isZwqc"
Content-Disposition: inline
In-Reply-To: <1369228886-3527-3-git-send-email-wsa@the-dreams.de>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] sound/soc/fsl: remove leftover release_mem_region
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e7MbhXUj+2isZwqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 03:21:26PM +0200, Wolfram Sang wrote:
> When converting this driver to devm_ioremap_resource, the removal of this now
> unneeded function has been forgotten.

This doesn't apply against current code, can you please regenerate
against topic/fsl or mainline?

--e7MbhXUj+2isZwqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnOqpAAoJELSic+t+oim96CoP/0H8fkH+KUko39u2bFWR7fWM
BNKlO1wjJOonvz6mz+KYXCI36JtQoMd555HILySKlmF8PnPROFx1/1MtQMjjgt6w
7WEysuJU8Rv0TeKrtXOMq6daHtmEYDOYrz7Jtha6NAB/9eB/9RQryBKj8peLyVG7
rHNrFcqpfhk5vmJ1yKgCVBB/4H8RdNlwc4WpjhKevDaaRp/LE89UrXabCJD1i1nV
0cIR8fnwZ65+MOVlBl4hfYXtjJgBJmd+ZR3BUAikZDwCWEJdxqiLQWBIeB965wpO
2MpynD2viFBnfNXj/UcHe0aiJaErZ2L2gL+9GHntnqQfiZ3PDRjGGfPI1VexFW6p
HjNFnRbsxcSJYDYwzp+4BcxU9CvHczGCnZiXKGEbmt5ZKo2S1u6KG9JIvviHHNGr
S9d9w10Y+YHFX8+PcPh+wqWXfwPb8bVyFTKrFhZEoBuZ0I7W9CBYO+XVd5FYW/F6
q8is2cw/yOnyyOsoAyDdiQaa2f1VuBnxEDvn575aPxzyo9TkRbQcOKLaVB9QLnNu
mflnep/Y+WXlqxR4p5Brr9flolMZxfmM9YcPDw9hS1gmXWptb95+NwngIdP7WmP7
YRRFnhKHt8SzBjTuksMGf6LgW0x0hrRo0F19Vs7jRsp82C7ltU6vKpjhxT2XQ3wM
BcQU9qJrRbvzN4tn7nkn
=k9cq
-----END PGP SIGNATURE-----

--e7MbhXUj+2isZwqc--
