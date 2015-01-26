Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbbAZL1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:27:41 -0500
Received: from sauhun.de ([89.238.76.85]:55785 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbbAZL1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:27:37 -0500
Date: Mon, 26 Jan 2015 12:27:11 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        christian.ruppert@abilis.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V4 0/2] i2c-designware: Add Intel Baytrail pmic i2c bus
 support
Message-ID: <20150126112711.GA1052@katana>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 01:12:15AM -0800, David E. Box wrote:
> V4:	- Added bus lock to i2c_dw_init() as suggested by Jarrko Nikula
> 	  <jarkko.nikula@linux.intel.com>. Addresses infrequent hang that was
> 	  seen occuring during probe.
> 	- Added label in i2c_dw_xfer() to bypass unnecessary lock release when
> 	  acquire fails. Suggested by Mika.
> 	- Changed make to build driver as composite addition to
> 	  i2c-designware-platform. Driver can be module or built-in following
> 	  the platform driver selection. Tested as both.
> 	- Added EPROBE_DEFER return to baytrail definition of i2c_dw_eval_lock()
> 	  to defer probe if iosf_mbi driver (required for acquring bus lock) is
> 	  not available.

Applied to for-next, thanks!


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxiSPAAoJEBQN5MwUoCm2gOUP/07PyelWHyBnWyXRazX9Adcy
36ebjcYDu6xKhSDzkpoU2pADSq/mYPwPnAcTZmwa0Y9NgHQJ0h8JTlFeqd79ivW9
W0XAvJgEkeHVHIKa5VAWsJLrn2hnuIraDBRxFh6Li/UIbJxk5PJSynXswchZFqKp
2MH5/H2z9bmfCIvLkWBNnQYBKpCw3bRdwykQ+QRNHaIB4fMDbo30IJYkjGaLbw9V
x3geeIc8VYBUlhbIBPA1LXmsqDAIvLJhi+utlKh/NdpEFpAGBvtVn1mwm2eP8d1/
Y5sSCrFAqZTD9UtjyGbZmYooolR3Mz7AHaULRV9EPoKGdwnzLKCh75XRJzb8gNyL
Mr/OGDftmXvL5fhjawU3JXseB2UCJcL6bZpF6OX+yTiWNWBM6FRreIHmYnIfGy09
ps3/VpPORtzc4Vg5SuTtW4C79+NIpy7hnz8EFrJblMAb10216dLPXrFgM/w3E3rc
FEP4SBi7axTfpPCarrSrkvgdY+IT07cGjSAIjVuUa02Eu0Zfnwtu8t0ZEGHb8sui
p47401GOWbeMmdTErRde01/Wy3XHI2tkmWcngYuR95LXQhlNmWWSeHYJX05pP/E3
g/CaRvKoWVNLASegxy1TJkc7ZvjYuJI9RXudGdQmSBqBhBmJ0M/nQOCnqhmtW/K3
RJIaUKYALCLbi1JvIBcr
=bfAl
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
