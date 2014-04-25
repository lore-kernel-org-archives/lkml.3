Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaDYJNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:13:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:7756 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbaDYJNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:13:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="asc'?scan'208";a="527192804"
Date: Fri, 25 Apr 2014 04:47:23 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Owen Kibel <qmewlo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140425084723.GA7455@gchen.bj.intel.com>
References: <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
 <20140417205807.GA27852@pd.tnic>
 <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
 <20140417213012.GC27852@pd.tnic>
 <20140417222028.GD27852@pd.tnic>
 <20140418080716.GA14280@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20140418080716.GA14280@gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2014 at 10:07:16AM +0200, Ingo Molnar wrote:
> Okay, so AFAICS the fix in x86/urgent isn't wrong functionally, it's=20
> just that the changelog incorrectly claims the raw-spinlock use is a=20
> bug causing a problem here.
>=20
> Still that raw spinlock is bogus and might be hiding other problems,=20
> so we can keep the x86/urgent change (ea431643d6c3) as-is and I'll get=20
> it to Linus later today ...
>=20
> Thanks,
>=20
> 	Ingo
Hi, Ingo

We ever had a patch(59d958d2c7) to make spinlock -> raw_spinlock.
Would you please explain it a little more why you revert it?

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWiEbAAoJEI01n1+kOSLHLGQP/jvLEr3Q4HvuanJHAmc9BzWC
97fA3Yn9F8pPLSoczCbe/IpAL5TmZ0co8BeoYJCN9I/lMmzYy5DSzNaoV8nY+aIN
1Xoagg1UvzIut7NqR+qcL+8F6XsyLBnq2Ce5bpZrO9Sn/gMTF+pa2GKBOS62/8FJ
ylxx3kzQ7x7B9LVYHtdYpW9zitDGhJ1i1UjyyR5JN/ShBvVp8WNEEcaX6P2bJ3Gq
d99jvvruifX8fNklNxUubVFweK7Rj1QXHjovNxKFcM9Avh1tc4BmH08wZqbE4VqR
wpBVuGOaQlU6UnbunfZKGS9Nj8/9H8BZa3L2gWT0xADF16wbUAYBA926lMotPyaD
lphMo1INWtHFStJZGS7656l7gaSwYDADuBGCXPqwymqMyfbt33LaSMpZTzvZjOTf
UcsovCk0Roi3GfnLdORSi+J6vlQNuJaCIR2AwznZCMBW4DIU06s2C/lRUI/30mcZ
vbZ7qcUp5DOyBnCZYC4JsyR4ITML9RbsLVMsAeMwCGWKILs/5rw/Mk/Krt/E18+k
estDWfo93epgu/NCOBQ/BziNDZuDhgyRdNJk5BHM6JVEYZQSePE9uqQJdgzrZ2zn
CJ/b1TdF14SrkGLH/Mf1TQW2yNkVfW6UmFxwUFdrWTQDcg6sdGZhf2HRuCKH8h0g
5TwKBe0nYjKeRIB6oi5G
=fCI/
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
