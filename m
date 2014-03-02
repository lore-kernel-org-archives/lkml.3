Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaCBKKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 05:10:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:52101 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaCBKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 05:10:15 -0500
Message-ID: <5313037F.2040000@gmx.de>
Date: Sun, 02 Mar 2014 11:10:07 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:gobuPIE7c6zemkInfrLQjmxwD0OHvvE+6s+Rk/VqQM1iBa6znwo
 wI+dPTKOGLYoTccO1ubA0ji2OUzx9ng/8zQjYylfx64jm0SF8PQE7xNsn5x/2Xvuqc57ovr
 UaCN7ck/sflwW7ZGRfHIwetGSx0sVcM4OrcAicerzUHlPxo//b6csOmDU/f1h9+rJcQWd02
 //7CTztdth3nhAzkqOmzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hello Ingo,


the issue I mentioned in [1] and [2] was bisected now few times in a
row to this id :


commit 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce
Merge: 6bfa687 d0e639c
Author: Ingo Molnar <mingo@kernel.org>
Date:   Wed Oct 9 12:36:13 2013 +0200

    Merge tag 'v3.12-rc4' into sched/core

    Merge Linux v3.12-rc4 to fix a conflict and also to refresh the tree
    before applying more scheduler patches.

    Conflicts:
        arch/avr32/include/asm/Kbuild

    Signed-off-by: Ingo Molnar <mingo@kernel.org>


Unfortunately I cannot blame a single commit of the merged branch for
the breakage of my system (till now). But with kernels after the merge
commit I cannot longer start a KVM machine here.

Do you have any idea how I could continue to nail down the problem ?



[1] http://article.gmane.org/gmane.linux.kernel/1657962
[2] http://article.gmane.org/gmane.linux.kernel/1633225


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMTA38ACgkQxOrN3gB26U7AQAD/dE49c4iJVgBDj4zgymDXDkwn
Sp99EjNBHvvMjk5ynC8A/j185mlJ5n3W9EXAZiiIA0QyMAJ08HfZ/wrpx+Ptrh5t
=t34l
-----END PGP SIGNATURE-----
