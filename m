Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3IIRTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:19:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34385 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3IIRTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:19:51 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
In-Reply-To: Your message of "Mon, 09 Sep 2013 11:49:34 -0400."
             <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
From: Valdis.Kletnieks@vt.edu
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1378747124_1775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Sep 2013 13:18:44 -0400
Message-ID: <19562.1378747124@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1378747124_1775P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Sep 2013 11:49:34 -0400, Matthew Garrett said:

> So, this is my final attempt at providing the functionality I'm interested
> in without inherently tying it to Secure Boot. There's strong parallels
> between the functionality that I'm interested in and the BSD securelevel
> interface, so here's a trivial implementation.

Although all the individual patches look like sane and reasonable things
to do, I'm not at all convinced that sticking them all under control of one
flag is really the right way to do it.  In particular, there probably needs
to be some re-thinking of the kexec, signed-module, and secure-boot stuff,
as it's still a moving target.

> So, this is my final attempt at providing the functionality I'm interested
> in without inherently tying it to Secure Boot.

You may as well bite the bullet on this one, and tie it together.  Without
Secure Boot, by the time your code runs it's already too late.  That's the
whole point of Secure Boot, after all.

--==_Exmh_1378747124_1775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUi4C8wdmEQWDXROgAQLVEBAAtkNSnNCYkHDRZJYPQGPLfT89WkYWZweL
S36AojErYjA5uRhro8JxWthZ2tt2LoB+1EDwyhPmAVxsr40z48tehtpqfMpzIABN
A+GDtdudo2kB5HS9LzTuO2N9f03Vert1/mbF7th9XfoSde2iQpPap3jYvLS5bkBA
Wn29EsRQ/Er3rN5+TKRbUjNjlZJz8vuqBEh7vwnvV9VCox3L/bmAwYfM22pMrP7j
rQfpyNq0bR7IxJPxapFuB6ispdwgBiHB+XMgJoSi17FGei9BilpSCVVXcEdD+YVJ
dfCQItk9gK7IZ+/M+mHqWgVQI/ISakWD2AKMPtUVa+cXDne9kRYRGC4YifOVvTyA
kpTXBd37RWvInK+l+LAxyOkko3nps0UfuShbA7W19IYqOGbh1aDQ3zAV5gKaP1Xy
qK6Jvmhc4JLMp9v5Gj1zFXHV3+1DyGLciPgYvC3lXgmXsA0duZAx1bE3ovVm9uu8
/nQ1wbFmMzrssMgK2A4vyqqPWMsyzA1IGH/eU6N5Mp7i1HYw4jhthdiD+SPCOG/D
uQh/xMTRk+hqqOxfCqohhyHoKz3SfRni1Ka5xhf8+IU++wgBSDLlS0D8DZU1jfx3
ZPrwJHLsRqkYdgxifRIS+aTgjQY2+7V2jUHGQPV6uShv69JtWw76DAPsWCGcTPT1
zzuXcyuUuTY=
=bWJx
-----END PGP SIGNATURE-----

--==_Exmh_1378747124_1775P--
