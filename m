Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3KSQAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:00:16 -0500
Received: from top.free-electrons.com ([176.31.233.9]:47408 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510Ab3KSQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:00:14 -0500
Date: Tue, 19 Nov 2013 16:56:49 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] clocksource: sun4i: Switch to sched_clock_register()
Message-ID: <20131119155649.GB1029@lukather>
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
 <1384559315-18699-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <1384559315-18699-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2013 at 03:48:34PM -0800, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface. While we're here, mark the sched_clock function as
> notrace to prevent ftrace recursion crashes.
>=20
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSi4pBAAoJEBx+YmzsjxAgq5AQAJurcLhXgK/xUIpGZ1nbxvRB
8+bjAIpjBJrvM6SZfRQ5sFx/lwzPyG6JszVy6y9Nx/X8uln/XFmuOeXq6tn7vFfW
O/OpRLw6VaMn248qLsmBJVBqe6uh2u2BXQ7r8R+inx6U1dAZFMZZBSrMHHTsjSsY
4rGZShOMFfSLMvUi/ZlqJn8SXkXTZRzdUBitJSYUoCS1QQf4L4hSHq+Ni895o8q2
eD3B2A0YuIzg9JlJRNS7e4goMn8CJWHYjJz52g36J92nG3UGFFCR3NK/8q2hRZ81
rX0YEDSRrRrwNjJ6mB3AiXSwVb2wA0FVt2jsQz8heTLZuYbD8Y6zK30773se432K
hFhwlj/SpeGLOiiey5jOdEGjBjqYVp7pc/dqv2QURgbe9HwX+LudR/Ln+NSX3C3T
hHd3UrDo4P70ubS2u5eE8JcQ1Y7sHL0zxWg5AKRwXyPK2QNg6sNj0yQWSz+JhC8D
UgYkbW/Sc6iBIpsJal2NmNKQgUwTl5GhJ9OLmXD1bWvGZt7Nx0+pOKsJCFaCOay7
UFQMY89iXwIFvOJ9g22tGTpVVQ7XNUx0dPkrhDpH35I6HHmhdM1dN0G9qqa2r3w0
6eDSHBg7QVlntpekdxTqqSObm2txh2hcsPn6455oyss2ix264lu8Uk5B/Hcs8+FF
td3chh0TvMhFCm2WHqL/
=38Yv
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
