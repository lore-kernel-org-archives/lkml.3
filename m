Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab3E1Rkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:40:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44097 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871Ab3E1Rke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:40:34 -0400
Date: Tue, 28 May 2013 20:39:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ravi Babu <ravibabu@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH v1 0/9] adding dual instance and usb-phy support for
 am335x platform
Message-ID: <20130528173947.GF15794@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="27ZtN5FSuKKSZcBU"
Content-Disposition: inline
In-Reply-To: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--27ZtN5FSuKKSZcBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 23, 2013 at 11:31:19AM +0530, Ravi Babu wrote:
> This patch set series
>         - adds dual musb instances support for am335x platform
>         - adds phy-dsps-usb driver based on TI's gs70 driver
>         - adds DT bindings for am33xx usb-phy
> 	- removed references to usb-nop-xceiv from musb

as Sergei pointed out, this would break some DaVinci/DA8xx platforms, so
I'm dropping from it from my queue.

--=20
balbi

--27ZtN5FSuKKSZcBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpOvjAAoJEIaOsuA1yqREBpYP/1iHlJjVJgARHN6D7pYjviwV
kbdpHdINGTyx/uSzrnwn5+Y/GRF1JURJwJ+XS93jS/bGpPqnxgiGq32KKOv40o8X
Yk7IhLIIgWGWkam61o9UuPn6S2x35+pQghjDnaJIA16QpakHOpZmzE3uMw9FBsHn
pVjV0O2E+afLDa5H6L0xZ2kc5KaKtkT1WjvlybhQdNDZSIPBWou58gxuGp/XwhPr
gns1PzIrn3dywclJRdawjTrTc05Z6/H233vWWLlJF3RwBFpd/qSXmHwSFCDy687u
KLg+JhB2tuhY+A5HOqPsnWk9hGpuk8q5Kpemw4yFLtSQsm8GIAc2wLBGKvxppLEm
o6FLVD592FFPtuCF5W4MUS4geJGJR0bSHSvbEKyFblMBv72koSIsfe+zBYQXx/xm
cXye/xeXKZU8Nao45wC88KA8qpHFiV+TOLTE6rtAE+ZnTUrJv5CSnVWseOZ9IF/g
yLE3ZHgGYce5UHdtKK82e63fFKEpECUT/N/HyLGKFjH5GWMe84SoZtNI1KuRWvP3
y2hrTJj886k49JNQt1mCwiFVbBlSsthEjhJuKNvhzyU55Zdovf7ENx9UjIkTvKzq
4dABikZ3xxKVzSOwtAPQejAXjQJPhoEniQM20Ykwx+zP7pUg1yDwErynVVVWvxZl
FmLq6tZ3mC2KwnD3uOMn
=aKdA
-----END PGP SIGNATURE-----

--27ZtN5FSuKKSZcBU--
