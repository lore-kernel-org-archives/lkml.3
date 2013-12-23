Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3LWQ12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:27:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33753 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab3LWQ1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:27:24 -0500
Date: Mon, 23 Dec 2013 10:25:57 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v8 3/9] usb: gadget: s3c-hsotg: enable build for other
 platforms
Message-ID: <20131223162557.GC28679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387462990-12039-1-git-send-email-mporter@linaro.org>
 <1387462990-12039-4-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1387462990-12039-4-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 09:23:04AM -0500, Matt Porter wrote:
> Remove unused Samsung-specific machine include and Kconfig
> dependency on S3C.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  drivers/usb/gadget/Kconfig     | 7 +++----
>  drivers/usb/gadget/s3c-hsotg.c | 2 --
>  2 files changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index a91e642..181e760 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -294,11 +294,10 @@ config USB_PXA27X
>  	   gadget drivers to also be dynamically linked.
> =20
>  config USB_S3C_HSOTG
> -	tristate "S3C HS/OtG USB Device controller"
> -	depends on S3C_DEV_USB_HSOTG
> +	tristate "Designware/S3C HS/OtG USB Device controller"

causes build failure in x86. Sorry dropping from my queue.

--=20
balbi

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSuGQVAAoJEIaOsuA1yqRE5iIQALW9ji3h8BP6h0nsJyJUa0lt
QSVxyjoajTSC/0G08vCbpfIH6d4LAenA0RTe2W38ufTH6GRJWfQlHBdpZsutJpH9
lZPoaUy70r6l7ZUVK4zp9sESmmSMpA9s3lYw7i/dT7WT5hTMZ6NKMusNpj5FCUkJ
DdYAbwVW7bSL7CY+axyyO47CyDlel8h+7Mv31bspMQTO+xkTPI26M5PJx//hJHmw
+WmD0eeMCmPxUO9xHKH7oNHxrUPYqqZk458JEJZCiQCJAk+a0kOyWHcQN6oN9KrF
J4mmJc22K97jah6WwQDHZpZfrB0h45CKfARiB3HD6PgACSiaGXE6+2zYT8jw8xmk
R+LTWv16squEOxBiWwUd5FN9shK2ld+7PFT7VrolIZ5KHfgUW2h3s1/Zb2q3huCy
LmwU6V1ZllcBKGeuUDvMouPpLd7oRuK1ggdFud9zd0XwFLlX4/zC2LK1Xqs0QzMn
sQt0mubWovGTGV3XEWQG57OpA+V6WY+VZqoGi7tsvmVVSKtNeO1RnDaoKagCXy68
jNbZCBsSq1gJMxpHWB8j7AxDSuViQ7J2KxEqdJkLPjgd1OB02F7QhWSpxkuVDbyo
sVcMiD/wV3jHPDqR61NEfqADFKc2PWoE24KMEb0ClMpxyArODLop1DkYblOLEFsh
HwCMbloDHgzm0Vj4d5AP
=3NTp
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
