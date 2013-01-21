Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3AULBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:01:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3AULBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:01:02 -0500
Date: Mon, 21 Jan 2013 12:00:56 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 12/33] Input: Convert to devm_ioremap_resource()
Message-ID: <20130121110053.GA11522@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-13-git-send-email-thierry.reding@avionic-design.de>
 <CAOh2x==ECCN-2wEkFuNQ6DN2K6LMe3kvYMXXpk1bzQvUVo19Wg@mail.gmail.com>
 <20130121104946.GA27252@avionic-0098.adnet.avionic-design.de>
 <CAKohpomN3tzdyHpv4ms2kgMK2DAQ9Q-8554He-1LjkVF0iXr_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <CAKohpomN3tzdyHpv4ms2kgMK2DAQ9Q-8554He-1LjkVF0iXr_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:K9UwXQZjFdfIhuQzZ5xx2gxKxptDaZ9dWEJJsJwFpdn
 5CBzDTwCAhXiwX6mdQOlA1IXBen8ceebjtdNvpiD3q9ww16wwp
 QyJleI9QBhvc74Ls0Wg0gmwLo9XGZtZeqJrchJ6+Ta3xKV1Bxf
 fyj6AvNzPhkhc3Ir3T/I/e338fZCpePCCjQ0OKPIRw90CCv1HV
 soaqa5uirvpQ3jfkQ3uOIPORzCC/gTwChmshIIyOYua1kMQvMC
 CjqoP9cWvR/mwv958fDfQ7IC3RSbj5ZqYFjt4d9Dy+CMQnSePH
 gEQeFYyAr9UQ/lEwJBWlGLTYerA41HG2zyN9jfX6TfmxhaB9lw
 64YErR7FpLaEbsS1BaKPhHD/eUwaoM50KgW2+WvZbBGsU8wOCC
 ni7bX47uk0EbLoHLadDBhJcDbozH8c0mfBplGSVAzmUI3B+6+G
 6XvAZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 04:27:03PM +0530, Viresh Kumar wrote:
> On 21 January 2013 16:19, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > Can you specify why? devm_request_and_ioremap() and the new
> > devm_ioremap_resource() both already output an error message if they
> > can't request or ioremap the memory region, so all this does is output a
> > duplicate error message.
>=20
> because i missed implementations of these routines.. Ignore this comment
> wherever i gave it :)

Done. =3D)

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/R/lAAoJEN0jrNd/PrOho4IQAIj+L5PNBf6Z2DaSqCuCPDfg
dh7KtpJuZKPDtqwo/owwfXuPxqT1Ur5P6Cim0VIv4XRoJ9Mx2qOWjvbbAQ5stpb2
AE0vxBzgIrnUYrJWyiHHuQrkoNoBI0pOj2g2GezvE1ZS6Ph01h2/2S1L4Zegb4P8
94XTL3yXPjQRH+4OxZZtH0pCsWHXZJ7GWjqrZfsmgaRiLqdryLeGAtztXCOYhy18
3bernuV29xauEAHqj+oD9Zov4mBg0StHTYI6VQPaXbvQTHyCWCibM2nxReZtlddn
Zgl+aH0Yrr2flAVq4AASFLvHS+OOUJM66LmSwBG7sInwhafe+uNK3bPezSb6UuRU
Sg3UIdG7xIP7VDHRXfZRpcFWOrVmSsDr3aPp8cANKI/6V0SIG6qeTqqucYa8XNB7
ZbnTUfas/neAZciA/FyKXPYWWRxT0ggTfXeToKM9d+tUgSmnvVoSxT+J2l21E94z
3ctbULrviv6oJDng1w0qu126Oji1eEFzmptC4jzNboF/nGgiti/4gtI2ORX7A70j
s9KwYAbl4IrFloypTD2o2W+/quuNrwrc0rzoVO3kDVhWm8EdPkbFf1ZOENvKR/D5
R+NABRbSE3ZRLfIzNkAEZmw+Wzir4gOlskHb4hJTM18QBjEnOZv+WMVJdl3ho4AT
m3f1fNE9DUu96IUs9o45
=Or9h
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
