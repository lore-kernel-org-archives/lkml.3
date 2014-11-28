Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaK1QCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:02:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42286 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaK1QCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:02:07 -0500
Date: Fri, 28 Nov 2014 16:01:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141128160156.GX7712@sirena.org.uk>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1417180198-9393-1-git-send-email-laurentiu.palcu@intel.com>
 <20141128141053.GL7712@sirena.org.uk>
 <20141128145703.GA16201@lpalcu-linux>
 <20141128151435.GQ7712@sirena.org.uk>
 <20141128153125.GB16201@lpalcu-linux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TWulL6J9QifKutO7"
Content-Disposition: inline
In-Reply-To: <20141128153125.GB16201@lpalcu-linux>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TWulL6J9QifKutO7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 05:31:25PM +0200, Laurentiu Palcu wrote:
> On Fri, Nov 28, 2014 at 03:14:35PM +0000, Mark Brown wrote:
> > On Fri, Nov 28, 2014 at 04:57:04PM +0200, Laurentiu Palcu wrote:

> > > The other patch in this series was already applied by Lee on
> > > for-mfd-next branch:

> > What this means is that the series you're sending actually contains one
> > patch, not two.  The point of numbering patches within a series is so
> > people can tell what order to apply them in, nothing else.  Things can
> > be lumped together and split during the upstreaming process, the only
> > thing that matterrs is what you're sending at a given time.

> The order of the patches in this series can be interchanged. However, if
> you wish, I can resend the entire series again.

No, please don't - you're missing the point.  The point is that now Lee
has applied the other patch you're not sending two patches any more,
you're sending a single patch.  This isn't patch 1/2, it's just a single
patch by itself now.

--TWulL6J9QifKutO7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJxzAAoJECTWi3JdVIfQQyoH/3Xb21Ad1a7EEMbxVIPIWY5K
R/lXrUbbV0CZBEaJm0Xq2RlvdPqUV4TCM+5k2rvigpt62+rwa0cOb57V1gDZiAkm
q/dTHjt3wOvRtncZBU473JdHTD8Q/stGfNO3BUHzbrL6W6dmqowbusFNJvwthB6E
1WlWvYilmHmJ/it3whJsOqKRhe+zMitH+3Gim8c0RATAolodsyV1x1lkNIe6wWRb
QABNja8TbpBOLHVtS504fgRw6wVSc06NJod7kVKkSmefwzM3oDWW2aE6wZ7W8vE5
nxw+fWlO7uu6XGNYuECEIoDZEtfIt+V60Cxt3arUVzxDFO/pFNiSmrXk8PkOaxY=
=fyS3
-----END PGP SIGNATURE-----

--TWulL6J9QifKutO7--
