Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3JPDBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 23:01:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:39119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab3JPDBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 23:01:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,504,1378882800"; 
   d="asc'?scan'208";a="417480053"
Date: Tue, 15 Oct 2013 22:46:33 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
Message-ID: <20131016024633.GC6898@gchen.bj.intel.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
 <20131011090630.GB5925@pd.tnic>
 <20131011154759.GJ5925@pd.tnic>
 <1381888638.22110.43.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <1381888638.22110.43.camel@joe-AO722>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 06:57:18PM -0700, Joe Perches wrote:
> Date: Tue, 15 Oct 2013 18:57:18 -0700
> From: Joe Perches <joe@perches.com>
> To: Borislav Petkov <bp@alien8.de>
> Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
>  linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
> X-Mailer: Evolution 3.6.4-0ubuntu1=20
>=20
> On Fri, 2013-10-11 at 17:47 +0200, Borislav Petkov wrote:
> > On Fri, Oct 11, 2013 at 11:06:30AM +0200, Borislav Petkov wrote:
> > > > -	printk("%s""APEI generic hardware error status\n", pfx);
> > > > +	printk("%s""Generic Hardware Error Status\n", pfx);
> > >=20
> > > Btw, what's the story with printk not using KERN_x levels in this fil=
e?
> > > Why are we falling back to default printk levels for all printks here
> > > and shouldn't we rather prioritize them by urgency into, say, KERN_ER=
R,
> > > KERN_INFO, etc?
> >=20
> > Ignore that - checkpatch complained about it but I kinda missed that
> > we're handing down the prefix.
>=20
> I think it'd be better to rename pfx to level
> as that's what printk.h calls them.
>=20
No. pfx includes log level and prefix string both.
>=20
>=20

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXf4JAAoJEI01n1+kOSLHWOkQAJhLsRRp1+UevOaBPzfkyohV
WndTzNt978VMD9qXucu+C1VGcXT7nr/B64mWOAeZ23fFwqWFE+VXyAITg4VN2x03
n+q2OesCdFTwkQGYs/ywdkdfW+hqtrn8VLagSMv6c5vQMjoLp63wTMsQ24g6uXmr
XfI4S+xKhhVWnuX8+MzZIv0Goky2LjJxWN3wnH3e2dbKxLqWEKRCBL9fI1r1vSsx
Mqd/SqShzydfE7PxG/aNsKYTyQ0T88/uWgdLmgeATJp4n1UWYRVO1Ln+LdxSkqgS
nw/FGKCGatBWfuEm1x7DELTxzqeD6uWnv2xZrCiNFCVZ07PjK3iCo/ZMoxR9VbUj
OY25J12IurcSqrwrQhi//QnRNt2A4F/+qelEJgVTMPqNKp/3bmgd8cWpgXjVh4Y3
/STgcJ5rnXzGAfkikNYz+e4wFlETnTcOH3fbxqC403VUNeh0Im8PmGmql2wZf+Kx
J9/44hC4efj0tOtmxpFynrqsBlhVdqvlcg4rvZVAW++Y2Dd8d5BwEUwqcMR43q7V
+6wUrGDW9HMKGcbOgYnkV0bcBCL32XXdFBYk1/2AewX/FTghCIeciSbb/Oct3l/k
RBl5jFYDcI7feGWfnpQUGsq/KZ1DYblbxKrYWugUCyciytdITAPyvuKL1qNqsBpS
EM+HPyhScc8Y+yiNpxro
=yIX2
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
