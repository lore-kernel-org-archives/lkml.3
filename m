Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3ENAH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:07:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45972 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3ENAH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:07:56 -0400
Date: Tue, 14 May 2013 10:07:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: comment on the watchdog tree
Message-Id: <20130514100744.0b7ba62711c972e0847f8e09@canb.auug.org.au>
In-Reply-To: <20130513121742.GZ14155@spo001.leaseweb.com>
References: <20130513094339.b93a7a4ccf73ccb7fff86d03@canb.auug.org.au>
	<20130513121742.GZ14155@spo001.leaseweb.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_May_2013_10_07_44_+1000_C1=nX.n8hHghv6gJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_May_2013_10_07_44_+1000_C1=nX.n8hHghv6gJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

On Mon, 13 May 2013 14:17:42 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
>
> > Since the watchdog tree now consists only of merge commits (relative to
> > v3.10-rc1), you might as well just reset it to v3.10-rc1 and have a nice
> > clean tree to start from.
>=20
> Absolutely correct. I fixed it.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__14_May_2013_10_07_44_+1000_C1=nX.n8hHghv6gJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkYBQAAoJEECxmPOUX5FEcTwP/Am5VBW0VjJUSr4YdppV60Ny
HQ34xcuWUofVYgDA0SexVPcWScYkwYVQ5u9e0/u6n1ZM0PkKJ3NIk+KBfi8PqmNK
pNokhQxF5Wh3lw1P6n5lc61RI3Yl3fol25++zaydN5dWvCi0VMRLoIlONExA/OE1
ZZFEVkvwSyEyj+sITiyU3PJ35c1W3DnvvGInCAbD5hLGcpzExKeMj/Wjppr+iksl
SWf+SjL/4rGDOr+ymwJ0An4IxDTRhbbaoSFYrcw+4RyPePc6N7RvM3bPGhvbq2fH
HFubZnus9xfSz/n6F7mZIgJfQRcO2cfXRK4nwirPWPmLSnrHwvBjiw/eeVj421fN
AbRbSRRBD1W2tymOcM+1nyW+2RgFgS6PxSe+XWCiE8XqWz/DVlxcA5CpE7EZAvZj
7nr9Ac4qUTLQdKSILGPIuobMJsLChc545EFsXpweJkX9Hi6PCde5ujiqUOdnRofX
4L9D+BW4KaRDNG1T68juFSuwTAqsiSr9Xs6yFgD+Fbf8bO1JnwW9AkVhlYvfBu7l
hyRHpvFqltpoVFFkPgZIFWV6nOXt+0qwkKAH9TZ7gkYrDulCYmQk2obYTAdR93KZ
uMHWhzuoZFBR09Y8jhfx3Q76u5MnRvb0s0A72ek4PngBoxcs7sfwT9Z/84fwYkWR
6mT/4cZy0ZdwPgvUL8Wh
=fntt
-----END PGP SIGNATURE-----

--Signature=_Tue__14_May_2013_10_07_44_+1000_C1=nX.n8hHghv6gJ--
