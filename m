Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaHZNls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:41:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55428 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaHZNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:41:46 -0400
Date: Tue, 26 Aug 2014 15:41:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/3] pwm: rockchip: Allow polarity invert on rk3288
Message-ID: <20140826134138.GA2980@ulmo>
References: <1409007567-23523-1-git-send-email-dianders@chromium.org>
 <1409007567-23523-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1409007567-23523-2-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 03:59:25PM -0700, Doug Anderson wrote:
> The rk3288 has the ability to invert the polarity of the PWM.  Let's
> enable that ability.  Note that this increases pwm_cells to 3 for
> rk3288.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
> Changes in v5: None
> Changes in v4:
> - Updated comment not to add caveats about pwm_cells 3.
> - rockchip_pwm_set_polarity() is now static.
> - Separate pwm_ops for v1 and v2; no set_polarity() in v1.
> - Added a blank line.
>=20
> Changes in v3:
> - Don't store a private copy of polarity.
> - Use true instead of 1.
> - Cleanup init order with "has_invert".
>=20
>  .../devicetree/bindings/pwm/pwm-rockchip.txt       |  4 +-
>  drivers/pwm/pwm-rockchip.c                         | 57 ++++++++++++++++=
++----
>  2 files changed, 50 insertions(+), 11 deletions(-)

Applied, thanks.

Thierry

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/I6SAAoJEN0jrNd/PrOhCdUP/inJkzIIKf/NijSTLxngMdfs
s7jkmXFSHuLIgIW+yfPOXftxY+fC/gOrKQTZBORLPCT0UtNzHMhrAcdyZHQ074KG
g1LXtkapK+VGSo5hVijOgxXEe5eTzc0EO4YFQpCLBYLd/BhlOuk+h4twJJyZfR27
uA0w539wbXpy3qBMIS8NEiToT6zqYrXOMUV0ddcMmuzEef5AOJFSkO7s6uGlKGXm
MUbMU3FjOfgVaTMCwtqr8lwueqvvF739EHbsrhjofWAXi3xMc0KtoeMUNjYvSr7e
2iPWuM7JthqorDvy7g0q9x6x7vvoxyYfTfHzAk4chdaf/MhE+50J9zwk8FL0JpxX
nUzIfFE3Uyfh+WFUE/KF+/DScSLTVKCuLuySQue0dKHXZAYcMJFJa7ldj9j+ebru
pcuv/2hbHC2i4jZ+BMl6ernBTMeAaeIzNaVAKzGeeSQ1BNcLDJGPAjLMfw3HOGVK
N/90IiUdHqXFWHnEl/qcMWzUPye8bbaC61JYBTqsxo/z5v4y4Ms4rtMGk1njEZIr
J5rGN0S9rFn4T2urtryhvmAzgk4cYjVVmIk1dZGeHsI3aWOzatf5FFFb3i4CulWN
fI+nUwE8ZavHUpLwX1pf6pWkqBjSRpErwmk1/3MCU/7nKnjyxx8fAjBcApOPwKt3
b65e0iCZv45l3dCiVT86
=E9tI
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
