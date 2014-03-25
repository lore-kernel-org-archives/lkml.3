Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaCYKfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:35:46 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52677 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaCYKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:35:44 -0400
Date: Tue, 25 Mar 2014 11:35:26 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Richard Zhu <r65037@freescale.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based on
 designware core driver
Message-ID: <20140325103525.GA14789@ulmo>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
 <1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
 <235376049.yyfljDtinu@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <235376049.yyfljDtinu@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2014 at 08:44:36AM +0100, Arnd Bergmann wrote:
> On Monday 24 March 2014 20:35:26 Murali Karicheri wrote:
[...]
> > +/* Keystone PCIe driver does not allow module unload */
> > +static int __init ks_pcie_init(void)
> > +{
> > +	return platform_driver_probe(&ks_pcie_driver, ks_pcie_probe);
> > +}
> > +subsys_initcall(ks_pcie_init);
>=20
> Why subsys_initcall?
>=20
> We should probably try to fix unloading soon.

I did some work on this a few months ago but never got around to
cleaning up the patches. Let me see if I can resurrect that work.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMVvtAAoJEN0jrNd/PrOhcKEP/0NkWbv69rdDV7DzjWXxvVR2
NfwiCP+rXOmdk2DdBahkUhbimlGsHTQpG4yUkOTsGOq5qmai6TXjqP+0WhUstBaw
l6tUd3bSxaYUw+QAk1wlgxuX39xycHEBgVgaXWTTIViIa6JWI+r3AHZuc0zStpOO
fPyNuDwF9/cDZ2vfiKjSc0hgG/mSXA0ZaY13PsoQB/OcDiyjDYNL9exTD3a9Y0+A
eOefJqYJEpJwPsgiGHGna39eOn0TLGGMDtiCHN+uMtOR0QFT2JUk5Wd1+lA8jDcz
aXrJEgohSgkFPaiCZ5N2F87ZrKzH2PrDqs36GJEO3LOj/MOcfodlJ2OJVy4RbHw8
hZvKbHSTV/F1gbg/CBxsf5SICpMos5FUCK07UvOKVeZeqQH6+Yb85kYesqHUg6JX
H0Vcc32S6fLyHrBmP0LyWYfIjWaDiEzS9fkiaRbZAAUCFdNubCnHHl/6+z1x63O4
XFoJtT+TAlo6pGw2ZX+KflPMeBOlP5Hs9LBVDWI0l1R+08I8CaV/i8VTh0A7rLIK
gS3xjN6N++hAZYRmb4X0cFnBTD/eqxelHSToEnTIRb5J0ZCfzTGJJritZA0rbXUt
3mc5mn5V8EqbIth6jqpQryMhJBtSO1W6TcS3Getww3tku2gUEdaruDiLv7ReiMfh
J/ZuERHd+pVQMD1yddOb
=xEJX
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
