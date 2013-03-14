Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3CNXOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:14:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39604 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3CNXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:14:51 -0400
Date: Fri, 15 Mar 2013 10:14:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error importing the device-mapper quilt series
Message-Id: <20130315101441.2fd9eb05f1f9f85c1768bba9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Mar_2013_10_14_41_+1100_rQBvDqLJXApQl1Sl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Mar_2013_10_14_41_+1100_rQBvDqLJXApQl1Sl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

While importing the device-mapper quilt series, I got this error:

$ git am ../quilt/device-mapper/dm-cache-policy-fix-description-of-lookup-f=
n.patch
Patch format detection failed.

The patch in question has no commit message or headers at all ...

I did this:

@@ -1,3 +1,6 @@
+From: Alasdair G Kergon <agk@redhat.com>
+Subject: dm-cache-policy: fix description of lookup fn
+

Please fix it up properly.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Mar_2013_10_14_41_+1100_rQBvDqLJXApQl1Sl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQlnhAAoJEECxmPOUX5FEWBIP/1u+5iwNdQS5U7P3eZhX5UfV
X7S1o0JZ5zASR3hqy4bmN5Dlyd7L3qzQWY06pRgdRBfwSCDmy7MsfyWpG8fg3JLM
oxFq1XWnMv9Szg+XtOxJfjGHIzy+cvY+7AVBZYTNjl1T4bLdNI3LPHjoo/KptP7T
+2dJ9g+dhk/Bpsrv5fRL2MHIDy97JbQ6Np4ACYdrWry91BiYalsC6u2bdki4s3Jc
x46j9e521m/W/pDhwMyVLr/YXwLVbzY6c0ULqE9Zm+Ql6Ejh/ZXxYeAvd5HK6FQD
Ma5xVN9kmvwBBF4DSAbJ9SbRAvXcSicgBE+yB5/yxWI2S16FW6dzOT5zOMzaG3oH
6B5wTCMtfsJ60GT3ll8sZ0lZFq0qJb771yTk2fCWuUqR2u1oUBDu+WMtE0lKGJnX
LDaSGLPNmlkxXJM1aJ28hVZHkh5Xyj+VUq0wiCNJ+xMTZifbeN2IXU72YmNoNziv
+/gMhkoJkqDvwebzGtQlMA/u0YgI807Ac9aLEKZDEC1nJ4jqacVnalFXBPa33WNt
iTH+MeiE1RzWrRwqQxFmd1ZrQPbB6O17kK9Jb5Bl5ErgPIudQnjdPj8Aly+7b6kC
om6c7EXIJMMECsUj9WqulVj9BO9IVJaRayavsjDfFseR4driZkUY3bCAyXEI4Lhg
iNsmpwG9z+vKGhASWM3u
=OnBD
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Mar_2013_10_14_41_+1100_rQBvDqLJXApQl1Sl--
