Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3JDKr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:47:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52767 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JDKrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:47:25 -0400
Date: Fri, 4 Oct 2013 11:47:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20131004104702.GL27287@sirena.org.uk>
References: <1380880098-25188-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UdiMmEj9EzJj2jSc"
Content-Disposition: inline
In-Reply-To: <1380880098-25188-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: wm8994: Remove redundant break
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UdiMmEj9EzJj2jSc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 04, 2013 at 03:18:17PM +0530, Sachin Kamat wrote:

>  		default:
>  			return (selector * 100000) + 950000;
>  		}
> -		break;
>  	default:

I'm not sure this is actually a clarity improvement.  While the break is
redundant the return statements are all inside the nested switch so it's
not entirely obvious at a glance that all the paths were covered.

--UdiMmEj9EzJj2jSc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTpyjAAoJELSic+t+oim90lEQAIxzRGGpDXUxJRx47cpBlRyX
W2h2oC+LdmhadeION3E6dhngcy07nzDQERzYMROHycLAgO1dCZdGUnfKQ69CJEpQ
VnyzjX6Xei5Zh3k1YAQBaLUzSPMGCULIUeGNPAPBXSKOlTvzsCHNuHrkgmIdfahf
JxrNPAM1mC/hRhTyl7dnp3eb2oxCmnKcE/jEW+oISZWnLjUvR635tKemSWgMDFmu
JWidv32OXjfUsxrwunQHFuu6koxhn4Vq+viadO6U5ULBhI99TC+m4dNLHOEN1PAa
eDZ2kFP/8JBEp/Y7F0dnOnKF7mLheQxxH6W0xyUkXvnhDKDfqE5m/lRPH66Xi3qk
4YlSs5R6HmtHMSP3F6DKDQLMIU2I4ytKGQfA1SJrpzb9Pz40aHLBd+thdINhb2Yp
m5u8358sM7wnI2+HYEGt92sxjOeg8xnL1C1DGDfnRlJz5UMlUQ6aCvAD98GR+SsN
Ahd4XC2M2lta4dC7XgRvGDom3DMwKg+1KmRps9dh6hZ+sNx9VrDEj90nUkMgUOQm
67LOOY4dKOIi49Adk8/3vJgjgWcsxb6xZ1K64R2jd8AG6MeQ2XrIbTcjLqtRlp5F
qclf8YoTmvSYjb6TgqS8o0vOnmMlHit7a3qI2PYDTxEjMwaeTBr4KzD/NxGDVB5x
CN8E3Ni+EAgPLpB+iUIA
=ZvnC
-----END PGP SIGNATURE-----

--UdiMmEj9EzJj2jSc--
