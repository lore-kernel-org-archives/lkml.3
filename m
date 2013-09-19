Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3ISW5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:57:38 -0400
Received: from ozlabs.org ([203.10.76.45]:54352 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab3ISW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:57:36 -0400
Date: Fri, 20 Sep 2013 08:52:32 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jon Loeliger <jdl@jdl.com>, Olof Johansson <olof@lixom.net>,
        frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc PATCH] Ensure all tests have matching reg and unit address
Message-ID: <20130919225232.GG3551@voom.redhat.com>
References: <1379535782-12667-1-git-send-email-swarren@wwwdotorg.org>
 <20130919121818.GB3551@voom.redhat.com>
 <523B3935.2090904@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
Content-Disposition: inline
In-Reply-To: <523B3935.2090904@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2013 at 11:49:41AM -0600, Stephen Warren wrote:
> On 09/19/2013 06:18 AM, David Gibson wrote:
> > On Wed, Sep 18, 2013 at 02:23:02PM -0600, Stephen Warren wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>=20
> >> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that
> >> any node that has a reg property must include a unit address in
> >> its name with value matching the first entry in its reg property.
> >> Conversely, if a node does not have a reg property, the node name
> >> must not include a unit address.
> >>=20
> >> Adjust all the dtc test-cases to conform to this rule.
> >>=20
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >=20
> > Yeah, the testcase examples were built as purely syntactic
> > exercises without really considering dt content conventions.
> > Fixing them up is arguably unnnecessary, but certainly doesn't hurt
> > and makes them better as examples.
> >=20
> > Applied and pushed.
>=20
> Strange; I see that the git author field ended up as you rather than
> me. Did you need to apply the patch manually for some reason (if so,
> what did I do wrong?) or did something go wrong in the patch
> application process?

Oh, dammit.  git citool did that when I added my S-o-b, and I forgot
to fix it up.  I just patched it up and did a push -f, I hope not too
many people have pulled in the meantime :(.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSO4AwAAoJEGw4ysog2bOS3/wQALky3Ze+6SDh8s5Hlne1dRSg
SJlEVe6EGQsThZVdm+jGrzuEDoNUVglxI46GaaodPjuvH8HsSJAYKKS+kxQ08jnR
hip3+hxP2USyUJ9P3Ucz/FpSoJy+pmy0SK+D3WsdZTFU1pGTjlDL5B6kHH4YSIgn
IXMn9WnrEb+XsK67p2eK0h5Ru82Ht6EYzwaMM+HmAaiHosP78ThXEdraI0H6DhLG
piv2yctkwGC2auLQtIn6TLSA4wbule3RfApu/sKkxMN+oESveoradci2ApVmeQSt
2F64cIUwTG0AIKX/10jUw+qObFXYlC6Ct9eKkukHo2ozAYrSHf/tezHQ07KN0j5O
erjiuw1CP878Kd/zJCGtdr+zBu4iwzChOxwqphXg7QnLMwDVKmuI7otAXrAioPTb
bogsmJmwHpQn5yQuMOLh8fUxEmwNe9oX7ngl/JFY/kqcVJWQaa5GrJ5H2nIKxtrD
VK/yZJUri7pRCW1fLKGKUhThDDakrsmhkFqGTp4eqKQ6gr2yJ3F1lomyZp5lU4UV
uPXzKtTJ91Xn5M5ErGhqsDrbJn6HYthyXqfh6jafIHbuPJBrysNDGN66THZirVbV
yrOJ8un8CANMmFT3jIdjrCBASy+mPD4/jEga8qVvQKEe3iS9kulbm/G7tuHn8swy
V5eeFstVJUHbtzTQbd/w
=JfYx
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
