Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaG3KMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:12:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaG3KMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:12:46 -0400
Date: Wed, 30 Jul 2014 12:12:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [RFC PATCH] mm: Add helpers for locked_vm
Message-ID: <20140730101218.GG19379@twins.programming.kicks-ass.net>
References: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YuRE/gUr1KgjPX1R"
Content-Disposition: inline
In-Reply-To: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YuRE/gUr1KgjPX1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 07:28:13PM +1000, Alexey Kardashevskiy wrote:
> This adds 2 helpers to change the locked_vm counter:
> - try_increase_locked_vm - may fail if new locked_vm value will be greater
> than the RLIMIT_MEMLOCK limit;
> - decrease_locked_vm.
>=20
> These will be used by drivers capable of locking memory by userspace
> request. For example, VFIO can use it to check if it can lock DMA memory
> or PPC-KVM can use it to check if it can lock memory for TCE tables.

Urgh no.. have a look here:

lkml.kernel.org/r/20140526145605.016140154@infradead.org

Someone needs to go help with the IB stuff, I got properly lost in
there.

--YuRE/gUr1KgjPX1R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2MUCAAoJEHZH4aRLwOS6tgcP/irknQ9NQqFgjP6iEkuuxHin
7HpyR+dr0RJnCyp6aqaneqfIX6MtyUnIVUsxPegu6OEGHwbYWE+D2XWZAbXHaMdW
GC2J6wCMw6YVBuBoXaUIxlmgL/VVcXuDluMkww6b3roBmF4jW+0jjIVG8hkX6DUl
YaG/cv6Kclu4vS4f+hXOMEd/rd+PJMl9O8Kk8yzcHGXfcBt2IOTqiiHwG/GX2XTw
1h6QvPid6SWLQ6EbHVZZd95/jgAowkwuVJZddlBxUwd839mg4+i/ypMtu7YXz5dN
x25Nvo6w+8sCQcq1G1GACaWcJTsKJhAjew90nF33EGU+PjqzgWJdwN07gBQa9zjV
F5pVrc2aYAGJWsxGTtq4kDD6w3B3oh1AKlv2/SAYA6koX29OGFi9WN5hUWOm3MG8
LIqwqhfuhL0tWFAbn9dP3IFHzeMjCyeyhpQMxIL2bqMFHicqk/+qz87ol9l69Qg1
Bwip5wxihkTQ9nfzK7FcUBthI3Hy4a09gXZm3KdpxvPoa9ZdfXfxuNF/gSRcfoHy
jzazCcWD+rZIMLPy509v49223MD9j4peSNjd3E64GlZFQqHHezDSUiNY6dl/jT39
XUTpoBdWXvQAb1z3YOYVDRNDIoDQroXQdelggdcACPn2aqj+kyXnB73+K6L+OGAC
tSxKdbkan5Zdl6BRbSx8
=zcmc
-----END PGP SIGNATURE-----

--YuRE/gUr1KgjPX1R--
