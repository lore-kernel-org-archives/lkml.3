Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbaEMHzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:55:15 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62978 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaEMHzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:55:09 -0400
Date: Tue, 13 May 2014 09:53:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] drm/panel: update simple-panel DT bindings doc
 with panel desc properties
Message-ID: <20140513075306.GG6754@ulmo>
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399645002-18000-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <1399645002-18000-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 04:16:42PM +0200, Boris BREZILLON wrote:
> Document simple-panel description properties and subnodes.
>=20
> The display-timings definition is the one described in
> Documentation/devicetree/bindings/video/display-timing.txt.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/panel/simple-panel.txt     | 34 ++++++++++++++++=
++++++
>  1 file changed, 34 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/panel/simple-panel.txt b/D=
ocumentation/devicetree/bindings/panel/simple-panel.txt
> index 1341bbf..3440f78 100644
> --- a/Documentation/devicetree/bindings/panel/simple-panel.txt
> +++ b/Documentation/devicetree/bindings/panel/simple-panel.txt
> @@ -7,6 +7,13 @@ Optional properties:
>  - ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
>  - enable-gpios: GPIO pin to enable or disable the panel
>  - backlight: phandle of the backlight device attached to the panel
> +- height: the screen height in pixels
> +- width: the screen width in pixels

width and height are not in pixels. They are in millimeters.

Thierry

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcc9iAAoJEN0jrNd/PrOhnKgP/1p9czcDlzv0oWp7C/t/mFEw
Lbvj3/Dv8Uxe4a7CZAJuT8HRTZm/76rxa1A9kX8lwCdzfm3MbhNUW3eMn/aoj1dy
P2vOyM8FDOU/AU8jt1P0FshRA2u7Q0PaZ+4KRKJRU4Eq2Wwlu/ytG3SUxCa7vJsO
gxz86J50m/dtru4faCLXELCNnR98HnK6AMAGgkcxwnKrinbLM/x4G2Bj2GnlrJ6z
WjsOlGPvTk1L6xIvTfnxdUdYBhDi6gFm6YLvB6rgidugzsdqSOX5DlZfplmcJOhF
6bR8SYyG0264n0KM3V24/ei0pi51OxVdad3Bo5T4ThZrdLxzlmMM2foI/3/KN6cD
IsvuOq4pUV8lVwWc4Sni0D4XtlTdhFpT8gKnj1DbbrQWgXr8yZO4nnUM+e3TFoGi
oQS/a4+RgBmxX9fdJOYnW+RqZ9jopvwi5ZulL/YlrJUj9aH2Cw6PIkbFV0Jc/n4J
GcwUGaBEC6lteanR6IA75GkLsDdSAMFc5Qv380m88QuQ1L2xNPNUdmrFmkaDwlWE
pBXVuGiT85st9n3satlVfmYKd/79taJAT6n2z3pmS+tz//N1qe9vfPN43i/R1ugZ
Tr1f2/doznjw7fp+y4p2lngwKo8i51T+xeirTzFV7bufLc34wTiWS7mQYq7hYRSq
i9FE5ZSbpYq97TK0ekFg
=bnDo
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
