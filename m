Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3D2FWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 01:22:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58270 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3D2FWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 01:22:01 -0400
Date: Mon, 29 Apr 2013 15:21:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>, Tom Gundersen <teg@jklm.no>
Subject: linux-next: manual merge of the tip tree with Linus' and the vfs
 tree
Message-Id: <20130429152149.d5bb408bf88bf46232282419@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_15_21_49_+1000__sgeb./wvjQFhjm6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_15_21_49_+1000__sgeb./wvjQFhjm6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/firmware/efivars.c between commits f464246d85d5 ("efivars: only
check for duplicates on the registered list") from Linus' tree and
a2162ae42bc4 ("Include missing linux/magic.h inclusions") from the vfs
tree and commits d68772b7c83f ("efivarfs: Move to fs/efivarfs") and
e14ab23dde12 ("efivars: efivar_entry API") from the tip tree.

I think that the second tip tree patch supersedes the patch in Linus'
tree.

I removed the file and applied the following fix up patch and can carry
the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Apr 2013 15:18:07 +1000
Subject: [PATCH] efivars: Include missing linux/magic.h inclusions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/efivarfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 34c48f1..1fa5e6d 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/magic.h>
=20
 #include "internal.h"
=20
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Apr_2013_15_21_49_+1000__sgeb./wvjQFhjm6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfgNtAAoJEECxmPOUX5FE9NAQAIyvM9/+z2gONxOEQ3jLu0sc
YMCdeJ0PCcVGjXA/ZbN6kWPF9feNhrB1U1tEJIYBVFEWZuZUcK89UWAUdfZ4BheO
3E8DnnIEgQo8mvFJuW4GD/iTe8q+P3rKvQkeWehXHMoE2bklWTUaZD2dDc0/NovJ
Y3LB2nNMYZR3yy2t9mLX+MY28791LkncDYXxNKQkStecyNRKKasnSWKtDTfaUd3k
k3kTIvwizmlYrO8b/6mVH7uUL3wv5qOEcTBneuUFVXLHk543a0UHXBmM08Hu8sRk
UnIGsCZcfQqPgwJVH+6q9P+CwLgchJTfROGUhCQT9leFchOufkqd3lX5CGPUj7EE
wcnqJpPyx4BWDWz0AonPDQLcvfWvXuGxeCss+UKBt1zj5hQOaj0Aun5aHJO4rUH3
Rupxx0caKLWFgjR4ON7VFz1m4/55Xuzst7hk+4li2IL0NqgprEaBfZIDsd8ADUd+
n2bgIBa6+cTl0IT3r9XwzftxkTH1AJJDo5QYn5s1eMVlb2ftdw2zOSHJIYJfMNAJ
Sou48dGeHLXmP6dcY8Id77ltAW8AWqSQxuq6XRg/gY959rJc9tZovj+G0+Lip/7f
c7SRQ4LegaunsckdhnMNBY111drEo+KiFka+gG1PXihGXMdAj4D+nqIDb45HT2gw
uHVHUq9zYHi+x9R0pZ/s
=srVy
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_15_21_49_+1000__sgeb./wvjQFhjm6--
