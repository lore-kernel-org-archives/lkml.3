Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaLRQoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:44:32 -0500
Received: from omr2.cc.vt.edu ([198.82.141.100]:39926 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaLRQob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:44:31 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
In-Reply-To: Your message of "Thu, 18 Dec 2014 17:34:56 +0100."
             <201412181734.56353@pali>
From: Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412181208.58969@pali> <21066.1418915331@turing-police.cc.vt.edu>
            <201412181734.56353@pali>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418921049_3517P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 11:44:09 -0500
Message-ID: <5390.1418921049@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418921049_3517P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Dec 2014 17:34:56 +0100, Pali Roh=E1r said:

> Thanks for testing. Anyway I would like to know if your dell
> machine supports i8k_get_fan_nominal_rpm(). Can you test without
> above 4 lines patch?

I'll give that a try this evening..


--==_Exmh_1418921049_3517P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJMEWQdmEQWDXROgAQLW7hAAm3XUYAd8byH6QWSFkcNlVOHS9j8XXHds
7+4hGfWC8dW6t3dUjJ/Ozzq/mOk2SWR3zB4z/Y9Brf0g/XCb3R5p6ztQo0gOizEQ
05AMAcASXUmWT1mW4U5d+juLbrRTWhzBhv/7Se1Y6TiAqTgIjIBTl0EclYiTBStc
j5ecMFKnMjbaGzXVGK5W/UK+fMGjrDIFez9HFFM+WzFCOzL+q7PfvQoQ2eQx2B8P
2FeBwNxVNq2M99J6wXnrwchW+19i42QT87FP9gzt6bhJue53Uo89UCED9xcMgHp5
j220iRbZkRKutXbCJBor0mY4NxWol2ZoLZKKZ8WlBIThnJslracf4datWGzhYZIx
7d1eKCjY4FuMO7FRh4Ryf7aSnGvlQewL7SoP/bShEbB/yiG51UrEqXOzfvehmbk5
ASjvZNGHthdNhasG/fgiaF0ffFeg3EGQA9r9Cgjr/JfDEjkQ/H26NsFgfuXdkO/M
uuZMdtaL8aVQfNxPk5N0lezTdGXX3dcbU816jgFFXGkdenmkE8bHzPUgcSpEFVfJ
zemDRZ0j/Y0F6y5DZjAwJcB/jAGguL4EQYNCpPYRyJbez6D1g757p1hAdxYZsfVK
HFqG7x7NbswZjfkg5Zjt+BjL5V5irgmyj01jYOHHkRYv3sGi7L4N/TbEY7axoVLO
GsWgYQ6JEMU=
=/zU7
-----END PGP SIGNATURE-----

--==_Exmh_1418921049_3517P--
