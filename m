Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab3DBL0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:26:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42513 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312Ab3DBL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:26:40 -0400
Date: Tue, 2 Apr 2013 12:26:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: ab8500: Fix build error
Message-ID: <20130402112637.GH23065@opensource.wolfsonmicro.com>
References: <1364863193.15806.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g3RkK9jYN81zD2N+"
Content-Disposition: inline
In-Reply-To: <1364863193.15806.3.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g3RkK9jYN81zD2N+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 02, 2013 at 08:39:53AM +0800, Axel Lin wrote:
> This patch removes 'delay' field which does not exist in struct
> ab8500_regulator_info. ( The 'delay' field was removed because fixed regulator
> does not need to implement set_voltage_time_sel. )
> Fix missing semicolon and declare match_size to fix below build error.
> Also setup match pointer and match_size for ab8505 and ab8540.

Lee?

--g3RkK9jYN81zD2N+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWsBnAAoJELSic+t+oim9Q08QAIYJm93ptiLI55LmAVJAunm5
qAs5nFitOWw0BKFUwzIcxQKV1xmsPzfKKjn+72osMNBuh1ja43QYzQZxl2wiNJP7
tP9MesIlTQ9OQlThBRwm8dl66tK1ReurzhZseAqjMpsHDVpkUmvMWkMsMLszJxMR
ofENDBQCcG4I3k8NJHY1/9p/8rosPp3akmHm9ix84LqB1A2RjhJCzxmD2yS6get7
uDmUvDP1d/hvVc+eeZXjpcA2VTFpo1iQa0gEliszCR5JszuYMKvHGbSdUa4xzBBm
RoeaSaaz2HPN29+YWKRFlZuUeRXNjR+ta1xETOKB0mCfg5HpmHoJJpKetaiBXgx4
wy4RfQvdMqQYtTebhYkIrXRN/1wJRBCmf46esafbfmdFqE+Q7L2hWCkC3NvwYVrY
kVc3yQ8HgD1zh1fqRBJGhaFUWih8OXJYJ+BYTpiQtBBHnuje4sGWwXVvaGUJzqov
cR3pn/jVrynviI9fn+liKhyA4buf3efj9ogE/AKZC7OBMXWkz52LUc8zetz9BXeg
2YQCULiDT8oSGSloCdXa8WXPNgwqaEmQqIV8zisWUoXY0M3GmQjvKmgrLw5922qq
W5i91If9h8pqs/wQRWC/h2ohVfdakixMYWMwkcjfeY3OjXRP3d4nqCPmT+DNTinH
Ck1putF8dHQ+f2mNe8ig
=pZrx
-----END PGP SIGNATURE-----

--g3RkK9jYN81zD2N+--
