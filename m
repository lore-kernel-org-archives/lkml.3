Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946254Ab3BHKzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:55:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41432 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945909Ab3BHKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:55:42 -0500
Date: Fri, 8 Feb 2013 10:55:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 01/49] regulator: ab8500: Further populate initialisation
 registers
Message-ID: <20130208105539.GF8879@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-2-git-send-email-lee.jones@linaro.org>
 <20130207184549.GA8879@opensource.wolfsonmicro.com>
 <20130208082050.GE7519@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <20130208082050.GE7519@gmail.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 08, 2013 at 08:20:50AM +0000, Lee Jones wrote:
> On Thu, 07 Feb 2013, Mark Brown wrote:

> > I tried to apply this but got conflicts - can you please check what's
> > going on with this vs my topic/ab8500 branch?

> It's almost certainly because you're trying to pull the patches in out
> of order. This _will_ end in conflicts. Any chance you can start from
> 01 and work your way though them. I will fixup any that you don't like
> on the fly.

Just following up on our IRC discussion I think that the issue here is
you're basing on -rc not on the topic branch - the patches are going in
pretty much in order, there's no meaningful reordering going on.  I am
picking things from the start of the several unrelated topics that are
mixed in randomly in the series but there should be no overlap here.

If you just rebase off the topic branch while you do your fixups git
ought to drop the patches for you most of the time.

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFNmPAAoJELSic+t+oim9AiIP/2xFu4SPk5LSeLlr3+RelAoe
1fCWEqOAsFJhda83/12hcrHbGLlIbCjLlybLW7QceWaTymSz8WvjDJoJ1y9GcpC2
Uz9ufY5P68Np/Ie7d9iKCcNOk1AOIRgvuuEkxRIrmf7AlQVF0VAjciJafgvJAWOo
zspFzKxmyw6Z9Dtw6bvuwU+/fF+8KtG8h3wbqyS9w1kthGCVBa92b0oezqRh3gt5
QLmR9wf2Mh7LJh2LI1vnwjX3DTWZtCuwfAT+83uQjXepC7x7HAlUniPwp8MAhMby
6zhGojqKyvZNif69TZbwmJfLlzdwJLOKKkDhrNhT/0m2y8e4rf2R+oE6ki2WRANV
hU7PIiWCqfjrUjQQ+U6Gf9RNYG9POV9tw1MVI9LiAOdw2zGpzYt/Vypn9mNbRBH5
L0ulGRwUVIiRm+tdn5I/TcnhATpko+me9XhmjS5ARINU4w1kDs4U7vY4X5uOKUtQ
NySM7a+G2rwaXV8UrZ60ZwUUFLhCwcp4Spc+JpMTIJvrViEobnhtSevB5WxHO2YN
U2R7uYB57EyXUvnvm+OAwjF5423Y4FOMhrD5/yq4IJTV1NDcXBHwJnK/Egriac+O
dZGedrIYUWttJXHd8rt+ED/Pn1GC/tMFIVg0dbamgjwxTmCPZrWx/M3Vt8fTi03z
y3y0WtlZnMP/Oux48RzF
=mN++
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
