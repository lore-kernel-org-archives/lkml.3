Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaG1H4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:56:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:57644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaG1H4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:56:35 -0400
Date: Mon, 28 Jul 2014 09:56:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH] perf/x86/uncore: split Intel uncore driver to smaller
 files
Message-ID: <20140728075623.GP19379@twins.programming.kicks-ass.net>
References: <1406277655-21808-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SriMJdVjWMjq81bG"
Content-Disposition: inline
In-Reply-To: <1406277655-21808-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SriMJdVjWMjq81bG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 25, 2014 at 04:40:55PM +0800, Yan, Zheng wrote:
> split Intel uncore driver into four files:
>  - perf_event_intel_uncore.c: general functions of Intel uncore driver.
>  - perf_event_intel_uncore_nhmex.c: hardware specific code for
>    Nehalem-EX/Westmere-EX
>  - perf_event_intel_uncore_snb.c: hardware specific code for
>    Nehalem/SandBridge/Haswell
>  - perf_event_intel_uncore_snbep.c: hardware specific code for
>    SandyBridge-EP/IvyTown uncore

Did not apply properly to tip/master, also can you do that in 3 patches?

One breaking out the nhm/wsm-ex part, one breaking out the
nhm/wsm/snb/ivb/hsw bits, and one for the snb/ivb-ep bits?

--SriMJdVjWMjq81bG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1gInAAoJEHZH4aRLwOS6iaoP/35mZ9Y6uTNkbkzM1ljaV31N
2Bk0xvHUJ1BQqw4ZpT837UnYKO1IIcQOUd5377WK8e1oHXzNjpSAvTYdQ1xC4CEN
iyk8JJvpcH3T+8mNaa3XoIFViFmcNPOizTr7/E6AA+/fCf3XXZKInYeabzsZXEMc
hcjiCf2HGKqpPQHpvWa5EczvQlPEoKHaKem6F0fegmqrWheFEZylyDIRMpuiUHz1
RyuqNnOF/0IFAfSRPDECKZnU66/kVNNaIBHEK4zHmEP9+/dy4Gb7t3Rk//JdcUtA
UGnMY3RsQAi3RVr+s/BhjkLsOOvYd+jf/uUeV9VfR6wp4Do+OGEO2oZIHESmzimM
MSbd+KphhmJ+Rr/FuEiToQog7nC8sgii8q3A8H1mHk4CVRyyNfTxBX1+5LaQYb8d
JNhSs2mMimJAw7kMcC+XOZQaMvmV+Jka1UsLRaeWtZHff7NyHqEQZw55FWN+3baH
AoNCBXEh1HpHkS/QsOkMbxDq9DQGk3T6KjNj7uRIOZ574XRODks4HxPRZ5Vz9O5K
vr/fGJaeu64D0nXJZi8Wzg9TWzwRMU09NcBAvQIloD5yYpot1UHmXkNVY3sWiRM8
6XMg/0cx1p3v6mHBsCzMKFQhobZ4fhAmemYgL+oGs5wubLVa3nWsyBaTcDJJNgf0
CYGjZ9V8jfiYhDwxTMsM
=MSut
-----END PGP SIGNATURE-----

--SriMJdVjWMjq81bG--
