Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaC1Wvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:51:49 -0400
Received: from sauhun.de ([89.238.76.85]:34616 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaC1Wvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:51:45 -0400
Date: Fri, 28 Mar 2014 23:51:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v5 2/2] i2c: New bus driver for the Qualcomm QUP I2C
 controller
Message-ID: <20140328225139.GC29200@katana>
References: <1394762863-12154-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1394762863-12154-3-git-send-email-bjorn.andersson@sonymobile.com>
 <20140314180038.GT18529@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20140314180038.GT18529@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> General i2c question: is there a reason why the core isn't responsible
> for ensuring a device is not suspended before invoking ->master_xfer
> (and smbus_xfer)?

Can't think of one right now.


--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTNfz7AAoJEBQN5MwUoCm2A2YP+wep39VhQGg2HGyEB3+E2LTT
QWlvKlVg8XMnY/EMmKRWytdw/p/NIOzWytboxYRd4yvRP0KbZj827E3JyGW4aoyJ
myI6slkxacX2qmxjPoAM0oY83c+qJJfMKzIdINllPGXcSxHgKrANG9r+/TteNSYt
fam41roINW2aWE7+g1kKsqzNVsaeI+dmJ0mRittgHHoSd7QW1ENCFt+z+GoFW/3M
NhoqAWpkoamSVoNeqmaJ1Qukk3d1bRwChOBJUdyYgAXPaAl+rxDdOfIiKuu1YhTx
ysCjW5viAk/30z14afvNRkTic1+L3a8IfywOs78/147Cy5fnkWWIXmE8iFBpAgEo
HCYxnRhLSoEyTf5dUxLRSvfUxp4/SbVsGECY7sQqbceK/m/kGqo39LNcXIIQJBKE
DiiTG7+rTnwPTWUestk5hs63o1nPJ96JUodM0s4OhBU2XSC88aB/FohUJmw5tOqZ
dybv3oVjnBl82KBy7BBSSwmTYYECut3Xv0pbH/6Om1Z4g6yEfaT7ee/Cp9I5YyOe
vFRTJ0zNJ5SjEAElzXlXWg+0n1gDgy5zbVvyuoH/XpfR1FdugaacnTnR+WYiqEeA
SQGwzYoS3TDydEi6f1k1i71M/d7xZGX9eSAKx+fo5pjmxDBovhiUpJd+BKCS94+v
HlllAvUAtrlknr3d+9z5
=HWUs
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
