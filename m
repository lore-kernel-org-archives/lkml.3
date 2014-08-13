Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaHMIBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:01:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:43054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaHMIBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:01:11 -0400
Date: Wed, 13 Aug 2014 10:00:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] perf, x86: Add Broadwell core support
Message-ID: <20140813080059.GZ9918@twins.programming.kicks-ass.net>
References: <1407894315-15928-1-git-send-email-andi@firstfloor.org>
 <1407894315-15928-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="itZeKTbdDcsshnDN"
Content-Disposition: inline
In-Reply-To: <1407894315-15928-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--itZeKTbdDcsshnDN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 06:45:14PM -0700, Andi Kleen wrote:
> +	case 61: /* Broadwell */
> +	case 71:
> +	case 79:

Same deal; please put a descriptive comment per model number.

https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=perf/core&id=a42c1bf50d297fcb96a3c71b0fdc2da6dbe47030

--itZeKTbdDcsshnDN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6xs7AAoJEHZH4aRLwOS6IhoP/0wQowzJl1btCeoYZ7CpC081
tsSNKqi4i2Am/Bmi8wdKi7oaPpqpgIs1hTUdY+LyeRe1K+ISMXxHyJNU/2+BRKRm
Q0/xJC9opOfPOGbAeOxsjAd2JnzhGBSaJ5bWO68U4oaf8iCp9NbNogb5s4qDHXy/
kmhlsVul6ZbFwN3XfYzR+bbpg21UDMGPuKrIbsWjNQgH7EV3976ChGcZUvee/rEW
ZPvH6931m7w+nxvWbrV2GesCPBizUU0hHgkqFY20i0dUjJTik5vhSpFSLGwZy1jx
gB/Nd2NXZ4LHdTWZiIy9hO0DNxxd9NWnGGfmtCIbqHP+ZF1i/Eu2/4hkeyaFVXVx
drv6xcIlczGTMZTt2JytPzLkjO73y1p62YgZrLOqwi9U08+kuSF0yuTmJsswOyTP
ECg/MojTyYgxKNxkXxxvlfpEtft+i1ItI7w7Zw1XjMxQM97Y9IZBpQwxu+AtliKJ
te4r281cFdhZVOW2dnkXPoH9D5noau6UqvuPqQHPpT0pdsv32tbq8YSrsxq8uCQU
mg+P3CyeuxBemq4bOWieKJi6InaRHvqVAPGxXLT1O7GAfWw1eeHNvJkDtl2WvWdl
rAkaapz/tnVfoxVm2Jed3mQWZvVMJkGp7IEsPTEiT5HLoeqizajIbMZARG7Sn70M
FsTWTrSbqhU+BSfJtNBW
=DUgF
-----END PGP SIGNATURE-----

--itZeKTbdDcsshnDN--
