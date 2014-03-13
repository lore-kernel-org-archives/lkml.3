Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaCMVq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:46:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32839 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaCMVqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:46:54 -0400
Date: Thu, 13 Mar 2014 16:44:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH][next] phy: core: make NULL a valid phy reference if
 !CONFIG_GENERIC_PHY
Message-ID: <20140313214450.GG27355@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394709073-1980-1-git-send-email-grygorii.strashko@ti.com>
 <20140313152024.GF4599@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <20140313152024.GF4599@saruman.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 13, 2014 at 10:20:24AM -0500, Felipe Balbi wrote:
> On Thu, Mar 13, 2014 at 01:11:13PM +0200, Grygorii Strashko wrote:
> > This fixes a regression on Keystone 2 platforms caused by patch
> > 57303488cd37da58263e842de134dc65f7c626d5
> > "usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
> > optional support of generic phy in DWC3 core.
> >=20
> > On Keystone 2 platforms the USB is not working now because
> > CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
> > return -ENOSYS always. The log shows:
> >  dwc3 2690000.dwc3: failed to initialize core
> >  dwc3: probe of 2690000.dwc3 failed with error -38
> >=20
> > Hence, fix it by making NULL a valid phy reference in Generic PHY
> > APIs stubs in the same way as it was done by the patch
> > 04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
> > a valid phy reference".
> >=20
> > CC: Kishon Vijay Abraham I <kishon@ti.com>
> > CC: Felipe Balbi <balbi@ti.com>
> > CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>=20
> nice :-)
>=20
> Acked-by: Felipe Balbi <balbi@ti.com>

Greg, if your tree isn't closed yet, could you consider this patch still
for v3.15 merge window ? Grygorii found a regression on Keystone
platforms which this patch fixes. Let me know if you need the original
patch and myself or Kishon can send it to you.

--=20
balbi

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIibSAAoJEIaOsuA1yqRELbQQAKBL6jwsYLi5V5SPhqAYqXZD
O8WJc94ieXkpczmKsS2a8NIdN7d8gLuJX0NRVSAFhnUK2sTkTYubMFycakC+oZRR
KFIBRdb8b5o0gNLCIozKoirkpz0QjFp2VwpBFzLBpHHmiu5wTqAYSmFy3P4ZZUpn
919EcbxZIcnPx1B+OXqfzf8OQdlH50WTcvijcMBztvzvwKJ7VyEH3ojCP8HoLMr8
CoJWBpc2DeesJccqSbm91g6xrmhE4tTAgLMDJSo2ykbB46VQ8npKB5R6grpxvnbS
a27xW6u56Ig8I569LnsLszdrxsI+K1MA/TTCNVQZcbruRO5OmztRBw001VcE/ndO
472Mw+5FiUO5JOxFGTDYmXu7p45b2dmTi3WoDfBDCk5qavgDb7rMuFO8LlNO3JTi
sGf8abu0Mb16eYIl0iNCog5OIOSNTwkLMjnJ89dQHgz2raP7o1dxly4WaAu6UFi6
FhIUTvOY2a06/zMcL7whUR5Mld5M+nt0OvOB8B3a3XskUdSGYQiAMCuRdjEioVfD
YDSRItNwSnDQw4cD0vi3n8tdoZ7jzSVrsEV59eqL0HbtgHt2U01xobMBOIdsuk0J
oyfsUILZb2LscqN0W1l0WcJLCy6Uws2250JqbOxv5RnrR/MEED23KLoxFRpt5pfU
Y9cD9P7SHsCJ/ptYY3VC
=Rw3M
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
