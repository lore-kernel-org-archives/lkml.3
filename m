Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab3CMDDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:03:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40113 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3CMDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:03:39 -0400
Date: Wed, 13 Mar 2013 14:03:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Masanari Iida <standby24x7@gmail.com>
Subject: linux-next: manual merge of the trivial tree with the virtio tree
Message-Id: <20130313140328.f4cc0a85729db25f014eed39@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Mar_2013_14_03_28_+1100_hIRSd/GOKBxbj80R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Mar_2013_14_03_28_+1100_hIRSd/GOKBxbj80R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
Documentation/virtual/virtio-spec.txt between commit 29266e2e29f1
("Remove Documentation/virtual/virtio-spec.txt") from the virtio tree and
commit d097ddaf529f ("doc: virtual: Fix typos in virtio-spec.txt") from
the trivial tree.

The former removed the file, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__13_Mar_2013_14_03_28_+1100_hIRSd/GOKBxbj80R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRP+yAAAoJEECxmPOUX5FET8kP/0DLpYZARUyUygBwOW4gSgi/
bpA6QIfnMmtZF3wOX/Qpx2l5Vao/nyuhBrQGs6b4DqKuoCSQFZ4NOYM9uGUPcgOl
VpSWlSJnZOHFgrw2qjVqxYdZgW4yS6PLgpYqyxehPwxequurOg6ZABfZWZWz6Ush
m7GVim17x47f5Lg338i06LStCl1We1TH/9V2RM4qEMG7I2FHRQAuSJgV5cOSYiv1
lIIRJb2weu8B4OB9xZxujM4QVbiG2kLmhIZqJy3W/vT7UoZb3kwOq2powuWZ3cQ2
YUBTmZHdU8XGZWNlHEwclPnSWYcTRu+4Wcu9ePALIUXLb1Q/rin0fS1Dlku3XZU0
0fk1B1HG517qOUvD7zyHX8V9FGtnjxwd054ACJ2hLOthNyqHQR7nm5Zw9xcgmIJG
4Yf+kw+YW4EpwPdJu43OgVsK5mgRMGRo8AxpKA7vuU4/+87B2MPESslUSkdsgqQ4
9Lk5xSAWRy5Drb0+TbCxKqCuzvRRTX3UDodYOZE8FaKvuI/Hnaygbz+Wng+lz4jQ
ko9Jf8ymUONRCcM6cnEeA0p+Y2dmOkKV8wDlbF1U5e7ltl3ftUKPlyubt88VT2vN
iAFwp+8Uk2WNWGIPpLb7w05ZJEp7xPWdtKsUFYBN325jwNEcnIU9V+Kj0SAIV3Ae
4FmkPXYaygQ+OZLuC/3Y
=Ad5Y
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Mar_2013_14_03_28_+1100_hIRSd/GOKBxbj80R--
