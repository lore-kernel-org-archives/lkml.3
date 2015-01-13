Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbbAMMvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:51:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54938 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbAMMvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:51:53 -0500
Message-ID: <54B514D8.9020507@ti.com>
Date: Tue, 13 Jan 2015 14:51:36 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 3/5] video: atafb: Remove obsolete IRQ_TYPE_PRIO
References: <1421052021-12560-1-git-send-email-geert@linux-m68k.org> <1421052021-12560-4-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1421052021-12560-4-git-send-email-geert@linux-m68k.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="IeH71uidaU8LdDdSd7R3B3XBCvMlaoBnI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IeH71uidaU8LdDdSd7R3B3XBCvMlaoBnI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/01/15 10:40, Geert Uytterhoeven wrote:
> IRQ_TYPE_PRIO is no longer used by the Atari platform interrupt code
> since commit 734085651c9b80aa ("[PATCH] m68k: convert atari irq code")
> in v2.6.18-rc1, so drop it.
>=20
> Note that its value has been reused for a different purpose
> (IRQ_TYPE_EDGE_FALLING) since commit 6a6de9ef5850d063 ("[PATCH] genirq:=

> core") in v2.6.18-rc1.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/fbdev/atafb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
> index b2d38097a95718ce..7b231771a4b668b0 100644
> --- a/drivers/video/fbdev/atafb.c
> +++ b/drivers/video/fbdev/atafb.c
> @@ -3121,8 +3121,7 @@ int __init atafb_init(void)
>  			printk("atafb_init: initializing Falcon hw\n");
>  			fbhw =3D &falcon_switch;
>  			atafb_ops.fb_setcolreg =3D &falcon_setcolreg;
> -			error =3D request_irq(IRQ_AUTO_4, falcon_vbl_switcher,
> -					    IRQ_TYPE_PRIO,
> +			error =3D request_irq(IRQ_AUTO_4, falcon_vbl_switcher, 0,
>  					    "framebuffer:modeswitch",
>  					    falcon_vbl_switcher);
>  			if (error)
>=20

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--IeH71uidaU8LdDdSd7R3B3XBCvMlaoBnI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtRTYAAoJEPo9qoy8lh71QGEQAJCHbpZqmfy4dDqM4CpxCQNb
5oXUXmEeQgrJaUmHYNPyjoQpGyccz/p7gQo14b7MPP3obD1yitNedgz/EhoeC6rQ
GGxR00Z/WcJ+hhkKgH9EwaQvhozeUQhqSxT2rZGHJud+fFVop69MgirvKADBqrCk
ub4h9Px7r+rEtUlkFbehpcHtF03IWRjRXk7rH7ulJxBN11b0F9rJnWLi7ZzTmnF7
RhhegHuxTaxKrVtPDYSPVeeFukF4JozGXah4f6j+FaDUlVUtp8grVt6gJRzc8uDj
43YdU14dYAZ+qOtp46x9w97QiA4WohLodQJVVj7QiySnkzdUumYkItjuKMwri96t
j7FKWnag5HkYO+WhqQyzhSMSbLBewz/PHhiNR+ueKfG5RlpEs41199XozyuWJSm8
tiU2Dxr0XLhxMhN7QpLTwCrfYYdQJypGptXjifQc0kUB3PZMYp2N/RXLpBnGeEcy
8zBEvq7kSPB+/t7pps8YsQYK3WLQgijQSFh/TlOIXYwZk51pdlEBvBlmmMW8Og7Z
DqZ9qsxYK2/KOxP9OvMXZSn/6c6bCKwGWEDQ7gnVSQNDj6lxpOnvOn9CRrlz70vO
Etp6rnHD9Aqb0KYUdnidoV/FQ3b7eeTFJAirH7ZtKfyqtO6IVM8kxNHCDNJiOxf6
HiaQ+1csV3vj0cT+qpLQ
=5XS9
-----END PGP SIGNATURE-----

--IeH71uidaU8LdDdSd7R3B3XBCvMlaoBnI--
