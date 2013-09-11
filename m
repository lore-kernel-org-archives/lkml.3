Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3IKSfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:35:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab3IKSfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:35:04 -0400
Message-ID: <5230B7D4.5020405@suse.com>
Date: Wed, 11 Sep 2013 14:35:00 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg KH <gregkh@linux.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: introduce kobj_completion
References: <5230A1AE.401@suse.com> <20130911172813.GL13318@ZenIV.linux.org.uk>
In-Reply-To: <20130911172813.GL13318@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4q8o70j5wV5kbWCeHSIQQAprPrVQLmquu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4q8o70j5wV5kbWCeHSIQQAprPrVQLmquu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/11/13 1:28 PM, Al Viro wrote:
> On Wed, Sep 11, 2013 at 01:00:30PM -0400, Jeff Mahoney wrote:
>> A common way to handle kobject lifetimes in embedded in objects with
>> different lifetime rules is to pair the kobject with a struct completi=
on.
>>
>> This introduces a kobj_completion structure that can be used in place
>> of the pairing, along with several convenience functions for
>> initialization, release, and put-and-wait.
>=20
> That's very easy to misuse, leading to deadlocks...

Misuse how? If you're using it any time other than shutting down an
object, you're shooting yourself in the foot.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--4q8o70j5wV5kbWCeHSIQQAprPrVQLmquu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSMLfUAAoJEB57S2MheeWySLQQAK9lBKqVzWvkPudVZdofhWqK
DHsFCT8yrGhFXueipnW3oxznXzvLfbYuNXzW71vWNUPH9sg0dk9WW1OHhK/hxNK1
wsnjMUphNCI+ng+9QHVPKelnkrA8UeJm2Zn+CFWqk4KZoPNfdkZR7HvVN8ObL5MB
Ppbheh5fN5rxhCSEAXAwXy5/ZFrcmrtelD6Flf4b/0Xx7G4Hc7jIp8j7D66gIs08
8XXusjqCuJI5yf73w6SsE+QlE3XfJ68lGfVc3tBnBO+U99YN0z3FYi7XOKDUgwVo
yns2iKNzecksUMbl4A+4R4bOVpvvuwa9/+9mfP7IyVtAJ6Ixev/RZ2rI/rOD42cD
3bND5gfPL9S+0+/7epfU4i7IYo79MWQfsEBOkMUPEweIlzeOnDILxhqPNdwd6gQt
Z3jOWGkoe9ESyorirW/XN/NZr9dPxeeRgvDBYmCkDi16f0fpR7XXzcs0z/7tEOX+
jKQbDbxjGX2/zb4XBljqVuQD/05zrhlxvulAdFg6MRoRlXYdYx0bo/rJiaEvCn2B
4/W9G7nyBUgSHrCpuv9j8gomQl2t80TS5NTNoFcRKDfhSwQmnqOuMyC3BgsnnNKB
HJrOqM9CSCljKE1hh/SzItogCxFzdKpdPx58iHylEyDR+2kZo4gi8aiu259daVZl
N7tT9Yv16FI7XWEa1jhl
=oDtW
-----END PGP SIGNATURE-----

--4q8o70j5wV5kbWCeHSIQQAprPrVQLmquu--
