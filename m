Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbaGOKCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:02:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441AbaGOKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:02:29 -0400
Date: Tue, 15 Jul 2014 12:02:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 0/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140715100216.GY9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7lrstsuc0VoKvTCW"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7lrstsuc0VoKvTCW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



The first two patches are the same patches as from the LBR callstack
series, right?

--7lrstsuc0VoKvTCW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxPwoAAoJEHZH4aRLwOS6uPcP/2djLNTELsAZ3aMWyRhVGOP0
nRmRdnJt2r9ei1BqyvtbegqpFdBiqWAYiuJbkbJR0KYof0PWlfMBC4APzDl6/Xqr
7kYj5vo1BgkejeeszsbEiJ3TzbDaCwDcbvtvLnzIWgseZUyuk8wmCMn68P8oF60X
6Y9qFGnT1ZqCCe+6oVSGWYnr5W3iGf3s6eOyO4XgcgP3XcsOFaXYDiIYdItga+S7
5lLXviI9WBjMwH7OXGT2g7eVnMqQLPDL24dqn5yXVr2UVDf8o/7+CluXZblwNOqX
hYuGoFDE/y07f7/84qbBoHnw7mjAtOKJVGJZO2bUEdyC6O5elW5ZVwn0kyBD1vdX
cgLCR94IbPCM8RsVW+KeCsJbMPltfyRGCc6Qn0dlNggFMwKxN5xPAFMHc/ywdMRH
2a4w2jnK5X0C8fwqw6AKT8l1v9AyNROM0NXxDLkKc8QOhsBIXlWkNCFqlyiecN7t
+H/cYGz5/6er1JpO6szR3EAolytq1GVcWQU1NfGoPLHLrWyG5HeOFA8srQNvK22h
kkeceoP1dNKmZjgAPz5JcSq6F9xiGvFO3L2OfoRTGbZLgMtxYyRVNql3AjIYGbrW
6zvrBVknFWh0QvF9lacMwJIB2QqKZhVqaeumJIiQffHVxKl6H7pno6Z7SBFL4BLa
R6XbvR6m1luGrbO3GTbf
=pfvs
-----END PGP SIGNATURE-----

--7lrstsuc0VoKvTCW--
