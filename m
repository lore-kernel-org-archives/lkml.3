Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaE1HAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:00:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaE1HAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:00:01 -0400
Date: Wed, 28 May 2014 08:59:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [RFC PATCH 1/7] perf, core: Add all PMUs to pmu_idr
Message-ID: <20140528065951.GL11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-2-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YgBy8fL35x4aZQ30"
Content-Disposition: inline
In-Reply-To: <1401257890-30535-2-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YgBy8fL35x4aZQ30
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 02:18:04PM +0800, Yan, Zheng wrote:
> Currently, the build-in PMUs are not added to pmu_idr. This makes
> a inconvenience for finding PMU by type.
>=20
This was done because of the horrid mess that we have with the software
pmus, some of which alias the same id.

I've not through about how this will or will not break things, but since
you didn't either, I'll leave you to sort it out.

--YgBy8fL35x4aZQ30
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThYlnAAoJEHZH4aRLwOS6IkQP/2Bo8gETvM7jpifQjE98vhW5
4yi9I+23wFvBd+WNRQwnnZ9MRo/Y0axtAVRdLjWFpQHXM7X3vgHH7odueAYF9vZA
PD2rUjWfEg6/H8AGQ1HTZ8BRjwjlLu6cYZOWZRZnNm9YpdvNMtpz9TMPg4aqal+N
JBQEL1b3x7EPe727EfZiY6hywoq7YF7fJdVMvnxahZlw1qgKLk9AWFD3ewLY3/5E
aoHUPEct24zu03sWRd8yOy6iymiWMTBqbcuE6YoMmF727y2CFcLJbr52/D/W4kTA
ye7ro/84Do8NQEwAds+71vq8c/Nyy8Uas1g83rq+V5G1/Ob3i+TeT2p4SJi1dOV9
7MhWv1yQq50JB55aHDCjNvfi2hszwWenXjgWSW3iM5vLmJuP6+BH1+BMnNHlZmEl
ziFG6fw+g43GWb5Zwtq0CswOrMVOmqxNjis1HUgoh4OHCvOaZ8dfcSC6u6x0fqvF
qSwtOEioovvB4r1dDZIcmYzFcr4sUOCOkuY54D0tiVAJKflWZnwqR88i9ACgfsqz
Hr3wccNeVnVYuXUDYnL59QNT1j1THURo9UAKdKS4ZJtvgvkhBihWyzTbegVYWX6D
DhC35q3K8HZOSqM/jsoZA99MVlIJRLd9S1yxOVTNcfKXtswyFwlGQMaVEgYE5FrE
lvpECOOuWeqkPYtL02ay
=hWmF
-----END PGP SIGNATURE-----

--YgBy8fL35x4aZQ30--
