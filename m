Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbaLDX3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:29:12 -0500
Received: from ozlabs.org ([103.22.144.67]:58146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbaLDX3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:29:11 -0500
Date: Fri, 5 Dec 2014 10:29:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-next@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: Please add
 git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git
 linux-next
Message-ID: <20141205102903.156731eb@canb.auug.org.au>
In-Reply-To: <54802B9F.1090303@de.ibm.com>
References: <54802B9F.1090303@de.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5GKvpvfkflk8siGS6BiyZpQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5GKvpvfkflk8siGS6BiyZpQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christian,

On Thu, 04 Dec 2014 10:38:39 +0100 Christian Borntraeger <borntraeger@de.ib=
m.com> wrote:
>
> can you add=20
> git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git linux=
-next
> to linux-next?
> It contains changes to ACCESS_ONCE and it would be good to have this cros=
s tested on several platforms.
> Thanks

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/5GKvpvfkflk8siGS6BiyZpQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgO5EAAoJEMDTa8Ir7ZwVrrAP/0hizD8x9mVN2X65/efKmat8
rvlSH4OwC+lEZWXqwiALHMQTYAktweCoU1UxZSC8Mj4+0unkJXH5WybOKHTvoQiZ
vwhJ8VO1CAPHVopG7eqC4aL8blhYCCDxvtbBuNjdh8nsxIgcti5T1PQA2OwIBg+B
lSZhNGFWqpdY5cJyxB4LiRzaM2g3q80oMZaBUjy9SwaaxvaINh4eQS0tdnrQZ4on
iu4Qj5tfaK+hBXgC9luNN9iNpcU4zEhabc5EobHHz5zMIH1Qo32WZKifQAFQwTbl
fkiEXw0HvprnlI39iCkNG/CzXEBzaaPhpmBeJF10spRcwRKyIQR4MHafl/ylj8PH
7ksDl92N/E/Hxy4W9zJ1UpOUSarDCN0xu/tIPedAP9Tuc/31Unv8MgLV2wFFf4z2
Bir+wkNdYacKgxm6EWEya4NPXeOoV7yNc7hXgukh9fUFtJxKZJl/N9LmVNnx5oUP
drtw4HSeLGkjVlrz9+kAJRf8UQLw/hXSbabRxZTPvvZRI49xzt5NPJM0fV4ML8Pp
JwOEeBxrZv33gSYRBzhulWfjixuY/dsrah3+MbVhDQCKOtXc5EAfqPqzK8Glroml
fcbM+AuUdRV1zCeN8tDxtlg1HIbtHcApUlrEzvq7KG2gUcjEqedVrtHd46v6WRS8
TMil9x2MN1EX79/PVpby
=lKaW
-----END PGP SIGNATURE-----

--Sig_/5GKvpvfkflk8siGS6BiyZpQ--
