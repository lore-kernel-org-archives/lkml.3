Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaEOUtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:49:49 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:59401 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEOUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:49:47 -0400
Date: Thu, 15 May 2014 22:49:42 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Bart Tanghe <bart.tanghe@thomasmore.be>,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, grant.likely@linaro.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
Message-ID: <20140515204941.GB7136@mithrandir>
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
 <5049141.XmehsUeakV@wuerfel>
 <5374C773.6070402@monstr.eu>
 <16896948.U7hTsgDub4@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <16896948.U7hTsgDub4@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 06:30:13PM +0200, Arnd Bergmann wrote:
> On Thursday 15 May 2014 15:56:03 Michal Simek wrote:
> > IP is configurable as is normal for us.
> > You can select IP with just one timer.
> > It means register locations for specific timer are fixed.
> > http://www.xilinx.com/support/documentation/ip_documentation/xps_timer.=
pdf
> >=20
> > timer0 - offset 0x0
> > timer1 - offset 0x10 (doesn't need to be synthesized)
> >=20
> > There is one interrupt for both timers.
> >=20
> > Timers can be as timers (up/down count/ reload with or without IRQs)
> > But then one options is to use both timers and generate PWM signal.
> > From full ip description in DT you can see xlnx,gen0-assert =3D <1>;
> > which can suggest that this IP can output PMW signal.
> > (We can also detect if PWM0 signal is connected just to be sure
> > that PWM can be enabled).
> >=20
> > There is also capture trigger mode where external signal start/stop
> > timer counting.
> >=20
> > It means there are 3 modes - timer, capture and PWM.
> > Timer (clocksource, clockevent) requires specific handling,
> > PWM has own subsystem and not sure if there is any subsystem for
> > capture mode. Is there any?
>=20
> I don't think so. Possibly somewhere in IIO.

I think so too. There was a patch set not so long ago that added PWM
capture support for one of the TI PWM controllers to IIO.

Thierry

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdShlAAoJEN0jrNd/PrOhTpsP/2duLfN2pnqigHWcaFpPF8AK
i1SwvQKEMLE/OYZ9QqFHbpPQLypO1PezbfsCTsqhA4l2Y1fHaTYdT2wdiqQVPn7K
IHGlAg4nXpaw0syKXO+xgsmui7vcSQQGbF8rCWe/vYoj7irMD01pCkiduGHi/yHn
/ovxTTn8eaf0PgLHNKnjFslCMZjywYctaqGY5OUJk80BpyyqgJL+aPPAg4ZIS57B
32A98XgxlZkMoyb96jhsdi/+dLe2u4hAAjqR01aKcZJmuvzzHGsH/LqWvAP6+QCK
PfdkrXlo8TM9itHsq5/xtbmXivH/qLHzSIpuqWexviJ+eqnnv73sHUeVHG2ewMXr
IVhH/UirDpDhZ2ozUf6skdkRnNeBr25zZHvzhdRvu03qnzdVOKaieXFeoigVSwKC
A5tIhpuJl8u8f22axFfElznG5CQ240m/hhDg9tne/bV8pgqP1AjhkjePOS5uGLvJ
Vl+kTafKU5qT0D0BzvDDEpDP0Yk5lG56ByLJqsL9kNhZMOrKX1lmwc00n+FxtP22
A3SszgAoQ7MYylCov/C32OG2ZOikiHh+obGt+J0LQ4ffo8NlYY2uOTAlUvsgkTgp
uzFFrf0cG2D2uGFufFo0zM4Q9TTQqDb2HBSoHseBzRc8VGztzxwogO9L6ZFvVCm4
CXh+J/I+XdxejCKZ74h5
=zIOg
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
