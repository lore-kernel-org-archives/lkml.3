Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab3IIFxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:53:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46173 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IIFxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:53:03 -0400
Date: Mon, 9 Sep 2013 15:52:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] vfs pile 2 (of many)
Message-Id: <20130909155253.839eda76453829b504b21949@canb.auug.org.au>
In-Reply-To: <20130907030411.GZ13318@ZenIV.linux.org.uk>
References: <20130907030411.GZ13318@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Sep_2013_15_52_53_+1000_TL4wljB8tYM0.GS6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Sep_2013_15_52_53_+1000_TL4wljB8tYM0.GS6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Sep 2013 04:04:11 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> 	Mostly Miklos' series this time.  Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

It would be really nice to see this stuff turn up in linux-next before
the merge window opens.  It is now causing pain for Andrew (at least) (or
it will be when he stops whizzing around in cricles :-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Sep_2013_15_52_53_+1000_TL4wljB8tYM0.GS6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLWI6AAoJEECxmPOUX5FEx/MP/ijJUyO9JUYglEuSbz4hEHxF
A8eOtebEyMG7wW1pcSsAdDlc41OOZ81WV8hkTkCdmRiPfMRPJpvk6u7dQuwC7Rz0
ajb+bklPt16JTuiKcv2C4ggesVr9GuJPHk3874BsB52v9ics3PvWg929Q6nU9ztm
0aEC06ODzts+5/JIxszFsBWD6ff9WxhhvhJBc9vGDXZTLaMUZ1H/NH5ucDVMr4F3
9ScQz9D31vzr2teRwPe76ZVmZ0+1hpe5uaJ0pfJoexg/3LJgNMQB/tc6ellTVBO+
4z2E9WP//d/hzRNf3BTJO4UMu+nSjVL6A2Przm3Q2XTT1cbTHbJPhg6xdU7wqSQy
xjWiVDH6ZvJjSr5Nh4qjdVNcQmlHtWDzoSsFROwwWSkGPB18gJ6avM/CrSoH5+JB
0hPTBcWSqLJrblDV+e3i6eYc4BTAn2MO/L0zlMu9mPMaiavRLwy1cl8h7Aki/QhN
lPfUP2gfF6geM4XVZZ1ltgTy6MMFdX5HuOAdo2ZLzHon54Nyyl6pQONmE6R8LQCR
PgDWJ0smPoPGRXkLaMDDnMYg5p3ZWCQT7TJh1YYMhzUN+45oQ167nDV2qUgexXl9
my26I3OpP+CLKMClN/uotwJf3R/Rtmk0Se0w6v9+9gziy6CvmZHf1LqJtWCwWPcr
eFplw9YYze1p7vWzpdMd
=UYxp
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Sep_2013_15_52_53_+1000_TL4wljB8tYM0.GS6--
