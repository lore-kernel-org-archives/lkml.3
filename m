Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaHEPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:25:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaHEPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:25:58 -0400
Date: Tue, 5 Aug 2014 17:25:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
Message-ID: <20140805152540.GC19379@twins.programming.kicks-ass.net>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
 <1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
 <20140805132837.GA19379@twins.programming.kicks-ass.net>
 <CAKocOOMa89+Ej0rk-LyQLBcwDvLtsXq7x+oPwBMS1N61kKUwQg@mail.gmail.com>
 <20140805144108.GK9918@twins.programming.kicks-ass.net>
 <53E0EDD2.50600@canonical.com>
 <20140805145437.GL9918@twins.programming.kicks-ass.net>
 <CAKocOOM=c2jaW_D27Z_iHoSzknp38j0gh_Exa3iTf5CzFkmPJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5wsc5v34kcSWG42z"
Content-Disposition: inline
In-Reply-To: <CAKocOOM=c2jaW_D27Z_iHoSzknp38j0gh_Exa3iTf5CzFkmPJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5wsc5v34kcSWG42z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 09:05:53AM -0600, Shuah Khan wrote:
> Maybe if tools doesn't sounds right, we could move testing from under tools
> and have it be testing

No, tools/testing/ is all userspace stuff afaict.

> We have several selftests spread around in the kernel tree. It makes it easier
> to pull them under a single make target devtest. I sent in a patch add devtest
> target that runs tests that are under tools/testing/selftests a couple of
> weeks ago, hopefully it will be included in 3.17. I am working towards pulling
> more kernel selftests that exist under this devtest umbrella. That is
> the motivation

A link to the patch might've been useful.. but no that's pointless,
there is no userspace component to locking-selftest, so your build/run
target is bloody pointless.

--5wsc5v34kcSWG42z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4Pd0AAoJEHZH4aRLwOS64L8QAKRRg22rSNtICRwx2MHc6MYk
xMB5jqTPmkD9Idx1Hqg95ltguH0fbs1jJ27PjAHYwurSNXnfFwYZlTk0ZDeRUBOh
MhT6H7dLzoBmpqg85X9pF4M1gnSz3kHIL6K7XKd0XXo79xXfKc6Clz7OWo62sOe7
fS2KCZTDbqA1fbPIRJcoWwV/MDOWPWJH2SexEimF/vicAoHzTLUJTksRYO80uT9c
oeBWpZhMtWr3qYpOs62LYaRcYf1OBpIIs2IHXBX0irKIX9KJAyI+ZsNN0MocCq3N
08bFKBW2tZsSAFHzrYt4OSse6jJPlGFqPJnMucnWXgvw/AC34vgLZL6sBOTpizg+
SRHKV4EV1iJXhG3zarBrymiowWDCrPRISQiPFnNOL/FcVbjajkHfndndJXKmbX5U
j55TS2AcKXci5hbN0dDMoF1L1k+KN8uV365HBJvDqPmcxrRunlpg2In/TGmIRSc1
32PwZxLO3HFRmVc+khskbcTkE42KWdf1POOLWXH2TkYL8mwfaA8cRSyRzBHP/5Do
xIpv6fwQWdnzm/IKEsEr2DUoC8J+sWkzLiFAD4GAj+BfbbcGfJMHBA9EA2Quytw8
1PsLjVc/hDtCYDucS9HwAnGcvymCCYdRRS6ZXP8k0oB6S3U4crJPE8QIKr4Qqy5h
GWJiA9PSD9QzF2h3qdsc
=MmZi
-----END PGP SIGNATURE-----

--5wsc5v34kcSWG42z--
