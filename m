Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaD1O5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:57:49 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42203 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaD1O5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:57:47 -0400
Date: Mon, 28 Apr 2014 16:56:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Message-ID: <20140428145615.GA28443@ulmo>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <20140428131034.GA15946@ulmo>
 <e5e350afaa7b42cfbd93f52130560064@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <e5e350afaa7b42cfbd93f52130560064@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 02:26:57PM +0000, Li.Xiubo@freescale.com wrote:
>=20
>=20
>=20
> > > Xiubo Li (3):
> > >   pwm: ftm-pwm: Clean up the code.
> > >   pwm: ftm-pwm: Convert to direct regmap API usage.
> > >   pwm: ftm-pwm: Add big-endian support
> > >
> > >  drivers/pwm/pwm-fsl-ftm.c | 96 ++++++++++++++++++++++++++-----------=
----------
> > >  1 file changed, 53 insertions(+), 43 deletions(-)
> >
> > This leaves me with only very vague idea of why this is necessary and
> > why it should be merged.
> >
> > Please describe in more detail (in both the cover-letter and each
> > individual patch) why you want me to apply these patches.
> >
>=20
> Thanks very much for your reply.
>=20
> Should I resend this patch series? If so, I will add some thing like the =
following:
>=20
> The FTM PWM driver will be used in our Vybrid, LS1 and LS2+ SoCs, and on =
Vybrid
> and LS2 SoCs, the FTM devices are in LE mode, while on LS1 SoCs it in BE =
mode.
>=20
> So this patch series add endianness support based on the regmap core, whi=
ch has
> already support the rich endiannesses for the same device.

Yes, please resend with that description added where appropriate. I'd
like to see something like that in the cover letter and, more
importantly, in the individual patches.

Thierry

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXmwPAAoJEN0jrNd/PrOhGdwP/2X4/hvStBXCxfeTUAjpnqQ0
ZYDiw7B6sQfsCoJ9VQsVYUdpocWvHmMQXjkqzdiE+sm+qh24lMk3ycapFytzjA1W
hZJ9gT7cJuze0OE/n0QTxwaZ3g8213q1bCK0wgX/YbKCkw/w0dJtgAErq9KzXlpX
kF75t7Mraq73q9U6QVb8z5k4vzMpXFopSoAD4BfS3KhOP5AX6LHzxaZBtRUeWwgf
dFfv/CAJzEL+y1NYeos7OiVhbbk+FQ0PcERXsGM5XPEu+4rpgxmb1kXfJ5h6vIqy
hAE8NUGOX9ckPgkaPFJxvmq4BYw7xD6//UOkFF9n5+CsUcJ0cPMeShAWV99LtYLp
nrT9BREl7p+ODZodLSs89Bo6bmDPGKkewXQqBCjHGKTRQVvfLWk26o5uULF/N4Bb
yH8jd7NRZzdotuCADDAkremPQ/M1U5RZD6Rm9rfsTMGw3pcBgm0XzMwQvSkKHLGa
w01NbRE6LC2QokwkcMjE6CRpZfUsodgJDXM/ukIYrwiQTrog+pq/Mk8H+KX5lUy6
rH0cZ3K26rBGVM3iV7vXwY9MkMEV+f9lb4J2uvOReVNWXHtNascy0mjIusQKxfM3
ICeP+/olCxwe6SQtpxjd4g6CuQ0Hh7Gr8Gh2EnxpB7DrsjHRcLAWXne9urPQCYOJ
XFspTn5+2qJNm2AoFIds
=S9hs
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
