Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaHNPKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:10:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaHNPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:10:36 -0400
Date: Thu, 14 Aug 2014 17:10:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
Message-ID: <20140814151019.GW6758@twins.programming.kicks-ass.net>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-4-git-send-email-andi@firstfloor.org>
 <20140814070722.GD16043@twins.programming.kicks-ass.net>
 <20140814073210.GP3588@twins.programming.kicks-ass.net>
 <20140814145854.GQ5803@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="spoeDETjLz8hlzGT"
Content-Disposition: inline
In-Reply-To: <20140814145854.GQ5803@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--spoeDETjLz8hlzGT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2014 at 07:58:54AM -0700, Andi Kleen wrote:

> Really, Peter, it's futile to try to reproduce http://ark.intel.com
> in perf comments. If you need information on specific Intel
> products please look it up there.

ark.intel.com is useless, I never can find anything there.
The best I can find is wikipedia and they stopped listing model numbers
long ago :/

--spoeDETjLz8hlzGT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7NFbAAoJEHZH4aRLwOS6E08P+wWS0BJGjnHO1WLU5ssq3YbB
PISlXOGk+18wDrH4Z4+vHpAEv3azEykoPxuP6Q9lq/12fDmK75SI/y4CKFlH7Eze
mNoVVpX3tA84k47x5skls2FdTA2gF3v1w7O6q9676psM+Vaz2jEfuS5+2OMzlAP2
tltap4O6V1ur7U+tekFA3rIO75hOU/aOUDxxJRuWwsxagX85qDzcuSuvZpsTZQh/
nkXE4JFpP4dcQYzn3dPwgSHtLnvJUDa6GSWKEYSCMlzPouVqraeqC57qTJpgCJI6
z0+W1Ewq5+Gnh55U6m+eIf0Hd/f82C4+FXeDEvXgiXd8RIEyceiKZ5ltVX56KqCF
3NK5INYtl0vLcLbXHwt5hATDZk7ZlzyvrQOg49ylELSMIr5hDGDRh+v56a4/0ucP
gord1DvFi0aVbwFU+KycDwD/Q9ny19AodU6iqzW+wYrOwilAbWh0TrNQFe2Aflde
1+wSnbVUPIQySD4qz6UJzoDkfW4kJ2XzS+ERh9Ct4751sxZQp/uDFddGaf4q012t
5iOHSrlGDozYd9lVTRDNgHGMt36NfAzIuEPM65/vDuMMEJs/CZhi8c5BT0EaX6EB
7AhcGl+C+AuCN9OGhO3v2wEwHllt1Z5i2VHe1LO3wJo0zW2ll3RHMHpjxPJpIjBE
dAc+xWW9ysijifYTNuXI
=SJ6T
-----END PGP SIGNATURE-----

--spoeDETjLz8hlzGT--
