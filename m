Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaIJH7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:59:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIJH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:59:29 -0400
Date: Wed, 10 Sep 2014 09:59:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
Message-ID: <20140910075926.GM6758@twins.programming.kicks-ass.net>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
 <1410310148-26260-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wgXxy63RjE4bNDjS"
Content-Disposition: inline
In-Reply-To: <1410310148-26260-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wgXxy63RjE4bNDjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> The earlier commit 86a04461a made near all PEBS on
> Sandy/IvyBridge/Haswell to reject non zero flags.

What's magic about nehalem and westmere?

--wgXxy63RjE4bNDjS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEATeAAoJEHZH4aRLwOS66LsP/ikw+ZcDROZIuv/TFhrvwcnT
hFxDr76HmMflR+VwhEJ/JLqXAwSBaqglLB/xpqXRSS+S55fpzNvNZsJToppb9QZP
ATCS8H+C2lejvMLYG9hELansyAt2gtMcSYkyzU9h0SDauMaD38sGwv7ecKHtdp0+
CVXRWq83l1i3NANPEeRURTJb/m/JlyzRDEO1xXaakaom7Dpps3R0F6JU9bGp4TVB
V+I72f62p1wAq47GY/PPru/U+y6E5Yxg2BSMSSY/fj4kH8FJlpIZgflZH8kTHXsw
E0amiPzZMKjLWGr6ZJfLWEjfERs1U4DxXqBxNVqddXCC0If0Av6G88w145x8F107
XSbg33IWYtr6F5OFBgI4dHcbxDmkwCbwzAZ+2n4iHz8OMUlyOSOMSAAVXGYqWIjm
B7hfA7RW3tduxFomfNYuIKAkUNzJuNvgOJXiDFzvnkhcsjhbobDBkxvDHP4qA3R2
Q9ifbN8D5CPHGwX4p5WA2bRNI07FV+zELgKDJtopEYLnvjR8hbYUc36vxUuYh3Yj
y8uPovPSOV5GYPtfIMsjvcAMyX3SZbpPHseOs2+HGXmmNuD4TSGP2erYF0K5/98I
c/4uxVF2FuOjR0Ozs2003M6wUX25MdnCOC/wsMxC3uJOBm9V4rH1f0SUpnmQVVmk
ccUjnSuTCH1k5Mh6gGil
=SES3
-----END PGP SIGNATURE-----

--wgXxy63RjE4bNDjS--
