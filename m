Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3BARlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:41:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219Ab3BARlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:41:16 -0500
Message-ID: <1359740457.31386.74.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 185/222] tcp: fix MSG_SENDPAGE_NOTLAST logic
From: Ben Hutchings <ben@decadent.org.uk>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Eric Dumazet <edumazet@google.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 01 Feb 2013 18:40:57 +0100
In-Reply-To: <1358351822-7675-186-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
	 <1358351822-7675-186-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xz4yynEbRf8xZTfItvm9"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 109.129.208.115
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xz4yynEbRf8xZTfItvm9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-16 at 13:56 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.3 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Eric Dumazet <edumazet@google.com>
>=20
> commit ae62ca7b03217be5e74759dc6d7698c95df498b3 upstream.
>=20
> commit 35f9c09fe9c72e (tcp: tcp_sendpages() should call tcp_push() once)
> added an internal flag : MSG_SENDPAGE_NOTLAST meant to be set on all
> frags but the last one for a splice() call.
[...]

David, I think this is needed for 3.0 and 3.2 as well since
35f9c09fe9c72e was backported to them.  You previously included it in
updates for 3.4 and 3.7.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-xz4yynEbRf8xZTfItvm9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQv+Kee/yOyVhhEJAQpUCQ/+IDhrYHax7tCN5u8gFhmpWSzAaSnVnRct
oNoUbWkimtFr8n1fI4a/MOsxAcodi/2xYxZICVqoWn4nw6RQA4cWEV+AiDi8JE9J
zs1q9NNhwDs1ufSGAAS9CajRI2ZSMFXHY8IhEZgZwaaXFp146NTEO1/p8aJbIrUs
VDWAiX2XAL3UqPqJE1iF93nSjyT4FJVngYpHi47x5fgKSMCNsVd+HjuAbcumkFZS
6pvGMxWfNjbce3oucDZ+3p934mGPxXEtt/arl1ETszyYqV/8yi4PqLNSihrYAKSq
+r34eYgJAd/DFB/kz1bZBuXl3J1P5JZ+AsTXmKPgI5wQn0Wa967x9JpxpmOXIUC0
yFjRm67aPZ6RUOZK4CIiUTHlyLfPseBbnlPIOTYaf5xg+9COl3cHksIoNgL1tGWB
BFlIQAhNdRu4v6Ran0pcFAJL6hrWpK3eERsMlsece/D0D5CLnz7RTF/w5eHmBu91
/8WsmL0Lxt6hworDLt+WPT9rfmtIedm0ebEBDJCjCT6RcO2W3JZcQfAyKB56dAGw
tN4TWEumofWzryplRKGUyBEGBcbSkGVKoJzBVHcVL7lZfjyEiocHkXit3+58dI1W
k9Vj/eFwzlCuHsm1eqOULgC6fU6b2hXLigrxu4bzZOo5QiB2sRavMHdgVH/r9JeO
7hgRHxUDb38=
=/vVA
-----END PGP SIGNATURE-----

--=-xz4yynEbRf8xZTfItvm9--
