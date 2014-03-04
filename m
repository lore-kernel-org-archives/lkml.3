Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaCDXN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:13:58 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:59639 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaCDXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:13:56 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
In-Reply-To: Your message of "Wed, 26 Feb 2014 15:31:47 -0800."
             <530E7963.10209@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <530E6F76.1070605@zytor.com> <20140226232859.GA9213@kroah.com> <20140226232954.GA17791@kroah.com>
            <530E7963.10209@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1393974804_2973P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Mar 2014 18:13:24 -0500
Message-ID: <17552.1393974804@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1393974804_2973P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Feb 2014 15:31:47 -0800, "H. Peter Anvin" said:

> Yes... it looks like the 0.4.5-rc1 that shipped in Fedora is indeed out
> of date.  With 0.5.0 I "only" see 8,207 messages, which means that at
> least the linux/err.h issue is gone.

Unfortunately, that's not true, at least with the Fedora Rawhide
version of sparse. From yesterday's build of next-20140403:

[/usr/src/linux-next] sparse --version
0.5.0
[/usr/src/linux-next] grep err.h build.default | sort | uniq -c
   1491 include/linux/err.h:29:23: warning: dereference of noderef expression
      2 include/linux/err.h:29:23: warning: too many warnings
   2493 include/linux/err.h:34:16: warning: dereference of noderef expression
     59 include/linux/err.h:39:17: warning: dereference of noderef expression
     59 include/linux/err.h:39:24: warning: dereference of noderef expression
    124 include/linux/err.h:52:25: warning: dereference of noderef expression
     18 include/linux/err.h:57:20: warning: dereference of noderef expression
     18 include/linux/err.h:58:32: warning: dereference of noderef expression

(Oddly enough, the tarball in the .src.rpm seems to match the one on kernel.org,
and nothing fishy in the .spec file, so I'm confused now...)





--==_Exmh_1393974804_2973P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUxZeFAdmEQWDXROgAQLzvRAAt3Ud81uzhsr9eD+L8Y3ULt6HBDnljFiu
NzJxhVeyEZ6Ygabykz5T6CCPUg6SKmv3qUSpXnQElzx3/9nSE+lHUGJt7wyCV8Kn
fDA8LirA0wvcqGXZZC6Zb9/FVP96Qe2t9IuFAeu7rpbwY9d2ndIB7P9eXaFSNcoa
B5Egv+F03L6Md4BmnsLKmth2wZXpUf/KY6WcnIxUpbffPKZO344YP+e55WIo7yya
BJoaVHdFCvoYhP10oPYXrCKnBIar072ukHPseua9uildu+N/t7bnIJopY9Ws9dfJ
1lBmymyUgdIA6aNen8M3Ykk7YrwXImM7r0KzhU+TlHNpusXbkwANXTIPlWgAAHp2
ZZmIO3hSfH1nTPjlTK/oDWLc2AjzlF8t4o6TETszljnNxY1Ux7C7D7+8SADrZ6Gi
YwpVM91JcQmM3gf6rf8xljCVEnVY2b3jvFeJcpsvTI4aymQs9YvsFkIGqLwAFksi
Wihp3Jh2bUek71hjk5O6j3IvlIO1Xee4uyECUIzetkErdu5taFhJ3CpODoUmNx4Z
zyiNh/Dx19MgLCp/X+nmNlLAvlxvhEbj12JHwiwyaNJTJoHLojBplb/uQ5rmSxP/
LIi9wcQtxBS6uqiK5GPJE0d/0JHCqyS/cOcgQbUJAt/mEghruBo/Dgxp7ZUUGUYy
la1YT6gdUcU=
=j5oG
-----END PGP SIGNATURE-----

--==_Exmh_1393974804_2973P--
