Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaBYDjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:39:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51289 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaBYDjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:39:52 -0500
Date: Tue, 25 Feb 2014 12:39:29 +0900
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: "Austin, Brian" <Brian.Austin@cirrus.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20140225033929.GP25940@sirena.org.uk>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
 <20140225000027.GI25940@sirena.org.uk>
 <20140225023840.GB7229@MrMyself>
 <20140225030947.GO25940@sirena.org.uk>
 <20140225031313.GA7343@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vS1hrE1x6fAwh07Q"
Content-Disposition: inline
In-Reply-To: <20140225031313.GA7343@MrMyself>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vS1hrE1x6fAwh07Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 11:13:14AM +0800, Nicolin Chen wrote:
> On Tue, Feb 25, 2014 at 12:09:47PM +0900, Mark Brown wrote:

> > We should be able to arrange to have the ESAI be a clock provider
> > shouldn't we?  If the clocks need to interface to other things (and they
> > do) then we should be able to use the standard interface we have to
> > clocks.

> Excuse me, I think I just don't get the approach how to use clock API to
> standardize the MCLK derived from ESAI IP: it's surely not a fixed-clock
> so we couldn't register in DT and it's not SoC internal clock which means
> we couldn't register it in the SoC clock driver either.

> Could you please shed me some light on it?

So register it from the ESAI driver then.

--vS1hrE1x6fAwh07Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDBBuAAoJELSic+t+oim9k60P/3GkvihWgQKi1BcQUvHGm+y9
E5cjPbAtLRSym4/twPYjudzBQK2KsqVMi9ovgquOMG7PIBTNB/f2aVjXpSVO+4T4
jK53dJWzPHV8sTOVpXExYobv9JmjVO93ljH4Hj5X/PXuq6Z9lowojtEqeGWs3kST
BtUXBNBXBmaoQ/UmHVFCXBMzbObHoh4tx9nu3Lse2yvOuYIY7RMV+hUZIAY0xyz4
AuuN8yjFy1uwNXdy3KlBhWNeBk7ZDOfxcRlLBaGyLhozA2P/3ojygi2AhAn9r2P7
g/ehk3nn240CQGrSnBnt2WyzPO52Fb2/ea9bJ7wd6UlxZE9HDGyn2BPj8dKdo1Hg
9U8N4IcPhwYOTLVufto6/gz+8Hs6Qir4jVfl/XK1JOD3A93c+UQXU2Iahe04kALx
QMkzKfsBKB5qdn0t4fxsZ3Um9mCYwLwcbniPePwB97NgYJWuIfAaud6m2XmUCoMF
1wDp5q50aa/FD3SVWs7fr0ZJL39ml4Iq1hbSXaXrq4Ve2luTeq2eBrIg6u9AseMM
AZnWv1q1zQdtgwT/RLQk/IM6XUwGfwqwgbudAtWMMLFG1Ui5l7g901p0jISQnnHN
sKSfYGIb4dUUwvQ9aW2Qt0W/IfUmxDDINy845G+cYIpEbheLRJfzG5JLzOkLjBdy
9+tkR2PU4haODF3mn3iu
=BMwP
-----END PGP SIGNATURE-----

--vS1hrE1x6fAwh07Q--
