Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab3JTHV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:21:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:37473 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3JTHV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,532,1378882800"; 
   d="asc'?scan'208";a="419617501"
Date: Sun, 20 Oct 2013 03:06:15 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com, m.chehab@samsung.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131020070615.GA30565@gchen.bj.intel.com>
Mail-Followup-To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, bp@alien8.de, joe@perches.com,
	m.chehab@samsung.com, arozansk@redhat.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <52612BA4.2060906@linux.vnet.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> >diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> >index 22327e6..c67ec61 100644
> >--- a/drivers/acpi/Kconfig
> >+++ b/drivers/acpi/Kconfig
> >@@ -372,4 +372,24 @@ config ACPI_BGRT
> >
> >  source "drivers/acpi/apei/Kconfig"
> >
> >+config ACPI_EXTLOG
> >+	tristate "Extended Error Log support"
> >+	depends on X86_MCE
>=20
> I think you also have a dependancy on ACPI_APEI for apei_estatus_print()
>=20
Oh, yes it is. Furthermore, it reminds me where is the best place to put
cper.c from I write this patch series. CPER really doesn't dpend on APEI
even ACPI. Maybe lib/ ia an option. I can update this patch and if it is
OK, I can add another separate patch to change this dependency. Make
sense?

> >+	default n
> >+	help
> >+	  Certain usages such as Predictive Failure Analysis (PFA) require
> >+	  more information about the error than what can be described in
> >+	  processor machine check banks. Most server processors log
> >+	  additional information about the error in processor uncore
> >+	  registers. Since the addresses and layout of these registers vary
> >+	  widely from one processor to another, system software cannot
> >+	  readily make use of them. To complicate matters further, some of
> >+	  the additional error information cannot be constructed space
> >+	  between "additional" and "error" without detailed knowledge
>=20
> Oops... looks like copy+paste went wrong ;)
>=20
Sigh, it looks like I have m a little bit hurry.=20

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSY4DnAAoJEI01n1+kOSLHMRYP/inpl4REe4W/y83VhaOzz7nH
9v7Mcd1y/DTVOPP/Apf4t1sw6ejiQMSHukrtgyJAd1Fdl56AHoc37VJhG3rGBxpH
0W9VW7RURlc52kseKrVObQgPxR3N6lgJ4kPHeyRChCBdChAmF6KTIiGyrNk03DOI
BiLnXbgy2z3ns6reHXOqHwGqvhqW+xxjxpVPDCOJizLeAsScQIKJkfF3w+y0EwJm
kgCkh1WeiXlLVfNzbomXTnCxiHUyEBXGI9/G/NGq54BrhVTLBCQ2ADBnWhvPYTpR
4fKn1Do/2YyiYQMcy866lVjzYQKrEl21QtS7Kd6yzsHWIyjVv3vCwLH0T83y+OAU
rmJQ6xAqJAFWDxoGpWzqZcGGa3H6+cXOjPXUicp1iZsW6mOYOg+PZnQ8/Vm2DjRi
u7ipIKvXr9hWP32Bl6Iqium67DAe0dMvSdKTZFXdyRqP9YmGjOtvWlviRP2OFKGJ
yYsTAZwPUkd/4hEHuhgqbffj+F589g/y5X7ohh0Mi1yI4O+pZlBKaxwl3JAeKB3Y
d2on9YpCqcWyYMay9aduts7kGfUFKbzaGt9V4AfKafJcn904gQBuf5X+XpmW5ozS
RiBEBJNUjETRVQYfWcm96GvadAmowth2qvSJeHJ9/RS67sIZgF5FaXVmZtwnq1E3
Hq1OL7PyZOyLY80Ow70n
=gR75
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
