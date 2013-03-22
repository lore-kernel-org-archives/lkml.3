Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab3CVKjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:39:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3CVKjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:39:41 -0400
Date: Fri, 22 Mar 2013 11:39:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: ab8500: use devm_kzalloc()
Message-ID: <20130322103937.GC4567@avionic-0098.mockup.avionic-design.de>
References: <000001ce1baf$71e96130$55bc2390$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <000001ce1baf$71e96130$55bc2390$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:qxLtlnjld9RqRi6t7tKfevaONscADE+CeZEOF/WuhIj
 3HEncqJY6rWZ4nZGGH7oY5UBX853rDhEUclanCrNH572YfrPZL
 QaRvfXwtZ0rRnQuMGvbZRBBR+jGGzRgyr7Qp9TqVkDBVPWfCB2
 f1df6cG+tbV/G5KseQD1B8plNseGqNBHQHeCV0/EhlqhxTNDJt
 c7JKwTmA0Y/UYGB7jpLVKRHWtRxZK9dnjnI/S4gpHXuPUFT0sH
 +3R3sH/Ocj5/uH65m09twyU06rUCtRqAjzqrR5fhBP/AdoHPy4
 IgHPGh9DrelanLmMjGXr7vwqFT4WQMPtlcbNxQXGH38OhPmUn+
 7lgipoF1gPyrWbCmjksIjuOHKa45rrclEe/HibAOAiwmjXFN/9
 wRp2Gdwp0fmxHb0H7HT2l7t+zjVJDDF2W4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2013 at 12:45:58PM +0900, Jingoo Han wrote:
> Use devm_kzalloc() to make cleanup paths more simple.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/pwm/pwm-ab8500.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)

Applied, thanks.

Thierry

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRTDTpAAoJEN0jrNd/PrOhW+oQAJscXxBzmQHJqjf/sJJXLLgj
K08MjFjrh8CIo3wLassctXknoBaL8H8sPWlsYdHlBRv/gWv8aO2hj57v+hfdq6Mi
V8OLYIQIRJiyGwIjjZV7R/fLQWYICQOXDe+Cyx6XfjpPiYVWN0SIgvjDhUzCr2/2
j1GtfqtymC6l72YAlIXIVs4tZdbHwpSgHYVxCRF08rJtel924TQAXuPIlb4mJOif
eswoc3sAzQ+5VBIgGghpsATOz+6CzuaLmaVk0X3RDJSb0lO44HeAwng7VOsTLz2G
l6lf3h+vLRBsP9rMqvVw98ZjrnA6o4ztoC+QHNP/Qq5cOoaV+ipsR5brZ+aH4kaP
hg2TafOLAwHx9POa8lC0h8aKefgVoKgGkSsrqyFAXjKMFhzuoeVvZ++B9WBMk4he
pPwc5PniIj0BO7JnoOSd8ADQvBe9fmexq56dbBmJytoPIneEHRejMjJBehJ5u9G8
nkNcLJm5vruMCrdhXpR5kW/35ZPkYb/PsSiKSWIP5fxwXYzDJvNRp6vzSFlS6ZwX
c09K5ijzD6FlD3BeA3WBcG1VANpjPB91Z20QjRoKlU04VL21/Ov180mKOML7Eon9
O0v/W1KInJ7LAhim3g1YVikL7LBa0naDqzdToT4TRyanW2+bQs8KRRDOaqe9iMGn
RuLuF5q2wqjNkJrYI/h1
=y3lp
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
