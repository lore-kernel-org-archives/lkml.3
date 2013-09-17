Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3IQHCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:02:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34663 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3IQHCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:02:16 -0400
Date: Tue, 17 Sep 2013 17:01:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: old trees
Message-Id: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Sep_2013_17_01_24_+1000_ugYdwK6T7JDx0cPM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Sep_2013_17_01_24_+1000_ugYdwK6T7JDx0cPM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This message is bcc'd to each of the contacts for the trees listed below,
so apologies if you get two copies.

I have been inspired to check the ages of the trees included in
linux-next.  Below I have listed all the trees that have not been
commited to in the past 6 months.  Please let me know if the tree is not
longer in use.  I don't mind keeping these trees in linux-next if they
will have continued use, but would like to remove any that are no longer
needed.

Tree		Last commit
----		-----------
4xx		1 year, 4 months ago
apm		1 year, 5 months ago
asm-generic	9 months ago
audit		1 year, 8 months ago
audit-current	1 year, 8 months ago
configfs	1 year, 10 months ago
cpupowerutils	1 year, 7 months ago
cputime		1 year, 9 months ago
davinci		2 years, 2 months ago
dwmw2		6 months ago
dwmw2-iommu	9 months ago
embedded	5 years ago
firmware	4 years, 4 months ago
fsnotify	9 months ago
fw-nohz		10 months ago
hsi		1 year, 8 months ago
hwpoison	2 years, 11 months ago
hwspinlock	2 years ago
ibft		1 year, 9 months ago
isci		1 year, 2 months ago
ixp4xx		7 months ago
jc_docs		2 years, 6 months ago
kconfig		12 months ago
kgdb		7 months ago
logfs		10 months ago
lzo-update	7 months ago
ocfs2		1 year, 1 month ago
omfs		1 year, 11 months ago
openrisc	6 months ago
osd		9 months ago
parisc		8 months ago
pcmcia		1 year, 7 months ago
pstore		6 months ago
random		7 months ago
sh		7 months ago
sh-current	1 year, 2 months ago
swiotlb		11 months ago
sysctl		1 year, 6 months ago
tmem		11 months ago
uclinux		7 months ago
unicore32	10 months ago
uprobes		1 year, 6 months ago
viafb		1 year, 6 months ago

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Sep_2013_17_01_24_+1000_ugYdwK6T7JDx0cPM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSN/5KAAoJEECxmPOUX5FEfmEQAJA1Q8roqFRXsr+xD4Cqw9QJ
mpmhbR5il0FMwrb9pgLJzO3bHhBZn+sOHgKUCSs2wXsbeLU4pYZ00GiM9zqcw4Ns
LVzTT0bvQaC4F5svo2fLWzk8ShJ4UK5JhXCbRMtHZF4ZVsfdSF3at1j0I4S8/ST2
iG0j3zSpynyJdwRCIp1P2+kbVVHLhQLUFqa7jpjmZelX4QP0nYXeFXKW1M09dhVA
0L4pqgzHn6V0e7wTnGp9JDSYsylEtF23FPTGca9hAco8Brg9VCPgLoNXnChR4fbD
Mu0nHDwhFstvf1ZThjbjZzxd0Vot2MYqPcV+47VKFmpkotj5kdLEeDAom4XAhrhb
7AI85JPvX0PPcxp/vHWsEfDGZ8+cfWpobTnsTaInOy/F2Ji8m9FQFyHpCj7cr+VV
o45YdBFj1oyZ9SCTUCNUgMM+7P0me7R9c7yDhHmZ1jJy6x8gNGXCVNZq5ooTSZsy
L9Hf+Izl9D+HBVP3ek8UOo0LPf3ZJXHZ4LRXy/bC0PPFYAEGNfQz/4mAmbbzZBZC
ak27e4JaiP8AcLMhiXG/fJ6xhZupQQIcLK+Zy6Q9CPHwMg3Jh9wBSUsQ+G9jJ7KT
5tNJqrzl+XiE0pz3tiIprgE7kWF5U7LM4hw1hr5GaaDK8oL+nqwij4vmt1Tuq9PQ
7aDLAP6RKiCMZ1Ean3Ye
=3Ucm
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Sep_2013_17_01_24_+1000_ugYdwK6T7JDx0cPM--
