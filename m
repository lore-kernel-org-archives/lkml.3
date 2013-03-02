Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3CBEIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:08:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58829 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab3CBEIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:08:17 -0500
Date: Sat, 2 Mar 2013 12:07:33 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "J, KEERTHY" <j-keerthy@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "liam.r.girdwood@intel.com" <liam.r.girdwood@intel.com>
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
Message-ID: <20130302040730.GI6610@opensource.wolfsonmicro.com>
References: <1361332815-2348-1-git-send-email-j-keerthy@ti.com>
 <20130220112639.GA2726@opensource.wolfsonmicro.com>
 <DC88CAD03C0052499C1907B327FC63229BBE34@DBDE01.ent.ti.com>
 <512E4D99.6030201@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0XMZdl/q8hSSmFeD"
Content-Disposition: inline
In-Reply-To: <512E4D99.6030201@wwwdotorg.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0XMZdl/q8hSSmFeD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 27, 2013 at 11:16:57AM -0700, Stephen Warren wrote:

> I believe what Mark wants is something like the following in this file
> (take from Documentation/devicetree/bindings/regulator/tps6586x.txt):

> > - regulators: A node that houses a sub-node for each regulator within the
> >   device. Each sub-node is identified using the node's name (or the deprecated
> >   regulator-compatible property if present), with valid values listed below.
> >   The content of each sub-node is defined by the standard binding for
> >   regulators; see regulator.txt.
> >   sys, sm[0-2], ldo[0-9] and ldo_rtc

Yes, exactly.

--0XMZdl/q8hSSmFeD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMXr6AAoJELSic+t+oim9AQIP/304N/dqLWmUrXUp2oO320E1
pojGV/c0QoqmW1R8ym6hA9rwufW3jTNdjPmfa+o4N+gJlbh+X5QmEP0Vi+kyz9sY
XsvuhNlEtDWK6e1kMZgj/imdCiDEX88Pczt/ENt1FNE802iz+sIaaRx1GGm6OJjZ
4pMy3pIfM558zx8RcmWBRnSaTtXC0i99xAmtI2fihmRNYOCs0rwRqu9f1w7x9+Tb
8mezxgj7cZ/+UEeCK/U7u0kJP7kPjm3tADwB5mfhlHWlQkfn5H57JEViK7hRWLJy
TJnQqmVa4zgCH1wPLP90+E/NrIfwlORJQJtNL4zXrTaMZAB0e0/9Bu7YRPOO0aEl
NDNYNJYLikcU1YFLjW0R2jpje3X/p+yc3/EvNRADz/4k1KsDX2IZqI9mH/Z8dNmJ
WO/Azb2/FaEa8Iv0jtFtwAKllA5sSlaH2gRr9cdu7tCwn4JnvbRmcHh5ry9K/e4w
32Z/XKDGfHX+mW/XMlOagWRcShSiCWiBWYY2IOnjwYVp+iA0Oh2rsRZ5CWetEE6F
+Z1naMUaxdgUspYhNYhG3kOu/euLwfkgYfZ292+LVEieNJ8Sj07tdneWd+zwlEvH
UGBI6PAW4ND0PgmD+9irSIhryn/a+ASFberPPIN4UP949urz1P8ZVhqe6GEhRtZP
aTYtDriwRJC5FK4q5nU6
=dddz
-----END PGP SIGNATURE-----

--0XMZdl/q8hSSmFeD--
