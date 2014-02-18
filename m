Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaBRQUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:20:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36252 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbaBRQUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:20:54 -0500
Date: Tue, 18 Feb 2014 10:19:06 -0600
From: Felipe Balbi <balbi@ti.com>
To: Bo Shen <voice.shen@atmel.com>
CC: Felipe Balbi <balbi@ti.com>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: at91: using USBA_NR_DMAS for DMA channels
Message-ID: <20140218161839.GD9878@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
 <1389927565-22477-2-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Content-Disposition: inline
In-Reply-To: <1389927565-22477-2-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2014 at 10:59:25AM +0800, Bo Shen wrote:
> When the SoC is earlier than sama5d3 SoC, which have the same number
> endpoints and DMAs. However for sama5d3 SoC, it has different number
> for endpoints and DMAs. So, define USBA_NR_DMAs for DMA channels
>=20
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>=20
>  drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>  drivers/usb/gadget/atmel_usba_udc.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atm=
el_usba_udc.c
> index 7e67a81..5cded1c 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1661,7 +1661,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devi=
d)
>  	if (dma_status) {
>  		int i;
> =20
> -		for (i =3D 1; i < USBA_NR_ENDPOINTS; i++)
> +		for (i =3D 1; i < USBA_NR_DMAS; i++)
>  			if (dma_status & (1 << i))
>  				usba_dma_irq(udc, &udc->usba_ep[i]);
>  	}
> diff --git a/drivers/usb/gadget/atmel_usba_udc.h b/drivers/usb/gadget/atm=
el_usba_udc.h
> index 2922db5..a70706e 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.h
> +++ b/drivers/usb/gadget/atmel_usba_udc.h
> @@ -210,7 +210,7 @@
>  #define USBA_FIFO_BASE(x)	((x) << 16)
> =20
>  /* Synth parameters */
> -#define USBA_NR_ENDPOINTS	7
> +#define USBA_NR_DMAS		7

what's the difference ? You just renamed this macro. Also, please
clarify a bit your commit log.

--=20
balbi

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTA4f6AAoJEIaOsuA1yqREuvsQAKUbaHqjqDvwWlceprpGndRJ
5LZ4KfDu9v/5fTina1cKEoyRt1WMFkx3sxWgKTitCBAAyxKuyGLCfHmuFhWFaVsm
wcltIxsi3hqXRuJR9IJvKUpcAGeplhvzxZoNof9ZrnOPtC/BCTbD+SIazssQvuc8
+2V94BckzZCJA2Yat3u10IAzs+wcEA13Y1iHpTovrjFyVAUKTSgX1NxRDWmRCm/g
iIz770B9Hf3TFcE9KHoE1GRnIo4eAY92k1nrUlQgQHRglwW+ItWfSadaqCctrEdi
9pwo0h2P97Xk7HdDbHXF37/ETGna11sX3tOxPLZNmqItv3vPR4nz9L7nzBMdOE6y
t8K6jJtWsGHRt+TpSzrysNV5j/eIlyt7srsp8WOJsEscUu6C0SSVfuJrsF3T9x6N
cshj0XO23HId4wPLDBqL1T/mX+i/h4IE6GWgaMybPiFtqkJoUePZKrADgqd4Z6CD
281E71zDRpyw0AuTABodhK1PgvAFoj2gEe+Gr6FHSbV+JCRKANnlaXirJAklVWvw
rVvjS3fL2hgXQo5OcQyOCJTUAcpCnrD9VIhgSN471H0Qu2HWVKIVJcrKwuXZCq6j
OHNwsN40ZJMQ4nmTx1Zdyu0mEjcr2CYOnL1MKUcPfn77umpOrTqQ/J56Uo9TuXtI
er72NtDnN7XIpiurZTKx
=Sh/P
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
