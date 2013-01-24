Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3AXCGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:06:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35993 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3AXCGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:06:25 -0500
Date: Thu, 24 Jan 2013 13:06:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Greg KH <greg@kroah.com>,
        Liang Li <liang.li@windriver.com>
Subject: Re: linux-next: Tree for Jan 23 (pch_uart.c)
Message-Id: <20130124130616.ee95e032326b1afee6716419@canb.auug.org.au>
In-Reply-To: <51007226.1040604@infradead.org>
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
	<51007226.1040604@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Jan_2013_13_06_16_+1100_lzefWPhmnFZe8ttf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jan_2013_13_06_16_+1100_lzefWPhmnFZe8ttf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Jan 2013 15:28:38 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on i386:
>=20
>   CC [M]  drivers/tty/serial/pch_uart.o
> drivers/tty/serial/pch_uart.c: In function 'pch_uart_hal_read':
> drivers/tty/serial/pch_uart.c:572:11: error: 'struct uart_port' has no me=
mber named 'sysrq'
> make[4]: *** [drivers/tty/serial/pch_uart.o] Error 1
>=20
>=20
>=20
> when SERIAL_PCH_UART_CONSOLE is not enabled.

Caused by commit 1f9db0921f21 ("pch_uart: add sysrq support") from the
tty tree. (added cc's)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Jan_2013_13_06_16_+1100_lzefWPhmnFZe8ttf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRAJcYAAoJEECxmPOUX5FEWPsP/jV0tMxWMa1LO2QHtGHK9wks
N4IN5FCljAJrVlUN5lkxxjJP0mcGm9mMJiDm3ZK/uIgw1wNhVhefkv+U4cm1kAc8
K16QU/hd60hWU+j/P705tPJvfGMQq2vhrlGWgV8AndgsKGjML3ZzkotHlvuNSEFZ
JbBtRQ2aVS0CtonHisBPvaW5pqsGHbb+spYrSeg7Cp+Y9TSe36Rgl070YHlcOsiA
FklLW87MOEvrPe5bVGtttNu3x0tKtHKRN83eGC3GdvKqwffG2VVYZaY4sV+ZSHXE
bOhm0hLuHAFus9Dq3vRZUcykugZ8/klIDkld38i2PuGCNKQ+/LCHfxbXVmgXmoY9
IPq+ZsHqs458ml3s8Ky59blF/T2cXd5L24SBwPfCFTtm1byIhS0qenzOLrIlBgsa
X7Jpyf+BcY5pWdBZBXJZSVz2ASy7hIsj/OpmalDmbOToGWQTgW4jJHx5EQP84An4
fxaBRUvfjFRjdssp6chKohsrIsygcDoEMM5BGSD+mPdTK707Qm74QtNTNEl7+Hle
rvji/nmOnSvhTXWS/d9G/XI4K8Bd7LdWhIT+nR1aaRdAe+Mi+gzkO5L7oCYIIUQG
+zxMqn6RY+xvDM/VI81qFwAQKOq52VjHN4RVl2u/CM4y7Xx86f0SMUprHlZUkQNE
IiwWZPV39dNTJBqATko1
=x012
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jan_2013_13_06_16_+1100_lzefWPhmnFZe8ttf--
