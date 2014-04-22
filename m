Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaDVTwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:52:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41708 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaDVTwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:52:30 -0400
Date: Tue, 22 Apr 2014 20:51:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Message-ID: <20140422195117.GG12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jNWcHVWQWvKhiWM/"
Content-Disposition: inline
In-Reply-To: <1397475984-28001-2-git-send-email-r.baldyga@samsung.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 01/13] Documentation: add extcon devicetree bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jNWcHVWQWvKhiWM/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2014 at 01:46:12PM +0200, Robert Baldyga wrote:

That's quite some CC list you've got there, and the mail seems a bit
corrupted too (it confused my MUA).

> This patch adds extcon devicetree bindings. Documentation describes in ge=
neral
> client and provider bindings, and contains detailed desctiprion of bindin=
gs
> for each extcon provider.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  .../devicetree/bindings/extcon/extcon-adc-jack.txt |   60 ++++++++++++++=
+++++
>  .../devicetree/bindings/extcon/extcon-arizona.txt  |   47 +++++++++++++++
>  .../devicetree/bindings/extcon/extcon-bindings.txt |   36 +++++++++++
>  .../devicetree/bindings/extcon/extcon-gpio.txt     |   63 ++++++++++++++=
++++++
>  .../devicetree/bindings/extcon/extcon-max14577.txt |   49 +++++++++++++++
>  .../devicetree/bindings/extcon/extcon-max77693.txt |   56 ++++++++++++++=
+++
>  .../devicetree/bindings/extcon/extcon-max8997.txt  |   49 +++++++++++++++
>  .../devicetree/bindings/extcon/extcon-palmas.txt   |   37 ++++++++++--

This is creating device tree bindings for MFD components as devices when
those MFD components aren't well isolated from the rest of the device.
If we need to add extcon bindings the device should have the flexibility
to decide where to add the properties, and really things should be set
up so there's less duplication in the documentation.

> +The following is the list of cables detected by the controller. Each
> +cable is assigned an identifier and client nodes use this identifies
> +to specify the cable which they are interested in.
> +
> +  Cable			ID
> +  ----------------------------
> +
> +  Mechanical		0
> +  Microphone		1
> +  Headphone		2
> +  Line-out		3
> +
> +Example 1: An example of a extcon controller node is listed below.
> +
> +	extcon: arizona-extcon {

The above doesn't entirely reflect what the hardware is capable of doing
- it reflects the default software configuration for the device but it's
got a wider feature set.

--jNWcHVWQWvKhiWM/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVsgyAAoJELSic+t+oim9PFMP/Ayd6ZXW/PfYVtfzJTJfLU+7
mL0MiPgW0BWkOjFRy+kFa6ZUpLZxT8xeQLrrM0MD1BuAjpmnnDp65D99lj0KHjvj
CTUei4VMQZFj59/fWwY439YDxuQqfMIZbI4rTUsj2QjaFm8NaW88V/hOfEaHDUFy
po2Ha/ljIF67y1ZZKxjFslOnSexV/lTBEpQz0pMKcDGu9+kI0WIpk/ecbThp/xYC
Dq5ckFKcPSptoOD4Yn0ennb05P44uS6Kus113kkE9F1QZqK8nqM0isWtCb1n5ca1
5z60aBHbIc6Yj2pWEavlS09Abnw3j1P6FWvFsQY2gZxwq6h8np6/lsa7UNAkFrEl
hiugorx2ItvkMSAV/F0FCiXlYDw6CdqSpV2H+jOQzd4VGvxKc0ZwAecbbLPfzmz7
8bJItJEU3/ws4zf2PcbFOY1FHU0Xxe0NP+rNjMaoBw9FJM++tCDAV1jvn0+1kt+l
5CLCtNdXyl4BcDp455GJz+YWybb30AgSrymVVeUAaFs6k+vZwHssVw5cl+Pj7e6p
JUrmUnjQzlXM65JcIVChRoAv5R9KjCI8ubP+VWl8OMYamBD9lr5n2PXmACKiVW/f
5nhL52gD+ijIUfbIc7w1ACEz+CCp9tbbqjwiP4Lx7SR1Qy/yMJSAc9Kx1FypN5Ko
Ih6wIoezNxNqZjpRrhjZ
=h3AL
-----END PGP SIGNATURE-----

--jNWcHVWQWvKhiWM/--
