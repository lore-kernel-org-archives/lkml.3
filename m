Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaANSai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:30:38 -0500
Received: from sauhun.de ([89.238.76.85]:52289 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANSah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:30:37 -0500
Date: Tue, 14 Jan 2014 19:30:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/amba: don't check resource with
 devm_ioremap_resource
Message-ID: <20140114183034.GA10340@katana>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
 <1389700739-3696-2-git-send-email-wsa@the-dreams.de>
 <52D57688.8070105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <52D57688.8070105@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> This looks fine. I expect to apply it for 3.15 after the 3.14 merge
> window, unless it's urgent to get it into 3.14 for some reason?

Nope, it is not. I wasn't aiming for 3.14, it was simply in my queue.


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS1YJKAAoJEBQN5MwUoCm2KlsQAKz/uNzJh5VmCSYB3XN/4gOE
kXEM5LmVOoRlXHFl66szL3TFyTQ9Q7qD691dfSLQCDbelQhYA5WEe4abMF1Gqr69
int+Z4h7sjFjXyzMr1CnhvoH7a42x5gjq0ORQs6M9F10f32ziEMH8xX2skN75vL3
9XsOWvnBZ3bKC4pTVSXN09FhrEzLZB91bSx5qamcLC3R/seRMlin1SZylLQa/AfE
4el1U1A4psTntgRs8gDDIJOoan6dN/8/FjW5MVuKnw2reQpLt+BvJKgEVi9yvjKv
Gw/XJxwx5j+Tut/kkxrw7CXtE4q/xk4PFoEQiVvivBKgmdP7s8s9Ech4jvMhPp6f
hgLbDnq0DnG0ogaiAcDqA7Yepa9a7mzwPu8Qo4XVheFXk4sbbwsIDDp2JRB72Iwk
VCUgE36JITPBPSVUztl60v1X5SCD24Ii1wc99djnN4gLRpED52kJZzlFm826QoPe
wGDcWsSlQ97S+9H9WmWzHRMv3cbJELEUCzbk71hGV+oSDQxiv4dfZT/GDok7MxJ9
03YSmV0PkNIlHV7soVAz8jS/l6qpuUQBqboRmWtG3bD+DMVNXoZria4/MrASeTND
jrH5fDY7BRlJ49g6g5SNm8qS6CfwOqJLVLjXHG8PR5M135qerQO4xjNDp8FTs8ul
XKrNvp7p63YoYsqKuDzu
=gNUN
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
