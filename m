Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbaGRNpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:45:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51846 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762275AbaGRNpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:45:42 -0400
Date: Fri, 18 Jul 2014 08:44:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 1/9] usb: musb: core: cleanup - remove some useless
 'break's from switch statements
Message-ID: <20140718134447.GA24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Fri, Jul 18, 2014 at 11:31:22AM +0200, Lothar Wa=DFmann wrote:
>=20

no commit log =3D=3D no commit, also the worst thing you can do is have your
bug fixes depend on cleanups. This is *not* a bug fix by any stretch of
the imagination.

> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/musb/musb_core.c |    4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index b841ee0..8623112 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -680,7 +680,6 @@ static irqreturn_t musb_stage0_irq(struct musb *musb,=
 u8 int_usb,
>  		default:
>  			/* "should not happen" */
>  			musb->is_active =3D 0;
> -			break;
>  		}
>  	}
> =20
> @@ -737,7 +736,6 @@ b_host:
>  				if (hcd)
>  					hcd->self.is_b_host =3D 0;
>  			}
> -			break;
>  		}
> =20
>  		musb_host_poke_root_hub(musb);
> @@ -787,7 +785,6 @@ b_host:
>  		default:
>  			WARNING("unhandled DISCONNECT transition (%s)\n",
>  				usb_otg_state_string(musb->xceiv->state));
> -			break;
>  		}
>  	}
> =20
> @@ -2015,7 +2012,6 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
>  		break;
>  	default:
>  		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
> -		break;
>  	}
> =20
>  	if (status < 0)
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySTPAAoJEIaOsuA1yqREK7gP/j8dscnOETUSakP69c17W1gV
f5dLO7KVFmcEu8ZtgYLnD2DR0t29KBBsYBwiRsS8GqD1DQarrVQduQiwR3l2V9B9
JTg2zBAOclFWIucz2YZJBskpYefAsrVrOb9B54P10dunO8Hr49DtOi3pDRO6dC3A
C66uevOGDGqDTwypPKXBuVuldLAaEf0lw81ndeWtHJZIIOk/UepLyXp+1LTu3W+2
Y9cyitVCxPOpp3kJy7WTUYNb4E6SL/gP2GRkTtsSP+29+FmztVRiqH6xrmtCE4HD
//tsS4BAYmYfzm2aJDp+SxUTPWUh6Z6HmUpY4iVZar/EQWTya6S79rgCzZsZfpNA
wC2+7Q9FfJxm4kI1ZHSBKfTA+89l/+eO48DEDbIr2b5H02D1aF6ePQAHryOgeDok
/gpEJ9F0r2lA/ZPa8W823RWa4a9urB3NqANEszLItZ7D66QMK1nxnNG25P1KRv9E
hHZbiOgJpTuobYQCUwy002mnWoucNzf+5io+MHo3lxVxCDH9uvMdtTtSkzonRdGB
+WVQGp7svjqcDHdLcWcXLmol1GaxmKB4tzddtfMdDuhbkvFX5VO5AIktQmOMeKg0
QK+6sPks+wOvI5D+8yrzqd0IPpZRIKc6830erioits/3qKuqSGyuHFsZSIN2Mim7
YwwVvTxvg45Rg3ujqbB9
=Rthj
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
