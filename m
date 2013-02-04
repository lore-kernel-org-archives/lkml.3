Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BDIDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:03:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:27769 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3BDIDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:03:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,597,1355126400"; 
   d="asc'?scan'208";a="282398436"
Message-ID: <1359965101.13791.11.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: fix random pointer dereference in OF device name
 handling
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 04 Feb 2013 10:05:01 +0200
In-Reply-To: <1358967548-25491-1-git-send-email-paul.gortmaker@windriver.com>
References: <1358967548-25491-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zLB4sqBWOty5dL5QyLzB"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zLB4sqBWOty5dL5QyLzB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-23 at 13:59 -0500, Paul Gortmaker wrote:
> Here is the output from an mpc8548 based board.  There are
> three instances of missing device name here:

A similar fix is already in the linux-mtd.git tree.

--=20
Best Regards,
Artem Bityutskiy

--=-zLB4sqBWOty5dL5QyLzB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJRD2utAAoJECmIfjd9wqK0sIwP/1ro+FypPr8AHbAPiv9pzSln
OCgaUBBAqE6exD5hfjj5GGCzfLtX6IpyAH7zzxLvFttEsEakM5dmzYdgok80Gqg7
NQyBSxphcWKB9VfankM5LRUzN7y/enNXMuTSIZu1rXZ0KBwwNc1QrNIXa4BNlFxx
E1e4CTF8JkQXxBL5o/Vg+u0mZ76Aspfcj3Q82Mtx4nA6l3fPmvU9SbyuJpkFdZ2e
fkRWLxuQknWx6QGO+ViRzHQUvCA2McOkDt8yfIe+GFdA9mn/XgGZ0DulH5XEaKIL
wMebfwRTOOJszEi+KtbxVtJ9BreTCpaMu5fqjzyNCs5Xx/qwC8IFlaE+HzRZXdx2
P5WIT0tva+0TC0EKE6eUARmM8xFrIFq8vWv9QuuDugtnYHsonIscLdZrNa0Gwci9
H47+RUKJPdNQRlvsuLCI7dU81nINvjOSsl4+GArrPqb4YrcpQl9RB2ajyYLPvCbl
QVTeNRKRlFSTiL0B5PLeCEWBv6cYFGpqGoeai+/QvLxnuOFg5+nelpfxxJCIaaX4
phEG0LXtWN3baUP1poXoPdgDuiq/Rc5hhH1Ls6bNntPTl26fitQsTdqTxLIEu+Ts
eVRDbG7c5v+VQGOyfYIQLqn24MUmUjL4JV0BDaJVk2DLrN8Q8ZIFyqx7Zpte6Xug
wgGUVZTQGvgMq1FqG8FF
=k2d+
-----END PGP SIGNATURE-----

--=-zLB4sqBWOty5dL5QyLzB--

