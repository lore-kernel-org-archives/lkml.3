Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3JJKEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:04:11 -0400
Received: from sauhun.de ([89.238.76.85]:36567 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3JJKEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:04:08 -0400
Date: Thu, 10 Oct 2013 12:03:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Subject: Re: [PATCH v4 0/4] Add I2C support to ST SoCs
Message-ID: <20131010100354.GE2638@katana>
References: <1381250576-7916-1-git-send-email-maxime.coquelin@st.com>
 <525675B6.4080404@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Content-Disposition: inline
In-Reply-To: <525675B6.4080404@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> > Changes since v3:
> >    - Switch back to vendor specific DT properties regarding the anti-glitch
> >      filter configuration, as this IP is the only one having such a filter.
> Do you agree to keep these properties vendor-specifics?

My preference is generic bindings. There are no other users right now,
yet there might be in the future. At least with something similar enough
that the bindings will apply. Was hoping for some additional input,
though, but I am not depending on it.

> If so, could you take this series for v3.13?

Sure, if it passes the second review...


--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVnuKAAoJEBQN5MwUoCm29YAP/j86Uvw2t0c5cudusZoI5pBT
mWGREfUbrGlgNBb3AFMeTdJtZRFPOn1ZJx8K/FHOz7e//tgTH0ebQm9dTDZ7ZwWQ
WD17mFEWsRq/yFyYxV9wr1bXu6OuKoUzLz9tDcLlN9BAYwJCXUHuQBt3Os6ELsb8
2HqUdPdsWhN+iEan8qwi4DeU0HA58IPiU71QeLCk6+ex8yGh5SOI2Q3HMES+eMDL
fgivJzU0u0SBUKNtfrhdK6RYmSYAm5qI/RezMhl/oU2r0q//bps8aF5aGNV1y9ZX
6b8cnpV3KGsju4DuPccGGAMKb7k4Yi/Z3lENsm57+FnsZu0cPpp3GentG0WiiLVI
BY57HKex3JwGblHKeYeM8+A+YCMg1Ju4+dY2gZ4wxWFPxaxORsXqdeufSRFXJErv
lHCOi91GyH2aYgxMi9EwE/Miwp59oQSCSzYsaVp/rvg2q2+75No4NSstq1qd0eLB
9B7zuEaXwVCzI1Ep9r+0nVSv6PRiNm74uzdgjUd7GbdxinaFRCrO21nNCvQFZVwv
Qj2+bUGequCP/55a4x/LJdYa2lNEjJImbyRwSPzI60pD7VEhYBZwopAlc3P39bGQ
0G0BsO46cFUGFagdiNMJkk1+kvmYmd6HS1Haua/nuKb2zfRhJ8LXyy9a/EYwwnOf
stNvDh3H5XFreu94BEwD
=Yzfa
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
