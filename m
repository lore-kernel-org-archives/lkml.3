Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaENOeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:34:19 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37818 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaENOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:34:17 -0400
Date: Wed, 14 May 2014 16:32:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, stefan@agner.ch,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: initial add of Colibri T30
Message-ID: <20140514143209.GB8612@ulmo>
References: <cover.1400001937.git.stefan@agner.ch>
 <d45ec5351ce8ef03256061bdc4b0ba673bd40c66.1400001937.git.stefan@agner.ch>
 <53727738.4080901@wwwdotorg.org>
 <537319CE.7020101@ziswiler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <537319CE.7020101@ziswiler.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 09:22:54AM +0200, Marcel Ziswiler wrote:
> On 05/13/2014 09:49 PM, Stephen Warren wrote:
> >On 05/13/2014 11:27 AM, stefan@agner.ch wrote:
[...]
> >>+	panel: panel {
> >>+		compatible =3D "edt,et057090dhu", "simple-panel";
> >
> >The panel-simple driver doesn't seem to know about that EDT panel. How
> >will it work out the display timings?
>=20
> Good question and me and Stefan actually even talked about that yesterday=
=2E I
> am actually using KMS right now as follows:
>=20
> video=3DHDMI-A-1:1280x720-16@60 video=3DLVDS-1:640x480-16@60'
>=20
> So the panel node is purely used to hook up the back light part right now.
>=20
> From our point of view for our completely generic module approach where e=
ach
> customer potentially hooks up his own display make/model it would be
> desirable to have some way of defining such timings directly through the
> device tree.

Every customer design would presumably get its own device tree file, so
they could easily follow the current conventions and update the
panel-simple driver with the proper compatible value and display timings
and then simply make the panel device node compatible with that.

Thierry

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc35pAAoJEN0jrNd/PrOhVC4P/0szEjvrRSwwtRVnMyX5ccJe
zHTS9fTBhAOZlHxafqVIaUPpUGkhmTfm1lf58YIxEvSpTsHEdP7EVbDGZgxxGd0k
HVY1QMWZtNUCbxvpCMYNVOUivLYYnBv/vkLIhtf+SyyO590YhndC6L4GvskyY0Ov
K+tUhPyMtICCEnRd9XYNy9hqTHbO1JQJHiNTx1SkER0ykt7ZuEN3xlrQwXaahCda
2NA+fLBdZlCrHsqyQcq+Gx3ogn6o4C11H0Od6oza+KnKtzuExTEim4OL2c7n0efN
X2y3GDQ06Xoe4zgJZcSG8CzjkHnQxmiNHqnVIdoCHBQq8CfPGoS+teWM9Xnc866h
cXcsPgbTRrpbm7EJgv3zWKJAASV2zWmG7eFEQb5X059XCiBbgcD2HIaVLjIW/4Lm
VUX8wFnUdK61MlB85gYODKCu27tO2ePeIe08r4Os9lf6N0THYX87kTYdJKN0HLoR
5Bj32sDItpt7vJZHfeHnOnC8y8h9TuhiI9l+uDoJJk+rUA10OtOqa+gDllOzf+X5
eYl6WsRKoiWxOhqEU8YP7ffoKefsqbhC1TDmLD0Fek+yD2sWmXS4ZBYoU6bndiPg
L+Q0kXbL5UnarYQOczUEAzNlqBA049d4vLYszUYZAiZjWgqdTCxmSw2t94qwG0v8
mogdXBfkRflWWVmRcV8Z
=+bbS
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
