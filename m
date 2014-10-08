Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaJHPMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:12:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40861 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaJHPMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:12:43 -0400
Date: Wed, 8 Oct 2014 16:12:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141008151220.GE4609@sirena.org.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk>
 <20141008142511.GA4609@sirena.org.uk>
 <54354C7D.7090104@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3qTVFk/EjXyDmsv5"
Content-Disposition: inline
In-Reply-To: <54354C7D.7090104@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3qTVFk/EjXyDmsv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 04:38:53PM +0200, Javier Martinez Canillas wrote:
> On 10/08/2014 04:25 PM, Mark Brown wrote:

> > That doesn't mean that the definition of those modes is something we can
> > sensibly provide in generic code, especially in a completely
> > undocumented fashion (perhaps you've done that later in the patch series
> > but bisection also applies to reviewability).

> As a general question, now that the convention is for DT binding docs to go
> in a separate patch, should the DT documentation be added before or after
> that code using these bindings is added?

It fairly obviously needs to go before so that reviewers can tell if the
code is actually implementing the binding.

--3qTVFk/EjXyDmsv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNVRTAAoJECTWi3JdVIfQtg4H/i+ZNi9+Fmd/Rzq3xk4Tj29I
vNR5T6mPodulKKjwx+IBh02pLMHwB6gKkgeHxKGG62KcbY9rCW6+50TQ/WYsGHz7
4lXOu8Hp6Hhmg49V2j4OC2yAGCmh/VfTkJAYF+jWoQn//6xlkZTf2qejX2khcxtu
a3TuNsfsK6eOFbWuxwI6/5qp7Bq/836Og6lZHklkyWSi3P7nO9UUb+7b/gPfy6Ry
WscjLuH4QcQ86XzsZtb4Gvui8HqAr+RCj/nq9wJBqWVb/UuIOATXWzYG3z3kASn7
/YIz3JHRjDOdY9Y7/A00quD5aCwQnLAbA2CvbotxHY/bp/aU/p8ZeSFTiTwTSuY=
=5lir
-----END PGP SIGNATURE-----

--3qTVFk/EjXyDmsv5--
