Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3GZGDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:03:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54747 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GZGDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:03:11 -0400
Date: Fri, 26 Jul 2013 16:02:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20130726160254.83bbe994219d6ee732c64b7d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_16_02_54_+1000_Uqwq/J+VDHs+VWL/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_16_02_54_+1000_Uqwq/J+VDHs+VWL/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/xillybus/xillybus_pcie.o:(.data+0x6d8): multiple definition=
 of `xillyname'
drivers/staging/xillybus/xillybus_core.o:(.data+0x888): first defined here

Caused by commit 48bae0507410 ("staging: New driver: Xillybus generic
interface for FPGA").

I have disabled that driver.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Jul_2013_16_02_54_+1000_Uqwq/J+VDHs+VWL/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8hEUAAoJEECxmPOUX5FESIcQAJIrqr0d+QFldpu+/OFZPKHe
I47MX2QAdbZK5rMe6mZoCLAiyeDzggxLa1Tpu6XsYzSJpiz37ZwYgn4smtcuOihv
CWE6i8otVwT8a86tZ/2/DDoa6rSw6MD3lYdl6GwYO6UwjpQmq78dC/mzIR5tSP2/
wtJm93tKc/XTK8TpNHpGB/27Jxw4g80HfbdNzuFeT/EhxtuLVq+krMZz8HG8FmMZ
IU0b7rDj1/RrivGtD7R76kAdHqzLsNCtBgxJnXg+0c/kcc5/q0XqKe8CuWkaUyJn
WIg5i0FN3Tzfwfnypa7XMpJHimQ9EupKT8jgv8MMoV3vD3oKJV23TUvWElQsjuH9
brVUEEYkm7HQ0H0lKijFz6f0OWR30wcl6GKdYpmJo6TxYMCyqPXD9HzRYot1z2Gu
zPrUf/ZncfYetIS00sBt06SjVi3Dqc/N05KqoCKW+0+zWI+Iv4AU9nEY/KaMRg2p
qnsZ3OsGVQELX3Y5yQJjzYvEvkwgYACa/zBaMxsqJsYipB119jsNvVObrCua8SrH
0kGIz8/RhymZ9Uol/KB0E8Co3l2NEGPM054c4iMfd2r2zDiwC8vBIE8QH6H4akhT
k201+6bEsOuk+PKAzIF+ELQubp20fLR5Bjx3pUM+NBWDMESdrOd7bavXMhvh8Jrq
jdEca3YxwmKt8KgOJQVg
=sZw0
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_16_02_54_+1000_Uqwq/J+VDHs+VWL/--
