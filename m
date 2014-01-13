Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaAMQrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:47:10 -0500
Received: from sauhun.de ([89.238.76.85]:38833 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbaAMQrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:47:03 -0500
Date: Mon, 13 Jan 2014 17:46:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: robert.valiquette@intel.com
Cc: nhorman@tuxdriver.com, seth.heasley@intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c-ismt: add the support of the
 I2C_SMBUS_I2C_BLOCK_DATA transaction type
Message-ID: <20140113164652.GA14602@katana>
References: <5285704e.jwiZWyk8R3ZEoySS%robert.valiquette@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <5285704e.jwiZWyk8R3ZEoySS%robert.valiquette@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2013 at 07:52:30PM -0500, robert.valiquette@intel.com wrote:
> This patch adds the support of the I2C_SMBUS_I2C_BLOCK_DATA transaction t=
ype for the iSMT SMBus Controller.

Wrap the long line next time, please.

>=20
> Signed-off-by: Robert Valiquette <robert.valiquette@intel.com>
> ---

> +		/* Make sure the lenght is valid */

Fixed the typo and applied to for-next, thanks!



--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS1Bh7AAoJEBQN5MwUoCm2978P/RCSrZSRzk6XI+kRIowwJzg2
q2Htk88WpdP/wUC1Tousp+6NZzO5Af6KVKxtZ9ad7kEPLHuDrdw0wIpxUiKEf3X1
wYHOaJGKqQvdm33RAlrBH4eNjb2swX3q74v441uaued4yXLu0PmYfd3u+eHqOqUQ
MBKQa1b/qeaAhx5NoY5YQLh2AO/yS5bkWlGx58INsLrimlJyu5NJctsbE5p/16jm
UD9Bm5z+L9ah04Eyh7C1lYif33ExtMx1kPSSr5ZqLss9WJvWEUl0F7iXnIZHKaea
Ii25tOnHLOly+yNBRlOK35M37pWfFx38zAq2SOOgRf3rPbDY51pYzQrkLsqlK3mI
eLLOhaVr+/z4iMmxa+30P3xCRNU6AjcaN4sRW+x2bXkvLx9iB2ufU7icKoGBFAeq
rbRQAazOkDOdUiGLAWS0B0H80SpGeGSsBM6WUgijLW95SWJH4efnlJxdCbedDKd3
QtnteoJvDL3k3/yYqr3oXaCg4oCddrWEN90elzieNB5t/GIFZRpU9ZpuLnYXYC20
OE8A0RmZWMpQ78RLBCg5WOMxbwMpurHP2vTGYt0GjZcjzXu92/GrKwASQl8ZWA6Z
YuQacuhLeokZsg1mTtFfqxYLYQrSTy6uadyKPIfkFXXNXgwZCZ3qHMnIDMBeFKv1
DwS3mkyZRoCm1U1skRhN
=8hXC
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
