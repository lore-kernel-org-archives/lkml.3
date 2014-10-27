Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaJ0PzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:55:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:42732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaJ0PzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:55:21 -0400
Date: Mon, 27 Oct 2014 16:55:15 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        dianders@chromium.org
Subject: Re: [PATCH v4 0/3] gpio-charger: add devicetree support
Message-ID: <20141027155514.GA20765@earth.universe>
References: <1411504936-21026-1-git-send-email-heiko@sntech.de>
 <2175750.C5jxjiuVyT@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <2175750.C5jxjiuVyT@diego>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Heiko,

On Sun, Oct 26, 2014 at 01:06:28PM +0100, Heiko St=FCbner wrote:
> Am Dienstag, 23. September 2014, 22:42:13 schrieb Heiko Stuebner:
> > This series adds devicetree support to the gpio-charger and fixes a sma=
ll
> > issue with the return value of gpio_get_value.
> >=20
> > [...]
> >
> > Heiko Stuebner (3):
> >   dt-bindings: document gpio-charger bindings
> >   power: gpio-charger: add device tree support
> >   power: gpio-charger: do not use gpio value directly
>=20
> I can see patch3 in your tree (and 3.18-rc). Will you take patches 1 and =
2 for=20
> 3.19?

Yes.

> The generally used 3 week period for devicetree-binding related complaint=
s=20
> also should be over by now.

Right.

-- Sebastian

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTmriAAoJENju1/PIO/qalcsP/A7hQoH9M68yinExk6meFThE
cYWypG2aFlwYGK0K0gwOWu2PJZLQ6W8oMjxDcAp0fj3CzpR9ZRzipbEkcUPEH/1m
/Ap4o3MapJA/CiIicxoF1BKbmPuGCaoNWctbbfZwz7wBYpW3XsHil+9Z3LpU97oh
iOyH1FDYy1AxS/8k1kjXskXVznjiSFLBsyPTYnTTjywMIApUCb48W5bz/QH/JF/W
eyhaA1QQQLQrocOnFuN7xfd0QBJcVPNT0ehzgOnlh8wv+Ulr/ISMNcT0HIlm23mD
uHVuHHomkIzt5exHDfCaKPOd2X4mJdKOxomohRLP8dSPltOjaKlwf3i31EHZ0xoz
c+s2Jm475179UWMLAJhVNTbZjZtpjgy4FSN5glxly/9ZHWqu53ED+bd8W6lMQlxl
flowrQT74CDrW8Kc+Uv7Ptb7Pey2fb6g+oRiQ2XBz4OT/aiYM8wSQ9jTj/UBDPRF
+K9MXKV2BCxHbMen1w5650l+y9n/23zH4tq9OV6o4MQNRjflYBsxfnL/xX9UNdt5
/rvdvQZFaK2R8//O41UpX9++/CuwTbKXp0CTOHqGOGiHjNiOBpeqXbjnypvZZuG2
vDRaEDB1PKvqOAHS4rQXv3eWPb2yN/esa/JS+FfRDPp8svs2IPcKArzTHyCxnqDi
5DTVI9jZzLk8vlqVDxEt
=uBSt
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
