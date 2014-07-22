Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaGVEsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:48:08 -0400
Received: from ozlabs.org ([103.22.144.67]:44943 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaGVEsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:48:07 -0400
Date: Tue, 22 Jul 2014 14:47:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@sigma-star.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Global signal cleanup, take 4
Message-ID: <20140722144727.441bcc2a@canb.auug.org.au>
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/d+81fpIa4D7A+9a2.i4FEvk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d+81fpIa4D7A+9a2.i4FEvk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Mon, 21 Jul 2014 16:02:46 +0200 Richard Weinberger <richard@sigma-star.a=
t> wrote:
>
> The whole series can also be found at:
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v4
>=20
> Andrew, can you please pickup this series?

Why don't we just add that git tree to linux-next? Then you can send
Linus a pull request in the next merge window.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/d+81fpIa4D7A+9a2.i4FEvk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTze0CAAoJEMDTa8Ir7ZwV0Z0P/jmWTVR9D+rTW/vtxJTGg898
y7dgRN6O8BQH9+5J33HxVaWSWY/qapwPB4ZWiGm7CJw4YdSGf3R7s6iy8y0h1Y+B
eenoPitCUzzZCgGxCyFMILlaFZ6qwHI/E3kxp3U2j/5YORXCElLx1kWj9tuSY/9K
adcb13jaKJsXOMN31LB98I3dT5wlBT0DipHr4OoeKzm1gn06vptQbEo+/jyeXGJS
JXf8zdv0LGKRTjwtapMH8aLRwM/Jll1lIc+G742gY1C+vZzPSubHutJO+c6iRS3Q
WtKvebgk8Mj02G22Tb2NT1dcRzXOo9DRCSpFUEynhCSXIMrVO0FmqoB99XdRZBSr
SOdcka3hTHuVT1iSDRfNc0h9WVIMz0MuJhjCqUDB7QjBCqzNjTZ7nCRIbpG83Zxq
Zqd0xp8npwoDyi7dMHDkmGXn0X1KdQuqCjPY5RWFTdyAQ0RKOxLV8wqWGTCBStfr
Y9xZWn8Dkc/k0CPmcH5jBZoLT581GOqpa/Umz71eKHwq10h7j5b34223Gi3uhkm1
gh1PvaoaQEi96KOMkLJiI42JdG8/+PkpPWCq7IjaE33f5yZzjF2ndhV3GqSqXcx8
czpZxLpprkWCquzjP2lrhg6zsejtRtM7uMZXDrLfSd7+ioH/DorNiRJ4O4Hc2Wa8
0XdbwLNdfpjBkOw2eS2a
=iBo6
-----END PGP SIGNATURE-----

--Sig_/d+81fpIa4D7A+9a2.i4FEvk--
