Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3LPA5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 19:57:47 -0500
Received: from ozlabs.org ([203.10.76.45]:41556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3LPA5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 19:57:38 -0500
Date: Mon, 16 Dec 2013 11:57:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the jdelvare-hwmon tree with Linus'
 tree
Message-Id: <20131216115733.16a652c0e350453d94c8551a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Dec_2013_11_57_33_+1100_oUpdlEb_U4iC=JB6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Dec_2013_11_57_33_+1100_oUpdlEb_U4iC=JB6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Today's linux-next merge of the jdelvare-hwmon tree got a conflict in
drivers/hwmon/lm90.c between commits from Linus' tree and commits from
the jdelvare-hwmon tree.

It looks like the jdelvare-hwmon patch series has been reset back
(unintentionally?) to stuff that has already been merged into Linus'
tree ... so I just used the version from Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Dec_2013_11_57_33_+1100_oUpdlEb_U4iC=JB6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSrlABAAoJEMDTa8Ir7ZwVfBIP/ixQ3kcK4fQagWQ+LUX25Pj4
OdeWEe4S2hw1/k5feVl8oyJ1T5v/7iPU+Ssz50BdT1yf+sbM3nqyoQotM13/F89b
TloTlVRUcTw3BPtRN8CWvnwsTy4G1s7psV23zaUPj7HPV3Ta4IYU4JIimVfZRcjb
SE7ooydO7t+ETHoBLzKcwU8tiyo1SEOi3SpahXJ6Ut7mbKqcXFKmdhJQKcDYNEbj
3cw6sZFimjaMqGSvXDc5wyHZCg2LdAr+nXFjriNvzoIsN3JzaITueMG6WTGdgZol
ZBMZfVMo1ZLRAGqKCtMXjdPwYsNaE7vNmMvt6FPj/DLKjqYoHew+ygDcN7msysHH
SDrTB4eRj00h78SCXsUlUh1ZjHYuXcUc3/ZOiiZJUj2HBDPrmaCLYi1nFW9U/DoV
R3HrTZXB67AD91Dl68YrW0Hvi463AcMnQcQl2oZAfmrZ8CVmBBeJLKeeXOKuE+m/
7McyFKLhz8N2VgyBEj+LNT3GnNJHxHGzCBwWiHNgIfvN/tKBSpH5D4K5Sd6BNbg3
HsG8DKjuaqgrVt2DKH6usGo0nNTGBsfHz8KsqkqdWDjWz6str7ZDKpP3NAhEqjG9
aEt+KORvsKjzWGXxcQ1BfoqbNhXWTNXUA2bc6F04U9PBh+7Z2bG3s8EzWVsUGyB1
wclaBLs6g0F0z5bnlAT1
=Cqc+
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Dec_2013_11_57_33_+1100_oUpdlEb_U4iC=JB6--
