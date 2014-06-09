Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaFITR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:17:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34275 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaFITRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:17:25 -0400
Date: Mon, 9 Jun 2014 20:16:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20140609191645.GC5099@sirena.org.uk>
References: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
 <1402309780-8118-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vUOrpVjU9N5sOsWB"
Content-Disposition: inline
In-Reply-To: <1402309780-8118-3-git-send-email-cw00.choi@samsung.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] dt-bindings: regulator: Add regulator suspend state
 for PM state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vUOrpVjU9N5sOsWB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 07:29:40PM +0900, Chanwoo Choi wrote:

> +- regulator-initial-state: initial state for suspend state
> +- regulator-state-[standby/mem/disk] sub-root node for suspend state
> +	regulator-volt: voltage consumers may set in suspend state
> +	regulator-mode: voltage mode in suspend state
> +	regulator-on-in-suspend: regulator should be on in suspend state
> +	regulator-off-in-suspend: regulator should be off in suspend state

These need to define what the states are in general terms - in
particular it's very unclear what standby is and how it differs from
suspend to RAM.  You also need to define what happens if neither
X-in-suspend property is set.

> +		regulator-state-mem {
> +			regulator-volt = <1000000>;
> +			regulator-mode = <0x8>;
> +			regulator-off-in-suspend;
> +		};

Probably best to remove mode from this.

--vUOrpVjU9N5sOsWB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlggaAAoJELSic+t+oim9TF0P+wX+yll+5iSqe6ERYk7eTmD4
n8JY1dUtsVF0OFVQUVBC30jKUMz2DXUqXDpMQ1rPtDtMt9qmWq0Wcys5ZH+o/AqV
r2ME3E8zkE15YfUYYz24w1xAZvFUDJfGs/xgnBEpXeH9TjbuxkDxb975xyxLQ3M+
DBrwRyO8EDfsP3nR74Rl26x6admlGxlbC7Bj/TpXiVc6gTO67s3bywXT1HsOD00y
SIpm1bPbjd5IuIfRBW8aoysHgBY91DvkNk9wnTwOTTh07rqZgoCvcaV7vAdb0LHu
b0DsJi9YGphHTHYc3jyvWI09XPtDntDjojAvGONe4LyErwJ3AushFMEqgnfu+8wp
T3Ci0MQHSEkU1fRUV6Nwk0/R67vh4JBzPaufUdhSxXG/1HD0pskTmIl3jYLEIqU9
9ooGrqDYfACezkMrhHOXy+zk/P+gjvNqMAeUzlZjBxKYRmP/oJ/bin7pAjFryg9a
NpuRQvlD3GXHzaO+4/UqcXsvsw54E/QBy5B4i5co4WvnONInMw3p45oLWcBdCKpO
9b30fwI1Y76HWPn9jkNd5Xt52dIX96deDMF8Y5wz67Pi7BUDoBFZND6I6G5IhsAk
bjO2vyTNN03EMv4fv7R/gmSifyF4YKKjz6WVaO7cPWXXsdGxWVrRzylJTX/zOafU
4Jug78WpTouy7CvlMtJ1
=Du7p
-----END PGP SIGNATURE-----

--vUOrpVjU9N5sOsWB--
