Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbaEMIrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:47:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48524 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaEMIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:46:42 -0400
Date: Tue, 13 May 2014 10:44:41 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: "gioh.kim" <gioh.kim@lge.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gunho.lee@lge.com
Subject: Re: [PATCH] Documentation/dma-buf-sharing.txt: update API
 descriptions
Message-ID: <20140513084440.GL6754@ulmo>
References: <1399895292-29520-1-git-send-email-gioh.kim@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMP3JyRexyk9c0Bv"
Content-Disposition: inline
In-Reply-To: <1399895292-29520-1-git-send-email-gioh.kim@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eMP3JyRexyk9c0Bv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 08:48:12PM +0900, gioh.kim wrote:
> From: "gioh.kim" <gioh.kim@lge.com>

It might be good to fix your setup to make this be the same as the name
and email used in the Signed-off-by line below.

> update some descriptions for API arguments and descriptions.

Nit: "Update" since it's the beginning of a sentence.

> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>  Documentation/dma-buf-sharing.txt |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sh=
aring.txt
> index 505e711..1ea89b8 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -56,7 +56,7 @@ The dma_buf buffer sharing API usage contains the follo=
wing steps:
>  				     size_t size, int flags,
>  				     const char *exp_name)
> =20
> -   If this succeeds, dma_buf_export allocates a dma_buf structure, and r=
eturns a
> +   If this succeeds, dma_buf_export_named allocates a dma_buf structure,=
 and returns a

Perhaps reformat this so that the lines don't exceed 80 characters?

>     pointer to the same. It also associates an anonymous file with this b=
uffer,
>     so it can be exported. On failure to allocate the dma_buf object, it =
returns
>     NULL.
> @@ -66,7 +66,7 @@ The dma_buf buffer sharing API usage contains the follo=
wing steps:
> =20
>     Exporting modules which do not wish to provide any specific name may =
use the
>     helper define 'dma_buf_export()', with the same arguments as above, b=
ut
> -   without the last argument; a __FILE__ pre-processor directive will be
> +   without the last argument; a KBUILD_MODNAME pre-processor directive w=
ill be
>     inserted in place of 'exp_name' instead.

This was already fixed in commit 2e33def0339c (dma-buf: update exp_name
when using dma_buf_export()). Perhaps you should rebase this patch on
top of the latest linux-next.

Otherwise looks good.

Thierry

--eMP3JyRexyk9c0Bv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcdt4AAoJEN0jrNd/PrOheuQP/1T1l2P5Zon6msGgbMaFg2cx
DF3TusNO2J9ykROz3lCtBr9QvkW/2xbpaj+g5mBwFT6mqhhLdV1nN2K9rEZ3jTi8
VzYtynmN0ZBT/cj4w9NSuagVPhRLSFLVEk3EbfhHg0u2r5zczxldlMq2Tkcw83dx
4rblbdB1OOOdm3Q0Pb1d4p5Y3Co+BIkminYtQiDbJ3xtgPTCVY2a+glHvL33cf4e
jCJLZxaUhjtGKD8ICZS1puuDRbiVhNKtDNE27NO6jbebaGWN0PIyIreCZegHQuZz
QbIam1arxga7J2pFaxdoAAVkZvV5giZEFEVsK+A84mqLk3P5Sa7WDlWWHP9GqhF4
voJTCE6ldmAs1NJXY9jT6pGIK7AeX96/HgwbzaMCW2ReS5/x3nSaq2peD0Ax6JMR
k1d347N8RAciNRJVR2qKNDPgVz7qAfUOkx7aTv80CHeAxG+USxh7b+pM9z0VOhET
SLjSyseprx900xK39B+DKIVegV9LdFeo1yjV/6XRAsSBrtYIVkBEVOFwSZpe4dXY
zBDI67jvb/RiEF8qvnTBm7m1ljJSAQpPaZ9pLIoSA0xwF7UCQJconvgkrbr4WAbx
Ls9vm8frOQmT/MQu1vCZk2NzpJsi/9Rlvhy1Re+LbvM+b1BfnrVulX2dk4IvkWLQ
R4zCjTKU65h83LQW02+p
=w6au
-----END PGP SIGNATURE-----

--eMP3JyRexyk9c0Bv--
