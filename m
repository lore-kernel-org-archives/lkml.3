Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3DKFaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:30:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46439 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3DKFae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:30:34 -0400
Date: Thu, 11 Apr 2013 15:30:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the driver-core tree with the tip tree
Message-Id: <20130411153023.7a987d1ef6f5cfc699eab672@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Apr_2013_15_30_23_+1000_fGRVFOB+B0apCjPE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Apr_2013_15_30_23_+1000_fGRVFOB+B0apCjPE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
kernel/rtmutex-tester.c between commit 8184004ed7a0
("locking/rtmutex/tester: Set correct permissions on sysfs files") from
the tip tree and commit 928c0c1571b0 ("rtmutex-tester: fix mode of sysfs
files") from the driver-core tree.

Both patches do the same thing - I used the tip version and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Apr_2013_15_30_23_+1000_fGRVFOB+B0apCjPE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZkpvAAoJEECxmPOUX5FEi34QAJz2IFFMmFkyGZuoY7jFVd9f
76+44G0twGD3EjnxvJgqFnNs01x3y6pZ4VBtuThMHsflWz8I6oEnt35fq5tBQ2JQ
1aFrYrgLF5thk7m7epTajdJ1iYiz4fM7bYqmyNq9MitJtaup7VCdOTKJsKG/FzNs
rxlHWwcPHiMC0klYhQP9td3vBwCTIZRYp53p9BrLsfgXta5ARI5Nf9BHk68JLgQd
oasz0fRv4SWy2Knr9JpQv45CGNnR5mGWGl6oHh1Qx8vUZNqAkFdjQHLJSwSKleXE
UtUXgnDeJaRd1PpYn67PlSNyu2ni0gPvAbcS64jNxuVKX78qKN5IhFgRwhCP7VXv
NCm5TQ7cB2GS6G5JF8yIIBZWSgang1HCFGBJ6cWCFvucPmYg5z7e1YgcWN1pWqO9
jbwECj2/WYCUsYmrxzuxQfrgOI+8s8NROQTaszMTDK8r6hRKKArXt3ABIjRtfHW2
cpDRWugVGLdCULMxBgdss3wd3b1e4tpFUXb6ADqXIQfHBFOGlNnzwi/SiwBagzHY
ZbQWaYgNRkzys+ZkMsUlK0CXiCzHkJjPazj8lErhjxNQYpgkhPgWqUbe6w+8JTNQ
E3Tetod5b82f/bfiF54qZJQPVTN/7s3fV0OZoWQ30TwDpD0Cd2TeugQBzpPN1/PQ
Fv6CxFrTiUYsWxaN/4iL
=VuuE
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Apr_2013_15_30_23_+1000_fGRVFOB+B0apCjPE--
