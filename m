Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3GZIgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:36:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42369 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab3GZIgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:36:51 -0400
Message-ID: <51F2351D.6010904@ti.com>
Date: Fri, 26 Jul 2013 11:36:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexandru Juncu <alexj@rosedu.org>
CC: <plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] matroxfb: replace kmalloc and memset with kzalloc.
References: <1373637618-10529-1-git-send-email-alexj@rosedu.org>
In-Reply-To: <1373637618-10529-1-git-send-email-alexj@rosedu.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HgqseJ9L2PmQHW44vRjP21C8500UFs2t4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HgqseJ9L2PmQHW44vRjP21C8500UFs2t4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/07/13 17:00, Alexandru Juncu wrote:
> Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
> ---
>  drivers/video/matrox/matroxfb_base.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matro=
x/matroxfb_base.c
> index 401a56e..2456529 100644
> --- a/drivers/video/matrox/matroxfb_base.c
> +++ b/drivers/video/matrox/matroxfb_base.c
> @@ -2029,10 +2029,9 @@ static int matroxfb_probe(struct pci_dev* pdev, =
const struct pci_device_id* dumm
>  		return -1;
>  	}
> =20
> -	minfo =3D kmalloc(sizeof(*minfo), GFP_KERNEL);
> +	minfo =3D kzalloc(sizeof(*minfo), GFP_KERNEL);
>  	if (!minfo)
>  		return -1;
> -	memset(minfo, 0, sizeof(*minfo));
> =20
>  	minfo->pcidev =3D pdev;
>  	minfo->dead =3D 0;
>=20

Thanks, I've applied this into my 3.12/fbdev branch.

 Tomi



--HgqseJ9L2PmQHW44vRjP21C8500UFs2t4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8jUdAAoJEPo9qoy8lh71KFQP/0E8DajpqCtuncZ5eQlkcxc9
4SebRU9XpEVdPXhRIUm/CC25ZwrVk4b9nGIda2UW0AaNi7qxqMMcdUbtJIqjEErH
2gp8i3UWdadtwdqN37Ckq4GBdWlBchYSLFt1UhP/JPCuViMqcNhV0SWoI6eIb26o
R6h3yAoV5jBMPRoKpYZoEwh1SiTA6auCxKCL/PROBcc8ymZiiXwAX6pMkWayTOcE
OqhLaaZPPshRaen+SlMA6Rn5AA0neJ+f7eBXNQUP7zsUgW9NeTneF0na47xhaUkO
eJvSRhFnA0QUalxTkJRoU/yBrmYqxjSg1PVCxymMkozIJHsyazm3KCmeIbhxILpz
IEb6SpWW41I0+p7hZqg5L2ctpunIqGUtJYrJQeR35RPIvnL/V94V4W8jzVh/wNXm
moKmk+6Z3JfX8JvHV1rrGFLTbl6H8QrQgnPg/TPW+/zvPkf2vs8U5zlDRuEdqJfh
BfytLiApdIRiNV2XgYl9iF5pRZFpe5KqvZwDw3JT405N8FK9zkKiUf1kOiMCNXzN
H0NN8DyTJimgoxQbSs+JEGVPK54co50bT2OUspxLuRbgzIWjbSy/D0azEthjOLeu
9IpRSaPYNVfQmhtfly8rVM1YShYk/cYGGe4Al6bH94H9CDCtfN8FPdUh2aGgE+kn
mltYinCSTUAKF9rRpN2u
=gS5X
-----END PGP SIGNATURE-----

--HgqseJ9L2PmQHW44vRjP21C8500UFs2t4--
