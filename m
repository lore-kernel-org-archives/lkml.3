Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3LQFdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:33:09 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63709 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3LQFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:33:07 -0500
Message-ID: <52AFE107.4040705@gmail.com>
Date: Mon, 16 Dec 2013 21:28:39 -0800
From: Connor Behan <connor.behan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Frederik Himpe <fhimpe@telenet.be>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer
 returned: -19
References: <1386969579.3914.13.camel@piranha.localdomain> <20131214092443.622b069d@samsung.com> <52ACE809.1000406@gmail.com> <CAGoCfiwxGU-j14oGDfvoYTA5WZUkQdM_3=80gfpWUjXVNN_nng@mail.gmail.com>
In-Reply-To: <CAGoCfiwxGU-j14oGDfvoYTA5WZUkQdM_3=80gfpWUjXVNN_nng@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DltcxB3loXq9jsvH6c3K1Bg9Tln8WUMOn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DltcxB3loXq9jsvH6c3K1Bg9Tln8WUMOn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks for the detailed answer. I have tried your patch and updated the
wiki page. Would a 950 or 950Q be safer to buy next time?

On 14/12/13 05:17 PM, Devin Heitmueller wrote:
> I had a patch kicking around which fixed part of the issue, but it
> didn't completely work because of the lgdt3305 having AGC enabled at
> chip powerup (which interferes with analog tuning on the shared
> tuner), and the internal v4l-dvb APIs don't provide any easy way to
> reset the AGC from the analog side of the device.=20

By this do you mean that the functions exist but they aren't part of the
public API? Maybe this problem can be addressed if there is ever "v4l3"
or some other reason to break compatibility.


--DltcxB3loXq9jsvH6c3K1Bg9Tln8WUMOn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSr+ESAAoJENU6BEW0eg2r3ucH/Rr/AwVYH+tfrbnbZbQXNH9O
0fxOP3tie0J5GE5Zp+D3BnPA/RqhYmbhjqfsTNfjnHPWcidtw8SSLKgRZwGpiz5B
1FMP49zyIMRqgUA9VbHbGtRGKjudCQqKeGRRRWb4k8zJzYZbPwQ4C0vf1HXGXNq6
3GwrgPTicV21WzAxmPLBLuPhEjD8J89VTtCHGcgK2QEOxHLRqbgvx06xFev/KB+r
/gfm1iX5rKg8aWN8DgliFw5KXwYfceWTwKt4A31EsEIT3FIk23EnqFwq9isxOiTX
xvuYBgZSycq38w4+KCiZtfJm5KecHSTa/iGtDlrJAXKGtcaj9tAweCczAL56WO0=
=Mv/V
-----END PGP SIGNATURE-----

--DltcxB3loXq9jsvH6c3K1Bg9Tln8WUMOn--
