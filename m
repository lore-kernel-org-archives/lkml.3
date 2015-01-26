Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbbAZMlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:41:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39651 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbbAZMlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:41:47 -0500
Message-ID: <54C63606.30002@ti.com>
Date: Mon, 26 Jan 2015 14:41:42 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAPDSS: hdmi5: remove unneeded check
References: <1421167620-17290-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1421167620-17290-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="83rKs0qH6sFP7O5ktTRcJLWXMwmpmwDhW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--83rKs0qH6sFP7O5ktTRcJLWXMwmpmwDhW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 13/01/15 18:46, Sudip Mukherjee wrote:
> prior to this check we are checking for word_length_16b and if word_len=
gth_16b
> is false then we are returning with -EINVAL.
> So at this point word_length_16b can only be true.

True, but it looks to me the code may be extended in the future.

And if it would be clear that it won't be extended in the future, then
there's more code changes needed to reflect that (the whole
word_length_16b can be removed, etc).

 Tomi



--83rKs0qH6sFP7O5ktTRcJLWXMwmpmwDhW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxjYGAAoJEPo9qoy8lh712nwP/j8/gAztbH+lyD8lx3wXU3vU
3bZmI2N8fg/DPCdr578O+smRcLnOguWiyo0rzRumvktU1okxDZl+OOxKZ0Cwq+Ir
tP8kqdQl78jK/bv/RQ1vvhM5WcLbE5AWAsWLkkC5fW2oSbvdQV3OgVQBXFxww2Gw
t1MLD0k/9omv6O4XTjOT3GQlNo37q15hPYvNsEE95Q/VHpqiSDyY1Qc+Koj2IxA9
PG2/HJwOxcxsOSbjHvcUYc12buy++fETmJHTTGGGsZ5R9R1TegqApRwd2Hu8vBhN
yoOaQBkK0Z9bp+8FPFhYUsRskYJwEtYYYK+YN8qIj+fDa9aCyCL1CqXFuPm6fQ8f
I296BOSmN/j+4SqmXaz9W1ykb/osomdB5PxCfXbJo2fQbMhaM+DByWhyYUbIoUnx
hGBvQfThAS9NOZy4eMVgGG8eSw526BrDpA7NwfFN4uFXLc+mNAevtBbBWyoW9AGX
tIahmCQW++ui04LKVOl1pN+gnm0c8C7cEl2MkDLvKf2SLqnLuAV7wytDd+io6v3b
lTnahU8AJLWpNwZV5IuN6ciRoU2bW1/Lv430Qblhxt/whoutHsOaI3LeQksS9BdI
XCPgCKlLs5qhl65d+42ji+Cbio5ujhR6OZ8T1Z3kDlgR618HLfOW144MzrMm9xDX
v39GAS8tHZFkP6OI7/Q4
=YGRp
-----END PGP SIGNATURE-----

--83rKs0qH6sFP7O5ktTRcJLWXMwmpmwDhW--
