Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaG3KVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:21:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:42115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaG3KVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:21:41 -0400
Date: Wed, 30 Jul 2014 12:21:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140730102128.GJ19379@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
 <20140730101331.GB15761@e103687>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UxLQriKcE1P0oA6o"
Content-Disposition: inline
In-Reply-To: <20140730101331.GB15761@e103687>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UxLQriKcE1P0oA6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2014 at 11:13:31AM +0100, Morten Rasmussen wrote:
> It is a very real problem when user-space uses priorities extensively
> like Android does. Tasks related to audio run at very high priorities
> but only for a very short amount of time, but due the to priority
> scaling their load ends up being several times higher than tasks running
> all the time at normal priority. Hence task load is a very poor
> indicator of utilization.

FWIW Android (which I think does this through binder) is utterly insane
in this regard. But yes, we have to live with it.

--UxLQriKcE1P0oA6o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2McoAAoJEHZH4aRLwOS6jx4P/RJUphoJfjDy2oJNtTomjvCv
O4eLhI6dxff9ybzTjjFBfub/+balwtu6ECY6j8Gw0xXXnwnGr+gLXVQ/OHKROci5
OWAjOPtuYzCfz+UFUrySspWJ0zOaKB5Anfc4SUhLdlxDORJpqd+zOHQjg015TlYA
6ofsF3Td+AJ1Zyzl0IEMFU9cvNLzQVuGqpe2UmZI/eD85PNB03unHSN3frWWc8UJ
CisbGcnlg9PH3QQnZLR4hOQGKwDA2AzUQ4S0Ynv7R9nuT73i2OvPSkN/NFllg1fD
GeXPxXYIbbFy+yAx3gpK4CY/7eN4Mu8V6943klE+K0ENKAzQH+4YMfxSJO2/0qZ6
9NjIZmNR/PMdHKGE1px2zVdP0uEZnaKyI2zJe8FIPQBxOhoL7a0CHVq3DMFHuTg3
K5Kqy8Z9qWvrveIsk8Kq6gjqQAONlEZMHEaT4i/ECjK9GS0/u8sl5z3D0w3vD6Sf
pXTHbYnTBP15M5/F3GEwzuYd3fTyW8VCN/T3svRsL1UrQpnEWCZ3J8kTsCfzQIrL
1jByQXr58RYDPcSOaCNnt86lsLlAfSt3inJZIGL/al41AG14c7lwNTK8bJY5iHj2
fVYNbphLXTGbfq5HtW7Nez07siQmymFuJyotIdkf2JAZQ4MPsveNeRQA6LMNojQL
rV7beF7qNRzwoHRFCDWS
=EgaO
-----END PGP SIGNATURE-----

--UxLQriKcE1P0oA6o--
