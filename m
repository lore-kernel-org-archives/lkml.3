Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbaCSVAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:00:22 -0400
Received: from ozlabs.org ([203.10.76.45]:54790 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178AbaCSVAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:00:17 -0400
Date: Thu, 20 Mar 2014 08:00:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: David Miller <davem@davemloft.net>, haiyangz@microsoft.com,
        netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v3] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Message-Id: <20140320080010.77e27d5d7086a57d39f79e6d@canb.auug.org.au>
In-Reply-To: <532A1275.2020208@cogentembedded.com>
References: <1395180922-2776-1-git-send-email-haiyangz@microsoft.com>
	<20140319.164005.1815461875771862691.davem@davemloft.net>
	<532A1275.2020208@cogentembedded.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Mar_2014_08_00_10_+1100_QDRBkewNJOGf8hMP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2014_08_00_10_+1100_QDRBkewNJOGf8hMP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Mar 2014 00:56:05 +0300 Sergei Shtylyov <sergei.shtylyov@cogente=
mbedded.com> wrote:
>
> On 03/19/2014 11:40 PM, David Miller wrote:
>=20
> >> +extern u8 netvsc_hash_key[];
>=20
> > We no longer use extern in header file function declarations.
>=20
>     Wait, this is a variable declaration. :-)

And the need for the extern on variable declarations was one reason I
gave for not removing it from the function declarations (consistency is
good :-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Mar_2014_08_00_10_+1100_QDRBkewNJOGf8hMP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKgVfAAoJEMDTa8Ir7ZwVbuQP/13NLiZY8wm0HgwWS9g5BGG4
hmATXGx9PAB4PATreeLeEORES0BDyrxTGXwv9hgFrPPtxyAJO4VmGQnnbztis4RS
GSeZId3e476jFW3VuzXnok4nWyWIGPtkKRUjS9mYYJ3PfgKcG9s9yMy0SpvWUlwf
WpV8vRWYbRTIv+HCw3buq2T9nFzATLTDh3qhuhqvZ2WQU+Sxs7y/fx4nKrurPEkn
aL8PwHElJEB4g3qdNsFzW2CXQ8O0M+tK3frDY11c7+JdBAUtf8u3S8yU3rZunSKM
WYbmlGPKo2GFKs43Sxf1Kiy54voqNwqp5qDBru6A9PxOFj3SOOxAgaPv542txvZ/
oJuhYaY4d5fY/RpG0ZMAUOaY4fa9FTM9HXHxVuslJ6Dt1rsVIrumUD7eb84m+jCm
GhCWdo9N/ohHZsQMZz/Bv+kxNTSkmNAwAsW0oJmtwe4jixK6VZZoib2M+2wPetDb
ndrR7OlsJ2qHxrnG6QF9o5BsJqMUwwmrkIiCm4zJTS4cGTv19yU/PL68xKA8ZAYt
o60+3uASE4DHMfd7kE/ca3N0MlGV4cP9Aw3CKoGDsn5SINyvWYeWqg5Dq0pDSNtU
cB8B5HPCMTmsvGpf0PFdJWLMNgByPU1xrnsEjaCaVBGnj64wr8UpEDfzzJxkNVV4
0xq0k1V39rV9qPU2xsM6
=khds
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2014_08_00_10_+1100_QDRBkewNJOGf8hMP--
