Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaG1GxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:53:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaG1GxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:53:10 -0400
Date: Mon, 28 Jul 2014 08:52:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
Message-ID: <20140728065255.GI6758@twins.programming.kicks-ass.net>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <53D216A4.3090600@intel.com>
 <20140725140652.GA6758@twins.programming.kicks-ass.net>
 <53D5B45E.4030403@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r8zkF+xBtxUQJvKX"
Content-Disposition: inline
In-Reply-To: <53D5B45E.4030403@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r8zkF+xBtxUQJvKX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 10:24:30AM +0800, Yan, Zheng wrote:

> I don't think this method works for interrupt threshold > 1 case. When collision
> happens, the hardware only create one PEBS record. The status in next record has
> nothing to do with the collision record.

Andi previously stated that the hardware will always generate a record
for each event:

  http://marc.info/?l=linux-kernel&m=140129731708247

Please lock yourselves in room and do not come out until you can give a
straight and coherent answer.

--r8zkF+xBtxUQJvKX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1fNDAAoJEHZH4aRLwOS6u5oP/A03p5N8rPkavjtE9Kfiz0gZ
/B9U1gQJj82D7+juK6OCdH7R4dlAgk0klOrH8XOqC+cygbxnONeA2bQGlykKB4Bq
sW6tIRuuApz2xBqHieOW+wB8NarxRnlcMPmZRWgSc9Jh2FBc3sTIOxJFT9+YTuW3
HQRjDpVYz4MSwx8R6KldXg+uoEmxbXSaDYwnXKpJ3gJK/WUOeuZH7QD/E7mYfEUf
91UWlfjc7mQrRLrYMazkZgxFI6RTKssV5t9MEOH6yNze3yMw7TAi7g/6KJnyheMU
gu2OZyTpqYSL+/xQ0zeHn+8WWN/Ejwah5B3EBixzDU5jPleJSUMHWQIVcSX5FYE7
8/pEd4Xl9AEttPTKbG2I7xxx+3keDfgTxXThiGSRTxK/7yhztYFvLxe8IRJInIZV
a/cTEQtXHGdOoqNK3cRWU5muyaVvPmr1LfdE6x3h/0c1kRAuvNk7PJt2jIduVzlw
pwlFMfL5GbyO+ZlUBl2Z7i+xOogYNKmSRicZ/vEKJJsvnsqLPVRu86QhawfuZUFS
I6OkdWpcKNOaZFPgAQC8UQlnofUazObh0WipQsO6Jgmj16Mm5qRaliqlN10YoHzr
FhsCXMP58c/vcLE9AuRdiugJA51UFt1Y9pOmkjlqWNLWriJmWWNLgieaozsn4eWv
esJgcbhjgDEHSSChUIHC
=xHzW
-----END PGP SIGNATURE-----

--r8zkF+xBtxUQJvKX--
