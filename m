Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaGBK5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:57:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaGBK5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:57:47 -0400
Date: Wed, 2 Jul 2014 12:57:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 10/16] perf, core: simplify need branch stack check
Message-ID: <20140702105737.GC6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-11-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IQcO73Bte+RllADJ"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-11-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IQcO73Bte+RllADJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 04:50:47PM +0800, Yan, Zheng wrote:
> event->attr.branch_sample_type is non-zero no matter branch stack
> is enabled explicitly or is enabled implicitly. we can use it to
> replace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
> that implicitly enables the LBR.

How so? I grep'ed for a minute but could not find what you're referring
to.

--IQcO73Bte+RllADJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs+WhAAoJEHZH4aRLwOS6uTgP/2M+BDngk9nKBJ/6R8ndxU6R
OlqY5c6/j5+HEYYluStKbwRX3ASBpGBN1BveJbNrmw3D39aU8irMsyCO8ul3KJcs
oCPEeQBbsxK9KcCFbW8aCKGl0xbhpdd0GvgTltCl7JxcsYmqzDP+utRBkWjOMVB+
itCgWBKsSLCJI9gFw/w0F/cKfLwGwTjfEfZ+MNIRvZ0qctETeTMs7nCR8S5sjRxT
qSWVRSqANR7G/zR8w7NYkWUWrmB+D9qs8Ir2KQr7Ph7NI/BJpOcx9XA9ysrr5eNh
288NKlmVfYXsGQpyu+cv0Su3pgJnBwr7PZ06weue079DVo3Yj+/xyTqmgWkb6riW
8Ixyz4gKLwFGecTRmX0VQpCpf4RwGm9yaelqh2PelccnbuCC/w5yBarwd60OtLnM
IsINIADR+lzogNKfXrV4FXhJYoX5VBV6jPgnjUd5915Ry8D7R1mMDIyi7HQXzdb2
Bhy8rYzQni9fwLFKU872bJ7UsBDYN2pHoSWj3APn0kJU7qWXN8AJZTHoUqQPrGaT
RICp8QCatCLEL5QT2rTKXeYn92mDr3OWpuUStKAa9zlf65NIlBr3k3Mh1IL5RoTb
E50Aohjsf/JtmNxsbAgbhLBCIxum4Aw+cqaWuvWctgl2B1RfwHIDTd0oSuhKng3V
V6ZWklLUp098yT90Ym9A
=mi3r
-----END PGP SIGNATURE-----

--IQcO73Bte+RllADJ--
