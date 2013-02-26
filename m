Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3BZMuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:50:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53218 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab3BZMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:50:11 -0500
Date: Tue, 26 Feb 2013 12:50:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
Message-ID: <20130226125006.GA24796@opensource.wolfsonmicro.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
 <1359978868-28736-6-git-send-email-lee.jones@linaro.org>
 <20130204193737.GU4720@opensource.wolfsonmicro.com>
 <CACRpkdYWZOa=bbJYpG7owxVJXxPq5sx7jHmo5UpRe8pmPGYKMQ@mail.gmail.com>
 <20130205120134.GY4720@opensource.wolfsonmicro.com>
 <20130226094412.GD16685@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20130226094412.GD16685@gmail.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 26, 2013 at 09:44:12AM +0000, Lee Jones wrote:

> Okay, I've just re-read this thread and it appears you're both talking
> about different things.

> Linus is talking about a discussion with Bengt regarding how these
> strange sysclkreq thingies work. When I first read the code they
> appear to be equivalent to GPIO regulators, but in actual fact the
> hardware logic is different on enable/disable. So they probably don't
> belong in regulator code at all.

> Where as, Mark is complaining about how the regulators are initialised
> by lots of magic register writes during init. Although, comments are

I'm actually complaining about both things.

> inserted for each of the values, they're by no means exhaustive and
> aren't really even helpful if you don't have the uber-s3cr3t design
> specification. What he would like to see is that most of this stuff
> being handled by the framework. Some of this stuff is clearly only
> setting voltages and power-states and the like.

Right, it's the voltages and so on - the stuff that's clearly already in
the framework domain.

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLK9nAAoJELSic+t+oim9Zi0P/R9GBhV+GHHMxjqsSOrNAQsN
T4hGoHqOpVuIcN1zxd0WYIVIKhNVTpp5vG46MxAO4iaUvy0iobKZc0V+wOc4IN+B
TT+MtOlEPAc93TqZyq/BPmVKc4UwPjInvM8dh/Kzmnq1TaDbJ8RhENuv8P9PVXXc
msRhmeS1ugtj6toKLejAPIdU6jjP/7sDKgHNtpc5emJXzS3Ln6Nphd7uYzRDEv3Z
bMnWyXAm7SjcYqko06Mmuqal1XYbFtdEl2BkBd7nX92qm0MkH7e2lJesrcc4JGMG
GQTdl7CDvIDpzyIakU3zIGTEMWjJ8VWUEn5bMPllnd5O/lmaGlrbrasc//Ux0Tia
/gZsN3sfDStu+Fv9LB6+CoLL4ULf/RnvCU1BYKY+8GoQsDJ6/wyT6zsxPF8xIeDa
fDr+VvPONqXdGT+Ki8I5ZdoH23O42LCuyPLLDM80KUMZPtYQJowBNX7TJbhCSr12
fvek1w+ox1zBzyjb0DWW2kKYLZ3mecnT7RKu4J9zBdZO0mJw9ZERb9mJijV3GQ/z
QKp4VyUx0oSjCfjdLtr7JWddMak7L8nzisYvcxM2hhmZ2/5rzjCz9q28YUKIN1sQ
+xX1oZWKMu0P5aW7+kCV4oyvnpvLa7B3koEJaB+rmUdpGoFMJWbVgWe2hc3eDGLp
LpUMclgS6KHPWtWlu6AN
=7Y3E
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
