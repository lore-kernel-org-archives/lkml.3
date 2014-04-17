Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaDQEbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 00:31:48 -0400
Received: from ozlabs.org ([103.22.144.67]:39605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaDQEbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 00:31:47 -0400
Date: Thu, 17 Apr 2014 14:31:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20140417143137.a66d4f53a928fd454911fa50@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_14_31_37_+1000_fKS2./I1ivEWHRhr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_14_31_37_+1000_fKS2./I1ivEWHRhr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/rtl8723au/core/rtw_ieee80211.c,
drivers/staging/rtl8723au/core/rtw_mlme_ext.c,
drivers/staging/rtl8723au/core/rtw_p2p.c and
drivers/staging/rtl8723au/core/rtw_wlan_util.c between commit
f5d197b614d8 ("staging: rtl8723au: Fix buffer overflow in rtw_get_wfd_ie
()") from the staging.current tree and various commits from the staging
tree.

I fixed it up (I just use dthe version from the staging tree) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Apr_2014_14_31_37_+1000_fKS2./I1ivEWHRhr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTT1kxAAoJEMDTa8Ir7ZwVFJYQAJI4cNELecDPYsWJnrTEcw3z
iUFXbuAMil+l+IB6D5FBvL2RaW5PzVDOsizqqczhZTEPOUaB0icSb+qB/+XYU5dQ
P+QFuekBHe1zaJ+0BT7luRXH44DhAsFtsnWW7+X5NrP76c0XK+Vesp7Patxzb9pQ
eiVO0GGlDyiuViG0jhJ4C0jlNkxjsmmEdAfbA3wpzP2jiThMhzB/HSuBoU31rRLR
ILjO55WypWeocexdQPYpfNYtYFiaQg/UEVKfZ8ZxrUOQRh5DXkY+w0q0/SaWAN7t
Bw8p1GFnWii4jgl9x+fv4JbTQGMgd05XiEPUU9MtS76D5Eve00cuOjYuqFyu0OcA
EvIJfa9jmGksOg5WIAqG8sD+lXVoaDfQfEHSpRVec4O6abyfyi/Fmf199B2Pxn8k
6VVdsSjPPqjU08dZEuXfqA3o9nMnpi/NMOZv9o74ozFm7uWMSAcQLNbooWUcRalE
pTwHQq9x6OS+9e9UAcslNV5GWd649nSnz3oM9A5Uq81exTEEUDKvSzHjsDTZ5q4N
FzoHE2EAe1D56jcPjuOy6ZNP2lquN6nO0m7fTps57xZ+Z1J6HV+kml/GdGBmDF4r
KgeHfIhKuhpziIClEt9yQDq1f9sx1YFjY7bNlVNwfnLe8FXnRKgGuqtsFuIulAg1
3TSF++qn346gwJjMA3r+
=2pp9
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_14_31_37_+1000_fKS2./I1ivEWHRhr--
