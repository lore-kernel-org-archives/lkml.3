Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3LRBAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:00:38 -0500
Received: from ozlabs.org ([203.10.76.45]:50564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab3LRBAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:00:37 -0500
Date: Wed, 18 Dec 2013 12:00:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20131218120026.aa6c48feca3e24c59b5bf4c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_12_00_26_+1100_5C2wyKjp8w6h2Do."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_12_00_26_+1100_5C2wyKjp8w6h2Do.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/acpi/nvs.c:15:27: fatal error: linux/acpi_io.h: No such file or dir=
ectory
 #include <linux/acpi_io.h>
                           ^

Caused by commit a99493647c1a ("Merge branch 'acpi-cleanup' into
linux-next") which incorrectly reintroduced the include of
linux/acpi_io.h.

I have used the pm tree from next-20131217 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Dec_2013_12_00_26_+1100_5C2wyKjp8w6h2Do.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsPOvAAoJEMDTa8Ir7ZwVF04P/3ldy5PMtkV3pAfrStbJzG2m
Y906K7wT8n6thKqKx4X9zcRquULvf3hGBDUoMH3pgpmDzH52Db7ua/E0ge0KhO+B
ncLXOoknZvPHtfLcbYCEnLrK9fZO7ZYaoKRn77JUeundT56fzkHE87wQ8dwR/9co
O6JGlZidhIsjunHaYs7Abxor1Y9AxD2YSmp/sY/Cm3hAGI5RjxOhmWUX4WMDvDy2
CQmh8j5QkGKvplkF5OOsjC0vWYrc5/Z36zdvd+JEe0C/Zczx2NExniRLonUjMt2M
GnOpnVJPR+jHB6LkNlGqf8Ez69gbo/ZzKKPI1vZLeET4GeFjhKEujSEBeBFkfIMz
fY84ZIqvqTis41LPs4JRDMLhoki2A64adonhV7Sw1j5QibTFz/Vj0UMleXPodhvt
1OJKkl3YHYsldftHBea5gJ+Dd0p73niU4tc2QoDivbhNumLQ4kE15f0AC2WEpbnv
dGQN3LgPHOtF39Cq5PM4ry+kyrqBq2gYxpLG4hda6P4+pPAiZxU7oD1pGzgKLyz5
qHzqFcK2QQBBsJLPx1lvIuRgcZyr9m7ufjxW8xCBXDYgP96g9DznP7WuPpv5cNRn
LDJbAAUQQt0ifYnOJ93To8AnvHGXbREKhCWud8aa0dAIcQXazGOAKGafyUjEctlB
/qMSePRsKHv/yovmDdqC
=e+wz
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_12_00_26_+1100_5C2wyKjp8w6h2Do.--
