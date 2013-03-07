Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3CGKpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:45:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46714 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab3CGKpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:45:02 -0500
Date: Thu, 7 Mar 2013 12:44:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Message-ID: <20130307104457.GA15079@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130306085446.GI28587@arwen.pp.htv.fi>
 <1362646660-22688-1-git-send-email-fabio.baltieri@linaro.org>
 <20130307091057.GB7422@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20130307091057.GB7422@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2013 at 05:10:57PM +0800, Fabio Baltieri wrote:
> On Thu, Mar 07, 2013 at 04:57:40PM +0800, Fabio Baltieri wrote:
> > Add transceiver notifier event handling to the ux500 driver to set vbus
> > on specific transceiver events.
> >=20
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
>=20
> Sorry, I forgot about:
>=20
> v2:
> - turn off vbus on USB_EVENT_VBUS event
>=20
> Note that this causes a trivial context conflict with patch 5, let me
> know if you want me to resend the whole set.

please do, I rather you resend otherwise I could mis-solve the conflict
:-p

--=20
balbi

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJROG+pAAoJEIaOsuA1yqRE57EP/2vQgVeRu7+iV8rbYEtklXTC
k9En3s7pNgJcRpa+QFtN11sB/irFhoA6FqkK6LqZniuMPyfg4eXGSaxKhVOYAays
pqxyvxyfSoa4BLcQ83zgJOkQG2KVOEOfTomVsW2vRcq5UMdW8drmFfMM0Pia088a
OvnNZmrfcwqhViBEIrrSfUlX0cQ7DWOK5NHzBuDUrFjQVGsgKKXHtpPScTVQU0zR
XRkvp+SeQoe/epUZiQ1wzuOvwpK5EZnCtvhd6BzAQSHakg7lzQFxJj4uExTE6qmW
cA43AupYPRrYxiDdJacDCWFCv+MCf2fwchd/nFtb4Mhq1Ge2u+Sm4WZWujvVfRjh
PbYKpDUyd0oPkDZv/MuuXcIXf3iwIeAt/51xfxcWo6yTlhy3YuOfDEzbGGBUStsp
3RHwVSBBs7GY21DlgPUYkrFzGrdWoy7CwWi+mhOoUKska6HZb/4Bgx3UQNCGymir
EQrfIokHBKXCKxqCPTOmbIeCqwvGtg8bfrGY7R+887GxNXR8YyiPNkrtEFJk1LoQ
s1X0n19Q0i8bBsvEFZVgngab1wid1jpjNW0JNfPRG81irbhPGMkCmJru6V1Vq6be
5niq6RCfzbLm8X5panilwaJ4OsyWH2qKxGfX0QGfOSXxOU8AMibYUuNtoEjnFAjh
hbxPS4LbjdqXwTS6DZma
=1rMu
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
