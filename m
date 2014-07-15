Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbaGOI73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:59:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbaGOI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:59:12 -0400
Date: Tue, 15 Jul 2014 10:59:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
Message-ID: <20140715085901.GS9918@twins.programming.kicks-ass.net>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
 <1405123285-23544-2-git-send-email-andi@firstfloor.org>
 <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
 <20140714192451.GC5803@tassilo.jf.intel.com>
 <CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
 <20140714223918.GE5803@tassilo.jf.intel.com>
 <CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
 <CABPqkBSVRuyOH8bTU4pjLNZMZdHoWFB4y-HJzVWTVowrO2Q+tg@mail.gmail.com>
 <20140715040542.GF5803@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9j/QU+CmmrcVJkVI"
Content-Disposition: inline
In-Reply-To: <20140715040542.GF5803@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9j/QU+CmmrcVJkVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 09:05:42PM -0700, Andi Kleen wrote:

> Yes, there are only three store events:
>=20
> MEM_UOPS_RETIRED.STLB_MISS_STORES
> MEM_UOPS_RETIRED.SPLIT_STORES
> MEM_UOPS_RETIRED.ALL_STORES
>=20
> These can be added.
>=20
> But most others are loads, so if you wanted loads too (besides mem-loads)
> it would be nearly a full list.

Of that list you had earlier:

MEM_UOPS_RETIRED.STLB_MISS_LOADS
MEM_UOPS_RETIRED.STLB_MISS_STORES
MEM_UOPS_RETIRED.LOCK_LOADS
MEM_UOPS_RETIRED.SPLIT_LOADS
MEM_UOPS_RETIRED.SPLIT_STORES
MEM_UOPS_RETIRED.ALL_LOADS
MEM_UOPS_RETIRED.ALL_STORES

There's only 4 loads and (as you already said) 3 stores.

That's 7 events total, that's not nearly a full list.

The other events:

UOPS_RETIRED.ALL
MEM_LOAD_UOPS_RETIRED.L1_HIT
MEM_LOAD_UOPS_RETIRED.L2_HIT
MEM_LOAD_UOPS_RETIRED.L3_HIT
MEM_LOAD_UOPS_RETIRED.L1_MISS
MEM_LOAD_UOPS_RETIRED.L2_MISS
MEM_LOAD_UOPS_RETIRED.L3_MISS
MEM_LOAD_UOPS_RETIRED.HIT_LFB
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE
MEM_LOAD_UOPS_L3_MISS_RETIRED.LOCAL_DRAM

are unclear on their type and should indeed be NA.

--9j/QU+CmmrcVJkVI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxO1VAAoJEHZH4aRLwOS6R7kP/RdwwPC8nkrTRdXI19RnLkGJ
bkvz2yd/XFs7gWJcziO8EH7qfIC0ouk8d5qVfg8XF+e2lGwx75UvsHbZ6o0tgIn/
RYQ1hFUuob46R5G9O+KNUAx1iDu7ugez2RllT6PjTZKkZ0rE55Kl58laDUIgabJQ
4/1MYDLBpvXamYrgqNHpcLycez99ed3GpM/XgLf2e26prMoI2zmh2RFnG0ct5JAr
8+P1pt79ZzPNO7m/EwE8r7gyIS+erbKpLbe2mA+4zo0zucDEQTsprZMNFfuN2ui+
Q2XlvKX7pu2KJYF1v2JgBSuCkkq72hPbwb8jkXu8ZWo6sG+ulybX002YHA6qzdv8
Z9a1HkZpeTiAUSqEQOoe9X589jGSMcTsH219sf2oYrj1cl/3zwNpA2dB5AODfu+r
OeZeOrDf83mLajOJjhWw9LEgLzIuo5vDBSOxl7T9JCKNBC3pKsW0U8CUgM3VwaLG
k2d99eL/WS8WyU0Ta8CRK0eOBDlsAyjRqPFYA+Mz4249VKI/SkqxWsY5Z0nJeRDA
KmZeu+dqLQh0aO7ZYUh0Ox0TBgPaxjIvrY7ww2+P8/zHGIybZMZyvWMbX7Niapxm
O9jLRykLtZrawptTfupBw7D9dDzpYD2LMq1VVG+PfpYzu5EYEIFDAGOBzYaW2Z4A
PU94RtxDnvPJ5d5HsMxZ
=Go93
-----END PGP SIGNATURE-----

--9j/QU+CmmrcVJkVI--
