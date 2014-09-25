Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaIYXlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:41:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:48555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaIYXlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:41:52 -0400
Date: Fri, 26 Sep 2014 01:41:46 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 1/1] power: Add simple gpio-restart driver
Message-ID: <20140925234145.GA2063@earth.universe>
References: <1409167431-21155-1-git-send-email-davidriley@chromium.org>
 <1409167431-21155-2-git-send-email-davidriley@chromium.org>
 <541BB278.9010701@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <541BB278.9010701@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Thu, Sep 18, 2014 at 09:35:04PM -0700, Guenter Roeck wrote:
> On 08/27/2014 12:23 PM, David Riley wrote:
> >This driver registers a restart handler to set a GPIO line high/low
> >to reset a board based on devicetree bindings.
> >
> >Signed-off-by: David Riley <davidriley@chromium.org>
>=20
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Is there an immutable branch available with your restart handler
stuff, which I can pull into battery-2.6.git?

-- Sebastian

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJKg5AAoJENju1/PIO/qa9zUQAJNPtR7q96NaF92VxP9928oY
gNufxPNDB34jP28DvUR1b4y3+4dzoSvg0nmuEgxxubpWsGEHms73NPkdglwksFyL
ksS34PNljHaWIHsVGeOaHIJNf6/IjEn0fxzGAZ6Y4UbCPjDC8VZbjImSCrrDzt2p
o7aRpHDndbjzK3FpfCS9bXdov7duhQ1F8XeCVuzNAH7xu2HtJC7OQxTohguHwBvT
96CkBpuJqv6DNuxf9Fu+aJWeybcEDihR1cyzaS19S/CH0F6nRKH8+wy2OiAvJ1YP
gQQLNZza93gX4vX6uISzoWoVbAt2PDJr5RtutNHvycQWfAyUFbRFmGLwG6kHwPOH
gEnX1eiGezaaGIG2IWkX4fk3gkqadcqi20qM9vJQWtuir3OO69OuzvC//WCVXmHD
ONrqH3pxoZtOivuMxXm9P39UIrWQHKrjJZWAS7xi3FJ2Oozb3raubtIIE8hhAico
tg1FwPAlCh1KLqKVcnHlyPQaOC1Nbbi1xT12KD7xMxKWnih4+7NL9i7VUh7Pk8Mu
L9psUpJKyUh7A2jSZxmqiJ/ILr4Lw3i6R/ku8oqcknIT9Kr0R7CCQmHiF/AXFQ6i
DYRdkSNE8M10qkIRvZ58FiN6GQJDt4+z+Y62atup2OxKPTpnowUEnUtzsBHApcb4
p+JPdnBPyGFtI2OeR80j
=Jfs2
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
