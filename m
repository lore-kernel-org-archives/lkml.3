Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaJOVmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:42:00 -0400
Received: from libra.uberspace.de ([95.143.172.171]:56077 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaJOVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:41:58 -0400
Date: Wed, 15 Oct 2014 23:41:51 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141015214151.GA20142@fu.3gs>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015123431.GA23154@mwanda>
 <20141015125934.GB23154@mwanda>
 <1413378213.2412.13.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <1413378213.2412.13.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15-10-2014 06:03:33, Jeff Kirsher wrote:
>=20
> I thought I remember Greg saying something about getting rid of this
> driver anyway, but I could be wrong.  If Greg decides to keep this
> driver around, then I think we should something like your suggestion
> above.

Let me throw in my comment here: Yes, Greg stated in several places
that this whole driver should be removed. I was about to ask when this
will happen, so let me add a suggestion:

    Lets delete this _now_!!1!1!

If you care, I can search the statements where Greg stated that this
should be removed, but I guess this some effort... I can barely
remember that one time was on the linuxnewbies ML and one or two times
here.

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPuofAAoJEJi+S08gyg+UfUcP/RPrwUOwDfkc0zNYNtJjw8x9
3pOBKiRAqNaj+En2gD5ikthNmFPOuqLE7QuWDhRvPnN94piQSXOSM55wYQpuvYQO
x0DMjulY/MvCV7og78A0DVZ3Q/CGmvyBRi5chDVW3zhtPCcHrDA4WC0oLI9f7nCB
AXLZ6Eig/4IoLELpzrvHUA3TCPyvWaNeEJEJFJTMUTLbNe/rpbPo7nCJSt0U00ei
6jg9RIfBZrqoGzoI9nbX4zyXy7B0N/7dHcH/4RBgcwCv4SP3XM1vDPBHKoM70qv0
jKwI1cuYh2S6zl9sPW7VF2sO9P+owjzcXjwYyZdXdkkOPJfCLGqH62TDYLAhf17n
A3vafSSm/eOnHaqyYjlcD8mdW6OaG8qX+cBXGcm3eq3MEuATt/9b7fE3jBYZ/rEx
Vk5WDFwnpNSex8p/cFl6/znvO8c6e8jUFvfqbo+epGYBPSOB33LX6BJH8YK9bHqm
FZyzNgeeHg2g0lKzWszSz8cj/JjTRNwWzRDM0ohkjJ+yTTxNAMpCmFGikmuHcK1I
9usooag3IIG9xpmOU+GMYMqOtDbIxCzpPybpNfbvQK5DWKGMswty9tp+nFi3PKYI
vSQspjgqOxn198kTnGk5J7wybXIdgWDFI8gQtJxV/G9WwCI44fyxJQuXGG7+Y5ed
0Ofbld34GtHBlL1UVmHa
=6XB7
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
