Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLNG55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 01:57:57 -0500
Received: from ozlabs.org ([103.22.144.67]:36878 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbaLNG5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 01:57:55 -0500
Date: Sun, 14 Dec 2014 17:57:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: question about the luto-misc tree
Message-ID: <20141214175747.2e6c506e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/w6AATFtADn6hH_l_/ISlrhw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/w6AATFtADn6hH_l_/ISlrhw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

The luto-misc tree seems to have a whole series of commits in it that
have just bee removed from the rcu tree ...  You really have to be very
careful if you base your work on a tree that is regularly rebased.

I also wonder if the other commits in that tree are destined for
v3.19?  If they are for v3.20, then they should not be in linux-next
until after v3.19-rc1 has been released.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/w6AATFtADn6hH_l_/ISlrhw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjTTwAAoJEMDTa8Ir7ZwV2hgP/RDe30vZNeQxzUK34JgmUIg1
STd0dIxwEcjBRmIp931W59wvreRk5Pn/1LdT1fXHq6M78SyUG7ozhE9k0PTFYqeX
lT29/ZF0tmSdjIOJlHtaZ1OTib01oGURXnk8Wtlv52ocsLXp8rS2T5cfaF4ds0nN
VQXSPfqPHNxripkBvRQMgtyO6D4JTqKbzPVFT6gWVPGfwS4MfKqFYs3RvaJBqRbm
JzZCPd2XHRDzE+vUEqIWZQ6xvxuzlVu353HitO/9NZfABSD05tILcgG+peCXYugy
sH4OrzVsu6Ng87XBASa6toyD8YI0bT0MKmTz5cGDqweFKvfm7pa6G/0OPfwjv13d
86Pwtm9Ik4RbPkrrmFQv5RA8OZRV3OVV8dcvDLIMWq+gtv/8xgHeMNVbx59J+X35
iRvrLtRcOmcZlUtDPn5qKXAPBthpbHOr8+SxsabuezMRg0jFnjvx+X97xECI79CH
ZfKCOAPUcB+0r0svDniquDbVNTwg6M9a7Z4w0hzWHRaqQIdYbgpAB1kNE7hmdU/A
LhhbqljEi40EkqbmrIpt8LVVHD3hJ8/B500XuW2nMlHm1ejdVlfTlwZBUIVHo+Jk
EtYdXDhAl70LzidocTnIFgXQhseHFyP7Nxg6JePXvdwDIkArq+42DDGNJ7JZuFG2
48lpHXZ9lGU+za8/YBzN
=vpIo
-----END PGP SIGNATURE-----

--Sig_/w6AATFtADn6hH_l_/ISlrhw--
