Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3IINqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:46:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50161 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3IINqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:46:31 -0400
Date: Mon, 9 Sep 2013 14:45:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Daniel Santos <daniel.santos@pobox.com>,
        Daniel Santos <danielfsantos@att.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20130909134558.GY29403@sirena.org.uk>
References: <522BC27A.5080303@att.net>
 <522BCA33.6000701@roeck-us.net>
 <522D0D37.3050500@att.net>
 <522D17EC.3050908@roeck-us.net>
 <20130909110257.GU29403@sirena.org.uk>
 <522DAE69.4050608@ahsoftware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mla3UN0L0Ly2to/J"
Content-Disposition: inline
In-Reply-To: <522DAE69.4050608@ahsoftware.de>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: "Virtual" Interrupts -- Need help please
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mla3UN0L0Ly2to/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 01:18:01PM +0200, Alexander Holler wrote:
> Am 09.09.2013 13:02, schrieb Mark Brown:

> >makes your mail very hard to read.  It looks like your mailer has also
> >reflowed Daniel's mail.

> That's just wrong. Mail readers should wrap lines, not senders. And
> readers can do this since some decades.

There's a specific way for senders to request that if it's desired, set
format=flowed in the MIME type to tell the recipient that the formatting
isn't important.

> The reason is obvious: No sender knows the line width the receiver
> can display. So, for example, if the sender hard breaks lines every
> 80 chars, a reader with a device which just displays 60 characters
> at max. will see every second line with at most 20 characters. I
> assume you can guess how such does look like. Furthermore there are
> still a lot of people which do like to read mails with line length
> as long their display is possible to show, and hard breaking lines
> on the receiver side does make such impossible.

> So the correct behaviour is to not hard break lines on the sender
> side and leave that to the reader on the receiving side, as only the
> receiving side knows the line width.

This doesn't work well with lots of content (like patches) commonly
handled in technical contexts - the line breaks actually mean something
and it's hard fo the mail client to figure out what is going on unless
someone tells it.

--Mla3UN0L0Ly2to/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLdETAAoJELSic+t+oim9qx0P/1tIr9whNtVbTLSJb/jJxT9b
Pzg0MRw6c84APL0cQJyt3gv7kj6TzwJyEyeWnkpwl2u1EsOMC3+GCmtBB8PvB1Hr
T/TZ3kSgTjrpGU/IP61HzJAnIWQngyky24cJeCTS2KANOLbzQyh1VycTWLbCQ9ja
LJaqgsJXchYn9rwXp4FMteJ5o5M8kkX6XcOX0HFk7BdVLmmbgqybdq8NXE3fZHaI
QgQ+RjZBbASqNiujYdvMxQG+itU930ylWNRw+C0wGRBr1Kk/7EY8ziTnt7N/RYWH
u0L26AHMMfoWbOZsQF00XiJHTb2QrhMoPt7WJBMdJ1mrUvbA8J5YQRcNeb13FDDn
rAOivJ6aelu1iRwrQs8/PK3JrEjgQOMYEmlutBYbLHEegbHjEMMqLFHqgtuOhpe6
4nrJMp4SSCQ2x73l1UtGiKd5Qggkpu4S0RHRiOvc+fWDp5X9RGzdKbxfYE1fMFC1
BTsOijfWBsM4sQ93RYnS12/Fbwnu99kuAN9QEp86Gk94MQGISYEjoCV+7Y3o7eAB
fMx9GJ/WsDpim1ECL/+8PT4X/HoVJN8fPBBQ8udgLigIg3dTCsqpGZtxqpHs8x06
tQ2+RqkEBCAA+Ya67djzjzG+9Y6T/X3aXmzq/EJRU0zWqYBufce9u4uhtWuxal5X
I+WJ0v8kH2WCAofHUGrz
=/EVN
-----END PGP SIGNATURE-----

--Mla3UN0L0Ly2to/J--
