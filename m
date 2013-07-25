Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab3GYQLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:11:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58443 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab3GYQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:11:33 -0400
Date: Thu, 25 Jul 2013 19:11:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Bin Liu <binmlist@gmail.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <george.cherian@ti.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to
 am33xx_driver_data
Message-ID: <20130725161120.GC31835@radagast>
Reply-To: <balbi@ti.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
 <CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
 <20130725144118.GA5412@linutronix.de>
 <CADYTM3bJZKUjgddP1pddZvqg7CfVyayxEXfBoJFrhean79+ykA@mail.gmail.com>
 <51F14165.3060803@linutronix.de>
 <CADYTM3Z1aoTx_99xCj9XOQCUj63GeCcekL6ECajWQWKoQD4n0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
Content-Disposition: inline
In-Reply-To: <CADYTM3Z1aoTx_99xCj9XOQCUj63GeCcekL6ECajWQWKoQD4n0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 25, 2013 at 10:28:37AM -0500, Bin Liu wrote:
> Sebastian,
>=20
> On Thu, Jul 25, 2013 at 10:16 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> > On 07/25/2013 05:12 PM, Bin Liu wrote:
> >> Sebastian,
> >
> > Hi Bin,
> >
> >>> Is it really there or was it never there and it has been added to TRM=
 by
> >>> accident?
> >> The EOI register IS in the USB subsystem of AM33xx, but the SoC does
> >> not use it because it uses level triggering for USB interrupt.
> >
> > I see.
> >
> >>>> But I am not sure if it is a good idea to remove eoi from the musb_d=
sps
> >>>> driver. If the intension is to merge the support for other SoC, such=
 as
> >>>> AM35xx, AM18xx, then EOI handling might be still needed. I just don'=
t know
> >>>> how those devices use EOI.
> >>>
> >>> If one of the architectures gets added which need an EOI then the off=
set
> >>> can be 0 and the EOI will happen only if it is !=3D 0.
> >> This patch cleaned up the use of EOI. Do you mean EOI handling will be
> >> added back with condition EOI offset !=3D 0, when the support of new
> >> device which uses EIO is added?
> >
> > That is my intention.
> Then should something like EOI cleanup be added into the commit
> message for better git log searching experience? I would think the EOI
> cleanup is more important then variable renaming in this patch. Or
> even better to separate the changes into two patches.

perhaps two separate patches would be best, indeed. At least it would
make it simpler to track regressions.

--=20
balbi

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8U4oAAoJEIaOsuA1yqREJlQP/jbWOi+hdwhxPMyLB0Da+y0W
7ZpniVhWdUfw0rtNs9EbT+cJNYEKm+VsTdQBSL6R7KlkoJFJlO76DRTa/+r/v25m
tIof8qmia0kjxRdHNfcctBR6GBNg5ftvzZjnm7d+pZQnIyv9L9485jenekDmmSYe
kkYvPtlBqNg3civyRn/iXFDj66htGncBEKik812Z7YlnOTE4/neMs1GD+UsFwhdR
zr3PI1zG8lajtfoVZZ0aFgUoeEWu2Kwn2X6UOtu7/5FwYC3nN1NwfS60xE3ImPFu
xqN/3ggRc+Jvl/8c4ZvCR+yg3i93gHQ0Tk3w995Bi+pHIiWpoUnGCeCeI1R8dDqJ
zfp1hOuUq8JHfMR7JlmgPR5KOPzD8fO7s5QQZUWRoMls6+Mqp2Gm0qfX2Q/2YAMP
lWy64nblMcg71H4MYKt/Tm7szVt4v3ZOmJvlL1dkMmWbRMjnbe/n51Jp3GkJ9NWJ
ZETXJNZdl651PUGjAmrGQGLZCH5ZAaPRPeNnS19IfyEY5PrATPsms7Ocg/gEJ6xf
c0B8rZbTQq43DritDhANtpPup3VawFRaYNClkWg2d94w5+NoAO9cJ2boWS6cZE5Z
Pk3H8iiaGoAujzivv+x/q1ODeXcILHsiHHnVJwWhqJMdZ48+iGsFg0O6DqQ1zPxX
pZlt329ZS1x7LB9sWomu
=0Ejw
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
