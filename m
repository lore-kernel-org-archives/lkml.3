Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3A1KXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:23:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49919 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3A1KXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:23:11 -0500
Date: Mon, 28 Jan 2013 21:23:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the usb tree with the driver-core tree
Message-Id: <20130128212309.58732e2b08398c4ecf326dfb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_21_23_09_+1100_NBcqoq8xZBDrPGXW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_21_23_09_+1100_NBcqoq8xZBDrPGXW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/musb/omap2430.c between commit 148e11349b0c ("usb: Convert to
devm_ioremap_resource()") from the driver-core tree and commit
ca784be36cc7 ("usb: start using the control module driver") from the usb
tree.

I fixed it up (the latter removed the code modified by the former, so I
did that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Jan_2013_21_23_09_+1100_NBcqoq8xZBDrPGXW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBlGNAAoJEECxmPOUX5FEotgP/0VMfemRu/ZkJA7/qaX6Z5GY
jqPKCtg8xjI3ZeTNYe3/7t30AHrwv3/vc4xcrwSqrUW8d16sLFHT4x6VUdFkyqek
e1zSSdV13BwMwgOGl4kJig9HjTNZI+d5AkFJcKdQGgSvAXeM+jOjmv07t0E/l/hE
KD5HmEwW3RXgvuorOmAAFbvxqAuhbNhjSM+9+4ZV8GdYsnI6IDXjCZ1yJ0rjATuP
4zeK3YhkEK7LGKe+vKZ4miZ+ivgVc4mMRAbi/mEuYQVHm2+EzeuGmWkn4Q+UYS3c
qxS39GTiAVxdzer/7kxrSXLKUpi5hbXC0Xspjlumj9d0NwpgOiGoG6w43qvChbrm
EJn8D4gZt22M86O81oWnQbftHq1mL47M9gndqKPM+T25P9+XLcLlSkf7BTSkzkgF
fzcWzlONSbwnuFQIz7MNkYkV2O/OWHsklTMyZPKxe/CdABS4u0M0v9rUrt7XuOsW
Kpk8MfY1h0HBRPQ+KIrVLkZxkK4Q8teHZGDu0w0h7tQAg3f1j3mtedoJzIpz/mEO
ywl/ApYGhOSqY4mlYKnduJ2R3wobKu8UBEi4eSIrjNXvGhG4ooMAOuFm3YiTuWFb
WEemwj1XRo7RPTNGwidrMreawHKR+a3E05bsfNZDyBCd7XAsiLlN//bruGTWpC9z
cgFU78FczGqYb7AJ2YhR
=LCOF
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_21_23_09_+1100_NBcqoq8xZBDrPGXW--
