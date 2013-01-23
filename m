Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3AWEpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:45:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49278 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3AWEpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:45:38 -0500
Date: Wed, 23 Jan 2013 15:45:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Einon <mark.einon@gmail.com>
Subject: linux-next: manual merge of the staging tree with the net-next tree
Message-Id: <20130123154525.9f1bd6652f13f2a7a8202bf6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_15_45_25_+1100_1cvGWpdGoxQQ58VX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_15_45_25_+1100_1cvGWpdGoxQQ58VX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/et131x/et131x.c between commit f9a8f83b04e0 ("net: phy:
remove flags argument from phy_{attach, connect, connect_direct}") from
the net-next tree and commit 26ef1021c1c7 ("staging: et131x: Modify block
comments to fit with networking style") from the staging tree.

I fixed it up (the former adjusted the white space in the same was as the
latter, so I used thet) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Jan_2013_15_45_25_+1100_1cvGWpdGoxQQ58VX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/2rlAAoJEECxmPOUX5FElncP+gKO+mwU5C6EEhNCSsyR/3eX
WsaWgJURBk8g5QHLSdLVy52Oju8n2KALsqlZn71nZnGc5XcgBC9lnSytTdcYUPFo
c1K/zchfiAb9FgdycSI13SHWMY86Yb8NuMEvv/vN1RNiBo+/9a6erxVRTowpffOi
y79C06CBmmN8ntiDgdyOZM7HOATD7FZYJvc/IgUPHTxvbgKsOh/v5KSmsWzdHphc
gzsSx41/3uvZXkJL2kWPMVaIL5B/DyyoGeYqw391C2Im77wu3APBLBHrY8W8C+zy
mpd089PWE6BOoB7/m/ie6xS4NZokCsPP21SupSkDa/gRdnHwJzBAupP4n3XD+Eyi
mm1/D7NSOP1v8rJT+MxYdfbH/3SEqWDawfccbxwfiJNXQZ4lqOeJ2aSwNEfxb5HP
5tlgnNUi6Nzpu3nr8crD/xjf7rPbWt15OuYCMUJfERVRLzNYjf//8K7TPRo13p86
AS2LrW/p4scoS9y6jMo415/pqfYt0nMPcALUcfQsnNiffxvBv90vgCDF3Ay+xb6F
/UL0rqcxXeLHpZkI1nk4w7CVObuJ3CwQnMsxDSrC+pqHkNQA4ifD56Cgz5gW+0i6
xlEf8AfyXxrMH5uvAumKCgYZP965ChgtzBEZr4bYIY/tDD/7/ekUblWhY7F+J9ka
l728JXTOfJVTvkJZEwKB
=es5m
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_15_45_25_+1100_1cvGWpdGoxQQ58VX--
