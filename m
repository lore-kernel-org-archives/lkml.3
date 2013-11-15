Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3KOBXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:23:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50017 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3KOBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:23:40 -0500
Date: Fri, 15 Nov 2013 12:23:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the idle tree with the pm tree
Message-Id: <20131115122329.1479981f032f0f863c786c84@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Nov_2013_12_23_29_+1100_zRf.pr1j17pWKf6w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Nov_2013_12_23_29_+1100_zRf.pr1j17pWKf6w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the idle tree got a conflict in
drivers/idle/intel_idle.c between commit fab04b2208dd ("intel_idle:
Support Intel Atom Processor C2000 Product Family") from the pm tree and
commit 0654c50d7a0b ("intel_idle: Support Intel Atom Processor C2000
Product Family") from the idle tree.

I fixed it up (I used the version from the pm tree since it was much
newer) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Nov_2013_12_23_29_+1100_zRf.pr1j17pWKf6w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJShXeVAAoJEMDTa8Ir7ZwVahQP/3sLka1yrejW+g8nIi0FiYOc
8a7EWUIfsh3DBbYTkO5aNh3StWAzby5y5LXQsJwy4DB1akI29yEKkTcxYfLyKejM
9oBSVAEcSIAs6O36AqD9ySu0XJAHfe11KxC7UsnSXzLEyegy1O7oiWrt0/u9uS28
EB1+9L7o6SnAtBs2N0elU4iZZYk5kTeyRtIuIjtrhFALYARdLr8aRhPdgE5qInjG
XMNimRAD5rOJS/tTN4h2P/q/bONOJs8+Jztbr/FFGrw2JMEhp0R41E78Vu4I5UJ6
5OKmrruZ8vJOSHgZKLhv+qrqvtsVzWWjX6UTyQBK93kIkOs0Bqa+pYtPb6lZuveM
m+C2LS6NiUd6TxJOfI3/IJ6aW9PTInxyOXbqHny6vNno/3tii6eK07W4nwHPUFl0
LCALdzGcPA3BSXUuAvpCSh9tQIhGiuom8+EtxCV9QCWoKxeeglgxAWTz4NqkxFRH
clhF0h1HdRUjD+KXMwUSyJ32pdXy4eIMfmYDEvtfBgTrrWaZ21i0ZrffmcwrQBR6
Foi2CeC4irm1h6/h8sZe81VaeR2ucLhcwosw1kj0CqGlBL3wVZBdFsi5202WbwVI
fV/XilhGL6NUqEWK+2tuO0V9/7su/sc8Wj0MV5DaZ8zJiv2h8sKduycit/HVi8Zt
OBfueQR1dYH8pOtU5r7h
=Gx15
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Nov_2013_12_23_29_+1100_zRf.pr1j17pWKf6w--
