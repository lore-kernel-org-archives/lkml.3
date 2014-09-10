Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaIJIAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:00:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaIJIAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:00:09 -0400
Date: Wed, 10 Sep 2014 09:59:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
Message-ID: <20140910075954.GW3588@twins.programming.kicks-ass.net>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
 <1410310148-26260-2-git-send-email-andi@firstfloor.org>
 <20140910075926.GM6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/tCzywT4ru0wuIhW"
Content-Disposition: inline
In-Reply-To: <20140910075926.GM6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/tCzywT4ru0wuIhW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 09:59:26AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >=20
> > The earlier commit 86a04461a made near all PEBS on
> > Sandy/IvyBridge/Haswell to reject non zero flags.
>=20
> What's magic about nehalem and westmere?

And core2 and whatever else we support PEBS for, for that matter.

--/tCzywT4ru0wuIhW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEAT5AAoJEHZH4aRLwOS6HWgQAJuoGjYjx1hfCV7Lvjk73QFN
hd0KPiCN9GJCElikmcAv8emqn128BVRh4CymBWqRoUujTluXmueh1IKHnZtdSOU6
XYBUqGHaedFj2WzvSK1CAc2y4jP5hiOxyLdAIE7p8vykuGxlEIKC3+3QGV+q0TGr
+pl4K+R5U0QuQ8r0+H610r6zOCILZy1KDitDX4f29Ugjmo+kIuwlzb4oTS3KV2yC
znnbKgyFK4U/Tuq5w/rULaLHNFTNGOvgnozaMaNF1ismF3OEm2+9tQ2vhZvTdI4i
Zfe/Lw+NAHUepimvLBzU+rPwL60SMUIipSD0MMbhtXT+ePSjBz/AxsKpSOV9PzuO
1mCx5puNBoErAzeF+RPyNHlqWrWDomV9LyykyDSlIZEzRPipCcmu7xLDS028AOJc
VXI8snVU6VBJRGRMzkUL/bm/bDMPnjkYimX8MJbMvxPXuvC+MxFIi1n62TDhO2ML
S5iWmIzLJhr+AzUrVAWK8OgCuxh+1APpD9qlN9zhDK9tGlQQbnzB6nzVNT8rVi58
Im3ORGsruFaVJ7ZtdyQ8tncVPp28nrVgkfAqWdQiPhBaBLtz+MsIRi8GHJQ1pWiy
SBB4ouiAU1NT52bTcLjN/hEHnVjjpi5OrzviGQZI3c5bmmOrh/AjsXC0M7QrjCnO
61TiTUAaxGrtvV5L2Ig8
=XGL6
-----END PGP SIGNATURE-----

--/tCzywT4ru0wuIhW--
