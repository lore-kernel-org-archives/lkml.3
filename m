Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3JSLq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 07:46:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:20497 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab3JSLqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 07:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,528,1378882800"; 
   d="asc'?scan'208";a="421585234"
Date: Sat, 19 Oct 2013 07:31:24 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com, m.chehab@samsung.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131019113124.GC16597@gchen.bj.intel.com>
Mail-Followup-To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, bp@alien8.de, joe@perches.com,
	m.chehab@samsung.com, arozansk@redhat.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <52612BA4.2060906@linux.vnet.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 06:07:56PM +0530, Naveen N. Rao wrote:
> Date: Fri, 18 Oct 2013 18:07:56 +0530
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
>  bp@alien8.de, joe@perches.com, m.chehab@samsung.com
> CC: arozansk@redhat.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
>  platform
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
>  Thunderbird/24.0
>=20
[...]
> >+
> >+MODULE_AUTHOR("Chen, Gong <gong.chen@intel.com>");
> >+MODULE_DESCRIPTION("Extended Error Log Driver");
>=20
> "Extended MCA Error Log Driver"?
>=20

Looks fine to me. Tony, would you please help to fix it when you pick up the
patch? Thanks in advance!

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSYm2MAAoJEI01n1+kOSLH6EgP/0awfFu3QUHLdoOUVKdOoEvt
0zx9AmGDMtjFaIronGBigJ/5ikFfTE3+qM/augoDrlWPMMALOUqIUUAq9r5+I0Hq
YugUUGx2gTBUTyr5KHL2VKdGgERcIx+I2kRzBKSmW/wBYPBz/IP1kkfAv/KPasXg
LchR0ZRof9f9YxAaetS6ugGnUHVdFItEtNa7iLpsBNhz3dVRRIorw3gv0MQ/YazN
cL7MXWCEDiJ34oUXPzyXNtzN6SF+CAGvL1LhtaK90u0H/Q1vWZ5OJjiR9fI2uG4w
8+SfnajTVQHkUv383XFZGmbing5zRzBjr1XPuTTQE5mYP1ot0z8HJ/Nvh+9HPVSV
7Pe0LnDANryX1syy5emhWHLvle56+4GkI+7b5KftgNEYH5vewIVU6stQ9hjTOVo+
ikpgmykQYMGOBBjGxgQUXsYf7Phr/8RHSEak5ObJ5QcFEA8VEAZyaT/QEXzv60g3
bk7r/cN0kK28bTdTL/D9P23NfaZxzqBHRynhyhueVmiWh9aheSerAh3jpAWNAjpC
5J/dlkf0M6z422xoSsEN9rmCG26MzsM2kRf/k39KkDXC4DeFDLjmkpNT4pEppPQ4
O5hFQLPb7K+vNWVuHE6t7IMRNiLvmzwbVRs57TYLJRAFnVYKCb7TCW3FVri5bcu4
v0fe68lKOQ2zuVcujtyc
=Bw8D
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
