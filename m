Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3CUBsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:48:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab3CUBsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:48:05 -0400
Message-ID: <1363830478.31336.84.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [stable request] TTY: do not reset master's packet mode
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 21 Mar 2013 01:47:58 +0000
In-Reply-To: <5141AE1F.40308@suse.cz>
References: <5141AE1F.40308@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Go2CF9Wc5D1Ii9VZmmAG"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:5944:e226:2c7e:1b17
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Go2CF9Wc5D1Ii9VZmmAG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-14 at 12:01 +0100, Jiri Slaby wrote:
> Hi,
>=20
> please include the patch below to all maintained stable trees.
>=20
> commit b81273a132177edd806476b953f6afeb17b786d5
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Tue Jan 15 23:26:22 2013 +0100
>=20
>     TTY: do not reset master's packet mode

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-Go2CF9Wc5D1Ii9VZmmAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUpmzue/yOyVhhEJAQpcZw/9Gwkzn6cs8pRDyICzPyj0ACpSZLM7sN5d
Wsgw/CHUoDY3rReHFXW2wosWkSXUCC9Zzrj6aBupezvsVuJjnju6JSohILqjCc1T
/kvVxM4rk5GBpuzsDYUwQc/XjORbd4lCAilF+SGN0JeshBsiQMsPhNm7f7VtFWmX
gbhhALPItyuuo7t+gU23bDICcw0Q495Kr+tkmi2x09t66+2OPnneyDHcvYGiVyhO
EaUpxR/zrx5aogEYwA6XduwHAEXRJE43z/sM2K4Y3+Zg+d96vvcPWw7KCmrQ2J+N
v22jOGG7kkkOmquZ4E/YEhFEdBxoSFopHeKc/au5DZZxqDBVTsefgbyXkNOKbGGJ
MsHVwbvai8tCOUzv/oD7ywpQn+19Wq2+yQGPBK+1xaFYWAmdLj9RfLzV3JeswCq/
izn12Kw1Hd+7Ddgc5gbBNJjG1hwFq/ECEpLfC+yw+2rYCyDDcEbyGsqUrBbc8siv
vropUhTltapq/a+3dYi4OIhRuLpFhRZ/h9XCeJbpvCBq9z5ju2zESMN4evWmXE1N
18tS5UajGVZXprITz8/XZlCNpGRUFFywp6s4aZjzXnFqgQr295wkrGy+z0GkxIYU
zECjNAI+D46k2+bJPqA8q0TtcYHT97hVTu2iBm1Ll08+nj574VA+NIlsc/XMxJVs
yfH0X3f+M/0=
=kmkZ
-----END PGP SIGNATURE-----

--=-Go2CF9Wc5D1Ii9VZmmAG--
