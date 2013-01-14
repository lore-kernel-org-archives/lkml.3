Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3ANAD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 19:03:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56448 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3ANAD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 19:03:27 -0500
Date: Mon, 14 Jan 2013 11:03:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20130114110311.a399f92e5e4ec730b380eaf4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Jan_2013_11_03_11_+1100_2GqNI1FC8YzbwKVi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jan_2013_11_03_11_+1100_2GqNI1FC8YzbwKVi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from init/main.c:25:0:
include/linux/acpi.h:549:46: error: unknown type name 'acpi_handle'
include/linux/acpi.h:551:49: error: unknown type name 'acpi_handle'

and many more.

Caused by commit c9b147cd9648 ("ACPI / PM: Rework the handling of devices
depending on power resources").  Please check with and without CONFIG
options that affect patches ...

I have used the pm tree from next-20130111 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_Jan_2013_11_03_11_+1100_2GqNI1FC8YzbwKVi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ80s/AAoJEECxmPOUX5FETvQQAJdg1yNsZUVG9Gzm/20NBRX5
56/PBozMn2gZmnD8VYy4Rgx6oH2xo+pzNaUrm/KJcbR5ZAiiWrLI8oxm5VAgF8Wj
LCqAw1ft9HvQ9iJwsEeppc8Wwiq6h74pke87zk6BM0C6feOUzqC4cj2arH0N0dns
r6rdFxtkrx0NhNZPD3tU+luTRUjdczC0dG7Sc5RuRcR6xkfhi3lLwR6ZsHwgHBel
Vfwwktbja53wC04ldD3C+ttpYuWoodOUquIuPTD1WJYvKxcGYApKXDRk2wHITeD/
BzqDhEJ0PnafzYl+UCzMQFeMEHSGjAzDGjTEsuXGseR2mjWzE7qjlCvZL4p1JfXl
7ilOFNOfSuiIRK2syie1HmMwWyT4ddmDRa5Od7uCvlblw1L4nkzawJYQSHdqFSKb
laZyuHJSNnP77qc5CPrZV/W+P6Zyp9SZLQpcfShz7lSLcbZg2OWRD+YRkAJAj56Q
Xx9EwGBaed8Su1H6qq+7sbntQBT5Sm5li+9ZgzMTQln8h1v3mfSIuIbNWcDJQJb6
ZK3fMuzj4HsQpDSEZNHm/n4oVDiSLZ7wC+9KPXWA+yytRPVoHeUE7oFk/IZzc2iz
D3lbFI5aIRXnGTLpCO9oHeOlcmAomwVeo6onGNkJdiIIsJHc50kKN7VqitH5vCVq
EE+V8t0yIoKMuMI84cfG
=RFQO
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jan_2013_11_03_11_+1100_2GqNI1FC8YzbwKVi--
