Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3CVMgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:36:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34569 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3CVMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:36:04 -0400
Date: Fri, 22 Mar 2013 23:35:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [linux-next] Not able to fetch next-20130321
Message-Id: <20130322233540.1c7db7b86afb1a110c2f58e0@canb.auug.org.au>
In-Reply-To: <CAFRkauCd_dL-9muXQz2PV=hBtdfKyzZDqA_5va_Nq37mJcfb5g@mail.gmail.com>
References: <1363877418.4019.1.camel@phoenix>
	<20130322092736.f379b24f5f3e6a6f0642ef4a@canb.auug.org.au>
	<CAFRkauCd_dL-9muXQz2PV=hBtdfKyzZDqA_5va_Nq37mJcfb5g@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_23_35_40_+1100_XpRuyDrtgQJi.LdK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_23_35_40_+1100_XpRuyDrtgQJi.LdK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

On Fri, 22 Mar 2013 16:51:40 +0800 Axel Lin <axel.lin@ingics.com> wrote:
>
> Even with a fresh git clone, it still shows the latest commit is 20130318.
>=20
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next=
.git
>=20
> git log shows the latest commit is:
> commit 0e78c0989334e9c1d578ba25621de14e8441d8b4
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Mar 18 16:10:47 2013 +1100
>=20
>     Add linux-next specific files for 20130318
>=20
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Very weird ... it works for me:

$ git clone --reference linus.git git://git.kernel.org/pub/scm/linux/kernel=
/git/next/linux-next.git ntest
Cloning into 'ntest'...
remote: Counting objects: 192286, done.
remote: Compressing objects: 100% (34238/34238), done.
remote: Total 184570 (delta 165819), reused 166851 (delta 149091)
Receiving objects: 100% (184570/184570), 25.60 MiB | 886 KiB/s, done.
Resolving deltas: 100% (165819/165819), completed with 5985 local objects.
Checking out files: 100% (42561/42561), done.
$ cd ntest
$ git branch -v
* master 2db42b7 Add linux-next specific files for 20130322

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Mar_2013_23_35_40_+1100_XpRuyDrtgQJi.LdK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRTFAcAAoJEECxmPOUX5FE0+gP/1aSix2XuUHj/xqTcLj9EeEa
8fhXXppU9kRFAHlEd5tEus/Usci5Kld/KJxmxccTH8iMWcrmYhk3htG4xadb6XUq
LrDpG+KejSVl31eBGD2Pdfe1Ukbe3yPzRSUkL7dyn3dc8cwFUjORP52ekxX8vKvw
unlJ/EDb49BkZWmIUuro0t11IydXO4oW0E2me7W3BaNQETZD+M4aD0wZKMn6MDFv
JJWEtj13HkLYugCVcgpt4ZNXIs1RaVdR7bulLKMXhuuiw7uJhAl9jxvpqMRYDsKA
QLcR3JLyaX9XNmIOwasW8V/fZtY96Bxqvw6uR8RO2eDRfJ9jXgNFMfmuks9KYKTh
CyIHN+AwH/rirgKSfyWuwYl7dgO8WRv3n7Sg8zvf1Cvqw/KBG+hMYmyN9jKm0mrk
DRwBDsDyGLX9qYFA4BYXf15EcTVK3GipY2EEKzTnaob62+tQpq6yBiS7WFUWakAj
lLx8lMfJDIyAc7qrWqwAN1t7RSrZagw5opDyIGinjuMqb5cGSvWw9+ZU0kW12PVy
HLch8NthSFHkY3UA88ZjLHxbywOftWt3KTmtKvBNyrkJlCP86BF3skGarAcN5UyK
QxJLbUSTg7ZIwx5KUx88cw/m3mLkp6IOfjvfMEOVJ3bDPqEcOq3YF8E1omTmQNd/
BKxbROgRa3qL9EAWmguQ
=wqHZ
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_23_35_40_+1100_XpRuyDrtgQJi.LdK--
