Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630Ab3DBJkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:40:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3DBJkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:40:40 -0400
Date: Tue, 2 Apr 2013 11:40:36 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pwm: mxs: Remove unused *dev from struct mxs_pwm_chip
Message-ID: <20130402094036.GC856@avionic-0098.mockup.avionic-design.de>
References: <1364784493.7725.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <1364784493.7725.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WEnLyJg0x8i++aF9+CVqo5YOPhmYKU3iHJ6NuerC0hK
 1clvym3omf1NYNPPoRgo+XGwNhdrUafCRkupMDINbO9eqKXzpD
 c6YBMPg6wq6x3l+qJryAoynSKKgUBC3Sg7HVJ7ht1dAKP7nh2B
 p6p6CV+BV35YELprQV+BNW6COwmRbDuS4S9pTivSwnBKu6HVRa
 BxuYkbR2yjnYq2MiP2dNesMBVfv3z8pKy5OjLsnS4qEgn7AqjV
 UyLIDpht01PTiKqCHfIqUCcufViPdlp5BlX0Lu9LTz2mpwszHA
 z5JPBqGsoLGJcK4bEeks7GgKPL4V5bclEXtW+BdtfsxSOU7KdU
 ak5fbRJWe5U0bGlp2E0FbhV8Q0Hs3lMgvgh/0UmWCnrp9fpUCT
 aOj7NFa/fm/fiDpIk26Pci5iwi2/D0R6ZQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 01, 2013 at 10:48:13AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-mxs.c |    2 --
>  1 file changed, 2 deletions(-)

Both patches applied, thanks.

Thierry

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqeUAAoJEN0jrNd/PrOhvGYP/1qkuNwjCifr7DVmuOJ3QrT6
SFDt5nShUqYagy7GPXpOk6DiahfEVWrP/M8jSXV32siypBga0MFUHjNCVAByfxSp
pJWccUnlmUPXiphpsAG2Nt0nBTNkEP6KCudRf6Oo+cIJ/mrFA1th12Ic7xhq8d3M
U7Hp25q+MotXZ7DsmHeCpy+pbmUwWTz2yqecPTnc4OFcy5wmM68C2OX9uBlq3hk/
A3g448cSrAqhvc6Vriu3pXgfRlzCpOSlg3DeOIsuvhFjciVyHAIAAtNgXnn4zJZ1
pi0A1HmuBXOG9QNw9rMVh0rtiAkVbKmCi+XhzkjKHDN0ZCY4IJ2J8mM3gZV1n2fG
0OsCGdP1OyOSEjqIsB14EBSUJY2hhOJEMAxIsoQNqUiu/OXJM4MmfzeQyrFoLjPI
31dyaoPQkGVUolqo16JDG/FcVsEWsKIvWzAmTQRVh6+MaI7n92LeSOowETbQpOBW
BUrZ92gUCw5J5lFmwYhbZ8geUDsv+8OC5qjNJ9kqWAL6NNcnDoO/tcKClyK4N+MH
ryyYPqm14WVsPYRNXdvF49Uz/ctW0DitdpEs9tJhWDm8n9puRZOE2upgTr6e1sT+
T+dGgrhtW1SNnPhBc34rKAzSLADdgFgIiCF+JQ2sBFaJ0072FVjihREw8U61rqbZ
JJMwYcXJ3hOL4BW0D2xD
=VV+e
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
