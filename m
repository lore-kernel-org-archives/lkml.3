Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbbAYVg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:36:58 -0500
Received: from omr2.cc.vt.edu ([198.82.141.100]:37891 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbbAYVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:36:56 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2015-01-22-15-04: qemu failure due to 'mm: memcontrol: remove unnecessary soft limit tree node test'
In-Reply-To: Your message of "Sat, 24 Jan 2015 02:16:23 -0500."
             <20150124071623.GA17705@phnom.home.cmpxchg.org>
From: Valdis.Kletnieks@vt.edu
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org> <20150123050802.GB22751@roeck-us.net> <20150123141817.GA22926@phnom.home.cmpxchg.org> <alpine.DEB.2.11.1501231419420.11767@gentwo.org> <54C2B01D.4070303@roeck-us.net> <alpine.DEB.2.11.1501231508020.7871@gentwo.org>
            <20150124071623.GA17705@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1422221788_1948P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 25 Jan 2015 16:36:28 -0500
Message-ID: <109548.1422221788@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1422221788_1948P
Content-Type: text/plain; charset=us-ascii

On Sat, 24 Jan 2015 02:16:23 -0500, Johannes Weiner said:

> I would generally agree, but this code, which implements a userspace
> interface, is already grotesquely inefficient and heavyhanded.  It's
> also superseded in the next release, so we can just keep this simple
> at this point.

Wait, what?  Userspace interface that's superceded in the next release?

I *hope* this was intended as "Yes,it's ugly in v4 of the patch, v5 is
a lot cleaner..."

--==_Exmh_1422221788_1948P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVMVh3AdmEQWDXROgAQK4QA//U6I3P9Vgzh6/W+tJaeSg4+BCFAJsyhUM
caCo+oiRsuhTNxreAEXmTi26Gx1HvvtJ3A/LbBUwXEWhlcrK2xcp0xUlg7sUT+kA
ufCh5qs5NLTbl1hWRb2lfC3ksqhChJo2HKnkWJHDAUzMITXXZz+9paJikNtvlMt9
OnGMHI5EGmm4VSwXoMpwz94mzXs/grL4EC61Y2pPgpbU9HaGyJ5dfbGxZ7qBdnrN
nrwyP4rpyxqLapyoq4Kd5k8ck/cdJCbnqPpR6cy0FQHdbBDQv0L7O4JtdPeuUm4p
VO9xayBSqnWl1zUa7VladqgGQdsBdJ5lYdrC9mHPntUm8G2cyAlMsWAm7dN+iEh4
BkVvfp9E805C5U1gMpg6+63LjMDcTYEeH7nVv5U04jJpx3GiHnwR2lB6iTJfDyFA
F0053x8dOp3TUZt2ovlzlkXB9IjXM48xyxrZV4+8ACEluaycSSxro/yejMv3Vrza
z3FjQ4Sp5z2TX1btmPn6DOkD1SeM0exflclMOCz3WfiD4cM4WrUakRNcuOdEaDbT
J1hpuPZ1FiJr3Uin14B6fKiFDWq+g7D/Fwb4UBSk2S880SqWep2jwS1g4J1Tndc1
2CXNahHWvdzeYEWqZvPRcijAaiu9VsotnMuCB6PfUbsDxWOt0pbmBbQr4ZOeMzeb
8WmTQBYs85Q=
=vhDK
-----END PGP SIGNATURE-----

--==_Exmh_1422221788_1948P--
