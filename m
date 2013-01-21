Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3AUDqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:46:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48731 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3AUDqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:46:15 -0500
Date: Mon, 21 Jan 2013 14:46:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20130121144604.3c2f94e93ce6252aa43d3d9e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_14_46_04_+1100_Sr3YSJBcdFakWMeY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_14_46_04_+1100_Sr3YSJBcdFakWMeY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/vt8500_serial.c between commit a6dd114e16cb ("tty:
serial: vt8500: fix return value check in vt8500_serial_probe()") from
Linus' tree and commit 12faa35ae5cb ("serial: vt8500: UART uses gated
clock rather than 24Mhz reference") from the tty tree.

I fixed it up (I just used the tty tree version - which included the
former fix) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_14_46_04_+1100_Sr3YSJBcdFakWMeY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/Ln8AAoJEECxmPOUX5FE6sMP/0tiEJPx0XAAE1rfizLbYl5k
5rZVHMvunt6LK3kwnaHpY2PSaje9Pq2zvOtBHRTnGU3IQvbw1Xg7FF8GsLYYHj8t
LuFz1mVhRTL9RgMcu7E9qV5yB1GyudlIAbBaWkE7YjquTSqELrEWS2Q7fWNvPvkd
RLyy8S4ot3umAZF4VaQcPn1CMdaZ2Q9lZrMTRKqsYhK8av6HRjQahyMsTl6AeJVt
OY8lDP5PPjjop7IgNyUHhW7jdA2zDzMc0lpT+3o6h42+cQhy0F1LD/xL3tZC8thV
m77Dqnv3BjxJurmFS36+EwzkZ78l95AiT5Z3E4wHZUWcpWjG8UHnSBXIfXyHWfY1
pi5sWhXrwPSNtj/ImdVPxu7pGLfN3ler2rfmxp5FodPvWqQbUXSGG6jRyGuYIadU
gUegJVGvAzXBhBX1VMd6z8Gd0uu02IGBPlQHv70EaYVfvli2dtn63/Ws5jeYFfCy
MUbIky/jCuVm72koO+vQK6qB4YW/1D62z1CBnwjNkUq2QTatG5YRKPZL4HMeYu+r
E4rAdbDeV0XIXyiUwFg1ac1R7BlihjW1XfybHDY2HuoCZU6zck/bpIFitbXoEarI
dGh4LxqqAQ2henoYB877CGMaCaSZiRTrMO16E0XqkR2O36WMncsNDkdYEZunTAPb
hHvsUK3hOgq69/PA+sA7
=1p53
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_14_46_04_+1100_Sr3YSJBcdFakWMeY--
