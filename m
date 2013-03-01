Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3CAHqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:46:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab3CAHqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:46:17 -0500
Date: Fri, 1 Mar 2013 15:45:43 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk
Subject: Re: [PATCH 4/4] regulator: palmas: Change the DT node property names
 to follow the convention
Message-ID: <20130301074540.GL25302@opensource.wolfsonmicro.com>
References: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRwESHC7KXlqFpSs"
Content-Disposition: inline
In-Reply-To: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XRwESHC7KXlqFpSs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 18, 2013 at 10:44:20AM +0530, J Keerthy wrote:
> DT node properties should not have "_". Replacing them by "-".

Applied, thanks.

--XRwESHC7KXlqFpSs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFyYAAoJELSic+t+oim9teEP/26gZV8j2KOTMkPmw1MpfpPV
8yoJW/paOcIdeW6r6EDRabDLztBf76cvkKQcszeandkB4QvpSxzyGlq+582ojh4C
onOMvvz5xyiyuOBn8nf+T4rgX2UWMRQ7/EAJdElJu4huJelD+I/H7mlBGs9nZeiA
sJqsBMLzv0LDQr0htHfRCx/ZrY0Av8l6LnPU/8yOu9AuDN7LLp3gqzjOHP2NPauo
gj6dtmLPwUq5bzNFbCtANUPyUvTs0WrU9XWqsyC/7NKBfr0sEa88UOq8de843GxS
Yov5ABqMluO0UmxeFDGPh4HhUSMJDZ6/qk8S+dNCZWJpZYaaorTYxnB2FEO5VXKi
y9v9XN1MwjuWp14L4YTNoGSMFGnst0GASmq/MSPjmAu77aKkFMy26oEInS/wBR5s
JEyZMSeyxImYQAUPtw4p724Jog5zuenaY76EBSlXc3n8lu5Ve1sm3GgmyAGXsscS
/dlWMV0IaOlNHnmRR2KWTiB6iHgmRtPSwjM1lMvIYO/xRNutsUY3JW86JUXVfKGn
oaFCXvHFIFZNU6XCFDLaMqRz62CAGdJbngRcQ6MBPtZHAX2fIOipcD+e2SRQYCmn
1Mo0Hv0Pi49ua0NOgMnAMtyRq9rABuI1UwLpcq/aD3ZJIC3wTYBE9VTuYJqgekUi
5r2hxdCH04Dr2NBGcjAz
=RDyi
-----END PGP SIGNATURE-----

--XRwESHC7KXlqFpSs--
