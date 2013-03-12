Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3CLCeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:34:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41423 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3CLCeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:34:22 -0400
Date: Tue, 12 Mar 2013 13:34:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the drivers-x86 tree with the  tree
Message-Id: <20130312133402.7a3e5edfbbfa423fd91575a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_13_34_02_+1100_YpdBZ6RhOWuGd.Uj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_13_34_02_+1100_YpdBZ6RhOWuGd.Uj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflict in
drivers/platform/x86/chromeos_laptop.c between a series of patches from
Linus' tree and the same series of patches from the drivers-x86 tree.

There was an extra patch merged into Linus tree affecting this file, so I
used that version.

Please, when you rebase/rewrite stuff before sending it to Linus, also
update your -next included tree (or just *don't do that* :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_13_34_02_+1100_YpdBZ6RhOWuGd.Uj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPpQaAAoJEECxmPOUX5FE8k8P/j97YNzce0MmOqScophU21HV
G/WmJkdZwpEtgxdjgV3ArY2vvA99zoxzUdVenS67pqeAGNoNdpDPqxl2pcnJVa+b
3B5jtOrTusWcC/00m5IoCVfuHw4eC4KW7PM0AjzU3IJe8bHoOKLi9KSaqzjAxmrk
VB+SnFWoBifhqUrGIi5nwkRHmfGRCsjFClTlPm6kjSbpntr1klatAKCM8SPtoR0A
jxVdq3kwUXa8PVsOz6C2qUf8hB4DJDxijTnjQ60kCwEEKsNZUElVoIdq5snWu6ks
FknFGYyeJC7Dx995uE2UNqx3KyWZODSzR2qJs/3AmIhdPNCjQVOg6jbXFK6SRYtE
cwr9oL+AHtAs2KwNvtdSMn8NCCTuHdr/T91fs3hdEUEpiZarwj3aX+T5V0uZrg2a
ry9/xi1thX7v4Qda1A+agyq+tPewddz7Mx+1HPc4mSgUNbvYPneZaBY360H7PI47
1LHG1/X9NHj6CpL5E3pEUqFWlWy28uPvyimu2lRic26oz/r3TcMQeO8qwFLrRC+z
c5E/2NhXk2+vVnMbjdDrMmDQ8/TU+dwEv/+5K4nUDxZMRUSJ56bCzRF7ETGO8/YW
3Yr4oDpJOP/Yb1IOdl1fHF+2zS96z+7HvvpnMGOGLzu30z0uPJyfJmjg5TCzB73J
mh9RE3GCIMMAqD3lgAmA
=QHRy
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_13_34_02_+1100_YpdBZ6RhOWuGd.Uj--
