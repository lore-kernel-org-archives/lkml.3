Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab3FMBPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:15:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35770 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775Ab3FMBPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:15:46 -0400
Message-ID: <1371086125.10688.5.camel@deadeye.wl.decadent.org.uk>
Subject: Re: https://lkml.org/lkml/2013/2/1/531
From: Ben Hutchings <ben@decadent.org.uk>
To: "Matthew O'Connor" <liquidhorse@gmail.com>
Cc: f.wiessner@smart-weblications.de, Greg KH <gregkh@linuxfoundation.org>,
        davem@davemloft.net, andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com
Date: Thu, 13 Jun 2013 02:15:25 +0100
In-Reply-To: <519D5206.8080701@gmail.com>
References: <519CADA9.9060909@smart-weblications.de>
	 <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de>
	 <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de>
	 <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de>
	 <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de>
	 <519D5206.8080701@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pPvnrOkOXqbeVV2sukpc"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pPvnrOkOXqbeVV2sukpc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-05-22 at 19:17 -0400, Matthew O'Connor wrote:
> This is the backported patch I submitted previously.  Hopefully this
> time around it won't be too messed up, I'm using Thunderbird instead of
> the web interface.
[...]

This was whitespace-damaged; please read Documentation/email-clients.txt

Also put the description in the subject line, like this:

Subject: [PATCH 3.4.y] bonding: rlb mode of bond should not alter ARP origi=
nating via bridge

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-pPvnrOkOXqbeVV2sukpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbkdLee/yOyVhhEJAQo/kRAA0gU25A0vZTiFQdPYNsUy1ySGZ6hRJjOW
BdOJSPSvHTgVIxC4yrpx/u76DdHBurjQo9RsC0emvDbi5MGDmaFTh4/5TF05QD+z
Kex+Tn6u04Wy5IUM3KEgXoFpzC0+MP8eSbpvYdwzKZnuK32W0cKP6VGOmZmQ/Rr1
pAvc4aKFN6V2smrK7cq0nrvdTRq0hzwGYZPb9Gt5JIWf1xOiVmsE/dHMIIbvymOs
1Iqk9FKgzAZkcIIwwN3lG8LvpyGolSkS9o2p8Julm4O8I6tnwKdBxbWRbrY2JfVa
o1HwjqfHHIPzdoFgVO/TCMpmlN4AoSGHIrYDG+IrC+gFcEXn8FS9dmyfDeviuLXs
fPJ6Z5zHBwTwF2RxOwsdiEB9hZ54QjitHBcKQtEIbSyEpbsFUslwdgYFhKyHFH5b
DlmClFSDIDhvBzhu14F5Pu35IpwvFwaLajpLvp7tcFZw3tc9DeW4FBalKHLMO1Rk
4iPTH6C3Vnzrbb2+I0XN2kCwTFKaKXZWpLDz9lHdaLOQPToMDZ9OuX6lO5rrE2Y4
A9FFY/+T3vNfjCpA+mXUKt2I5LD/zZyMSioLLWQCsFIOZfl2z8DDFvocHdZGupdY
GA/eB9SRtryOcYaF4si2UVrFHbbqea/DUkmNJTovv//lXqneos02Jxb0G/R4UyLk
92U7FJvh9YA=
=ZghB
-----END PGP SIGNATURE-----

--=-pPvnrOkOXqbeVV2sukpc--
