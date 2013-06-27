Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3F0Gun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:50:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:29410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab3F0Gul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:50:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="asc'?scan'208";a="323240891"
Date: Thu, 27 Jun 2013 02:42:05 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86/mce: Update MCE severity condition check
Message-ID: <20130627064205.GA23923@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
References: <20130626091808.GA18468@gchen.bj.intel.com>
 <0134840@agluck-desk.sc.intel.com>
 <20130626190845.GK20274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C5653E@ORSMSX106.amr.corp.intel.com>
 <20130626203639.GM20274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C56603@ORSMSX106.amr.corp.intel.com>
 <20130626211052.GN20274@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20130626211052.GN20274@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 11:10:52PM +0200, Borislav Petkov wrote:
> Date: Wed, 26 Jun 2013 23:10:52 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Luck, Tony" <tony.luck@intel.com>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chen
>  Gong <gong.chen@linux.intel.com>, "Naveen N. Rao"
>  <naveen.n.rao@linux.vnet.ibm.com>
> Subject: Re: [PATCH] x86/mce: Update MCE severity condition check
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Wed, Jun 26, 2013 at 09:00:10PM +0000, Luck, Tony wrote:
> > > And this obviously is the case for the hardware too, I assume, not on=
ly
> > > the SDM?
> >=20
> > Yes - we have a magic process which reconfigures all deployed silicon w=
henever
> > a new SDM is published :-)
>=20
> Haha, I wouldn't wonder if your silicon dudes come up with
> reprogrammable fuses someday :-)

If so, it must be a catastrophe and the guys who wrote SDM have a big
trouble ... ;-)


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy969AAoJEI01n1+kOSLHHRUP/AprAZmte7HCOH1O3mKPXIuL
5OShVQmHRY2gdQI6VL4j07l+WrSifT9htIdZpgHqC+3yGlVgUv/2Ri1FN+9KL2I5
Ltxk/u329BCnHzvZl/iwoZVUUFX3lnzyhGsRiK0WeU1QWyQKeCPvwzX7oGGMimRN
+edCziSi4aS1Ev6URt5EUXKUQmeTv0otMZ1Mwj+GToj4H5487P1ZqFPmDD9tfrxX
WqvOa3/IokYXJ/55dS6STFmY7jSpPlf1FKsDcLNVcMuRbQIrm28RaBCQFrXzKEgq
11blwBHEUC9rHG7PBfwHyddOSlXcp8vn3tuuwnVQvKyWC1BNMfrjk3UVVUQ3MNUC
sdAiziWyVWZsdMinTUZ/3vd/9qtOIr45JZoPkUqg0M7OUEKMfUtIAkwfX1Yz0mIj
L0zy+lJ85t2PFKO/UhMh5UIZ0ra67QeqZAP13Hjie4wRe7kWTVDB7eoY3h7dy2vk
H1lcGEFvf7M6QeDiO2c5df3+Zwl/OwwH1cva2uxwdEjRqVrcEmcBzsydoCbU49NC
VZca6Pk0SmHKC9te2gsVTeO2h7CBVrSp/p0UjabLFzhuioGlPNqXK2S1kgrYmM0a
9m4ZexBgGiOtqY0QGg/lAad2Y2ufDdjEVTAV3FOQS0pSq7JoXUurZGPIXqHWD4nx
H6gZPERsV3v6G2Yslyzl
=onza
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
