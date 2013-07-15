Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3GOANY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:13:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39753 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3GOANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:13:22 -0400
Date: Mon, 15 Jul 2013 10:13:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: rebase of the drivers-x86 tree
Message-Id: <20130715101306.6d6fc3cb42ce956130606ac2@canb.auug.org.au>
In-Reply-To: <f7e5023f-0e7e-4da1-a91d-5b9f4fd0db21@email.android.com>
References: <20130711100437.4e5198a27a72dcdd3f69200f@canb.auug.org.au>
	<f7e5023f-0e7e-4da1-a91d-5b9f4fd0db21@email.android.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Jul_2013_10_13_06_+1000_57SBNdVsHlhJ_Yjn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jul_2013_10_13_06_+1000_57SBNdVsHlhJ_Yjn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

On Wed, 10 Jul 2013 20:08:39 -0400 Matthew Garrett <mjg59@srcf.ucam.org> wr=
ote:
>
> Because I noticed that one of the patches changed the permissions on a
> file to 755 and rewrote it.=20

That is hardly a reason to rebase your tree.  Just add another commit to
correct the situation.  The tree as it stood would not have affected
anyone's building, running or bisecting.

And why do I now have three versions of your tree?  The one in linux-next
on Friday, the one in linux-next today, and the one you asked Linus to
pull.

I hope you don't have any developers trying to develop stuff based on
your tree :-(

And yes, this is a rhetorical question, just trying to get you to think
about your process.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__15_Jul_2013_10_13_06_+1000_57SBNdVsHlhJ_Yjn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR4z6XAAoJEECxmPOUX5FE6sYP/0SGBV1cZxFQONFrg/FT3cYg
U0+ZaH4rz2Fe/SfDz9a+p6Dn9YViD1XNY5HAnZRkhYsXQjHv8wu6CRnPvwiVmu8Q
wNdWVimqmI2zuxwIa2l8WR+wGidLPpuwhwQHlCZPU7EpYCOsfBh0J3U5pAP5Qp4G
6KulEoZm6Cy17QMihaOHYidV3TtpBNl81efd79txxITS6+jMdkUNjXmXD2+HmqV2
GjUURkm8gryPLewJQM7YAUw9L7v4Kf3GFO51LbuRuT/Q4s67hV+RIb+PB8wZKtES
6i4zzGyzA0o5yzeBpjyqCZ9c3DDe2I5MxajqJe09LotDFofGuVFY7YQfmZOR4DaT
myK/ZJDG69YQZLAPWwP7FDaUI8FNSWiYPe6LXOmTbyGaULj8Xd3ug5LT0kLckytg
duogQIhamdngJv+YPJNcGLC/wuivNYVfd+DxE/qmjmSroGEuqQhamZgmU6uF2wNM
dNBAgbJi45XWO+OYdLzrsHsG0cSU2wcPIrAq+jxL8jRLZwpT4M1boT8O9lOlK4vK
E8viD/dS2Fyd/IAjk3ci3AUpN8KXhJcuKfL6x1VxgzbjRxCTxfeerNcaWzhGpsON
6Q9mbDaRuylugFVa+WZ/yu74gXvjGodMl7HyzDUcieAYsfOfFDwEAKLlmnTwF3Zf
bvSzhVgL47Q7q3Qua+fS
=zl3g
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jul_2013_10_13_06_+1000_57SBNdVsHlhJ_Yjn--
