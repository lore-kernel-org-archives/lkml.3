Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaENNzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:55:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaENNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:55:23 -0400
Date: Wed, 14 May 2014 15:55:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514135509.GL30445@twins.programming.kicks-ass.net>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
 <20140514113808.GA1278@localhost.localdomain>
 <20140514115406.GA11096@twins.programming.kicks-ass.net>
 <20140514121122.GC1278@localhost.localdomain>
 <20140514124150.GB11096@twins.programming.kicks-ass.net>
 <20140514135116.GD1278@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d5L/0NH1d7AMGItx"
Content-Disposition: inline
In-Reply-To: <20140514135116.GD1278@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d5L/0NH1d7AMGItx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 03:51:19PM +0200, Frederic Weisbecker wrote:
> > Anyway, if it turns out to really be needed, the split list doesn't
> > sound bad.
>=20
> Either that or we can remove LAZY stuff and wait to see if people complai=
n :)

How big do we need tested? I'm fairly sure RHT has some medium silly
boxes to run things on.

--d5L/0NH1d7AMGItx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc3W9AAoJEHZH4aRLwOS6vvAQAKEQ3ta3beyQ6IVVVqSgAjXG
0ACBW1WdpYgiv1gdPvAwD7B2WS3B2au9U+pT/aq+zd11o4BgvajDPrP2PePJ88n6
EFQJ2j2ePWGH76oT0ztS8ciTjYRCcW8oIXuC9VtTbFr0uBt2C0SN/uvRZXm9ZeYE
O5o74C+Fr+MLbLvTjG1IeM6XKMdNkn/79dLUfkGQHtjjNVW7GziVs1RSmwr3OAJl
wfSsq29Xzk1gBuH12M+Y2M/uVOCkq+c1+wqHC1bx7ds06Rihv7W/Ka0X/oXE0xle
ANeC02ilY12XF5qhnmjRrrSo+3tdB7XkA6uPYHWNjtjnaTLzDeTAHLFvOeqa6/Tg
OWHb27n/m15AOpXFIISKtmD334cfaYYDHj+zx/wJcDoWDMd+9gNtHQIlSKHDXM0A
fdPXJsqoz968zRA2uo655D9CSws2eMEA/CMmOgSVcAh9f4Mftjur+ss4/BPyFocY
VX3zfYfrvJ6d5d7y7sapdjcb9eYK85eKfTI8wIlra0uT9usPGYiTmgVC+UKey6vn
Yz43bSGUAIb1rBThHNDvQB84dPsjfnPmS1JUUKheEmwFknZYI+Q+ALho7FUKa2sP
qX2eSpDdC0r5CW58dcCrkN4AVJ1euCHKAN33m+87UxH/aZJevkeMjIOOkkChmalM
bPFak+WZzLBHaO/AwRjE
=XU8j
-----END PGP SIGNATURE-----

--d5L/0NH1d7AMGItx--
