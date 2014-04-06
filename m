Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaDFPbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:31:24 -0400
Received: from sauhun.de ([89.238.76.85]:57567 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbaDFPbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:31:22 -0400
Date: Sun, 6 Apr 2014 17:31:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        dlaurie@chromium.org
Subject: Re: [PATCH v2 0/2] i2c-designware-pci: Add Haswell ULT device support
Message-ID: <20140406153104.GA2609@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382367944-3005-1-git-send-email-bleung@chromium.org>
 <20131021161428.GI3521@intel.com>
 <20140406135424.GA1840@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20140406135424.GA1840@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 06, 2014 at 04:54:24PM +0300, Kirill A. Shutemov wrote:
> On Mon, Oct 21, 2013 at 07:14:28PM +0300, Mika Westerberg wrote:
> > On Mon, Oct 21, 2013 at 08:05:42AM -0700, Benson Leung wrote:
> > > Fixed 25Mhz clock instead of 100Mhz clock in 1/2 and a warning in 2/2.
> > >=20
> > > [PATCH v2 1/2] i2c-designware-pci: Add Haswell ULT device IDs
> > > [PATCH v2 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
> >=20
> > Both patches,
> >=20
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>=20
> Guys, any idea why these patches have not upstreamed yet?

Yes, read the discussion of V1 of these patches. AFAIU the patches are
obsolete.


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTQXM4AAoJEBQN5MwUoCm2C/UP/2iUbrDnvEVg+swGX2/GgkQX
wc4u5HYBBWIA8MZXHg2DVM7NGWEMHDLEg/0A9MCKgqcW3VFApdLSjIWELLxhbGoU
ZzuGFGhAapcARsSc0AK/B2tf9q7FdB0EHFE0Z0B+hxMkGcnqYJKNCc1RY7FY9f7X
n8SoUhwe29hpZKLMx0bZsiy0SgHBSTcC0IpB3TJHyjXZVpKtPFHdhyWV6WqbVK7q
WBQ5R7oHgqYL3+P+1kJyN2OaxkVe4mLx95tw6ZlI6TSBZht9KdPH/UFTzzLAVX9p
FE/OfP/bLH4rdVGEWewpNnEiZNw71XdxZha8jz0YARrXrpAtufYnKlWKerXBODco
EwMphx+05ZSA0ScewXn1eC5spEHho4Uqn/0n+3rkFEzC//+zJsWa+R4v9uD5DWh3
+yqbYj9w5pHcSUluRrqdZAppOpYo4yUs3zuIOMyh2Wp0KE9NSpgK+tlkKN0YHl54
roE15eIA3XcmksjI5feag/p7UTezx6Enr3aQ69haDaSIKgkpvK4DcWpZPjHrCmLF
G/QFgFmKbheXIqdBih1G33+1/jsDz7Dgr16sIMbvMuQfm5Lu+jbTmnV6ZHI+wQqU
izEN4DL943cAzY8jFqdaOcX5x9TXr0BngEFIb968rjq5aTP2Ui70MIxVgrFtxgTM
uobABx6KqGKQTh03PODs
=JLen
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
