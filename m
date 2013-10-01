Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3JALFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:05:32 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:61814 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3JALFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:05:30 -0400
Date: Tue, 1 Oct 2013 13:03:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 1
Message-ID: <20131001110344.GA20249@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

	git://gitorious.org/thierryreding/linux-next.git

A next-20131001 tag is also provided for convenience.

The situation is pretty much the same as yesterday. Some conflicts went
away, but most remained. i386 and x86_64 default configuration builds
show no breakage and ARM default configurations are still being built.
Yesterday's run didn't show any merge-related breakage. I found a single
build issue for i.MX which was trivial to fix and sent out a patch.

I received a response from a few people to the conflict notifications,
so I won't be sending those out again. For those that I haven't received
any replies and for new conflicts, new notifications will be sent
shortly.

It looks as if I will be able to do another linux-next tree tomorrow,
but not on Thursday and Friday, so Mark Brown will be doing those. If
anyone else is interested in helping out you're very welcome.

Thierry

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSqwQAAoJEN0jrNd/PrOh+sMP/A+HP88gqyHINs957Rs8nEmU
upATkY3ZlsGXjnwlqKGMLgqP0x4jEwYJ+GstJbsmexQ5nS9aO591rHkhHVaPc/0d
6pymfortWVPAb8PVYqcFJwUX9J3q8ZFu0/5QQ6Kj0bBJ8+KBaNxNSM1ItejkgfaR
CHfSULG3rdZafIXZggHoH3hhx568oIzTtzW92ibluWrf3GvJgtzdGRD0Ak53Ws5Y
z+tSflZIcgl4MCyWNlHbQjD0VXVXhnOey/UVRXplS6OH+AXgOH49z2y0QPaMM9Xh
fjpDvQDFJ+mIqXsUrgMpyEGzF/XcWvgTP6n/DDDK+DzhohiBnxzHJi4Yb1NI7z2H
Ehfp8AUc8UlmVVX97VfREVn6SAVdAiJnMiA65U9fUuLYi2n7dsJDJUVb04qaH+OB
q9mdK/VB7YTEvP17P2Hw2R0o8zDuoENibb3REOzw4B511WU8W6EUppzzSZPmouqO
AfccB6cOKpHodF1IUOdm+9nCO09LRknwon633D9dxmN2J2JF4fkUH077ddCl4HCn
WJ/x1htkskmqXMT4PbiTvY6JoCMolpvv+SbYsgiRrvYpHqzTTzROGPAl6o+XHx15
HVEo9uUMZZlzwWrqLzpbaSVaVnWnK4yvFTDF77iZZTcCHoWykzrnXIwkicRI50lK
a0jHJMfV/6NMdQD7c/CC
=KeTd
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
