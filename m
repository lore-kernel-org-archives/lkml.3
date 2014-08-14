Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaHNHcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:32:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:48239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaHNHcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:32:23 -0400
Date: Thu, 14 Aug 2014 09:32:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
Message-ID: <20140814073210.GP3588@twins.programming.kicks-ass.net>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-4-git-send-email-andi@firstfloor.org>
 <20140814070722.GD16043@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sB5q8U+2Z60V3VP3"
Content-Disposition: inline
In-Reply-To: <20140814070722.GD16043@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sB5q8U+2Z60V3VP3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 09:07:22AM +0200, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 06:17:47PM -0700, Andi Kleen wrote:
>=20
> > v2: Remove unnamed model numbers.
>=20
> > +	case 61: /* Broadwell Client */
>=20
> Seriously? So 71 and 79 are fine as a number but you cannot name them?

would something like:

	case 71: /* 14nm Broadwell TBA */

work? Where you then will update the description at the appropriate
time?

--sB5q8U+2Z60V3VP3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7GX6AAoJEHZH4aRLwOS6i+kQAJp3B9QVJquitRfo3GsQBKH9
+YiAVSXmNdF8eGAsAnkKEzCbV9ZwU03gHxr7QBdxtbV9JhdOXe+V9TbNlLD+peaH
M4Hlw+lZ3c0kYbd3jSMzYEdHsDWCx/jQRvoEaVO++2NxVL7a/v5wFSno16cCYzcE
PDbaYjf5d8d4iBSTt/gn/pRMtnX+EFxqJWMbrmKRH9CKtO3ZjhuvCpntYKxGThun
L7dYe2lCbdvrXLNMmxPfu/D1FI+ciMjbl0684jghVrbxiUqOl0lZWfNvDN3vZfwr
2N+gYvRvpM5eCfJ9DM/CIrxmV9XSLlCp97Tj510Zog9rxuPq0EANVf0y/JgSfxHO
ROwNIJ5iEIC4Z8HIf58xzfIHrEZtqaUmAW2F33iswJvzkVmRQpZ4rRObKPT+yY/O
y30GVj6/8pJ1SzaJf+GpI+06pVUslsqLmGZg7C3bjgVAWP7ZkMuhLZ+gu3Y8PhfM
wW7+r/OMKsiyAmX6HUM5s10WN4EYMDSG2ysjQHsB221EIwyknZFLaG2vYzBuQ9Lv
ueHVr7x1h8RxWHNWh9uLZk9EY8Aq1bZ3/uASXWiMxZ1seKlyIjqx6wzAAsVcx0NS
kurnoxEz0DPQfwuULO7YFYY8lEAG6MTjnPutLhOtn2XRYDtsiDxyJAEEkWQz/9lk
lBxJ2m/9SbrsHDUg3Qav
=Ydse
-----END PGP SIGNATURE-----

--sB5q8U+2Z60V3VP3--
