Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaJHTzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:55:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60003 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbaJHTzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:55:06 -0400
Date: Wed, 8 Oct 2014 14:54:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <mina86@mina86.com>, <r.baldyga@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size
 flag is set
Message-ID: <20141008195454.GO22688@saruman>
Reply-To: <balbi@ti.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141008003256.GB9957@saruman>
 <20141008175558.GC16791@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4D23EFnZpzTzcHd"
Content-Disposition: inline
In-Reply-To: <20141008175558.GC16791@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--z4D23EFnZpzTzcHd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 08, 2014 at 10:55:58AM -0700, David Cohen wrote:
> On Tue, Oct 07, 2014 at 07:32:56PM -0500, Felipe Balbi wrote:
> > Hi again,
> >=20
> > On Tue, Oct 07, 2014 at 05:18:06PM -0700, David Cohen wrote:
> > > The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> > > quirk implemented to align buffer size to maxpacketsize on out endpoi=
nt.
> > > As result, functionfs does not work on Intel platforms using dwc3 dri=
ver
> > > (i.e. Bay Trail and Merrifield). This patch fixes the issue.
> > >=20
> > > This code is based on a previous Qiuxu's patch.
> > >=20
> >=20
> > btw, please resend and add below right here:
> >=20
> > Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
> > Cc: <stable@vger.kernel.org> # v3.16+
>=20
> Sure. But v3.16 doesn't have the new 'function' directory under usb/gadge=
t.
> Not sure if same patch is useful for v3.16+.
> The patch I sent is intended for v3.17.1 and v3.18-rc1.

code is the same anyway right ? It's just a path change :-)

--=20
balbi

--z4D23EFnZpzTzcHd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNZaOAAoJEIaOsuA1yqREfNwQALCMuNJBIiE5tltZxqokokgK
xEzDEA+iY1KG+eKz8RvPx1yqJ4ezFBRSaGhL5KWbAQ7XEVP5a8/FwKkHFaqjBdj2
C6OyZ2qHZewHOYJRkvGZ7Hbgphcb2ZyrDzb4eLgDsMyLDvbZ9HVsWtF9wchUmiz1
Zn2RQ2wbdq+0miR39z85t8iOFPuT2YKzaLHVTX+uTTRKbpWXCqzdCvZILokkm8gS
OLjV+3FS4+kg96Pw5d2R49H9fidYgIvPEaR3s+9GKMWrAcn8wLH5MxJE8YuW3T14
P7d7VS0QHnMUB+M1PE/gnp27ZOjNUEsH6TNl0JddVfa6wg1jsxrl9oGmimripmvv
fQJcCRGOi1kLSCaMU22xy59TDU/jAezUj6WHZdRTyGRMz9HC36TcNeV9Kt3+N8f/
JPTR5jMtFPiF98D0RPN5Ai68pG44xZ31McUZFUDQHFF+FcNQZmbPlAn62m6P+c1e
HpNJSB5NoSeUVhenBLro6hCVl5V5Gdz5LShRkhzTbsIy7iI3dOKEb4+83nEGUGvj
Iy6d3GJPG8z/lz/9eCDyhlZSmyxsef0v9SjAVCaqTFHvExb+cEySe99FNH/TEztV
BNIH5I72rNYOJ18uMMsy96oc7xd+nuGYTRHlrraNrpZvXEA3SUx/pxcQAm0VDNoS
zgcOza7SRS4Vpj0Dk+g8
=8Hc8
-----END PGP SIGNATURE-----

--z4D23EFnZpzTzcHd--
