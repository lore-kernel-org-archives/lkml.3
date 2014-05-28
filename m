Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbaE1T3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:29:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:44361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaE1T3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:29:02 -0400
Date: Wed, 28 May 2014 21:28:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528192853.GY13658@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <20140528153548.GY11096@twins.programming.kicks-ass.net>
 <20140528160847.GJ29957@tassilo.jf.intel.com>
 <20140528170531.GT30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l5oECiFRo5dp+2y7"
Content-Disposition: inline
In-Reply-To: <20140528170531.GT30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l5oECiFRo5dp+2y7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:05:31PM +0200, Peter Zijlstra wrote:
> If we get the PMI (where denoted) we can actually reconstruct which
> event triggered, by looking at which bit(s) flipped between the recorded
> state and the current state (due to E coming before F)
>=20

just a bit flip (xor) isn't enough, we need to find the bit that flipped
off, so the condition gets slightly more complicated.

--l5oECiFRo5dp+2y7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThjj1AAoJEHZH4aRLwOS6RKcP/3ogfblj/Z9sFlWlgNFhbKjT
RpSvJd8hyG/jsRY4nmWer4SQzbZD9RIioktG/rUiOGr9Ata6IB4sOxH/LYfqrT2q
1B3/0bLmHVct8ocVux0jZVP8Rcnf7vyXNNACM6p9oPSeqRIKSJwchmaUAxLhiuEU
/ODQ9GX13ztCTyxT9urR/rEzfybu+9ddYKfpfSFs078p15ti59DIuRoHY1DLuQVY
kpJCYGQe6tUSXtrGd5gND14Vy+a16iy09IAylX1zjMxenmyLTVvNXB4LTyK7ndno
wLkU0y81VaQVkFJ6TD0ZIfTDA7M9I27JjsZgp2AkeS0zXXYSdS1JZRKjUX+pM2K8
q8TFKUB45/wgaGzMuY7iKtDzyqVW0zmG6w1ZM+lavs1hjXYsZWE4Cvj+6mpCNycM
SdAyKnA5uov8InsYxmfpLwORNCZvGbrB8/0F7EPZqELz6b0ehfwoMcXbV5akfUDe
21T+/K/x5HkgF/DHeKRXg/mE5WJTWJGdhhxdDcZZSacG8QrUg2cqdJOgk2ZB0n3/
tv+25jgAPxl1GHLIFdSoAZaNcrIi1pkxysy8XFemxE33sARAIn7dRNBrbwmScqEt
ia86X02XkaApztQtmP0W18QBppl0U0ABoTnOCBqpzFnhpNkdz5XsEm5KAq83lzcO
jRoHVZVhJLrEMopK46nL
=plhx
-----END PGP SIGNATURE-----

--l5oECiFRo5dp+2y7--
