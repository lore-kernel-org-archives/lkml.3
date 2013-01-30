Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3A3Isv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:48:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44152 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3A3Ist (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:48:49 -0500
Date: Wed, 30 Jan 2013 19:48:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20130130194841.abd832c601b21c3e67aae4f6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Jan_2013_19_48_41_+1100_=c5eQQ0eH1lo0t2B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jan_2013_19_48_41_+1100_=c5eQQ0eH1lo0t2B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `ipc_init':
pl320-ipc.c:(.init.text+0xf96b): undefined reference to `amba_driver_regist=
er'

Caused by commit 970066f5b269 ("ARM / highbank: add support for pl320 IPC").

I have used the pm tree from next-20130128 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Jan_2013_19_48_41_+1100_=c5eQQ0eH1lo0t2B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCN5pAAoJEECxmPOUX5FEbzQP/i2UY056uXn+iI1vZZfxLKMl
Us25z739Q3RYt0uliAzTXYwMfX8yv9iZ3o1lcbVdcYRqisjZ+4Xm80QSvTWotmDR
vPHLm4J5XFm1RaIPcZ1WMi2NA7255klgR148o0IzDHQGw3FdG4lFw+x0gaQjpdY8
x3Fu01oFzdRgmnqbRxslENtZi3Sk61Wd1+LnBIvOG7XXTbWN/NCKeaEJcXJH9JhQ
yWXxQOqIrW0dCOeWiCe6d8V8ai3gQ+8U6ESa2VnUqHg7syGhj1mjuQkoMwwcPE+r
r62ZFSh0+dAbspf4WH47t/coRHkou9qCcmLgm9jupa3qVpqs2ZKX4MabkwfT2EbU
V5CcQDvGalTlnp3EgDkwtXsXOVWRUIP9iYJybvTkaHFWxgktmWs93NsIbpSTR8z4
ixhIILEMWqTihdGPb4KC+4Sh8lKqaDIQdhIooshPqxmcN4ePJ6EE3pWVb+32x8WA
TBlfX5WfBTNxkLwOgNc4K66yHdFguNZkaFf/0CWKxzu0K+qsjJ3nUynv9bA08i9g
pgKSwDuUoTSRIXobZ4Hjs4bWCWhSVA7io4rdtjLEMDY4DF1miQT6GVz1soy7jvuc
n/HodM92KOlvPfo8h4Bvi/mpyY5Z/26wFUi4yyzpv19bAai52Gequ74aQ9QJY2yc
w92asj/i5hcedVTMy2GX
=D/p7
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jan_2013_19_48_41_+1100_=c5eQQ0eH1lo0t2B--
