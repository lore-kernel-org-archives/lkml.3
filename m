Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaFBXio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:38:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaFBXin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:38:43 -0400
Date: Tue, 3 Jun 2014 09:38:33 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST - 3.15] to md bugfixes, tagged for -stable
Message-ID: <20140603093833.1bca3dfb@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Gez_exs.HqWVhd21ckatyMK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Gez_exs.HqWVhd21ckatyMK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
If these could be pulled into 3.15, I'd appreciate it.
Otherwise they end up in 3.15.y for some y eventually.

Thanks,
NeilBrown


The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://neil.brown.name/md=20

for you to fetch changes up to 2ac295a544dcae9299cba13ce250419117ae7fd1:

  md: always set MD_RECOVERY_INTR when interrupting a reshape thread. (2014=
-05-29 16:59:06 +1000)

----------------------------------------------------------------
NeilBrown (2):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "res=
ync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--Sig_/Gez_exs.HqWVhd21ckatyMK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU40K+Tnsnt1WYoG5AQLKCBAAhXVUJOw/4wC+JC2OPCFZG6HONq2nKCwp
nQVvT5k8kSs5Ly0zv/iDJNv6qYdXkEaO6i7uHWFcyYYOlxjSG6eWBCrA7CylPquD
Vgm7stX202ZKzRExy1nUDh6qEEgigoSvfuvcYPy60rsafx5K62r/SHFjMUQuWkAd
i7HVxmIRUfGutliQnuoxfJETztUgWzcmsXAj6wOqiqXQOm0XPsZT/OF1Lv0NyluR
liv6D5IP41o+Q3bfKHCANq+WsrGS8n04jbUJMGsgYOZwlse4UhRW432hpCOQgqUD
C9ffAxgi1luMbqtrK+TzPUqojg8xhh/Nn2GXjv46HZHXgHW4bSle7+kQtMDSaKHd
HHE+AQY8iOnmqPR8eVS9Errbuv2FrKQaiA21LVKSgcRyrF6oeGge3egJB/tkn6u0
s6ISqoPgvpiJWkXyCGZBODRV/OHISihpLir/CUVKtw633qzkrhK6XSINg6i1IF4u
E5u+bI0vaioqG1yhnk+fwXSClCNlRQQxTfxO+wptRI4VP4PON1sCFUvGm6rXCtdw
oa6nfut0ZV6zMZBU5DmQkDhERF4R6Psf07ByNbfI76KvPUS48C9Wv+VXPq+vrTeW
MwEI7WTEc7GMGsgh85AogUBWqQCqyZvu6EpjfQbWCzKxen4iFBXjKyg1J3O095oK
3PYrojVSP7I=
=Syh4
-----END PGP SIGNATURE-----

--Sig_/Gez_exs.HqWVhd21ckatyMK--
