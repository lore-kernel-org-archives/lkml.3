Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbaGQXWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:22:12 -0400
Received: from ozlabs.org ([103.22.144.67]:50055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071AbaGQXWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:22:11 -0400
Date: Fri, 18 Jul 2014 09:22:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        mimi.e.zohar@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings and asymmetric keys patches for 3.17
Message-ID: <20140718092203.3bab9fba@canb.auug.org.au>
In-Reply-To: <23717.1405636445@warthog.procyon.org.uk>
References: <23717.1405636445@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ddXQZJrWZ_8/a.dviFsEnuE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ddXQZJrWZ_8/a.dviFsEnuE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 17 Jul 2014 23:34:05 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> I have a number of sets of patches for you to pull.  I've git-merged them
> together into a single branch (keys-next) as there are some conflicts and
> tagged the end.
>=20
> The component subsets are:
>=20
>  (1) Tag keys-preparse-1-20140707
>=20
>      A set of patches that mostly convert extant key types to perform
>      preparsing to make it possible to determine the amount of quota in
>      advance.
>=20
>      I haven't fixed the encrypted and trusted keys as yet as they incorr=
ectly
>      use the ->update() op, but I'd like to get the changes I have done o=
ut
>      the door.

I hate to be a pest, but this whole branch has only your signed off by
and no indication that any of it has been reviewed/tested by anyone
else ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ddXQZJrWZ_8/a.dviFsEnuE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyFqgAAoJEMDTa8Ir7ZwVI7cP/2LMgnN/CSuh0BXdWvb+qOO5
INZKsrOO7lDlp8XrrsGo8gWtc4KbwWWwBq5oOVSrWTVi/scMA2WIyknBEKA5oR8P
pGoREZ3Zh2/l2pc8zfmE4Uq14Ra4UgOXJiZQCKtO4ZCIoVRDWiN/T8+xIJ02F/LY
qheB4rZOeMIjmt/Rl2ld7dO3Mu1aoidLg91bOWSp2v1dpY8WLR8eX3C5/up/DYPV
bPg4qWoKwtxGjVYAbwLo0LSuLTLmA2A8RHPIdOhmKU2qbR3zKn39WfCWoqWbsT+e
VIGOyBjGVK/wGwkrLpDh+ihWSVRRhXFbRWmrVjPErMGNmVgcu+Zwj+bwMf3EM7qU
JHAhj0xpIAsFDgniUJHYvIJWeiKiC/oJx+/YTUayXFDmg6pPLjGCdglFZaCykBeh
k1oKB2eRYrSguz6qhuSJJzHS2eq0FQUKn+xbDsEC3aB/cSzU5FKzS8o77Xl/vTTQ
Nns9o7RraYVTTP0SNqVylUxg9FW0uWCreK3gYNAX0PVS1dpD7OyGFV1CARrMIqKA
c81wRwlZ3I6gBq+YU9Q1n2VtM1j8Dvdi89vxgyDwOUQeZLogVKe8cCK/pXSQXVKN
1R0yhJMfrxzcSObhdf3KCWMMTev5wYeMiEQEz8vFT56IcHrs/inni5/0spBv6J+5
kgTcIPPNJowvpanYZuOj
=dzhD
-----END PGP SIGNATURE-----

--Sig_/ddXQZJrWZ_8/a.dviFsEnuE--
