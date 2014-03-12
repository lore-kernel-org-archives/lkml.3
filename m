Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaCLBtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:49:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53783 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaCLBth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:49:37 -0400
Date: Wed, 12 Mar 2014 01:49:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>, moinejf@free.fr,
        alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Li.Xiubo@freescale.com
Message-ID: <20140312014927.GK28112@sirena.org.uk>
References: <1394542472-16580-1-git-send-email-Guangyu.Chen@freescale.com>
 <8761nkryky.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="duiWCIIjnNnpV3+H"
Content-Disposition: inline
In-Reply-To: <8761nkryky.wl%kuninori.morimoto.gx@gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: simple-card: overwrite DAIFMT_MASTER
 of	cpu_dai->fmt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--duiWCIIjnNnpV3+H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2014 at 06:32:32PM -0700, Kuninori Morimoto wrote:
> > The current simple-card driver separates the daimft for cpu_dai and cod=
ec_dai.
> > So we might get different values for them (0x4003 and 0x1003 for exampl=
e):
> >=20
> > asoc-simple-card sound-cs42888.12: cpu : 2024000.esai / 4003 / 132000000
> > asoc-simple-card sound-cs42888.12: codec : cs42888 / 1003 / 24576000
> > asoc-simple-card sound-cs42888.12: cs42888 <-> 2024000.esai mapping ok

> cpu   =3D 4003 : SND_SOC_DAIFMT_CBS_CFS | SND_SOC_DAIFMT_LEFT_J
> codec =3D 1003 : SND_SOC_DAIFMT_CBM_CFM | SND_SOC_DAIFMT_LEFT_J

> codec is master, cpu is slave...
> what is problem ??
> Am I misunderstanding ?

The C in those constants stands for CODEC and the values should be
identical for both ends of the link.

--duiWCIIjnNnpV3+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH70jAAoJELSic+t+oim956oP/iprbn1oSZIhFchn3pxZALEx
qtS8hfw7mf7zCtPdJNZO5C6SyQyTnchAGzDw8iiQQd7tM7vnbyHR06rMmNYXek2d
IGOKzmMbTj0Nh4C6+bFRzJhamfCQ+aos2Cb6VfV/Lg/d8YuBasio2Mp/HBf2NAUd
2bsUEOvbQAN6Dk5raZIx7AtECVuj23MzPv0Vkl5g/FL7CpuZmHwMX0JduRIF4kxs
RKWoYPObeDR7k1d8Wk+GezPk972u/eNLTxW94Nzn/3xiOiDhYErBWr1GUesVmL60
NwPu9jAmfN4Iq/B8pWQrBkMbU6hvMVn/0wxwkA9GHaVTmG2tugcZBBrXFO709jcE
/HlB0GYZG4Xgc1Vm93Jz5+F9aG3+h2UMo4rgavSWi5wg3w3sk8b7x3fs1W9X24EA
8SQi11/LJhh6ycYMT7EejS2wNd/zToxusEFKEICIQ0xcrH224OAWv3MplLR2g+dC
4ZhYc18T91EFUftpzbXDnpNVCtL05Vz+MsnPggn0IFUkaYpnjIWojSXE/l/QTlpZ
n1++XkqB0SrgMpiRcpN7H6VRP5fPUNrwM3ZN2XevgCJ9QF37790NrB6AjnTUKAiT
UIwoXkBlw2M2dwAvBKBxaH8YR1PlBtwVHjy3KPeyUKieJ+YBKkQ70N3KVm6XWqcd
Z1zcpOzSZB6L76crwefF
=5V1Y
-----END PGP SIGNATURE-----

--duiWCIIjnNnpV3+H--
