Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab3I0CWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:22:46 -0400
Received: from sauhun.de ([89.238.76.85]:33622 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3I0CWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:22:45 -0400
Date: Fri, 27 Sep 2013 04:22:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: 10-bit addressing mode enabling if
 I2C_DYNAMIC_TAR_UPDATE is set.
Message-ID: <20130927022234.GA3159@katana>
References: <1380221855-14150-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1380221855-14150-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2013 at 02:57:35AM +0800, Chew, Chiau Ee wrote:
> According to Designware I2C spec, if I2C_DYNAMIC_TAR_UPDATE is set to 1,
> the 10-bit addressing mode is controlled by IC_10BITADDR_MASTER bit of
> IC_TAR register instead of IC_CON register. The IC_10BITADDR_MASTER
> in IC_CON register becomes read-only copy. Since I2C_DYNAMIC_TAR_UPDATE
> value can't be detected from hardware register, so we will always set the
> IC_10BITADDR_MASTER bit in both IC_CON and IC_TAR register whenever 10-bit
> addresing mode is requested by user application.
>=20
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied to for-current, thanks!


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSROvqAAoJEBQN5MwUoCm2sUQP/2L7DmE4BzPRPoyOcXsLWYvO
JnkfKc9ngGu3Up/GWe/asNG3qghyY40yoGEBfdfPrAsUkSHK4V7aTqrOgeeNJfCd
JuU7mlKGOr7nosdTI6el/RJptaq5BLBKkeF29dNLrRVwappK0714T1Y1QaVnf5TA
m5Z1XudPHCfGjSEqP1jMWsnYcQ7X+Lz5jWyFyKZhpiS08sV0qQkxGDzoc4ZWqehR
voPMDL3q9g1Y/LBpgM0YWJ24kxM88ZsfwjsRvke0Aytfb48OEcGy/ljGzlJm4p6L
zSyOWPoysChh7IlUsR9RphccVhUEFdHPwqSGH/uptwqLT4dpz2JmXlNmZ56TMssg
UFNkoFQLjO31oDKNTETurSb3l9LaisuCkDJUu58Zd1a0MYu2KdEZFD5T16mV2X/G
pSO96SaBhmdCw4BZUlX5QHyc4ZKevngc0Na9SFYuFll+lSKgWvEeDQugNmxaAaNH
4tAprIu86rXxJ1BRZ5yxPhFgUnoog8oVjo5XaR3G+I5xVqe264to/JXQ4eKafSe1
2rSGNBJvNG5PcRQ3pfBIpFebADqDckhMch16eEMsc+iptJlRpHpNAIzTJwLCV1fT
dQgPvVG1m8U095PA3BaeHyLHUd49DpHmG5oGF6vC2YEIPTqqzL4n9NUnnxhngI4V
gkdue3DmtbfX6NFOMSfp
=Vw8D
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
