Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaATQcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:32:02 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:35995 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaATQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:31:58 -0500
Message-ID: <52DD4F74.4000807@gmail.com>
Date: Mon, 20 Jan 2014 10:31:48 -0600
From: Souvik Banerjee <souvik1997@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
References: <52DD4096.6020408@gmail.com> <20140120153105.GA1650@srcf.ucam.org> <52DD492F.1060208@gmail.com> <20140120161132.GC3844@srcf.ucam.org>
In-Reply-To: <20140120161132.GC3844@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oMvO0XKH3ETfwtiVgLnnbCO7XwKPpJIc6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oMvO0XKH3ETfwtiVgLnnbCO7XwKPpJIc6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I used KE_KEY instead of KE_IGNORE. Should it be changed to KE_IGNORE?
On my kernel build with KE_KEY everything works as expected, but I have
not tried it with KE_IGNORE.

--
Souvik Banerjee

On 01/20/2014 10:11 AM, Matthew Garrett wrote:
> Sorry, I missed the KE_IGNORE somehow. This should be fine. Thanks!
>=20


--oMvO0XKH3ETfwtiVgLnnbCO7XwKPpJIc6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS3U98AAoJEDYrZuXu8ZIMFXkP/ibWeSnq9AIoWcYpBwl73xKw
t1tPqY+jYqqDXAHwZ3YzsRifr2WGf7pO5dlpme2Z7IOm2i3YYLWwJu7tsZ25V0fM
ZZnvilTN1HAh/kOaD6GOqoZ7WnNlpzgZWseQtF0Pz927tA5+poRHqgfXynZ8V12+
1FgYvrtQcc30eDVYwhM+fdZtuQ96QSZTVWZL+tqWb+dBsCovzl0/QIU2yMt6fdcD
/XGkthc0qCfCBi7bTyRwG3NL+cxmrZqfr0CrtK8xAFilUGOPR5zaKbtOAk1xI5Wz
LyfFe28rGqbN/rozi5kAL6S7AyRbf7vhdiPGwpFFHl/ndmxkPrmjoHt0e8jG8xs3
Er8TJe7C+5OQpr/rD3++2qOFCWdKiuunXVtD6kpQSIZH9AMxHIQj5t1UVYaOcc3k
so5esNAviQUOcLIEZUptkz6mN9wU9HaFfv+FTrBoKEt8fwxCy0qeJxcCEwA9HvMC
RxdT7W+4F92WxQW0vDInRzc2tMsJ/0gbw8Q0LvDafjlEOMMKbrmqj2cUjVVAex3m
iXl5oCbsPZJd64B7/6QfUWNEPVU7QyYrXVSKF+O1dsgap9UZfDKHA0pRJkzBY377
DyiZOLhJRC56K6J4vUtbeLqGEdCsEtcLwBeC39t0v26tmaZFXetXVSTVCZrAyNgk
syfUEJqnzvPQCM23FzOE
=MYhh
-----END PGP SIGNATURE-----

--oMvO0XKH3ETfwtiVgLnnbCO7XwKPpJIc6--
