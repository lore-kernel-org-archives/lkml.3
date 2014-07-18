Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbaGRIby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:31:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:14836 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760339AbaGRIb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,683,1400050800"; 
   d="asc'?scan'208";a="575106618"
Date: Fri, 18 Jul 2014 04:00:56 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
 accelerate S3
Message-ID: <20140718080056.GA2037@gchen.bj.intel.com>
Mail-Followup-To: Lan Tianyu <tianyu.lan@intel.com>, rjw@rjwysocki.net,
	lenb@kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 01:55:22PM +0800, Lan Tianyu wrote:
> Date:	Fri, 18 Jul 2014 13:55:22 +0800
> From: Lan Tianyu <tianyu.lan@intel.com>
> To: rjw@rjwysocki.net, lenb@kernel.org
> Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org
> Subject: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>  accelerate S3
> X-Mailer: git-send-email 1.7.9.5
>=20
> NVS region is saved and restored unconditionally for machines without
> nvs_nosave quirk during S3. Tested some new machines and the operation
> is not necessary. Saving NVS region also affects S2RAM speed. The time of
> NVS saving and restoring depends on the size of NVS region and it consumes
> 7~10ms normally.
>=20
> This patch is to make machines produced from 2012 to now not saving NVS r=
egion
> to accelerate S3.
>=20
The year 2012 is a mandatory value in the spec?

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyNQ4AAoJEI01n1+kOSLHHa4P/0T6DZAB+eAZr71j+Sg3Dl2G
NYpjLyD1Tfwksj5U0s5Kl4XVcxvb61xpbnDzkeSc4MzE6KOs3+TK0MTUm/GOJUnp
x9K/W1YFmkQacgNzdNGDCSsz+o7uqgOMFdFgn8xP/NfHlR+r9jbBbFh8vlsB+3Bx
VWrHsMmjgnikpjFrpvWRtjdrQhFHKReB7c+mK0Z74+3+GODn0nQZ/XQHa2Rhj0MP
9l1GeCiGtFtPM5Am/cUQcu0AAIshNTGBaw7Yv7d3VAMUkZOCx2NJJzUyjekGkdGO
N674Ce2qTvpg8vOZzIxKQHlb9KcntM9o2tcyVtQhMdsO4Xx87fb999V2USv4H6VP
2HnjJJoc9xXRJ/EsUf1NeAgzmBJsmAYKgcmCmwSte11UzQXIrJG5s7VJjj32zbZV
AuSNTMDNQpoP14iX6klKC4cqYdYRjLIs1MJTvMX+CaPWC3JWPyXMyxHNK2d7zfzY
9s60a2X1e+1IzosCPJtT/q04hFPSy5ZHxeXYgvCVvbRFWhmNEHb56oopCzG/u4nQ
MZeLdWcH9jRRMRQZRUSFNUr1JpF3xtOTPC0LyWBEgUU/GfvWByqiPodvZ7hIFok4
w4Tn+zcBaYgYvvtZDizFJrBx4sWiFHtITNQ6Ty9Badx1K/MDQt4nSKi4k+hQK1gd
/iDFIIiAf+0Vhb7MIUI2
=mJBV
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
