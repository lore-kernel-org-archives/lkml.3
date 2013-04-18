Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967484Ab3DRRgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:36:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42179 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967156Ab3DRRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:36:12 -0400
Date: Thu, 18 Apr 2013 18:36:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: palmas: Fix min_uV for LDO8 tracking mode
Message-ID: <20130418173603.GQ13687@opensource.wolfsonmicro.com>
References: <1366304032.27953.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4v4CeaphHHcoDrun"
Content-Disposition: inline
In-Reply-To: <1366304032.27953.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4v4CeaphHHcoDrun
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 19, 2013 at 12:53:52AM +0800, Axel Lin wrote:
> When SMPS45 is set to off and LDO8 tracking is enabled, the output voltage can
> be set from 0.45 to 1.65 V. Thus set min_uV to be 450000.

Applied, thanks.

--4v4CeaphHHcoDrun
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRcC70AAoJELSic+t+oim9v20P/2g1dtky0zmG91mOj0i079Hm
yvIdHLYK4oQbeXLe/iEyCVg6cApYRbgV+XHsn1atFLFOH1oTD0dMJ0jB0uk7BQff
rQqIbsAv8SuKLQkLYtnQshNHNHyVK7nSjdfHTmWlhQD5+JSJIIW3JOV/w1ru/CWT
WWfExVKV8wv8/fmsnzYTIFUpR6t2/v8ZSXSzli+mKw873RLiUfYnLbnO2oU1t3Gx
XN1Snm6JItuupEHoQPoXiB+gYJsXTIu66+h6HI5xvRjr9g3PCSSJFenFVjzXJzBt
MVjuYNB9OF0l3daQJ3xCJyc2qjxzX7qFD8LwFy1kTB5+KUK2SqTjO9vQGtOZBQuY
D1oqglLKxC4YV+bU7O2abRSbqJXJHeSHwJjycv7qViy5yBqQAcpZMIvxDZYP2Zc/
2XYG3QmZ15yIrnA+zuJL0TaoQ+ZUt/jFhrPwliMSPNskDwFLmgyri0iD/pA9BsxM
1GMfV5bFMjVPYUj5e9XeRCDJQjJxyVv93Ih90fAUbAzy/yLGsf/L2tYNnm8U/NXs
jVDETwGdmzXXvqQyyiNGs2Q+b2rs1dbn6LOQCgJ5+W8UNgvGo6mUgWvdE/Ivas7G
lWCdzwpV/OXxw3o0d3IqCwM0HlHxvuCfoLVpm1TRAy4oNaRPc786lH87KPDyko9f
PuBpV4QdfGCeTOqAbldE
=RGBl
-----END PGP SIGNATURE-----

--4v4CeaphHHcoDrun--
