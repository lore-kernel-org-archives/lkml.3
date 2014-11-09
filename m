Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaKIXza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:55:30 -0500
Received: from ozlabs.org ([103.22.144.67]:42015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaKIXz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:55:28 -0500
Date: Mon, 10 Nov 2014 10:55:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20141110105520.79a01c90@canb.auug.org.au>
In-Reply-To: <20141106112359.GJ26297@ulmo>
References: <20141106193618.461c3ae7@canb.auug.org.au>
	<20141106112359.GJ26297@ulmo>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/votWREneJCcvUWwtDkQ_MHZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/votWREneJCcvUWwtDkQ_MHZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

On Thu, 6 Nov 2014 12:24:00 +0100 Thierry Reding <thierry.reding@gmail.com>=
 wrote:
>
> I fixed this using the attached patch.

I will apply this to linux-next today (unless Andrew beats me to it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/votWREneJCcvUWwtDkQ_MHZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUX/7tAAoJEMDTa8Ir7ZwVRYYQAJItnr9qaCAmwIFCYOdH6nZo
xiwMknY8f8pEXRkLYRdtRzpqq2o8fHpJ69mlfE6DGqHv6tBYMQKud/96UIc5SGgD
GYZRZSX54EumwfPr+DbY7MHwlr0skJNiDrVULBfWYkGir+sQP8kq3jMuptuZPXjO
nJFkHTiqhwPhzZkoBcNqHuXmstztQHWZ8pIM0bPVPXxW62o+Dn7POXAMG6TuFmXD
gGlox4QT55R9GKwnKK93CKpIbiksCzMiptyI970E3v8nBfcgLQAp+4Fp+UpT0x8H
mcaQoTBFFguzX72euwxou4A+YCE1pPS5Utw8gAl63pwLt9yv4TgMXKfcwXMBe5Vs
SS5isAit/bMxeJtNdBr0qfXm7Wp3A8eXFvhH9mWakvOB7a6KMXfA/M1h/oK7mYpH
P1pZqlns/adCg1UVBauWeNVDwJg0gpzBdP3FerYLPTjOmYE2NfnEmtdddUhI0EOb
GuLvMslTEuk+w3NOj+mLiK19ZbLey5Xx/muTYgo1BNMHMIY46fGhRMeiBwnUvVzG
3zGzjXpnaUhFmY+z1WQmSRKijlkjLa5b36iXWRudmV/hVcw3zz3mdQv8t6SZ2Eku
m4DzKi1lc4Ey4gJydawFUFWht7DpuAp9rlMICHG9Ei4zItA6sfCSM5WZZXw1M35y
e38V8Sq+vu1WzH1rLuRa
=V+hn
-----END PGP SIGNATURE-----

--Sig_/votWREneJCcvUWwtDkQ_MHZ--
