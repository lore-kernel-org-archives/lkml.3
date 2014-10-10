Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaJJLys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:54:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44297 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaJJLym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:54:42 -0400
Date: Fri, 10 Oct 2014 12:53:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: PERIER Romain <romain.perier@gmail.com>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, robh <robh@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Message-ID: <20141010115359.GE18557@sirena.org.uk>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
 <CABgxDoL2cztT6Y0oodtk4Q4jaDc1Rtx_RokxC+f0XykSojrdyg@mail.gmail.com>
 <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Content-Disposition: inline
In-Reply-To: <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2 1/4] regulator: Add helper function to get
 "poweroff-source" property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2014 at 12:47:08PM +0100, Grant Likely wrote:

> This is an extremely simple wrapper. It may be best to simply make it
> a static inline. It is also generic enough that I don't have a problem
> with it living in include/linux/of.h; but of_regulator.h would be fine
> too.

I think of.h might be a better idea - it's not something that needs to
be regulator specific, system power controllers could provide the same
functionality but may not offer any regulator control to Linux.

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUN8jWAAoJECTWi3JdVIfQL84H/1LIL/5/DYEQwAMprFKH8pLv
BfFv863V5x1QtGRxC+OiDANdj61PBIrAB78PswZ5tPpX13mca3WbEqqOFSnIGdeA
AbtMTWiznlEdQoO04vwm7lbGkAH3M7KKjq9EMIDsGnQJ4Qi+JyxTNKuwbPRIFL6e
CiRnwPuz180PeBsUWw2b4oqcK8CPk/Bq4txHz/9Q7C59IBdzd9q62oFtLf5l6C9Y
lqspLR7EiZOzXx3DkJ6+Jphq7SN84MZwFYoyI9WvP1MxpSzp1XLrNOXnBeyHDoSl
7bCr0uVL8YtxUdGAKFAdWZ/IqVh9zAvct5YTw6MKNhYumkHuTrfYWRzU8p7s+zA=
=Illa
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
