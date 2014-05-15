Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaEOHVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:21:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaEOHVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:21:16 -0400
Date: Thu, 15 May 2014 09:21:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/6] sched/fair.c: change "has_capacity" to
 "has_free_capacity"
Message-ID: <20140515072105.GY30445@twins.programming.kicks-ass.net>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
 <1400101030-17717-3-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CYbV4jyGkzCEppMb"
Content-Disposition: inline
In-Reply-To: <1400101030-17717-3-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CYbV4jyGkzCEppMb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 04:57:06PM -0400, Nicolas Pitre wrote:
> The capacity of a CPU/group should be some intrinsic value that doesn't
> change with task placement.  It is like a container which capacity is
> stable regardless of the amount of liquid in it... unless the container
> itself is crushed that is, but that's another story.
>=20
> Therefore let's rename "has_capacity" to "has_free_capacity" in order to
> better convey the wanted meaning.
>=20

Yeah, not really, the whole capacity thing is bollocks, but sure we can
rename it for as long as it still lives ;-)

--CYbV4jyGkzCEppMb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdGrcAAoJEHZH4aRLwOS67mgP/RiTFHzZq701X//dur+ZLNAa
reQIcQRZAEu9JBH7UiJL43+CcpsIQG6jGfxn2sb7fHDFu7Xku0HpXZFgqrZkTW1D
z7etuV2wKUc+9REZBQXXHkSevGRm1ygbByLCWz8wkTTWPVj9ozqW0TmEWaRdQmPC
2RC+36419dGFNOhCHOYOFKp0x35CcryZOb5XaX51HqU+oJpmNqx2XRuuPx/MdfVS
Z/Y5cWw9ZXFyczfqGsfCU3/ceMSa173YZF8Y/8uk4o9nw3N3Q902CDOAuuUrCoJJ
lbCCwhVT3S79ohfkhiBj1EcfN5a2YvfzVJXG0+8IsFhD4QIFtVsp6sZ20djxWiRr
KTaLscv85KLBuZztHh2bOtBlmePfNwsmHFul1KHqHgasFBzbnuQek8la3Jnq5gW5
XoB6Iw3pA5FiE1mpubxy4yKI8VCduCbnMhnGi5/C+d69nSiSBLSe+vDGnRrD2VVw
2v5cD+wKjlOJFlOQosW3LFeDt62Blkidc/KsnAHqWqaM0O8iwXJ2fKxK0BaPn4Zn
UEywQNpm/rTDa+jHXk/11LhfoFwHpOj0iTgjQjbIZUdt0HXwUHvBlcwc2MJTgUax
5uF3Fz6D/yPINrqhiry7i9XblLhu0C/EGhLQmgZEA1FFMORcBkB1xfbXRTrcuQsL
yOQ+/r4jlEicCd9Qoef9
=uCrT
-----END PGP SIGNATURE-----

--CYbV4jyGkzCEppMb--
