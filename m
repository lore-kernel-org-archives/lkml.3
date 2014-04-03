Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162492AbaDCJHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:07:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50582 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162430AbaDCJHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:07:25 -0400
Date: Thu, 3 Apr 2014 10:07:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140403090712.GP14763@sirena.org.uk>
References: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com>
 <20140301003320.GA31852@kroah.com>
 <53143CD3.30209@ti.com>
 <20140304045626.GK2411@sirena.org.uk>
 <533BB04E.9000206@ti.com>
 <20140402231857.GB26696@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcTtWMBd/uZDG7+Y"
Content-Disposition: inline
In-Reply-To: <20140402231857.GB26696@kroah.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivercore: deferral race condition fix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcTtWMBd/uZDG7+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 04:18:57PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Apr 02, 2014 at 09:38:06AM +0300, Peter Ujfalusi wrote:

> > Do you want me to resend this patch in hope that it is going to be taken or do
> > you have other method in mind to deal with the situation I have described and
> > fixed with this patch?

> Can you resend, I've totally lost the idea of the original patch.  And
> if others agree with it, getting acks from them (like Grant) would be
> great.

Acked-by: Mark Brown <broonie@linaro.org>

FWIW.  It's not the most elegant thing ever but then nor is deferred
probing.

--qcTtWMBd/uZDG7+Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPSS9AAoJELSic+t+oim9IDoQAInTj3IUEqUctvlzVSzjKQ9/
wIpN+DAkHcnvzd0HJ8nm3aLUV7GCWhYanT5zsKKCEcFnHOz0vARlzGLeEasIEqph
tixHllf4y+L3XSNYR0MshuU8qvcs7NjohmcquhKj4Adw1LP57FrhZ9dDaKbzndiq
TWqEi48tCk0O0AEhFMjqd9ha5a1AWij69ADbTwmLwhYS8ar++abpF20Zp7icXOxn
Z2JfixM3aCVv4Hnto8AbDORH3V1KcEjxd4SVqAEG2KsJJ5/aIHAbWANelSpcuOD1
3o+42Tqs03Lr7R0MKRdK3EzWe3Lesg7oxQ4ZEnmbV4t8w1JaEfNdqXhfVNb1NtAn
V4WAu2FxZw59VAzGIhV/blWhrI0m7F+OFz5u2k2SsU+VNowKAdxrdhijB8sMNQZo
XG6jux/7Wlu94Gz5/YeNGOJlJDQ+aGTxt87t9irV5YIrC5aSj6ZSprysw7UJOVRv
xgigJXLYsDejAvndIfU4PJkSMxLCAYG+7jO1zT4Cva2Gjbl0zUtDlz0IB3t+hUdF
8dig/7/5gxK6olMEaciH6tog0uVuyH+ehvYFQOnEIeSDqX9GRd8SlxZQ0YJeX+NC
9iZoKww56k5nD84NtgzqL0ypm90KYcGDT4pzcfOw70RGRPWrurW3rMdmsWS+N0dN
8dgRJ6Qjy4nu/rGcXmQo
=kNl0
-----END PGP SIGNATURE-----

--qcTtWMBd/uZDG7+Y--
