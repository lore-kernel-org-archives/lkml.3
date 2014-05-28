Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaE1H7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:59:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaE1H7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:59:52 -0400
Date: Wed, 28 May 2014 09:59:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [RFC PATCH 5/7] perf, x86: use the PEBS auto reload mechanism
 when possible
Message-ID: <20140528075937.GO11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-6-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UaIp6+ubhcbWp687"
Content-Disposition: inline
In-Reply-To: <1401257890-30535-6-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UaIp6+ubhcbWp687
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 02:18:08PM +0800, Yan, Zheng wrote:
> When a fixed period is specified, this patch make perf use the PEBS
> auto reload mechanism. This makes normal profiling faster, because
> it avoids one costly MSR write in the PMI handler.
>=20

You can't do this unconditionally. Like I think you mention in the next
patch, we need the PMI to fix up lots of cases.

--UaIp6+ubhcbWp687
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThZdpAAoJEHZH4aRLwOS6ChAQAKlRuAJ3RQ1ho/GVP2D5fMGP
YGws2lfQVYqeNPhxc92GXFyn9BKQIF4IerbAOqG9fGKIJWaRwDq9gby1uk+thgve
ky6n6LN18Xt/mflNZPpHts9o9o9HJZgIKrzowttHaVWBK1MlBJ0Qiz4ZdBBRVjWE
vadnqxHSBxrlaHtIXU2cNx3/tUeIidBqPmmBi7qbLewdb2JGleVP7pDvvRdGBIIl
wEnXaMSO3pDEsvqEQEQi+bxR0eikVoDF9kzytODVewRoXvge8OZQZ8lkgTX3eC7a
xeSZC5p3Z7CenFJhqrmULLsjbCUC8ErL+q23mmzKPtcpjiDQaZvGr4oN+XM7Aqga
ASulAZp2somM0FFpVURebBlKMD4R5lR4plsQA3Khs8auQQfBvdVK/dLVxb+Sz4Iw
0U41Nh9nnMYjLXwv4oXXpkEz/4jK4EwwOj+6XqX22ukxABtFGXkBX64uANzyyn4m
Y41tDpNtdk1pH4XNqfnoKMZZYJFuA1bDvaWsVDclatAnixqDi0LRfO4e59nRfT/z
N+qURmxjDgHGjLMiQFwOEyX3XccxTd+GXyRg50S0YgRKMjvKg5/JOkDEKn9xLxqo
+pEO6Mgp7MerFevOoAk43r3/R78lHmx6JY2JOC0cnOLRY7heU3pgSBIuTAoDy+6F
mcIBLPLZFl9we2agPc52
=jfST
-----END PGP SIGNATURE-----

--UaIp6+ubhcbWp687--
