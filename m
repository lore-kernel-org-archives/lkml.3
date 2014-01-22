Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaAVSH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:07:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58207 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAVSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:07:24 -0500
Date: Wed, 22 Jan 2014 18:06:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com, alan@linux.intel.com,
        acme@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Message-ID: <20140122180643.GP17314@sirena.org.uk>
References: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
 <1390325069.2472.78.camel@joe-AO722>
 <20140122122728.GA8882@gmail.com>
 <1390395744.31946.45.camel@joe-AO722>
 <20140122160917.GI17314@sirena.org.uk>
 <1390411823.31946.63.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NmfzLA6GLqNeIeLP"
Content-Disposition: inline
In-Reply-To: <1390411823.31946.63.camel@joe-AO722>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [tip:core/urgent] MAINTAINERS: Restore "L:
 linux-kernel@vger.kernel.org" entries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NmfzLA6GLqNeIeLP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2014 at 09:30:23AM -0800, Joe Perches wrote:
> On Wed, 2014-01-22 at 16:09 +0000, Mark Brown wrote:

> > and in practice doing so would make it even harder to work with
> > than it is at the minute.

> How?  What is "it" here?

linux-kernel, it's rather hig volume.

> > In practice this is exactly what's been happening for years anyway so
> > it's not something I'd expect to be controversial.

> Perhaps the biggest benefit of cc'ing lkml is
> a centralized repository of proposed patches in
> https://patchwork.kernel.org/project/LKML/list/

Which isn't triumphantly usable as a result.

> Perhaps the best argument to cc lkml is still this:

> https://lkml.org/lkml/2009/5/27/44

That's one of the reasons one might choose to CC lkml, yes.  But equally
well it doesn't need to be the default for everything and usually
someone is watching the subsystem lists.

--NmfzLA6GLqNeIeLP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4AiwAAoJELSic+t+oim9NakP/ibdVM7Yfc24JeqXiy4gPl2b
g0XJW7cJulVyiVM/tsMDt3yPd/n4866igCr3VuA9PjwG9rg3PxgnX7qKm0vBAYzI
N4pWrmg/IL9EVA2c1Znv/DJFpw/A65i5rubxKxdQ64JeYKeuZZYHMgzjHBdtDDux
MTXvmLJSCvwvaxElpUqAOCIG3pIIKJIujeqhoPDSDIVlUmM6GovsvV/yYTWt5GHK
4PV5/9vETgXOgffoIUEZPo3HsXHF3BVefljnhPkRzh1dfYRU19/3Mg1pHOuWyuMW
bhjW90H9dqni1cJl40uEMdf+HzkHJ7fUlvjvBhqEJ1c5tKPIPxAnydevBvt7u7mC
Dn5fD4+A7fnf8PFv7ox1JGpGdctsEh1JG95QkyjfDVynEO28GYPa3+CVa8cRVtq/
nQ8rlNUBo6/p5x5QsxfeXXzoVNL5Df4E6+LM18yNq+piHeUMeA+SFxKJ3JtjlsJW
CkxUeYryxxlgkx9SbLY3/T8Tv8mqVWTbYWZb1VGWeU0GJbMHV30cyiChxljm/oJ6
j0vwckDofIL641GQehj0zKYyeo6mKQNlV/pF7fZkJQx/kiLBjYsJFpn1yB26Q4Ca
hrJxy0dBmCbXmzY2TAz2jt5g7xWo144v/KNiF91Ux15aXsnkJaR1DMHteRHsCWgZ
1gDiPedB1MS/P7ndYs3y
=ZazY
-----END PGP SIGNATURE-----

--NmfzLA6GLqNeIeLP--
