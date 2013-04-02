Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab3DBBPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:15:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43047 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab3DBBPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:15:23 -0400
Date: Tue, 2 Apr 2013 12:15:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the cpuidle tree with Linus' tree and
 the pm tree
Message-Id: <20130402121511.40119d4e1e2e8fae62c047ec@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_12_15_11_+1100_irnlz7gJS4JToHJi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_12_15_11_+1100_irnlz7gJS4JToHJi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

Today's linux-next merge of the cpuidle tree got a conflict in
drivers/base/power/qos.c between commit 37530f2bda03 ("PM / QoS: Remove
device PM QoS sysfs attributes at the right place") from Linus' tree,
commit dcc1a5e7d8f7 ("PM / QoS: Avoid possible deadlock related to sysfs
access") from the pm tree and commit 1e3b5df683e2 ("PM / QoS: Remove
device PM QoS sysfs attributes at the right place") from the cpuidle tree.

The cpuidle tree commit appears to be an earlier version of the commit
from Linus' tree, so I just use the pm tree version of the file and can
carry the fix as necessary (no action is required).  I do wonder why this
patch appears in two version in two trees  In fact it looks like the
cpuidle tree is nothing more than an old copy of the pm tree :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_12_15_11_+1100_irnlz7gJS4JToHJi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWjEfAAoJEECxmPOUX5FEG1EP/2fAJ+3IEfqoyGrEBPqCtZko
EfsCPDKjvw3fJm2dtvWy5daHyEdrOtp32tXd3wQGxIgjIZP3dBxkewa7PnNlnL07
4vqIfYYdvjY2OH7D0VjSSJby8EOpYHlJr2S42f9qnFnBqy67nIMvXhEQKJWcgigR
93D7N883jG1PFmTH8DyyCxN0B4ysjn8Y7rFTafVdxAy8vFQ9YZLHO8HaIsUIv/hf
tIcU7XVy5hxCvh0+56kx5Mkfjj2lg91HyP+emh6lMI0X21NIG6sCHwh5zapNUeKP
B3umCjKLYW3mCWcrpwgI/MoBuGSL+2UjWR/vpvt4HP3MYXWcyKdteNz2XF1fH906
rAFTuJ6OJfguuFqbSbf1oNbPXHTaOrXHVFKKkHqtwztcbhTpwmG7Y1XjGehf6Ea3
Tu/E8JNMhink0FvHYZSer7trX+PctLxgkmcPcAUSbLXVIUYdsCMAEwV2Tnwv468V
goi4niTgaMbYFH7u2mRaZJrwM+vjfA3P5cIJsWD8dNVsFbobjAsLgQ0AR66TCFGX
1IqIfg6NJSi2aXe4FiP0SvNL5MXmeiiAUeAgeVfkRQ9gUfrzteNjeMmbjp4IJzyT
p0cy+wJAuJdFz2gehCd083XEQCKEiYaQvevr9QSk4e/a5/k1QtMNC3LzxMALZHxs
D3nma/CpCq64egGZa0el
=IENe
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_12_15_11_+1100_irnlz7gJS4JToHJi--
