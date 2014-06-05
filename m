Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaFEIE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:04:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaFEIEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:04:25 -0400
Date: Thu, 5 Jun 2014 10:04:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20140605080418.GH3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-5-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="poemUeGtc2GQvHuH"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-5-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--poemUeGtc2GQvHuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
> @@ -499,6 +530,7 @@ do {									\
>   */
>  #define PMU_FL_NO_HT_SHARING	0x1 /* no hyper-threading resource sharing */
>  #define PMU_FL_HAS_RSP_1	0x2 /* has 2 equivalent offcore_rsp regs   */
> +#define PMU_FL_EXCL_CNTRS	0x4 /* has exclusive counter requirements  */

the EXLC thing is HT specific too, right? How about HT_EXCL or so?



--poemUeGtc2GQvHuH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkCSBAAoJEHZH4aRLwOS6+SYP/1QdBZY56bMPON3dCRPUS5ee
YqUonhafHeVlsHis0kFXfSmdB1dRrxD/zZw4D9xNup7yWqlJwotee3yR2+2/uwFq
71IOf1RPr9XxKZUOegl4k9SX9+XfMn37630NkSOwd8QNyW4woK9TvyURHPcmd6PN
4ZZnlaCwyR4S2NSZpSA85fiD+ZjOXlQd2pjqmvSdG4Mt5PU1uSktEnZHWp1xop+E
Gpzs5X/Kmt3GL79QEpavysil9DXgRkrknj38J3678PQJRS1st+n2iCKK4Y+zNRFd
S9zMqIUE2/NouqLylm8fz037Wq4b9uAkvMlrPFhD39WciDiiyJcHpzmlVYg1HuTc
Fbm5j8GdxbTtZAWmoNjtbMViYMC0a/BPZFHMX+Gwnk+2ijE/WRbUWaG50N75cfO7
5SICnheZk7NnnH0LhELIzO4Jkjz0g915bLQrNEtcUlHHhRqnZuu4fXFjAzmkvZ0A
qPdRDcG+LjZNPa0NXncrC6+LGXRssMCh8ZwDtII34RqIb7aaNpnCXn4E083aWeSA
67Vn40Cnump7XgqebVg1AdPl/t8Eyi0+smGTcgrzFhnOrHOZZnyfatvO63l56JYi
4CISZ8Yhs55Ur3JmE+93zWUlmwKafTj8At3tHbxaYZI/CQ72oH2YshmqIlIBd1Un
0vD5Y/Ea17sJupJjbTo5
=h3wR
-----END PGP SIGNATURE-----

--poemUeGtc2GQvHuH--
