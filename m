Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaHKNoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:44:06 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53490 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaHKNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:44:04 -0400
Date: Mon, 11 Aug 2014 15:43:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: swarren@wwwdotorg.org, linus.walleij@linaro.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra114: Make of_device_id array const
Message-ID: <20140811134356.GC26128@ulmo.nvidia.com>
References: <1407755870-439-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <1407755870-439-1-git-send-email-kiran.padwal21@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 04:47:50PM +0530, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as cons=
t.
>=20
> Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
> ---
>  drivers/pinctrl/pinctrl-tegra114.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pinctrl/pinctrl-tegra114.c b/drivers/pinctrl/pinctrl=
-tegra114.c
> index 33614ba..a3db85b 100644
> --- a/drivers/pinctrl/pinctrl-tegra114.c
> +++ b/drivers/pinctrl/pinctrl-tegra114.c
> @@ -1850,7 +1850,7 @@ static int tegra114_pinctrl_probe(struct platform_d=
evice *pdev)
>  	return tegra_pinctrl_probe(pdev, &tegra114_pinctrl);
>  }
> =20
> -static struct of_device_id tegra114_pinctrl_of_match[] =3D {
> +static const struct of_device_id tegra114_pinctrl_of_match[] =3D {
>  	{ .compatible =3D "nvidia,tegra114-pinmux", },
>  	{ },
>  };

Good catch, thanks.

Acked-by: Thierry Reding <treding@nvidia.com>

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6MicAAoJEN0jrNd/PrOhEmAQAKgqOrovUIACVn2fIRhfkX0B
E4iICkH9FJvaLqf+kSVEs1BLWruB061quaJP7Q1Xubc1ASgS0SvxIqWa22HFj+KW
lSvlegPzlZwQpqUCEhRymr6jTSbcXA8NnrPAUT7SZI/TQeyC0qPq7a9rU8X0wjk7
5WFw+VaUZPnlWvaJ1DfqAOi2ZcS7Wex0ro/VBVnclhwY92QSe1B6RoS0eg101zPx
wWcSbSYIlRkNPna83mmk7PfOYgujCUOGJNRLAi5n3XlkzsPTyu6XLIFTzXjDAe8T
Xhb4w5EWNEvLAFos4PSlK72q74UfvB5mnGoehlrewrBjleE6IrS/v+uYVq3GuB5V
jNOAnnOK0BZTrbfQ+40Hv+Xlz1v1ZJF2MP/ldp50Fx8HwWqZCbNcJrFEFE0SlBWM
+bl0s3aoCyuGS63jBEzy8zfGch53+5SnPDgy4wB6yzOEZOJCyPU4vs2xHtE/5NLN
ku6dU2HIY8zn90b8yIRaDRIfWngC8s1phrkbWsPCvcdgFeyEEGlt+Y1FSwLc+1kB
Ehp/CNC6A2gPPdwgk7+fDyO++Z1UPK/2C8HP9FTH/DGCfNCZ16kTlgfjyVD5P2V5
vsTOq1EJ4Nhxto8dujg/pNHcxEJPWH6AHxNI5zkO5N0c4lwEowj3aLZdTgebLDFD
nZBurLRgPYXzj+LfP7lT
=RV3z
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
