Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3H0SpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:45:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3H0SpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:45:24 -0400
Date: Tue, 27 Aug 2013 13:44:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tushar Behera <tushar.behera@linaro.org>
CC: <balbi@ti.com>, Julius Werner <jwerner@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Message-ID: <20130827184447.GR3005@radagast>
Reply-To: <balbi@ti.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
 <20130710052534.GB15674@arwen.pp.htv.fi>
 <CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
 <20130712065734.GE31802@arwen.pp.htv.fi>
 <CAHbNUh0Sa-atYMHbhEUX2vnVAcsdBJxw9RRzAp+6vqE8hi=p1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="syxNSs/hKlQka4Wt"
Content-Disposition: inline
In-Reply-To: <CAHbNUh0Sa-atYMHbhEUX2vnVAcsdBJxw9RRzAp+6vqE8hi=p1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--syxNSs/hKlQka4Wt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 02:11:27PM +0530, Tushar Behera wrote:
> On 12 July 2013 12:27, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Wed, Jul 10, 2013 at 10:42:27AM -0700, Julius Werner wrote:
> >> Hi Felipe,
> >>
> >> This is intended to pull down a reset signal line, not to switch power
> >> to the device. I could implement that with the regulator framework
> >> too, but I think that would just be confusing and harder to understand
> >> without providing any benefit. It's really just a plain old GPIO.
> >
> > alright, in that case how about using drivers/reset/ ?
> >
>=20
> IIUC, reset-gpio driver only provides APIs for reset controls (reset,
> assert, deassert). We still need to find out the location from where
> we would be calling the reset function.

that's fair, but at least you reuse a bunch of boilerplate code to claim
the GPIO, set proper direction and value. No need to duplicate that in
your driver.

--=20
balbi

--syxNSs/hKlQka4Wt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHPOfAAoJEIaOsuA1yqREK/AQAJz1pjDg4TF8/kklUNT96FWM
lcTmiNXXyhCVNRJERcKoAqiAC5YgOeSM3BcEE5iMHUTaUQKdT2Xebb0MDXdc6X2/
pFrx7fvtdnwJU4xW4WBGvB6jQ+kNh8dXzO7wHnuSeIa+pEJaQYP+1kg9otTMCBS7
tGtpG9JQPlODyeNRiG3uqRI/6Bt74oAVhDNCT+KDozyP6VYU+/8gLB7Aiq6znTbI
2LILM44aGt+E+pHnTD0KRmytMIOFVk7SZ4D+E1sWf1ztwk58pMRBAcaCG+2GWhxQ
6fQ565O8v5NkeSECV5Qn5aXf+wU9+RLVdc5nJUMZXIilK03yU7MPA2L+Koaku08d
a85GKiE9k0zOdxoLK2sfT4R9SD4VXjAlI9llwJCGhrnKQ+3XvEsx6zz0+aa4ghch
xCpSSFxKlQpLWivI86U2TCcCX5h0oSRr+6xBIzxRsz6GYfKsvBP1QhM+Rat3CVey
sS0RbLBVMOy/wimhDEE0U4P9F6+FIeWLFWHC+DI1WMH3bmkaJghydOVqT7/KzFhU
WKgi4ZEve9vkoG5Iy9/EcZYcoTcRW9GR+rq7lVgEcQ1Tk9u2F8SduO7XJ3nFFSl2
NRnt786nyYGLmxEhPAipYdRgCOKznqa5yxOtsx+EOhzlGc2IkKqH+mCD7zNVaR7g
mqaGRb3RhTWmmhzDurH6
=h3Il
-----END PGP SIGNATURE-----

--syxNSs/hKlQka4Wt--
