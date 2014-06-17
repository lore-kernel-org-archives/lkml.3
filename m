Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaFQX3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:29:07 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59313 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaFQX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:29:05 -0400
Date: Wed, 18 Jun 2014 01:29:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/2] pwm: sunxi: document OF bindings
Message-ID: <20140617232859.GC25525@mithrandir>
References: <1400523003-27082-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1400523003-27082-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <1400523003-27082-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 08:10:03PM +0200, Alexandre Belloni wrote:
> This is the documentation for the Allwinner Socs PWM bindings.

"SoCs".

> diff --git a/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt b/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
[...]
> +Allwinner PWM controller

"Allwinner SoC"?

> +
> +Required properties:
> +  - compatible: should be one of:
> +    - "allwinner,sun4i-a10-pwm"
> +    - "allwinner,sun7i-a20-pwm"
> +  - reg: physical base address and length of the controller's registers
> +  - #pwm-cells: should be 3. See pwm.txt in this directory for a description of
> +    the cells format.
> +  - clocks: from common clock binding, handle to the parent clock.

This is a sentence, so should start with a capital letter.

Thierry

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToM87AAoJEN0jrNd/PrOhq4kP/104c9xxYm3H38x1BkD+dbM8
GfTt7I/Dvkhk1jt0feM0Fd76Rz07QFx1RFb8N9mgYLFNGNzAoRIywO72S+Ng33bp
ypuirnsW96aImje3CwMrJtrKGi8HrbocT5kt9f5muasQNCg3+7y/1Txy2UKuUp7G
nQOtrNHtj+2JXoyAN6ClLg4TCC+giNrlXKaaMEGzhJHl0Rv8AXA3G+JCNwbV9chV
kj+wZhr5l8yZQyg7NrBuYwGmFYvIyq5R3hpl8gsZHO0ubCZp+Fe9GYWoG3CkWwPK
wZEKIjVuMLC+4HzGuBtkJDTZVEC3n4ySlviAj+7ECF0m0RQ4fvMJ13vZvJmE2MBS
tUiZlQEXg1RTxdS6MgqFdAhmK22QQbTGpZoRuE3X4D7a1vOU4VOVnHawUaMGGbXx
L0Jwsd3lIEpxLPoa2wHkMmOh7qRsl745Y1BZ/ATIuqAC4byQ9ldsfzGfB0LFAcY/
qNASoWOarqTpuxXvmY+dBFpO54IeT/M67l5auonaKG1dJXwq7LIBO04hYv0hYPKG
0743XTtirOHjKXMfTumGllHKTyeZDt9dg2hyRmaBBMj4qngnUyiYkHPZxBcDyK4W
vaMFJtcTZO5M21GTxEGshVPIKcgXvwjUE5Xc8wKqAQQN55WSPP7gYpevhA+p30Om
14ZOhA5Baojhqb2ZFAwF
=282s
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
