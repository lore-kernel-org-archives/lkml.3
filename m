Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3H0IFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:05:25 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48211 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3H0IFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:05:22 -0400
Date: Tue, 27 Aug 2013 10:04:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: tbergstrom@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] host1x: hdmi: Make sure clock is enabled before dumping
 registers
Message-ID: <20130827080447.GH8686@ulmo>
References: <1375173303-4275-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNfT9TXqV7nd4cfk"
Content-Disposition: inline
In-Reply-To: <1375173303-4275-1-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CNfT9TXqV7nd4cfk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 11:35:03AM +0300, Mikko Perttunen wrote:
> The debugfs register dumping function did not enable the HDMI clock.
> This led to a possible system hang when reading the debugfs entry
> while no HDMI cable was connected to the system. This patch makes
> sure that the clock is enabled during the read.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  drivers/gpu/host1x/drm/hdmi.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied, thanks.

Thierry

--CNfT9TXqV7nd4cfk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHF2fAAoJEN0jrNd/PrOhjD0P/25n4NrF/zsYVKXY7oDEeM0k
D24bAqBHLySDysys0DEqhA6XQZV3JoBkGK++QjEAoRAE/A6a5dzTbwQbELhlO8+z
iuLuYx7aBuJh7lT1ghvoctgP2p8lJvD1FhrVS/ucTYJyNhnNebp2gXW45PqUOG61
YleJ1kfYBKI6lEZgZ6JP5AWdVxD8ETrqs9zoSjY+1KK93Q70y87JSzMqR0/ounJO
JXYdXepWa8yIC7ywwaTykcFvpgXPEjocn06i7BJr4MS5axYhJvcfKIWxRVBXwYA5
Z14RmGOuVlmvlkUsc3F+9udjgKzzm6XG38QtXY1QsIcwYWQQqfT7uPpcP1P4mu81
8xtrw58ZPDzJhbk3v8310MYg81q2f7HtZ9jnZPQIn7eTa7646xmhHtdC9ZD+IUjx
QYAY+X9X4FtGDqMRZnonK3FcI+ao0xI9rdwnMbUNDpWf2trOxiDAeDYaLa1EkJ+1
5J/B61FRVi4N3fB/IEntLcMVBSAPiIrXQUDpTANgOLDm1KYr5FDTLM711wmUeHMd
2toNbMdvEuisNkHoDfXyAm5Tsq7Yg9dahPHTluUQAvZqDS44fef/lPn7zFJtqAuG
ikcn8l6OrFwpv/Qm5ptmVNs5ZCpqrn08VYj/J2mlzcIm7PTd1zakJpPcJmOvn9s7
0QvKcvOxlbphSUCGUev2
=8APv
-----END PGP SIGNATURE-----

--CNfT9TXqV7nd4cfk--
