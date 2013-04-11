Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab3DKQoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:44:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58276 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200Ab3DKQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:44:23 -0400
Date: Thu, 11 Apr 2013 17:44:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: ab8500-ext: Make the return type of
 ab8500_ext_regulator_exit() void
Message-ID: <20130411164420.GI9243@opensource.wolfsonmicro.com>
References: <1365653058.17060.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGtad4bun3m+J/4B"
Content-Disposition: inline
In-Reply-To: <1365653058.17060.0.camel@phoenix>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGtad4bun3m+J/4B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 12:04:18PM +0800, Axel Lin wrote:

> ab8500_ext_regulator_exit() never fails.

Applied both, thanks.

--ZGtad4bun3m+J/4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZuhZAAoJELSic+t+oim9JuoP/iI6/A0suyp3lRGcsp/NJD6t
a2VbGT/zAzGmAVZX22f4oa3qUoyg+WDv+hq01ww11fpFKezVY6BTc8z+QGTDe4DJ
iACLwISSjFQ+fhFx/OzyakpQyyFjry6zrzjc7iye07+HV9hHoE4pZG+zh2h0iFi7
gyzD/dFzrxn7D7Q4KyeteZUUinV5TECJYtATpiEX24/o+aOEIqF9Q0LidVhC/D0M
7F6uuNC7q5+XpiOBf1AX7z0MAw+0YZGgK0mKUPUT+V4ty910jQPx8s3pCw8XpA+9
gtwUDRkojkfQbywsiOA+LKz7knwI6IIpMzZScetV0hEAUXwue1FI2rarK17C8SzF
EobX//Bt6aNXYHx0m6+l1N9PxwI0Joy9vPUo4UM3Tqq7jfjgSw08pgLCfW0rVmm4
IcPjmy2EPZvcJrbWWPDSIlsjlkM7jvveyIoqKTZMaY+4WqwfyZdzKTJcCyYnwOl7
vdgji8i42xNk7yHqnJlFtuGIAgp0Z+UD7BDfFMzzTdvzs6rmgVGSV9zHSkbWC0Rk
AY+AZrzpLmrHtXeBYliK2bHUz7qQMgHMuBMVZ09o54XzUQrMvT44Vaor2dFXQid7
T68IH3TkrQ0R30fE0nlLGQGG5dWk/wAST+vig6Uyt4yzMLPpLNipIX95V+B17kfk
aTi9vNoHNN/TCK43hRAm
=ZcTs
-----END PGP SIGNATURE-----

--ZGtad4bun3m+J/4B--
