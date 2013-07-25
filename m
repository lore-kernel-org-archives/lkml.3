Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3GYSYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:24:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54185 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3GYSYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:24:08 -0400
Date: Thu, 25 Jul 2013 19:23:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20130725182356.GN9858@sirena.org.uk>
References: <20130725111314.66b811bc@armhf>
 <20130725093855.GB24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9KV7gQ2WEwhe+RIz"
Content-Disposition: inline
In-Reply-To: <20130725093855.GB24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ASoc: kirkwood: change the pcm/dma stream data
 pointer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9KV7gQ2WEwhe+RIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 10:38:55AM +0100, Russell King - ARM Linux wrote:

> There's a much better solution to this, which is to get rid of
> kirkwood_dma_priv entirely:

This does seem a lot nicer, can we either grab the relevant patch from
your tree or update this one to use the same approach?

--9KV7gQ2WEwhe+RIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8W05AAoJELSic+t+oim9Tc0P/3rtB+vcNvPnDvRurWTYd9R3
QVmCINpjOKEYxhjsiMpzMYIGF3UNzTpubzqtfcxTXtx/jWOHychBhMEPdibLhRjB
QZfU3QuNdUJ8ieZ1YZ2+ItPswQ4Bpd523C5AoxcOt2Xp92gpFlJiw8OzIruznydT
S3pNgYatAiWTe8LbSovS5u3IK/zGasGiyojCWNhCmx+eYstlJsxXmm1/HNc+Tv60
mqyqhCGS5XEOZNSx6zpUHKDl0lbiOYPlcgXr10vvQRx9Ckh2IG0Kg/LwI8xroG8Z
T4WBbA5uqfCULHpStIuwnR3HUKHkmYZSNNnQl+tYltuHhOA65McdA0VG3TV9FTz4
n1GV9h7q/IuASTLUPg4OCrc6/A2tipzO+jmq1ZPty6Z4GvofPPm3TKx5QLSbEcEj
Lea8irCuhLU691g0lbFMKwrlEV/7iPa71PtyhfuKSA42Pbbo/2kv9jwATnmExQed
At2W+wn6hgZsvi109PXfYdWqm2SebQAB69EgSXLc8cdIMO5jhyqR8c7E9mDxKUvV
iFaHePfJL+r5r3UQw9Vkp+zT88hU7kemkPw1TOIoA7YS571P1WJX2S3xYJ560+0B
3kBDZIuWXTLHP69xkGF26dJgEZZmSJ6FDKizOTxuCEZJQ5UIKNJQMdgityuip8Wf
QN/EIC6lq9DKTdUq3Pno
=YzPe
-----END PGP SIGNATURE-----

--9KV7gQ2WEwhe+RIz--
