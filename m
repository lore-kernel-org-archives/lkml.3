Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaDOCxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:53:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:47767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaDOCxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:53:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,861,1389772800"; 
   d="asc'?scan'208";a="492977177"
Date: Mon, 14 Apr 2014 22:28:07 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, MCE: Cleanup macro __get_cpu_var
Message-ID: <20140415022807.GA29868@gchen.bj.intel.com>
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
 <1397464777-25451-1-git-send-email-gong.chen@linux.intel.com>
 <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
 <534C0B6C.8070109@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <534C0B6C.8070109@zytor.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2014 at 09:23:08AM -0700, H. Peter Anvin wrote:
> Please read Documentation/this_cpu_ops.txt for reference for how to use
> these functions.  However, you want to avoid forming a pointer if you
> can; it is relatively expensive to do so.
>=20
:-). I just found your comment yesterday so that I was eager to finish it.
I should do more homework as you told and send it again. Thanks very much
for your patience.

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTJk3AAoJEI01n1+kOSLH9twP/i/T8lqxE+NpQ/SwXZtf7vtB
HYxnC61DZNqpFq3VNEV3R3i2h3RQ8VWB+ukDDRBTJCsgjyThHLvyaNTM6U9VuTFh
ASNzBpU0z7OC1CtYa08lKnWM7/x5oWcnFfrwGneOOCOUQvUOEaH4DOeyE2TQV4cx
1ezWuOEZXP6C1Pt/FRQEcTXFfpaXZ+XY3GVXVfwUxEhPd8bpdngQ3uxVVNgYAqWj
24jVhswXA0UvUR39b95jbFHLW4I0nPe/fsOx0OzTF41o+yjsyr576qDG1NCdQJmO
uqIqXNVUdZueRUuTJ8vXNJVMS4P/zVwsBuCvGj3mnNBd1Yt3egHqE4T1TIxh7od3
HS1I1pAYc3BELHZxH1LPx6BAZx+goP1vQUkcnDJzUhw98Kh+baJ2tM1bYKWsKalE
Sb3o2zEq7s1YwwiJv1Ve4TRjnFHWNbRu9l1zy2NYoOdeLCdAblN5J/Xc1w2d6jwq
YkTGo7gR8uyjFw7IReBXDetzRxM09xEy2XhQdBCW8CfwlrZlSXSxBAtPl4E6DfLX
Q6swg3mTTP5fAIT8PDWjvLBvLVktI3PyPmLtn6sIRxHMolfjkGh8X2WSTVrmOnuP
X3FYpPPMYpGLHk7ybd0ZYMhFhl4NKdRl/mLsa6BLrpWjw5dLp7XYaAburpZPF3GL
uX3darWeW1FpiuE6CjVV
=2EIE
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
