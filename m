Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161103Ab3BGSxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:53:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40350 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286Ab3BGSxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:53:33 -0500
Date: Thu, 7 Feb 2013 18:52:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: convert to idr_alloc()
Message-ID: <20130207185253.GE8879@opensource.wolfsonmicro.com>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
 <20130207163247.GL2875@htj.dyndns.org>
 <20130207163958.GY4720@opensource.wolfsonmicro.com>
 <20130207165547.GO2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <20130207165547.GO2875@htj.dyndns.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 07, 2013 at 08:55:47AM -0800, Tejun Heo wrote:

> Heh, this is embarrassing.  I got too focused on the id allocation
> itself and missed moving i2c_register_adapter() call.

> I think this should fix the problem you're seeing.  Can you please
> test this?

Oops :) I'll test this tomorrow, out of time for today.

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE/f+AAoJELSic+t+oim99C8P/1bOKNtpGRltzQFMSg8td7Bz
R+Cc1Ta2sF91hdO035RpTYYEK2SBu8bzU3usENbw8t3edBVyQi8khqH0VyiZma0r
FhNZRTx2lOA+dO+2vsp5H7R0xdbPkU/DGePh/seZ/yK5xTy873+GUan8ligQQOLo
NbodP/mzMPKcWKqcAFnXCtfD/AYx56pbQRf4SY02cXXjrP0xvzqx+mrwrqJFcL0k
ytdaZor5qjDaJF4AKD+xiZ0YRbLPn3cEH1r6dcOYgp9uJx/FVBh2flHOeg4FM1bz
Zw9PH2F/yAZ4sNwqdE5t2BXVyvdF/yTh5m7aFKYZ3qny5B7KuzBo779+l0lKvYS5
OcuUM7UKNi42gRMjWoMsAa+xpbYUY2XNeERX2lchdpyUQYK04Q4W82F+yUYnehSz
qn/g9uD1/bwpzPM7TOhdaa6UMDJZHtU+O5mN/WcufBOkqY770Qf7qE7rI7srTSuo
OB6PLKJfRgoZ8VZ1KK6L71yoetLjPDGKggoj8D6E4HjSwODOeAH7iD26C4zBto5U
wBWnuWuQYjtZN98K77UkhyqSTlVrq/2SV7V3iwMbQbvUTuRJQnTN28WDLs0XdZPh
zKUdK9/vfXEy0iFKiBN69FsjFMus9FAT2ZVN8lOlfCEn0x0/qlaKSoP5MXN+Diqa
LZ0bcvzwu9+TpXAPxVSw
=3NAy
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
