Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaJMLyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:54:15 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43976 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaJMLyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:54:13 -0400
Date: Mon, 13 Oct 2014 13:54:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Add vendor prefix for Sharp Microelectronics
Message-ID: <20141013115409.GB16186@ulmo>
References: <1406901044-32654-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <1406901044-32654-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 03:50:44PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Use "sharp" as the vendor prefix for Sharp Microelectronics in device
> tree compatible strings.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)

Ping?

>=20
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Docu=
mentation/devicetree/bindings/vendor-prefixes.txt
> index 81cc5bb8c821..b833b10da988 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -121,6 +121,7 @@ samsung	Samsung Semiconductor
>  sbs	Smart Battery System
>  schindler	Schindler
>  seagate	Seagate Technology PLC
> +sharp	Sharp Microelectronics
>  sil	Silicon Image
>  silabs	Silicon Laboratories
>  simtek
> --=20
> 2.0.3
>=20

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUO71hAAoJEN0jrNd/PrOh37kQAIUCZRo8EtG2yVeylPlEoeCJ
BWoftxkDSH3O5KPIOB6jcE9KSAueOR7VbkATWp2HolfKEkT+NS5Ef9Vae5aX43Nc
Q+3xAbAvtVUoVRssh0CFRx/pQn+pg/6upMZU9d0dunDUkoRblqf+czlSiSG8VCU0
g3JcaVIcVFzjkuSxtpIJR0q4+RAcs5WfEGbqSWBZhtzliDocaBL7X4Zp+lm7DYMN
p0Yh2fTlYBLe54RYhyYNQMu5qhIGrXXcg9ATQiWrID5tSwOdfR+2Ug6fnarVyK05
SJPWMfEmv00eMfS7wwidcbPdBsyXEFjw4FcujFxbxBAWe93RgTNUWPW2aoGp5g6B
7s0qUKdGXR6Do5j8qIReQwCDwdoKe4NzTNXaqHwXeLSiJn1vd+zbn7kgZjE0btQV
HQTV9Fjy23ImVWipCzz3cR3MHfnZdqgDC8Sh8l/iiwDU3yqwKP84+hBjbtSqXydW
Se7QmygpO6610NersmAzunLFRJHqCnENtzyaprdfsRxQJoTm3HjL4gubSY9te/63
cgjku10ow/qIvqPAb+WDEX7WGt1ghrWro5pTWUfpKKe2iIluzpGint1xCNVTY1tI
iRFwhKUfk3gvF7DfKc5zJpAVWGbFIIFEiKSMqJsJirKx7ZqaqQSAMgizPm/x5oh3
IZhA1lYLd5H03PA+M8sH
=UIHB
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
