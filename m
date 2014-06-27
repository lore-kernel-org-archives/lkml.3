Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaF0Mbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:31:52 -0400
Received: from sauhun.de ([89.238.76.85]:52076 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbaF0Mbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:31:50 -0400
Date: Fri, 27 Jun 2014 14:31:46 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        broonie@kernel.org, sameo@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/10] mfd: cros_ec: ec_dev->cmd_xfer() returns number
 of bytes received from EC
Message-ID: <20140627123146.GB29156@katana>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-10-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <1403115247-8853-10-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 11:14:06AM -0700, Doug Anderson wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>=20
> When communicating with the EC, the cmd_xfer() function should return the
> number of bytes it received from the EC, or negative on error.
>=20
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>

For the I2C part:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrWQyAAoJEBQN5MwUoCm24ekP/RTz4HAlV6gUbBbVucnd+3Iq
VbfnIvEeU7dtooPxbWOXR5GuF7ov2m9EKNYwDcvfz04aPO9DnB3D9Vc5U7PMaR+G
mYOP8vVKxDPAlX12dyumECZP2oZoINABn74esUtwKnUAUBZDqp1ETxoY3Rlnc06x
ry6kowHBGkYAW9IpqwyLs4gbQ+KfWn/o95ig4lwM7/hsgwq5QzxPjRxbSIzKZBgo
e7Z6PGTxdoXNmnhtWtfkaQMzz8T9b0AWZSXJ57R0L8wernlC9CElWhuNvEv94E50
llhAQt7agScIrWypLtV6SG1tSxNRSwxJvNopSpU6rrGVGZ/zkgpTcE/aPKp4waV4
vL4UqbDCAbJM3n0ME/1p7i+3yINCJVZXSHeAQhQDQiN0GQy5QqW7Q4D7OpM01VNh
1wuJYy/2ho0t4kUHn4d9keKjFztcXB+0C8++W1TX0mFseza11cxmta7sH6FGlwSU
N00zapBrQYdmsqSdGMA3D7Nanxo3j0EVhdCP9fgUuKFGdAvvQWNZHVCDvIOo+v5h
PerPAOmFV/sj2EFbCKiG+HZ4/JGC2ywzlup97nJ0PPFUPbEctUanDxxMsAo2H7pl
x8V0cTacPtIWmnQN7fCEmr7jWV6dAEQ8IN2aMc40mlv5jxSCJHoO2zJAEaKjNzlC
Zh2zMh+RCIsHMekpdNRR
=jMuy
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
