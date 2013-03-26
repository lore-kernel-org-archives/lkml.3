Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab3CZPYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965313Ab3CZPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:38 -0400
Date: Tue, 26 Mar 2013 16:24:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Arun R Murthy <arun.murthy@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: ab8500: Fix trivial typo in dev_err message
Message-ID: <20130326152432.GA28997@avionic-0098.mockup.avionic-design.de>
References: <1364308490.4090.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1364308490.4090.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fm3GrKSGTneu5SRS1TdL60DNm1TH2qBp3L+4etTV/4S
 dog3yKboV4uNwcPt3cDosuc1HUfLjYFK1WeJ3jAuIL11rlsIxc
 IOZ74HUK1GumQCnM5fucbnBF41AvqnHauMrkDqv7yAcKFu28P1
 SzyNuk5q5c5dPUlvIQzfuBccD0/sAG6J6SrYRY/LQMQH298uls
 D6QOBi2TCFtd0Qvqn2yAE+2syVG176AbFGJSoSK3LJZmuhqj+U
 L2+t7f8SfNWHMaKNjFZodw0KWUXzQ01L9zX6qnS36wFJjHcbS6
 mZ/j+xftoIDIs8MywpwpvFhQnARPT9oj8PMVpBbi4FGtqEFNam
 3g5AAb+Hjgv1joEDiDqJIvfrgN+pnpl/RN6RG0lTHWxTD/Bqhm
 RLi5OCRGOMoT0RXtEo7tAcvVESRvvu0dGT6Gm3MtugYxwL9vbT
 an7uq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 10:34:50PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-ab8500.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
> index 93af1bb..3beb2b5 100644
> --- a/drivers/pwm/pwm-ab8500.c
> +++ b/drivers/pwm/pwm-ab8500.c
> @@ -66,7 +66,7 @@ static int ab8500_pwm_enable(struct pwm_chip *chip, str=
uct pwm_device *pwm)
>  				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
>  				1 << (chip->base - 1), ENABLE_PWM);
>  	if (ret < 0)
> -		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
> +		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
>  							pwm->label, ret);
>  	return ret;
>  }

Applied, thanks.

Thierry

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRUb2wAAoJEN0jrNd/PrOhTY8P/1NLTplHrifgtEKRQfE1khQo
Lq+Z0dhS6RnHJ+ILlbZ67Qp7AT5j2UmZ+MADqkxxeQPyCYaY94niMLT14YG3ZA94
vwmG6eY8tmBTlwH+Z/Hn1oAUtkqWyv0ebtJXsa8781+NXSsyOgPd2K7QIb52cO7s
wxwpwDSUcxiV0ZyUnlFxpXKoidx5x/EvIAu6gSNlbWFK+I48s5ExUn3MsI77StKV
kLOiPjZ1d0UWwrf+qYk//w9ahM/tk64cFdjiCBDbWvTiswmLtqAK1pz6hwrUrFoj
nqLu+5/M+2X1fNfkm3TN16DPX0HMCeouxpJxNouVIGf0YO69KUDJSX1KFE8VrzYj
YqFVKJv1vkI1GWMujsgVjxnh2nT8wmPRuX8WbInNSdmC9i5WHF+8vD22DXdLrMx7
B7oVd/c7XuxYD6Te3Zfssy7xKfAWAgvOrdRt7OkEzeiNl48L3MuxQDWvkXX/pI/y
XuxaUZCyOucd/9uvwpsegMDZ+jxXrTTKHMLCKIx+MRWrPII/IsrPQrhsEiaFKUXJ
abk26XQe+uGpQBI2CRg1ulRlNaHpNFFzpGuSUCEIxF82tqiPM4XkIABwZFmcHrA1
08ofhUwS/KStnCmiP7RFr0Ifo6ysRIN/znAPrl1NnSeowiGD43kv+4lwgpRb+9Wh
ooNPDEJHwgFvBj1o1w06
=1dU9
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
