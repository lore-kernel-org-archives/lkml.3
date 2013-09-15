Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3IOX4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 19:56:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40649 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3IOX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 19:56:30 -0400
Date: Mon, 16 Sep 2013 09:56:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: linux-next: manual merge of the h8300-remove tree with Linus' tree
Message-Id: <20130916095618.ebbe64569b730dc9bd5593c5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Sep_2013_09_56_18_+1000_MbhPV7Xwydt_F8JG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Sep_2013_09_56_18_+1000_MbhPV7Xwydt_F8JG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

Today's linux-next merge of the h8300-remove tree got a conflict in
arch/h8300/Kconfig between commit 0244ad004a54 ("Remove GENERIC_HARDIRQ
config option") from Linus' tree and commit d02babe847bf ("Drop support
for Renesas H8/300 (h8300) architecture") from the h8300-remove tree.

I just removed the file and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Sep_2013_09_56_18_+1000_MbhPV7Xwydt_F8JG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSNkknAAoJEECxmPOUX5FEjjgP/0pXGp6BXkRKjmgVbKsZKu9J
4Lq8s3WoRRoUaS7qJ9EzJWtrYESShGYllcRNSgXaUSz+kpWkzSwZr6S7KVxiXsis
vgZux0jV4/gpNs7vWPTedsHRhNi5qxEPV8ZBYJHUK35j7z+GNB6dJt9zZVYwVhSp
mhU11kCTEZgaqfNfiYMwHZ5k0NMd63OLAKHS41bHxCRRvgOxt+hv6z1q1P6ogf4W
hJSsADAuvI2A36XmLCq1AY7KyJnbotcZyr3xvPu9r/dI8LbHd/FRYu7xCZBH+PI/
5cBe000p5fosJv9d8OvJDkgjB1LUlh9WyjookZHbgYzhjkIZgQSzZ6+Yill5Bd3Q
IwOROSjkQad2xFe9jBqJ48Yv04E1GXxDVyB4K6qOwpb5YkiTS6sCC7QmyK3Tbe06
GcYFXJH2tBIBx+VGRFcouW0eAyBXEStMoiinNjChiVvfRxo2L8iJaxfxcN647Rym
vYbH/ebjVoTSMohpnNc2s2zhrrZhO4MUEHQLxuLG7wlSb5SQNEijSiukNPvFUuuB
BZfGLVp8O5S0pDhBIRUMLONraqwKZvO8JEh0+pxVa6pnwCFL0W2roVu6pzAfndnF
GU80fkt9l8xqca4dRUd9KX4u8Hy6KnQSoMoH+Kzhtozc5pPwKFdGXxruzo1E6KHm
2s6QV85xTs8rLHIExYxy
=ds8G
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Sep_2013_09_56_18_+1000_MbhPV7Xwydt_F8JG--
