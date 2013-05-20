Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3ETUJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:09:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:59902 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab3ETUJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="asc'?scan'208";a="244283409"
Message-ID: <1369080566.2892.3.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH v2 net-next 0/4] net: low latency Ethernet
 device polling
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, Willem de Bruijn <willemb@google.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Don Skidmore <donanld.c.skidmore@intel.com>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>,
        Dave Miller <davem@davemloft.net>
Date: Mon, 20 May 2013 13:09:26 -0700
In-Reply-To: <5199260B.9090204@linux.intel.com>
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com>
	 <CAJZOPZJzVykmBH5FFQBVuztAFGRMOPT-GKABiewG6b4pnKVUeA@mail.gmail.com>
	 <5199260B.9090204@linux.intel.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ui1aw4VUeVaqgngbL4zE"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ui1aw4VUeVaqgngbL4zE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-05-19 at 22:20 +0300, Eliezer Tamir wrote:
> On 19/05/2013 22:06, Or Gerlitz wrote:
> > On Sun, May 19, 2013 at 1:25 PM, Eliezer Tamir
> > <eliezer.tamir@linux.intel.com> wrote:
> >> This is an updated version of the code we posted on February.
> >
> > Last time you've placed a copy of the patchset in the rfc branch of
> > git://github.com/jbrandeb/lls.git  - can you repost there V2 too?
> >
> > Or.
> >
> Yes, but it will have to wait for tomorrow.
> It's on Jesse's github account and for him it's still the middle of the=
=20
> weekend.
>=20
> -Eliezer

If Jesse has not done so already, I can put your series of patches on a
branch of my kernel net-next tree.  Let me know...

--=-Ui1aw4VUeVaqgngbL4zE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRmoL2AAoJEOVv75VaS+3OrfoP/2UMX1C4sHw48jw7ol4tRmJY
8ROYkgKyCDrFJqUpBD66OEIfqAW/2QnGjPRVagRAzpjqzbbYHnwOxkt9TXpU2wrR
8pxXiwxW51mhDNfE+KPuAk/+qUVWLI6s+99eeSWBoDdIynnNrTLjAeKQnt1faNWq
+6RJRSKmKNZ2fVyWswExdowvnO2CSPjUVXP0SMkD7PIYxVNC53CXDbf0+kh3KCUC
pMafIaLoxFobZnM3q/jZRDau8UIM+z5PN7iiSqR0+BGiwqvpor3gsdlKBUvPflgN
Vb+CQ2dJfwDe9YspqfJJZTWcTBqd3xcZhuRtemdv2vJ9y6+sIlAq+/7YrOPYdjtB
I1Pl9erQpsoCYg5nG1j6tyaE1juocBi1CkENQx6LKPqmItWMjgRyIG+8moAnf6c+
bwxhDaMZ2Z2s2S8OVzH+2AsF+U79DUHow33Yw+zPE24Ffyp9J2x7LSNIsFPGk5H1
Z8vI2XlWfeUNMW1j0CATsO08hey4DuqiWQFZAXqjk6LmMSAzBI+7fDZ9d3B6WRK+
xvmReF7iCCcXONtwaIjMYmxQiitDIPE7/WijuiLAT+0KJUjYOFeX5lDE1hTGSnuv
X/uOxEPZkt6VP/Efr38dkzWpltl/IEwU9dmNg69JCJF7V947ttC1Cpvialr+j3m2
wZVVFKjppUXHrpRVIZp+
=Bvw7
-----END PGP SIGNATURE-----

--=-Ui1aw4VUeVaqgngbL4zE--

