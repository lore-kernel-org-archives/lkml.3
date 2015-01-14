Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbbANBSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:18:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54209 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbANBSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:18:34 -0500
Date: Tue, 13 Jan 2015 19:17:42 -0600
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 2/2] irqchip: omap-intc: Remove unused legacy interface
 for omap2
Message-ID: <20150114011742.GC18523@saruman>
Reply-To: <balbi@ti.com>
References: <1421187806-6804-1-git-send-email-tony@atomide.com>
 <1421187806-6804-3-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1421187806-6804-3-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 02:23:26PM -0800, Tony Lindgren wrote:
> Nowadays omap2 is booting in device tree only mode so there is no
> need to keep the legacy interface around for omap2_init_irq().
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Awesome, only one to go now.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/irqchip/irq-omap-intc.c       | 8 --------
>  include/linux/irqchip/irq-omap-intc.h | 1 -
>  2 files changed, 9 deletions(-)
>=20
> diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-i=
ntc.c
> index b75a44a..ece8624 100644
> --- a/drivers/irqchip/irq-omap-intc.c
> +++ b/drivers/irqchip/irq-omap-intc.c
> @@ -348,14 +348,6 @@ out:
>  		omap_ack_irq(NULL);
>  }
> =20
> -void __init omap2_init_irq(void)
> -{
> -	omap_nr_irqs =3D 96;
> -	omap_nr_pending =3D 3;
> -	omap_init_irq(OMAP24XX_IC_BASE, NULL);
> -	set_handle_irq(omap_intc_handle_irq);
> -}
> -
>  void __init omap3_init_irq(void)
>  {
>  	omap_nr_irqs =3D 96;
> diff --git a/include/linux/irqchip/irq-omap-intc.h b/include/linux/irqchi=
p/irq-omap-intc.h
> index bda426a..2e3d1af 100644
> --- a/include/linux/irqchip/irq-omap-intc.h
> +++ b/include/linux/irqchip/irq-omap-intc.h
> @@ -18,7 +18,6 @@
>  #ifndef __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H
>  #define __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H
> =20
> -void omap2_init_irq(void);
>  void omap3_init_irq(void);
> =20
>  int omap_irq_pending(void);
> --=20
> 2.1.4
>=20

--=20
balbi

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtcO2AAoJEIaOsuA1yqRErUwQAJ45NWSnbHCTmwc2qbLkjIX8
2oaRHkOXl8mrG9g9EEqNPS+rXqNBAm4AXqaP0sqbNGBkDdrJRAaRkRITuJ6xjCBy
GP3LK+6PdHXnsZfAhQP3U+CKtjVG6PUW3ZRnzrqO1c0hZ0FHQVzoTI9LWPo8x7nF
HCxrc/Gv0ysYkI0kyliHg/dH2bqBACCqmx5sGwj5cd3T3sNil4/06f6a9TBxyNjp
k1o1V1v1f6lDDHUAus9D5Hwafj7mSdk2JlL+AdlmzUPHb+x9EwqOUBSXIqUlUum8
VEnaoKbPagczny1LTzBOs1wob7KeMTjc0GIvm1dPuVrkCUI7MVQCSadNjfQNZ0nZ
tH0QsjKq36A9eu3JYZeWRDGqwfDP1Kic0+xG/R+HoAE0C1WReIlIMwNoh+2pyLvn
YeI/inpnpsGY0raCegtZoEgKUSHf1RLMxHIEeBM6pN6G0P/HRfMHgUsHnUNYgKV+
U/yiUHGyCnPEWfNM2X7GWaLlq9qUGIRbEag8tVdNqkMbt2Y4WNlr2bKSskLtn6Kh
sB/dojPADaSJBb+9pnUUsfIpB2FLr6NFByy/ccdtoy0JhUT+tiicBq7FPcyfuZ6s
UpOb1184vQgtSe8UH6JbP6SKc/RA4jIexIedKhvYxPDk5IY4couwDvxl+oY28nFq
5aA/ky5KtG15qFUoNXpS
=kCjz
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
