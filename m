Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaKXAQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:16:42 -0500
Received: from ozlabs.org ([103.22.144.67]:36491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaKXAQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:16:41 -0500
Date: Mon, 24 Nov 2014 11:16:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the sunxi tree with the arm-soc tree
Message-ID: <20141124111634.1498b6c1@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ser9ctsfvOEy9L7mLVkfhNu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ser9ctsfvOEy9L7mLVkfhNu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

Today's linux-next merge of the sunxi tree got a conflict in
arch/arm/boot/dts/sun6i-a31.dtsi between commit 123ccfcc632a ("Revert
merge of sunxi/dt") from the arm-soc tree and commits from the sunxi
tree.

I fixed it up (I just used the version from the sunxi tree) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Ser9ctsfvOEy9L7mLVkfhNu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcnjmAAoJEMDTa8Ir7ZwVMIIP/0UqRPK23D1zCKOUoNvEg/ON
5mnfW+ffFNsPXiqX9cSO8E2VHuTBSNVnO49jXgr7tn5xlN7lH1058LgjqKsB57nW
uNCkVr4/J3SMkDNZQ6r8kZovT4UawZ7kWCbC6qy2waHfs5N+syzp7mwaq2MGnf8G
sdgdjLuQnAyPQLwsw1ZmJEKfrX7AbOm+yMOk0sbM5dco6Q3b9cR0QyuHpFbV9iAi
eMHHk4mRvo7N6GiwzDk3VvGViBEQW7ewqO6nfIbj2sqrFZi8j/l7eAHFTb8L6kv8
HIUQuHSRbG0mmUWIc4H9l6uGoG33N+2Nn/Pmr+plGcBgvN4goCQZNUviEFkdE3be
z0gOjatQj5fcSa4+uu4imJm3eDv5THbnpf0t9ZqD4hKVOHc/jJOo+T1s33J7+IrJ
W0f/eHdRH/6078YehmBxZsuSA2PyP8V7s5zAXbuvi4mxXSFuhBltx+wLPXvXtZAY
d/laRyKW2WgVEjnhJyBYUKeUE290Tz0MAbUxTj8hNumDhYAJcZKA6K7fQ43dzhGQ
2pSCj5fWmlL1C/S7KFNfnX+yvEaVNDC7V7EKlNbsGVOCH0Ei5vctvC2a24F6fpWB
OwgJdIoruv/9v9FhSz4O/4pVyw7dMuW4lUwiKGCZqP+dl/4CvaUgzfkUScZ8Ivgd
QcAM0453cKa0z8pQxPva
=owmk
-----END PGP SIGNATURE-----

--Sig_/Ser9ctsfvOEy9L7mLVkfhNu--
