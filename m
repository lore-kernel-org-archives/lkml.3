Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaFYWMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:12:46 -0400
Received: from ozlabs.org ([103.22.144.67]:54636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbaFYWMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:12:44 -0400
Date: Thu, 26 Jun 2014 08:12:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <james.l.morris@oracle.com>
Cc: Paul Moore <paul@paul-moore.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140626081232.52cb51da@canb.auug.org.au>
In-Reply-To: <53AAA9BF.4090205@oracle.com>
References: <20140618084046.1bce12cc@canb.auug.org.au>
	<20140620085931.6427678d@canb.auug.org.au>
	<1474416.aEfMv8Ny53@sifl>
	<32647147.KmAPzBrbMT@sifl>
	<20140625095928.3161ebe1@canb.auug.org.au>
	<53AAA9BF.4090205@oracle.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_o1oOzxuQ.AewR_x/1+R1Sl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_o1oOzxuQ.AewR_x/1+R1Sl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, 25 Jun 2014 20:51:43 +1000 James Morris <james.l.morris@oracle.com>=
 wrote:
>
> I haven't pulled in Paul's tree, I merged with the latest Linus release.

Ummm, yesterday your security tree
(git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git#n=
ext)
moved from commit 2fd4e6698f08 ("Merge branch 'smack-for-3.16' of
git://git.gitorious.org/smack-next/kernel into next") (which is
included in v3.16-rc1) to commit f01387d26938 ("Merge commit 'v3.15'
into next").  The commit between those 2 commits is 92953ff38ba5
("Merge branch 'next' of git://git.infradead.org/users/pcmoore/selinux
into next").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/_o1oOzxuQ.AewR_x/1+R1Sl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTq0laAAoJEMDTa8Ir7ZwVLGoP/j/6BjC80ssWq5j+IoTTz7fE
AT58DW3/9NDzxaF9+fnTx97JvHjp9KCCyuGr08QLiAHKRLv3hbkac3iz5TJ5uMPj
reyqegEI7zxK+T1pxhOqwKDjpu13WmoxZ5N++11jiLmVWVYHaci4Wfjjbl7WDSjQ
atfApznpgqmaGPvqKMB4VYtQtkbnodsS31YwQtmTwbTeGY2TOIHfHk1CsreAJIYx
5HUFVsYYh9GxbST8+hOe4Jj+Mq85JbcHk/5x5/DAuM0w7lLqiYCnjL/WD1Akp7e2
QO3LOaKLjvLsgYAp9bziXv3pPEkEyci0gnvcTqtrNjPeaV0e/kWTQOCI+B1ixBta
ovZpteplgQiy79jhZMuq9ciZ9o0mYuUtsjz+jGDfwPruglFN5LXXuMONgWgN45BK
Xr4IN0OMnQ3/ylqoQ1aCSE6imoTYaT4IzYV/Zg+9q0qX21FZkSuVht8JEw5g+tu6
J8wHe6br+/Y0qi+sbVDgUNnxlNaavi23nWO/g8/ooutO4X/gwddyFfz+fKaRp2TW
kba35djcODZklNbL/VMC0f5srlwa7FtYuaXuivIGGqdSGKcqu5wSF5EyQ4tWjHb2
aseOts+ngLhQ7FNFa6zH71iisyAZzUHXx3Ug9N3oSt90agmOzrLxUXOLX6rrdw/A
6oWASC/gKH50Sv/qD/CB
=3DgB
-----END PGP SIGNATURE-----

--Sig_/_o1oOzxuQ.AewR_x/1+R1Sl--
