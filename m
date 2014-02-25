Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaBYSKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:10:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59259 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaBYSKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:10:12 -0500
Date: Tue, 25 Feb 2014 12:08:35 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH 1/6] usb: gadget: gr_udc: Make struct platform_device
 variable name clearer
Message-ID: <20140225180835.GE23275@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
 <1389264858-32664-2-git-send-email-andreas@gaisler.com>
 <20140218155253.GC9878@saruman.home>
 <530AF761.2020107@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
In-Reply-To: <530AF761.2020107@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2014 at 08:40:17AM +0100, Andreas Larsson wrote:
> On 2014-02-18 16:52, Felipe Balbi wrote:
> >On Thu, Jan 09, 2014 at 11:54:13AM +0100, Andreas Larsson wrote:
> >>Rename struct platform_device pointers from ofdev to pdev for clarity.
> >>Suggested by Mark Rutland.
> >>
> >>Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> >>---
> >>  drivers/usb/gadget/gr_udc.c |   18 +++++++++---------
> >>  1 file changed, 9 insertions(+), 9 deletions(-)
> >>
> >>diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
> >>index 914cbd8..e66dcf0 100644
> >>--- a/drivers/usb/gadget/gr_udc.c
> >>+++ b/drivers/usb/gadget/gr_udc.c
> >>@@ -2071,9 +2071,9 @@ static int gr_udc_init(struct gr_udc *dev)
> >>  	return 0;
> >>  }
> >>
> >>-static int gr_remove(struct platform_device *ofdev)
> >>+static int gr_remove(struct platform_device *pdev)
> >>  {
> >>-	struct gr_udc *dev =3D dev_get_drvdata(&ofdev->dev);
> >>+	struct gr_udc *dev =3D dev_get_drvdata(&pdev->dev);
> >
> >you can use platform_get_drvdata()
> >
> >>@@ -2083,7 +2083,7 @@ static int gr_remove(struct platform_device *ofde=
v)
> >>  	gr_dfs_delete(dev);
> >>  	if (dev->desc_pool)
> >>  		dma_pool_destroy(dev->desc_pool);
> >>-	dev_set_drvdata(&ofdev->dev, NULL);
> >>+	dev_set_drvdata(&pdev->dev, NULL);
> >
> >and platform_set_drvdata()
> >
>=20
> Yes, but wouldn't that be better handled in a separate patch?

not necessary, you're adding the platform_device argument to this patch
anyway.

--=20
balbi

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDNwjAAoJEIaOsuA1yqREuGAQAKBkyEx6jFVrLcOhRM4hXm8T
b+U5pwsRr9HSqnMUaY8EaYEd9rKgAkKnOo/GL7e67LW0tMSXfM9YB32KRhv/4KXC
ErMym6C6c4qZavFao1vfreRstTglKQ4P3WaQ2Y+exIJAjT36qfajVcQSmyz9dIvo
eAJ4s/DXNuRUt+y4rTUdeXzbP9ewa0CgDEPeGJB2yHIz22jWC0FII7vz8keHwNWK
0sGNuFXjHCh8lDLBslezA/eTWZ9m0nnN0Vtc1SYPjjh0QIgZusExKNcidi1dNDaP
QF3PtWOKznKOf4LRhkeHQgA7YDYoclnROAUF2BOuVYGsFn2dZN9ssOJ1yG5KjK8T
VW1tvc+F3Yutg6ONK1CBmylEZQV8gc9mCehu9jiwwPIMpSCd1CPJMPtBzjcRQLSB
5iSFMgkjTMq9lJuergPLHw3hJm+etnuSNbCI+NpS9F2LMgbZACzqm82WO7AZzyeY
r9CymnB/Yv6IFXmfthboGb/Gw+dF4cmZxhr7vdM8RoBnbIJMzanBI4oOne/XvHgG
Ndyi/lASAjtviheXWENbkj9ESkmRUTT14Z0okEEEudkRftQVw9nwnJOXrN9PF3Sj
gD3OMahMAhCy/JgaGxTBpx2vgoa6G+QIKMbTm5XZx9YzSu1tZDho/Sc7WjaEH0IY
5iyLrtF/RvQKQ3zyR7b5
=B+XK
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
