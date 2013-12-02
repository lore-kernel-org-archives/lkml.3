Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3LBPnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:43:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3LBPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:43:33 -0500
Date: Mon, 2 Dec 2013 15:43:29 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Linux 3.11.y.z extended stable support
Message-ID: <20131202154329.GC1799@hercules.my.domain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Since Ubuntu 13.10 "Saucy Salamander" uses the 3.11 kernel, the Ubuntu
kernel team will pick up stable maintenance where Greg KH left off[1]
with 3.11.10 (thanks a lot, Greg!).

The Ubuntu kernel team is pleased to announce that we will be
providing extended stable support for the Linux 3.11 kernel until
August 2014 as a third party effort maintained on our infrastructure.

Our linux-3.11.y{-queue,-review} stable branches will fork from
3.11.10 and will be published here:

    git://kernel.ubuntu.com/ubuntu/linux.git

We will use the same stable request/review workflow and follow the
standard upstream stable kernel rules.  More details are available at
http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

We welcome any feedback and contribution to this effort.  We will be
posting the first review cycle patch set in a week or two.

[1] https://lkml.org/lkml/2013/11/29/327

--
Luis Henriques
Ubuntu Kernel Team, Canonical Ltd.

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSnKqhAAoJENt0rrj9ziT8lDIP/3EL75nrtOrPbynUxPhphYdH
sBOZySm79AZ3x9FYscejuGx0FC2d2UxUws+2NQ0JnqmUXLOlQJTI6OJtc/KM4/Eu
Tkr00Cy05gM45EXkPh1mpHH0NR+eForQjlbitLkgdp0mt7Lv+TYd76KG+l+j7EoM
/9iQKoky3cfcGEuPK+1ZTEzlwaibgSObeQXNgoszkyMOb+aXhaNPup66p7ujzwzz
VUeoIo5fka3tzEe+l00FrKgiPEovIxtEXn3tFDLTpulwuvI0wHDX/ceocsNcHUcT
P4HC3Mm9A5kK80K/JzvE6dfuVfZSBdu4gqrUqy1yCyKfeXV57P2Hzk7VNJNQxADY
HquvnubXeL/eEYuSgWNTd3QsaUe4bGWCE15Xrkdr/0b0dJmjOBigubDAz9N//DX2
uAIdWmjCLDk1pmK+rQB8UK7wowo2S1vX+5rLkVwdIJwvV8mR1osV8ylWfKzjudaq
VHIszCswkiKx4nbK2rt1GEGn1hx5pFgcc5cdtWACRCHRTV/TKIDpecPKyqK8kk96
fmnwTC2vC100pPZysMnFhNBTrKEKG2vH2sntW6jtuzmzJf/VHOTmokDEwnpg6tF6
mYN0N3o5qzEtjwQhxHvTIvQ/uNs6LO8fYw5M/R8Hf7/umzZnv43rdfwkXjSge2Lx
Bzkf8ATyHD1HXqEfrpBI
=I1lu
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
