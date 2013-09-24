Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3IXP7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:59:42 -0400
Received: from sauhun.de ([89.238.76.85]:35660 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab3IXP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:59:40 -0400
Date: Tue, 24 Sep 2013 17:59:25 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Olivier CLERGEAUD <olivier.clergeaud@st.com>
Subject: Re: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
Message-ID: <20130924155925.GA2995@katana>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-2-git-send-email-maxime.coquelin@st.com>
 <5240AD6E.4090905@wwwdotorg.org>
 <5241B1FA.6020500@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <5241B1FA.6020500@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> "glitch" is is used to tune the I2C timing requirements, and has a=20
> nanosecond granularity.
> These values are added to default timing values.
> I'm not 100% sure, but it looks like the "samsung,i2c-sda-delay" in the=
=20
> i2c-s3c2410 driver.

For that, we have the generic "i2c-sda-hold-time-ns" property. The s3c
driver hasn't been converted to use it, sadly.


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQbbdAAoJEBQN5MwUoCm2xjEP/0cHjX/2Ozq+yhaNXOqivqTk
GuXvuVQERNOcBikKecWnIMOhawbQkprOdtosuc2uFgbEAIA8NKsc+OtN3gc0vyQB
bTpLyCY22RcZ26NRLMzT1cSYZdes1dOHpZ5yfeIdJCJxjsOYGquk8whF19lXtrIr
j4U3BKbcAcukjBkcQNnp7li3u4JgAWgZ1HOnOstmZL5Q/2ih8VSnYhGMO/ps61Y2
kBSwfTjWBiZy/qxArQytl9JX2KXD8lPCBpbuEQ65o9tWAuUy5k4gf1fLG1tz2oyS
BCL/C8SEHLNC7Me7PJDBkHwCWVkCv5UnfrHDYJ/XM95UD00QWJ2jxNIKQEofdPbf
4MmayhtAsq0mjTpniV9OWXfZJiYZDQBA6Q29BTsgByFM9IhxtTvmxCE83Py/O1Ux
2BRcNtg913PT0nhcRjSbk7Sk5IJ+YdG6Y9HGiKMj35GmNhOaDgLtoQ8LOWOeoox8
V2vKlO19R4NOOqCMJHefRcusZO9a2n1j8seDCveJnYf0j+XsKqdfvrEKbFJ+ObmM
kZQqMOeLSpGARYQfrvYNIgsRQ+bQRHvIZLkQw2iC26iUmJLjkVdxLqpNUinZ7syP
wuGRoGbCeeodCBamCo/Phs2lc+NDlgIj6qLCBeZXGjMdsMgc/S4DkPO0HteCwKD3
EdGxQvicSfKfAaA3ip1G
=kCEp
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
