Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3FNIRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:17:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32985 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3FNIRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:17:51 -0400
Message-ID: <51BAD181.3020902@ti.com>
Date: Fri, 14 Jun 2013 11:17:05 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1368796954-3499-1-git-send-email-kishon@ti.com> <51A43E0A.8090201@ti.com> <51B9C3B6.1080707@ti.com> <51BAABB0.5060107@ti.com> <20130614054720.GL8164@atomide.com> <51BAB9EA.5090805@ti.com> <20130614073314.GA20992@atomide.com>
In-Reply-To: <20130614073314.GA20992@atomide.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2HNHPTJIVANKBMVEBWGEE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HNHPTJIVANKBMVEBWGEE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14/06/13 10:33, Tony Lindgren wrote:

> If we want to fix something this late in the merge window, the patches
> must have a clear description what caused the regression and what happe=
ns
> without the patches. These patches don't have that. And they are marked=

> RFC also. So actually I'm not applying any of them before the regressio=
n
> descriptions are there and the patches have been reposted without RFC
> and have sufficient acks from people.

No disagreement there.

Kishon, I tested the patches on top of v3.10-rc5, booting with nfs root
via usb gadget eth:

Overo: works
Beagle: works, but I need to reconnect the usb cable after kernel is up
Beagle-xm: doesn't work. The cable is detected correctly, though
Panda: works

The problems with Beagles are there even without these patches, so they
do make things better (fix Overo).

 Tomi



------enig2HNHPTJIVANKBMVEBWGEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRutGBAAoJEPo9qoy8lh710rIQAJH7MGB/33pOFZXA+xWhWZiI
u2EBcMjobB6R5PSvuQVZtE39fPDf8Z+p0D2E+2/FKTS4uzrFFVmXw2NgVSfcO/Ny
GFWTlgls8K9j/BZJ0AaM9YywDUthc/xrb946YHCORKkPH9AaqIJWlqHQIDWx20Cb
dK6bKmqbuCtq+ci9IV8rBfOpbV3N7PzyajNyZxLhsc+6qVrWkjnLYB8skuP2KaGE
71V3Tghvgtw+ZlENQXE1+/VO54XNNljuzQ7nOfhflHDBg0phwEd5DiHFlBa+9c6B
wh9/8kC7iMiMCMTMWLEbHZFw8wroh57PckFjOvbRgH78BqNSaaKMFvAwppjoCFn8
Ih6D1JfuT8h7tue7mMzEhirabXqmEj1XNGYjT8bMSqAHDkviE+VjrqG3mm06PBCk
sdSvvZjw+ZJeVKEtx8JFXTDMDGuMZQ7T+gC4wg+Vzl1J5XQy0vU3EmqENRS3bDLK
JzfUBPrCMfEqimrIc4DXnXcSRpPMsw4ajTPBHwuhGh29TXi+awDJl7yxi5gpUZDJ
S55j5vixv+36E6U3PCHpeHlaYsFXbgKoaogrd/Z54xswejRe1e1RY0S7nucWK+6d
NlQnbplCoNwG51G8lbsSbDJQhqypDkTCHP932vOV56TtXCYAbO9opaVgSDLqb3FA
4wzlDDJNUsEOn8EFKUG/
=sJcQ
-----END PGP SIGNATURE-----

------enig2HNHPTJIVANKBMVEBWGEE--
