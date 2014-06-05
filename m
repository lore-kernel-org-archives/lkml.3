Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaFENVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:21:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:52285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaFENVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:21:22 -0400
Date: Thu, 5 Jun 2014 15:21:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Liu ShuoX <shuox.liu@intel.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
Message-ID: <20140605132118.GJ6758@twins.programming.kicks-ass.net>
References: <20140605023610.GA12905@lskakaxi-intel>
 <20140605071919.GD3213@twins.programming.kicks-ass.net>
 <20140605073321.GA14869@lskakaxi-intel>
 <20140605075507.GA6758@twins.programming.kicks-ass.net>
 <53902398.70005@linux.intel.com>
 <20140605091517.GB6758@twins.programming.kicks-ass.net>
 <53906D78.60509@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvznHscUikHnwW2p"
Content-Disposition: inline
In-Reply-To: <53906D78.60509@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvznHscUikHnwW2p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 09:15:36PM +0800, Zhang, Yanmin wrote:

> Sorry for misleading you. It depends on backend. Pstore can use RAM or
> other storage, for example, EFI-provided backend. If using EFI backend,
> pstore can keep persistent across cold reset or even power outrages.
>=20
> If using RAM, usually pstore can keep persistent at WarmReset. Since RAM
> access (even at non-cache mode) is fast and more flexible, in fact, we of=
ten use
> RAM as backend of pstore.

Funny definition of persistent you end up with in that case... :-) But
yes, that does explain.

--GvznHscUikHnwW2p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkG7OAAoJEHZH4aRLwOS6DE4P/15U1+10RW3INxa8cnwyWU+W
BjhYVGNdJbGFVOtJod4BQk1TBAgprTQ/Z2BzJPHUEcKKR86T3mWb7hrrinFZ63cE
7NYkxmTemyyavuTLNCYdJX+wakyfMzVNux7W6jwzsx5Mp9Ei9YTefxsfeQLZbBQs
g2p3rpwBrKHIOdz8fKAhsUP2KgdfRzuaKAR9iBFAnY7XEYraFL/ImoAhwR1BTAoT
hLLAGXP8mADjfjVeLGBl4+bs3kWF5IQ9fYaWsNPwFLoP5mJ/o+lXI+wMqzU3KMfJ
8vhuWCp6tA+Ijoe+KMQD4RlpBl8JONh3DsKYkyZCDgAsL9N43jLf4Kpl5r3kx5HW
7SqRbJr3DJjPxXZrdyVMPZKVv9VWypDui48KuzATZ1dowrwGWXvubW8v/ab7Ufol
qwVC3Pncuoau7byPJzLkAsKPMFJOowIlBYVDWCX23VhiAbXbGvXudMT0luy9Brba
C5lLoDq+WrlWhbqI4t7VKdBWigi26JM8MYGznwOzB+MgwcLY09F3R/D0/xrSorpi
Xjsvb0ECjGZRMZyzdl/dqumvMIGlVZE8kwmfM+3Ywphrtf7Lxq1lBn50rDJyYWhx
hGDLUD4IPXnLLMPzJSKJ+soctdDFBSGgRdFclJyMlLKs2reyyStOkrPWXARf8WMe
OQoQnDXewYskzE89VFAi
=BvLU
-----END PGP SIGNATURE-----

--GvznHscUikHnwW2p--
