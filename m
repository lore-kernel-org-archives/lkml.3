Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaIIIdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:33:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:43433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaIIIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:33:08 -0400
Date: Tue, 9 Sep 2014 10:33:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
Message-ID: <20140909083303.GX19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/VG9mYbp8jL2/WoI"
Content-Disposition: inline
In-Reply-To: <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/VG9mYbp8jL2/WoI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 03:36:06PM +0300, Alexander Shishkin wrote:
> This adds support for overwrite mode in the AUX area, which means "keep
> collecting data till you're stopped". It does not depend on data buffer's
> overwrite mode, so that it doesn't lose sideband data that is instrumental
> for processing AUX data.

This patch is out of order as well, it would've made sense right after
the other aux buffer patch. Also, its not specified (and I can't find it
in the patch) how it _is_ set. The Changelog above only says how it is
not.


--/VG9mYbp8jL2/WoI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDrs/AAoJEHZH4aRLwOS6nHwQAKGIRxxFhkxpxtuaTc5K3pkB
dJOJ8cE+YMDAux6yOUjsToypZRE1qDNPGo7hz+FM5KEgvNDR+aBZL+KTmOtFXoCJ
deVctL1z2SRUQgsCpbdUFe2wFNIeNsphuMmD8ut/dVgdxzLzZEm/MFC0kpuPqBJJ
0V0G+TiIXCBg58EroyhxWRl7mDMSV7n4mvaCnltZ9yWVYM3PvS77in2pSJhbd5yR
LNsKfAqsgPshMgFDa50a/WrMLd3oZ9Lf9EJANW36LhzccEgX8NBIby8Ys5qSaUgI
9hsxw8VcrwxhKZeSU/oBlaL9mVasaFiGN19lQKtOnGnV+Sn/Md2qYcwI7ELfIKXt
REoqrnHv0cE50xAV5P5NKMtzgsaTWoi7oOoVt0exG/GSzS0GOQlwf4298Uzd1RFW
zw140YUr6aHbRpD/5gjGyh8do+nSXevPcsn1MGL4fUkQWqZRR1WbD3Ke1k4YtdQk
2xZpBdZpPM+8hX3WpZq2/xFGxhbqH1ojpTP9ki8/Rjl/ZoQSL5X84DdGXurX0qBQ
Msszm3FHGV+YEV30IoZ+IIOe/laeUuPxhRC+sXs7DiPhBgZPXB7/CKHpRPsgKsFC
kGIMbrYDHMkbvaXzTzjoviAI0JHp0ws82JzHxr6XJwpiI9QLuWrLLZ+g2PRwsF77
gPj25dR7GaumOokgT2r7
=FZVr
-----END PGP SIGNATURE-----

--/VG9mYbp8jL2/WoI--
