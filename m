Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab3BMHj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:39:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58615 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3BMHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:39:54 -0500
Date: Wed, 13 Feb 2013 18:39:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130213183947.8f2a946f84d156272db38e8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Feb_2013_18_39_47_+1100_d54X5hpZtwrB5Vsd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Feb_2013_18_39_47_+1100_d54X5hpZtwrB5Vsd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got conflicts in quite a few
files between commits from the arm-soc tree and commits from the samsung
tree.

I took Olof's advice and just dropped the samsung tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__13_Feb_2013_18_39_47_+1100_d54X5hpZtwrB5Vsd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRG0NDAAoJEECxmPOUX5FE2HMP/i/p4qQFjJ3dswHTlytghxfZ
7svjT4QBIFNPz0yMn3DQGXe9lRL10ytNPBXPy1ICcUn2/uFFqwuLWSJoVcEfWtWT
5xdoWkgFzV/xIm6OoTzxIXWqijFo77Eys34SvtlzGOv9e4L6HEWwWgkow+oaneqf
Wu2YdUOKP/v8pRL0nTj5vZnTi6bnz9BzNdfXlJ0dp5JZsBpqcJGTG59DM52+4W7G
0h3VgwFOqcXi0k2cIbpobS7ry2BwBoxCz4UKvuEc65QvBb/dWgAfOVqQqLK9yEjw
AGsN+BoRdMW3iT6qg0YpM8AyeNfo/aRzbJdLAOs6hqhdjnKNcyyVarlkXuGRi/sN
SJZo2lYGBKpWHm0ByLVFKTYMsdoD10sAS/TUSNfeP0Oi+U1lY1azo8Qzk0QrFcF+
QjkAePfDbupQkkXrzXuVEe1+rVv5rcGDYop87DEWVUqw+vyeLAzH0xRUzeF21aVq
cZ5UodNPv4Kko5JoiA45Kw5hsPUwlKeGuB0BFVc6EdF5FB9zAyGcyNMRM0C26jbE
EgTcpKsBaX6G6cJFECOftM0a2XbjvfH6PYyvhnRHMFe58uS2sYdncERe3BXnqMIe
EorOV3f3wcsIrIQ02rVfpkVOrN18PFth8JSQVn828RALyHFgaxowszN1dU1orqzy
AjlSIzlLqxkiro4PcZuK
=lenK
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Feb_2013_18_39_47_+1100_d54X5hpZtwrB5Vsd--
