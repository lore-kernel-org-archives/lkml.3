Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LKADy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:03:54 -0500
Received: from ozlabs.org ([203.10.76.45]:38211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3LKADb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:03:31 -0500
Date: Wed, 11 Dec 2013 11:03:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH driver-core-next] sysfs: bail early from
 kernfs_file_mmap() to avoid spurious lockdep warning
Message-Id: <20131211110319.33065ea7642d1fd5775531be@canb.auug.org.au>
In-Reply-To: <20131210145004.GA4610@htj.dyndns.org>
References: <20131209144712.57a50d7ed468ae8a4d57a0bf@canb.auug.org.au>
	<20131209082152.GA26809@kroah.com>
	<20131210145004.GA4610@htj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Dec_2013_11_03_19_+1100_sO5u4vgXIuT7Qx9i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Dec_2013_11_03_19_+1100_sO5u4vgXIuT7Qx9i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 10 Dec 2013 09:50:04 -0500 Tejun Heo <tj@kernel.org> wrote:
>
> Greg, given that there will be more patches in driver-core-next, I
> think it'll be best to pull driver-core-linus into driver-core-next to
> avoid conflicts from the same commit.  You can pull my commit or if
> you pull it yourself, just take all the chunks from driver-core-next
> so that the resulting fs/sysfs/file.c is unchanged compared to
> driver-core-next before pull, and then apply this patch.
>=20
> ------ 8< ------
> From 5cb9f29a28c87cbf62f74ff6bde3d9da2a565b1d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 10 Dec 2013 09:29:17 -0500
>=20
> This is v3.14 fix for the same issue that a8b14744429f ("sysfs: give

I have added the patch as a merge fix patch for the merge of the
driver-core tree today.  I will throw it away if/when Greg applies it.

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__11_Dec_2013_11_03_19_+1100_sO5u4vgXIuT7Qx9i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSp6vMAAoJEMDTa8Ir7ZwVPoMP/1iSkD7vVtUeRxEz/DQJ9NNx
mgMNzzwDUQ658bK9orKq8uRMOYJQDE38r70FZEtpxSxrzzgcpRFKNIFNSc2HO2FS
HV4uhE+oo6DXJolkbl1x7mdkwFOZp0MZe7kji/hj9dtjFRKA9WbEGsJJxNFs38Qj
9eVFE2jF20248crBq7GIcxgW26jswJGVPvGhKZcravNtZ3INF+hHjhHV/irwHBXl
PeibpEpFM8DYkyLxZL38+T+LmaNtkrqG38345XzpIHQqtD9sDYAwdsSK3NvXSNrK
jHePPU2fcu9PTJtb5ZGf9zOwebK8tQH6ciCp8S+SkxPdJRmpw05HeScBNj3raDxT
80TWuWZ5C9/eL9/88GLlO3MVQL0ZRFLEov1/6X8HcA4mjV2NqqbfMulpJ+AVwTY3
//Zkj63raub6XY17TTUOb8PrbKdqgdlz7E6dXW6nw0MMfYkCEKbXNVz9XojzCcJI
vR3fQbP8PTo3OjP/y/QxsUFxQsJ9BKMDCfWzi3QFkwVQmPPpG6ia6bIq7T6iTilf
E0vEXA9KDUPddQBYT/oiXnK8MAZfCN+NUGUHB6r6uPO/44W0cwqwp7IqGD2XzHW3
LRfr3dKcM09jG07CZQb5cjIIPy1V3hlM4X4hcxrWiq0EpsZmMqYbePQr096vPHfu
eAKGE6NEU4xbgGRXKqWg
=BX7C
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Dec_2013_11_03_19_+1100_sO5u4vgXIuT7Qx9i--
