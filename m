Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3EHMdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:33:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58406 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3EHMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:32:59 -0400
Date: Wed, 8 May 2013 13:32:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508123225.GK7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LR9UEBmNK407lwl9"
Content-Disposition: inline
In-Reply-To: <20130508114216.GB29130@balto.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LR9UEBmNK407lwl9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 01:42:16PM +0200, Fabio Baltieri wrote:
> On Wed, May 08, 2013 at 11:51:24AM +0100, Mark Brown wrote:

> > I tend to agree with Lee that this looks like a bad approach - there's a
> > whole bunch of other code in there which I'd guess is probably equally
> > broken but only the pinctrl code is being removed.  Why not just fix it
> > (or better yet simplify all this stuff)?

> Sorry I did not get the subject, are you referring to other broken code
> in the ux500 driver or to pinctrl and shared pins in generals?

I'm saying that if functions like enable_msp() don't work reliably then
removing some but not all of their functionality isn't an obviously good
approach to fixing that.  Why does the other functionality work well but
not this bit?  It sounds like there's some reference counting bug here
is all...

--LR9UEBmNK407lwl9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRikXWAAoJELSic+t+oim9XZwP/2lqobpaImrY6Jxc1tg9GR+2
8bTTu+Wckvz0V5AdnPyX3/Rf+BIgn3ZQLkQOWorm9W9jdb20QFaT5IbSzDyggw9H
8ScjZShjz+gOle1/qn9VNe2o/Hyh++wwbOYyR7Kr7SL6TbDFYLu52szR+VldcByO
lo/16ICzYec1Qq+tGisXXoAWbnJx3BVMnnS/ifuz5xsdLq8VN8cIz6QvLhujiA0T
nB1j+lpJlfAfdsmWpEjzI6cWLQ0mU4USDFKr5Sl0gqeEa31LEdhqYdUUU+7Co8jR
kqJt5K1J7IMn/6yqCskE4YRz4JojYu3FN9D2dSqo5d+mcXQ8YpcGtdJefXyYL3kf
tA7mOaWbxRtbDaHnXekFkvpOhWbyEFGzqiiqWx45Sr4jThND2ja/uIMNc6z8ufp3
asKjTdxSc88sor/P+DO1IZfxHkTJln6Uc93i1v4pVLAeLao0fmKUVaM3OhCYNpBy
TbfhlVB7Cw1kcnBL325/M1rMyYQUJ7h+WtJxErmUfJ+StMlnI23MKZxMKOXxCobr
BBZ8UJF+gfgX8jAie1agHwJd7wkUW9f+mbLxDU20LB83aUY0WoXoYIjp1asmaVJt
OjV0YV6JT/PHiNUhlnqxl8h1yvWY5HJ7ZspnABX6i57Ex1pk9O4g1S+WxEv3Mf5f
Q1qQk7JY035JAmB16cQ5
=g0eS
-----END PGP SIGNATURE-----

--LR9UEBmNK407lwl9--
