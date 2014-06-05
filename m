Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaFEJPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:15:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:51027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:15:20 -0400
Date: Thu, 5 Jun 2014 11:15:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Liu ShuoX <shuox.liu@intel.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
Message-ID: <20140605091517.GB6758@twins.programming.kicks-ass.net>
References: <20140605023610.GA12905@lskakaxi-intel>
 <20140605071919.GD3213@twins.programming.kicks-ass.net>
 <20140605073321.GA14869@lskakaxi-intel>
 <20140605075507.GA6758@twins.programming.kicks-ass.net>
 <53902398.70005@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <53902398.70005@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 04:00:24PM +0800, Zhang, Yanmin wrote:
> On 2014/6/5 15:55, Peter Zijlstra wrote:

> >Why does pstore cause corruption? I thought that stuff was supposed to
> >be 'good' ?

> pstore is good if the board is reset by WarmReset as memory content is kept
> across rebooting.
> If it's a ColdReset, memory might lose some or all contents. My board uses
> Coldreset, which is a very
> fast ColdReset. Most memory content can be kept. But sometimes, some data
> has little change.

Oh, I thought pstore was persistent across cold resets or even power
outages. My bad then.

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkDUkAAoJEHZH4aRLwOS6UWUQAIJp8d2R8LElVXNar149PnHk
CG6w9Z/q+Wla3evGnF9BKOoKLWFcCSh6RTyWrQBXxZq9qT3/NoVJQ35bzZW9qabB
UI7h5g3B07u6/vcWqqymU7J3baBw9H956rGC934LxmdCM6PtIHVDfr6c9YymH/jD
B3X8S1zeEA2HkqSJOsk0ef9SNtIdDWkX4Iaebi6uY/H0dlaDJbFXJwsWcerDe5Xy
DYiPT5bl+4bP/8uZRuKYG84lpHKc0EVj9CCpqj/kcBHENvZRLoGGe9aO6Ud74zx6
t9jO8abjGYkCz4V/cyfdDnfTzcwArTBCT5ED2D70K0/tvKuu/Pr04Gxg7kUP4g27
KccHg7aFMoM99o9OVD+cwgsjIywZ6hvuswzj0DnTwnyERkPEaT0tJD2wdd0x23kp
6CEHiZRINHzMPnzqigLCtedqRst223G7DNTYSpRcaoLSK8I8fsZSgCM/fsitDSUo
NaULKRSjxJ0Qk+iJqk5AF8/CLB81dP62+84u+VeaxD5DO+amsDL6b/VI6srHJsOM
uw/jNSvlnzYs71RwAcbplwVdDq6Wu2qiMAdslf0NQkej/VI9tO3sK6wYszyt9KCf
663YimUWw0i+GNrDQHqFXI4y9iFMF/qp07fZG3/yLHQS/GxBfTIdo4pQ5X4z5czt
dM0YeNrE06wqfxp7Rsvl
=EBqE
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
