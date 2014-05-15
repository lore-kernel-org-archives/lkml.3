Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaEOIfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:35:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaEOIfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:35:40 -0400
Date: Thu, 15 May 2014 10:35:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140515083531.GE30445@twins.programming.kicks-ass.net>
References: <537192D3.5030907@linux.vnet.ibm.com>
 <20140513094737.GU30445@twins.programming.kicks-ass.net>
 <53721FD4.6060300@redhat.com>
 <20140513142328.GE2485@laptop.programming.kicks-ass.net>
 <53731D12.7040804@linux.vnet.ibm.com>
 <20140514094426.GF30445@twins.programming.kicks-ass.net>
 <5374387E.4080802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lhOtAiCshckiypUO"
Content-Disposition: inline
In-Reply-To: <5374387E.4080802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lhOtAiCshckiypUO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 15, 2014 at 11:46:06AM +0800, Michael wang wrote:
> But for the dbench, stress combination, that's not spin-wasted, dbench
> throughput do dropped, how could we explain that one?

I've no clue what dbench does.. At this point you'll have to
expose/trace the per-task runtime accounting for these tasks and ideally
also the things the cgroup code does with them to see if it still makes
sense.

--lhOtAiCshckiypUO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHxTAAoJEHZH4aRLwOS6JEoP+wfamA2596u6SFCEv0GmuxeV
cwRY+AqgPcu06xo8le6cUiiy5JwcHn04YaCSHZ+M2i5olamP7EPDu0yLT9PkretC
gTr8+l1rbqFhIhU9rS04O3/qJJoMu1aGYyHiX/+TXlhTjNFl/cuhIc4YsQ5eI/T8
15YMOc8GOeZUxPFCCiXHszyqIKR57PPMDTj2QSiwu7+Un1TYbjjvwTykRwdIZ9JJ
dpjbEd06aGvvdY7HvvUqc2Tv9K1iduJ0ttS4SH7HvzQx7oID03SVAx0VO2V1z5iu
YuRSUnQTj7JabnPNCAlr2Mj0cIM8IhmXmtzuHyvYMS2ukiaxKfVvWWyULW85/qhW
yj05Nwm9N05PdPh/Jld8TujDmbm6/UuDb9CNKixGCfxjS5wpDHksYSRD0X2C4N6b
UnUQ9CDJkuBcTMCc3B1pm+rxsI+EDoGaEjQfzeA26eABrWbvGj2I8wlykv0xTuJ+
6/+kRU+0HcSTRoQ2NgKoHC7RXIATX8gLw+iASKddo2VDOceNO3rGzgWSGogl3c+i
MG2ppvEgYplkz/bgxHH/XAOGS5KO9X3a0o/uQ9rtW6XMwIXCdqWtVOuICh1qO17+
qX6T4M0nKJ90VUGzpMOqhDOm0siCdtLRtkniMfUxvTB3+AVE8DTj6/95xSiLJX+O
W7cz8tWWQJT2ov6HFdw8
=VrUS
-----END PGP SIGNATURE-----

--lhOtAiCshckiypUO--
