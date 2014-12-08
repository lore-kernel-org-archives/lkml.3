Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaLHC7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 21:59:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33904 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbaLHC7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 21:59:08 -0500
Message-ID: <1418007534.11886.58.camel@decadent.org.uk>
Subject: Re: [ 10/25] x86, espfix: Make it possible to disable 16-bit support
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 08 Dec 2014 02:58:54 +0000
In-Reply-To: <20141206174148.851443989@1wt.eu>
References: <20141206174148.851443989@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jND2xmxBgmdzzb0Ytgno"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jND2xmxBgmdzzb0Ytgno
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-12-06 at 18:41 +0100, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: "H. Peter Anvin" <hpa@zytor.com>
>=20
> commit 34273f41d57ee8d854dcd2a1d754cbb546cb548f upstream.
>=20
> Embedded systems, which may be very memory-size-sensitive, are
> extremely unlikely to ever encounter any 16-bit software, so make it
> a CONFIG_EXPERT option to turn off support for any 16-bit software
> whatsoever.
>=20
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux=
.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> (cherry picked from 3.2 commit 70d87cbbd92a3611655b39003176ee1033796bf7)
> [wt: backport notes for 2.6.32 :
>   - Fixed arch/x86/kernel/ldt.c (no IS_ENABLED on 2.6.32).
>   - No CONFIG_EXPERT condition in 2.6.32.
> /wt]
[...]

It used to be called CONFIG_EMBEDDED, so you could s/EXPERT/EMBEDDED/,
but it doesn't matter much.

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-jND2xmxBgmdzzb0Ytgno
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVIUT8+e/yOyVhhEJAQqq8RAAh8Po8nw2EGrF8sWWJAwLOSXfqe+2a5WB
7QKGFl+2N5tyC+P5jnJ2shswtZdEiIurpgNutitzyPfGuhE9kdf1oXO21R3QN1wj
kqMVP2F6yfB0feOy+TS2uDbxDbooBy9STw4K610E6JF4zrEgOqVWZ5BJNE9tYtJn
K6CVfLw2dSQpCGgCae8I/lZoB6LpwfxExwLxQJgKG1/tgkHTspbPL98wYYdPeho9
u2N8zqy6JeXr+c7xhGx0Mc7XZv0MAxj9OODu0o0EJY3G0SSPw00tDYucxKarm1rM
wpB+q7u4p1IzTQUwsBVeYVQSmwlWYttUb9dbV+JKgPCdMAzG2/II776OpRqpHzvH
3LoC8VsqYFNMRjh2BTpDYVHEPd7zsrzXWlRAiYYCkky67wHex15887mPJYjDlkg5
Tf6piX5RHXpCFUsxubrxivpoi20ZrN4fRCqcUa21rXmLC0VlMWa1sxL2zschTwvS
i85V2wEWW0Z+nkuxwP3dycrjEsrbs9OTPzGRyrcjnqGMygyv6k8PoTced75K8p+8
Fe4aJAi0h+eXxGYhwu9RsIrkYATa7+DINHUntwO0jkzvUScLzMiDA+PvjoNRUNf/
kvuMowopqPJcOKBBhEbdBvY/kX0Fqw+zGKbk5RJJcwONWNg40Im0i4T1uyI0zX3O
x+U1q9MRy0Y=
=ptCI
-----END PGP SIGNATURE-----

--=-jND2xmxBgmdzzb0Ytgno--
