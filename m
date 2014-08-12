Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHLBAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:00:30 -0400
Received: from ozlabs.org ([103.22.144.67]:48087 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaHLBA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:00:29 -0400
Date: Tue, 12 Aug 2014 10:59:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 11
Message-ID: <20140812105953.3284db9c@canb.auug.org.au>
In-Reply-To: <20140811170510.GA19750@roeck-us.net>
References: <20140811155213.0aa083ce@canb.auug.org.au>
	<20140811170510.GA19750@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.wJEsV6HEAhi8cU/nLI=w2C"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.wJEsV6HEAhi8cU/nLI=w2C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Mon, 11 Aug 2014 10:05:10 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> New build failures:
>=20
> Building arm:s5pv210_defconfig ... failed
> --------------
> Error log:
> arch/arm/mach-s5pv210/pm.c:150:12: error: 'suspend_valid_only_mem' undecl=
ared
> here (not in a function)
> make[1]: *** [arch/arm/mach-s5pv210/pm.o] Error 1
>=20
> Building arm:pxa910_defconfig ... failed
> --------------
> Error log:
> arch/arm/mach-mmp/pm-pxa910.c: In function 'pxa910_pm_valid':
> arch/arm/mach-mmp/pm-pxa910.c:243:65: error: expected ')' before ';' token
> arch/arm/mach-mmp/pm-pxa910.c:244:1: error: expected ';' before '}' token
> make[1]: *** [arch/arm/mach-mmp/pm-pxa910.o] Error 1

The patch that caused this has been removed from linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.wJEsV6HEAhi8cU/nLI=w2C
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6WcqAAoJEMDTa8Ir7ZwVTaMQAJKceZ2bmPB+4yG074HOr/Bd
SYJldv6ZRrr4FovigDAIRQQQ2vKgMcPPY9eLZuM6z2eWKmw/8nMdQIpLGs54DHC0
VrHgSa/djvFAJmXxnssqcqzWgtbl0rIzRGnDGl6Tdmj/AMjdMjPhjYaH05HgqcqO
xLoM9sDyHUU12BCmagy5Y+PGZQc5Ka6SWkhdIz/8uECCCaWKPoHpE1ltaWllkXZ9
YiQItoRI/Uo1mzZziyrXS5svKQ17i6WwLC9h9/iBmGyZIskJ9FVBAhG6mc3YJZDS
bs0YexmQtxmQsff+5SuJqdRz4ICjZcUjsjwGkDcMcXRA7aVXknKpiqpjMQ7iv2nh
HZOGldFapTH0cs14oRpZLS3F6/S1FXu4WJ/atVTCzgYKWruMeA/4lh/HIn1mOt7g
61z3kSLA0ReepqxsFY2A+KbQo5eXuWp4MHZN1YoyP/ip/qxF+I9hZLYkFehz56gp
dQOaM05WUFYTurhYy47HXhWB3FjnXVvfGAIqcG5HdId7xTom2Fm2hLlJWKwiBz86
nHEqjGgJrciaX7guHwwydAa+IeZXYzako5G+rDPVPXqz/fWQWUS4m4XBRpza31F1
oxBeDD7f4C+Hpjy5ETZ71FTZcA9E5++mBS1FpU2+e+DLbC9K9Hd2Yh2dDKe6hrrQ
Wb8qZBxFhHuVNC5aspxF
=dqcl
-----END PGP SIGNATURE-----

--Sig_/.wJEsV6HEAhi8cU/nLI=w2C--
