Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3BORob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:44:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43590 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486Ab3BORoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:44:30 -0500
Date: Fri, 15 Feb 2013 17:44:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Wolfram Sang <wolfram@the-dreams.de>, linux-doc@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Guenter Roeck <linux@roeck-us.net>,
        Grant Grundler <grundler@chromium.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        "bhushan.r" <bhushan.r@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "sreekumar.c" <sreekumar.c@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Prashanth G <prashanth.g@samsung.com>
Subject: Re: [PATCH v2 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
Message-ID: <20130215174425.GF22283@opensource.wolfsonmicro.com>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
 <511E64C0.9090500@wwwdotorg.org>
 <CAD=FV=W9WwSsid_KqtDRmAkFXnneRXu5zcakDB3t4hLhOpuCtw@mail.gmail.com>
 <511E7295.4000902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dgjlcl3Tl+kb3YDk"
Content-Disposition: inline
In-Reply-To: <511E7295.4000902@wwwdotorg.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2013 at 10:38:29AM -0700, Stephen Warren wrote:

> Either way though, I believe that upstream, no driver should be relying
> on specific initcall levels in order to get dependencies/initialization
> ordering correct.

Right, in the past we did bodges like this but in the glorious new
present where deferred probing is available it shouldn't be needed any
more except for a few fun cases like cpufreq that are outside the device
model.

--dgjlcl3Tl+kb3YDk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHnPIAAoJELSic+t+oim97QAP/3aMTa1nprO13KakHb9cYQKi
aQwUMpB0amk5v7tsFxKBYmuODLVButaL7FMM2cHT5VW9BkW7phF+p2u+MkVb2OtN
xqzKiusOB8WjWZ4mLWRipyMHlqC2BNKXKx4m53iuvQgHA2tvSjeRZZp34rGGhSJ8
3D/ZBgYZCLU01My4aGppqWSFC9Z5/7CQgwgj1tMnjHFGWLl7hYG4ZkozjtdMqvhg
9c2mX2fJYyci30KHcHU23yHkL4voultrr2Q8mKmr3D4voNbQJWNEz+JjHtIE00yV
NqvAuaq2wJDsQH46La4myAE9DAkXo+RhEIOT+x8nLipWg5ECD6l7zfcqocGXHCfj
2WK3vdm0E4vAHFN1i1w62EnZcXI/HKTSUWV2Xgp6bpD2iXXeXcEEzsT10ovpGe5e
j6Z5vlku0qt9QBqOg/SINnRwnXXUACBBmWsiVepqBKPEPxSWTN7GV1Wq2qj+ZqeI
oK4w7xP7/RfxiIOWoQ/A2h1JHJGQpfos6nfT9nPXa9VjgBvQaZYjE26DZVnTcfF6
YxzYrLe3jVLoONKqDF0guWPUxCrQSEFqGapUysXOhPa7S6iiEi9WN7Vr5hsUeheu
omPm68F3uU7UXshUrQpdDC7pgVNt6BnsO0/dzZhGZTxq+qjsR2q4ymA6xf8rSSoy
o7ypMgS/t5N5JC+tWZAE
=Xb8J
-----END PGP SIGNATURE-----

--dgjlcl3Tl+kb3YDk--
