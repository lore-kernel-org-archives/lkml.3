Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaHHFqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:46:46 -0400
Received: from ozlabs.org ([103.22.144.67]:40702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbaHHFqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:46:45 -0400
Date: Fri, 8 Aug 2014 15:46:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-ID: <20140808154638.79a06c16@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/X+o1xbfDld6o_K4FnibHE0W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X+o1xbfDld6o_K4FnibHE0W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memcontrol.c between commit 61e02c745721 ("mm: memcontrol: clean up
reclaim size variable use in try_charge()") from Linus' tree and
various commits from the akpm-current tree.

I fixed it up (I think) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/X+o1xbfDld6o_K4FnibHE0W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5GRCAAoJEMDTa8Ir7ZwVS4QP/0w0Rwe0oRwanYoNTc0E2BzW
uK4K1HUyCvwD3m6SJBEN5dlZeCN+wPeT2Eo5Uwv0KciN5cGJNy4s6lo44ZAfILCM
72Zuun1Hg5ETz8xbq2zoriMpTTOchDFce9FJaBRJPFedGjdmSu7Wq8XtEmaBdsW1
VRGVakvu3Y40XH75+Z6BQAFavvEIPy2vgmDPvQGHr5StTAshurc48lVQrF7ga7Vc
sRW+BzDwZeR1Y0g+bbLPJxF82jpWGlXxycWDaWEDraJZyY2CBg+OnraQ7fwMahSk
m/gUppK3E11GqcAaF67+O7+0CPs0I7yOjsu5d96sj7r/TGFwZLuplR0MMzQiLvfx
nb5hbeyiasQhRIC61plV5MF+LuEktoouAyiXbedo0Olw5NHmiETy3m/ipEX6Fy5E
8Tz1YJij6efY+oNtPdt52N8Wev6ynEhTb8aOaqmSqEsqpc3ZGuRd1PuSln9BLL9r
ZW7pZhCnoaHbtxZLKbS6O2Xgnt54ChmnwLO+iKTf+hV42oVnd0T3k7tU+fXSyISd
Gz9JVaZ7p+Wm4lqVfnvUrj6cpizoxpQN17QQAGnqAG/oe2EJgkT5yi8HMIdvPo77
B9q5M5fub9xQ45AcsP8mCj8Kuyb7TsEgK9uVwG2m2qPkEtVVSKl+KzGoEgz3x792
9PI3Fr7AGc/7vNlwxY9n
=GaLE
-----END PGP SIGNATURE-----

--Sig_/X+o1xbfDld6o_K4FnibHE0W--
