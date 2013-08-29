Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3H2MhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:37:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44541 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3H2MhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:37:03 -0400
Date: Thu, 29 Aug 2013 13:36:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        David Jander <david.jander@protonic.nl>, linux-kernel@vger.kernel.org
Message-ID: <20130829123640.GD10783@sirena.org.uk>
References: <1377764794-12090-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W0CfcDg401mapelP"
Content-Disposition: inline
In-Reply-To: <1377764794-12090-1-git-send-email-lars@metafoo.de>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] regmap: rbtree: Simplify adjacent node look-up
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W0CfcDg401mapelP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 29, 2013 at 10:26:32AM +0200, Lars-Peter Clausen wrote:
> A register which is adjacent to a node will either be left to the first
> register or right to the last register. It will not be within the node's range,
> so there is no point in checking for each register cached by the node whether
> the new register is next to it. It is sufficient to check whether the register
> comes before the first register or after the last register of the node.

Applied all, thanks.

--W0CfcDg401mapelP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH0BVAAoJELSic+t+oim9ThgP/3Se2nJqo8dxxToej5ZJNbSK
hWqXcAe6jzSRxUNf3Ak9RTF2LxN7szmLsbiZtcdj+5luO2YQh2bXUCwl4wWrGuu3
qoHWXvxB47cq4vUx34bMLZ6T50BuWLOrrbH50vDXyt5mZTzQ0jvG1IBfYfmjmT1n
tllUqxpNzeGtZbagwSZk+QKzeEveIRkGmFO3Q5W+5IsRxVZurFQVMyb0Gs31Wg42
pa5X9PgMxDKKlgHOo39Vbsw5bLN5LsMte7O+OKEISTqDW2aGx8LPxJnWiFPmAvdw
v85Y2Xpi5r3Ra50O2TxP5zCegOGRZMHBoHC3Lgt31B20tpLySr/xV0Yf9GIioYdG
eIXnvyhQcEHP8xMOMcFV+PGjmmhMFqCfzUW20OnVFqlltYlc+Z4kNyz54w7TpRtr
2v2vIemfXWr46MFgggkUdLAFS3H8iWzzpb/+8+kQhLcS4iutUVcBse6gT/FBHM9y
hZYWt53RoyH+QnmcoEgbm4WXCVqBGjLoo1YJdW8EQnqGWounaPoa/HsRuUuzkicV
NCIA0Gl7Q0rlT1aJgZJxFW4TWrvUTMQ0AqFMuqCp/vwqXN+D7DGFPjAiOB4ovT8N
I9q/RYSZoNbCJuYLhE2EBh9+IxbkG6rI2Ql0ed46Dx020aB0GK3Kz4NAsPkJICT3
1SivkNmoBT+xgz4vQ4VC
=u6Za
-----END PGP SIGNATURE-----

--W0CfcDg401mapelP--
