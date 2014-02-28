Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaB1JB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:01:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39445 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaB1JBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:01:54 -0500
Message-ID: <53105077.4090102@ti.com>
Date: Fri, 28 Feb 2014 11:01:43 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>, <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kys@microsoft.com>, <abgupta@microsoft.com>, <haiyangz@microsoft.com>,
        <jasowang@redhat.com>, <devel@linuxdriverproject.org>
Subject: Re: [PATCH v5 0/2] hyperv-fb: add support for generation 2 virtual
 machines
References: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="l0iuHr5xEEFNCHLwwRgO7LS7PRItn893X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l0iuHr5xEEFNCHLwwRgO7LS7PRItn893X
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/02/14 12:51, Gerd Hoffmann wrote:
>   Hi,
>=20
> This patch series adds support for uefi-based gen2 virtual machines
> to the hyperv-fb driver.  It depends on a few vmbus changes which are
> staged in Greg's char-misc tree (and linux-next).

Depends how? Patches that depend on other patches should be merged via
the same tree to avoid compile or functional breaks.

 Tomi



--l0iuHr5xEEFNCHLwwRgO7LS7PRItn893X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEFB3AAoJEPo9qoy8lh71TJsP/RW4drjOoS5twwNVoH9GL6y/
BEb5TwEuvfa10d8LSJ0Lqg64bwE/6UZi0yQTtOFRmdn1li0uKpK3/5Wck98fbCqf
Ogla7RmUNx0nbvxf++5snW5+w/ZyMzGTl2BNt4plzjBvXhOxuoPNNTvuFKF2qJTw
wq4E4W4MJ8cnV2L0dB99Ue62OWpaQn+h62M/BTxL1l6BeFifW6Koi3ji5oo7QIte
BAyz/P0BYr/hRzJXyygn72yAIkuLcmPZBL6TxP52/u1KJ/r4bIRBmZ+hye7JTmy8
XYyIjiH0xBvbEfJcwPv6B24Uf3tAOPndXtv2bq2On7Il0eO8HVQ6URqxZw9BC/95
2cWc7VN//sTTgXqpVYF4P1VdiCKdW/FRyYBcwN7jpuFdXWyzKWDJaBScfn275dhY
lp0Ng+I4B9r5mUopalqJWuB79lQeBZykxhqJHoLqYkZYI4umZi7j5DlR+QEojcZC
4LtR+5gRwzvQfTi0UCysGYJZMyLQl0HyZT7PYnq/jkOTlEUgHhS4rTFlDo5m/jPP
W6Clz5lKASO7Se29qS4FXyvb9Oy7XVMXbG3N6YxYyOg2VXkULLUHyJqeyUkbudKt
jyC1zMzRsXAzrPp+kUM4CQlEgsKSma9fBpW+K4iAHLlzxWLh5Be+zYTcWRlAQiqr
tuvkZ15mX2FHdCDwqoxE
=/FiR
-----END PGP SIGNATURE-----

--l0iuHr5xEEFNCHLwwRgO7LS7PRItn893X--
