Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3JYXkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:40:43 -0400
Received: from ring0.de ([91.143.88.219]:53492 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3JYXkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:40:41 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 26 Oct 2013 01:40:31 +0200
From: Sebastian Reichel <sre@debian.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131025234031.GC8657@earth.universe>
Mail-Followup-To: Grant Likely <grant.likely@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Florian Vaussard <florian.vaussard@epfl.ch>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
References: <1382626126-12565-1-git-send-email-sre@debian.org>
 <1382626126-12565-2-git-send-email-sre@debian.org>
 <20131025190904.3EE93C403B8@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <20131025190904.3EE93C403B8@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 08:09:04PM +0100, Grant Likely wrote:
> On Thu, 24 Oct 2013 16:48:44 +0200, Sebastian Reichel <sre@debian.org> wr=
ote:
> > Add device tree support for twl4030 power button driver.
>=20
> The above commit text is insufficient. There are changes in the patch
> that aren't described here and have nothing to do with device tree
> bindings.

I will update the description in PATCHv7.

> [...]
> > +++ b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
>=20
> Can all of the TWL or TWL4030 funciton bindings be collected into a
> single file please? It is a single device after all. All of it should be
> in bindings/mfd/twl-family.txt

I guess this should be done in another patch? There's also a typo in
twl-family.txt's filename. My suggestion is to leave the patchset in
its current state. I will create another patch, which combines all
the twl4030 bindings descriptions into one file.

> [...]
> > +- interrupt: should be one of the following
>=20
> Spelling: s/interrupt/interrupts/

fixed.

> [...]
> >  static struct platform_driver twl4030_pwrbutton_driver =3D {
> > +	.probe		=3D twl4030_pwrbutton_probe,
> >  	.remove		=3D __exit_p(twl4030_pwrbutton_remove),
>=20
> Remove the __exit_p() wrapper. __exit is for module exit functions, not
> remove hooks (I know, that's not actually this patch, but the code is
> definitely wrong here).

On of the following patches converts the driver to devm, which
results in complete removal of the twl4030_pwrbutton_remove
function.

-- Sebastian

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSawFuAAoJENju1/PIO/qalKIQAJqIpjQwKt63Wy+xHOLtYPxq
VM7gRkOb6DYUaF8vLQDYh9PU15Ggqtyf5mcmk0DthtlTWCkkPSfkylz52wadbc3M
hpfD3KiNx777IkMnXR0dMt61cWg0mprO4MzR8K2CHasPGKUrK1dED0G+ndLSocsP
RCVLn60JmF/ig0WU2oPBKfUKi6TyIQkkvq+PX6OQHYLvuGLoyYhW7V9UVGbFQTJR
MNHsxLVhbMznJ8elYUFtWerU3Dp5iqwWXkXpCSAwrsUPa8UBghqJ33wA2baxzR/2
lvQM+PZNEkVZcHjRO503zAJL6MonywZT/3GJFOmgkZa1kgvI7exUaa0TWW5f3WeM
uQlWHWNcS+wZbNLqv0EkAz9pcrOeq7BDpqNU0q7DOpr//EMJdxWgID+bnLpKv1mq
8KFKpqV4MID2iab3F4kUedns5lhuUhmF8OPPIyfz+VLLfw9xLEUIhczgrT+7Xz/K
zzlvclqlm2WI4F96UUSPihl2PVjZEuc93Tc6fLq9T5Ii8iGsvwA3PVvBU/6js3nh
DOtd87YZJQfoBnegqXKZHFQK9PlRtnLiE4cumj66Yg9O74/+uSlZVXe8eOvtT/lC
mLc1AZRlwhquw33Y2dO9t1a4QAlt6Cw+AXIgrhYid56MglgzaNn+YyRBDoPBRZLv
kt5fRUFQLiVDRr/IUixY
=96+a
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
