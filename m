Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaFDXpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:45:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:22197 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbaFDXpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:45:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,976,1392192000"; 
   d="asc'?scan'208";a="549929254"
Message-ID: <1401925517.19767.175.camel@jtkirshe-mobl>
Subject: Re: [linux-nics] [PATCH] net: ethernet: intel: ixgbe: ixgbe_main.c:
 Cleaning up missing null-terminate after strncpy call
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>, Don@isotope.jf.intel.com,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linux@isotope.jf.intel.com, NICS <linux.nics@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>, netdev@vger.kernel.org
Date: Wed, 04 Jun 2014 16:45:17 -0700
In-Reply-To: <1401917380-2772-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401917380-2772-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XKWcFaUQst+hbSnjUrfr"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XKWcFaUQst+hbSnjUrfr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-06-04 at 23:29 +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
>=20
> This was partly found using a static code analysis program called
> cppcheck.
>=20
> Signed-off-by: Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

NAK, I won't be picking this patch up based on Mark's and Joe's
feedback.

--=-XKWcFaUQst+hbSnjUrfr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJTj6+NAAoJEOVv75VaS+3OVJUP/1YONvsZ0hxDz5IMn59SXzNf
359R8nBq00KUIKxCgb9StrPdXCsxaAIPCDTmaU3/bixQq2R36lrlxT3im6MtoBDG
R/Mbh/TDokG9/UTV+5RBw+n+s5sojeL2HRZzhrUCid0NmQVdJYdPWxji5d+DSBnT
pYLBTyWV0drXYflK8S2nRtyE2qg7TwXN1L0ZMFadzN8T0D/1OFaXmhrVkQRnteYQ
ozJ+O8rRDggltWn/nc+zHwvce7aDVXFJGo5pUTtsZ2dwC3p1nB/pkA/5ooT82Z2t
zn8KD15XA9WSKRkaWmYOhV6+bahUar2uXhGJ8+EcUTkJEbuWZHLS9RBAAdgQVsAf
m1rlouzi9Zxia2KP+HHixlsoPor/8lO39WVUPgmsDxMK3K88FE/R73DZ3pYUMdQo
TK2OIR1LY2wEGVXqErHl80rLDp/ZVU/vj+fSjQzd47x3bMcMY/jsDgwU2akjms4O
nC/cVox/xPg3LdzFCW4S1XEm+Q/2LkniclFhCpVUJzOWjldzbQ+Ng44LJYNxoxmS
Qd9xRce9dKOOdNbWDXjEL0yvSTis9hi/8+glsfp080BoObN2QbtxynRfG9mLWRCk
WObnciTF9ya4/AKpvV+RiW79dRVmdxRwb+1Hcagjj2umKaHV53bSbKIgJPJOXHoj
aOK7rDaP1B3lVvbQLk1D
=9W/H
-----END PGP SIGNATURE-----

--=-XKWcFaUQst+hbSnjUrfr--

