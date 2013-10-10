Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3JJHzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:55:36 -0400
Received: from sauhun.de ([89.238.76.85]:56478 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3JJHzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:55:33 -0400
Date: Thu, 10 Oct 2013 09:55:31 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: linux-omap@vger.kernel.org, patches@linaro.org, steve.mcintyre@linaro.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Felipe Balbi <balbi@ti.com>, Richard woodruff <r-woodruff2@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: omap: Clear ARDY bit twice
Message-ID: <20131010075531.GB2638@katana>
References: <1381142519-29382-1-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <1381142519-29382-1-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2013 at 01:41:59PM +0300, Taras Kondratiuk wrote:
> Initially commit cb527ede1bf6ff2008a025606f25344b8ed7b4ac
> "i2c-omap: Double clear of ARDY status in IRQ handler"
> added a workaround for undocumented errata ProDB0017052.
> But then commit 1d7afc95946487945cc7f5019b41255b72224b70
> "i2c: omap: ack IRQ in parts" refactored code and missed
> one of ARDY clearings. So current code violates errata.
> It causes often i2c bus timeouts on my Pandaboard.
>=20
> This patch adds a second clearing in place.
>=20
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>

Applied to for-current with stable tag, thanks!


--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVl1zAAoJEBQN5MwUoCm2VwAP+gJ4HFNH6QzwEVIyqFU1yT0r
KVn6VA8isQ/DCXfREswOGezJI9pwKSdxpM3yQf5RXKVhazU6A/yTrh2FOj9wYVat
x+Xl7NY6/wptc2cU1kHve4IVyt1x/UcBVBpMI+WRV76ayEiP1O94SwRlIhDd/KnV
Bi9q/hbrHGLeKVMPH++buzOUJ/wuzHgGy1Xcbzq8t5zoOhy8/jWiJIcyT+hLtDbO
BlSdaMnbpq6bMJonb6fx9egxGJR1LFPC8t7c2AQ7KZ1WukddrChcNqo6dicnIJJD
Gv3s4HKC4kE8oJpYTGcEluh75LEn3IwyLljQqlzfLY5VitYgaRnnOrCxyohaG2ga
E1wJn9DsKEDt7D38VxNBeFLSXm5Rq1bIvpcdUbNyOEZZHx0tCWHiROak1CLNrWWa
9F4pL2krPNi1jCyF8VaDKapELXWObDyFMZkt4Oji246dFaWzF1Xx5MSz4VwLuxw0
Tt5QIaJto4bIkgo4NTaLH6kmkT0nf/Kq4rHVnAbYrNn4crp8bvH4QyZtVQthPkbX
ljenEl8BSpQEDuZceMY0KSE5GYnHWQXlOcAtP+i9t0KnjcLKZEVr8+vrYVCvXD0D
x9np9d6vcM4muyjgpojXyya+dhIGSsM32YcHb5jrXKgJl71ZqOhHRcqH2iCeHcc0
8GNmHVBD3P6BNZHqzVpe
=aY2K
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
