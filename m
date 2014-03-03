Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaCCDzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:55:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:29925 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaCCDzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:55:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,575,1389772800"; 
   d="asc'?scan'208";a="345017289"
Date: Sun, 2 Mar 2014 22:32:50 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86, make check_irq_vectors_for_cpu_disable() aware of
 numa node irqs
Message-ID: <20140303033250.GA22677@gchen.bj.intel.com>
References: <1393337061-1315-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <1393337061-1315-1-git-send-email-prarit@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2014 at 09:04:21AM -0500, Prarit Bhargava wrote:
> This patch explicitly depends on Yinghai's patch, [PATCH v3] x86, irq: get
> correct available vectors for cpu disable, which was last posted here:
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D139094603622814&w=3D2
>=20
> and is not yet in any tree AFAICT.
>=20
> P.
>=20
Sounds reasonable to me. Just a nitpick.

Acked-by: Gong Chen <gong.chen@linux.intel.com>

[...]
> +		if (cpumask_empty(&affinity_new)) {
> +			pr_warn("CPU %d disable failed: IRQ %u has no availble CPUS to transi=
tion IRQ.\n",
These words looks not fluent to native speaker. (but I'm not native
speaker, too ;-))

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTE/fhAAoJEI01n1+kOSLHnyIQAIUXW4VPlJRF0iWCNhwZfUpB
FFWz8A/jT9FJ4II5mNrENcBCsAyQfOQMk/VOxF+BGubOnoxf+kkpBhZx8FrMtX7C
7zS7ZmHwFicEaNRGBxs+nuLLcyxWYnjR79O9MFwI/Pb9WxKYfo8yq+gMZxubRJFK
8x/R6bvK3Amyf4GmvvXYk2naxmDk6nY8v78G7sKAjT/xCJ8ru4ta65s+EaOwrGND
ClNa3+Xd65odOT3u0ADQkC3ZmT6hbiOiDXR2im7QZdLGdiDaHARUczSPvqjbVL6K
x43QbkI1ivVcAR29IChZ2HqtLPJYZcqPDElNz8sBcoTzvzuW4GflDYTzyUZMeLGA
BeUop0tgM+er0/qTKE0LNVSdDXHEIRfMjU+4+GU3J9y7yoD7RHwlCuVZn7M+8Rq0
R8MulGsWWz9BmNUH3ZgJ7lbd9P5uMAc2Q7g0r1T2XMnYEKTKKbxQJo9hT5lobRyN
RM6sAdxxRe243ubyGR+Q+gJj0H7Rb9F9S1MpjPHb+0POTRJcxqVvIxZP0iyRkKQ5
BL2yUzFNdV+5PNR3nFgZQ+XP/Z28L9wvU12q+mc8V8IY42U3/mwZykXfG5ff20fb
HpEh2MEZY+CsweZdjEe7snmm1w9nm0yc51c5G6ZigOFqqhLCbwA7vTL40uKzFB99
NhzXsXoxIHjnyc2HRXCb
=frS1
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
