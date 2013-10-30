Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3J3XTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:19:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38741 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3J3XTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:19:03 -0400
Date: Thu, 31 Oct 2013 10:18:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
Message-Id: <20131031101853.9fb4e06d591d0ed6be768c4e@canb.auug.org.au>
In-Reply-To: <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
	<20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_10_18_53_+1100_ga.nrp5dI+qe9.6."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_10_18_53_+1100_ga.nrp5dI+qe9.6.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 30 Oct 2013 13:48:39 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> I can't immediately think of a nice solution so I guess for now I'll
> drop printk-mark-printk_once-test-variable-__read_mostly.patch.

I have removed that from my copy of the mmotm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_Oct_2013_10_18_53_+1100_ga.nrp5dI+qe9.6.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScZPiAAoJEMDTa8Ir7ZwVQKQP/0x5M6Z6d7dORewZYw92d0fE
G4SrYDa5vI1Jzh619lZTTs4q7wd4bJNFddiglYj7auHpvK9uNI4Q/ohWKmqrdELH
DT90M8F9WbJi3fhvzF17RBppLeJzI5AP/DwRz5Ez/5XjwG5M6TGs41BCXzsiySSm
Ki4SsQOuIbNASGHgi6Q76TJs4EzVGFL8BAibEqSLfXRmmBVZCOm10val7JggiNNC
PgP0Ca4v73Lr9RM417ToSbSBk5fKpmJln62hvgTFSQZS/sQeP9IBCKe3FFVVF9qw
AwUnsUk4ZIFunb4A0OrzMfzvaskhUS7PsJ8bqSwCVQZ2zHdnaIUuNgkMb6G5RxWX
FQt+LKgmaHBHBZ0O5/iLAoJxJTYHFNJDjB4AQmoczXgxpwAXjNnWd3OexWNDNCkg
Rnvt4VtVrRTjXycX11+q3vanS1yVjLjITLstklzNzrGArjlzs2RuzXA4xWutT1D8
abIBBAjZ6GPdh/lXv+Zzks3wDzMP39o8oZu2NT4TTWB9pdeE8Kwu33wlvLJ63o2U
OSZuzWTYipUylu/3bWGeEqkNzPwaGWbTOYZMSBecG7oTWwaVQUr3BOjOY0FSkwdg
H24NRWgAt8YwWLEQynNxl0cEFSipj8mzFz8u/2bWtOGYILiQqSVUBGCLUyCLu3pX
61hAHpyeGjvEYQVdzp5r
=xHDI
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_10_18_53_+1100_ga.nrp5dI+qe9.6.--
