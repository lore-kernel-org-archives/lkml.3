Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3DHEVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:21:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39605 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3DHEVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:21:35 -0400
Date: Mon, 8 Apr 2013 14:21:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_14_21_24_+1000_EmJn.GmBvJY2KKpU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_14_21_24_+1000_EmJn.GmBvJY2KKpU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of =
function 'of_get_parent' [-Werror=3Dimplicit-function-declaration]

Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").

I have used the mfd tree from next-20130405 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_14_21_24_+1000_EmJn.GmBvJY2KKpU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYkXEAAoJEECxmPOUX5FEHOIP/1XXeT01+j7QaG1VS6fvmOWC
nu0AWxqeQqk7CHW5hfXod953sfvCzWKnDZNLQt5jgDY9RQbdFBP0ohq65n+HFiSV
zcWK7GrS5RMNjo2WAGrsFamJZnWmpBds9aAiRPVwbM0h0F9mL1l+UnUh5dQP54ro
ZZFuKPUujvL3xkWrci9rtC0CAAK3Zo8vrXZ9dffDOwFeOT+CEK6sm+CjYoK80Fvh
elcQbkld09dOrzIcmV2JHVHu6CkhVxR1Fkl3Gz6BVQUcgOhsRYhAitqhAh1vP4YO
gBMr8n4i+8IEblLeRKTTH+1FR+Qwr5EJCiX5fW8manuSSTRUhl619vu5W8XnVCJ2
tyKtZoeA+XYqqMmuqbDZaskD3r0HitmvRcrkJp5wMg3k61RXI2IAaNQ3aiz1bGB9
xqnkYJItU4IuH1vN0Cy8iw/cEHoFRaEVpo+Ln1MRSHS07qT3rVK3QKvxcMAvs9q3
ScvO3DPfDM30Tzvo/w0zEYYQekV+nP1yI1QdEXRDw7IZCyleTzLpw6Drhubofdry
eFkjADsAjswFAZJRecyK2rQo2nxLBJu/F7XIey+QH5/yLcM2REGmh4pXwhRrRC3O
KrlqQZsOpHF8CNS0NVzJBYJ/OsafRMt67BZribQ3D9spS3vUFdwKs81UssqEtvCV
p180LFaUqZBMuFvE1yuP
=Skhd
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_14_21_24_+1000_EmJn.GmBvJY2KKpU--
