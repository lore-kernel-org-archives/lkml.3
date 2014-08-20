Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaHTR66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:58:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55879 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHTR64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:58:56 -0400
Date: Wed, 20 Aug 2014 12:58:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>,
        <balbi@ti.com>, <lee.jones@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 3/3] MAINTAINERS: Add dwc3-st.c file to ARCH/STI
 architecture
Message-ID: <20140820175824.GT24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpUp1egui7PDlNtH"
Content-Disposition: inline
In-Reply-To: <1406734091-16202-4-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lpUp1egui7PDlNtH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 04:28:11PM +0100, Peter Griffin wrote:

-ENOLOG

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 702ca10..269ad3b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1325,6 +1325,7 @@ F:	drivers/pinctrl/pinctrl-st.c
>  F:	drivers/media/rc/st_rc.c
>  F:	drivers/i2c/busses/i2c-st.c
>  F:	drivers/tty/serial/st-asc.c
> +F:	drivers/usb/dwc3/dwc3-st.c

also doesn't apply, please rebase on v3.17-rc1. As for the other two
patches, I'm reviewing them right now and they apply cleanly, at least.

--=20
balbi

--lpUp1egui7PDlNtH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9OHAAAoJEIaOsuA1yqREewYP/iLq8FYsT1zrk9Zg0HcPYqn0
8z+L6zgSmkadE+1DF8e6Y6aYOGynGWFPUAXzvTrs49Fk/MiZxoxUHLjV8XOXkrsS
OJy1c53Oc3vN+affQ36BtB+QyL2rnHpn0aqlUi202k62C0ZQk70iXVPonsyRBvSS
h127tBpiA1LcrU5n1oZbiUXsGl9Jukj2+Yuk/Pv23HECq1K6V5pRVPnTyLgm1slK
Su21lzf/8OWQBnONeSX6ZWg+v1LaUMsNvCqzghwiavBSOqaK6aRb9pfYCTae7ZgN
UIRqF60kO9jVOnP3CJZeicQGiLvWtSn0TyvTnBJXtQJ3eYMr3qeii8ijUDRbkXCs
bbTjKlN5XsZvy31DK624tmFF6r/UC+ENfhBlut1UMYAn4BNcNDfHfymuDFjGBH1Y
sg4ecXTSnLtQjipyrumu22LoWiImGvlep/V/fQ2mMJruVB6oGxzqYrwAtF/dP3+D
kpBxdHK1ddWLvH07HZ3Wz9sFCXgztGqYU4rq8Ig9BYuqBVqgz3ouJLWwWGlahyFi
Fx3+ibffzKxzvW9Eu+caqLgukhaXxysdAZtUwb2TRXA0Mf6RWQ5CysD8vJjwTZFj
Es0RORXSMeMeZxVg8DB749DHPf4R5i25WZVG+SmXHFlw++xr6oiB18qRvUxW74QI
MqI7LCtIZ4XJL3yT/mz6
=/dNH
-----END PGP SIGNATURE-----

--lpUp1egui7PDlNtH--
