Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaHZE3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:29:19 -0400
Received: from ozlabs.org ([103.22.144.67]:52787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbaHZE3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:29:17 -0400
Date: Tue, 26 Aug 2014 14:29:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-ID: <20140826142910.2e8c496e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sGCh49bY2+c_BOa9o=fETPH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sGCh49bY2+c_BOa9o=fETPH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
mm/memcontrol.c between commit 747db954cab6 ("mm: memcontrol: use page
lists for uncharge batching") from Linus' tree and commit cc5ac3e15fa5
("mm: memcontrol: fix comment") from the trivial tree.

I fixed it up (the former removed the comment changed by the latter)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sGCh49bY2+c_BOa9o=fETPH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/A0aAAoJEMDTa8Ir7ZwVoZwP/0wmI048dVKGmunFPAcBIAyB
HhBZjqvU0n9NgO1EfAcdVcJnwHRMKTCDlUZJKDOTTpofbq3QSMDlvlmd7SozqDhH
f16TkY1yLle5nM/SVzmtz2FbGjeRjSJqexUiTstL+tiUoTuxIaTHkTYjpWYrNtRO
KSIHD99w9D2Wi+H5cBbmuwt7uXomynDjf/J6RwFLZibXL+ZXPJjefGXbJtO63jDd
Hx+r5ef8M5J73qWwuJya8Z6ScqrJQZOw5H479ncG3XbFfdv3cJje4sDkeNA6O4zJ
Hi6GS9GPNt3bA0PdFxX25WrrAKhKemjYdAPHVtuBG5HfeVFchnzbEj+XM6pS2C8g
/F0VCtcP6Ks+UIyjtP0lEEsS0nSThtmqikdJesyp1sqoKrrwtx6lcKz/OTdG8INj
gRFd1jC93L9jwWAiiibwx8iCFYIT3RkXrcFK4KRojgHAtxvVCCxb/ZjaCDdHKlls
RlHzUFm4PSkl1NbuHXNPCTsS/ffVL5rOuvBLmkwy62xDT0eft/gjVt+RzSQt1jpB
cVIxo62HLmK7ygQwIOMD3DI1MKVtN5F7rXnixA2LTFGOYJrvk8b6/AAk+GgYVXJ3
UvY84mPQ8/e5k59MqFfagSbeNGCcQjONVeQy/CddzZggQXiNqA/duZQMGXW8bGtg
D9kwthnHBdWBOuoZnkHi
=BUTN
-----END PGP SIGNATURE-----

--Sig_/sGCh49bY2+c_BOa9o=fETPH--
