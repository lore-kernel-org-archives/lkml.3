Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaLIEnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 23:43:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:46866 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbaLIEnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 23:43:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="426754271"
Date: Tue, 9 Dec 2014 10:13:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141209044317.GU16827@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
 <20141208141807.GC8739@lukather>
 <20141208162843.GP16827@intel.com>
 <20141208183853.GG8739@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Content-Disposition: inline
In-Reply-To: <20141208183853.GG8739@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 07:38:53PM +0100, Maxime Ripard wrote:
> On Mon, Dec 08, 2014 at 09:58:43PM +0530, Vinod Koul wrote:
> I totally understand your point. And I actually am a bit uncomfortable
> merging this so late too, and I'd actually prefer to have it merged
> for 3.20. But this is a huge patchset, and I'd really like to avoid
> rebasing it forever.
>=20
> I'll send a v6, with your patches, as soon as 3.19-rc1 is out. This
> will be my last rebase of this serie. If these patches are not merged
> then, then I will just give up on this cleanup, and probably any
> subsequent ones.
Since I have applied them to a topic branch, I don't think we you to rebase
and resend. Git does a pretty good job at rebasing so I will rebase
this branch on top of -rc1 and merge. Fixes can keep coming on top of this
one.

So these patches are applied, and will show up in -next after -rc1. Thank
you for the work you put in this.

Last night, I thought of giving it a try so temporarily merged this to my
next. SFR found bunch of issues with it (mostly due to dependencies in
users) so lets keep fixing those..

--=20
~Vinod


--d01dLTUuW90fS44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUhn3lAAoJEHwUBw8lI4NHIGUP/A1RL/ZQY/EDZGMf34wY1NY8
GrhyqxAbveX/rqIOfMqy90R2MbXN9gc6i7NCNBOC+BQ35TRsy8ZdmTswBZcyMNda
Y0ghtXgIZ6WszMRIYgGWXBSzpXVVfB4OOJGKpB7c29xDHF6o8lb/C8hK0TiYafdg
X0hm76nM7EBk+MjyCAoqgAupWqLiHFjG+40evOuo9BxtTHq7Hd7eSdYvEcRiJAGD
jpM3/TG2jy3S59hPdKrPYQZqqX+Tt7rdsALNu9IAE1DKfDjXQ/gMBW5MeISmcPRv
gqwJOmXN6cHMJQ1NuSsff7+homr5gBwav99HQEkn94X3heerMUkVH8Y7HeVq+lSW
Rlr6NL1W6PXrprYLybXHP42XvaFELNDeICOGt2oDW6O16H0leo08+mkCJS9mEQTQ
ToZeF6uF743UfhOWusraMvCdmnXJCz2PupS8VKLH/4F+Zsw34EmFlTDLL2T1NfID
NWKjPyhUF1X2QgbtnptiNCeeKek4jWjomEWnI1FxS11GhxAsL9Zp1cK339dBnM4h
2tj4rTd0BLFc+i3JO03ZJQBDvp8vjakpk6jeyrgHglF22f9jplu9oguvxmzdX7ls
0GYkWP2mI7Zn4Rl/iD2NByNIcPMVzKe5iHLNKD37NDP5uV3L7TU1/TPgeE1735yE
lDFjnxLR8OQd9ya8+Sx5
=H0YF
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
