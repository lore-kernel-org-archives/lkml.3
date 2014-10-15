Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaJOWUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:20:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:61134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaJOWUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:20:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,728,1406617200"; 
   d="asc'?scan'208";a="615180892"
Message-ID: <1413411584.2412.35.camel@jtkirshe-mobl>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 15:19:44 -0700
In-Reply-To: <20141015214151.GA20142@fu.3gs>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl> <20141015214151.GA20142@fu.3gs>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jcrbYxod4abVEQ2g0AT9"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jcrbYxod4abVEQ2g0AT9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 23:41 +0200, Matthias Beyer wrote:
> On 15-10-2014 06:03:33, Jeff Kirsher wrote:
> >=20
> > I thought I remember Greg saying something about getting rid of this
> > driver anyway, but I could be wrong.  If Greg decides to keep this
> > driver around, then I think we should something like your suggestion
> > above.
>=20
> Let me throw in my comment here: Yes, Greg stated in several places
> that this whole driver should be removed. I was about to ask when this
> will happen, so let me add a suggestion:
>=20
>     Lets delete this _now_!!1!1!
>=20
> If you care, I can search the statements where Greg stated that this
> should be removed, but I guess this some effort... I can barely
> remember that one time was on the linuxnewbies ML and one or two times
> here.

No need to dig up where and when Greg stated that it should be removed,
I was pretty sure he mentioned it on several lists.  I think the most
recent was on the linuxnewbies ML.

I will just go ahead and create a patch to remove the driver.  Greg can
then decide to either accept the patch to fix the Kconfig or accept the
patch to remove the driver.

--=-jcrbYxod4abVEQ2g0AT9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPvMAAAoJEOVv75VaS+3O6QEP/3tVWSz+KvA7zClQjyiU4md9
RbYFtvcxeoC5ZJa144ALFCZKYQ90L+R7lZZJoUOp7hmCtCEAlpYkf6bGceN/sgn9
dSixVDgeSgw0sPnxndapl+hHwjTBSEhQJvY3oNEe3tMOD00SUl6nF5gkbe89P1n+
DCU3fsqNVhuwPc3clCF4DM4ubA3n0MCiLSAajwnkIOqbVbbF4bGFFYpSC5F9gqDd
GBkD/ltbwJY1Dv7MT1LgfgxTisOnw1kMqxALh6Y10D5TqccAByDb6kUc5EiV4SU7
rRegl/l5Oru9nW+nAeQ48B7LBCz3LGQ8zqa4bIMTFstxrRLy9EL/If+uUSLHh87/
zOFZZy3Q1VZOzA7UmflAuL4NLmoTHYUqXAlil96e7tBgezyQylbLJLBiop+Rntbm
ouxR1HYF4JT6AtdZdWJTibgetC3EqNIp9Bh50kWupN6f2TO2sNQE/YEG0gGv289T
ssOdrElkTcE1yQYvJOQNePczWk/WlbN2fNOEG3+cJyp8qjd4O1iB3fj5kZSPYxlT
AgY6fWqn3+aFJFs1SjVfqvrDQ6H8Urr66oGMDm0QjDUfJqOWX8hnYyi5a5K1M0RJ
Mn5ZKUhwKyDGnOm4KycTcAWSR590Q+SRCSZ45kluOBQ53Z8zSP3UukDux33iBrqR
3uxzTVWnwOYjcE0C+Rck
=Uy0r
-----END PGP SIGNATURE-----

--=-jcrbYxod4abVEQ2g0AT9--

