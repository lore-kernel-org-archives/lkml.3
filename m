Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3IEXI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:08:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40635 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3IEXI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 19:08:26 -0400
Date: Fri, 6 Sep 2013 09:08:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: back merge of Linus' tree into the vfio tree
Message-Id: <20130906090826.947212e7d5383837bff881f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Sep_2013_09_08_26_+1000_39_qIMhPXIIZUKEd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Sep_2013_09_08_26_+1000_39_qIMhPXIIZUKEd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

I noticed that you have back merged Linus' tree into yours.  Linus
usually takes a dim view of that - especially when there is no
explanation in the merge commit message.  i.e. you shouldn't to that
unless you really need to - and then you should explain why you did it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Sep_2013_09_08_26_+1000_39_qIMhPXIIZUKEd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKQ7qAAoJEECxmPOUX5FE5HEP/3vh4FdyUh2GOdC/OC3oVrhC
rborWwf14FoaDeZmUu9Su6/I0gJD56mwIaJwC3LilFqTD1rY+20+DyVLX/N0GHe9
tdvV9QtMhHu7Gui8EkMPeuslpEti2TAM3brXhudK59y3xsbC8bkq0QOKstlGR24C
h1Z/968Skrzs3NjKLGhgJq1hxwi6b3irbyAXdNR4Fjc+jXlAWYIVGki/6gFNhXzm
8q+0sXYQIizWr5hIZ4d7DmWqw0uqPFQ5ODxD1EE0MN0/W/54RdjmPRlL20joIqn/
WnsuPk+3D/sEf7k2jBanoL7cvHZiukELAU3Y+CpzQbDqd2KoSz9URJ7NZRCw5bfr
qhl7eh1Jt3NvMip0ommbSNXvtl6fuKGt78SxM565OWFaXvMHghNulCPXXb78hONN
IaLja9gab82XMj2s/i9rrxyEwlU9Hr15ZZewwimfvywth7OAVdcQd5u8Dp35hERZ
4otRpU3oNqQ9G/OWGJE1EgNutf4DjtDZxuWe17YmKxghinsjHWdeiROkW6dv1oim
Z2/0ihTAucROwDkJr4Xb20dcU2uqsE/fUzTXcZAN3lK9+zFKimhNedAVGiSHkgFK
K5xx9U9HMHl1A32bS7FvWGXJFzdQQdrWsYTHuKm7m0e7urRFcw0iulhGNiUqKaD3
z6Kz3/01wFpNE7IFO7MH
=eYpg
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Sep_2013_09_08_26_+1000_39_qIMhPXIIZUKEd--
