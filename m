Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3CJWma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:42:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:42:29 -0400
Date: Sun, 10 Mar 2013 23:42:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 3/5] ARM: DT: tegra114:add aliases and DMA requestor
 for serial controller
Message-ID: <20130310224219.GG4743@avionic-0098.mockup.avionic-design.de>
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
 <1362852678-13421-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iAL9S67WQOXgEPD9"
Content-Disposition: inline
In-Reply-To: <1362852678-13421-4-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:pS0VisUGHYgAQJ+iCyAUixpT5qkvoRsHs+5extgXJ7r
 qKi6o5CqwDbKRgsDJ4rRQXQIcQwP1gwNhwM9u8V2EQsdCo/d9U
 fAvDmVBsUGBcQsF7ljP7p48P0gskG5TniI4Tzqv7toYq26xB0M
 dwUzRTcoJnFW/osQ/qOIgRJGQ+qpqIM9y0NcHGNrf9OTkx9Mz3
 d2o7PtWXCg+psu1WQ2voV29tBP/t9TQk/BJtXer4QPrzqWC/h3
 Gm6JZ0jcybS815EFUE+YjXRM5dW2kjvZMR00h80mxr26ZiQbGr
 53UrewKkvHmoupOWch2lLOapX1i70brkp+6ljwQe09gs5Umkwr
 i2XEf/NlFUHwD06h/yY+l1hn7w3Z+YPATXOnSVC7BUPwkavDEn
 O6JaHQuceAWGYmPY9tHolLI/UdMnbt2V6g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:41:16PM +0530, Laxman Dewangan wrote:
[...]
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114=
=2Edtsi
[...]
> @@ -99,38 +106,50 @@
>  		       0x70003000 0x40c>;	/* Mux registers */
>  	};
> =20
> -	serial@70006000 {
> +	/*
> +	 * There are two serial driver i.e. 8250 based simple serial
> +	 * driver and APB DMA based serial driver for higher baudrate
> +	 * and performace. To enable the 8250 based driver, the compatible
> +	 * is "nvidia,tegra114-uart", "nvidia,tegra20-uart" and to enable
> +	 * the APB DMA based serial driver, the comptible is
> +	 * "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".
> +	 */
> +	uarta: serial@70006000 {

I'm not sure if this is a good place for this comment. Perhaps it should
go into the binding documentation?

Thierry

--iAL9S67WQOXgEPD9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQxLAAoJEN0jrNd/PrOhdDEP/AmuvysFGkiVSQZukpun2xQJ
uGsBU9x/nXud+XUtGNDYcQYOr1n9e90RNWEn9A25UjtQc1JW06hYkdGzLDDUQCin
5PoyIQHbiuUelELGWvKalPPTgPwJYHmc1He3CH8rTrlcqfECT71dzJtpue1+aHqB
MnQr0gVFHcXG1rigq3FleEHWZTvmXUPb078FUDAM4VfNfAtt00KWWjBgYt0K6A1U
lNizMZ22HV6I8x/L9hnRJIwMJLJCgNDNMjNRiMtMapalrIONJFxM6dEgnOe+ODA0
wk4qvrQ/sQUBRfJwXhEXfrHuUlMPoFdjemjRS3nvk2a+n2xhokrHeRyQ0ngpjeKa
9YJgobjzx625hVWtLsEet22q98xKo7zilg+VOqbf93chUZayyKWy1tQF4c6eb79w
HiIf9YL9Tdd69g1zWbmoWoRhhV9phiiV9sPvApP1p0SgIuqZDwfz8TYII8KN4fuo
HGNdT75AE/lfF6GL1elycXBoqNFFUpQav6C41TMKSCsnv/+NnAsZQZlWivcPVqIN
xU7TeVdASHiQzqzVtrn29VI2F3QmZDAd/nB/SP+pzJvIlKne0Ud4MK87y62GqYwf
E9RRINbxUKx8Ro9GX27XUyqC4U8zPzZ0D1xW9DmnBWIc55i0zKa2PCD4u2WtKcLV
5U32NLBDjmqXJj6eBafR
=W0HI
-----END PGP SIGNATURE-----

--iAL9S67WQOXgEPD9--
