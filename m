Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab3BHKzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:55:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45742 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788Ab3BHKy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:54:59 -0500
Date: Fri, 8 Feb 2013 21:54:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] f2fs fixes for v3.8-rc7
Message-Id: <20130208215447.afa1c65ff6056e844e650ad8@canb.auug.org.au>
In-Reply-To: <20130208080148.GG4503@ZenIV.linux.org.uk>
References: <1360196464.26950.65.camel@kjgkr>
	<CA+55aFzygotc-rGOBwHmdXU6KrpCE7srqWYs6j-iP5c5Ef3UnA@mail.gmail.com>
	<20130208031021.GF4503@ZenIV.linux.org.uk>
	<1360297231.8037.8.camel@kjgkr>
	<20130208080148.GG4503@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_21_54_47_+1100_XbWZDJqLol/EVrGr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_21_54_47_+1100_XbWZDJqLol/EVrGr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 8 Feb 2013 08:01:48 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Fri, Feb 08, 2013 at 01:20:31PM +0900, Jaegeuk Kim wrote:
>=20
> > Could you send the patches to me?
> > I'll merge them in my tree and submit them in the next merge window.
> > Is it OK?
>=20
> Feel free to fetch/cherry-pick or simply pull from
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git f2fs
>=20
> - that branchlet grows directly off the mainline and it's not going to
> be rebased...

Please pull/merge it directly, do not cherry-pick the patches.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Feb_2013_21_54_47_+1100_XbWZDJqLol/EVrGr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFNl3AAoJEECxmPOUX5FE49MP/3f89ZZbzy339i1hVqW2k/ph
i82uYtyOpDL0K36ReZfu8DwPo/d4ADkCsbrYdz16A5+D74R9IzD4woNu4MRLidBC
tuMihukHK9NkQ1kZJLFXxzxc4ngcUuRl8Ka23RJz0qSV1JJzBNEDhBfnNn+RPetk
i/31YQzIbmExt9T74NLZVmx2DGVwo7sSCwrqpovn9dFqePXf6EXYkQlpTWYAjqQ2
AwM+1NtLoznRguGfkopHJrfah2E4/Nhgf2gZQDx9XXNd5ogqMJOCZYXJUWpSLtQ0
fjIKdGuTq+PIzs+Z4y8eq14g5zQCcRy+YL6XcXiBXxoQlwD8k0hHXoVbTIsd56Sc
cQXQ4XGo7j6Gd1L73x+aFmJyTT5ZiOoS3rYhPY/6D87vgumR9/QV38CmfT4StOUw
+ohBWHBWStHnl8Cj3xa4FtA4FVnjxVVevdnzoLQRJoOZ3bcZjQTMfzMBef/uDwa5
/ozV1pFOFJ/LQz8I7fB7cG3w11OX5E0u5PivaFbJc25JNm2M2dtFlO4Ks5HWQFMH
KcBKM1fm76wHGvtowBp2xda2sRz1V5+M27bHnBKz1X0ESZjD1x2trOwJWZTkfMtz
LOVrzuXB7PCYHTnmpqsF/sAX6AaW6dQy4Uk8JtY32+8XqVEku65vokZnarruOveF
2+mD4HWxbukzsN4OqZ7i
=3r1G
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_21_54_47_+1100_XbWZDJqLol/EVrGr--
