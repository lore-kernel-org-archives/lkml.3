Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3AXFzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:55:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35422 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3AXFy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:54:58 -0500
Date: Thu, 24 Jan 2013 16:54:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130124165448.a27de37fb29ecceac235a7e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Jan_2013_16_54_48_+1100_Kx65sv57V8WI0wo5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jan_2013_16_54_48_+1100_Kx65sv57V8WI0wo5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

arch/sparc/mm/init_32.c: In function 'show_mem':
arch/sparc/mm/init_32.c:60:23: error: invalid operands to binary << (have '=
atomic_long_t' and 'int')

Caused by commit "swap: add per-partition lock for swapfile" from the
akpm tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Jan_2013_16_54_48_+1100_Kx65sv57V8WI0wo5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRAMyoAAoJEECxmPOUX5FEaLcQAKGlyPj5NzV5Qn4BImclqg42
DC1dJfQHrLKkOmpB+YNwwVXRDUXpBNMSV+7s2/oOl8WV9mtt2jl+BDH9FPpo/VOg
QHEzmZ2mXLYxKAcQKP8NlkqioeN67xfxDCVjlZ30DqUmAzyBHyfsxsLS3zYKqYgW
Y460rymBy90MvLM6+5ge43D6epWHC8RqrG3ofByv0y6F647AdUWB8PHGJm3/VxpL
2ioG7pZfR3jS540M7awlNgx50sHrm3ciMPWQtLNYzfm/eztLnNca9WhyvNu43FlG
SU+tK6lhvVn+pMM+eVtnRw9Kk0XSC3he1/C/lgM4T+K2taMrjCMd1TJwGDZwOc0Q
D8dBAACviH/9AjdiJTAadkgrMFyF8ZjQuveGxLKSGg98Ho1a+fUORYBnlsnX6dlZ
lOMaw2R+ZF64mE/lqrpyIknqi2mj7+Hcvh/i8Fwd8Oq2ayzxABjU2COPH47tSwx0
r722lSejJCCGRN9KiwdkzpTXqExVE688daDU2VgYAuWn0CeRIZJ+CBWLjbOYiFdb
WohJmYBHaOLizSsundUwpuAk0TLisH+CLbeCOOYBCVsgpH4k4u4XAp8ALjBXRZlD
Avtpde1J6OB0hocZYjKeiBi3z1oQOB6Mj7t9uQk2uWVjdl6EVSWz7bJui5nA68Nr
jPcAoE794jdHxEfDpIlz
=IzGd
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jan_2013_16_54_48_+1100_Kx65sv57V8WI0wo5--
