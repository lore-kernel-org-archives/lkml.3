Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaGWMyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:54:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:40599 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbaGWMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:54:15 -0400
Date: Wed, 23 Jul 2014 14:54:09 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH] power: add driver for battery reading on iPaq h3xxx
Message-ID: <20140723125409.GC18172@earth.universe>
References: <1405157629-10550-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1405157629-10550-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

On Sat, Jul 12, 2014 at 11:33:49AM +0200, Linus Walleij wrote:
> [...]
> +
> +#define BATT_PERIOD 100000 /* 10 seconds in milliseconds */

that's 100 seconds...

> [...]
> +
> +struct micro_battery {
> +	struct ipaq_micro *micro;
> +	struct workqueue_struct *wq;
> +	struct delayed_work update;
> +	u8 ac;
> +	u8 chemistry;
> +	unsigned int voltage;
> +	u16 temperature;
> +	u8 flag;
> +};
> +
> [...]
> +
> +static struct power_supply micro_battery = {
                              ^^^^^^^^^^^^^
I would prefer to have a name different from the struct defined
above.

> [...]

-- Sebastian

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTz7BxAAoJENju1/PIO/qa/5oP/0jKdc7MviJmJSDuwOxMbsjM
NB0zsi4B61uhKMjdSAfaJ6oE5SDRZqjpOTQkgGbygu3guc6df4RxJkHKC2BbUI51
CWF+nvxslr/iBKfwW3SfUp2pY4jTCnrPxppfMbxnrsxbbSl1e1tNKt4bXEQTmoXg
5xcLMxup0gSyiIZuBfB/XdlUpvm1rreTJf21AQIhne8bOplHf7arKAuHQO/tNVCX
Jqp006wIkwnxcVGoTvDP6WXTJH4TAXROwIafd7semgjh1uBXRlCviuSKHofbU6J+
2lsrPOVc2Qn2gxLNUPO94LQr+L93T9WIWHoAElyMJDGQHU+flWDE0TZ3Of17vvFH
KQ1Oi1wEeYabMvcOeQh4McezsH+BXEbYXaLW4+jq0BcCvZR8uanltbo0XuL1iQzS
sijNOdCrRTzpgxFnOJkMp6llm54TXRg6t7CfAni7CdRdQsR/ghRUHSNAaFqwgs4j
Fi6iggjWKt3J/6VXMjMLpu3aL7kNntJLzVR8hMTgb3MQpQ4BoAspIaK9ER4d0JHV
KCprvE/Y1qa+C6tfr/0uNG+JWkcu2D4PPcZQhmQigvu+8pKUUeNAa0GjGi0xpx/G
5rMR5OGnP3+bBzpbuq59n8Q+orr0mn5jexoZ8ESvf1/74REH3uLelJgMfxTNCnaM
RK45c/zxJsAEI/3CbwU5
=t++l
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
