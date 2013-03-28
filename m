Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3C1APK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:15:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56279 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab3C1APJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:15:09 -0400
Date: Thu, 28 Mar 2013 00:15:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 24/46] ARM: ux500: regulator: Add accelerometer and fix
 magnetometer supply device ID
Message-ID: <20130328001506.GO18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-25-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DH1DRkmIQ+dOt2yx"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-25-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DH1DRkmIQ+dOt2yx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:59:21PM +0000, Lee Jones wrote:
> This patch adds the LSM303DLHC Accelerometer to the list of VAUX1
> consumers, as well as amending the already added LSM303DLHC
> Magnetometer's device ID.

Applied, though this looks suspicously like it's bugfixing an earlier
commit in the series...

--DH1DRkmIQ+dOt2yx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4uEAAoJELSic+t+oim91TIP/36+fNHNMBNeDqvduAIV+FV8
fcw/+xZujNvC0PLD3QsBGECnp8u2UxBCJMVJOZraN+2zOM+S3rq/PqTZvToNF69U
Lk97fR+g6KjtiLeH/yf6/wDfoQM1VcPEiOKNhZDlZEZYMkzLTg15L/+R6VYEYPg4
6SS/lTH488HdS0HGF/BsSV6/7d6F/Bf7P7wQsZSvy6UL1KrpeurbFFwMpMMtrqHh
xHiZUJ3XkP+Iere0m0QgjaQ6l50IgDxkkaMX9whQpowBavB+eeLCVY671JW2unLS
jyPilZUfCpZDj2kBmsJJNRBBSQDsBuQG/v94Z1qpaTNU3cc/JndXsHLEuq11DADC
nN1FExM4litfWILwG2bJFzrm/x6cgeIkekd5uiCWydCEfxHTqxuKmtIJ43VVAoeP
YgqSnOe14yopQSxPDDAUOkwhBpEvqNnU/MQueV36vRNYjcZw0OGPkcFh0DSdRlC0
lVDPtuIOmAW7XsfjmAApUsGmIfQ5RPFNaudRQRSoxvGuIqiBvsd5HzyktPrSdmcl
2VqmFefPN4SKuPs8ivjOIiC31aAY7aeC3R61D+cG4n9A+R4mF8Ak963Et6WMbEuv
yglClr8lF2PPRlDuNhYOGR4XKsJDD7/bBizYVPHKMle3kCuNFswHqOkOfMJ15XoH
SBzFVmRXzuCYVyYFekWS
=qZuO
-----END PGP SIGNATURE-----

--DH1DRkmIQ+dOt2yx--
