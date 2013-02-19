Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab3BSSav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:30:51 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46992 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab3BSSau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:30:50 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/1] early_printk: Consolidate random copies of identical code
Date: Tue, 19 Feb 2013 13:30:57 -0500
User-Agent: KMail/1.13.7 (Linux/3.7.6; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
References: <20130219124038.365937990@linutronix.de>
In-Reply-To: <20130219124038.365937990@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1381256.Ym9K5LIMLt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302191331.00187.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1381256.Ym9K5LIMLt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Tuesday 19 February 2013 07:44:29 Thomas Gleixner wrote:
> The early console implementations are the same all over the
> place. Move the print function to kernel/printk and get rid of the
> copies.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart1381256.Ym9K5LIMLt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRI8TkAAoJEEFjO5/oN/WBGW0P/3hnQsCXMF2gnu4akQytlQl5
an6lPPz08nTiPLgFAe05OC5YiWO2RxL3HvG0Qx5x/Uop+wg9roju6EbBXPBytbdw
w221MRn6TLAa1taVCM4IzbfSy4Q9sC0BsIPtu2YlBMpLQMt81RNCNSJ7Zka7wYhf
72IBpKMXimlKgRMg38j6KgEXVbXlkGwkCMC+pi1qp7wqzQLD96BwZIAi10wWJsV2
D1HiCuOgjewCKBiOhD+oKYH4758ieifxpeoTK1Du0GueG6d9jT8MV4IcyhDUQWtJ
1spBjS7CXda+7eW425rJBeYDYqfGQD7yrumVBQkWgeDLq2xOoOm7034ZdKsP2sz1
Z5B+LojGgwWzVRMDz8YMefGtBhU/uazGl5Lg6Q01xQ4xEeLd+3IZIwby5tIiXJHr
CAt/pB8SCpW2+Pn9efGmSKJFs4kiFWLEFnaD2r5r3u29xathHJ2fSlbaCNjYUm//
at/CBPR5dwH5nqEAoPJwGax/CzX3x/ZeRcSPuh4TjQzJUV9LdJ1Z4ytnOwFy7KV/
yhqEQhqLEyFnXiOeHg9mz6UmlljprSsM3YWk7svOFjswgSUA/xd6lEmPRIfWh0r2
L2VvNeZ80/RjZti/74OsOjDQZp8us49lMQC2XfMQI9XwD+Qw5cbVUSLHPWvSLUNh
A1h2yAj0kNk02ZSsl5RU
=KyvN
-----END PGP SIGNATURE-----

--nextPart1381256.Ym9K5LIMLt--
