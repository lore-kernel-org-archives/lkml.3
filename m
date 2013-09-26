Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3IZJrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:47:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35434 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab3IZJrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:47:23 -0400
Message-ID: <524402A6.1040709@ti.com>
Date: Thu, 26 Sep 2013 12:47:18 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] framebuffer: arkfb: Fix framebugger typo
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
In-Reply-To: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="vV43fXx6PTKCKokkRKUdtmodHrBJMxDFj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vV43fXx6PTKCKokkRKUdtmodHrBJMxDFj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20/09/13 04:53, Joe Perches wrote:
> s/framebugger/framebuffer/
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/video/arkfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
> index ee0f1a1..b13f3f2 100644
> --- a/drivers/video/arkfb.c
> +++ b/drivers/video/arkfb.c
> @@ -1048,7 +1048,7 @@ static int ark_pci_probe(struct pci_dev *dev, con=
st struct pci_device_id *id)
> =20
>  	rc =3D register_framebuffer(info);
>  	if (rc < 0) {
> -		dev_err(info->device, "cannot register framebugger\n");
> +		dev_err(info->device, "cannot register framebuffer\n");
>  		goto err_reg_fb;
>  	}
> =20
>=20

Thanks, queued for 3.13. Although I have to say I kinda like the sound
of framebugger.

 Tom



--vV43fXx6PTKCKokkRKUdtmodHrBJMxDFj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRAKmAAoJEPo9qoy8lh71BnwQAIg40rlQKmSBnMn2UtL2+YRx
t+tqE3jtfsd9ae1aWeJe18x5TIaoBnrIVbW38zGNrx7eQrBw1R0GxGRpiyR9rDOz
TOgBr6jLpb4Js7wi/eAbbS414KhiEBI96MVR13YFok4CLE3OqZdclb5pbC0xWUBV
kOw78+E++5F+iS+RneWeGPhYjwXjIwKtZMAW9i5hiPf9RUOmC1PuDnARkq9WRLtF
6VTtXB1oxnZbcOQHpTXeIYuM1VjmP57M7vPMCyuEF1AC+I509n85yfBdslT2REkX
tlc0MHj5sO9NrV8dL2veLdfKXLyhZ4AaFYIotdJCUV19grIktHcHq/X0TZEElI8i
2yMKV+lLhVzboNABmWyoktZugP4Em2grncjWZe/UyOAArGA0T/CIReu7C0sG5KNc
gs0zmuZyt52rAvIkdOePl6mpdv1jR9MucCbiSp0jGYlo1Kff9phte6hI02jOKa1g
Om8okBh/X1vJPqCYdiNDRKIw0Amwrov0/BO85aiPV7+bzZ9NtHkJkYbCM1vQ7Scj
pwShdeBZnfd+2so3tErPERXQtsQIYo0w1dLS9ErhV+RfBWwa4Qzb0AmBWjVQUKol
XxtB9CZ+m+tMzhJ2V0UTEamt6jlO2NVEI8arAiD6JEYQmerfg6h0pzOTFoFOeZBm
A20Q+s1LmcK6cGuY+kFP
=QGYk
-----END PGP SIGNATURE-----

--vV43fXx6PTKCKokkRKUdtmodHrBJMxDFj--
