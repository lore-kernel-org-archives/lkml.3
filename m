Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3LPVbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:31:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34966 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3LPVbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:31:33 -0500
Date: Mon, 16 Dec 2013 15:30:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v6 5/9] usb: gadget: s3c-hsotg: use generic
 phy_init()/phy_exit() support
Message-ID: <20131216213015.GI12896@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386953483-21631-1-git-send-email-mporter@linaro.org>
 <1386953483-21631-6-git-send-email-mporter@linaro.org>
 <20131216212001.GD12896@saruman.home>
 <20131216212644.GA15814@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zqjkMoGlbUJ91oFe"
Content-Disposition: inline
In-Reply-To: <20131216212644.GA15814@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zqjkMoGlbUJ91oFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2013 at 04:26:44PM -0500, Matt Porter wrote:
> On Mon, Dec 16, 2013 at 03:20:01PM -0600, Felipe Balbi wrote:
> > On Fri, Dec 13, 2013 at 11:51:19AM -0500, Matt Porter wrote:
> > > If a generic phy is present, call phy_init()/phy_exit(). This supports
> > > generic phys that must be soft reset before power on.
> > >=20
> > > Signed-off-by: Matt Porter <mporter@linaro.org>
> > > Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > ---
> > >  drivers/usb/gadget/s3c-hsotg.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >=20
> > > diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-=
hsotg.c
> > > index 7c5d8bd..e9683c2 100644
> > > --- a/drivers/usb/gadget/s3c-hsotg.c
> > > +++ b/drivers/usb/gadget/s3c-hsotg.c
> > > @@ -3621,6 +3621,9 @@ static int s3c_hsotg_probe(struct platform_devi=
ce *pdev)
> > >  		goto err_supplies;
> > >  	}
> > > =20
> > > +	if (hsotg->phy)
> > > +		phy_init(hsotg->phy);
> >=20
> > doesn't build. you need to include <linux/phy/phy.h>
>=20
> It depends on https://lkml.org/lkml/2013/12/5/172 which I noted in the
> cover letter. At this point, I don't know if Kamil's whole series will
> make it to 3.14 so that patch may have to be taken separately. He has a
> trivial update to make on the binding example is all for this patch.
>=20
> I was wondering today if we might just want to separate that out now. I
> originally had a similar patch in my series but his was posted first so
> I rebased on that.

I can wait another week tops. By v3.13-rc5 I'm locking my tree down, and
only urgent bugfixes to the next branch will be accepted.

cheers

--=20
balbi

--zqjkMoGlbUJ91oFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr3DnAAoJEIaOsuA1yqRERfgP/AnsfhlwXldiMnTsSFX4l271
zamjyhMk/tpFzZoaLTWIF+vuj7dvjmCScP6sCHJoEkgf5hF0WB7PAUF/t9/F8EX+
0jAq6KHGv5NZ/M3bjpGZLtNAcqKtQBu3Nn1gKtcW+VPj/Bf8koG3/+h5yCgEvKkR
kYID+vOtn3o0aYpQic9oTW5TBUCcoLZ3DWeQ4x/VkN4zAP5jM0oq48cXg9FbpFgo
X5KR0LcRUIACVobIDk336QYraUOg5fzQBgOWbszPV1CvaUEypreGqd2WH3kmHp68
TRHqcm9itczhlBvz+2hVDjVbUNYJT8ThVlqlNqjaDJV7N3ZCXRoVZ/o82D6lAy2I
r0UR7g7s5beQSEzdu1vzmZtehQjOmsGXMzFEyVlD3EM8mY4YgvOsFBI/q0yrWAhj
7R6Tg4bVZPk4rmQ8Qi65gpgR8eXeFZw9mUME2+KQG9rUjR6iZo3yJDK9u9ZBvR9U
afSUyKo2oTTO0RW/94rXD2PpVv+nEWpw+nTNxSgHMB7t1jKU8eWlDgxCN/Bbzh/d
/P1ZbF0YN0r7k5PTlJXy3Sgb06VsFK+ik59lDGQ394dhaheNAkc/3S6bPFKWaAdL
JJYUz1Z+BPeZIjxy+ijQv5m5s2xFtH4xOzTxvOv8cfAXF0XXOVpwT96v2wZmn8Xx
deKzaaCB+fw+pCk7xHr6
=K8VL
-----END PGP SIGNATURE-----

--zqjkMoGlbUJ91oFe--
