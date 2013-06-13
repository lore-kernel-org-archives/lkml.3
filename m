Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3FMWRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:17:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab3FMWRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:17:14 -0400
Date: Fri, 14 Jun 2013 08:17:01 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "H.Peter Anvin" <hpa@linux.intel.com>,
        Alexander Lyakas <alex.bolshoy@gmail.com>,
        Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PULL REQUEST] md bug fixes for 3.10-rc and -stable
Message-ID: <20130614081701.191f4574@notabene.brown>
In-Reply-To: <CA+55aFyU6jNB7fbhBsAo9qLh-az5nKHi+f20saGyq6KeMutv8w@mail.gmail.com>
References: <20130613173641.08b56b4c@notabene.brown>
	<CA+55aFzufX_3eLPHYODCUO3FkGe0ngaqx7xbEUWUnonuF+MC7w@mail.gmail.com>
	<CA+55aFyU6jNB7fbhBsAo9qLh-az5nKHi+f20saGyq6KeMutv8w@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zmMN/.nJ/iu7BtlQQfbq=s8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zmMN/.nJ/iu7BtlQQfbq=s8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Jun 2013 10:15:40 -0700 Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> On Thu, Jun 13, 2013 at 10:07 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'm not having a lot of luck fetching this. Is the machine sick?
>=20
> Ahh, either you kicked it, or it was just really really slow. I had
> left the pull running, and now it got through.

Yes, I had an email from the hosting provider over night saying there was an
incident with network slowness.  Your "git pull" must have hit that target =
:-)

NeilBrown


--Sig_/zmMN/.nJ/iu7BtlQQfbq=s8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbpE3Tnsnt1WYoG5AQL9Ag/+K0dMXyzhC/PkEDMrR9kXtaPPLkKcU2Ci
Dqiqn/yT4OyMtcyTwSp3IiIG1mtq4YWh76KDXLT7hhEk311Wco+lOQLJ45ht4ZGl
YUNAlXzuXxOvfNOHbQTEjL5mhS4/+ZU+X9YPcvM2SDxNeGPmXY1ZLawc2V1Hii0k
AqIhqnBq5Bf2FQel+adXhogB7MHdOqFdZY1UNoMYxT9AnvGqSKzYw8HLkZ5WnKNI
u+1LsNCkr09WtOKoiBX2xmIPVxWpfUVvXRA+RUdrzBfgRn9dqfqHDj78Y+Kcah+r
wg1b5pxD0FMK0tHw67zVO3ODtJYoxuVaxt2rrgqvFi6/NDwx7iaZ/qA2jFudAti6
tl4SPRtfNU3Ukhp76o+dW5tREwzHAbYnnRHPVSZ6RwPiT0dd+7oFRS4kWKUubYSg
pzoSYbgxSvWhwGI+C43MOu8hJwPSuO41w2T0PbO7aBmJOCif2J4g1pseKFcA+FiO
DMxSy5IshGkU/vre+l7ZoakTbgUv57k2i8f2KlA/JuCrinX0OplBXCpD2BXNbUUN
lZ8IFc1gBLRMACX7yk69ISQNX6I+JfHx5q9rbn4RlUl6lSqIobDK7gDH3R9+wbHQ
LWGapas6UcdXIevdAzqD/MEHk0lvGk+DQJLaXc4PIhnf3FrZiJh2ZCzosjSrT/Bm
q0gdiKYVH/w=
=74Vu
-----END PGP SIGNATURE-----

--Sig_/zmMN/.nJ/iu7BtlQQfbq=s8--
