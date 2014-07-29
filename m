Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaG2Lb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:31:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36485 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaG2Lby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:31:54 -0400
Message-ID: <53D785F0.1000309@ti.com>
Date: Tue, 29 Jul 2014 14:30:56 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        abdoulaye berthe <berthe.ab@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Michael Buesch <m@bues.ch>, Greg KH <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 3/3] driver:gpio remove all usage of gpio_remove retval
 in driver
References: <CACRpkda6mzVdaN0cvOxpbsxWyCv2nGyDXOjZg_5aT8u7SSQeUw@mail.gmail.com>	<1405197014-25225-1-git-send-email-berthe.ab@gmail.com>	<1405197014-25225-4-git-send-email-berthe.ab@gmail.com> <CACRpkdasp9bLULT7NJM9nYX58rRSsQKXFddOLz9Ah6kp-j-3=Q@mail.gmail.com>
In-Reply-To: <CACRpkdasp9bLULT7NJM9nYX58rRSsQKXFddOLz9Ah6kp-j-3=Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="nDvig6w1IaO5idwNJGff6KXjnBUdsJGt1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nDvig6w1IaO5idwNJGff6KXjnBUdsJGt1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 22/07/14 18:08, Linus Walleij wrote:
> On Sat, Jul 12, 2014 at 10:30 PM, abdoulaye berthe <berthe.ab@gmail.com=
> wrote:
>=20
> Heads up. Requesting ACKs for this patch or I'm atleast warning that it=
 will be
> applied. We're getting rid of the return value from gpiochip_remove().

>>  drivers/video/fbdev/via/via-gpio.c             | 10 +++-------
>=20
> Tomi can you ACK this?

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--nDvig6w1IaO5idwNJGff6KXjnBUdsJGt1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT14X1AAoJEPo9qoy8lh71gvsP/iJDf8dcnv2JZFloH/noIb3s
DCXfxyTW2zDeWEEH7rLW+fP5JKu5TutqOCF2Y85HaPa/DV1iMI4S+IUeEwNiw0wd
JTwMqUbS2ua22J87F1Oc5kXshDk+uqLRfpxO7xs0Pd/JcsrOgA7zqJN67jeDwQo/
XsiRTBmJ3CNR/qur7AKN8toHdZp+KaHZ/4cazUxxp/cu71eFuRfFJMjE/cGk8cva
fsIrugCAFjYIy3z88VtW4VPj1rcNDYUlxcklbpNtosOKUuPfNoDwToLUCdjE22G9
v93XHZKlv0iWso5fo9HA2BTDK7N37WMsyktqF1ULEUiKIyoWs6a0WG9eREVLKlpi
ugiCLH6c4jQYycmSTmFGZnzuhz5hN5oirXpKtba6hVHh6ZNkIkGtFElGTZYjVhKn
k06HXBVTTYwf4pg2PGSGPsl2dIx0Zyl8pG+iFn10LSxELxbNU6N/wYzf6LquPLok
cnnfX2riaFV6DgQHhHlTqr0tN6NFb8smYeH9rq37+4GyVYnokXuBMJ+qQ5In8BDZ
9ZgW2N1PH2aRO2RZERVwll4otqtZgJcmWdAgeZzjkl0nBpWH8X78c41O3T3LUscq
3cDDyXHCLDGabHGuab5JPofNnN1GW8xM/wN8jLmH/abZICdjfGqRVzaQh7FJjc97
PbSJaJG3ZaHHHc6LWcil
=W85Y
-----END PGP SIGNATURE-----

--nDvig6w1IaO5idwNJGff6KXjnBUdsJGt1--
