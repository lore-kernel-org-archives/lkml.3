Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaHSPYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:24:05 -0400
Received: from ozlabs.org ([103.22.144.67]:40851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaHSPYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:24:02 -0400
Date: Wed, 20 Aug 2014 01:23:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hugh Dickins <hughd@google.com>
Cc: Felipe Balbi <balbi@ti.com>, "Eric W. Biederman" <ebiederman@twitter.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: Lock Directory failure
Message-ID: <20140820012345.7c358fd7@canb.auug.org.au>
In-Reply-To: <alpine.LSU.2.11.1408181350260.1127@eggly.anvils>
References: <20140818163209.GJ9662@saruman.home>
	<alpine.LSU.2.11.1408181350260.1127@eggly.anvils>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FAnhHLziiaUj1r9U_98glok"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FAnhHLziiaUj1r9U_98glok
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Hugh,

On Mon, 18 Aug 2014 13:58:26 -0700 (PDT) Hugh Dickins <hughd@google.com> wr=
ote:
>
> [PATCH next] vfs: initialize m_list to fix crash in mnt_set_mountpoint
>=20
> Fix mnt_set_mountpoint() crash: new_mountpoint() must initialize m_list.
>=20
> Reported-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>

I assume that this is a fix for commit 89f7ca1af15b ("vfs: Keep a list
of mounts on a mount point") that is currently i the vfs tree.  I will
apply this patch as a fix up for the vfs tree in linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/FAnhHLziiaUj1r9U_98glok
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT82wLAAoJEMDTa8Ir7ZwV48gQAI4C10QgUkV9DCI/o2+SidKU
z7vbjpoJr9VodmRdfG+9ZA55xzVeBwp6L7d9U4bWbLpbcIpARppCaPNNgjg1av9S
pwPaTdY7gmaXJBqYKHTex6wsgalc1emmdVvCP0erJZdwdD0SchXh0D9riLF30M4u
kKV9K9oXDFZxMhixxCbffgDt4fnKRpUXc1GBHuvmrfrtFLaW4LzYwSe8Zi4uB2x1
m5JjV5/zVS90u1xrwxJAqMlH4UBBzk7vRNxqMUV4hkHWL0h/ulG9u1+3OwBm/oZ/
PfeDAVdK5UaPKtTzme3zGU4Y64p06Gk8C/pDzzzbCW7uYIkP28bpzsMv0YkvifF6
11U0m9CTHEsLZeOfICH0N3zPlzZ7bTzuTzka9uii6vYQSraoruumAoRNtC9DwbrT
wnPVqlpJmvRnCqNzfBsAYlFcckTDrcyMqe5WvINd4d7409Yd/+a78fY2urzbC0aL
nyoodeXka3suNzieNkbiEEaC/8UBGoNsvBJCcOVST1hL9DLMNAW1N1kfGwB8R2NT
uIHzxR0GbAYV5nJmmN+djhAEfV6ym0VbOjr7OdTyXFgHe621uN/fDavp3tvTAu9m
NVnbcCGHF1xf/6xuE11SQSDfgrhOFoTQqAZtaM/Ob+L1ktn13P5eFToTWxM9wkHR
nF6dxSuq8HSGxhZXjIMg
=o/57
-----END PGP SIGNATURE-----

--Sig_/FAnhHLziiaUj1r9U_98glok--
