Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaFFK07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:26:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56876 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaFFK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:26:56 -0400
Date: Fri, 6 Jun 2014 11:24:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20140606102446.GK2520@sirena.org.uk>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-8-git-send-email-lee.jones@linaro.org>
 <20140605103009.85BE4C40A4D@trevor.secretlab.ca>
 <20140605103709.GE19550@lee--X1>
 <CACxGe6vLuKygv0E7yq42qe-Lh+nMZ1wrL7PW_TAeoz55wz9q8A@mail.gmail.com>
 <20140605155509.GH24240@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HdZAANC5GEQnh8Bp"
Content-Disposition: inline
In-Reply-To: <20140605155509.GH24240@lee--X1>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.213
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the
 aforementioned systems
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HdZAANC5GEQnh8Bp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 04:55:09PM +0100, Lee Jones wrote:
> On Thu, 05 Jun 2014, Grant Likely wrote:

> > I still think the way to do it is to emulate the missing i2c_device_id
> > when calling the drivers .probe() hook by having a temporary copy on
> > the stack and filling it with data from the OF or ACPI table....

> That's the opposite of what I'm trying to achieve.  I'm trying to get
> rid of unused i2c_device_id tables, rather than reinforce their
> mandatory existence.  I think an i2c_of_match_device() with knowledge
> of how to match via pure DT principles (of_node/compatible) and a
> fall-back, which is able to match on a provided of_device_id table
> alone i.e. without the requirement of an existing of_node.

> I've also been mulling over the idea of removing the second probe()
> parameter, as suggested by Wolfram.  However, this has quite deep
> ramifications which would require a great deal of driver adaptions.

If you're going to do that another option is to refactor the probe()
function to take the driver_data as an argument and then have the core
pass that from whatever table it matched from rather than the entire
i2c_device_id structure.  That way the driver just needs to supply all
the ID tables mapping binding information to whatever it needs and the
core can pass in the driver data from whatever table it matched against.

--HdZAANC5GEQnh8Bp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkZbqAAoJELSic+t+oim9/e8P/1ahy4nWy5qhvn708KuMzIIl
rdqHa3Vz/wGrlvjcMIPIB+4qYmmb1Yy3aRP/QmteZMTcpg6DAhstK7+nxzcSQ01i
qUncE0YEvuy68T4Smp5zfM4oYBl2NdnO7hG5b0KQhNPyj4TSx+WtUNHoSqwG+TQy
zNOjUYUjfjB+ZTHDfN6ew4Nj21BpAKODyVY0AqxURxxMcf42S74kXySyDUai+cqd
ZI//TyfdrsMiHxtLweFjxwFHG9zmQDKGQOSTks2t+l17v117xnQiUamjZLBnBaV+
8IrC84MYBOhklQypbpSeDnYLui31mj/8rW8CgiM9VfACjqRuImJwxKYwthVXgPd9
aaGQ3Tcg6+GJgy43rmBdyk9KUfJgTNAUSfrlm/9ZZjA41KKHR1+HtZsxdzPhDJFG
FqPo1iJ6Rf1aH23wn2qp7O/bUGvlwdoetglpz0Z7iqMOJPwyGgLsyQclelNVwB55
VMd7whwtD72co2JH0j44k0eUfKcX9FgmSNpMNOGcwYHykjBL95LRJEuN/8lEy0iG
PgNxKErRQCdzNaS1ViCglBqcoWrgDEcCNytjlmL1xmBOjp7PmDLAAt5duOQdWQDu
Wjndbz8OgtEDt4qyaihR5JwmIKHMIZf7Izsht523J6lPLMzM3CA/y4eDA7NFNJ8D
vDneN2im2ZjT9CQsrWsP
=05Ec
-----END PGP SIGNATURE-----

--HdZAANC5GEQnh8Bp--
