Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaHLV6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:58:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60508 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaHLV6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:58:02 -0400
Date: Tue, 12 Aug 2014 22:57:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Peter Chan <peter.chan@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "rf@opensource.wolfsonmicro.com" <rf@opensource.wolfsonmicro.com>
Message-ID: <20140812215742.GE17528@sirena.org.uk>
References: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com>
 <20140807165836.GL17528@sirena.org.uk>
 <20140808082043.GB6333@MrMyself>
 <39712b9fd56546f8a943d605230a2f18@BL2PR03MB371.namprd03.prod.outlook.com>
 <20140811131949.GA28085@opensource.wolfsonmicro.com>
 <20140812082416.GA15833@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oi8qGtpy8i2CN1L2"
Content-Disposition: inline
In-Reply-To: <20140812082416.GA15833@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to
 enable mono speaker output
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Oi8qGtpy8i2CN1L2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 09:24:16AM +0100, Charles Keepax wrote:
> On Mon, Aug 11, 2014 at 02:19:49PM +0100, Charles Keepax wrote:

> > From the wording of "tie both outputs together" in the datasheet
> > I would assume that means both should be fed the same audio? Was
> > this done? I will try to give the hardware guys here a shout and
> > see if I can get some clarification on mono mode on this device.

> I have had a word with the hardware team here and both channels
> do need to be enabled but audio should only be fed to the left
> channel. So the driver definitely needs updated for the mono
> case, but I am unclear as to what is causing your poor audio
> quality issue.

Overdriving the speaker perhaps?

--Oi8qGtpy8i2CN1L2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6o3TAAoJELSic+t+oim9qo8P/2QE/vec5M1/H5300V1TV5Dd
+ekkPinivVeH0tLoiDA+EMaP0OqrHfnAx9yLedNxUn3TWfBQHL34Gr6YvgRE9QWA
NajLZmllMDtf0anVh4oQTKkYBcfvazNY3PtGOOeagmO87u7s3vOdErmNoOWlFsW1
06yM7PEIZuIUbzRcBnJ9Q3uA6j95xr5JtoeaWKMdNyQ4JIebp5c9aEBkSEGv1JnE
6FJUoQjeY1Vx9/Cc3xT1hnxkTP+vRmTZcUq4k4pmu/HDrRdtVxhbVNF4a1IlfxZn
DDKt944Ygo5ZwI8NPf4Hpya4LtMytQQvNvd1aNrF1uXt+o7DJUovUuGuNrp+HVaV
6L5b/6edXB6sQto/KwAELkJBZKEyilF14QpicOgoLq6+tEeriYyCvWuTxFpLO4lb
zPv4hLAksVmNTBSFf355Bp8iY1CT0KItxTyjPC0sXskFSNStn+XVT+YIofVSzfyD
DqnB1JYyC52rJ71+1g0NgwQJF8fNikWjxZtIJc8lbBtcy/NwpGzp6TqPUkdQf0ga
MTGafX6MOn95/KbwtM/qDmz5QM0slKip0W7kb7jU9rtjhioBPypoxN0+G8CkScTl
uHJFDJ79M3AJlh8114a8iyeB14dkn6m0ay3VyI0wqSPV33qEVOTbQYAhA1QAuiZL
Dueh0Eq181uCRNSbpJI3
=7VIs
-----END PGP SIGNATURE-----

--Oi8qGtpy8i2CN1L2--
