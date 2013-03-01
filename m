Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3CAMEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:04:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41989 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab3CAMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:04:40 -0500
Date: Fri, 1 Mar 2013 20:04:04 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] regulator: fixed regulator_bulk_enable unwinding code
Message-ID: <20130301120402.GZ25302@opensource.wolfsonmicro.com>
References: <1362137045-25600-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UbqA5qh2E+WCbFAw"
Content-Disposition: inline
In-Reply-To: <1362137045-25600-1-git-send-email-a.hajda@samsung.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UbqA5qh2E+WCbFAw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 01, 2013 at 12:24:05PM +0100, Andrzej Hajda wrote:
> Unwinding code disables all successfully enabled regulators.
> Error is logged for every failed regulator.

Applied, thanks.

--UbqA5qh2E+WCbFAw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMJkqAAoJELSic+t+oim9kv0P/iEFkln+jhABpbFJY+pBBblF
4fe+9hMg1IyUWzCkr0wU/oUuEIMd5K2bwKmOa9jwhB3Reln6TELdT9G+tgXfZ5ym
NE9+nUqeQBbal0BKb/c/EW2MicMjphlFYRFNDyy6iNnGM+ASFotaymleSU+RpXmI
pQL4miiGHUdSAfIwaizQlEv05RXwc3MYlyTDvKFUyKXU+h7IBE5pLVkrdzR8Uo96
+DH2+h7G/A3SbmdkvvadUnVwimWldofPTCYFvszlVGZiPYAzuJ/8aX/gWf5tIVku
APxeQ5RhMkdasL55t1oDCim1wFpntva0YLYPmIgs1xEHjWqcHl2ZxABTn8rI1Bh7
PeoZMhGiekegCpsy4CONrGuCRNgNxSHuvBmurTU6bY12Gf5kBprLPsnkZxFZpfvU
gzmtetSN+xCEAY3+42/qvYP7JxxuG5LsWk+FRsm8BiTZa9cIP1bG8VKz8RPHTVUt
rWp8YUEenOPZXS6W1Hv0i7VNzhgGyi9tgZa5gUpLCBx1aFTDYUK9Bhb++WOUoYBt
fDgRtmB6UXqSMgXagFtRj7Zg0k10DNRv6kviaYg1bmK3hQ+t6gcZcxdYfK7XKmda
4NQoMePLVmLeG2/PfNaW3wl2V5wLcD0g1ZNeQSgJsypy/eLAivq9TKLbhpe47N3n
ewMvBVlM9l9s9JOBeI/m
=H/XS
-----END PGP SIGNATURE-----

--UbqA5qh2E+WCbFAw--
