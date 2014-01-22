Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaAVCVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:21:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:56755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaAVCVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:21:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="asc'?scan'208";a="405175657"
Date: Tue, 21 Jan 2014 21:00:49 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Fengguang Wu <fengguang.wu@Intel.com>
Subject: Re: [PATCH] x86, cpu hotplug, use cpumask stack safe variant
 cpumask_var_t in check_irq_vectors_for_cpu_disable() [v2]
Message-ID: <20140122020049.GA16393@gchen.bj.intel.com>
References: <20140120085017.GB5243@gchen.bj.intel.com>
 <1390244278-30024-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <1390244278-30024-1-git-send-email-prarit@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2014 at 01:57:58PM -0500, Prarit Bhargava wrote:
> Subject: [PATCH] x86, cpu hotplug, use cpumask stack safe variant
>  cpumask_var_t in check_irq_vectors_for_cpu_disable() [v2]
>=20
> kbuild, 0day kernel build service, outputs the warning:
>=20
> arch/x86/kernel/irq.c:333:1: warning: the frame size of 2056 bytes
> is larger than 2048 bytes [-Wframe-larger-than=3D]
>=20
> because check_irq_vectors_for_cpu_disable() allocates two cpumasks on the
> stack.  Fix this by using cpumask_var_t, the cpumask stack safe variant.
>=20
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Yang Zhang <yang.z.zhang@Intel.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Janet Morgan <janet.morgan@intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Ruiv Wang <ruiv.wang@gmail.com>
> Cc: Gong Chen <gong.chen@linux.intel.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Gong Chen <gong.chen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: Fengguang Wu <fengguang.wu@intel.com>
>=20
> [v2]: switch from GFP_KERNEL to GFP_ATOMIC

Reviewed-by: Chen, Gong <gong.chen@linux.intel.com>


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS3yZRAAoJEI01n1+kOSLHt/YP/3ofpKDfIuUHjGatyj/JVIbN
eu0wH2GbnfS3S6XsvM1Dctt/W/gxJARuoUT/39cJfzqeGWm6XBUqk/bcAeXn6ZbC
bMC5C8J6d/QS+LoQDy5M+1t/nSP7fJ0yaL3LtYRUGFVjAd2/VuEfzj8in30hFU1N
HgYLxLsMGUZo4l+xneCZiUPiEOUl6S9FrUIkDVg/htMq3+x3pezoPVO/wod4fvHu
k0V9WpIg7MXNwGIq8Av+Qxmytpl+lTppDfsNdv8nbWDZ+25rcnHat/qOgVWcsdo4
Jth1aEUgtLZTvfSv0lWyHZ9ual94PTdGlaVgl4ehuTih+D4k0cYwv2W1pRvN72F9
c1UkoCHejPztHvydiUCGkH2P4KetPQsoJ91jk8oJqjgmFnTG+SoXM5Bu7aQQJKXF
2WDyEKiory4lqLaRZpfuex3lM9LPQ/cbaSOT4nLWRTNSpGyXd/9jwMhkcMz0jPPV
glvzF/G4Hz9PzyuYH0ZvWVzrdr7rsy7mo+h5Olyr0QugvQMnK0ZcOaqqEdEyUE0W
yqgPsgmenI3GNWK/xnP9agyucVuyLNBppWI2+L6u3iQiMB0x0o9D+l/wy5PTmjg4
A7TD9Ym+ZrI/bGai0PhYFyMO7VJzhjAdaK0Sc4vm+7vrRYSlRk2caTWH68gFdeGL
J0yYZD9xCsQyvqZp3QxE
=YI44
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
