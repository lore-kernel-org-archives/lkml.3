Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3A3Kg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:36:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55063 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953Ab3A3Kgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:36:55 -0500
Date: Wed, 30 Jan 2013 18:36:47 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, software@gaisler.com
Subject: Re: [PATCH] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode
 outside of FSL SOC environments and add a grlib variant normally running on
 sparc
Message-ID: <20130130103645.GB6229@opensource.wolfsonmicro.com>
References: <1356711368-10437-1-git-send-email-andreas@gaisler.com>
 <5108F031.1010005@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <5108F031.1010005@gaisler.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 30, 2013 at 11:04:33AM +0100, Andreas Larsson wrote:
> On 2012-12-28 17:16, Andreas Larsson wrote:

> >This makes the cpu mode of the driver available outside of an FSL SOC
> >and even powerpc environment. This is accomplished by putting things
> >regarding fsl specific code and to cpm specific code within ifdefs.

> Any comments anyone?

> This patch takes "Approach A" discussed and supported in
> http://sourceforge.net/mailarchive/message.php?msg_id=30131080

I don't seem to have been CCed on the patch...

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCPe2AAoJELSic+t+oim901oP/jMbbOG1fdi05cf6t4TBgMlf
/vuo+2o08Vp3w1SSzQMYlF3jbdynjBVqf7aAyp5PcYqPbzfUeOAkj47Ue6nlEH8V
ZVoAUmCCLg2yWr2cmpvQo080/YLJlDWjLkA7s2QPpSHhahAGWVxQWY27KCnzyFhS
QbM7XpwL6aXT062OjDuZEW8FWozj9ZravfE1rder4I3jgXQyelnX8VyCean24iOa
uHjiOWeBQdsNLsUBgTinUoMlfWdrLlvNiYQ+7KXT7aP+//LYAOA5G80Ql+y9HCXS
j40bgJjHHrdXwMkqLLh/OS/LOufvOur+QPF3WXfVyQUlldZIVH8nk8OJWub0igg7
OHZQMPUtIbFEdlC2cOvtKn5CDF5m20IzCcQAKcm4/tmSasDo8nCje0QLg9jsnoYD
NvZc+a5nPbQ+X53DPDbFxgF3J+CDBUgKV51NrJdZvPYfT+gIqHdCXIFyJ/SFDAhn
InjEXaVbFPI+z3e3GC9Bv1h+LDXyaWEBRmsAtvTTG6Dn5wNc5pC6p4mDQQMOfMrH
lCx0XHsd14YxvF9WcUR37HB7mP5lvkufUnQI4EMKVK8CoqzSPwiudwfYHfLp0Spu
I6HJtdm23TXdT8f9mqwe+pE6SvZkS/B6y/02f4Yis3Mi6gx8/9sMhhObGvtBV5NH
HQqF2omuveJLkbby+rL9
=v5UY
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
