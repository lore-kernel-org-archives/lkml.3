Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBSBYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:24:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57546 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaBSBYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:24:38 -0500
Date: Tue, 18 Feb 2014 19:22:52 -0600
From: Felipe Balbi <balbi@ti.com>
To: Bo Shen <voice.shen@atmel.com>
CC: <balbi@ti.com>, <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: at91: using USBA_NR_DMAS for DMA channels
Message-ID: <20140219012252.GA30027@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
 <1389927565-22477-2-git-send-email-voice.shen@atmel.com>
 <20140218161839.GD9878@saruman.home>
 <53040592.2000707@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <53040592.2000707@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 09:14:58AM +0800, Bo Shen wrote:
> Hi Felipe Balbi,
>=20
> On 02/19/2014 12:19 AM, Felipe Balbi wrote:
> >On Fri, Jan 17, 2014 at 10:59:25AM +0800, Bo Shen wrote:
> >>When the SoC is earlier than sama5d3 SoC, which have the same number
> >>endpoints and DMAs. However for sama5d3 SoC, it has different number
> >>for endpoints and DMAs. So, define USBA_NR_DMAs for DMA channels
> >>
> >>Signed-off-by: Bo Shen <voice.shen@atmel.com>
> >>---
> >>
> >>  drivers/usb/gadget/atmel_usba_udc.c | 2 +-
> >>  drivers/usb/gadget/atmel_usba_udc.h | 2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/a=
tmel_usba_udc.c
> >>index 7e67a81..5cded1c 100644
> >>--- a/drivers/usb/gadget/atmel_usba_udc.c
> >>+++ b/drivers/usb/gadget/atmel_usba_udc.c
> >>@@ -1661,7 +1661,7 @@ static irqreturn_t usba_udc_irq(int irq, void *de=
vid)
> >>  	if (dma_status) {
> >>  		int i;
> >>
> >>-		for (i =3D 1; i < USBA_NR_ENDPOINTS; i++)
> >>+		for (i =3D 1; i < USBA_NR_DMAS; i++)
> >>  			if (dma_status & (1 << i))
> >>  				usba_dma_irq(udc, &udc->usba_ep[i]);
> >>  	}
> >>diff --git a/drivers/usb/gadget/atmel_usba_udc.h b/drivers/usb/gadget/a=
tmel_usba_udc.h
> >>index 2922db5..a70706e 100644
> >>--- a/drivers/usb/gadget/atmel_usba_udc.h
> >>+++ b/drivers/usb/gadget/atmel_usba_udc.h
> >>@@ -210,7 +210,7 @@
> >>  #define USBA_FIFO_BASE(x)	((x) << 16)
> >>
> >>  /* Synth parameters */
> >>-#define USBA_NR_ENDPOINTS	7
> >>+#define USBA_NR_DMAS		7
> >
> >what's the difference ? You just renamed this macro. Also, please
> >clarify a bit your commit log.
>=20
> As commit message said, the SoC before sama5d3, the endpoint number
> is the same as DMA channel number, so use endpoints definition for
> DMA channel number, however after sama5d3, the endpoints is not the
> same as DMA channel, so use DMA micro for DMA channels.

which means you're just renaming the macro for the sake of clarity.
That's fine, just needs to be clearer in commit message.

--=20
balbi

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTBAdsAAoJEIaOsuA1yqREXAoP/3dzI2aJG2hHyUatvX1hjBqd
TTkKxW0dJdXyr/RAN2fIZICG+89X7K6NE/SR8QZzbjOhWUM3Eh76EVBpR5U5jZ7x
fR/LGp6mRJawYwuZu0HaGgD3rLvmfMLpikbtCV/Xl2ltznYt69kAv0aHpuVpNpTT
yvEea1JWd5y/tckvvb0gSl+fkVMSskdFs272Cb3K3HoXJcT2KZrRbkl9n7kYFyKd
jYKTyx0/NEr8jBI6OZo3x4eP2pWMCbloAftk0HFkXJ1jMtlFXUmAkXKC7jdM6gRB
0TXq4Jkm/HRQ3+ggszWZNSmcvT0k+YyTv40MthuhogfzjKGSKUgBLkk+l2JDtUK7
KnwrRXmac+8V2ecLYkU9cojD/1pzL5yj0uk2FmSstgf4aWF7JqHCgtBz+rCI2y/3
BwqZpEjDNtpAqjt/ZQgav1RVXYTCY8uHF+9AAc/JDcnQwakRLiZWOfhaoKmbs15q
geeIo84oUSdouQ0sQzlCIFmB8uxQsFP7CEUkonVIWGnVRCZYdhjc+4FAJ1wmk9uk
aqZtTSda4tZtjfdralqw7kxCvZFAloUSjFgYcuzFqKERXSa15iTOlDOSpF8vdUbh
EO1ZUTQQCkqApAG1Ind+iozI37WfRFo3ntXAfRKGLCbbL3TRKV4HPlohgamcDJFs
AIJr3r9V8+t1I7Y3tCMG
=IPC1
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
