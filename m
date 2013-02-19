Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3BSFat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:30:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10450 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3BSFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:30:47 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=71bQu_V0mRcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AZ2ZI1y3ASoA:10 a=20KFwNOVAAAA:8 a=2-J6K_Kjc2weECRg5QsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=nNJLwGYRhFcIU2115iAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219053045.724380793@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 00:30:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] Linux 3.0.65-rt92-rc1
References: <20130219053021.721159211@goodmis.org>
Content-Disposition: inline; filename=0004-Linux-3.0.65-rt92-rc1.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index e95e338..dc0be96 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt91
+-rt92-rc1
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIw4FAAoJEOdOSU1xswtMHREIAKGpC6E+h0A1pNC2cdwcsfGE
SSq/2Mx7sjEcjwGnZuSkTEdnybENGcfkyxQuJ0iAF47PSQqzvtzVHRt53uTulEBb
TugVOSN9dL8m4dha9tbXOHgmGI1tQoEPtdyOfvOespICxDsQRpFkPZWCO3T0+giz
1IcreYf2c2fZngdSZiFG4ocLj59EUsd6p7zhB04T36SZmzppVAheBA24RRadsJB+
r/ipjznFcpqadz7LwPKWQFHYPubL61DLoAwp6vErEpW73bBTSepaU0C7iAKjgFZa
Vc31AJOzTo3o5ciWD/v+q9kI+oWTZCBxFlwDCEhjf5C6n70ooTiaugdLJzRPpgQ=
=LMTN
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
