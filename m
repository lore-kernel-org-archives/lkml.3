Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaGJOwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:52:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57825 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:52:22 -0400
Date: Thu, 10 Jul 2014 16:50:23 +0200
From: Mark Brown <broonie@kernel.org>
To: Keerthy <a0393675@ti.com>
Cc: Keerthy <j-keerthy@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        mark.rutland@arm.com, galak@codeaurora.org, robh+dt@kernel.org,
        linux@arm.linux.org.uk, balbi@ti.com, tony@atomide.com, kishon@ti.com
Message-ID: <20140710145023.GH30458@sirena.org.uk>
References: <1404884193-20580-2-git-send-email-j-keerthy@ti.com>
 <1404901379-30135-1-git-send-email-j-keerthy@ti.com>
 <20140710121210.GF30458@sirena.org.uk>
 <53BE90CF.5060407@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U/fatWn3w9i48dtV"
Content-Disposition: inline
In-Reply-To: <53BE90CF.5060407@ti.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] regulator: tps65218: Add fixed_uV fields for dcdc5
 and dcdc6
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U/fatWn3w9i48dtV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 10, 2014 at 06:40:39PM +0530, Keerthy wrote:
> On Thursday 10 July 2014 05:42 PM, Mark Brown wrote:

> >Applied, but don't bury new patches into the middle of old threads -
> >it's a good way to get your patch ignored.

> Okay. I thought only one patch had to be redone on top of the other branch
> so did it this way. I will resend a new series next time onwards. Thanks.

For something like this where there's actually no dependencies it's OK
to resend the patch as a standalone thing.

--U/fatWn3w9i48dtV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvqglAAoJELSic+t+oim9WQQP/2onpD/UaN80vD+apvUOM1B7
G+PRdRLnnMLy5IOXAaFOCYDMwHGHSUaZ2VoZNRrZG2IufR2gc3ME8WAht7oGkSMc
/ZC8eEQCTb7tJ+sSTgg8d2IEeAe8pKoPSz0//zva0ThtrTW3I8gMtMkNnRohL8aZ
JfmEIOeXOMaCjsdc3Obx/fzbil1gnua9Ks4pBda2UnOj5d5aMTIIGeQzP37hQeqm
t6MrhyohYZB0yFHN5W2EmoeN3vr15Y3Gp58ljeA0ekZTKbH1VyWbPLUSYVqK2/BB
qEdq1ON4lRjyVXTBZTvwQb1l+AwslWqNdkTf0VopHQQWpcT0CKuuwHQwJIpltMbq
CShZafowYIItpdQ2ZIncR5PVw3FVexzyZO2FELBiFITnpyhxqzWS6zPh3uGAeS1j
MnHTsyu/kCepe3mZh9/Lq8eCND1kw7BitS/dJ5MC1qya6jzmjlH9yCwYt3HNuK8/
soZOG8k3MQx8jpdu/Wf7aKowXfuDLhlXIZKmq2fUprqMGTSAtvR6A5i8f5/Z0zKx
ZtnInxRDlh7sAnv0VAYQr/O1xEWXDIKYExS23osbRoXHM9/O/E3nHHAi0YZH89Dd
iT4me5gq7VvkCmr+M2Hrpqzu430DE3f/be7BujeNLw6K2iOUz0oxbH8mmWJ5mX70
a/7UMczr4ve4BMLonQzc
=DftR
-----END PGP SIGNATURE-----

--U/fatWn3w9i48dtV--
