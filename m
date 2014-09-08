Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaIHSvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:51:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:40947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaIHSvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:51:19 -0400
Date: Mon, 8 Sep 2014 20:51:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
Message-ID: <20140908185115.GI6758@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8S3Z05jHc5WjjFzN"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8S3Z05jHc5WjjFzN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 01:47:11PM -0400, Vince Weaver wrote:
> Hello
>=20
> so I finally had time to run my perf_fuzzer again and it has rapidly=20
> turned up an alarming crash that instant-reboots my core2 test machine.

Urgh, of course :/



--8S3Z05jHc5WjjFzN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDfqeAAoJEHZH4aRLwOS6laEP/3iUeTu5NkIoe7jZC6W4Rl8k
Qwk48C8n3J4HIei1aEnr+abmM8n/DoyDkcsXG0SDBWSeTXyR1FnGCzppGe/qkBZD
aPYpUt6nabJJq0EkqhvBt4jhyx4RQjxSXNLPeQAXkP5cBAT6Qq/eg1FvpYgbAem5
cnnxAZCb+27eypWfxxcD7Sw3MV2HgunWyL9hfnlYnlFH/E5r4U5DD3uJ4YLFMdXI
kNUKxFkqDxQYv2nNp8TisdmJJdDWqRTQubrf7chkzkViYNUqHLz62BE7vrupbuHU
JZbMy5zq/bmNlRZWkQkEoTyT6mcurWNxH2ZYZqnTi4tyyX1VQSqjtGnXhF0rzmxs
3R65o4vLSNVh5B2SeeRIv2rXIDIPif8eujmvXmV6gdtCX2DtylR+0p64G8+ftWKk
bvLMUdtqWy8Hq7ANdCP1UQhrkqL7rmvrkkA8VQjGFTf3TQDWoui8zRT2hAbbPmTK
m6Z5fqjAVOiFGAjEdxrjN9qtVpOJvoUBe65F8bBwsNz2wyJGMbwU03D/9w6DdHNe
iAgXzMxb5bx4aDDffNNZ5DG/a51MsojXV1ItFT744MBtr03z1YnovAb71YMnlyYO
yO7uo3X0rJ3gWa252D083CD9rAkwtek+SRrYetGlg+dEQ2onxRqHeU0Crde1TepK
/DU1+RdFGEw/TqAPLXqw
=9p/H
-----END PGP SIGNATURE-----

--8S3Z05jHc5WjjFzN--
