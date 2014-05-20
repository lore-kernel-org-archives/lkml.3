Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaETShu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:37:50 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33562 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaETShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:37:48 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-doc@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
Subject: Re: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
In-Reply-To: Your message of "Tue, 20 May 2014 20:10:28 +0200."
             <201405202010.28868@pali>
From: Valdis.Kletnieks@vt.edu
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com> <201405201056.47726@pali> <20424.1400608961@turing-police.cc.vt.edu>
            <201405202010.28868@pali>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400610978_1987P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 May 2014 14:36:18 -0400
Message-ID: <22163.1400610978@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400610978_1987P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 20 May 2014 20:10:28 +0200, Pali Roh=E1r said:

> > Hmm.. what tree are you building against?  I wonder if your
> > checkpatch is a different version than mine (next-20140519).
>=20
> I'm using up-to-date linus tree, git rev
> 60b5f90d0fac7585f1a43ccdad06787b97eda0ab

Ah, OK.  Linux-next tree has a bunch of changes to checkpatch.pl that
will probably go into the Linus tree during the next merge window, and
several of them address the =22blank line after declarations=22 warning -=
 they
roughly tripled the number of checks made for that case....

--==_Exmh_1400610978_1987P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3ugoQdmEQWDXROgAQJJ5hAAvpMTr8zqfj9gIeG+S4plRv97MbCx3xDS
c58vRyZJJCRmyY4r8e1dUYkd/OPdzUkMtirUUNMh/TfpmHOxGBlPNhzlxaZYhHVa
/ODMhtHdhY0X/SGxdTfdQTQtcmUQHKD/WK3GnonQnXYysctYq8XINV+xXGSgN0qV
PnAA+noGXjBwVd/LNTht8WxHPaEdSezZqB7sCagH6ljpADzcFJxwoakvGr9UWyG+
wf6aaMRQEsT/8dAeF1M6S4CydJqNhIBDW9T37gxiGpYukQW2/5BL5OZ1zhvQhxkp
WJVpcw97QKqXrF5PkXLvTvNhfS/Ddx3s7psTHXg9u6Cn7jYZf3UUJ3x3Sqyhd5tU
uiTHMlRL5xgKmhq6p6uoXMegjO7/1e2InqgAyQmaGP7Ge+bzi5QvJbcvkJTZ4jpA
aWZn/KpsmMUJbBvv2d94gNj1xAd82FegZjPTJFmubTU9EDb9DTDizzBoSbEixUBj
i1ZNzf8MdqXOC/l1M70Np4x5+VYHknpEsQJDqJ9gtRAsDVWjrTg+rnkbcVUH6m+0
XKDDn650yhPlX30uwDGR8sLWquQU9A+0DKXfLAWuTg0U0+dUGO0pzZeVa8svSwmM
UY7PJu6P1T4gupdm/uVR7vmAv3E3331YfxIWfxhGiylFOxSYdMsKOTqfwImxW8Dw
tfh3TuhXnsI=
=oPgh
-----END PGP SIGNATURE-----

--==_Exmh_1400610978_1987P--
