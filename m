Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaHAS1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:27:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40433 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:27:28 -0400
Date: Fri, 1 Aug 2014 19:26:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks.giri@samsung.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, mollie.wu@linaro.org, t.takinishi@jp.fujitsu.com,
        khilman@linaro.org, lee.jones@linaro.org, andy.green@linaro.org
Message-ID: <20140801182656.GJ30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aRuUY7KzmetiZjaI"
Content-Disposition: inline
In-Reply-To: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.121.167
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv10 0/4] Common Mailbox Framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aRuUY7KzmetiZjaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 05:59:54PM +0530, Jassi Brar wrote:
> Hello,
>  Here's v10. Not much different from v9. The code and the generic
> bindings looked good enough to relevant gods, but the patchset still
> needs some formal loving in the form of Acked-by's.
>=20
> Changes since v9:
>  o Purely cosmetic changes - added headers and used BIT()=20

Given that this code is now getting very stable can I suggest setting up
a git tree and making sure it's included in -next?  Just send Stephen a
mail with a pointer to the relevant tree and branch and ask him to add it.

I'd say it's probably worth merging at this point though since it's not
been in -next yet and the merge window is likely to open this weekend it
might be a bit much to try to merge it this window.

--aRuUY7KzmetiZjaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT29vtAAoJELSic+t+oim9dA8P/A+FpIIsTly/rMkM4zGMh/v0
BYIZyAxSl1AcOaXx2W1LnbW46bWFjGn/6bADpa2l0J7VV4ia03dyk8p28YfvFq2v
65tOuNRAiqmqv9+BXVG/w4IMPRj7SpTYG9p6i/vz7GG2GKB/FFe2MaaGYzcWgbr1
TkOeXhinDuyvd4gQsg4f2GJI4djhY0KWnU41R02rMWZwBbVnfJSEqFbwo66XXboO
Uvw1l9WCK56GqJVf6pR4tNSxqD+8fp9dpJXrdyaZ9Ul08atd2xpR4jyUraljSqAG
fTar2Vy474LMh8aDfS8wEPXbf4AuEwq0PzUvBTY1/rJMT8g1kvURiJ3+h2ihKNAN
3EJ+rPEcsCmlB04BP3/Y2BF1HDNM/51uVbekF7xvOaTCK01N8MBfth4D38plm7Hh
IqaVezfrSrgo5cz8/xssii4NFYbZGSKtVs6Z0oIZijME+YtEqQrLuAG2kRNdLzDR
DANb7dtB3U848vn9hQaCJ5HPGYjHfS21O609oSAltwkXdx2xYh77McVn5AcKw5ax
lvAa7wahag7Z40zSnZpFJV0bPD2TDKpZgFnDRWF07m24VGhnPLnY+HXFEG5BISaT
bSOIXfPdsLsXEpmvnxIdl0ToavzW4TfQbeCL5RIPU++fjoOpbgvTMbO3ayAlfT0r
dYZttikv27G4WqMPhNXl
=xtYB
-----END PGP SIGNATURE-----

--aRuUY7KzmetiZjaI--
