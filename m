Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3J2Vep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:34:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3J2Veo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:34:44 -0400
Date: Wed, 30 Oct 2013 08:34:31 +1100
From: NeilBrown <neilb@suse.de>
To: John Schmidt <johnschmidt4@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mdadm.8.in
Message-ID: <20131030083431.59e5d397@notabene.brown>
In-Reply-To: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
References: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bTXfbOOlh7TGa0UzP0XNdlF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bTXfbOOlh7TGa0UzP0XNdlF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Oct 2013 10:16:18 -0700 John Schmidt <johnschmidt4@gmail.com>
wrote:

> I found a small bug in the documentation of mdadm.  I fixed it in my
> local git clone of git://neil.brown.name/mdadm  Here is the change:
>=20
> git diff mdadm.8.in
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 09aff81..006ae59 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -529,7 +529,7 @@ amount of available space is.
>  .BR \-c ", " \-\-chunk=3D
>  Specify chunk size of kibibytes.  The default when creating an
>  array is 512KB.  To ensure compatibility with earlier versions, the
> -default when Building and array with no persistent metadata is 64KB.
> +default when building an array with no persistent metadata is 64KB.
>  This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
>=20
>  RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
>=20
> Let me know if there are other things I need to do to get this patch subm=
itted.
>=20
> Thank you,
> John Schmidt
> johnschmidt4@gmail.com


applied.  Thanks.

NeilBrown

--Sig_/bTXfbOOlh7TGa0UzP0XNdlF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnAp6Dnsnt1WYoG5AQKCGxAAts6eN6GA0+BIPOH29G/xYsa1HUJDkCWH
EjVSKP5SFxq/CfSkvTgoxfQFJj2d/hNAAt2ZLcYdJvtAYMXnAMVervH35ZftSjpY
6vqivRAYVZnd/R0VdYZjYFvsRA5aJ+RXiHKsI5//qpJpGdj0M4yoh4Sqnv9hmVUa
i/y9XipP31mVq0LD5HAuHfy99Ltjk3Fj0LFQ7xmLjC5iqL/x5pseIFoa6i8BEoIh
mScMTdxNKANEdySlmjEQXvNay2IM9XHeMPFoopYpTDUvcoadDZq52wFf6FBxz0X8
K2/utNMwJpQpnpNYNZ8nuTU5On0meI5woEeDj0zWcMLbNg2G5jiqNjKQ29u5dtfr
eUdxt1qGcMpPPlh4kaqD4ZlL5J/N0XE7mXCDBMwRlbMI9Aa9RK02rmyGJGX+aKiw
ZmHee9IT0o5zZDcn6wwi2CnoeaSgyEatsPLlTmhbF3v0s3Hzih0IKe8PzTExshhc
52xOlrpEI9WeXw4FqpqqpudkRGX4O+mNEwG+cp+dT+6QUXVg+Xn5ME7DfkSezDde
UINm7JxsF0p2wRd3iZtrSqwB7oK+eoOe5RcdgwL2hxbC9dZmTFVYRT57ZnhXDEx5
IsSxehxD6oCpShKvRBASyLbAh1UGxwl7jg7mJ9S2M25VRmn2L0l2VM9DX959gF8g
wNM7OKNdhcY=
=52eb
-----END PGP SIGNATURE-----

--Sig_/bTXfbOOlh7TGa0UzP0XNdlF--
