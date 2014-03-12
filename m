Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaCLAlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:41:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45604 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbaCLAlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:41:02 -0400
Date: Wed, 12 Mar 2014 00:40:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140312004030.GH28112@sirena.org.uk>
References: <1394552775-31264-1-git-send-email-mporter@linaro.org>
 <1394552775-31264-3-git-send-email-mporter@linaro.org>
 <20140311160837.GP21216@lee--X1>
 <20140311221938.GO25092@beef>
 <20140311224517.GA5672@lee--X1>
 <20140311232545.GP25092@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UU+P6sd7srm6fAXi"
Content-Disposition: inline
In-Reply-To: <20140311232545.GP25092@beef>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] mfd: add bcm590xx pmu driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UU+P6sd7srm6fAXi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 07:25:45PM -0400, Matt Porter wrote:
> On Tue, Mar 11, 2014 at 10:45:17PM +0000, Lee Jones wrote:

> > Are there any inter-patch dependencies in the set? If so, we should
> > know about them so we can coordinate a sensible solution.

> Yes, the regulator driver (3/5) that Mark applied is dependent on this
> patch...the regulator driver includes include/linux/mfd/bcm590xx.h.

There's no actual dependency though - the regulator driver can only be
built if the MFD is enabled in Kconfig since it depends on it so until
the MFD is present in the tree it won't get built.

--UU+P6sd7srm6fAXi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH6z7AAoJELSic+t+oim9/k0P/jx0GxmDS7i+kPAtBYWDAwnD
CSrOzMd63UfJdzXyQ+nt2zfC8FV+g8TGegQjgN3179LuX52zKPo9louXw/YrTTgi
i+XXh8nr+jCEcktX/wnBcpEcLBma/rWIUa3DWjlXKDXFIhfoPyKVcT5oEoG/sHJj
RV7PT+7QIk25zAnWo/mMv33l8M3qMwV4j/aeWlFnn5IPEaI3rtU18n/TFl3HnchI
yKGYyPgFhI7R0gFualm39QNYjGw/xm7u/f3aaP8V1o950H90P43XfgLfSHyCX4j/
A8F4JTR5q8pQDcfXLA9/GBvDgVkKHgYMQ8GBoLEYOYHyxZPFZ0mwwxoZhxj10ByT
+kujpqTdbI13QOUtMGz1edMSRRSNsEgSRz0b4qmqma8YYm5OW1z7mUuvhJXY1+V4
hT/eeP9LIjs0hH+1GgxwvqoVOHRxk+bQrQgIlKbdVAZJCP1+Wgj+Mg+/ZXi3D0k8
kUvvi1w8NfaCzYydTAHA/XLl/J2RinReS2rSyaV6marlo3epzPo981OYvf9fL1sa
nhMN7TIzQMke/RjSzEJA1iBoG1q+zg3/QSJR+spZ4lVtQLE/RsFJPRmHKZICjN3V
JE9I1cJkNgTD6Y23D5fVqkmHNf1IY0Nyq30OVxJsAUkCOvi2juYn1Wpc1tEfNrYz
HCqWOCo0YgXBtD7MTYSd
=c9RH
-----END PGP SIGNATURE-----

--UU+P6sd7srm6fAXi--
