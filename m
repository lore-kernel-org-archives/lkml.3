Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaCLA54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:57:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59968 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaCLA5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:57:54 -0400
Date: Tue, 11 Mar 2014 20:57:48 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
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
Subject: Re: [PATCH v3 2/5] mfd: add bcm590xx pmu driver
Message-ID: <20140312005748.GQ25092@beef>
References: <1394552775-31264-1-git-send-email-mporter@linaro.org>
 <1394552775-31264-3-git-send-email-mporter@linaro.org>
 <20140311160837.GP21216@lee--X1>
 <20140311221938.GO25092@beef>
 <20140311224517.GA5672@lee--X1>
 <20140311232545.GP25092@beef>
 <20140312004030.GH28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
Content-Disposition: inline
In-Reply-To: <20140312004030.GH28112@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 12:40:30AM +0000, Mark Brown wrote:
> On Tue, Mar 11, 2014 at 07:25:45PM -0400, Matt Porter wrote:
> > On Tue, Mar 11, 2014 at 10:45:17PM +0000, Lee Jones wrote:
>=20
> > > Are there any inter-patch dependencies in the set? If so, we should
> > > know about them so we can coordinate a sensible solution.
>=20
> > Yes, the regulator driver (3/5) that Mark applied is dependent on this
> > patch...the regulator driver includes include/linux/mfd/bcm590xx.h.
>=20
> There's no actual dependency though - the regulator driver can only be
> built if the MFD is enabled in Kconfig since it depends on it so until
> the MFD is present in the tree it won't get built.

Oh, right. Lee, no dependencies then.

-Matt

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTH7EMAAoJEOfTILNwq7R4e9sQAIXesbhSk/V4rmkcFBNd62ws
G/FcWJ6uiMLzmluuoFpbczqIkMe/5EqQlQLs5VJWP7NNbI2YK+LyVOBR3sZDj5uf
YaqtFDZlZhyhisz4jyfX413Fpuy7V9jEXdJiycf56eC1ulnSeX/HDWV1KS5bJg9L
paAoe8htqWDKFr58vMiA7gpEiJxdUV/zT9ZoSKhkpohiXTrcugPCOa7XPLs0lHG0
+VnZ/8Nsf+iUiKnKXZXhh6lc8+GovvG0LAotxeMrVIKgnNTpwyID1PbA6qXIAEd6
vc5J4vsTA3VvANubjq56FXqtncUEEU5cq7jQUMlF0gEQJF2cZcTYVnYb0Gw2/g73
MzWMkMleXcCAFjG9BoY7w1/QK2YfIpOmfhsYvP0YHX/N9gd3Z7Ex3EUG4JGjDixV
jyEBgBkY9AwXCq/r3py7xOKpXAQDHNqrfO4GACO614rjsnp5QFIvMlifEyko/4JL
xguH3ZtQtky6WXSb3E9NmrkZFMxfT/mq57TH8Y61ETrDIhOvfay4AAR5CxeNp+u6
hlesUi1NZDCZmxVvRdR77fBNRWupgkpU1Z040oA0mbcShAlVmcx1fHJeLx48erWO
Vr4AZXpCVGYeOLQhxZpQ09FDrpRGnpIybqYMDtEWW4u0gyWk1Ue0QHg+Ajy+9/PA
6iXZWkG0JA7ftanyq+op
=ouhT
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
