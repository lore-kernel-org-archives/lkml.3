Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbaKTXgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:36:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33163 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600AbaKTXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:36:22 -0500
Message-ID: <1416526571.7215.6.camel@decadent.org.uk>
Subject: Re: [PATCH] Revert "staging: sm7xxfb: remove driver"
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Markos Chandras <Markos.Chandras@imgtec.com>
Date: Thu, 20 Nov 2014 23:36:11 +0000
In-Reply-To: <20141120170925.5a435436@gandalf.local.home>
References: <20141120170925.5a435436@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sDr8Exxsg5KLkUUFxplz"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sDr8Exxsg5KLkUUFxplz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-11-20 at 17:09 -0500, Steven Rostedt wrote:
> Someone reported a bug in the function graph tracer for MIPS. As I'm
> still waiting on my USB serial for my Imagination MIPS board, I decided
> to bring my Lemote Yeeloong laptop back up to the latest kernel. This
> is where I noticed that the screen no longer displays anything.
>=20
> I ran a bisect, which came across a staging commit that removed the
> sm7xxfb driver. When I reverted it on a v3.18-rc5 kernel and booted it
> on my Lemote laptop, the display worked again.
>=20
> I then did a search for this commit and found that Debian reverted it
> too. Seems that there's still some Debian users of this laptop. (RMS?)
[...]

I reverted the removal for our 3.16 branch only, as that's going into
the Debian 8 'jessie' release.  It's not included in our 3.17 packages
and won't come back unless someone supports it upstream.  That gives any
interested developers another couple of years to rescue it if they want
it in Debian 9 'stretch'.

Ben.

--=20
Ben Hutchings
Man invented language to satisfy his deep need to complain. - Lily Tomlin

--=-sDr8Exxsg5KLkUUFxplz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVG566+e/yOyVhhEJAQor0hAApXKd7oDBc47uypiP1e8ZRQv+9AiCEMKt
2gk8Z3cL47beWSPUb06Fm/q5q1VeXRBffg87mJ9/bGytLIpebhteXz5oS/SJj1Ka
mNQFNkUqCfhlMGJ31lr/EosiNSgfA478kbuTVSpcEIvRGW5LyCoL8wJumLCnD52M
MQ2rtgNohcvJUpSe4l7eDXSjEOmbJWGI51BnRWhk3Zd452EFknTtvkvVvOfix1Sc
hCvgIltgunLIQwi/AIbDHllWrdJ3pXmWcx9lza8FB0tvBJlHFfx4uSq/mzQQDfkv
pMGS7+xfhzsYxKZlyNmY6Evy2825SWvu5Tdk254gVQBPo031BM2MEi/7OMFnFQRZ
1bXSVzuJyO/TG/kyYM1eer74Pgys37U+1ODkSvdQS9l271zFdox5KF3rwUo4dB2W
V7VubjWUzM06iW0e5+46zgImoqpuBK+mg8zhsZHbsy5l4ghF2RTwoWPOpz8NtEGD
lQmagJ/ax9gBr5OGFoB+YzvRmP26Tmq7FgAru/cRayN0wXwCrIJk0KlQi70gX9XF
Ku6ZNXlh3kz1U5SFW+wucrxWnk6p8YseShIvUAqvvqWe/NO1DtYxNUNeMsA0dsc8
jLk+6cGrlbCiboGzOADqAR/N+ZCCt3syjOSriEAxN41i6+Q6sYH35PMaf1Q5DpzD
zvcQ3Jxo+JM=
=L5/d
-----END PGP SIGNATURE-----

--=-sDr8Exxsg5KLkUUFxplz--
