Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806AbaFUKTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:19:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51774 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaFUKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:19:15 -0400
Date: Sat, 21 Jun 2014 11:18:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140621101855.GL5099@sirena.org.uk>
References: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
 <1403259380-13634-5-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iogDzdALPo6egaiW"
Content-Disposition: inline
In-Reply-To: <1403259380-13634-5-git-send-email-geert+renesas@glider.be>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] spi: sh-msiof: Refactor sh_msiof_transfer_one()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iogDzdALPo6egaiW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 12:16:19PM +0200, Geert Uytterhoeven wrote:
>   - Move buffer pointer and length setup to the top,
>   - Make unsigned values unsigned,
>   - Loop over words and increment pointers instead of recalculating them,
>     which allows to kill bytes_done.

Applied, thanks.

--iogDzdALPo6egaiW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVwMAAoJELSic+t+oim9ipAP/2zXPAWWngyQ0m1Ky0ttpBGj
JrMjIPr1BXoEyUuovkNCK3Ykiywt36kZFvzshag/p0Ej0jAFUMfatL00J8k09kWh
Q7f/thcEOB19JM4TZhq8R4ga8A97EX4S6WE+rHThPzHqKz6GWIzqAfiwimzZ/+Uk
+PVrFjbx4xjFyLOvJqaTMFdFuWU6ZavlEVbh3CLpZ1W5Op6LG8sA0Z6AQR4WMfxA
6r2B5Bcu0dwcBb9ygeerEQO+mpZ/OsX1nEbjdlMbFIwdFj6ONJEibmwMPv+Culqs
+VZstmiUtGR/hjr+qNytHr/j3nvByoQp4FP/LKHCueLLXngoVQP2QdNj/dobDvqo
Oc9IrUTJd+rsOvdb46ZaKF7NDJsb5KnS0OG8FIIGqFMnwXzOb7cledcqvTQCZwvK
Ec5zG0yk35LlUNtExir2F0BAysoIf4CJ5rHaAE8OfGk+8OfdQjBoQXPo/sv9dBtr
t2GfqVtVoTrOaaN1I4g3QljiqWMOGPBWkq6hhTkOASjy6cEtz31lCqUpXHnZlCjk
H6qCTckQ7v1Hvjmqz6jC6N5j2utR+fq0ljUSOD241Q27kV1avR8RTbdmoarOycVg
xcxZpaUC/fUPcwBFsw1d1+DZDCnaoQ/POvGNjt6eZosqrMXeGNu8yfV3Jvt6bPI8
jWw8+arM7BNYaq2jLyeZ
=enXp
-----END PGP SIGNATURE-----

--iogDzdALPo6egaiW--
