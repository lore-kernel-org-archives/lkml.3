Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3GXOcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:32:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33284 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3GXOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:32:11 -0400
Date: Wed, 24 Jul 2013 15:31:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130724143150.GD9858@sirena.org.uk>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-22-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7/Z1yz1L7BOCEubH"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-22-git-send-email-wsa@the-dreams.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 21/27] sound/soc/au1x: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7/Z1yz1L7BOCEubH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 08:01:54PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Appiled, thanks.

--7/Z1yz1L7BOCEubH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+VTAAoJELSic+t+oim98ZgP/iZ1yY4fAHzjOiPOeUuZ7n1Y
QeoIbAZpZfwBPRyMyKafrUNy8LLXxYNHOrbEGGiFLpelFBTX5Jttl1mTQEB17S/7
j8x35gAGWz7B/FgsiY9faaDIdjfS7ofvMLtFd+XAK9coz5Zb0ohI+FwzeN8T6Vo4
bkjgAI5U5eVYhPMo09PvDHcT/dAXOA65UoBrRz2J3XOhVEflMVXReNkj35FsgpQA
5y6xf8f8D76vJhIJa0tBEstCMOGJR3RErPg5rR7y2KsTdrA4h0Cn2hnMjHUAKrrr
3mM/E8Sim3B9X4IMj/ynYY/yp+uWPPIgAQcylDmeKJpBKQHpEhRNvxeCtues/cBg
E5Z4+RKUVKVQRazrmp6BxkA1ZzqFlpG0EXkpyz2XNikX+7sQcURHx9Rx/J6/gWPj
UQsewfva30+ua/sHZixNdwYTmnZUeNdKleMWM93qjUtZe8uBUpHHJeTEr7VEMSqH
UDZV3zuDjips3y4n+vJVm0AdQd9CC+UNkQTC0L13GJZUJXl9sC6cYylz+f6/5dPA
ujEJ6S60nfYfk7pIqcICcrzwxm4HZpIMmWMzToiEQ31pZTN8dhbEEg5UG+m97rrH
A0pfqpX+d/cAuQpQck7aZ8b1imfN9R9UdKdh47sMO2okwKD5/MxhrdF7t27MhGbn
7EJ2X0+j3BIAiFbhLe4Q
=cAsn
-----END PGP SIGNATURE-----

--7/Z1yz1L7BOCEubH--
