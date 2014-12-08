Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaLHBG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:06:26 -0500
Received: from ozlabs.org ([103.22.144.67]:34302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaLHBGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:06:25 -0500
Date: Mon, 8 Dec 2014 12:06:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Matthias Klein <matthias.klein@linux.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
Message-ID: <20141208120619.68287b54@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6yZr7PafkkPqsojDZWQfZ59"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6yZr7PafkkPqsojDZWQfZ59
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Today's linux-next merge of the bcm2835 tree got a conflict in
arch/arm/boot/dts/Makefile between commit 302a5ef29d49 ("ARM: BCM5301X:
Add DT for Netgear R6300 V2") from the arm-soc tree and commit
6298ed17a404 ("ARM: bcm2835: Add device tree for Raspberry Pi model
B+") from the bcm2835 tree.

I fixed it up (the bcm2835 tree patch is also in the arm-soc tree as
commit ba2a1d6959ac ("ARM: bcm2835: Add device tree for Raspberry Pi
model B+"), so I just used the arm-soc version) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/6yZr7PafkkPqsojDZWQfZ59
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhPmPAAoJEMDTa8Ir7ZwVHx0P/1ff9/dAZnFi/6f9CSPLdDg1
jJOHrZn6YiZUdLD997cxmMe+MIngPffz8PCpYJ3dIAXOX9rGE9edrLulglS18k8j
k8yo7gODN1ZyZkhXjyMrOyZlLI3WmftEGmVxTNeuPAoSQWhG6yF/QA+WB5g85JbF
ku6GTB974IwrGEytorhSoooEK0Fe2tubSaj77d+9WcyMa8kqNtZPrBH1WEtiQvlC
OkNx1HI/Euu87V8e7XLQqYvmHa4rZdCvoJ8hHEfBH0ZuHkBO1wGinJweRDa2Ldum
+NL1tqcM5zceDFz0rLZufw4IV6NqL/OsMip4f+uIqTiOpydns9cy04eocuLbII1H
KZCdMY1tfKbnQyWsr82rNdI53RTwgvXU4QsptTg7zxUEhTCScpCiKdzTZd9eNqTM
jGo2zPWfD5q7E6p6IKCTcFhanmhZTACmXhvdPkOgpgc24l6iFYWBXhpD4zwr01JJ
2SJJ+qHhFa0wYR4h/o6+zl9NcpWAXM1W3GAEtlKxNSBYE81cDxKldnyDm9J/+GCh
uG1PMZr9pUtwBPIhvsJT2zuMh4NrdQ2IXZyi2eUmGv9pYIOibobMOhhyBAx0KFuN
8b13+Gx4oDRcekkv+ng5bzJs+oFJoxvjWccUrUoMhhoLZ9YlrZpHtALZK3KekY1V
pk/kcaxETPgMmHxBXmg7
=xf6Z
-----END PGP SIGNATURE-----

--Sig_/6yZr7PafkkPqsojDZWQfZ59--
