Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaIAPyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:54:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44990 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaIAPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:54:01 -0400
Date: Mon, 1 Sep 2014 16:53:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140901155350.GF29327@sirena.org.uk>
References: <20140901132808.c7b08f4ffa7055dc28e6dac7@kernel.org>
 <54049590.6060500@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1+kiJ7gFzGEgD6MU"
Content-Disposition: inline
In-Reply-To: <54049590.6060500@roeck-us.net>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: jdelvare-hwmon tree unfetchable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1+kiJ7gFzGEgD6MU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 08:49:36AM -0700, Guenter Roeck wrote:
> On 09/01/2014 05:28 AM, Mark Brown wrote:

> >Today's linux-next merge of the jdelvare-hwmon tree got a conflict with Linus'
> >tree which appeared to be due to the hwmon quilt series I got from Stephen being
> >based on v3.14-rc3 and subsequent changes from mainline interacting badly with
> >it. In addition I'm not able to check the original series since linux-fr.org does
> >not resolve for me.

> Jean dropped the linux-fr.org domain, and his old e-mail address probably
> won't work anymore. The alternate (and temporary) pointer he gave me
> is http://jdelvare.nerim.net/devel/linux-3/jdelvare-hwmon/. It is empty,
> so you did not miss anything.

I figured it was something like that - the address definitely does
bounce.  Thanks for letting me know, I'll update for tomorrow.

--1+kiJ7gFzGEgD6MU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBJaKAAoJELSic+t+oim9H8gP/i4ZeUQNr25VxAuOC8fnCpst
LDyyLVQOUt+xBhA6vsk8ko2oNR4CFe34zH99TPdEy4K5sYYEOOFaS9pdt7OS2tTm
XmDb952j0VVcHT8V/PeWvB4d5xGhxqp0eoJLTUUYPAb/JDx5q6U48hzKZZnvhDXc
oOp+LcqFWAdK31KfFYAuwkAe8nwLP45HP6vFPZMwxCKcKvcj2GCVGV599KH98wy8
zROZGugP1AHq0Nsm29mWqh5NcPUAMmkA/cy61q8IqYfiTvm6eoHoPnM7VdRUQjYf
8ubSMu5cVsd1QEusrY/PioGvH2tJ9pz1avnmyVAx7/GTaAvH5PSA5NjtLcLXZjN0
LD1APWNu8mlkwedAzGclRyG1NhIpRx7z2fskGapsgVXDPqpIed2UkxCEXFwuO1cy
INudlZ3EFOjVsHJKT22u96qK+BZ49UgzFxIDCciJQjujvsxXOPeMTVwdYQuP7ty4
eAMZuTYzoZsH4ueoEjkbXztRxqk0dF0NKL6eAl52TMLZC98vkkAXVPyGpLJG+D96
B4KiOX9IzO1F4oDoZDPERQ5RivvlkgVmBfLOz/nLr1R5UcGs9ZjbCKOHcq+hQZuV
H+jTxtf1X9G+u3EG4s7iKLzrw0UUH7lYF1R5Us++ld/f6Lqt+IQQ84WpJBkbq6oc
IE33RVRNWUEC2uBwQcLy
=32DG
-----END PGP SIGNATURE-----

--1+kiJ7gFzGEgD6MU--
