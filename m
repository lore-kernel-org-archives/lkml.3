Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3CVAmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:42:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52939 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3CVAmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:42:42 -0400
Date: Fri, 22 Mar 2013 11:42:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Jiri Slaby <jslaby@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-Id: <20130322114233.e4a0262fef21a929191dcc9f@canb.auug.org.au>
In-Reply-To: <20130321234724.GA1734@kroah.com>
References: <5149D1FD.90400@suse.cz>
	<20130320151511.170EC8017A@viridian.itc.virginia.edu>
	<20130321001628.GC27981@kroah.com>
	<20130322095423.799b201fd0f6671e8127c2ac@canb.auug.org.au>
	<20130322102808.5bdd9e5e0d98733e202e49c2@canb.auug.org.au>
	<20130321234724.GA1734@kroah.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_11_42_33_+1100_p/6zCboxek5YevWs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_11_42_33_+1100_p/6zCboxek5YevWs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 21 Mar 2013 16:47:24 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Mar 22, 2013 at 10:28:08AM +1100, Stephen Rothwell wrote:
> >=20
> > Except, of course, commit 27b351c is not in your tty tree :-(
>=20
> Which was causing me lots of confusion :)
>=20
> I've merged it in there now, and reverted it, so all should be good.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Mar_2013_11_42_33_+1100_p/6zCboxek5YevWs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS6j5AAoJEECxmPOUX5FEU2EQAIoD+ziLTJ5/k40hE+JWFZew
ZJJSTgBsnw2URegGKCmim9/lr76yT30Jw6m0S/cW/h1+FIXvAk5PdsaVzHqwMDyA
1VfJEcyida9slXhEyBy+WgrWK3uaztl3/5/bC1K+mIMh3UvdysmvOFlzPG8azz/a
RH4W1+WeXKiD3XK3EzbdFMOfY19JPYFv6kvEXNVj73krBN1CYT6xhIWgOT/yDB4x
jnRwlSbQu3PfpA2+7dGkQbt+iuDZWg63oWzMCYELpP9JYpFTyCGmPNncRg8tgt1s
F51x2AVJPyjrwfymN8csM4ZEvHtFA+oLmuaIYx8A1ZatKDrtUCkeCjJouSmh9EsZ
mwu8M4BKpcE9SCKoY3Bfq44qYK7TLE9EXrzGPZ23aGCxU4PZ3501W7SYk0tHQyvG
KIwNiY5iDE6QXBFcjWVOug0GmEajLYpAn2pH8hRnStLJxAP7Dh6s2KfvJ0ysf+ye
NFWkKiVrUFJRc28Pgj1tWqHR4y9zfLhaDKvmnp5WZJrzG+uwqLowRn19GPLFnAZ5
8AMOOlvzHdl6dKP63pnlGU26JEUX8URY7MyYQHcCy2CsOy/8/KDLYMMW7bEa2Thi
S40HJjAQt7MTDRrM0RCagw+HjzYlZrsL+ShdYgxsXcII6mW56OXGBRT2LYeAksAS
gEclcKnHoAi7OpDJOkvz
=S7Z6
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_11_42_33_+1100_p/6zCboxek5YevWs--
