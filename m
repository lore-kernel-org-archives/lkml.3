Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbaGPMIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:08:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40178 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916AbaGPMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:08:13 -0400
Date: Wed, 16 Jul 2014 13:07:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org
Message-ID: <20140716120750.GM17528@sirena.org.uk>
References: <cover.1387336613.git.lv.zheng@intel.com>
 <cover.1405500886.git.lv.zheng@intel.com>
 <7ac00c9c5a32f7a3ec98f061080ba1573ae57d0d.1405500886.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5me2qT3T17SWzdxI"
Content-Disposition: inline
In-Reply-To: <7ac00c9c5a32f7a3ec98f061080ba1573ae57d0d.1405500886.git.lv.zheng@intel.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 7/7] ACPI: Cleanup useless ACPI inclusion.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5me2qT3T17SWzdxI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 04:59:02PM +0800, Lv Zheng wrote:
> The sst-haswell-dsp.c is an ACPI independent file, this patch removes
> ACPI header files for it.

Applied, thanks.  Please use subject lines matching the style for the
subsystem and send at least the cover letter for the series to everyone
so that they know what's going on with dependencies and so on.

--5me2qT3T17SWzdxI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxmsTAAoJELSic+t+oim9wDgQAIGj1IsQmCiC9wzzx0I14JOl
d70+ZlvbDYeXiL0fVaF7QdArfjt99hRdvn0KUSd/QcykHl0nSwYAT6MrAmkla44K
3QXJmODQpC4TIXUDIlIVH1hMd/3uZvn2pzz6+QtqcrJk4BeMzYKGnbz90nUayx6p
cAb1XEBTQJwVR8zdrSE2oXzYr9JbSMt+YTmgLlyz9te/FYQ8GwaFcj3bpF+1Ykbv
plLSnY8pkG8YjgpLeuA//0XsCPLGYOn8oM77uRDkmJSYcE9EOWSAJBNuZicsIhOu
kvkWONtvfIDBzT/2tcZJ37jpuRC/f9SLeMj/tk8ZgqaR7WxPMNuTRK/4eSPYqocr
eP/xZOeul04gJa8tEg/gECwdPU61NCvgrr1g1/l19D76ItNlyOF1Tz/2hXrDadMh
8ypSdoW/NBrWoq+rF3sZYpemD11AHO+wJ5T6H7WZyTDf+jA51uZGBK+Tijq98edL
r6kZpyNNg8enhQNaN8qN6zG4x1kBcP9Ohfo8+L1e21D7PpEpWIcIAATFxvWETR+t
4L0occpODtwYqY4XRs2YhXV2lJ3ljx42iLqRSsuELZuAVGCwrQArirMrIy6gRM0i
S1icS3VbPXBvJHmqPTAI0cV0oHeF1M0gPSd4g1+h1hG9irbRRb4+rJxnFBaE3HFm
yT1t5g6go3gfewKLMUpy
=A3iP
-----END PGP SIGNATURE-----

--5me2qT3T17SWzdxI--
