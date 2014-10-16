Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaJPGwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:52:53 -0400
Received: from sauhun.de ([89.238.76.85]:44142 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPGwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:52:51 -0400
Date: Thu, 16 Oct 2014 08:53:18 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATH v3 0/4] i2c: show and change bus frequency via sysfs
Message-ID: <20141016065317.GA1949@katana>
References: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 15, 2014 at 11:03:27PM +0300, Octavian Purdila wrote:
> This patch series adds support to show and change the bus frequency
> via sysfs, by exposing files to show the minimum, maximum and current
> frequency as well as allowing the frequency to be changed. This allows
> the user to view or change the bus frequency on a per bus level.

To give you some early feedback.

Patches 1-2 are nice, will review them somewhen, no general issues here.
For patch 3, I am not convinced that sysfs is the right mechanism. Maybe
configfs, yet I have never dealt with it, so far. So, looking into this
might take more time since I have other core changes pending before
that.


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUP2tdAAoJEBQN5MwUoCm2rIsP/2+Lmko1cCNtNSHFKV2Da35j
qiCveF0MzEaNgeAaDT9Q1uNHpWy/y6jWEoyxd/zcMj0nY12kKTpeNOfFaDv3u42r
zToWdA4Z6UEkQrzpniguHsjYTEv1SxW+KtkwlSkY+mHTzw+FBJSr2zIULaayvrNm
tBaxRmp1g8iKOxddIlajW6lRRn7nlUExdROmCMgmFjgHvFm/mgJc4yy5jVNz05tA
GTK1XfJOLRm6Xyoub8+aI2MAMffmmbnLvf9y4e/VQMjlY+OybNDAX8S3Kv+G9ovD
wh2KOVKXzOWREz4VOfK+TSA97+xCM60ocOSdNTbWDtHsdUJMaeBCYsTWuj9lmdp5
Bceb1zOPkPCHpyTqE8Z1jvCeQ+PxRL2iAWtQ3PbYiMUbeP35KmWrhC5uu3MXT70j
EGde/cS7jEVlywTP06aR3kFNW0m+KD0FXtLtQJ38HYV63QTYRdVB2FKQ4IpfCWKL
GUKAoAbqUfdC4LPLe93S7nFIdFfXbqlSH2HgRoGdBNy/zyOa2elFs15ojY9soQZs
bUJ03G0SIaEwetrzL95Ba6KrAhahL8r2WBouqFcAjw+28ndBdng1m8E3ks59HDO8
VRdz0CuhFMVyzeGCOdHok9kbMLCkVAuUxKB0rq1wy6RXAcv43dWM1RHVoaTrDJML
FR7mcTAfLhJTfGT8k4BN
=Zy+F
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
