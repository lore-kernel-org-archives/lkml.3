Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3IMOv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:51:56 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:42661 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab3IMOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:51:54 -0400
X-Greylist: delayed 2387 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2013 10:51:54 EDT
Date: Fri, 13 Sep 2013 15:11:59 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130913141159.GI25694@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
	Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130912153629.16487.88969@localhost.localdomain>
 <52330E18.5040405@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Content-Disposition: inline
In-Reply-To: <52330E18.5040405@redhat.com>
X-GPG-Fingerprint: B25A 5A66 69D3 1E15 2DD8  0998 BF73 F4E5 65E7 4AC0
X-GPG-Key: 65E74AC0
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 13, 2013 at 09:07:36AM -0400, Ric Wheeler wrote:
> On 09/12/2013 11:36 AM, Chris Mason wrote:
> >Mark Fasheh's offline dedup work is also here.  In this case offline
> >means the FS is mounted and active, but the dedup work is not done
> >inline during file IO.   This is a building block where utilities  are
> >able to ask the FS to dedup a series of extents.  The kernel takes
> >care of verifying the data involved really is the same.  Today this
> >involves reading both extents, but we'll continue to evolve the patches.
> 
> Nice feature!
> 
> Just a note, the "offline" label is really confusing. In other
> storage products, they typically call this "out of band" since you
> are online but not during the actual write in a synchronous way :)

   I knew there was a specific term for this, but couldn't remember
what it was. I've now updated the btrfs website's description(s) of
the feature to include "out-of-band" and "in-band".

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Once is happenstance; twice is coincidence; three times ---     
                            is enemy action.                             

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUjMdL1heFHXiqx3kAQKSDw//Yn/vpAPBkTsSUTB7DbamrEP8b8stR0lS
kOkiA7N3mnSr36MLi8NZyrsvvxPU1LenwqgpQe1dQEsiOkVuZHIQY+T1OlM8nMMI
ZzcsLw/4Y/fJEJ02ZG2VKk4YOdXS68YYph1RaWTZwPvCrUvtWrIlLy/8vm0qOFQJ
MiHAswH1WWL3l14eR9+CMdime8+zOQPaMRvezZwlFff/EMQEHIlnvy/yvdpbEehQ
gztV8RepbM8lFJQDS7g4fGd37ACByhH0ko9/OHmHOBRqvEfAa1hxkZ/DGySeH39t
rnsv+D3OyjS4v/xcShTkdPrq7XVlZBaMqddEA3Q5C74V+2mIktRYc1mTgO4ngHYz
3zgd/A393BvvYuFFbWLNVUuPAzCQhPV3YXwpwtjM/kiG69JYbqy3ttlBN1yODlr8
EJwlik7cwLWTNtsHP54QtbDFbtiSGXmXqmCNmMy+a6qI+4uJImInWFW3wmq5rldI
TGn11ddHDd8QSUTZiZZMgQRIgaKScdpH89D4uU20dX/j2Pncvh5UzbdynV8GEgQi
HX2vzwHgNDhr4Q5Cfalq2txBV2RK2ZtXgxqw0BVmKDbZWprZ8dgPaiBnKf9OUCSK
iv8O1LuO66/n3bU7fmQUTU0nMTR1fOrTDaUQxthb4Zo7sq7TJBvZr7Sq36NA3lSn
SE5o7xAInrY=
=mKzG
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
