Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaLCOzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:55:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45641 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaLCOzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:55:44 -0500
Date: Wed, 3 Dec 2014 08:55:42 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/5] i2c: omap: add trace
Message-ID: <20141203145542.GC16138@saruman>
Reply-To: <balbi@ti.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
 <1417617242-16869-6-git-send-email-al.kochet@gmail.com>
 <20141203144934.GB16138@saruman>
 <2E40A984-A6AA-4D17-AB1D-725004EF845F@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <2E40A984-A6AA-4D17-AB1D-725004EF845F@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 05:52:18PM +0300, Alexander Kochetkov wrote:
>=20
> 03 =D0=B4=D0=B5=D0=BA. 2014 =D0=B3., =D0=B2 17:49, Felipe Balbi <balbi@ti=
=2Ecom> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> > NAK, if you want to add traces, use, well, tracepoints :-) It makes no
> > sense to hack stuff like this.
>=20
> It's for testing only the problem reported not for upstream :)
> The hack stuff like this is to allow for me to see what happens on the To=
ny's board.
> I don't have omap2430 board.

oh alright, you might want to make it clear by adding "not for merging"
somewhere in the patch. Also, tracepoints would be something that can be
merged upstream *and* can be used for testing when necessary.

--=20
balbi

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfyRtAAoJEIaOsuA1yqREveoP/0aQIBR+NzxG0LD77rA7Hf3W
xTply5jcHH50hc+qvmi0f8g63y1A4pWNlG+qknHn50LxJTDth6nKEPAqnpQkhTDm
PS5wRLNo9rqWnQwksRIQ4pyxO3xkXBAR4UoeoAAYb4oMEz9o1T7hM5Vjw+0Rx4Fa
S4jdWBqTYdL95RdY2866ir0A5CwAtQw50yQiY8EbGLXlEgr9+/bDbtiN0Ftk18Ju
1MoxHjNZL3KB7O8DwHOeZ3O+rTFC0DqKzB/d0ISD+tn3WLKdhBjFzLOLv0CgRV1C
eULECeVL8+pkuUuW/Iv8Y27TShiBjIg6td8mDwcRtFDcmDYVPSPPuLhsBiNuRLFx
ZbR2rAKpyVRmAknepqodQ8aQxhxZep09596EqUB6Xm8hSO2O3hsAWRm2CRF+7CYR
wUCsWR3fPzY6Xf6ZzgIukyGjCsvTRuA20B7ogw9eaZVPalMbS4MxtdYb/0ok7aa1
HuVTCZLupn2wewXZb/YDRfWxdLTY3+eCvkFAxoEP/U/+lxlhmAdyPquM+a7AL1tF
umLg5oVtVzfuPwMARabXqqqjZUNQq4dTLA2r6oUDFgFL0SZSyvxJ9fXVcRjTtLnU
/BDiuWAT13UvxTOGXRxLAD99C2Lf7xvdudY5kLO589BVsFP3H7/9fgJofJBiHwuh
/V9SVGRE0vyZCX31lP97
=16uc
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
