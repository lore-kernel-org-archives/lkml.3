Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaGQBoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:44:54 -0400
Received: from ozlabs.org ([103.22.144.67]:59695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaGQBov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:44:51 -0400
Date: Thu, 17 Jul 2014 11:44:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: linux-next: manual merge of the mvebu tree with Linus' tree
Message-ID: <20140717114444.15d99fc2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/c2ySEUNRYniU/PLmfOWmc8y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/c2ySEUNRYniU/PLmfOWmc8y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
drivers/cpuidle/cpuidle-armada-370-xp.c between commit dc559aabe2d4
("cpuidle: mvebu: Fix the name of the states") from Linus' tree and
commit 742450174037 ("cpuidle: mvebu: rename the driver from
armada-370-xp to mvebu-v7") from the mvebu tree.

The former patch appears to have been applied to the
renamed file, so there was nothing to do (except remove the git created
version of the old file).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/c2ySEUNRYniU/PLmfOWmc8y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxyqRAAoJEMDTa8Ir7ZwVJScP/0bkFXIU0trwoU+5ZuM6OOnp
Q1ONoYy1RDVVW2Ztc8du9FCive1CUiCMYoziiIo16Tg1kb/oql0eL6LeBZcdIsgM
hu3GtkkiSR896ci90PiFDMjqmk7XzZ1OES4cVanEtwqamYMDzeMfC918QZgs+GO+
t8Kw9Ga8yvk/RWQ9mvT2aFcyedANvJKxeVMva50wGZRZl8HmFVHNHwKhxqltqQTN
gkZtFAD6BH4PH2e8ZSVbVP2oc6ALBXsLZsXqWad8OHvC7c7iR0iNOWppNB5dE+09
0ucxRMxJaLoXBjew2kHE6m8x7ks7A5Gk7ksrbhmMwnTpLRegwWRZnN7gGGOI52yw
0lwFK0psGkoutdJ4N81E3Ns/41txAvUdluiOfzAXQPBnpJtSxFpsgUSQcb0N5YvB
8l5K2RwTqw0mdUeHOpQPOlrHryJZJmdajiACPw1gudOmWcRrfh+zd4mH3j8qE2mY
A1mUK563Td5iXn9fXuszGLabH6LTAmKo032bmC3JxsHU632q3VjF3O2yGGDpqhc8
l9SZmsN4oOhe7gpO5C4kz/ILnHfSqrZzIU+tgt3aAbZq+rKavb5YO/oluNNgPcnc
xvKC5T+kN/8VjJBANal8JC2URExm1L2Duzke5R7i/D7UlwzABdFg5zzMmTnh25lx
/J4q4LadS905DNM2CV9j
=ZGrL
-----END PGP SIGNATURE-----

--Sig_/c2ySEUNRYniU/PLmfOWmc8y--
