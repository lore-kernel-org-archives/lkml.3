Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaKQCo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:44:26 -0500
Received: from ozlabs.org ([103.22.144.67]:39246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbaKQCoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:44:25 -0500
Date: Mon, 17 Nov 2014 13:44:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>
Subject: linux-next: build warning after merge of the pm tree
Message-ID: <20141117134414.7f4d8d21@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xwzt9o0X2U1LUHI05AYpR0O"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xwzt9o0X2U1LUHI05AYpR0O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (arm multi_v7_defconfig)
produced this warning:

kernel/power/Kconfig:132:error: recursive dependency detected!
kernel/power/Kconfig:132:	symbol PM_RUNTIME is selected by PM_GENERIC_DOMAI=
NS
kernel/power/Kconfig:272:	symbol PM_GENERIC_DOMAINS is selected by PM_RUNTI=
ME

Caused by commit 9cdd5fd742e6 ("PM / domains: Kconfig: always enable
PM_RUNTIME when genpd enabled").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/xwzt9o0X2U1LUHI05AYpR0O
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaWEEAAoJEMDTa8Ir7ZwVYZEP/2zhAzwtPR0D6EI+Ro/j3xnS
s9og01xxCsZ86HV1b6ganf79C0EkpVvdRmW1UemVJqmpw7RwP+4UapJzusRCl/zS
l7tYehxuFGEXX29ANTUzhuMsKNJgiVUvIkyD97Q4xOjYZ10xdaVsc6DVFVym5gzO
TSZzwCxckj8Shv+HeJhsSjGH+lfq/nZKr5O4lcdFvpUcNdCIg8UfWHjNITzbkZQR
nZMY9z1dOEJJpKjoUYIg0lIghXNe8MBSsqjKOBMZzZsoLDZmBVlCQMsgbgdNNArm
i7dZ38P9h/88Rj6RW4BGt2v9AMq9jGfIkf8Aqi2Nf5OpiSlsgpnwVI3DKEyG3R3v
TnsS6kvO79oZtyMNHNFpHEd5BUh4sND2NanlsqzaqS/li+tJgJc1h4gH0Z7fK5TW
fERdI6mRSQfvDhPhuYdIQhD3nUXwVji5c++FGCuvKERYBKjeD34+XdxBojO1+NWx
QbD7eB1Y8KkG9dhNYf+pIim7ZnqpWweWsb+H2SEAs5SeOlxwd1ZxI8Wj4Qznw7cD
CXcCqCfE0BmaCG1Aw+ldi7Box3mt63kGXdkRvNH4V+Ei4ghc+5JSf+lgciQ7QSRq
JOySigUi5MbRrOC3Ur8KbsBLB/WjstVzgsG5rjtuK39VQKEc3w2rDvRFDHPb7G2a
tHPDUWmD+EN7dr9xW8TJ
=OYsg
-----END PGP SIGNATURE-----

--Sig_/xwzt9o0X2U1LUHI05AYpR0O--
