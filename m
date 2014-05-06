Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbaEFLy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:54:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:60468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaEFLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:54:53 -0400
Date: Tue, 6 May 2014 13:54:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140506115448.GH11096@twins.programming.kicks-ass.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
 <1399011219.5233.55.camel@marge.simpson.net>
 <53633B81.1080403@redhat.com>
 <1399016273.5233.94.camel@marge.simpson.net>
 <536379D0.8070306@redhat.com>
 <1399030032.5233.142.camel@marge.simpson.net>
 <5363B793.9010208@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MM5RgFPKyuP3gDcV"
Content-Disposition: inline
In-Reply-To: <5363B793.9010208@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MM5RgFPKyuP3gDcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 02, 2014 at 11:19:47AM -0400, Rik van Riel wrote:
> As an aside, it also looks like SD_BALANCE_WAKE is set on all domains
> of a NUMA system by default, so even the non-affine wakeup will end
> up looking for the lowest load NUMA node to start up on.

I can't find it being set on anything by default.

--MM5RgFPKyuP3gDcV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaM2IAAoJEHZH4aRLwOS6tTEP/2xkQIP0c6WbrcG8s7NRcsdP
P4uNvZhZuqpdBroxu5ccaAt0l5rI624Erm55WL2Btd9RIC43eu1QC/A3u3gV3XfZ
EBiX4wvfqOp/Wp05H06hEUmYuD7QAcyD0FzWcPuwrAIJlLX8MLkArOq6wrp1iiV0
ncgE89XoSP8UK92/h/F/UIOBEmZ0F/1Gns5L3GgxOsh+pBAuh4zbL8/GBkgryJwY
yIVHEs9kHkuiwsA9L//OKsT5HeKvjq/YuS3J8+TdJrp8YN9RWqzbkA5nO9F97GaD
SjGCOoGL97R7+WvV47qfL0f7p1zcSUXwB0/5n3NJV+HfTr4ROahdf2hvt9EDxQq2
ieJKSzulDgEJIJb0KiU5qTaDdiFdoIpPOtqX2QoWxMUHHpJfQKgs+S+YY6r8uIGn
AsxVHiF52nBEWl5XryP91RLYfFz3gb0a7at5euL05KYHCPoUMkOQQtilUITuhvG8
QwULQD99wFMcrFV7rCGaxjgrRZqgxhCxKOdkydhgsSyIIA407c29W84xw1FqHCEt
hZ6Ubk1Zw+KfANiFyd6R+GqPEqRKirzIu4B5NJKOhnfVMzhJkTtx6+krSoO8rAwC
OxT+m8NSdIQnf/q4A3+PJXkbSJvQ6qzUdfthM7/XMU3MwUawq1jwN9cwx8OO9MJh
X3cf+/aPo9C2qmhsl2SZ
=SOWQ
-----END PGP SIGNATURE-----

--MM5RgFPKyuP3gDcV--
