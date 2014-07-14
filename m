Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaGNSTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:19:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGNSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:18:59 -0400
Date: Mon, 14 Jul 2014 20:18:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, luto@amacapital.net,
        hpa@linux.intel.com
Subject: Re: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
Message-ID: <20140714181846.GJ9918@twins.programming.kicks-ass.net>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
 <20140714160947.GB9918@twins.programming.kicks-ass.net>
 <20140714173755.GH17761@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MTHfywbKLRvT1GNJ"
Content-Disposition: inline
In-Reply-To: <20140714173755.GH17761@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MTHfywbKLRvT1GNJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 07:37:55PM +0200, Jiri Olsa wrote:
> On Mon, Jul 14, 2014 at 06:09:47PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 14, 2014 at 05:57:19PM +0200, Jiri Olsa wrote:
> > > Following patch added another way to get mmap name:
> > >   78d683e mm, fs: Add vm_ops->name as an alternative to arch_vma_name
> >=20
> > Please add to your .gitconfig:
> >=20
> > [core]
> >         abbrev =3D 12
>=20
> hum, will check

Mandated by Linus, also I've already had 8 char hash collisions, so it
really makes sense.

--MTHfywbKLRvT1GNJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxB8FAAoJEHZH4aRLwOS6UuEQAJjugQgQ1xQOGPOv3wMmQhVR
vjM7GQ1um5YwCkEVg/lV5vKvJ8+ysfRYeLlhfYgGjN8Vpj69AKErsOTDUovX9/GA
78XkWHppRvZ2M/iielmpbqRINrw+DSTbXRcwMiBHTw9omlmOrNsgQGk+PtGn2lZg
ka8+gjx0N0QxY47oLrahCRJAY0yzBwOIBPjnjTwjmCMQKZFUJIYzeCWaupwVNMeB
qTvppQ11Z4gLxXofY+7PYDlHAa0pPpT2Z0Z35JX9nODZtO8jtyK51B0aw2z0389G
86oOvNXCMorpXtq5i5Idv+70SEpL/B72zeLVqgZ85hgzEboRf49FS1YJI8WXqitY
tJk/BVJG5EfcxdSzjznhsJELwSvMLCOvt89aMoyNLP+gcdkEx+SKSDIKOzv3B/cw
gB/r0wq+mKtJEm62seWGx57teVXaLit5Cml2k/crf/IrhO0lDBEMjlOxKrK5CFW8
NRJFUPf/V8pU3RgVEVqPVqPtzYO4MCt3BIGOI4YAbmTQQ7Dz+FZnt+awdqElcD3R
Hs9NRR5eAFi8gjqIR/P7X9hQJL/X4MGRZwaA9jrKOATza3shxVYgO2/TPXz0SMcF
bwCIFHK2n0FOTs8f8JPg4B/uqxhZoXXYZadReCjn1s3u5ClV8Log1H5C5odwm3Ft
aDexEMVW9Vjfw5iEn0OM
=zBQW
-----END PGP SIGNATURE-----

--MTHfywbKLRvT1GNJ--
