Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3BGGvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:51:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36535 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3BGGvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:51:40 -0500
Date: Thu, 7 Feb 2013 17:51:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the kvm
 tree
Message-Id: <20130207175130.ae5a558e5f498a24e0727374@canb.auug.org.au>
In-Reply-To: <20130206222357.02d049e6.akpm@linux-foundation.org>
References: <20130207170319.5b5c471398b134c676f9dc6c@canb.auug.org.au>
	<20130206222357.02d049e6.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_17_51_30_+1100_AUL0eypAqK3r4FQB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_17_51_30_+1100_AUL0eypAqK3r4FQB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 6 Feb 2013 22:23:57 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> hm, not sure what you meant by "bad" but that patch went and took the
> nice fits-in-80-cols kvm code and mucked it all up.  Shall unmuck
> tomorrow.

"bad" in the sense that there was lots of white space changes to lines
not otherwise touched by the patch and those white space changes
introduced extra levels of tabs (so the indentation was incorrect) and
merged some lines.  I unmucked some of it, but got bored :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Feb_2013_17_51_30_+1100_AUL0eypAqK3r4FQB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRE07yAAoJEECxmPOUX5FEaagQAKO14h6IdUxZJ7xh/6jjn+YK
pvWbeHMSoHqxnnBZc9sd12HuY+ySBSlWH5lVaIEG4PUDn4VqFxgWfzKAAL4kR6aQ
bR3Sn5zhB+w6XX4ejy2Rn5JFZDoNI1N7jIAGEc6dYhNGA3WhPIsgbuaDkU7/MY/N
gb4YaxPy7/hDF5rdLsSA4TnX3xzpk9xz0zsEx8wePABNG5AnIDS9qulSYT/j3b2y
a0BAWVoqXm+dYM0qu5wS2QDIMzjldS/U5W068RS0wBtdSJlooteEhvNRT9m+wxlJ
VQ5ss4x78slF9RPPPPyV4xEtKY/eowchARuW0uA1+LKggIpL90XQ7sUEniXGAfje
oMURdkScsZ6dgwg4F7Ys6UR08pOxcczgGLFCUmBQu1Rb8ew0uh0yKbbw+ZFIapR7
rfIwUdk/44pMwUQI9Qpn2XiNPyekWJTvo0cIiEyt83lEr0FyfKYbfvJFqF9uyZA3
64XKmuGlBLM0Qdt0Ust7ec11NkK1r0bfrzg3vJhDFRMxY75AUBNaibcdxEa56ATe
D38cqI/6uqhA+5WHTxl48oivmyDCxl2406593v7XhUDNLBf1M6639snjjDitBK6N
zHCxFBdrgCPQfvqSNRRoNTjFt3i6aSn/8iOBD+nu+8IItcXeU/8zEKLHa/NpgjkA
V0TmSM5tPWZ8uUz33xRG
=Fl2p
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_17_51_30_+1100_AUL0eypAqK3r4FQB--
