Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaGPW2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:28:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40883 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaGPW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:28:43 -0400
Date: Wed, 16 Jul 2014 23:28:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: pramod gurav <pramod.gurav.etc@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Message-ID: <20140716222829.GO17528@sirena.org.uk>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1405465241-28684-4-git-send-email-bjorn.andersson@sonymobile.com>
 <CAMf-jSn2YHF7ihRpXMfkPWYt8pNCj4o395OGha3BHD3K3mUv9g@mail.gmail.com>
 <CAJAp7Oj1R-EkJoSdLEa6SBLbzE_N1MjsystQ9Z+x4L_SjU=56w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D85EWoRcDXv1uhH1"
Content-Disposition: inline
In-Reply-To: <CAJAp7Oj1R-EkJoSdLEa6SBLbzE_N1MjsystQ9Z+x4L_SjU=56w@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D85EWoRcDXv1uhH1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 03:17:13PM -0700, Bjorn Andersson wrote:
> On Wed, Jul 16, 2014 at 12:01 AM, pramod gurav
> > On Wed, Jul 16, 2014 at 4:30 AM, Bjorn Andersson
> > <bjorn.andersson@sonymobile.com> wrote:

> >> +static const struct regulator_linear_range pldo_ranges[] = {
> >> +       REGULATOR_LINEAR_RANGE( 750000,   0,  59, 12500),

> > ERROR: space prohibited after that open parenthesis '('

> I prefer the nicely aligned columns over checkpatch correctness here.

Me too.

--D85EWoRcDXv1uhH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxvyKAAoJELSic+t+oim9NngP/RoArEBjjlY82D9lo+UbT5nf
chizzJ49scpVqzayPgiMMuOKpKKSQsFGRQe4fdi3u0sW/0PFfEHHHH9lVDmFgOxX
OxiOdVQxDel2c5G9J2SZiZ0vT74ecJp5aPlq9MRdh1KtCRAcg+xOWQ2GzWmR8MyM
GgPyC8IFTuoLkBMPjEMDKnnfy9OgsuPXxtZDifnSaFZXqiWgIXauwc0xrzbAtmTu
IjhhX0DeEr1hXpfUnBifmbpjfDZqNtu96nrKFJvOoiAbhJnZQyge+ycg+JEmNZpv
7jdN+gsh+jZI22Z3E92i9c9xbxT4n0NxTvjqmV89q+FRTyBjYAvp0+tpltinRe5F
NetX15zM7aevhxXAzp1504tundKUqwi+3xuE1MAfDlHejIm0801AhPRLOVMctqP8
SHTXPHcIY7cJ3dHtVJJANFEXn9oJjRRJCMwo1AZhzRihem9bPJ/ZtkoFIOMt2Bfn
1ybj3xt78fqJruFcS4dvh95BCfAuBMpO0yYJfFPEDPAfvA6Y8wS9l027z9LeNEwa
6hjIn5fxQIw2jvMNDlGzYHVYTtA+9LaorngeqZ4I679CZzFn3DAauo1FE4o4Lk6N
Ta0WToAd8kEpc85kEhKCMZWdwI9FRHNCj1ElWYUy+D7zJqChYMYScI6/+nXygrQp
Oc/vP06NsjuxaGeXXDSF
=fREf
-----END PGP SIGNATURE-----

--D85EWoRcDXv1uhH1--
