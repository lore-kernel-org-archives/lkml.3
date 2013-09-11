Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3IKShd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:37:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3IKShc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:37:32 -0400
Message-ID: <5230B86C.2070708@suse.com>
Date: Wed, 11 Sep 2013 14:37:32 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linux.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: introduce kobj_completion
References: <5230A1AE.401@suse.com> <20130911171508.GA29741@kroah.com>
In-Reply-To: <20130911171508.GA29741@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VlgXnjqfALOPPCTTWX0D05j1XGOttH6FR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VlgXnjqfALOPPCTTWX0D05j1XGOttH6FR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/11/13 1:15 PM, Greg KH wrote:
> On Wed, Sep 11, 2013 at 01:00:30PM -0400, Jeff Mahoney wrote:
>> A common way to handle kobject lifetimes in embedded in objects with
>> different lifetime rules is to pair the kobject with a struct completi=
on.
>>
>> This introduces a kobj_completion structure that can be used in place
>> of the pairing, along with several convenience functions for
>> initialization, release, and put-and-wait.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  include/linux/kobj_completion.h |   18 ++++++++++++++
>=20
> Does this really need a new .h file, or can we just cram it into
> kobject.h?  It's only 13 more lines to add to that file.

It doesn't need to be, but it avoids everywhere that already uses a
kobject having to include <linux/completion.h> indirectly.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--VlgXnjqfALOPPCTTWX0D05j1XGOttH6FR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSMLhsAAoJEB57S2MheeWy4bMP/1jr6XGF7thofPVWBWzJYpSG
2FUWbBITSW/4hEd2p0K8DUS9nxZFg5mQ2K/c3siYY6a/qbWgBWnbjpkN1UVBT7Yk
8jF4sitK13b57gp4CTfBRKiOakegdGk5DQjKUqqK2RFoCieQ3Wkc92g3qXCb6c8C
P/QP0IPQ+JcOaMed22ystlr0uR+tbUbNyVlhICFj/qI8kBJg8PZ1O9AlqjgRkAkT
KwsZBHMJUsaKpgHe1MTOW6lgbL68NheQyGxVfGp7ar0tCbjVKe1iIvDB9DFLFWVF
QVDRAGpsiPcqN1J7MNQJ1Gq/Uu+nD9bwQrTVXBZRZqRAgeTwrIyvol3EPKhYFkwB
2IbtZvO1pTmFoewW4hiewOurVYIkJZaIMIR16f2w82mGGlc35ZjdZFvx2KocleqO
sJtqYH3lvY+vUxR9D5qUu5+1o+O843310zIPeJlDFYd3xKV3STD728w/nq6df46X
FOodCbD33GwILNJ9m5FLjvXnRVSetvo3IPj5FFo59aEIABhvdix3wGPWw8Kqn93w
lFR4RwocO4DRwhtlZZnsEa4V+ijBmENAPfRDp0PoNuMo/jJjYXdpftPkaVCywwHZ
nK2P4EUeh4pLT2gs7XQFXW7lNPVka/rm9EKP83l/H0gWNLOiDNG325+NJTRsruT9
jBBZgEaxDxHp3nV93Glt
=Mmpi
-----END PGP SIGNATURE-----

--VlgXnjqfALOPPCTTWX0D05j1XGOttH6FR--
