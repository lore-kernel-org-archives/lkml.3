Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaHNHHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:07:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:48116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaHNHHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:07:36 -0400
Date: Thu, 14 Aug 2014 09:07:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
Message-ID: <20140814070722.GD16043@twins.programming.kicks-ass.net>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1407979069-7121-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 06:17:47PM -0700, Andi Kleen wrote:

> v2: Remove unnamed model numbers.

> +	case 61: /* Broadwell Client */

Seriously? So 71 and 79 are fine as a number but you cannot name them?

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7GAqAAoJEHZH4aRLwOS6fzEQALEQRe30lx9v5MXIHPeXhBl9
cpZAYBYzLSZ3yWX/KGziN75MHCThj5XhDwIHSjMxq11qz/a2IqruG8Cf6WziqGP6
g9cr68Wnbs6KkQfNSlT8VB8Dhv1EdNNg1QTApRX5u9n6gYD/MsePtpJqEVkx8ZnW
QD6Rr0KPPmw1eSuvG2UvYsi8MzZqSZ1/XF1nKeOLLZdkeAFyK62meSP/buTHOrYH
YFHkfWz3n+Kw+ONwNbgKz3yeaWQePQJmNxenwuczXUlmx/eyrtK4cv6R2bomVD22
ai36eljijMQhccLCF/FZTCLO6u0fH+6Hy6I3GxaW+rx3Cqkvyvf3D++DUmeP7Ctk
5bjrSq0BAPDfZYw3lT0jFEJbBK4TYL5wa7FQEH6wKBOT8S6js1/ttZGd1vPzNsmy
3Fr3qgJSwzU1zwU0ThG68hBESI7OZDwiuBKDRgqMpAWsYnDRYMQP7iRuwBM4jIpF
L9jT8hw2/gO6Kn6VNwe+m4zLiqjen/JgVmk01hIO/thObVHGThQObdChs7Rv/YDY
tNU9TeAO3kxrFbnJiTRLX3Dh0IrsG7rEouYDodw1HKmEpfhVPHlsdZFbeK7SS7Vt
zs88OpMttZCj5HjWYH+r3jgn6ar/iqfwe0DLGwrHR25dFFwII94AervX3+LZV7Ct
kCAxN9YlEph6+8Whd6LW
=8BDY
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
